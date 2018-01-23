public with sharing class CXE_CP_SplashPageChangePasswordCtrl {

    @AuraEnabled
    public static String getChangePassword(String initPass , String confirmInitPass){
    	String displayMsg;
        try{

        displayMsg = 'Initial Password : ' + initPass + ' Confirm Initial Password : ' + confirmInitPass;
            
        PageReference pRef = Site.changePassword(initPass, initPass, 'serVER7&');
        Aura.redirect(pRef);
        
        }catch (Exception ex){
            displayMsg = 'error';
            ErrorHandlerException.recordException(null, true, 'CXE_CP_SplashPageChangePasswordCtrl', 'getChangePassword'
                                                  , UserInfo.getUserId() + ' : ' + ex.getMessage());
        }
        return displayMsg;
    }    
}