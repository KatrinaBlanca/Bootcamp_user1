global class CXE_CP_PortalUserInactivityNotiBatch implements Database.Batchable<sObject>{
    
    
    private Integer nDays;
    public CXE_CP_PortalUserInactivityNotiBatch(Integer xDays){
        nDays = xDays;
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {

        String query = 'SELECT Id,Profile.Name,LastLoginDate,isActive,Email,Contact.IsPersonAccount  FROM user '
            + 'WHERE Profile.Name =\'MERALCO Customer Portal\' AND isActive = TRUE '
            //START CSM-14099 GGrandea 10.27.2017
            +'and LastLoginDate < LAST_N_DAYS:'+nDays;
            //+ 'and (LastLoginDate < LAST_N_DAYS:'+nDays+' OR '
            //+'( LastLoginDate = NULL AND CreatedDate < LAST_N_DAYS:'+nDays+') )';
            //END CSM-14099
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User> scope)
    {
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>query size' + scope.size());
        
        try{
            //START CSM-14099 GGrandea 10.27.2017
            List<User> usersToNotify = new List<User>();
            Set<Id> inactiveUsers = new Set<Id>();
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

            for(User u : scope){  
                if(!usersWithPBSubscribed.contains(u.Id)){
                    usersToNotify.add(u);
                }
            }

            //sendEmailNotification(scope);  
            sendEmailNotification(usersToNotify);  
            //END CSM-14099     
        }catch(Exception ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_BatchInactivityFiveMonths', 'execute', ex.getMessage());
        }
        
    }  
    global void finish(Database.BatchableContext BC)  {}
    
    private static void sendEmailNotification(List<User> inActiveUsers){
        Id orgWide = [SELECT Id from OrgWideEmailAddresS WHERE  Address =: CXE_Constants.ORG_WIDE_EMAIL].Id;
        Id templateIndiv = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMPLATE_ACCTDEACTIVATION_150_DAYS_INDIV].id;
        Id templateBiz = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMPLATE_ACCTDEACTIVATION_150_DAYS_BIZ].id;
        
        List<Messaging.SingleEmailMessage >  myEmails = new List<Messaging.SingleEmailMessage >();
        List<Task> taskList = new List<Task>(); //START END CSM-14795 JFernandez DEC-19-17
        
        for(User userRec : inActiveUsers){
            Messaging.SingleEmailMessage  email = new Messaging.SingleEmailMessage ();
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
            //  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            myEmails.add(email);
            
            //START CSM-14795 JFernandez DEC-19-17
            /*Task taskRec = new Task();
            taskRec.ActivityDate = Date.today();
            taskRec.Notification_Channel__c = CXE_Constants.PORTALUSER_NOTIF_EMAIL;
            taskRec.Notification_Type__c = CXE_Constants.CASE_SERVICE_APPLICATION;
            taskRec.OwnerId = userRec.Account.OwnerId;
            taskRec.Priority = CXE_Constants.TASK_PRIORITY_NORMAL;
            taskRec.Status = CXE_Constants.TASK_STATUS_COMPLETED;
            taskRec.WhatId = userRec.AccountId;
            
            if(userRec.Account.IsPersonAccount == false && userRec.ContactId!=null){
                taskRec.WhoId = userRec.ContactId;
            }
            taskRec.Subject = CXE_Constants.TASK_SUBJECT_PORTAL_DEACTIVATION;
            taskList.add(taskRec);*/
            //END CSM-14795 JFernandez DEC-19-17
            
            //START CSM-14795 JFernandez DEC-20-17
            taskList.add(
                CXE_Utility.taskCreation(
                    Date.today(),
                    CXE_Constants.PORTALUSER_NOTIF_EMAIL,
                    CXE_Constants.CASE_SERVICE_APPLICATION,
                    userRec.Account.OwnerId,
                    CXE_Constants.TASK_PRIORITY_NORMAL,
                    CXE_Constants.TASK_STATUS_COMPLETED,
                    userRec.AccountId,
                    CXE_Constants.TASK_SUBJECT_PORTAL_INACTIVITY, //START/END CSM-14979 RReyes DEC-29-17
                    userRec.ContactId
                )
            );
            //END CSM-14795 JFernandez DEC-20-17
        }
        
        Messaging.sendEmail(myEmails);
        //START CSM-14795 JFernandez DEC-19-17
        if(!taskList.isEmpty()){
            insert taskList;
        }
        //END CSM-14795 JFernandez DEC-19-17
    }
    
    
    
    
    
}