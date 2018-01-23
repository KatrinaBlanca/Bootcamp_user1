global class CXE_CP_PortalUserInactivityDeactBatch implements Database.Batchable<sObject>, Queueable{
    
    private List<Task> listTaskToCreate; //START END CSM-14517 JFernandez DEC-12-17
    private Id portalCommProfId = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE].Id;
    private Integer nDays;
    private Integer oDays; //CSM-13881 10.12.2017
    public CXE_CP_PortalUserInactivityDeactBatch(Integer xDays, Integer yDays, List<Task> lstTask){ //CSM-13881 10.12.2017 //START END CSM-14517 JFernandez DEC-12-17 add list<task>
        nDays = xDays;
        oDays = yDays; //CSM-13881 10.12.2017
        this.listTaskToCreate = lstTask; //START END CSM-14517 JFernandez DEC-12-17
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       /* commented out by Melvin Corbes: Aug-8-2017
        String query = 'SELECT Id,Profile.Name,LastLoginDate,isActive,Email  FROM user '
                        + 'WHERE Profile.Name =\'MERALCO Customer Portal\' AND isActive = TRUE '
                        + 'and (LastLoginDate < LAST_N_DAYS:'+nDays+' OR '
                                +'( LastLoginDate = NULL AND CreatedDate < LAST_N_DAYS:'+nDays+') )';
    */
          String query = 'SELECT Id,AccountId,Account.OwnerId,Profile.Name,LastLoginDate,isActive,Email,Contact.IsPersonAccount,CXE_CP_isPortalDeactivated__c,UserArticleSelected__c  FROM user ' //START END CSM-14517 JFernandez DEC-12-17 ADD Fields needed (Account.OwnerId, AccountId)
                        + 'WHERE Profile.Id =:portalCommProfId AND isActive = TRUE '
                        + 'and (LastLoginDate < LAST_N_DAYS:'+nDays+' OR '
                                +'( LastLoginDate = NULL AND CreatedDate < LAST_N_DAYS:'+oDays+') )'; //CSM-13881 10.12.2017
             
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User> scope)
    {
        try{

            //START CSM-14099 GGrandea 10.27.2017
            List<User> usersToUpdate = new List<User>();
            Set<Id> inactiveUsers = new Set<Id>();
            List<Id> userIds = new List<Id>(); //START END CSM-14517 JFernandez DEC-11-17
            for(User u : scope){
                inactiveUsers.add(u.Id);
            }

            //get Payor Users that are subscribed to Paperless Billing
            List<CXE_Service_Enrollment__c> 
                        withPBSubscribed = [SELECT Id,
                                                    CXE_UserId__c 
                                                FROM CXE_Service_Enrollment__c
                                             WHERE CXE_IsActive__c = true
                                              AND CXE_UserId__c in :inactiveUsers
                                              AND CXE_Type__c =: CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR 
                                              AND CXE_ServiceId__r.Payor__r.Bill_Print_Mode__c =: CXE_Constants.BPM_PAPERLESS ];

            Set<Id> usersWithPBSubscribed = new Set<Id>();
            for(CXE_Service_Enrollment__c enroll: withPBSubscribed){
                usersWithPBSubscribed.add(enroll.CXE_UserId__c);
            }
            //END CSM-14099

            for(User u : scope){  
                u.IsActive = False;
                u.CXE_CP_isPortalDeactivated__c =TRUE;
                //START CSM-13900 GGrandea 10.13.2017
                if(u.LastLoginDate==null){
                    u.UserArticleSelected__c ='Verification link expired after ' + oDays + ' days';
                }else{
                    u.UserArticleSelected__c ='Portal Inactivity of six Months';
                }
                //END CSM-13900

                //START CSM-14099 GGrandea 10.27.2017
                if(!usersWithPBSubscribed.contains(u.Id)){
                    usersToUpdate.add(u);
                }
                //END CSM-14099
                userIds.add(u.Id); //START END CSM-14517 JFernandez DEC-11-17
            }
            
            //START CSM-14099 GGrandea 10.27.2017
            //update scope;
            update usersToUpdate;
            //sendEmailNotification(scope);
            sendEmailNotification(usersToUpdate);
            createTask(userIds); //START END CSM-14517 JFernandez DEC-11-17
            //END CSM-14099
        
        }catch(Exception ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_BatchInactivitySixMonths', 'execute', ex.getMessage());
        }
        
    }

    global void finish(Database.BatchableContext BC) {
        
        //START CSM-14098 Corbes Melvin - chain batch
        //CXE_CP_UnEnrollServiceBatch b  = new CXE_CP_UnEnrollServiceBatch();
        //Database.executebatch(b,200);
		//END CSM-14098 Corbes Melvin - chain batch
    }
    
    
    private static void sendEmailNotification(List<User> inActiveUsers){
        Id orgWide = [SELECT Id from OrgWideEmailAddresS WHERE  Address =: CXE_Constants.ORG_WIDE_EMAIL].Id;
        Id templateIndiv = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMPLATE_180_DAYS_INACTIVITY_INDIV].id;
        Id templateBiz = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMPLATE_180_DAYS_INACTIVITY_BIZ].id;

        List<Messaging.SingleEmailMessage >  myEmails = new List<Messaging.SingleEmailMessage >();
        
        List<Task> listTaskToCreate = new List<Task>();
        for(User userRec : inActiveUsers){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String[] addresses = new String[]{userRec.Email};    
            email.setToAddresses(addresses);
            // Who you are sending the email to
            email.setSaveAsActivity(false);
            email.setTargetObjectId(userRec.Id);
            email.setWhatId(userRec.Id); //Your Record Id if applicable
            email.setorgWideEmailAddressId(orgWide);
            if(userRec.Contact.IsPersonAccount == True){
                email.setTemplateId(templateIndiv);
            }else if(userRec.Contact.IsPersonAccount == False){
                email.setTemplateId(templateBiz);
            }
            
            // Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            myEmails.add(email);
            
        }
        Messaging.sendEmail(myEmails);
        
        //insert listTaskToCreate;
        
    }
    
    //START CSM-14517 JFernandez DEC-12-17
    public void createTask(List<Id> userId){
        
        if (!userId.isEmpty())
        {
            system.debug('CREATE TASK');
            List<Task> lstTask = new List<Task>();
            for(User u: [Select Id, 
                         AccountId,
                         Account.OwnerId,
                         Email,
                         isActive,
                         CXE_CP_isPortalDeactivated__c,
                         Contact.IsPersonAccount,
                         ContactId,
                         Contact.OwnerId,
                         Account.IsPersonAccount //START CSM-14807 JFernandez DEC-13-17 Add fields ContactId, Contact.OwnerId, Account.IsPersonAccount
                         from User
                         Where Id in:userId])
            {
                if(u.AccountId!=null){ //START END CSM-14807 JFernandez DEC-14-17 Add Validation for AccountId
                    //START CSM-14795 JFernandez DEC-20-17
                    lstTask.add(
                        CXE_Utility.taskCreation(
                            Date.today(),
                            CXE_Constants.PORTALUSER_NOTIF_EMAIL,
                            CXE_Constants.CASE_SERVICE_APPLICATION,
                            u.Account.OwnerId,
                            CXE_Constants.TASK_PRIORITY_NORMAL,
                            CXE_Constants.TASK_STATUS_COMPLETED,
                            u.AccountId,
                            CXE_Constants.TASK_SUBJECT_PORTAL_DEACTIVATION,
                            u.ContactId
                        )
                    );
                    //END CSM-14795 JFernandez DEC-20-17
                } //START END CSM-14807 JFernandez DEC-13-17 Add closing tag for the if condition
            }
            
            system.debug('lstTask >>>' + lstTask );
            CXE_CP_PortalUserInactivityDeactBatch updateQJob = new CXE_CP_PortalUserInactivityDeactBatch(null, null, lstTask);
            Id jobID = system.enqueueJob(updateQJob);
        }
    }
   
    public void execute(QueueableContext context) {
        system.debug('this.listTaskToCreate >>> ' + this.listTaskToCreate);
        try {
            insert this.listTaskToCreate;
        } catch (Exception e) {}

        
    }
     //END CSM-14517 JFernandez DEC-12-17

}