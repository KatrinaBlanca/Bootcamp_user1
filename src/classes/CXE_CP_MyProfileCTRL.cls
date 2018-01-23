public without sharing class CXE_CP_MyProfileCTRL { //CSM-12485 GGrandea 09.08.2017 - changed to "without sharing"
    
    public CXE_CP_MyProfileCTRL() {
        
    }
    
    public class Response{
        
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public String message;
        
        
        public Response(Boolean isSuccess, String message){
            this.isSuccess = isSuccess;
            this.message = message;
            
        }  
        public Response(String portalUser){
            this.isSuccess = true;
            this.message = '';
            
        }    
    }
    
    public class Request{
        
        @AuraEnabled
        public String email {get; set;}
        
        @AuraEnabled
        public String firstname {get; set;}
        
        @AuraEnabled
        public String middlename {get; set;}
        
        @AuraEnabled
        public String lastname {get; set;}
        
        @AuraEnabled
        public String suffix {get; set;}
        
        @AuraEnabled
        public String mobileNumber {get; set;}
        
        
        @AuraEnabled
        public Boolean hasActiveSin {get; set;}//added by Melvin Corbes
        
    }
    
    @AuraEnabled
    public static CXE_CP_SplashPageSelfRegistration_CC.Response createUser(String email, String firstname, String middlename, 
                                                                           String lastname, String suffix, String mobile) {
                                                                               try{
                                                                                   CXE_CP_SplashPageSelfRegistration_CC.Request request = createReq(email, firstname, middlename, 
                                                                                                                                                    lastname, suffix, mobile);
                                                                                   
                                                                                   if(hasDuplicateEmail(request.email)) {
                                                                                       return new CXE_CP_SplashPageSelfRegistration_CC.Response(false, CXE_Constants.PORTAL_REGISTRATION_ERROR_DUPLICATE_EMAIL);
                                                                                   }
                                                                                   
                                                                                   else{
                                                                                       User u        = new User();
                                                                                       u.Username    = request.email;
                                                                                       u.Email       = request.email;
                                                                                       u.FirstName   = request.firstname;
                                                                                       u.LastName    = request.lastname;
                                                                                       u.MobilePhone = request.mobileNumber;
                                                                                       u.suffix      = request.suffix;
                                                                                       
                                                                                       String nickname = (String.isNotBlank(request.firstname) ? request.firstname.substring(0,1) : '' ) + (String.isNotBlank(request.lastname) ? request.lastname.substring(0,1) : '' );
                                                                                       nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
                                                                                       
                                                                                       u.CommunityNickname = nickname;
                                                                                       String userId = Site.createPortalUser(u, null, null);
                                                                                       
                                                                                   }
                                                                                   
                                                                                   return new CXE_CP_SplashPageSelfRegistration_CC.Response(true, CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL);
                                                                               } catch(Site.ExternalUserCreateException e) {
                                                                                   ErrorHandlerException.recordException(null, true, 'CXE_CP_SplashPageSelfRegistration_CC', 'createUser', UserInfo.getUserId() + ' : ' + e.getMessage());
                                                                                   return new CXE_CP_SplashPageSelfRegistration_CC.Response(false, e.getMessage());
                                                                               } catch(Exception e) {
                                                                                   ErrorHandlerException.recordException(null, true, 'CXE_CP_SplashPageSelfRegistration_CC', 'createUser', UserInfo.getUserId() + ' : ' + e.getMessage());
                                                                                   return new CXE_CP_SplashPageSelfRegistration_CC.Response(false, e.getMessage());
                                                                               }
                                                                           }
    
    @TestVisible
    private static Boolean hasDuplicateEmail(String email){         
        return ([ SELECT COUNT() FROM User WHERE Email =:email AND Profile.Name =:CXE_Constants.PORTAL_COMMUNITY_PROFILE] > 0);
    }
    
    
    private static CXE_CP_SplashPageSelfRegistration_CC.Request createReq(String email, String firstname, String middlename, 
                                                                          String lastname, String suffix, String mobile){  
                                                                              
                                                                              CXE_CP_SplashPageSelfRegistration_CC.Request req = new CXE_CP_SplashPageSelfRegistration_CC.Request();
                                                                              req.email        = email;
                                                                              req.firstname    = firstname;
                                                                              req.middlename   = middlename;
                                                                              req.lastname     = lastname;
                                                                              req.suffix       = suffix;
                                                                              req.mobileNumber = mobile;
                                                                              
                                                                              return req;
                                                                          }
    
    /*Author: Melvin Corbes
* Jul-26-2017
*/
    @AuraEnabled
    public static Boolean hasSinPaperLessBilling(){
       
          //START CSM-13863 JRances - Unable to deactivate Non-Payor subscribe to Paperless Billing
          
         return( [SELECT COUNT()   
                 FROM  CXE_Service_Enrollment__c 
                 WHERE CXE_UserId__c=:UserInfo.getUserId()
                 AND CXE_IsActive__c = TRUE
                 AND CXE_Type__c =: CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR
                 AND CXE_ServiceId__r.payor__r.Bill_Print_Mode__c =: CXE_Constants.BPM_PAPERLESS] > 0);
        
        //END CSM-13863 JRances
       
    }      
    
    /* Author: Melvin Corbes 
*  Jul-28-2017
*/
    @AuraEnabled
    public static String PortalAccountDeactivated(String relatedArticle){
        
        Request req = new Request();
        List<User> portalUser = [SELECT CXE_CP_isPortalDeactivated__c FROM User WHERE Id=:UserInfo.getUserId()];
        List<ThirdPartyAccountLink> tpaLink = [SELECT SsoProviderId, Provider, UserId, RemoteIdentifier FROM ThirdPartyAccountLink WHERE userId=:UserInfo.getUserId()];
        portalUser[0].CXE_CP_isPortalDeactivated__c =true;
        portalUser[0].UserArticleSelected__c =relatedArticle;
        try{
            update portalUser[0];

            //authtoken revocation 080717
            for(ThirdPartyAccountLink t : tpaLink)
            {
                Auth.AuthToken.revokeAccess(t.SsoProviderId, t.Provider, t.UserId, t.RemoteIdentifier);
            }

            req.firstname ='successfull';  
        }catch(DMLException ex){
            
            req.firstname =String.valueOf(ex);
            ErrorHandlerException.recordException(null, true, 'CXE_CP_MyProfileCTRL', 'PortalAccountDeactivated', ex.getMessage());
        }
        
        return  req.firstname;  
    }
    
    public class PortalDeactivationReasonLinkUrl{
        
        @AuraEnabled
        public String DifferentEmail {get; set;}
        @AuraEnabled
        public String MoveOutAddress {get; set;}
        @AuraEnabled
        public String NoActiveSin {get; set;}
        @AuraEnabled
        public String NoLongerUse {get; set;}
        @AuraEnabled
        public String PortalDifficult {get; set;}
        @AuraEnabled
        public String PortalUnuseful {get; set;} 
        @AuraEnabled
        public String PrivacyConcerns {get; set;}
        @AuraEnabled
        public String ReceivedManyEmails {get; set;}
        @AuraEnabled
        public String RegCustmerNotAssctd {get; set;}
        @AuraEnabled
        public String Response {get; set;}
        @AuraEnabled
        public String CreatePortalAcct {get; set;}      
        @AuraEnabled
        public String applyNewService {get; set;}
        @AuraEnabled
        public String enrollSin {get; set;}
        @AuraEnabled
        public String removeSin {get; set;}
        @AuraEnabled
        public String receiveNoti {get; set;}
        @AuraEnabled
        public String privacyPolicy {get; set;}
        @AuraEnabled
        public String articleLabels {get; set;}
        
    }
    
     @AuraEnabled
    public static PortalDeactivationReasonLinkUrl getPrivacyConcerns(){
        
        List<PortalDeactivationReasonLinkUrl> portalDeactionReason = new List<PortalDeactivationReasonLinkUrl>();
        
        List<Privacy_Concerns_Article_Link__mdt> retrieveRecords =[select Meralco_Privacy_Policy__c,Article__c
                                                                   from Privacy_Concerns_Article_Link__mdt];
        
        for(Privacy_Concerns_Article_Link__mdt pdreasonRec: retrieveRecords){
            PortalDeactivationReasonLinkUrl pdrlu = new PortalDeactivationReasonLinkUrl();
            
            pdrlu.privacyPolicy = pdreasonRec.Meralco_Privacy_Policy__c;
            pdrlu.articleLabels =pdreasonRec.Article__c;
                   
            portalDeactionReason.add(pdrlu);
            
        }
        
        return portalDeactionReason[0];
        
    }
    
    
    
    
    @AuraEnabled
    public static PortalDeactivationReasonLinkUrl getReceiveManyNoti(){
        
        List<PortalDeactivationReasonLinkUrl> portalDeactionReason = new List<PortalDeactivationReasonLinkUrl>();
        
        List<Received_Many_Emails_Article_Link__mdt> retrieveRecords =[select Manage_Notifications_Link__c,Article__c
                                                                   from Received_Many_Emails_Article_Link__mdt];
        
        for(Received_Many_Emails_Article_Link__mdt pdreasonRec: retrieveRecords){
            PortalDeactivationReasonLinkUrl pdrlu = new PortalDeactivationReasonLinkUrl();
            
            pdrlu.receiveNoti = pdreasonRec.Manage_Notifications_Link__c;
            pdrlu.articleLabels =pdreasonRec.Article__c;
                   
            portalDeactionReason.add(pdrlu);
            
        }
        
        return portalDeactionReason[0];
        
    }
    
    
    
    @AuraEnabled
    public static List<PortalDeactivationReasonLinkUrl> getMoveAddress(){
        
        List<PortalDeactivationReasonLinkUrl> portalDeactionReason = new List<PortalDeactivationReasonLinkUrl>();
         
        List<Move_Out_Address_Article_LinkV2__mdt> retrieveRecords =[select Article_Move_Out_Address__c,Article__c,QualifiedApiName  from Move_Out_Address_Article_LinkV2__mdt
                                                                   order by QualifiedApiName]; 
                                                                 
        
        for(Move_Out_Address_Article_LinkV2__mdt pdreasonRec: retrieveRecords){
            PortalDeactivationReasonLinkUrl pdrlu = new PortalDeactivationReasonLinkUrl();
            pdrlu.articleLabels =pdreasonRec.Article__c;
            pdrlu.applyNewService = pdreasonRec.Article_Move_Out_Address__c;
                  
            portalDeactionReason.add(pdrlu);
            
        }
        
        return portalDeactionReason;
        
    }
    
    
    @AuraEnabled
    public static PortalDeactivationReasonLinkUrl getDifferentEmail(){
        
        List<PortalDeactivationReasonLinkUrl> portalDeactionReason = new List<PortalDeactivationReasonLinkUrl>();
        
        List<Different_Email_Article_Links__mdt> retrieveEmailRecords =[select Create_Customer_Portal_Accnts__c,Article__c
                                                                        FROM Different_Email_Article_Links__mdt];
        
        for(Different_Email_Article_Links__mdt pdreasonRec: retrieveEmailRecords){
            PortalDeactivationReasonLinkUrl pdrlu = new PortalDeactivationReasonLinkUrl();
            
            pdrlu.CreatePortalAcct = pdreasonRec.Create_Customer_Portal_Accnts__c;
            pdrlu.articleLabels =pdreasonRec.Article__c;
            portalDeactionReason.add(pdrlu);
            
        }
        
        return portalDeactionReason[0];
        
    }
    
    
    
    @AuraEnabled
    public static PortalDeactivationReasonLinkUrl getDeactivationReason(){
        
        List<PortalDeactivationReasonLinkUrl> portalDeactionReason = new List<PortalDeactivationReasonLinkUrl>();
        
        List<CXE_PortalDeactivation_Reason__mdt> retrieveRecords =[SELECT Different_Email__c, Move_Out_Address__c,No_Active_Sin__c,No_Longer_Use__c,
                                                                   Portal_Difficult__c,Portal_Unuseful__c,Privacy_Concerns__c,Received_Many_Emails__c,
                                                                   RegCustmer_Not_Assctd__c
                                                                   FROM CXE_PortalDeactivation_Reason__mdt];
        
        for(CXE_PortalDeactivation_Reason__mdt pdreasonRec: retrieveRecords){
            PortalDeactivationReasonLinkUrl pdrlu = new PortalDeactivationReasonLinkUrl();
            
            pdrlu.DifferentEmail = pdreasonRec.Different_Email__c;        
            pdrlu.MoveOutAddress = pdreasonRec.Move_Out_Address__c;
            pdrlu.NoActiveSin = pdreasonRec.No_Active_Sin__c;          
            pdrlu.NoLongerUse = pdreasonRec.No_Longer_Use__c;          
            pdrlu.PortalDifficult = pdreasonRec.Portal_Difficult__c;           
            pdrlu.PortalUnuseful = pdreasonRec.Portal_Unuseful__c;           
            pdrlu.PrivacyConcerns = pdreasonRec.Privacy_Concerns__c;          
            pdrlu.ReceivedManyEmails = pdreasonRec.Received_Many_Emails__c;         
            pdrlu.RegCustmerNotAssctd  = pdreasonRec.RegCustmer_Not_Assctd__c;
            
            portalDeactionReason.add(pdrlu);
            
        }
        
        return portalDeactionReason[0];
        
    }
    
    
    
    
    
    
    
    //end of Melvin Corbes Jul-28-2017
    
    //Mike 7/31/17 - for retrieving contact info referenced by (MyProfileTab1, MyProfileTab2, MyProfileTab4)
    public class UserData {
        @AuraEnabled
        public Date Birthdate;
        @AuraEnabled
        public String FirstName;
        @AuraEnabled
        public String LastName;
        @AuraEnabled
        public String MiddleName;
        @AuraEnabled
        public String MobilePhone;
        @AuraEnabled
        public String Suffix;
        @AuraEnabled
        public String Email;
        @AuraEnabled
        public String Phone;
        @AuraEnabled
        public String Mobile1;
        @AuraEnabled
        public String Mobile2;
        @AuraEnabled
        public String FName;
        
        @AuraEnabled
        public String billingNotification;   
        @AuraEnabled
        public String paymentConfirmation;      
        @AuraEnabled
        public String paymentReminder;        
        @AuraEnabled
        public String serviceApplication;       
        @AuraEnabled
        public String outages;
        @AuraEnabled       
        public String promotions;
        @AuraEnabled       
        public Boolean google;
        @AuraEnabled       
        public Boolean facebook;
        //start CSM-12839 Melvin Corbes 9/22/2017
        @AuraEnabled
        public String Email2;
        @AuraEnabled
        public String Salutation;
       //end of CSM-12839 Melvin Corbes 9/22/2017
       
        //START CSM-13745 JRances - Formatted Birthdate format to be displayed on My Profile
        @AuraEnabled
        public String BirthdateString;
        //END CSM-13745 JRances

        // START CSM-14011 Jerome To 10/20/2017 Social Media links not saving in the Profile Information
        @AuraEnabled
        public String googleAcct;
        @AuraEnabled
        public String fbAcct;
        @AuraEnabled
        public String instagramAcct;
        @AuraEnabled
        public String twitterAcct;
        // END CSM-14011 Jerome To 10/20/2017 Social Media links not saving in the Profile Information
    }
    
    
    @AuraEnabled
    public static UserData getProfileInfo(){
        
        UserData Udata;
        try{
            User currentUser = [SELECT FirstName, LastName, MiddleName, Suffix, Email, Phone, MobilePhone, ContactId  
                                FROM User WHERE Id =:UserInfo.getUserId()];
            // START CSM-13021 Jerome To Added IsPersonAccount, HomePhone
            // START CSM-14011 Jerome To 10/20/2017 Social Media links not saving in the Profile Information
            Contact conRec = [SELECT FirstName, LastName, MiddleName, Suffix, Email, Phone, MobilePhone, 
                                    Birthdate, Mobile_1__c, Mobile_2__c,
                                    Billing_Notification__c, Payment_Confirmation_Notification__c, Payment_Reminders__c, 
                                    Service_Applications_Notification__c, Outages_Notification__c, Promotions_Notification__c,
                              		  Salutation, Email_2__c, IsPersonAccount, HomePhone, Facebook__c, Google__c, Twitter__c, Instagram__c
                              FROM Contact WHERE Id =: currentUser.ContactId];
            // END CSM-14011 Jerome To 10/20/2017 Social Media links not saving in the Profile Information
            // END CSM-13021 Jerome To Added IsPersonAccount, HomePhone
            List<ThirdPartyAccountLink> thirdPartyAcct =[SELECT Provider FROM ThirdPartyAccountLink 
                                                        WHERE UserId =:UserInfo.getUserId()];
           
            Udata = new UserData();
            Udata.Email       = currentUser.Email;
                
            Udata.Email       = conRec.Email;
            
            //START CSM-13803 JRances - Value for birthdate is not displayed in the Edit Profile Info page in Customer Portal
            Udata.Birthdate = conRec.Birthdate;
            //END CSM-13803 JRances
            
            //START CSM-13745 JRances - Formatted Birthdate format to be displayed on My Profile
            if(conRec.Birthdate == null){
                Udata.Birthdate = conRec.Birthdate;
            } else {                
                Udata.BirthdateString = String.valueOf(conRec.Birthdate.month()) + '-' + String.valueOf(conRec.Birthdate.day()) + '-' + String.valueOf(conRec.Birthdate.year());
            }
            //Udata.Birthdate2   = String.valueOf(conRec.Birthdate.month()) + '-' + String.valueOf(conRec.Birthdate.day()) + '-' + String.valueOf(conRec.Birthdate.year());
            
            //END CSM-13745 JRances
            
            Udata.FirstName   = conRec.FirstName;
            Udata.LastName    = conRec.LastName;
            Udata.FirstName   = conRec.FirstName;
            Udata.MiddleName  = conRec.MiddleName;
            // START CSM-13021 Jerome To Added filter for person acct
            Udata.Phone       = (conRec.IsPersonAccount) ? conRec.HomePhone : conRec.Phone;
            Udata.MobilePhone = (conRec.IsPersonAccount) ? conRec.Mobile_1__c : conRec.MobilePhone;
            // END CSM-13021 Jerome To Added filter for person acct
            Udata.Mobile1     = conRec.Mobile_1__c;
            Udata.Mobile2     = conRec.Mobile_2__c;
            Udata.FName       = String.join(new List<String> { conRec.Salutation, conRec.FirstName, conRec.MiddleName, conRec.LastName, conRec.Suffix}, ' ');//  conRec.FirstName + ' ' + conRec.LastName; // CSM-12839 Jerome To added Middlename and suffix
            Udata.Suffix      = conRec.Suffix;
            
            Udata.billingNotification = conrec.Billing_Notification__c; 
            Udata.paymentConfirmation = conrec.Payment_Confirmation_Notification__c;
            Udata.paymentReminder     = conrec.Payment_Reminders__c;
            Udata.serviceApplication  = conrec.Service_Applications_Notification__c;
            Udata.outages             = conrec.Outages_Notification__c;
            Udata.promotions          = conrec.Promotions_Notification__c;
            
            Udata.google =False;
            Udata.facebook =False;
            Udata.Salutation =conrec.Salutation;
            Udata.Email2 =conrec.Email_2__c;
            
            // START CSM-14011 Jerome To 10/20/2017 Social Media links not saving in the Profile Information
            Udata.googleAcct = conRec.Google__c;
            Udata.fbAcct = conRec.Facebook__c;
            Udata.instagramAcct = conRec.Instagram__c;
            Udata.twitterAcct = conRec.Twitter__c;
            // END CSM-14011 Jerome To 10/20/2017 Social Media links not saving in the Profile Information

            for(ThirdPartyAccountLink tpaLink : thirdPartyAcct){
                if(tpaLink.Provider == 'google'){
                    Udata.google =True;
                }
                if(tpaLink.Provider == 'facebook'){
                    Udata.facebook =True;
                }
            }
        }
        catch(DMLException ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_MyProfileCTRL', 'getProfileInfo', ex.getMessage());
        }
        return Udata;
    }
    
    //End of Mike 7/31/17
    
    //Mike 08/09/2017 - Getting custom settings link for Facebook linking
    @AuraEnabled
    public static String getFbLink(){
        return OrganizationSettings__c.getOrgDefaults().Fb_Linking__c;
    }
    //Mike 08/09/2017 - Getting custom settings link for Google linking
    @AuraEnabled
    public static String getGoogleLink(){
        return OrganizationSettings__c.getOrgDefaults().Google_Linking__c;
    }
    
    
    //JFernandez 11/16/2017 - Getting the userId of the current user
    @AuraEnabled
    public static String getUserSessionId(){
        String userSessionId;
        
        if(UserInfo.getSessionId() != null){
            userSessionId = UserInfo.getSessionId();
        }else{
            //userSessionId = null;
        }
		
        //userSessionId = userInfo.getUserId();
        return userSessionId;
    }
}