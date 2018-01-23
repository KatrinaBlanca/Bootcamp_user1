public without sharing class CXE_CP_SplashPageSelfRegistration_CTRL {
   
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

    }

    @AuraEnabled
    public static CXE_CP_SplashPageSelfRegistration_CTRL.Response createUser(String email, String firstname, String middlename, 
                                                                           String lastname, String suffix, String mobile) {
                                                                               
        try{
            
            id meralcoCCProfile = [SELECT Id FROM Profile WHERE Name=:CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE Limit 1].id;
            //do not proceed if current user profile is not Meralco Customer Community Profile 
            if(userinfo.getProfileId() != meralcoCCProfile){
                return new CXE_CP_SplashPageSelfRegistration_CTRL.Response(false, CXE_Constants.PORTAL_REGISTRATION_ERROR_HAS_SESSION);
            }

            
            CXE_CP_SplashPageSelfRegistration_CTRL.Request request = createReq(email, firstname, middlename, 
                                                                             lastname, suffix, mobile);
            
            Id communityProfileId = [SELECT Id FROM Profile WHERE Name=:CXE_Constants.PORTAL_COMMUNITY_PROFILE LIMIT 1].Id;
            
            if(hasDuplicateEmail(request.email)) {
                return new CXE_CP_SplashPageSelfRegistration_CTRL.Response(false, CXE_Constants.PORTAL_REGISTRATION_ERROR_DUPLICATE_EMAIL);
            }
            //START CSM-13946 GGrandea 10.18.2017 disable this rule
            // Start CSM-12516 Mike Verdad 09/13/2017
            /*if(hasDuplicateContact(request.firstname, request.lastname, request.middlename)) { //CSM-13869
                return new CXE_CP_SplashPageSelfRegistration_CTRL.Response(false, CXE_Constants.DUPLICATE_CONTACT);
            }
            // End CSM-12516 Mike Verdad 09/13/2017
            else{*/
            //END CSM-13946
             
                User u        = new User();
                u.Username    = request.email;
                u.Email       = request.email;
                u.FirstName   = request.firstname;
                u.MiddleName  = request.middlename;
                u.LastName    = request.lastname;
                u.MobilePhone = request.mobileNumber;
                u.Suffix      = request.suffix;
                
                 
                //START CSM-13946 GGrandea 10.18.2017 use email for User nickname 
                /*String nickname = (String.isNotBlank(request.firstname) ? request.firstname.substring(0,1) : '' ) + (String.isNotBlank(request.lastname) ? request.lastname.substring(0,1) : '' );
                nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);

                u.CommunityNickname = nickname;*/
                u.CommunityNickname = request.email;
                //END CSM-13946
                u.ContactId = getNonPayorContactId(request);
                
                u.Alias = request.firstname.substring(0,1)+(request.lastname.length()>7? request.lastname.substring(1,7) : request.lastname );
                   
                u.TimeZoneSidKey = CXE_Constants.PORTALUSER_TIMEZONESIDKEY;
                u.LocaleSidKey = CXE_Constants.PORTALPORTALUSER_LOCALESIDKEY;
                u.EmailEncodingKey = CXE_Constants.PORTALUSER_EMAILENCODINGKEY;
                u.LanguageLocaleKey = CXE_Constants.PORTALUSER_LANGUAGELOCALEKEY;
                
                u.ProfileId = communityProfileId;
                u.IsActive = true;
                u.By_Pass_Validation__c = True; //CSM-12915 GGrandea 09.22.2017
             
                insert u;               
            //} //CSM-13946 10.18.2017

            return new CXE_CP_SplashPageSelfRegistration_CTRL.Response(true, CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL);
        } catch(Exception e) {
            ErrorHandlerException.recordException(null, true, 'CXE_CP_SplashPageSelfRegistration_CTRL', 'createUser', UserInfo.getUserId() + ' : ' + e.getMessage());
            return new CXE_CP_SplashPageSelfRegistration_CTRL.Response(false, e.getMessage());
           
        }
    }

   
    private static Boolean hasDuplicateEmail(String email){         
        return ([SELECT COUNT() FROM User WHERE Email =:email AND Profile.Name =:CXE_Constants.PORTAL_COMMUNITY_PROFILE] > 0);
    }
    
    // Start CSM-12516 Mike Verdad 09/13/2017
    private static Boolean hasDuplicateContact(String firstname, String lastname, String middlename){         
        return ([SELECT COUNT() FROM user WHERE firstname =:firstname AND middlename =:middlename AND lastname =:lastname] > 0);//CSM-13869
    }
    // End CSM-12516 Mike Verdad 09/13/2017
    
    private static CXE_CP_SplashPageSelfRegistration_CTRL.Request createReq(String email, String firstname, String middlename, 
                                                                           String lastname, String suffix, String mobile){  
                                                                               
        CXE_CP_SplashPageSelfRegistration_CTRL.Request req = new CXE_CP_SplashPageSelfRegistration_CTRL.Request();
        req.email        = email;
        req.firstname    = firstname;
        req.middlename   = middlename;
        req.lastname     = lastname;
        req.suffix       = suffix;
        req.mobileNumber = mobile;
       
        return req;
    }
        
    //Getting Custom Settings url link for Terms and Conditions
    @AuraEnabled
    public static String getHiearchySettings(){
        return OrganizationSettings__c.getOrgDefaults().Terms_And_Conditions_Link__c;
    }

    private static String getNonPayorContactId(CXE_CP_SplashPageSelfRegistration_CTRL.Request request){
        // CSM-14042 Lisen : for Non Payor -> always create New Person Account
        /*List<Contact> contactList = [SELECT Id
                                            FROM Contact 
                                            WHERE FirstName =: request.firstname
                                            AND MiddleName =: request.middlename //CSM-13869
                                            AND LastName =: request.lastname];*/
        //Boolean createNewAccount = false;
        String contactId = null;
        /*if(contactList == null){
            createNewAccount = true;
        }else{
            if(contactList.size() == 1){
                contactId = contactList[0].Id;
            }else{
                createNewAccount = true;
            }
        }
        */
        //if(createNewAccount){
        // CSM-14042 Lisen
            try{
                Id personAcctRecTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(CXE_Constants.RECORD_TYPE_NAME_ACCOUNT_PERSON).getRecordTypeId();
                
                Account acct = new Account();
                acct.RecordTypeId = personAcctRecTypeId;
                acct.FirstName = request.firstname;
                acct.LastName = request.lastname;
                acct.MiddleName = request.middlename;
                acct.PersonEmail = request.email;
                acct.PersonMobilePhone = request.mobileNumber;
                acct.Suffix = request.suffix;

                acct.OwnerId = OrganizationSettings__c.getOrgDefaults().Default_Account_Owner__c;
                insert acct;

                if(acct != null){
                    Account newAccount = [SELECT PersonContactId FROM Account WHERE Id=:acct.Id LIMIT 1];
                    if(newAccount != null){
                        contactId = newAccount.PersonContactId;
                    }

                }
            }catch (Exception e){
                ErrorHandlerException.recordException(null, true, 'CXE_CP_SplashPageSelfRegistration_CTRL', 'getNonPayorContactId', e);
            }
        //}
        return contactId;
    }
}