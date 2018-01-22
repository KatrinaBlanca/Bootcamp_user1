public with sharing class CXE_CP_MyProfileTab3 {
    
    @AuraEnabled
    public static String ChangePasswordController(String oldpassword, String newPassword, String verifyNewPassword){
       
     String returnValue;
        
     try{
           
         Site.changePassword(newPassword, verifyNewPassword, oldpassword);
         User portalUser = [SELECT Id,CXE_ChangePasswordSuccessFlag__c FROM User Where Id =: UserInfo.getUserId()];
         portalUser.CXE_ChangePasswordSuccessFlag__c =True;
         update portalUser;
         returnValue = 'SUCCESS';}catch(Exception e){returnValue = ''+ e.getMessage();
        }
         return returnValue;
    }        
        
    
}