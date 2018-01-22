public without sharing class SplashPageForgotPasswordController {
    
    @AuraEnabled
    public static String sendMailMethod(String eMail) {
        /*Author: Melvin Corbes
         * Date: Aug-24-2017
         * Description: used to Identify the correct format of email
         * for biz and individual user.
         */       
        string message;
        try{
            User portalUser = [SELECT Id,CXE_ForgotPasswordFlag__c FROM User Where username =:eMail][0];
            portalUser.CXE_ForgotPasswordFlag__c =TRUE;
            // START CSM-14898 LISEN
            portalUser.Reset_Password_Link_Generation__c = Datetime.Now();
            Blob b = Crypto.GenerateAESKey(128);
            String h = EncodingUtil.ConvertTohex(b);
            String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
            portalUser.Reset_Password_Token__c = guid;
            // END LISEN
            update portalUser;
            message = 'Please check your email for the confirmation link to proceed with your password reset.';
        }
        catch(Exception ex) {
            message = 'Please make sure that you enter the email address that you used to register on Meralco Online.'; //+ ex.getMessage();
            ErrorHandlerException.recordException(null, true, 'SplashPageForgotPasswordController', 'forgotPassword', UserInfo.getUserId() + ' : ' + ex.getMessage());
        }
            
        return message;
        //end Melvin Corbes
    }
    
}