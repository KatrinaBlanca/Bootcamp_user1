/*Author : Melvin Corbes
*Description: Will Send Notification Email To portal Users that the sole service was terminated
*/
global class CXE_CP_LastEnrolledServiceNotiBatch  implements Database.Batchable<sObject>{
    
    private Id portalCommProfId = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE].Id;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       
        String query = 'SELECT Id,CXE_ServiceId__c,CXE_UserId__c,CXE_UserId__r.Email,CXE_UserId__r.FirstName '
            + 'FROM CXE_Service_Enrollment__c WHERE CXE_UserId__r.Profile.Id =:portalCommProfId '
            + 'AND CXE_SERVICEID__r.Agreement_End_Date__c = TODAY  '
            + 'AND CXE_isLastEnrolledService__c =False '
            + 'AND CXE_UserId__r.isActive =True '; 
        
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<CXE_Service_Enrollment__c> scope)
    {
        try{
            //CSM-12195 
            Set<Id> userId = new Set<Id>();
            Map<Id,CXE_Service_Enrollment__c> portalUsers = new Map<Id,CXE_Service_Enrollment__c>();
            
            for(CXE_Service_Enrollment__c cseRec : scope){ 
                userId.add(cseRec.CXE_UserId__c);
                portalUsers.put(cseRec.CXE_UserId__c,cseRec);
            }
            
            //get all terminated service enrollments
            List<CXE_Service_Enrollment__c>  terminatedActiveSin = [SELECT Id,CXE_ServiceId__c,CXE_UserId__c,CXE_ServiceTerminated__c,
                                                                    CXE_UserId__r.Contact.isPersonAccount
                                                                    FROM CXE_Service_Enrollment__c 
                                                                    WHERE CXE_IsActive__c =true
                                                                    AND CXE_UserId__c IN:userId];
            
            Map<Id,Boolean> userWhoLastEnrolled  = new Map<Id,Boolean>(); //holder of user that all services are terminated 
            Set<Id> userNoMoreEnrollments = new Set<Id>(); // holder of user that has no more enrolled service
            Set<Id> userHasEnrolledSin = new Set<Id>(); //holder of user that still have active sins
            
            for(CXE_Service_Enrollment__c serviceRec : terminatedActiveSin){
                
                userNoMoreEnrollments.add(serviceRec.CXE_UserId__c);
                
                if(serviceRec.CXE_ServiceTerminated__c ==True){
                    userWhoLastEnrolled.put(serviceRec.CXE_UserId__c,serviceRec.CXE_ServiceTerminated__c);                 
                }else{
                    userHasEnrolledSin.add(serviceRec.CXE_UserId__c);
                }
                
            }
            
            Set<ID> notifyPortalUser = new Set<ID>();// Portal users where all  service  are terminated
            Set<ID> portalUserTerminateAService = new Set<ID>(); // portal users who have terminated single service and have active sins
            // process the comparing if user has all terminated services or not
            for ( ID portalUserID : userWhoLastEnrolled.keySet()){
                
                
                if(!userHasEnrolledSin.contains(portalUserID)){
                    notifyPortalUser.add(portalUserID);
                }else{
                    portalUserTerminateAService.add(portalUserID);
                }
                
            }
            
            //send email to user where all services are terminated 
            if( notifyPortalUser.size() !=0 ){
                
                NotifyUserPortalDeactivation(notifyPortalUser, CXE_Constants.EMAIL_TEMPLATE_ALL_ENROLLED_SERVICE_TERMINATED,
                                             CXE_Constants.EMAIL_TEMPLATE_ALL_ENROLLED_SERVICE_TERMINATED_BIZ,portalCommProfId);
                
            }
            //send email to user where services has just been terminated
            /*Melvin Corbes
             * 10-13-17
             * It was commented No email Portal User will receive upon termination of Service
             * According to Migo Oabel
            if(portalUserTerminateAService.size() !=0){
                
                NotifyUserServiceTerminated(portalUserTerminateAService, CXE_Constants.EMAIL_TEMPLATE_SERVICE_TERMINATED_INDIV,
                                            CXE_Constants.EMAIL_TEMPLATE_SERVICE_TERMINATED_BIZ,portalCommProfId);
                
                
            }
              
			*/
              	/* Commented out October 10,2017
            * Melvin Corbes
            * This functionality checks for All services Unenrolled.
            // if the user in terminated id is not present in the scope expected ko n 
            // lahat ng  services niya is unenrolled
            
            Set<Id> portalUserAllServicesUnenrolled = new Set<ID>();
            for ( ID portalUserID : portalUsers.keySet()){
            
            if(!userNoMoreEnrollments.contains(portalUserID)){
            portalUserAllServicesUnenrolled.add(portalUserID);
            }
            }
            
            
            if(portalUserAllServicesUnenrolled.size() !=0){               
            filterPortalUserSendEmail(portalUserAllServicesUnenrolled);
            } 
            */
                        
                        //end of CSM-12195
                        //if zero results is send email unerolled sins
                        
                        /*
            //List<CXE_Service_Enrollment__c> EnrolledSin = new List<CXE_Service_Enrollment__c>();
            Set<Id> userId = new Set<Id>();
            List<User> userList = new List<User>();
            
            for(CXE_Service_Enrollment__c cseRec : scope){ 
            userId.add(cseRec.CXE_UserId__c);
            }
            
            // get record for active enrollments
            List<CXE_Service_Enrollment__c>  EnrolledActiveSin = [SELECT Id,CXE_ServiceId__c,CXE_UserId__c
            FROM CXE_Service_Enrollment__c 
            WHERE CXE_IsActive__c =true AND CXE_UserId__c IN:userId];
            
            Set<Id> stillActiveIds = new Set<Id>();
            for(CXE_Service_Enrollment__c enroll : EnrolledActiveSin){
            stillActiveIds.add(enroll.CXE_UserId__c);
            System.debug('Active Sins'+ enroll.CXE_UserId__c);
            
            }
            
            Set<Id> finalIds = new Set<Id>();
            for(CXE_Service_Enrollment__c cseRec : scope){ 
            if(!stillActiveIds.contains(cseRec.CXE_UserId__c)){
            finalIds.add(cseRec.CXE_UserId__c);
            }
            }
            
            //query the users;
            List<User> finalUser = [SELECT Id,Email 
            FROM USER WHERE Id IN:finalIds];
            
            
            
            if(!finalUser.isEmpty()){
            sendEmailNotification(finalUser);
            }
            */
            
        }catch(Exception ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_LastEnrolledServiceNotiBatch', 'execute', ex.getMessage()+ex.getStackTraceString());
        }
        
        
    }  
    
    global void finish(Database.BatchableContext BC){}
    
    
    
    
    public static void sendEmailNotification(List<User> inActiveUsers,String indivTemplate, String bizTemplate,Map<Id,Set<String>> serviceEnrollmentId){
        Id orgWide = [SELECT Id from OrgWideEmailAddresS WHERE  Address =: CXE_Constants.ORG_WIDE_EMAIL].Id;
        Id templateIndiv = [SELECT Id FROM EmailTemplate WHERE developername =:indivTemplate].id;
        Id templateBiz = [SELECT Id FROM EmailTemplate WHERE developername =:bizTemplate].id;
        List<Messaging.SingleEmailMessage >  myEmails = new List<Messaging.SingleEmailMessage >();
        List<Task> taskList = new List<Task>(); //START END CSM-14795 JFernandez DEC-19-17
        
        
        for(User userRec : inActiveUsers){
            
            if(serviceEnrollmentId.containsKey(userRec.Id)) {
                
                 
                for(Id cxeServiceEnrolledId: serviceEnrollmentId.get(userRec.Id)){
                    System.debug('user'+userRec.Id);
                    System.debug('enrollment ID'+cxeServiceEnrolledId);
                    
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    String[] addresses = new String[]{userRec.Email};    
                        email.setToAddresses(addresses);
                    // Who you are sending the email to
                    
                    email.setSaveAsActivity(false);
                    email.setTargetObjectId(userRec.Id);
                    email.setWhatId(cxeServiceEnrolledId); //Your Record Id if applicable
                    email.setorgWideEmailAddressId(orgWide);
                    
                    if(userRec.Contact.IsPersonAccount == true){
                        email.setTemplateId(templateIndiv); 
                    }else if(userRec.Contact.IsPersonAccount == false){
                        email.setTemplateId(templateBiz);
                    }            
                    
                    myEmails.add(email); 
                    //START CSM-14795 JFernandez DEC-19-17
		    /*
                    Task taskRec = new Task();
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
                    taskList.add(
                        CXE_Utility.taskCreation(
                            Date.today(),
                            CXE_Constants.PORTALUSER_NOTIF_EMAIL,
                            CXE_Constants.CASE_SERVICE_APPLICATION,
                            userRec.Account.OwnerId,
                            CXE_Constants.TASK_PRIORITY_NORMAL,
                            CXE_Constants.TASK_STATUS_COMPLETED,
                            userRec.AccountId,
                            CXE_Constants.TASK_SUBJECT_PORTAL_DEACTIVATION,
                            userRec.ContactId
                        )
                    );
                    //END CSM-14795 JFernandez DEC-20-17
                }
                
                
                
            }     
        }
        Messaging.sendEmail(myEmails);
        //START CSM-14795 JFernandez DEC-19-17
        if(!taskList.isEmpty()){
            insert taskList;
        }
        //END CSM-14795 JFernandez DEC-19-17
    }
    
    private static void NotifyUserPortalDeactivation(Set<Id> portalUserId,String indiv, String biz,String portalCommProfId){
        
        List<User> userRec =[SELECT Id,email,Contact.isPersonAccount, Account.OwnerId, AccountId,ContactId, Account.IsPersonAccount //START END CSM-14795 JFernandez DEC-20-17
                             FROM USER
                             WHERE Id IN:portalUserId];
        
        List<CXE_Service_Enrollment__c> updateEnrollments =[SELECT Id,CXE_ServiceId__c,CXE_UserId__c,CXE_UserId__r.Email,CXE_UserId__r.FirstName,
                                                            CXE_isLastEnrolledService__c 
                                                            FROM CXE_Service_Enrollment__c 
                                                            WHERE CXE_UserId__r.Profile.Id =:portalCommProfId
                                                            AND CXE_SERVICEID__r.Agreement_End_Date__c = TODAY 
                                                            AND CXE_isLastEnrolledService__c =False 
                                                            AND CXE_isActive__c =True 
                                                            AND CXE_UserId__c IN:portalUserId];
        
        //create a new Map that will hold the list  of service enrollments
        Map<Id,Set<String>> serviceEnrollmentId = new Map<Id,Set<String>>();			
        
        for(CXE_Service_Enrollment__c enrollRec :updateEnrollments){
            enrollRec.CXE_isLastEnrolledService__c = True;
            
            if(serviceEnrollmentId.containsKey(enrollRec.CXE_UserId__c)) {
                  serviceEnrollmentId.get(enrollRec.CXE_UserId__c).add(enrollRec.Id);
            } else {
                serviceEnrollmentId.put(enrollRec.CXE_UserId__c, new Set<String> {enrollRec.Id});
            }
            
            
        }
        
        update updateEnrollments; 
        sendEmailNotification(userRec,indiv,biz,serviceEnrollmentId);
        
    }
    
    /*
    private static void NotifyUserServiceTerminated(Set<Id> portalUserId,String indiv,String biz,String portalCommProfId){
        
        List<User> userRec =[SELECT Id,email,Contact.isPersonAccount
                             FROM USER
                             WHERE Id IN:portalUserId];
        
        List<CXE_Service_Enrollment__c> updateEnrollments =[SELECT Id,CXE_ServiceId__c,CXE_UserId__c,CXE_UserId__r.Email,CXE_UserId__r.FirstName,
                                                            CXE_isLastEnrolledService__c 
                                                            FROM CXE_Service_Enrollment__c 
                                                            WHERE CXE_UserId__r.Profile.Id =:portalCommProfId
                                                            AND CXE_SERVICEID__r.Agreement_End_Date__c = TODAY 
                                                            AND CXE_isLastEnrolledService__c =False 
                                                            AND CXE_isActive__c =True 
                                                            AND CXE_UserId__c IN:portalUserId];
        
        //create a new Map that will hold the list  of service enrollments
        Map<Id,Set<String>> serviceEnrollmentId = new Map<Id,Set<String>>();			
        
       
        for(CXE_Service_Enrollment__c enrollRec :updateEnrollments){
            enrollRec.CXE_isLastEnrolledService__c = True;
            
            if(serviceEnrollmentId.containsKey(enrollRec.CXE_UserId__c)) {
                  serviceEnrollmentId.get(enrollRec.CXE_UserId__c).add(enrollRec.Id);
            } else {
                serviceEnrollmentId.put(enrollRec.CXE_UserId__c, new Set<String> {enrollRec.Id});
            }
            
            
        }
        
        update updateEnrollments; 
        sendEmailNotification(userRec,indiv,biz,serviceEnrollmentId);
        
        
    }
    */
    
    
}