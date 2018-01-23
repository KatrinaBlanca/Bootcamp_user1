//START CSM-15010 RReyes - change to without sharing - guest user can't see details on related account due to sharing
public without sharing class CXE_CP_ServiceEnrollmentTriggerHandler implements TriggerInterface  { 
//END CSM-15010 RReyes - change to without sharing  - guest user can't see details on related account due to sharing 
     public Boolean IsDisabled() {
        //Added trigger control from heirarchy custom setting
        TriggerControl__c caseControl = TriggerControl__c.getInstance();
        return caseControl.Service_Enrollment__c;
    }
    
    public void BeforeInsert(List<SObject> newList) {} 
    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {}
    public void BeforeDelete(Map<Id, SObject> oldMap){}
    public void AfterInsert(Map<Id, SObject> newMap){
    
        Map<id, CXE_Service_Enrollment__c> newMaps = (Map<id, CXE_Service_Enrollment__c>)newMap;

        enrollServices(newMaps.values(), null ); // Lisen CSM-14049 20171022
        handleBillPrintModeUpdate(newMaps.values(), null); //CSM-12877 GGrandea 09.22.2017

        //Start of CSM-14807 Von Pernicia 12-29-2017
        portalAddDeleteSIN(newMaps.values(), null, false);
        //End of CSM-14807 Von Pernicia 12-29-2017
    }

    public void AfterDelete(Map<Id, SObject> oldMap){}
    public void AfterUndelete(Map<Id, SObject> oldMap){}   
    
    public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) 
    {
        Map<id, CXE_Service_Enrollment__c> oldMaps = (Map<id, CXE_Service_Enrollment__c>)oldMap; //Corbes Melvin Sept-4-2017
        Map<id, CXE_Service_Enrollment__c> newMaps = (Map<id, CXE_Service_Enrollment__c>)newMap;
        enrollServices(newMaps.values(),oldMaps);

        handleBillPrintModeUpdate(newMaps.values(), oldMaps); //CSM-12877 GGrandea 09.22.2017

        //Start of CSM-14807 Von Pernicia 12-29-2017
        portalAddDeleteSIN(newMaps.values(), oldMaps, true);
        //End of CSM-14807 Von Pernicia 12-29-2017
    }


    /* Author: Melvin Corbes 
    *  Aug-3-2017
    */
    public static void  enrollServices(List<CXE_Service_Enrollment__c> serviceEnrolled,Map<Id, CXE_Service_Enrollment__c> oldMap){
        
        List<CXE_Service_Enrollment__c> enrollService = new List<CXE_Service_Enrollment__c>();
        List<CXE_Service_Enrollment__c> finalServiceEnroll = new List<CXE_Service_Enrollment__c>();
        
        Integer proceed =0;
        Set<Id> serviceEnrolledId = new Set<Id>();  
        Set<Id> contractId = new Set<Id>(); 
        Set<Id> portalUserId = new Set<Id>();   
        
        
        //validate if the  new Map record =Payor  and CXE_isActive  =True
        for(CXE_Service_Enrollment__c validateStatus :serviceEnrolled)  {
            
            // START Lisen CSM-14049 20171022
            if(oldMap == null){
                // NEW TRIGGER
                if(validateStatus.CXE_Type__c == CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR && validateStatus.CXE_IsActive__c== TRUE){
                    proceed=1;
                    serviceEnrolledId.add(validateStatus.CXE_ServiceId__c);
                    portalUserId.add(validateStatus.CXE_UserId__c);
                }
            }else{
                // UPDATE TRIGGER
                //Description: Use old and New Map to compare values
            //CSM-13005 Updated the condition to be not included once the unerolled batch run !10-09-2017 Melvin Corbes
                if(validateStatus.CXE_Type__c == CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR 
                   && oldMap.get(validateStatus.Id).CXE_Type__c != CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR 
                     && validateStatus.CXE_IsActive__c== TRUE){
                       
                       proceed=1;
                       serviceEnrolledId.add(validateStatus.CXE_ServiceId__c);
                       portalUserId.add(validateStatus.CXE_UserId__c);
                       
                }
            }
            // END Lisen CSM-14049 20171022            
        }

        //If Validation Passed Proceed to the Process of Auto Enrollment
         if(proceed ==1){
             
             //From the Service Record Provided Search for it original record from Agreement__c to get the Contract of Each Services
             List<Agreement__c> serviceList =[SELECT Id,Payor__r.Id,SIN__c FROM AGREEMENT__C
                                              WHERE Id IN:serviceEnrolledId AND Active_Agreement__c =TRUE]; // LISEN CSM-14049 20171022 : Use Payor instead of Contract
             
             //CReate a Set of ContractIds from the above query
             for(Agreement__c contractIds : serviceList){              
                 contractId.add(contractIds.Payor__r.Id); // LISEN CSM-14049 20171022 : Use Payor instead of Contract
             }
             
             // Get the related service Record  based on the contract Id        
             List<Agreement__c> serviceRec = [SELECT Id,Payor__r.Id,SIN__c FROM AGREEMENT__C
                                                      WHERE Payor__r.Id IN:contractId AND Active_Agreement__c =TRUE]; // LISEN CSM-14049 20171022 : Use Payor instead of Contract
             
             // To get the User   find it on the   Service Enrollment based on the Service ID of the NEw MAP       
             List<CXE_Service_Enrollment__c> userReceiver = [SELECT CXE_UserId__c,CXE_ServiceId__c FROM CXE_Service_Enrollment__c 
                                                               WHERE CXE_ServiceId__c IN:serviceEnrolledId];
                     
                     
             //Create a map that will hold of the existing Record from the Service Enrollment to avoid to avoid duplicates
             Map<Id,String> userIdHolder = new Map<Id,String>();
                 for(CXE_Service_Enrollment__c userIds: userReceiver){
                     userIdHolder.put(userIds.CXE_ServiceId__c,userIds.CXE_UserId__c);
                 }
                        

             //Validate if the new Map Record  has  ServiceRec and userReceiver
             if(!serviceRec.isEmpty() && !userReceiver.isEmpty()){
                 //if Passed I have assumed that the related Service Record with the same Contract belongs to the User from the New Map  
                 for(Agreement__c toBeEnrolledService :serviceRec ){

                     CXE_Service_Enrollment__c cxe_se = new CXE_Service_Enrollment__c();
                     cxe_se.CXE_ServiceId__c =toBeEnrolledService.Id;
                     cxe_se.CXE_IsActive__c =TRUE;
                     for (Id setuserId : portalUserId) {
                         cxe_se.CXE_UserId__c =setuserId;
                     }
                     enrollService.add(cxe_se);                                 
                 } 
              }     
             
             
             //Create a Map  for the record of enrollService to determine if the added service with the same user id already exist in Service Enrollment
             Map<Id,String> foundServices = new Map<Id,String>();
             
                 for(CXE_Service_Enrollment__c enrollmentRec : enrollService){
                     foundServices.put(enrollmentRec.CXE_ServiceId__c,enrollmentRec.CXE_UserId__c);
                 }
             //To perform the matching of records I need to query the records From Service Enrollment based on the Service Id of The list Enrolled Sin using the Map foundservice Keyset
             List<CXE_Service_Enrollment__c> enrolledServices =[SELECT CXE_ServiceId__c,CXE_UserId__c,CXE_Type__c 
                                                                FROM  CXE_Service_Enrollment__c 
                                                                WHERE CXE_ServiceId__c IN:foundServices.keySet()];
             //If there is match put it on a map to be used 
             Map<Id,String> duplicateHolder = new Map<Id,String>();
             
             	//Iterate the retrieve records from enrolledServices
                 for(CXE_Service_Enrollment__c checkRec: enrolledServices){
                     
             		//Check if the Service Id exist in enrollService List using foundServices Map
                     if(foundServices.containsKey(checkRec.CXE_ServiceId__c)){
                         //if Passed check if the user id are the same
                         if(foundServices.get(checkRec.CXE_ServiceId__c) == checkRec.CXE_UserId__c){
                             //then add this record as duplicate needs not to be processed during insertion
                             duplicateHolder.put(checkRec.CXE_ServiceId__c,checkRec.CXE_UserId__c);
                         }
                     }
                 }     
			
             
             
             //Ready for Data Insertion Iterate the List of  enrollService
             for(CXE_Service_Enrollment__c enrollmentRec2 : enrollService){
                 
                 //Validate if the Service Id is in DuplicateHolder Mao
                 if(duplicateHolder.containsKey(enrollmentRec2.CXE_ServiceId__c)){
                     //do nothing
                     
                 }else{
                 //If not Means This record not yet Exist on the Service Enrollment Record
                     //Prepare the Single Object Record Data		
                     CXE_Service_Enrollment__c serviceReadyEnroll = new CXE_Service_Enrollment__c();
                     
                     //Assign the Services to the User From New Map
                     for (Id setuserIdf : portalUserId) {
                         serviceReadyEnroll.CXE_UserId__c =setuserIdf;
                     }
                     serviceReadyEnroll.CXE_ServiceId__c =enrollmentRec2.CXE_ServiceId__c;
                     serviceReadyEnroll.CXE_IsActive__c =TRUE;
                     serviceReadyEnroll.CXE_Type__c ='Payor';
                     finalServiceEnroll.add(serviceReadyEnroll);
                 }
             } 
             
             
             try{
                 
                 insert finalServiceEnroll;
                 setToTrueAutoEnrolledServices(portalUserId);
                 
             }catch(DMLException ex){
                 
                  ErrorHandlerException.recordException(null, true, 'CXE_CP_ServiceEnrollmentTriggerHandler', 'Auto Service Enrollments', ex.getMessage());
             }
                    	
             
         }//end of if
        
        
    }

    /* 
    * Description: CSM-12877 Update Bill Print Mode of related Contract when Enrollment records are updated or created
    * Parameters: newList
    * Returns: N/A
    * Author: GGrandea (Accenture)
    * Date Created: SEPT-22-17
    */  
    public static void handleBillPrintModeUpdate(List<CXE_Service_Enrollment__c> enrollments, Map<Id, CXE_Service_Enrollment__c> oldMap){

        Set<Id> enrollIds = new Set<Id>();
        Map<Id, Id> enrolIdContractIdMap = new Map<Id, Id>();

        //filter in new ServiceEnrollments and those with CXE_IsActive__c modified
        for(CXE_Service_Enrollment__c enrol : enrollments){
            if(enrol.CXE_ServiceId__c!=null 
                    && (oldMap==null || enrol.CXE_IsActive__c!=oldMap.get(enrol.Id).CXE_IsActive__c) ){
                enrollIds.add(enrol.Id);
            }
        }

        if(!enrollIds.isEmpty()){
            Set<Id> contractIds = new Set<Id>();
            Set<Id> enrollmentIds = new Set<Id>();
            Set<Id> bpContractIds = new Set<Id>();
            Map<String, String> bpmMap = new Map<String, String>();

            //new list of ServiceEnrollments with Payor(Contract)
            List<CXE_Service_Enrollment__c> newEnrollmentList = 
                            CXE_CP_PortalUtility.retrieveServiceEnrollments(enrollIds); //CSM-12581 10.03.2017

            for(CXE_Service_Enrollment__c enrol : newEnrollmentList){

                //if enrollment is ACTIVE and Contract Bill_Print_Mode__c is PAPER, SET to PAPERPLUS
                if(enrol.CXE_IsActive__c && enrol.CXE_ServiceId__r.Payor__c!=null
                        && (enrol.CXE_ServiceId__r.Payor__r.Bill_Print_Mode__c==CXE_Constants.BPM_PAPER 
                            || enrol.CXE_ServiceId__r.Payor__r.Bill_Print_Mode__c==null) 
                        && !bpContractIds.contains(enrol.CXE_ServiceId__r.Payor__c) ){

                    bpContractIds.add(enrol.CXE_ServiceId__r.Payor__c);
                    bpmMap.put(enrol.CXE_ServiceId__r.Payor__c, CXE_Constants.BPM_PAPERPLUS);
                }

                //if enrollment is INACTIVE and Contract Bill_Print_Mode__c is PAPERPLUS,
                    // check if other ACTIVE enrollments exist under the same Contract before setting to PAPER
                 if(!enrol.CXE_IsActive__c && enrol.CXE_ServiceId__r.Payor__c!=null && enrol.CXE_ServiceId__r.Payor__r.Bill_Print_Mode__c==CXE_Constants.BPM_PAPERPLUS){

                    contractIds.add(enrol.CXE_ServiceId__r.Payor__c);
                    enrollmentIds.add(enrol.Id);
                }
            }

            if(!contractIds.isEmpty()){
                List<CXE_Service_Enrollment__c> otherEnrollmentList = 
                            CXE_CP_PortalUtility.retrieveExistingServiceEnrollmentsOfPayor(contractIds, enrollmentIds); //CSM-12581 10.03.2017

                Set<Id> contractWithActiveEnrollments = new Set<Id>();
                for(CXE_Service_Enrollment__c enrol : otherEnrollmentList){
                    if(enrol.CXE_ServiceId__r.Payor__c!=null){
                        contractWithActiveEnrollments.add(enrol.CXE_ServiceId__r.Payor__c);
                    }
                }

                for(CXE_Service_Enrollment__c enrol : newEnrollmentList){
                    if(enrollmentIds.contains(enrol.Id) && !contractWithActiveEnrollments.contains(enrol.CXE_ServiceId__r.Payor__c)  
                            && !bpContractIds.contains(enrol.CXE_ServiceId__r.Payor__c) ){

                        bpContractIds.add(enrol.CXE_ServiceId__r.Payor__c);
                        bpmMap.put(enrol.CXE_ServiceId__r.Payor__c, CXE_Constants.BPM_PAPER);
                    }
                }
            }
        
            // Invoke BillPrintMode Utility class
            if(!bpContractIds.isEmpty()){
                //START CSM-12954 GGrandea 09.26.2017
                //CaseTriggerHandler.relateServiceAddress(bpContractIds, bpmMap);
                //START CSM-13009 GGrandea 09.27.2017 - invoke relateServiceAddress() if current transaction is non-batch or non-future
                if( !System.IsBatch() && !System.isFuture() ){ 
                    CXE_CP_BillPrintModeIntegrationUtility.relateServiceAddress(bpContractIds, bpmMap);
                }
                //END CSM-13009 GGrandea 09.27.2017
                //END CSM-12954 GGrandea 09.26.2017
            }
        }

    }
    
    //CSM-14173
    //Corbes Melvin
    //10-30-2017
    @future
    public static void setToTrueAutoEnrolledServices(Set<Id> userIds)
    {   
        List<User> usersList =[SELECT Id, CXE_Auto_Enrolled_Services__c 
                               FROM USER
                               WHERE Id IN: userIds];
        
        for(User userRec : usersList){  
            userRec.CXE_Auto_Enrolled_Services__c = True;  
        }
        
        update usersList;

    }
    //END of CSM-14173

    //Start of R2C CSM-14807 Von Pernicia 12-29-2017
    public void portalAddDeleteSIN(List<CXE_Service_Enrollment__c> newSEList, Map<Id, CXE_Service_Enrollment__c> oldSeMap, Boolean isUpdate){
        
        if (!newSEList.isEmpty())
        {
            String taskSubject;
            Id emailTemplateId;

            Id emailTemplateIdforCaseCreate;
            
            String currentUserId = UserInfo.getUserId();
            Map<Id, CXE_Service_Enrollment__c> mapSE = new Map<Id, CXE_Service_Enrollment__c>();
            List<Messaging.SingleEmailMessage> myEmails = new List<Messaging.SingleEmailMessage>();
            List<Task> listTaskToCreate = new List<task>();
            Id orgWide = [SELECT Id from OrgWideEmailAddress WHERE  Address =: CXE_Constants.ORG_WIDE_EMAIL].Id;

            // Assign Email Id
            Id emailTemplateIdAddSinIndv;
            Id emailTemplateIdAddSinBiz;
            Id emailTemplateIdDeleteSinIndv;
            Id emailTemplateIdDeleteSinBiz;

            // Assign Email Subject
            String emailTemplateSubjectAddSinIndv;
            String emailTemplateSubjectAddSinBiz;
            String emailTemplateSubjectDeleteSinIndv;
            String emailTemplateSubjectDeleteSinBiz;

            List<String> listEmailTemplate = new List<String>{CXE_Constants.EMAIL_TEMP_ADD_SIN_INDV, 
                                                    CXE_Constants.EMAIL_TEMP_ADD_SIN_BIZ,
                                                    CXE_Constants.EMAIL_TEMP_DELETE_SIN_INDV,
                                                    CXE_Constants.EMAIL_TEMP_DELETE_SIN_BIZ}; 
            
            for (EmailTemplate et: CXE_Utility.emailTemplateQuery(listEmailTemplate))
            {
                if (et.Developername == CXE_Constants.EMAIL_TEMP_ADD_SIN_INDV)
                {
                    emailTemplateIdAddSinIndv = et.Id;
                    emailTemplateSubjectAddSinIndv = et.Subject;
                }
                else if (et.Developername == CXE_Constants.EMAIL_TEMP_ADD_SIN_BIZ)
                {
                    emailTemplateIdAddSinBiz = et.Id;
                    emailTemplateSubjectAddSinBiz = et.Subject;
                }
                else if (et.Developername == CXE_Constants.EMAIL_TEMP_DELETE_SIN_INDV)
                {
                    emailTemplateIdDeleteSinIndv = et.Id;
                    emailTemplateSubjectDeleteSinIndv = et.Subject;
                }
                else if (et.Developername == CXE_Constants.EMAIL_TEMP_DELETE_SIN_BIZ)
                {
                    emailTemplateIdDeleteSinBiz = et.Id;
                    emailTemplateSubjectDeleteSinBiz = et.Subject;
                }
            }

            for (CXE_Service_Enrollment__c se: [Select Id, CXE_UserId__r.Email, 
                                                CXE_UserId__r.ContactId ,
                                                CXE_UserId__r.IsActive,
                                                CXE_ServiceId__r.Account__c, 
                                                CXE_ServiceId__r.Account__r.OwnerId,
                                                CXE_ServiceId__r.Payor__r.Account.PersonContactId,
                                                CXE_ServiceId__r.Payor__r.Account.IsPersonAccount,
                                                CreatedBy.UserType
                                                from CXE_Service_Enrollment__c 
                                                Where Id in:newSEList])
            {
                mapSE.put(se.Id, se);
            } 

            for (CXE_Service_Enrollment__c se: newSEList){
                
                String[] userEmailAdd = new String[]{ mapSE.get(se.Id).CXE_UserId__r.Email };

                if (!isUpdate) 
                {
                    if (String.isBlank(mapSE.get(se.Id).CXE_ServiceId__r.Payor__r.Account.PersonContactId) &&
                        se.CXE_IsActive__c && 
                        mapSE.get(se.Id).CXE_ServiceId__r.Payor__r.Account.IsPersonAccount &&
                        mapSE.get(se.Id).CreatedBy.UserType == 'CspLitePortal')
                    {
                        // Send Email Add SIN Indv
                        emailTemplateId = emailTemplateIdAddSinIndv;
                        taskSubject = emailTemplateSubjectAddSinIndv;
                        
                    }
                    else if (se.CXE_IsActive__c &&
                       // String.isBlank(mapSE.get(se.Id).CXE_ServiceId__r.Payor__r.Account.PersonContactId) &&
                        !mapSE.get(se.Id).CXE_ServiceId__r.Payor__r.Account.IsPersonAccount &&
                        !se.CXE_CreatedforRegistration__c)
                    {
                        // Send Email ADD SIN BIZ
                        emailTemplateId = emailTemplateIdAddSinBiz;
                        taskSubject = emailTemplateSubjectAddSinBiz;
                    }
                    /*else if (se.CXE_IsActive__c &&
                        !String.isBlank(mapSE.get(se.Id).CXE_ServiceId__r.Payor__r.Account.PersonContactId) &&
                        !mapSE.get(se.Id).CXE_ServiceId__r.Payor__r.Account.IsPersonAccount &&
                        !se.CXE_CreatedforRegistration__c)
                    {
                        // Send Email ADD SIN BIZ
                        emailTemplateId = emailTemplateIdAddSinBiz;
                        taskSubject = emailTemplateSubjectAddSinBiz;
                    }*/
                }
                else
                {
                    if (mapSE.get(se.Id).CXE_ServiceId__r.Payor__r.Account.IsPersonAccount &&
                        !se.CXE_IsActive__c &&
                        oldSeMap.get(se.Id).CXE_IsActive__c &&
                        mapSE.get(se.Id).CXE_UserId__r.IsActive)
                    {
                        // Send Email Delete SIN_INDV
                        emailTemplateId = emailTemplateIdDeleteSinIndv;
                        taskSubject = emailTemplateSubjectDeleteSinIndv;
                    }
                    else if (oldSeMap.get(se.Id).CXE_IsActive__c &&
                        //String.isBlank(mapSE.get(se.Id).CXE_ServiceId__r.Payor__r.Account.PersonContactId) &&
                        !mapSE.get(se.Id).CXE_ServiceId__r.Payor__r.Account.IsPersonAccount &&
                        !se.CXE_IsActive__c && 
                        mapSE.get(se.Id).CXE_UserId__r.IsActive )
                    {
                        // Delete SIN Portal_BIZ w/o contact
                        emailTemplateId = emailTemplateIdDeleteSinBiz;
                        taskSubject = emailTemplateSubjectDeleteSinBiz;
                    }
                    /*else if (oldSeMap.get(se.Id).CXE_IsActive__c &&
                        !String.isBlank(mapSE.get(se.Id).CXE_ServiceId__r.Payor__r.Account.PersonContactId) &&
                        !mapSE.get(se.Id).CXE_ServiceId__r.Payor__r.Account.IsPersonAccount &&
                        !se.CXE_IsActive__c && 
                        mapSE.get(se.Id).CXE_UserId__r.IsActive )
                    {
                        // Delete SIN Portal_BIZ w/ contact
                        emailTemplateId = emailTemplateIdDeleteSinBiz;
                        taskSubject = emailTemplateSubjectDeleteSinBiz;
                    }*/
                }

                if(emailTemplateId!=null){
                    myEmails.add(CXE_Utility.emailNotif(userEmailAdd, false, currentUserId, se.Id, orgWide, emailTemplateId));
                    
                    // Task for Email Registration
                    listTaskToCreate.add(
                        CXE_Utility.taskCreation(
                            Date.today(),
                            CXE_Constants.PORTALUSER_NOTIF_EMAIL,
                            CXE_Constants.CASE_SERVICE_APPLICATION,
                            mapSE.get(se.Id).CXE_ServiceId__r.Account__r.OwnerId,
                            CXE_Constants.TASK_PRIORITY_NORMAL,
                            CXE_Constants.TASK_STATUS_COMPLETED,
                            mapSE.get(se.Id).CXE_ServiceId__r.Account__c,
                            taskSubject,
                            //mapSE.get(se.Id).CXE_ServiceId__r.Payor__r.Account.PersonContactId
                            mapSe.get(se.Id).CXE_UserId__r.ContactId//CSM-14807 John Mark Fernandez 01-04-2018
                        )
                    );
                } 
            }   
            if(!myEmails.isEmpty()){
                Messaging.sendEmail(myEmails);
            }

            if (!listTaskToCreate.isEmpty())
            {
                insert listTaskToCreate;
            }
           
        }
    }
    //End of R2C CSM-14807 Von Pernicia 12-29-2017 
}