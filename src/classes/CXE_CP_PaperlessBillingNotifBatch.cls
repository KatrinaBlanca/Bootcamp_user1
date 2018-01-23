/*Author : Gavi Grandea
*Description: 
*/
global class CXE_CP_PaperlessBillingNotifBatch  implements Database.Batchable<sObject>{

    private Set<Id> caseIds;

    public CXE_CP_PaperlessBillingNotifBatch(Set<Id> caseIdSet){
        this.caseIds = caseIdSet;
    }
    
    public CXE_CP_PaperlessBillingNotifBatch(){
        
    }
        
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = '';
        
        if(caseIds != null && caseIds.size() > 0){
            query = 'SELECT Id, Status, Contract__c, Application_Type_Subtype__c, '
                        + ' Contract__r.CXE_PaperlessBIllingCancelEffective__c '
                        + ' ,Account.OwnerId, AccountId, CXE_V10AccountNumber__c, ContactId, Contact.OwnerId, Account.IsPersonAccount' //START/END CSM-14977 RReyes DEC-29-17
                        + ' FROM Case '
                        + ' WHERE Id in :caseIds'; 
        }else{
            query = 'SELECT Id, Status, Contract__c, Application_Type_Subtype__c, '
                        + ' Contract__r.CXE_PaperlessBIllingCancelEffective__c '
                        + ' ,Account.OwnerId, AccountId, CXE_V10AccountNumber__c, ContactId, Contact.OwnerId, Account.IsPersonAccount' //START/END CSM-14977 RReyes DEC-29-17
                        + ' FROM Case '
                        + ' WHERE CXE_Paperless_Email_Notification_Sent__c = \'Not Sent\' AND Record_Type__c = \'CXE_Paperless_Billing\''; // CSM-15092 LISEN
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case> scope)
    {
        try{
            Map<Id, Case> caseMap = new Map<Id, Case>();
            Set<Id> contractIds = new Set<Id>();
            Map<Id, Case> contractIdCaseMap = new Map<Id, Case>();
            
            for(Case caseRecord : scope){
                caseMap.put(caseRecord.Id, caseRecord);
                contractIds.add(caseRecord.Contract__c);
                contractIdCaseMap.put(caseRecord.Contract__c, caseRecord);
            }

            List<CXE_Service_Enrollment__c> enrollmentList = [SELECT Id,
                                                              CXE_UserId__c,
                                                              CXE_ServiceId__r.Payor__c
                                                              FROM CXE_Service_Enrollment__c 
                                                              WHERE CXE_ServiceId__r.Payor__c in: contractIds
                                                              AND CXE_IsActive__c = true 
                                                              AND CXE_Type__c =: CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR];

            if(!enrollmentList.isEmpty()){
                Set<Id> portalUserIds = new Set<Id>();
                Map<Id, Set<Id>> contractIdUserSetMap = new Map<Id, Set<Id>>();

                Set<Id> tempSet;
                for(CXE_Service_Enrollment__c enroll : enrollmentList){
                    if(enroll.CXE_UserId__c!=null){
                        portalUserIds.add(enroll.CXE_UserId__c);                        
                        if(contractIdUserSetMap.containsKey(enroll.CXE_ServiceId__r.Payor__c)){
                            tempSet = contractIdUserSetMap.get(enroll.CXE_ServiceId__r.Payor__c);
                        }else{
                            tempSet = new Set<Id>();
                        }
                        tempSet.add(enroll.CXE_UserId__c);
                        contractIdUserSetMap.put(enroll.CXE_ServiceId__r.Payor__c, tempSet);
                    }
                }

                if(!portalUserIds.isEmpty()){
                    Map<Id, User> userMap = new Map<Id, User>([SELECT Id, 
                                                               Email, 
                                                               Contact.isPersonAccount
                                                               FROM User
                                                               WHERE Id in: portalUserIds]);

                    CXE_CP_PaperlessBillingNotifBatch.sendEmailNotification(userMap, contractIdUserSetMap, contractIdCaseMap);
                }

            }

            // update Case Email Sent status
            for(Case caseRecord : scope){
                caseRecord.CXE_Paperless_Email_Notification_Sent__c = 'Sent';
            }
            
            update scope;
            
        }catch(Exception ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_PaperlessBillingNotifBatch', 'execute', ex.getMessage()+ex.getStackTraceString());
        }
        
        
    }  
    
    global void finish(Database.BatchableContext BC){}
    
    
    
    
    private static void sendEmailNotification(Map<Id, User> userMap, 
                                                Map<Id, Set<Id>> contractIdUserSetMap, 
                                                Map<Id, Case> contractIdCaseMap){

        Id orgWide = [SELECT Id from OrgWideEmailAddresS WHERE  Address =: CXE_Constants.ORG_WIDE_EMAIL].Id;

        Id successSubIndvTempId = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_SUCCESS_PB_SUB_IDV].id;
        Id successSubBizTempId = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_SUCCESS_PB_SUB_BIZ].id;
        Id failedSubIndvTempId = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_FAILED_PB_SUB_IDV].id;
        Id failedSubBizTempId = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_FAILED_PB_SUB_BIZ].id;

        Id successCancelIndvTempId = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_SUCCESS_PB_CANCEL_IDV].id;
        Id successCancelBizTempId = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_SUCCESS_PB_CANCEL_BIZ].id;
        Id failedCancelIndvTempId = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_FAILED_PB_CANCEL_IDV].id;
        Id failedCancelBizTempId = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_FAILED_PB_CANCEL_BIZ].id;

        Id renewalIndvTempId = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_RENEWAL_PB_SUB_IDV].id;
        Id renewalBizTempId = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_RENEWAL_PB_SUB_BIZ].id;
                    
        //START CSM-14795 JFernandez DEC-11-17                                            
        String successSubIndvTempIdSubject = [SELECT Subject FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_SUCCESS_PB_SUB_IDV].Subject;
        String successSubBizTempIdSubject = [SELECT Subject FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_SUCCESS_PB_SUB_BIZ].Subject;
        String failedSubIndvTempIdSubject = [SELECT Subject FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_FAILED_PB_SUB_IDV].Subject;
        String failedSubBizTempIdSubject = [SELECT Subject FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_FAILED_PB_SUB_BIZ].Subject;

        String successCancelIndvTempIdSubject = [SELECT Subject FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_SUCCESS_PB_CANCEL_IDV].Subject;
        String successCancelBizTempIdSubject = [SELECT Subject FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_SUCCESS_PB_CANCEL_BIZ].Subject;
        String failedCancelIndvTempIdSubject = [SELECT Subject FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_FAILED_PB_CANCEL_IDV].Subject;
        String failedCancelBizTempIdSubject = [SELECT Subject FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_FAILED_PB_CANCEL_BIZ].Subject;

        String renewalIndvTempIdSubject = [SELECT Subject FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_RENEWAL_PB_SUB_IDV].Subject;
        String renewalBizTempIdSubject = [SELECT Subject FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_RENEWAL_PB_SUB_BIZ].Subject;
        //END CSM-14795 JFernandez DEC-11-17

        List<Messaging.SingleEmailMessage >  myEmails = new List<Messaging.SingleEmailMessage >();
        
        User tempUser;
        Case tempCase;
        Boolean isIndividual;
        //START CSM-14977 RReyes DEC-29-17
        List<Task> listTaskToCreate = new List<Task>();
        //List<Id> caseIdsToUpdateOwner = new List<Id>(); //START CSM-14795 JFernandez DEC-11-17 EBD
        //END CSM-14977 RReyes DEC-29-17
        String taskSubject; //START CSM-14795 JFernandez DEC-11-17 END
        
        for(Id contractId : contractIdCaseMap.keySet()){

            for(Id userId : contractIdUserSetMap.get(contractId)){
                
                tempCase = contractIdCaseMap.get(contractId);
                tempUser = userMap.get(userId);

                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                String[] addresses = new String[]{tempUser.Email};    
                    email.setToAddresses(addresses);
                
                email.setSaveAsActivity(false);
                email.setTargetObjectId(tempUser.Id);
                email.setWhatId(contractIdCaseMap.get(contractId).Id);
                email.setorgWideEmailAddressId(orgWide);

                isIndividual = tempUser.Contact.IsPersonAccount? TRUE : FALSE;
                
                if(tempCase.Application_Type_Subtype__c==CXE_Constants.CASE_PAPERLESSBILLING_TYPE_SUB){
                    if(tempCase.Status == CXE_Constants.CASE_STATUS_SUCCESSFUL){
                        if(isIndividual){
                            if(tempCase.Contract__r.CXE_PaperlessBIllingCancelEffective__c!=null){
                                email.setTemplateId(renewalIndvTempId);
                                taskSubject = renewalIndvTempIdSubject;
                            }else{
                                email.setTemplateId(successSubIndvTempId);
                                taskSubject = successSubIndvTempIdSubject;
                            }
                        }else{
                            if(tempCase.Contract__r.CXE_PaperlessBIllingCancelEffective__c!=null){
                                email.setTemplateId(renewalBizTempId);
                                taskSubject = renewalBizTempIdSubject;
                            }else{
                                email.setTemplateId(successSubBizTempId);
                                taskSubject = successSubBizTempIdSubject;
                            }
                        }
                    }
                    else if(tempCase.Status == CXE_Constants.CASE_STATUS_REJECTED){
                        if(isIndividual){
                            email.setTemplateId(failedSubIndvTempId); 
                            taskSubject = failedSubIndvTempIdSubject;
                        }else{
                            email.setTemplateId(failedSubBizTempId);
                            taskSubject = failedSubBizTempIdSubject;
                        }
                    }
                }
                
                if(tempCase.Application_Type_Subtype__c==CXE_Constants.CASE_PAPERLESSBILLING_TYPE_CANCEL){
                    if(tempCase.Status == CXE_Constants.CASE_STATUS_SUCCESSFUL){
                        if(isIndividual){
                            email.setTemplateId(successCancelIndvTempId);
                            taskSubject = successCancelIndvTempIdSubject;
                        }else{
                            email.setTemplateId(successCancelBizTempId);
                            taskSubject = successCancelBizTempIdSubject;
                        }
                    }
                    else if(tempCase.Status == CXE_Constants.CASE_STATUS_REJECTED){
                        if(isIndividual){
                            email.setTemplateId(failedCancelIndvTempId);
                            taskSubject = failedCancelIndvTempIdSubject;
                        }else{
                            email.setTemplateId(failedCancelBizTempId);
                            taskSubject = failedCancelBizTempIdSubject;
                        }
                    }
                }

                myEmails.add(email);

                //START CSM-14977 RReyes DEC-29-17 - moved task creation inside the loop
                //caseIdsToUpdateOwner.add(contractIdCaseMap.get(contractId).Id); //START CSM-14795 JFernandez DEC-11-17
                if(tempCase.AccountId!=null){
                    listTaskToCreate.add(
                        CXE_Utility.taskCreation(
                            Date.today(),
                            CXE_Constants.PORTALUSER_NOTIF_EMAIL,
                            CXE_Constants.CASE_SERVICE_APPLICATION,
                            tempCase.Account.OwnerId,
                            CXE_Constants.TASK_PRIORITY_NORMAL,
                            CXE_Constants.TASK_STATUS_COMPLETED,
                            tempCase.AccountId,
                            taskSubject + tempCase.CXE_V10AccountNumber__c,
                            tempCase.ContactId
                        )
                    );
                }
                //END CSM-14977 RReyes DEC-29-17 - moved task creation inside the loop
            }
                
        }

        Messaging.sendEmail(myEmails);
        
        //START CSM-14977 RReyes DEC-29-17 - moved task creation inside the loop above
        if(!listTaskToCreate.isEmpty()){
            insert listTaskToCreate;
        }
        //START CSM-14795 JFernandez DEC-11-17
        /*List<Task> listTaskToCreate = new List<Task>();
        for(Case caseLoop : [SELECT Id, Account.OwnerId, AccountId, CXE_V10AccountNumber__c, ContactId, Contact.OwnerId, Account.IsPersonAccount FROM Case WHERE Id IN : caseIdsToUpdateOwner]){ //START CSM-14807 JFernandez DEC-13-17 Add fields ContactId, Contact.OwnerId, Account.IsPersonAccount
			
            if(caseLoop.AccountId!=null){ //START END CSM-14807 JFernandez DEC-14-17 Add Validation for AccountId
                //START CSM-14795 JFernandez DEC-20-17
                listTaskToCreate.add(
                        CXE_Utility.taskCreation(
                            Date.today(),
                            CXE_Constants.PORTALUSER_NOTIF_EMAIL,
                            CXE_Constants.CASE_SERVICE_APPLICATION,
                            caseLoop.Account.OwnerId,
                            CXE_Constants.TASK_PRIORITY_NORMAL,
                            CXE_Constants.TASK_STATUS_COMPLETED,
                            caseLoop.AccountId,
                            taskSubject + caseLoop.CXE_V10AccountNumber__c,
                            caseLoop.ContactId
                        )
                    );
                //END CSM-14795 JFernandez DEC-20-17
            } //START END CSM-14807 JFernandez DEC-14-17 Add closing tag
        }
        system.debug('listTaskToCreate >>> ' + listTaskToCreate);
        insert listTaskToCreate;
        */
        //END CSM-14517 JFernandez DEC-11-17
        //END CSM-14977 RReyes DEC-29-17 -  - moved task creation inside the loop above
       
	 
      }
    
     
}