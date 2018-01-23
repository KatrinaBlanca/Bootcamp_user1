global class CXE_CP_PortalUserSelfDeactBatch implements Database.Batchable<sObject>, Queueable{ //START END CSM-14517 JFernandez DEC-11-17 ADD Queuable
  
    private List<Task> listTaskToCreate; //START END CSM-14517 JFernandez DEC-11-17
    private Id portalCommProfId = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE].Id;
   
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
    String query = 'SELECT Id,AccountId,Account.OwnerId,Account.IsPersonAccount,ContactId,Contact.OwnerId,Email,isActive,CXE_CP_isPortalDeactivated__c,Contact.IsPersonAccount '  //START END CSM-14517 JFernandez DEC-11-17 ADD Fields needed (Account.OwnerId, AccountId) END
                   +' FROM USER WHERE Profile.Id =:portalCommProfId  AND CXE_CP_isPortalDeactivated__c=TRUE AND isActive =true '; 
      
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User> scope)
    {
        try{
            List<Id> userIds = new List<Id>(); //START END CSM-14517 JFernandez DEC-11-17
            List<User> inActiveUser = new List<User>();
            for(User userRec : scope){
                /* START LISEN CSM-12910 -> remove this block of code, no need to create a new object, just use from the scope
                User u = new User();
                u.isActive =False;
                u.Id =userRec.Id;
                u.Email =userRec.Email;
                END*/
                userRec.isActive =False;
                inActiveUser.add(userRec);
                userIds.add(userRec.Id); //START END CSM-14517 JFernandez DEC-11-17
            }
            
             update inActiveUser;
        	createTask(userIds); //START END CSM-14517 JFernandez DEC-11-17
            sendEmailNotification(inActiveUser);
           
        }catch(Exception ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_PortalUserSelfDeactBatch', 'execute', ex.getMessage());
        }
        
    }  
    
    global void finish(Database.BatchableContext BC){
        //START CSM-13005 GGrandea 09.27.2017 - chain batch
        CXE_CP_UnEnrollServiceBatch b  = new CXE_CP_UnEnrollServiceBatch();
        Database.executebatch(b,200);
        //END CSM-13005 GGrandea 09.27.2017 - chain batch
    }
    
    
    
       
    public static void sendEmailNotification(List<User> inActiveUsers){
        Id orgWide = [SELECT Id from OrgWideEmailAddresS WHERE  Address =: CXE_Constants.ORG_WIDE_EMAIL].Id;
        Id templateIndiv = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMPLATE_SELF_DEACTIVATION_INDIV].id;
        Id templateBiz = [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMPLATE_SELF_DEACTIVATION_BIZ].id;
        
        List<Messaging.SingleEmailMessage >  myEmails = new List<Messaging.SingleEmailMessage >();
        for(User userRec : inActiveUsers){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String[] addresses = new String[]{userRec.Email};    
                email.setToAddresses(addresses);
            // Who you are sending the email to

            email.setSaveAsActivity(false);
            email.setTargetObjectId(userRec.Id);
            email.setWhatId(userRec.Id); //Your Record Id if applicable
            email.setorgWideEmailAddressId(orgWide);

           if(userRec.Contact.IsPersonAccount == true){
                email.setTemplateId(templateIndiv); 
            }else if(userRec.Contact.IsPersonAccount == false){
                email.setTemplateId(templateBiz);
            }
            myEmails.add(email);
        }
            Messaging.sendEmail(myEmails);
        
    }
    
    
    //START CSM-14517 JFernandez DEC-11-17
    public CXE_CP_PortalUserSelfDeactBatch() {}
    
    public CXE_CP_PortalUserSelfDeactBatch(List<Task> lstTask)
    {
        this.listTaskToCreate = lstTask;
    }
    
    public void createTask(List<Id> userId){
        
        if (!userId.isEmpty())
        {
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
		    /*
                    Task taskRec = new Task();
                    taskRec.ActivityDate = Date.today();
                    taskRec.Notification_Channel__c = CXE_Constants.PORTALUSER_NOTIF_EMAIL;
                    taskRec.Notification_Type__c = CXE_Constants.CASE_SERVICE_APPLICATION;
                    taskRec.OwnerId = u.Account.OwnerId;
                    taskRec.Priority = CXE_Constants.TASK_PRIORITY_NORMAL;
                    taskRec.Status = CXE_Constants.TASK_STATUS_COMPLETED;
                    taskRec.WhatId = u.AccountId;
                    //START CSM-14807 JFernandez DEC-14-17
                    if(u.Account.IsPersonAccount == false && u.ContactId!=null){
                    	taskRec.WhoId = u.ContactId;
                    }
                    //END CSM-14807 JFernandez DEC-14-17
                    taskRec.Subject = CXE_Constants.TASK_SUBJECT_PORTAL_DEACTIVATION;
                    lstTask.add(taskRec);
                    */
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
            
            CXE_CP_PortalUserSelfDeactBatch updateQJob = new CXE_CP_PortalUserSelfDeactBatch(lstTask);
            Id jobID = system.enqueueJob(updateQJob);
        }
    }
    //END CSM-14517 JFernandez DEC-11-17

    //START CSM-14517 JFernandez DEC-11-17
    public void execute(QueueableContext context) {		
        insert this.listTaskToCreate;
    }
    //END CSM-14517 JFernandez DEC-11-17
}