public without sharing class CXE_CP_SplashPageResetPasswordCtrl {
    
    @AuraEnabled
    public static String getChangePassword(String initPass , String confirmInitPass, String user_id, String Page,String Action){//String page
        String returnVal;
        String tempMsg;
        String pageValue = Page;
        String actionType = Action;
        ApexPages.PageReference lgn;
        try{
            
            /* Author: Rj Rances			Date: 8/3/2017
            * Description:	Redirect users to a specific page
            * 				if there is a param = page value indicated
            * 				in the URL after clicking the link in the
            * 				email received for reset/set password 
            */
            
            /** start CSM-14898 - JIntal (Added Reset_Password_Token__c in SOQL) [12/27/17] **/
            List<User> GetUserName = [Select UserName,CXE_ChangePasswordSuccessFlag__c,Reset_Password_Token__c
                                      from User where id =: user_id];
            /** end CSM-14898 - JIntal [12/27/17] **/
            System.setPassword(user_id, confirmInitPass); 
            
            
            if(actionType !='Set'){//csm 12874 corbes melvin
            GetUserName[0].CXE_ChangePasswordSuccessFlag__c =True;
            GetUserName[0].Reset_Password_Token__c=null;  //start CSM-14898 - JIntal  [12/27/17]
                update GetUserName[0];
           
            
            } 
            
            if(pageValue!= null && String.isNotEmpty(pageValue)){
                lgn = Site.login(GetUserName[0].UserName,confirmInitPass , OrganizationSettings__c.getInstance().PortalEmailURL__c +'/' + pageValue);
                Aura.redirect(lgn);
                
            } else if (pageValue == null){
                
                lgn = Site.login(GetUserName[0].UserName,confirmInitPass , OrganizationSettings__c.getInstance().PortalEmailURL__c +'/dashboard');
                Aura.redirect(lgn);
            }
            
            
            /* Original Code
            * 
                //displayMsg = 'Initial Password : ' + initPass + ' Confirm Initial Password : ' + confirmInitPass;
                PageReference pRef = Site.changePassword(newPassword, verifyNewPassword, oldPassword);
                Aura.redirect(pRef);
                ApexPages.PageReference lgn = Site.login(GetUserName[0].UserName,confirmInitPass 
                , OrganizationSettings__c.getInstance().PortalEmailURL__c +'/dashboard');
                Aura.redirect(lgn);
                returnVal = GetUserName[0].UserName;
            */
            
        } catch (Exception ex){
            System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ex.getMessage(): ' + ex.getMessage());
            returnVal = ex.getMessage();
            
            /* Author: Joebhelle Rances
            *  Date:   09/18/2017
            *  Description: CSM 12594 - For Password Already Used Notification/Error Message
            */ 
            //if(ex.getMessage().contains(repeatedPass)){
            //    returnVal = 'repeated password';
            //} else {
            //    returnVal = ex.getMessage();
            //}
            //End CSM 12594
            
            ErrorHandlerException.recordException(null, true, 'CXE_CP_SplashPageResetPasswordCtrl', 'getChangePassword', ex.getMessage());
        }
        return returnVal;
    }  
    
    /* 
    * Description: CSM-13900 Verify if verification link is still valid or not
    * Parameters: String user_id
    * Returns: String
    * Author: GGrandea (Accenture)
    * Date Created: OCT-13-17
    */  
    @AuraEnabled
    //START CSM-14898 LISEN
    //public static String verifyPortalUser(String user_id, String action){
    public static String verifyPortalUser(String user_id, String action, String guid){
    //END LISEN
        String retVal = 'valid';
        try{

            // START CSM-14898 LISEN
            User portalUser = [SELECT CXE_CP_isPortalDeactivated__c, 
                                            LastLoginDate, IsActive, 
                                            CreatedDate, Reset_Password_Link_Generation__c, Reset_Password_Token__c
                                         FROM User 
                                        WHERE Id =: user_id LIMIT 1];

            //RJ
            Org_Wide_Fixed_Setting__mdt meta = [SELECT Reset_Pass_Link_Validity__c, Portal_No_Password_Grace_Period__c
                                                FROM Org_Wide_Fixed_Setting__mdt 
                                                WHERE MasterLabel =: CXE_Constants.ALL_STR LIMIT 1];
            
            // validate if origin from Registration set password or Reset password
            if(action == 'Set'){
                
                
                
                //if(portalUser.LastLoginDate != null || portalUser.CreatedDate < Date.Today().addDays(-30)){
                if(portalUser.LastLoginDate != null || portalUser.CreatedDate < Date.Today().addDays(-Integer.valueOf(meta.Portal_No_Password_Grace_Period__c))){
                    retVal = 'expired';
                } else if(portalUser.CXE_CP_isPortalDeactivated__c && !portalUser.IsActive){
                    retVal = 'expired';
                }

                
            } else if(action == 'Reset'){
                if(portalUser.Reset_Password_Token__c != guid){
                    retVal = 'expired';
                }else if(portalUser.Reset_Password_Token__c == guid && portalUser.Reset_Password_Link_Generation__c < Datetime.Now().addHours(-Integer.valueOf(meta.Reset_Pass_Link_Validity__c))){
                 //else if(portalUser.Reset_Password_Token__c == guid && portalUser.Reset_Password_Link_Generation__c < Datetime.Now().addHours(-24)){
                    retVal = 'expired';
                }
            }
            // END CSM-14898

        } catch (Exception ex){
            retVal = ex.getMessage();
            ErrorHandlerException.recordException(null, true, 'CXE_CP_SplashPageResetPasswordCtrl', 'getChangePassword', ex.getMessage());
        }
        return retVal;
    }
    //END CSM-13900
}