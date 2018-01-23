public with sharing class CXE_CP_SplashPageLoginForm {
    
    public class Response {
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public String message;
    }

    /* Author: Rj Rances Date: 7/28/2017
     * Description: Declared one parameter (String Page) for redirection to specific page
     *              If page is not empty, redirected to page. Default is dashboard
     */    
    @AuraEnabled
    public static CXE_CP_SplashPageLoginForm.Response getLoginDetails(String LoginDetail 
                                                                      , String PassDetail
                                                                      , String Page
                                                                      , String acctNo
                                                                      , String sinNo
                                                                      , String bpBillDt
                                                                      , String bpinvoiceDate
                                                                      , String bpBillId //CSM-14200 added bpBillId 11.15.2017 //CSM-14664 JRances [R2B WARRANTY] - User is not redirected to the correct page.
                                                                      , String startURL
                                                                     )
    { 
        CXE_CP_SplashPageLoginForm.Response resp = new CXE_CP_SplashPageLoginForm.Response();
        List<User> userList = [SELECT Id, CXE_CP_isPortalDeactivated__c FROM User WHERE UserName =: LoginDetail];
        try{
            ApexPages.PageReference lgn;

            resp.isSuccess = true;
             
             if(!userList.isEmpty() && userList[0].CXE_CP_isPortalDeactivated__c){
                 resp.isSuccess = false;
                 resp.message = 'Your Meralco Online account has been deactivated';
             }else{
                 
                 // START LISEN
                 PassDetail = PassDetail.replace(' ', 'x');
                 // END
                 
                 if(Page != null && String.isNotEmpty(Page)){
                     
                     String billParams = '?';
                     if(String.isNotEmpty(acctNo)){
                         billParams += '&acctNo=' + acctNo; //CSM-13033 added ampersand
                     }
                     if(String.isNotEmpty(sinNo)){
                         billParams += '&sinNo=' + sinNo; //CSM-13033 added ampersand
                     }
                     if(String.isNotEmpty(bpBillDt)){
                         billParams += '&bpBillDt=' + bpBillDt; //CSM-13033 added ampersand
                     }
                     if(String.isNotEmpty(bpinvoiceDate)){
                         billParams += '&bpinvoiceDate=' + bpinvoiceDate; //CSM-13033 added ampersand
                     }
                     
                     //CSM-14664 JRances [R2B WARRANTY] - User is not redirected to the correct page.
                     if(String.isNotEmpty(bpBillId)){ //CSM-14200 added 11.15.2017
                         billParams += '&bpBillId=' + bpBillId; 
                     }
                     //CSM-14664 JRances
                     //if(String.isNotEmpty(acctNo) && String.isNotEmpty(sinNo) && String.isNotEmpty(bpBillDt) && String.isNotEmpty(bpinvoiceDate)){
                     //    billParams = '?sinNo='+sinNo+'&acctNo='+acctNo+'&bpBillDt='+bpBillDt+'&bpinvoiceDate='+bpinvoiceDate;   
                     //}
                     
                     //START CSM-14882 JRances 12/14/2017 - [R3A REGRESSION] Modify page redirection from Login
                     
                     if(Page!= null && billParams == '?'){
                         lgn = Site.login(LoginDetail,PassDetail
                                      , OrganizationSettings__c.getInstance().PortalEmailURL__c +'/'+Page);
                     } else {
                         lgn = Site.login(LoginDetail,PassDetail
                                      , OrganizationSettings__c.getInstance().PortalEmailURL__c +'/'+Page+billParams);
                     }
                     
                     //END CSM-14882 JRances
                 } 
                 //START WENJUN R3A - OAUTH
                 else if(startURL!= null && startURL.contains('RemoteAccessAuthorizationPage'))
                 {
                        lgn = Site.login(LoginDetail,PassDetail, startURL);
                 }
                 //END WENJUN R3A - OAUTH
                else {
                    
                    lgn = Site.login(LoginDetail,PassDetail
                                 , OrganizationSettings__c.getInstance().PortalEmailURL__c +'/'+'dashboard');                   
                }
                Aura.redirect(lgn);

            }
        }catch (Exception ex){
            resp.message = 'You\'ve entered an incorrect username and/or password. Please re-enter your log-in information.';
             resp.isSuccess = false;
             if(!userList.isEmpty()){
                 UserLogin checkLock = [select IsPasswordLocked from UserLogin where UserId =: userList[0].id];
                 
                 //End             
                 if(checkLock.IsPasswordLocked == true){
                     resp.message = 'Your account has now been locked for security purposes. Please reset your password by clicking on Forgot Your Password.';
                 }else{
                     System.debug('sample');
                     //JAgapito CMS-13529 Oct.6,2017
                     //resp.message = 'Sorry, but you\'ve entered an incorrect username and/or password. Please re-enter your log-in information.';//ex.getMessage();
                    //ex.getMessage();
                     /*
if (logintries > 5) {
resp.message = 'Your account has now been locked for security purposes. Please reset your password by clicking on Forgot Your Password.';//ex.getMessage();

}
*/
                 }
             }
             ErrorHandlerException.recordException(null, true, 'CXE_CP_SplashPageLoginForm', 'getLoginDetails'
                                                   , UserInfo.getUserId() + ' : ' + ex.getMessage());
         }
         return resp;
     }   
    //Mike 08/09/2017 - Getting custom settings link for Login with Facebook
    @AuraEnabled
    public static String getFbLink(){
        return OrganizationSettings__c.getOrgDefaults().signInThruFacebook__c;
    }
    //Mike 08/09/2017 - Getting custom settings link for Login with Google
    @AuraEnabled
    public static String getGoogleLink(){
        return OrganizationSettings__c.getOrgDefaults().signInThruGoogle__c;
    }
    
    /* 
* Description: method used by portal splash/login page to check if User should be redirected to dashboard
* Parameters: none
* Returns: String
* Author: GGrandea (Accenture)  //CSM-13053
* Date Created: OCT-5-17
*/  
    @AuraEnabled
    public static String checkUserSession(){
        String returnVal = 'NONE';
        id commProfId = CXE_CP_PortalUtility.retrieveCustomerPortalProfileId();
        //change return value if User Session exists
        if(Userinfo.getProfileId() == commProfId){
            returnVal = 'WITH_SESSION';
        }
        return returnVal;
    }
    
    //START CSM-14664 JRances [R2B WARRANTY] - User is not redirected to the correct page.
    //START CSM-14200 JRances / UAT, Bills link from Marketing Cloud does not automatically direct to Viewbills
    public class Response2 {
        @AuraEnabled
        public Boolean isSuccessful;
        @AuraEnabled
        public String retMessage;
        @AuraEnabled
        public String billParameter;
        @AuraEnabled
        public String newPage;
    }
    
    @AuraEnabled
    public static CXE_CP_SplashPageLoginForm.Response2 redirectToViewBills(String Page
                                             , String acctNo
                                             , String sinNo
                                             , String bpBillDt
                                             , String bpinvoiceDate
                                             , String bpBillId){
                                                 
        CXE_CP_SplashPageLoginForm.Response2 resp2 = new CXE_CP_SplashPageLoginForm.Response2();
        
        String billParams = '?';
        String CHECK_SESSION = checkUserSession();                
        
        if(CHECK_SESSION == 'WITH_SESSION'){
            if(String.isNotEmpty(bpinvoiceDate)){
                Page = 'viewbills';
                
                if(String.isNotEmpty(acctNo)){
                    billParams += '&acctNo=' + acctNo;
                }
                if(String.isNotEmpty(sinNo)){
                    billParams += '&sinNo=' + sinNo; 
                }
                if(String.isNotEmpty(bpBillDt)){
                    billParams += '&bpBillDt=' + bpBillDt; 
                }
                if(String.isNotEmpty(bpinvoiceDate)){
                    billParams += '&bpinvoiceDate=' + bpinvoiceDate;
                }
                if(String.isNotEmpty(bpBillId)){
                    billParams += '&bpBillId=' + bpBillId;
                }
                
                resp2.newPage = Page;
                resp2.isSuccessful = true;
                resp2.retMessage = 'Redirect user to view bills!';
                resp2.billParameter = billParams;
            }
        }
        return resp2;                                                   
    }
    //END CSM-14200 JRances
    //END CSM-14664
}