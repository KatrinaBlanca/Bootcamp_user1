/*************************************************************************************** 
Developer -    Jerome To (Accenture)
Date -         07/12/2017
Version -      1.0 
Function -     Method for creating a portal user
#############Change Log#############
****************************************************************************************/
public without sharing class CXE_CP_SplashPageSelfRegistration_CC {
    
    public CXE_CP_SplashPageSelfRegistration_CC() {
        
    }

    public class Response{
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public String caseNumber;
        
        public Response(Boolean isSuccess, String message){
            this.isSuccess = isSuccess;
            this.message = message;
            this.caseNumber = '';
        }  
        
        public Response(String caseNumber){
            this.isSuccess = true;
            this.message = '';
            this.caseNumber = caseNumber;
        }    
    }

    public class Request{
        @AuraEnabled
        public Boolean isNew {get; set;}

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
        public String SIN {get; set;}

        @AuraEnabled
        public Decimal amount {get; set;}

        @AuraEnabled
        public Date transactionDate {get; set;}
    }


    public class SINWrapper{
        public Boolean hasError {get; set;}
        public String errorMessage {get; set;}
        public String caseNumber {get; set;}

        public SINWrapper(String errorMessage){
            this.hasError = String.isNotBlank(errorMessage);
            this.errorMessage = errorMessage;
            this.caseNumber = caseNumber;
        }

        public SINWrapper(Boolean hasError, String caseNumber){
            this.hasError = false;
            this.errorMessage = '';
            this.caseNumber = caseNumber;
        }  
    }

    public class BillWrapper{
        public Boolean hasError {get; set;}
        public List<String> errorMessages {get; set;}

        public BillWrapper(List<String> errorMessages){
            this.hasError = !errorMessages.isEmpty();
            if(!errorMessages.isEmpty()) {
                this.errorMessages = errorMessages;
            }
        }

        public BillWrapper(Boolean hasError){
            this.hasError = hasError;
            //this.errorMessages = new List;
        }  
    }


    //@AuraEnabled
    //public static CXE_CP_SplashPageSelfRegistration_CC.Response createUser(CXE_CP_SplashPageSelfRegistration_Req request) {
    @AuraEnabled
    public static CXE_CP_SplashPageSelfRegistration_CC.Response createUser(String email, String firstname, String middlename, 
                                                                           String lastname, String suffix, String mobile, 
                                                                           String sin, Decimal amount, string transactionDate, Boolean isNew) {
        try{
            Date bpDate = Date.valueOf(transactionDate);

            // START CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017
            Set<String> hmbFilters = new Set<String> {CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP002, CXE_Constants.SERVICE_CODE_SEGMENT_2};
            Set<String> smeFilters = new Set<String> {CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP003, CXE_Constants.SERVICE_CODE_SEGMENT_3}; // CSM-13908 LISEN 20171015 : adding logic to handle SME both SME with Business account or Person Account
            // END CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017

            CXE_CP_SplashPageSelfRegistration_CC.Request request = createReq(email, firstname, middlename, 
                                                                             lastname, suffix, mobile, 
                                                                             sin, amount, bpDate, isNew);
            
                id meralcoCCProfile = [SELECT Id FROM Profile WHERE Name=:CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE Limit 1].id;
            //do not proceed if current user profile is not Meralco Customer Community Profile 
            if(userinfo.getProfileId() != meralcoCCProfile){
                return new CXE_CP_SplashPageSelfRegistration_CC.Response(false, CXE_Constants.PORTAL_REGISTRATION_ERROR_HAS_SESSION);
            }


            if(request.SIN.length() != 12) {
                return new CXE_CP_SplashPageSelfRegistration_CC.Response(false, CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_INVALID_LENGTH);
            }

            List<Agreement__c> serviceList = getSIN(request.SIN);            

            SINWrapper sinWrapper = validateSIN(request, serviceList);

            if(sinWrapper.hasError) {
                return new CXE_CP_SplashPageSelfRegistration_CC.Response(false, sinWrapper.errorMessage);
            }

            //START CSM-12464 Jerome To Rerranged order of validations
            BillWrapper bill = validateBillingOrPayment(request, serviceList);
            if(bill.hasError) {
                return new CXE_CP_SplashPageSelfRegistration_CC.Response(false, String.join(bill.errorMessages, ' '));//CSM-13869 added space join error messages 10.12.2017
            }

            //START CSM 12454 Jerome To
            if(hasDuplicateEmail(request.email)) {
                return new CXE_CP_SplashPageSelfRegistration_CC.Response(false, CXE_Constants.PORTAL_REGISTRATION_ERROR_DUPLICATE_EMAIL);
            }
            //END CSM 12454 Jerome To
            
            //START CSM-13946 GGrandea 10.18.2017 disable this rule
            // START CSM-13811 Jerome To Checking of Name should be First Name, Middle Name and Last Name
            // Start CSM-12516 Mike Verdad 09/13/2017
            /*if(hasDuplicateContact(request)) {
                return new CXE_CP_SplashPageSelfRegistration_CC.Response(false, CXE_Constants.DUPLICATE_CONTACT);
            }*/
            // End CSM-12516 Mike Verdad 09/13/2017
            // END CSM-13811 Jerome To Checking of Name should be First Name, Middle Name and Last Name
            //END CSM-13946
            //

           
            

            // CSM-13908 LISEN 20171015 : adding logic to handle SME both SME with Business account or Person Account
            if(smeFilters.contains(serviceList.get(0).Code_Segment__c)) { 
                return new CXE_CP_SplashPageSelfRegistration_CC.Response(createCaseForBusiness(request, serviceList.get(0)));
            }
            // CSM-13908 LISEN

            if(!serviceList.get(0).Payor__r.Account.IsPersonAccount) {
                // START CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017
                if(hmbFilters.contains(serviceList.get(0).Code_Segment__c)) { 
                    return createPortalUser(request, serviceList.get(0));                    
                } 
                /* CSM-13908 Lisen : remove this, any SME will be creating case. Moving logic up before checking Person Account
                else {
                    return new CXE_CP_SplashPageSelfRegistration_CC.Response(createCaseForBusiness(request, serviceList.get(0)));
                }*/
                // END CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017
            }

            if(!serviceList.isEmpty()) {
                //Vincent 8/7/17 for V10Integration
                //START CSM-12877 GGrandea 09.22.2017 disable BillPrintMode invocation from this class
                /*Set<Id> payorServiceId = new Set<Id>();
                for(Agreement__c enroll : serviceList){
                    payorServiceId.add(enroll.Id);
                }*/
                //END CSM-12877 GGrandea 09.22.2017 disable BillPrintMode invocation from this class
                
                //START CSM-12543 GGrandea 09.13.2017 disabling Service Enrollment query; reuse serviceList
                /*List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c
                                                                     , CXE_Alias__c
                                                                     ,CXE_Type__c
                                                                     , CXE_ServiceId__r.Account__c 
                                                                     , CXE_ServiceId__r.SIN__c
                                                                     , CXE_ServiceId__r.Payor__c
                                                                     From CXE_Service_Enrollment__c 
                                                                     Where CXE_ServiceId__c in: payorServiceId and CXE_Type__c = 'Payor'];*/
                
                //if(!listofEnrollments.isEmpty()){ //CSM-12543 disabling IF condition
                    
                //START CSM-12877 GGrandea 09.22.2017 disable BillPrintMode invocation from this class
                /*List<Contract> contractRecords = [Select Id,Contract_External_ID__c,Bill_Print_Mode__c
                                                  from Contract 
                                                  //where id=:listofEnrollments[0].CXE_ServiceId__r.Payor__c]; //CSM-12543
                                                  where id=:serviceList[0].Payor__c]; //CSM-12543
                
                if(contractRecords.size() > 0){
                    if(contractRecords[0].Bill_Print_Mode__c ==CXE_Constants.BPM_PAPER){
                        CXE_CP_BillPrintModeIntegrationUtility.printmodeUpdateRequest(contractRecords , CXE_Constants.BPM_PAPERPLUS);
                    }
                }*/   
                //END CSM-12877 GGrandea 09.22.2017 disable BillPrintMode invocation from this class
                    
                //}
                //END CSM-12543 GGrandea 09.13.2017
                //End Vincent 8/7/17 for V10Integration
                
                
                Id communityProfileId = [SELECT Id FROM Profile WHERE Name=:CXE_Constants.PORTAL_COMMUNITY_PROFILE LIMIT 1].Id;
                User u = new User();
                u.Username = request.email;
                u.Email = request.email;
                u.FirstName = request.firstname;
                u.MiddleName = request.middlename;
                u.LastName = request.lastname;
                u.MobilePhone = request.mobileNumber;
                u.Suffix = request.suffix;

                //START CSM-13946 GGrandea 10.18.2017 use email for User nickname
                /*String nickname = (String.isNotBlank(request.firstname) ? request.firstname.substring(0,1) : '' ) + (String.isNotBlank(request.lastname) ? request.lastname.substring(0,1) : '' );
                nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);*/

                //u.CommunityNickname = nickname;
                u.CommunityNickname = request.email;
                //END CSM-13946

                
                //START CSM-12211 RReyes AUG-03-17
                if(isPayor(request, serviceList.get(0))){

                    //START CSM-13946 GGrandea 10.19.2017
                    if(serviceList.get(0).Payor__r.Account.IsCustomerPortal){
                        return new CXE_CP_SplashPageSelfRegistration_CC.Response(false, CXE_Constants.DUPLICATE_CONTACT);
                    }
                    //END CSM-13946

                    //use the contact of the person account
                    if(serviceList[0].Payor__r.Account.PersonContactId != null){
                        u.ContactId = serviceList[0].Payor__r.Account.PersonContactId;
                    }
                    //START CSM-12461 GGrandea 09.12.2017
                    //u.CXE_Auto_Enrolled_Services__c = true;
                    if(hasRelatedServices(serviceList[0].Payor__c, serviceList[0].Id)){ //CSM-13029 GGrandea 09.28.2017
                        u.CXE_Auto_Enrolled_Services__c = true;
                    }
                    //END CSM-12461 GGrandea 09.12.2017
                }else{
                    //search for the related person accounts
                    u.ContactId = getNonPayorContactId(request);
                }
                
                u.Alias = request.firstname.substring(0,1)+(request.lastname.length()>7? request.lastname.substring(1,7) : request.lastname );
                u.TimeZoneSidKey = CXE_Constants.PORTALUSER_TIMEZONESIDKEY;
                u.LocaleSidKey = CXE_Constants.PORTALPORTALUSER_LOCALESIDKEY;
                u.EmailEncodingKey = CXE_Constants.PORTALUSER_EMAILENCODINGKEY;
                u.LanguageLocaleKey = CXE_Constants.PORTALUSER_LANGUAGELOCALEKEY;
                u.ProfileId = communityProfileId;
                u.IsActive = true;
                u.By_Pass_Validation__c = True; //CSM-12863 GGrandea 09.21.2017
                u.Initial_Service_ID__c = sin; //CSM-13904 Lisen 20171014
                insert u;
                //String userId = Site.createPortalUser(u, null, null);
                String userId = u.Id; 
                if(String.isNotBlank(userId)) {
                    createServiceEnrollmentList(request, serviceList.get(0), userId);                    
                }
                //END CSM-12211 RReyes AUG-03-17
            }

            return new CXE_CP_SplashPageSelfRegistration_CC.Response(true, CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL);
        } catch(Exception e) {
            ErrorHandlerException.recordException(null, true, 'CXE_CP_SplashPageSelfRegistration_CC', 'createUser', e);
            return new CXE_CP_SplashPageSelfRegistration_CC.Response(false, e.getMessage());
        }
    }

    @AuraEnabled
    public static CXE_CP_SplashPageSelfRegistration_CC.Response hasBeenUsedByAnotherPortalAccount(String sin) {
        return new CXE_CP_SplashPageSelfRegistration_CC.Response(true, ([SELECT COUNT() FROM CXE_Service_Enrollment__c WHERE CXE_ServiceId__r.SIN__c =:sin AND CXE_IsActive__c = true] == 1) ? CXE_Constants.PORTAL_REGISTRATION_NOTICE_SIN_HAS_BEEN_USED2 : '');
    }

    // CSM-10823 This SIN has reached its maximum portal account enrollments
    private static Boolean hasBeenRegisteredTwice(String serviceId){
        //check if registered by two portal accounts        
        return [SELECT COUNT() FROM CXE_Service_Enrollment__c WHERE CXE_ServiceId__c =:serviceId AND CXE_IsActive__c = true] >= 2;      
    }
    // CSM-10799 
    private static Boolean hasDuplicateEmail(String email){         
        return ([SELECT COUNT() FROM User WHERE Email =:email AND Profile.Name =:CXE_Constants.PORTAL_COMMUNITY_PROFILE] > 0);
    }

    // START CSM-13811 Jerome To Checking of Name should be First Name, Middle Name and Last Name
    
    // Start CSM-12516 Mike Verdad 09/13/2017
    //private static Boolean hasDuplicateContact(String firstname, String lastname){         
    //    return ([SELECT COUNT() FROM user WHERE firstname =:firstname AND lastname =:lastname] > 0);
    //}
    // End CSM-12516 Mike Verdad 09/13/2017

    private static Boolean hasDuplicateContact(CXE_CP_SplashPageSelfRegistration_CC.Request request){         
        String requestName = getRegisteredName(request);
        return ([SELECT COUNT() FROM User WHERE Name =: requestName] > 0);
    }
    // END CSM-13811 Jerome To Checking of Name should be First Name, Middle Name and Last Name
	@TestVisible
    private static CXE_CP_SplashPageSelfRegistration_CC.Request createReq(String email, String firstname, String middlename, 
                                                                           String lastname, String suffix, String mobile, 
                                                                           String sin, Decimal amount, Date transactionDate, Boolean isNew){           
        CXE_CP_SplashPageSelfRegistration_CC.Request req = new CXE_CP_SplashPageSelfRegistration_CC.Request();
        req.email = email;
        // Lisen CSM-14045 20171022
        req.firstname = firstname.trim();
        req.middlename = String.isBlank(middlename)?'':middlename.trim();
        req.lastname = lastname.trim();
        req.suffix = String.isBlank(suffix)?'':suffix.trim();
        // Lisen CSM-14045 20171022
        req.mobileNumber = mobile;
        req.sin = sin;
        req.amount = amount;
        req.transactionDate = transactionDate;
        req.isNew = isNew;
        return req;
    }

    // CSM-10811 As a system, I want to display an error message when the customer is enrolling for a Prepaid SIN during registration
    // show error "Prepaid SINs are not allowed to be enrolled in a portal account for this release"
    private static SINWrapper validateSIN(CXE_CP_SplashPageSelfRegistration_CC.Request request, List<Agreement__c> serviceList) {

        if(serviceList.isEmpty()) {
            return new SINWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_INACTIVE);
        } else {
            Agreement__c service = serviceList.get(0);
            // START CSM-13715 Jerome TO Added Code Segment 10/05/17
            Set<String> cbgEmailFilters = new Set<String> {CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP001, CXE_Constants.SERVICE_CODE_SEGMENT_1};


            // END CSM-13715 Jerome TO Added Code Segment 10/05/17
            //START CSM-11518 Jerome To 09/05/2017
            // commented out
            //if(service.Payor__c == null) {
            //    return new SINWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_BLANK_PAYOR);
            //}
            //END CSM-11518 Jerome To 09/05/2017

            // CSM-10811 As a system, I want to display an error message when the 
            //           customer is enrolling for a Prepaid SIN during registration
            if(service.Payor__r.Type__c == CXE_Constants.CONTRACT_TYPE_PREPAID) {
                return new SINWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_PREPAID);
            }
            // CSM-10769 As a system, I want to display an error message containing to 
            //           RM of that SIN when a customer is self-registering for a CBG account
           
            // START CSM-13715 Jerome TO Added Code Segment filter 10/05/17
            //if(service.Payor__r.Account.Conglomerate__c) {
            
            // ** CSM-14887 - JIntal [12/15/17] 
            if(service.Related_Account__c != null){
                return new SINWrapper(CXE_Constants.SERVICE_ENROLLMENT_SIN_RES); 
            }
            // ** CSM-14887 - JIntal [12/15/17] 
            
            // CSM-10757 As a system, I want to display an error message when the customer 
            //           is enrolling for a Retailer SIN during registration
            // START CSM-14072 Jerome To 11.09.2017
            //if(service.Related_Account__c != null) {
            if(service.Payor__r.Account.Retail_Electricity_Supplier__c) {        
            // END CSM-14072 Jerome To 11.09.2017        
                return new SINWrapper(String.format(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_RES, new List<String>{ service.Payor__r.Account.Owner.Name }));
            }

            // START CSM-14944 Lisen
            if(cbgEmailFilters.contains(service.Code_Segment__c)){
            // END CSM-13715 Jerome TO Added Code Segment 10/05/17
                sendEmailTOCBGRM(request, service); // CSM-12187 Jerome To
                return new SINWrapper(String.format(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_CBG_ACCOUNT, new List<String>{ service.Payor__r.Account.Owner.Name }));
            }
            // END CSM-14944 Lisen

            // CSM-10823
            if(hasBeenRegisteredTwice(service.Id)) {
                // Start R2C CSM-14323 Von Pernicia 11/9/2017
                return new SINWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_ENROLLED_TWICE);// CSM-14153 CORBES MELVIN  10/28/2017
                //return new SINWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_ENROLLED_TWICE_REGISTRATION);
                // End R2C CSM-14323 Von Pernicia 11/9/2017
            }


            //START CSM-12464 Jerome To comment this code
            //if(!service.Payor__r.Account.IsPersonAccount) {                
            //    return new SINWrapper(false, createCaseForBusiness(request, service));
            //}
            //END CSM-12464 Jerome To
            

            return new SINWrapper(null);
        }        
    }

    private static String createCaseForBusiness(CXE_CP_SplashPageSelfRegistration_CC.Request request, Agreement__c service){
        try{
            Id recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND IsActive = true AND DeveloperName =:CXE_Constants.CASE_RECORD_TYPE_BUSINESS_SELF_REGISTRATION].Id;
            Case caseRecord =  new Case();
            caseRecord.Email_Address__c = request.email;
            caseRecord.Business_Email__c = service.Payor__r.Account.Owner.Email; //CSM-12447 GGrandea 09.06.2017
            caseRecord.First_Name__c = request.firstname;
            caseRecord.Middle_Name__c = request.middlename;
            caseRecord.Last_Name__c = request.lastname;
            caseRecord.Mobile_No__c = request.mobileNumber;
            caseRecord.CXE_Service__c = service.Id;
            if(!request.isNew){
                caseRecord.Total_kWh__c = request.amount;
                caseRecord.Bill_Date__c = request.transactionDate;
            } else {
                caseRecord.Bill_Deposit_Amount__c = request.amount;
                caseRecord.Payment_Date__c = request.transactionDate;
            }            
            caseRecord.RecordTypeId = recordTypeId;
            caseRecord.CXE_isRegistrationCase__c = true;
            caseRecord = populateIROandRO(service, caseRecord); // CSM-10769 Jerome To 08/10/2017
            // START CSM-13756 Jerome To 10/17/2017 [R2B SQT] Email to Biz RM that a case is created for appropriate action.
            caseRecord.AccountId = service.Payor__r.AccountId;
            // END CSM-13756 Jerome To 10/17/2017 [R2B SQT] Email to Biz RM that a case is created for appropriate action.
            // START CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
            Id contactId = CXE_CP_PortalUtility.getCurrentUserContacId();
            if(contactId != null){
                caseRecord.ContactId = contactId;
            }
            // END CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
            insert caseRecord;
            

            return [SELECT CaseNumber FROM Case WHERE Id=:caseRecord.Id].CaseNumber;
        } catch (DmlException e) {
            throw e;
        }
    } 

    //START CSM-12211 RReyes AUG-03-17
    // START CSM-13917 Jerome To Updates on existing contact/Person Account Email or Mobile Number upon registration. 10/16/2017
    private static String getNonPayorContactId(CXE_CP_SplashPageSelfRegistration_CC.Request request){
        /*List<Contact> contactList = [SELECT Id, Account.IsCustomerPortal
                                            FROM Contact 
                                            WHERE FirstName =: request.firstname
                                            AND MiddleName =: request.middlename
                                            AND LastName =: request.lastname];*/ //CSM-13946 GGrandea 10.19.2017 remove code

    // END CSM-13917 Jerome To Updates on existing contact/Person Account Email or Mobile Number upon registration. 10/16/2017
        //Boolean createNewAccount = false; //CSM-13946 GGrandea 10.19.2017 remove code
        String contactId = null;
        //START CSM-13946 GGrandea 10.19.2017 remove code
        /*if(contactList == null){
            createNewAccount = true;
        }else{
            if(contactList.size() == 1){
                contactId = contactList[0].Id;
            }else{
                createNewAccount = true;
            }
        }

        if(createNewAccount){*/ //END CSM-13946 GGrandea 10.19.2017 remove code
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
                ErrorHandlerException.recordException(null, true, 'CXE_CP_SplashPageSelfRegistration_CC', 'getNonPayorContactId', e);
            }
        //} //CSM-13946 10.19.2017
        return contactId;
    }

    //END CSM-12211 RReyes AUG-03-17
    // CSM-12187 Jerome To added Payor__r.Account.Owner.Email
    private static List<Agreement__c> getSIN(String serviceIdNumber) {
        // Start CSM-12889 Jerome To Added listStatus and Updated query to filter listStatus
        List<String> listStatus = new List<String> {CXE_Constants.SERVICE_STATUS_ACTIVE, 
                                                    CXE_Constants.SERVICE_STATUS_ACTIVE_PENDING_TO_DISCONNECT,
                                                    CXE_Constants.SERVICE_STATUS_ACTIVE_DISCONNECTED}; //13983 GGrandea 10.19.2017

        // START CSM-12211 RReyes AUG-03-17 - added Payor__r.Account.PersonContactId
        // START CSM-13715 Jerome TO Added Code Segment 10/05/17
        //START CSM-14795 RReyes DEC-26-17 - added Payor__r.Account.OwnerId
        return [SELECT Id,Payor__r.Type__c, Account__c, Payor__r.Account.Conglomerate__c, Payor__r.V10_Account_No__c, 
                       Payor__r.Account.Owner.Name, Related_Account__c, Payor__c, Payor__r.Account.IsPersonAccount, Payor__r.Account.FirstName, 
                       Payor__r.Account.MiddleName, Payor__r.Account.LastName, Payor__r.Account.Name, Payor__r.Account.PersonContactId,
                       Case__c, Case__r.Initial_Responsible_Office__c, Case__r.Responsible_Office_Lookup__c, Payor__r.AccountId,
                       Payor__r.Account.Owner.Email, Code_Segment__c,
                       Payor__r.Account.IsCustomerPortal, //CSM-13946 10.18.2017
                       Payor__r.Account.Retail_Electricity_Supplier__c, // CSM-14072 Jerome To 11/09/2017
                       
                       // Start R2C CSM-15172 Von Pernicia 1/18/18: Added the following fields
                       Payor__r.Account.OwnerId,
                       Contract__r.Account.Owner.LastName,
                       Contract__r.Account.Name,
                       Contract__r.Account.Owner.Name,
                       Contract__r.Account.Owner.Email,
                       Contract__r.AccountId,
                       Contract__r.Account.IsPersonAccount,
                       Contract__r.Account.PersonContactId,
                       Contract__r.Account.OwnerId
                       // End R2C CSM-15172 Von Pernicia 1/18/18: Added the following fields

                FROM Agreement__c 
                WHERE SIN__c =:serviceIdNumber 
                AND Service_Status__c IN:listStatus];
        //END CSM-14795 RReyes DEC-26-17 - added Payor__r.Account.OwnerId
        // END CSM-13715 Jerome TO Added Code Segment 10/05/17
        //END CSM-12211 RReyes AUG-03-17 - added Payor__r.Account.PersonContactId
        // END CSM-12889 Jerome To Added listStatus and Updated query to filter listStatus
    }

    //START Updates CSM-12461 GGrandea 09.12.2017
    //private static List<Agreement__c> getRelatedServices(String accountId) {
    private static List<Agreement__c> getRelatedServices(Id payorId) {
        return [SELECT Id,Payor__r.Type__c, Payor__r.Account.Conglomerate__c, Payor__r.Account.Owner.Name, 
                       Related_Account__c, Payor__c, Payor__r.Account.IsPersonAccount, Payor__r.Account.FirstName, 
                       Payor__r.Account.MiddleName, Payor__r.Account.LastName, Payor__r.Account.Name 
                FROM Agreement__c 
                //WHERE Payor__r.AccountId =:accountId];
                WHERE Payor__c =:payorId //]; //CSM-12461 //13983 GGrandea 10.19.2017
                AND Service_Status__c !=:CXE_Constants.SERVICE_STATUS_PENDING]; //13983 GGrandea 10.19.2017
    }
    //END Updates CSM-12461 GGrandea 09.12.2017

    private static CXE_Service_Enrollment__c createServiceEnrollment(CXE_CP_SplashPageSelfRegistration_CC.Request request, Agreement__c service, Id userId) {
        CXE_Service_Enrollment__c serviceEnrollment = new CXE_Service_Enrollment__c();
        serviceEnrollment.CXE_ServiceId__c = service.Id;
        serviceEnrollment.CXE_UserId__c = userId;
        serviceEnrollment.CXE_IsActive__c = true;
        serviceEnrollment.CXE_Type__c = (isPayor(request, service) ? CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR : CXE_Constants.SERVICE_ENROLLMENT_TYPE_NON_PAYOR);
        return serviceEnrollment;
    }

    private static void createServiceEnrollmentList(CXE_CP_SplashPageSelfRegistration_CC.Request request, Agreement__c service, Id userId) {
        List<CXE_Service_Enrollment__c> serviceEnrollmentList = new List<CXE_Service_Enrollment__c>();
        List<Agreement__c> relatedServices = new List<Agreement__c>();
        if(isPayor(request, service)) {
            //START CSM-12461 GGrandea 09.12.2017
            //relatedServices = getRelatedServices(service.Payor__r.AccountId);
            relatedServices = getRelatedServices(service.Payor__c);
            //END CSM-12461 GGrandea 09.12.2017
        }  else {
            relatedServices.add(service);
        } 
        for(Agreement__c serviceRecord : relatedServices) {
            serviceEnrollmentList.add(createServiceEnrollment(request, serviceRecord, userId));
        } 
        
        insert serviceEnrollmentList;

        
        
        /*if(!serviceEnrollmentList.isEmpty()) {
            updateUserForEnrolledServices(userId, serviceEnrollmentList);
        }*/
    }

    private static Boolean isPayor(CXE_CP_SplashPageSelfRegistration_CC.Request request, Agreement__c service) {
        // START CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017
        return isRegisteredNameSameAsAccountName(request, service);
        // END CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017
       //return (request.firstname == service.Payor__r.Account.FirstName && request.lastname == service.Payor__r.Account.LastName);
    }

    // CSM-10787 No Bill Date
    public static BillWrapper validateBillingOrPayment(CXE_CP_SplashPageSelfRegistration_CC.Request request, List<Agreement__c> serviceList) {

        //CSM-11340
        if(!request.isNew) {
            //CSM-10787
            // START CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017
            return validateBilling(request, serviceList.get(0));
            // END CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017
        } else if(!serviceList.isEmpty()){
            return validatePayment(request, serviceList.get(0));
        }

        return new BillWrapper(false);
    }

    
    // START CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017
    //CSM-11340
    //private static BillWrapper validateBilling(CXE_CP_SplashPageSelfRegistration_CC.Request request) {
    private static BillWrapper validateBilling(CXE_CP_SplashPageSelfRegistration_CC.Request request, Agreement__c service) {
        List<CXE_Heroku_Model.BillDetail> billingDetails = getBillingDetails(request, service.Payor__r.V10_Account_No__c);
    // END CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017
        Set<String> errorMsgs = new Set<String>();
        List<String> errors = new List<String>();

        if(!billingDetails.isEmpty()) {

            // CSM-14105 Lisen 20171026
            Date firstDayLast2Months = Date.Today().addMonths(-2).toStartofMonth();

            for(Integer i = 0; i < billingDetails.size(); i++) {
                // Start CSM-12850 Jerome To 9/20/2017 Added null checking on billDate and billUsage
                // START CSM-12920 Jerome To 9/25/2017 Changed bill_date to gen_date
                //if(i < 2 && String.isNotBlank(billingDetails.get(i).bill_usage) && String.isNotBlank(billingDetails.get(i).gen_date)) { 
                if(String.isNotBlank(billingDetails.get(i).bill_usage) && String.isNotBlank(billingDetails.get(i).gen_date)) { 
                    // End CSM-12850 Jerome To 9/20/2017 Added null checking on billDate and billUsage
                    CXE_Heroku_Model.BillDetail bill = billingDetails.get(i);
                    decimal consumption = Decimal.valueOf(bill.bill_usage);
                    Date transactionDate = Date.valueOf(bill.gen_date); 
                    String billType = bill.bill_type;
                // END CSM-12920 Jerome To 9/25/2017 Changed bill_date to gen_date
                    if(firstDayLast2Months < transactionDate){
                        if(request.amount == consumption && request.transactionDate != transactionDate) {
                        // invalid Date
                        //CSM-10733
                            errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_BILL_DATE);
                        } else if(request.transactionDate == transactionDate && request.amount != consumption) {
                            // invalid amountOrConsumption
                            //CSM-10787
                            errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_TOTAL_KWH);
                        } else if (request.transactionDate == transactionDate && request.amount == consumption){
                            // CSM-14105 Lisen 20171026
                            if(billType == 'Deposit'){
                                errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_EXISTING_BOTH_KWH_AND_BILL_DATE);
                            }else{
                                return new BillWrapper(false);
                            }
                        }                    
                    }
                }
            }
            // CSM-14105 Lisen 20171026

            // Jerome To CSM-12315 08/23/2017
            if(!errorMsgs.isEmpty()) {
                errors.addAll(errorMsgs);
                return new BillWrapper(errors);
            }
        }else{
            
            
        }

        //START CSM-14090 GGrandea 10.25.2017
        /*errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_BILL_DATE);
        errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_TOTAL_KWH);*/
        errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_EXISTING_BOTH_KWH_AND_BILL_DATE);
        //END CSM-14090
        
        errors.addAll(errorMsgs);
        return new BillWrapper(errors);
    }

    private static BillWrapper validatePayment(CXE_CP_SplashPageSelfRegistration_CC.Request request, Agreement__c service) {
        // START CSM-13974 Jerome To 10/18/2017
        Set<String> errorMsgs = new Set<String>();
        List<String> errors = new List<String>();
        List<CXE_Heroku_Model.BillDetail> billingDetails = getBillingDetails(request, service.Payor__r.V10_Account_No__c);

        // start of  CSM-14038 Corbes Melvin 10/20/2017
        if(!billingDetails.isEmpty()){
            for(Integer i = 0; i < billingDetails.size(); i++) {
                if(billingDetails[i].bill_type != CXE_Constants.HEROKU_BILL_TYPE_TFGEN10006){
                    errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_HAS_EXISTING_BILLING_RECORD); 
                    errors.addAll(errorMsgs);
                    break;
                }
            }

            if(errors.size() > 0){
                return new BillWrapper(errors);
            }
        }
        // //end of CSM-14038 Corbes Melvin 10/20/2017
        

        List<CXE_Heroku_Model.PaymentDetail> paymentDetails = getPaymentDetails(service, request); //CSM-12517 added 'request' parameter
        
        if(!paymentDetails.isEmpty()) {
            for(Integer i = 0; i < paymentDetails.size(); i++) {
                if(i < 2) {
                    CXE_Heroku_Model.PaymentDetail paymentDetail = paymentDetails.get(i);
                    //decimal amount = Decimal.valueOf(paymentDetail.payment.paid_amount); //CSM-12437 Emandolado 9/5/2017
                    //Date transactionDate = Date.valueOf(paymentDetail.payment.payment_date);
		    Date transactionDate = Date.valueOf(paymentDetail.paymentDate);
                    System.debug('>>>>>>>> Date :' + request.transactionDate);

                    if(request.amount == paymentDetail.paidAmount && request.transactionDate != transactionDate) { //CSM-12437 Emandolado 9/5/2017
                        errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_PAYMENT_DATE);
                    } else if(request.transactionDate == transactionDate && request.amount != paymentDetail.paidAmount) { //CSM-12437 Emandolado 9/5/2017
                        errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_BILL_DEPOSIT_AMT);
                    } else if (request.transactionDate == transactionDate && request.amount == paymentDetail.paidAmount){ //CSM-12437 Emandolado 9/5/2017
                        return new BillWrapper(false);
                    }                    
                }
            }
            // Jerome To CSM-12315 08/23/2017
            if(!errorMsgs.isEmpty()) {
                errors.addAll(errorMsgs);
                return new BillWrapper(errors);
            }
        }

        //START CSM-14090 GGrandea 10.25.2017
        /*errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_PAYMENT_DATE);
        errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_BILL_DEPOSIT_AMT);*/
        errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_NEW_BOTH_BILLDEPOSIT_AND_PAYMENT_DATE);
        //END CSM-14090
       
        errors.addAll(errorMsgs);
        return new BillWrapper(errors);
        // END CSM-13974 Jerome To 10/18/2017
    }



    ////CSM-10787
    //private static Boolean hasMatchingBillingDate(CXE_CP_SplashPageSelfRegistration_CC.Request request, List<CXE_Heroku_Model.BillDetail> billingDetails) {
    //    for(Integer i = 0; i < 2; i++) {
    //        if(Date.valueOf(billingDetails.get(i).billingDate) == request.transactionDate) {
    //            return true;
    //        }
    //    }
    //    return false;
    //}

    // START CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017
    private static List<CXE_Heroku_Model.BillDetail> getBillingDetails(CXE_CP_SplashPageSelfRegistration_CC.Request request, String acctNo) {
        //private static List<CXE_Heroku_Model.BillDetail> getBillingDetails(CXE_CP_SplashPageSelfRegistration_CC.Request request) {
        return CXE_HerokuApps.getAllBillsBySingleSin(request.SIN); // CSM-14105 Lisen 20171026
        // CSM-14105 Lisen 20171026 //return CXE_HerokuApps.getAllBillsByAcctNoAndSinNo(request.SIN, acctNo);
    }
    // END CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017

    //START CSM-12517 MVerdad 09.14.2017 - added 'request' parameter
    private static List<CXE_Heroku_Model.PaymentDetail> getPaymentDetails(Agreement__c service
                                                                        , CXE_CP_SplashPageSelfRegistration_CC.Request request) {
        // START CSM-13950 Jerome To 10/18/2017 remove this line of codes
        //START CSM-12592 GGrandea 09.15.2017
        //Date startDate = Date.today();
        //Date endDate = startDate.addMonths(-2);
        Date endDate = request.transactionDate.addMonths(1);
        Date startDate = request.transactionDate.addMonths(-1);
        // END CSM-13950 Jerome To 10/18/2017 remove this line of codes
        //return CXE_HerokuApps.getAllPaymentsBySingleAcctNo(service.Payor__r.V10_Account_No__c, request.transactionDate);
        return CXE_HerokuApps.getAllPaymentsBySingleAcctNo(service.Payor__r.V10_Account_No__c, startDate, endDate); // CSM-12603 Jerome To 09/18/2017 Switch endDate and StartDate
        //END CSM-12592 GGrandea 09.15.2017
    }
    //END CSM-12517 MVerdad 09.14.2017

    ////CSM-10733
    //private static Boolean hasValidAmountAndBillingDate(CXE_CP_SplashPageSelfRegistration_CC.Request request, List<CXE_Heroku_Model.BillDetail> billingDetails) {
    //    for(Integer i = 0; i < 2; i++) {
    //        if(Date.valueOf(billingDetails.get(i).billingDate) == request.transactionDate && Decimal.valueOf(billingDetails.get(i).billTotalAmount) == request.amount) {
    //           return true;
    //        }
    //    }
    //    return false;
    //}

    // CSM-10769 Jerome To 08/10/2017
    private static void updateAccountCBGRMEmail(Agreement__c service) {
        try {
            List<Account> acctList = [SELECT CXE_trigger_CBG_RM_email__c FROM Account WHERE Id =:service.Payor__r.AccountId];
            if(!acctList.isEmpty()) {
                acctList.get(0).CXE_trigger_CBG_RM_email__c = true;
                update acctList;
            }
        }
        catch (DmlException e) {
            ErrorHandlerException.recordException(null, true, 'CXE_CP_SplashPageSelfRegistration_CC', 'updateAccountCBGRMEmail', e);
        }
    }


    // CSM-10769 Jerome To 08/10/2017
    private static Case populateIROandRO(Agreement__c service, Case caseRecord) {
        // Case__c, Case__r.Initial_Responsible_Office__c, Case__r.Responsible_Office_Lookup__c
        if(service.Case__c != null) {
            caseRecord.Initial_Responsible_Office__c = service.Case__r.Initial_Responsible_Office__c;
            caseRecord.Responsible_Office_Lookup__c = service.Case__r.Responsible_Office_Lookup__c;
        } else {
            List<Address__c> serviceAddressList = [SELECT Address_City_Municipality__r.Name FROM Address__c WHERE Service__c =:service.Id AND Type__c =:CXE_Constants.ADDRESS_TYPE_SERVICE];
            if(!serviceAddressList.isEmpty()) {
                caseRecord.Initial_Responsible_Office__c = getInitialResponsibleOffice(serviceAddressList.get(0).Address_City_Municipality__r.Name);
            }
        }
        return caseRecord;
    }
    // CSM-10769 Jerome To 08/10/2017
    private static String getInitialResponsibleOffice(String cityAddress) {
        String responsibleOfficeString = '';
        if(String.isNotBlank(cityAddress)) {
            List<Reference__c> ref = [SELECT Id FROM Reference__c 
                                     WHERE Name =:cityAddress
                                     AND Field__c =:CXE_Constants.REFERENCE_FIELD_CITY];

            if(!ref.isEmpty()) {
                Set<String> responsibleOfficeList = new Set<String>();
                Set<Id> officeIds = new Set<Id>();

                for( Office_Jurisdiction__c oj : [SELECT  Id, Office__r.Name, Office__r.RecordType.Name, 
                                                          Street_Name__c, City__c, Office__c
                                                  FROM    Office_Jurisdiction__c 
                                                  WHERE   City__c =:ref.get(0).Id
                                                  AND     Office__r.RecordType.Name =:CXE_Constants.RECORD_TYPE_NAME_OFFICE_HMB]) {
                    
                    if(!officeIds.contains(oj.Office__c)){
                        responsibleOfficeList.add(oj.Office__r.Name);
                        officeIds.add(oj.Office__c);
                    }
                }

                if(!responsibleOfficeList.isEmpty()) {                    
                    for(String s: responsibleOfficeList){
                        responsibleOfficeString += s+',';
                    }                    
                    responsibleOfficeString = responsibleOfficeString.subString(0, responsibleOfficeString.length() - 1);
                }
            }
        }
        return responsibleOfficeString;
    }
        
    //Getting Custom Settings url link for Terms and Conditions
    @AuraEnabled
    public static String getHiearchySettings(){
        return OrganizationSettings__c.getOrgDefaults().Terms_And_Conditions_Link__c;
    }

    // CSM-12187 Jerome To
    @AuraEnabled
    public static void sendEmailTOCBGRM(CXE_CP_SplashPageSelfRegistration_CC.Request request, Agreement__c service) {

        List<EmailTemplate> emailTemplates = new List<EmailTemplate>([SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName = :CXE_Constants.CBG_RM_EMAIL_TEMPLATE]);
        List<OrgWideEmailAddress> owas = new List<OrgWideEmailAddress>([SELECT id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address=:CXE_Constants.ORG_WIDE_ADDRESS]);
        // Start CSM-12462 Jerome To Added negation (!)
        if(!emailTemplates.isEmpty() && !owas.isEmpty()) {
            // End CSM-12462 Jerome To Added negation (!)
            EmailTemplate emailTemplate = emailTemplates.get(0);
            OrgWideEmailAddress owa = owas.get(0);
            List<String> fullname = new List<String>();
            fullname.add(request.firstname);
            fullname.add(request.middlename);
            fullname.add(request.lastname);

            // grab the email template
            
            // process the merge fields
            String subject = emailTemplate.Subject;

            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{CustomerName}', String.join(fullname, ' '));
            htmlBody = htmlBody.replace('{SIN}', request.SIN);
            // Start R2C CSM-15172 Von Pernicia 1/18/18: Change from Payor__r to Contract__r
            htmlBody = htmlBody.replace('{AccountName}', service.Contract__r.Account.Name);
            htmlBody = htmlBody.replace('{AccountOwner}', service.Contract__r.Account.Owner.LastName);
            // End R2C CSM-15172 Von Pernicia 1/18/18: Change from Payor__r to Contract__r

            //build the email message
            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();

            //email.setInReplyTo(owa.Address);
            //email.setSenderDisplayName(owa.DisplayName);
            //email.setTargetObjectId(service.Payor__r.AccountId);
            email.setOrgWideEmailAddressId(owa.Id);
            // Start R2C CSM-15172 Von Pernicia 1/18/18: Change from Payor__r to Contract__r
            email.setToAddresses(new List<String>{ service.Contract__r.Account.Owner.Email } ); 
            // End R2C CSM-15172 Von Pernicia 1/18/18: Change from Payor__r to Contract__r
            email.setSaveAsActivity(true);
            email.setSubject(subject);
            email.setHtmlBody(htmlBody);

            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});
        }

        // Start R2C CSM-15172 Von Pernicia 1/18/18: Change from Payor__r to Contract__r
        //START CSM-14795 RReyes DEC-26-17 - create task
        Task taskToCreate = new Task();
        if(service.Contract__r.AccountId != null){
            Id contactId;
            if(service.Contract__r.Account.IsPersonAccount){
                if(service.Contract__r.Account.PersonContactId != null){
                    contactId = service.Contract__r.Account.PersonContactId;
                }
            }else{
                List<Contact> contactList = [SELECT Id FROM Contact WHERE AccountId=:service.Contract__r.AccountId LIMIT 1];
                if(contactList != null){
                    if(!contactList.isEmpty()){
                        contactId = contactList[0].Id;
                    }
                }
            }

            taskToCreate = CXE_Utility.taskCreation(
                                Date.today(),
                                CXE_Constants.PORTALUSER_NOTIF_EMAIL,
                                CXE_Constants.CASE_SERVICE_APPLICATION,
                                service.Contract__r.Account.OwnerId,
                                CXE_Constants.TASK_PRIORITY_NORMAL,
                                CXE_Constants.TASK_STATUS_COMPLETED,
                                service.Contract__r.AccountId, //START/END CSM-14972 RReyes DEC-27-17
                                'CBG Customer Enrollment in Meralco Online', //START/END CSM-14976 RReyes DEC-27-17
                                contactId);
            if(taskToCreate != null){
                insert taskToCreate;
            }
        }
        //END CSM-14795 RReyes DEC-26-17 - create task
        // End R2C CSM-15172 Von Pernicia 1/18/18: Change from Payor__r to Contract__r
    }

    /*private static void updateUserForEnrolledServices(Id userId, List<CXE_Service_Enrollment__c> serviceEnrollmentList){
        //if(serviceEnrollmentList.size() > 1){
            User myUser = new User();
            myUser.Id = userId;
            myUser.CXE_Auto_Enrolled_Services__c = true;
            //update myUser;
        //}
    }*/

    //START CSM-12461 GGrandea 09.12.2017
    private static Boolean hasRelatedServices(Id payorId, Id serviceId) {
        return  ( [SELECT Id FROM Agreement__c 
                    WHERE Payor__c=:payorId AND Id != :serviceId].size() > 0 ) ;
    }
    //END CSM-12461 GGrandea 09.12.2017

    // START CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017
    private static CXE_CP_SplashPageSelfRegistration_CC.Response createPortalUser(CXE_CP_SplashPageSelfRegistration_CC.Request request, Agreement__c service) {

        Id communityProfileId = [SELECT Id FROM Profile WHERE Name=:CXE_Constants.PORTAL_COMMUNITY_PROFILE LIMIT 1].Id;
        User u = new User();
        u.Username = request.email;
        u.Email = request.email;
        u.FirstName = request.firstname;
        u.MiddleName = request.middlename;
        u.LastName = request.lastname;
        u.MobilePhone = request.mobileNumber;
        u.Suffix = request.suffix;

        //START CSM-13946 GGrandea 10.18.2017 use email for User nickname
        /*String nickname = (String.isNotBlank(request.firstname) ? request.firstname.substring(0,1) : '' ) + (String.isNotBlank(request.lastname) ? request.lastname.substring(0,1) : '' );
        nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);

        u.CommunityNickname = nickname;*/
        u.CommunityNickname = request.email;
        //END CSM-13946
        
        String contactId  = getContactId(request, service);
        if(String.isNotBlank(contactId)) {
            u.ContactId = contactId;
        } else {
            return new CXE_CP_SplashPageSelfRegistration_CC.Response(false, CXE_Constants.DUPLICATE_CONTACT);
        }

        if(isRegisteredNameSameAsAccountName(request, service)){            
            u.CXE_Auto_Enrolled_Services__c = hasRelatedServices(service.Payor__c, service.Id);
        }
        
        u.Alias = request.firstname.substring(0,1)+(request.lastname.length()>7? request.lastname.substring(1,7) : request.lastname );
        u.TimeZoneSidKey = CXE_Constants.PORTALUSER_TIMEZONESIDKEY;
        u.LocaleSidKey = CXE_Constants.PORTALPORTALUSER_LOCALESIDKEY;
        u.EmailEncodingKey = CXE_Constants.PORTALUSER_EMAILENCODINGKEY;
        u.LanguageLocaleKey = CXE_Constants.PORTALUSER_LANGUAGELOCALEKEY;
        u.ProfileId = communityProfileId;
        u.IsActive = true;
        u.By_Pass_Validation__c = True;
        u.Initial_Service_ID__c = request.sin; // CSM-13904 Lisen 20171014
        insert u;

        return new CXE_CP_SplashPageSelfRegistration_CC.Response(true, CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL);
        //String userId = u.Id;
        //if(String.isNotBlank(userId)) {
        //    //createServiceEnrollmentList(request, service, userId);            
        //}
    }

    private static String getContactId(CXE_CP_SplashPageSelfRegistration_CC.Request request, Agreement__c service) {
        List<Contact> contactList = [SELECT Id, CXE_isPortalContact__c, Mobile_1__c,
                                            MobilePhone, Email_1__c
                                     FROM Contact 
                                     WHERE FirstName =: request.firstname
                                     AND MiddleName =: request.middlename
                                     AND LastName =: request.lastname
                                     AND AccountId =: service.Payor__r.AccountId];
        String contactId = '';
        if(contactList.isEmpty()){
            try{

                Contact conRec = new Contact();
                conRec.FirstName = request.firstname;
                conRec.LastName = request.lastname;
                conRec.MiddleName = request.middlename;
                conRec.Email = request.email;
                conRec.MobilePhone = request.mobileNumber;
                conRec.Mobile_1__c = request.mobileNumber;
                conRec.Suffix = request.suffix;
                conRec.OwnerId = OrganizationSettings__c.getOrgDefaults().Default_Account_Owner__c;
                conRec.AccountId = service.Payor__r.AccountId;
                insert conRec;

                contactId = conRec.Id;

            }catch (Exception e){
                ErrorHandlerException.recordException(null, true, 'CXE_CP_SplashPageSelfRegistration_CC', 'getContactId', e);
            }
        } else {
            // START CSM-13917 Jerome To Updates on existing contact/Person Account Email or Mobile Number upon registration. 10/16/2017
            Contact updateContact = new Contact();

            for(Contact conRec : contactList) {
                if(!conRec.CXE_isPortalContact__c) {
                    updateContact = conRec;
                    contactId = conRec.Id;
                    break;
                }
            }
            //START CSM-13946 GGrandea 10.18.2017
            if(String.isNotBlank(contactId)){
                updateContact.Id = contactId;
                updateContact.Email_1__c = request.email;
                updateContact.MobilePhone = request.mobileNumber;
                updateContact.Mobile_1__c = request.mobileNumber;            
                update updateContact;
            }
            //END CSM-13946
            // END CSM-13917 Jerome To Updates on existing contact/Person Account Email or Mobile Number upon registration. 10/16/2017
        }
        return contactId;
    }

    private static Boolean isRegisteredNameSameAsAccountName(CXE_CP_SplashPageSelfRegistration_CC.Request request, Agreement__c service) {
        // START CSM-13811 Jerome To 10/10/2017
        String requestName = getRegisteredName(request);       
        return requestName.equalsIgnoreCase(service.Payor__r.Account.Name);
        // END CSM-13811 Jerome To 10/10/2017
    }

    // START CSM-13811 Jerome To 10/10/2017
    private static String getRegisteredName(CXE_CP_SplashPageSelfRegistration_CC.Request request) {
        List<String> requestName = new List<String>();

        if(String.isNotBlank(request.firstname)) {
            requestName.add(request.firstname);
        } 

        if(String.isNotBlank(request.middlename)) {
            requestName.add(request.middlename);
        } 

        if(String.isNotBlank(request.lastname)) {
            requestName.add(request.lastname);
        } 
       
        return String.join(requestName, ' ');
    }
    // END CSM-13811 Jerome To 10/10/2017
    // END CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017

}