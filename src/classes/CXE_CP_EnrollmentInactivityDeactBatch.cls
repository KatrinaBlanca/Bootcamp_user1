global class CXE_CP_EnrollmentInactivityDeactBatch  implements Database.Batchable<sObject>{

    private Id portalCommProfId = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE].Id;
    private Integer nDays;
    public CXE_CP_EnrollmentInactivityDeactBatch(Integer xDays){
        nDays = xDays;
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id,CXE_Unenrollment_Date__c,CXE_ServiceId__c, ' 
            			+' CXE_UserId__c,CXE_UserId__r.Email,CXE_UserId__r.FirstName,CXE_UserId__r.CXE_CP_isPortalDeactivated__c, ' 
                        +' CXE_UserId__r.UserArticleSelected__c	FROM CXE_Service_Enrollment__c ' 
                        +' WHERE CXE_UserId__r.Profile.Id =:portalCommProfId ' 
                        +' AND CXE_IsActive__c =FALSE AND CXE_UserId__r.isActive = true and CXE_Unenrollment_Date__c < LAST_N_DAYS:'+nDays;
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<CXE_Service_Enrollment__c> scope)
    {
        try{
            //List<CXE_Service_Enrollment__c> EnrolledSin = new List<CXE_Service_Enrollment__c>();
            Set<Id> userId = new Set<Id>();
           
            Set<Id> userAcctId = new Set<Id>();
           
            
            for(CXE_Service_Enrollment__c cseRec : scope){ 
                userId.add(cseRec.CXE_UserId__c);
            }
            
            List<CXE_Service_Enrollment__c>  EnrolledActiveSin = [SELECT Id,CXE_ServiceId__c,CXE_UserId__c
                                                          FROM CXE_Service_Enrollment__c 
                                                          WHERE CXE_IsActive__c =true AND CXE_UserId__c IN:userId];
            
            //query for active enrollments with inactive CXE_UserId
            Set<Id> stillActiveIds = new Set<Id>();
            for(CXE_Service_Enrollment__c enroll : EnrolledActiveSin){
                stillActiveIds.add(enroll.CXE_UserId__c);
            }
      
            //check if no more active enrollments
            for(CXE_Service_Enrollment__c cseRec : scope){ 
                if(!stillActiveIds.contains(cseRec.CXE_UserId__c)){
                    userAcctId.add(cseRec.CXE_UserId__c);
                }
            }
           
          
            
            List<User> FinalList =[SELECT Id,Email,Contact.IsPersonAccount,
                                   IsActive,CXE_CP_isPortalDeactivated__c  		
                         		   FROM USER 
                                   WHERE Id IN:userAcctId];
            
            
            if(!FinalList.isEmpty()){
                for(User userRec :FinalList){
                    userRec.IsActive =False;
                    userRec.CXE_CP_isPortalDeactivated__c =TRUE;
                    userRec.UserArticleSelected__c ='Enrollment Inactivity';
                }
                
                update FinalList;
                
              // sendEmailNotification(FinalList); //No email should be sent to the portal user according to BA(Migo)
            }               
        }catch(Exception ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_EnrollmentInactivityDeactBatch', 'execute', ex.getMessage());
        }
        
    }  
    
    global void finish(Database.BatchableContext BC){
        //START CSM-14098 Corbes Melvin - chain batch
        CXE_CP_UnEnrollServiceBatch b  = new CXE_CP_UnEnrollServiceBatch();
        Database.executebatch(b,200);
		//END CSM-14098 Corbes Melvin - chain batch
    }
    
    
    /*
       
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
            if(userRec.Contact.IsPersonAccount == True){
                email.setTemplateId(templateIndiv); 
            }else if(userRec.Contact.IsPersonAccount == False){
                email.setTemplateId(templateBiz);
            }
            // Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            myEmails.add(email);
        }
        Messaging.sendEmail(myEmails);
        
    }
    */
    
}