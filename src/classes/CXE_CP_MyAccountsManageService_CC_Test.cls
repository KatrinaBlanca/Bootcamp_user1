@isTest
public class CXE_CP_MyAccountsManageService_CC_Test {
    /*
    @testSetup static void setup(){
        //HMB Portal Data
        CXE_TestDataFactory.setupPortalData('2');
    }
    
    @isTest
    static void test_EnrollServiceSinAlreadyEnrolled(){
        
        Test.startTest();
        User adminUser = CXE_TestDataFactory.createAdminUser();
        insert adminUser;
        
        User userAd = [SELECT Id FROM User Where email='bruce.wayne@wayneenterprises.com'];
        System.runAs(userAd){
            //Register for a Portal Account
            List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
            try{
                if(!portalUsers.isEmpty()) {
                    System.runAs(portalUsers.get(0)){
                        String email = 'cxe_testuser2@test.com';
                        String fName = 'mfNametc2';
                        String mName = 'mmNametc2';
                        String lName = 'mlNametc2';
                        String suffix = '';
                        String mobile = '+639999999999';
                        String sin = '293028374839';
                        Decimal amt = 300;
                        String txnDate = '2017-10-15';
                        CXE_CP_SplashPageSelfRegistration_CC.Response response = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                        System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL, response.message);
                        
                    }             
                }
            } catch (Exception e) {
                System.assertEquals('', e.getMessage());
            }
        }
        
        //Enroll Service 
        User userPortal = [SELECT Id, Email FROM User Where email='cxe_testuser2@test.com'];
        System.assertEquals('cxe_testuser2@test.com', userPortal.email);
        System.runAs(userPortal){
            
            String sin = '293028374839';
            Decimal amt = 300;
            String txnDate = '2017-10-15';
			
            //This SIN is already enrolled to your portal account
            CXE_CP_MyAccountsManageService_CC.Response resp = CXE_CP_MyAccountsManageService_CC.enrollService(sin, amt, txnDate, false);
            System.assertEquals(CXE_Constants.SERVICE_ENROLLMENT_SIN_ALREADY_ENROLLED, resp.message);
            
            CXE_CP_MyAccountsManageService_CC.Response resp1 = CXE_CP_MyAccountsManageService_CC.enrollService(sin, amt, txnDate, true);
            System.assertEquals(CXE_Constants.SERVICE_ENROLLMENT_SIN_ALREADY_ENROLLED, resp1.message);
            
        }
        Test.stopTest();
    }
    
    @isTest
    static void test_EnrollServiceSinLengthError(){
        
        Test.startTest();
        User adminUser = CXE_TestDataFactory.createAdminUser();
        insert adminUser;
        
        User userAd = [SELECT Id FROM User Where email='bruce.wayne@wayneenterprises.com'];
        System.runAs(userAd){
            //Register for a Portal Account
            List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
            try{
                if(!portalUsers.isEmpty()) {
                    System.runAs(portalUsers.get(0)){
                        String email = 'cxe_testuser2@test.com';
                        String fName = 'mfNametc2';
                        String mName = 'mmNametc2';
                        String lName = 'mlNametc2';
                        String suffix = '';
                        String mobile = '+639999999999';
                        String sin = '293028374839';
                        Decimal amt = 300;
                        String txnDate = '2017-10-15';
                        CXE_CP_SplashPageSelfRegistration_CC.Response response = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                        System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL, response.message);
                    }             
                }
            } catch (Exception e) {
                System.assertEquals('', e.getMessage());
            }
        }
        
        //Enroll Service 
        User userPortal = [SELECT Id, Email FROM User Where email='cxe_testuser2@test.com'];
        System.assertEquals('cxe_testuser2@test.com', userPortal.email);
        System.runAs(userPortal){
            
            String sin = '29302837483';
            Decimal amt = 300;
            String txnDate = '2017-10-15';
            
            //Sin has invalid length Error
            CXE_CP_MyAccountsManageService_CC.Response resp1 = CXE_CP_MyAccountsManageService_CC.enrollService(sin, amt, txnDate, false);
            System.assertEquals(CXE_Constants.SERVICE_ENROLLMENT_SIN_INVALID_LENGTH, resp1.message);
        }
        Test.stopTest();
    }
    
    @isTest
    static void test_EnrollServiceHasBeenUsedByAnotherPortalAccount(){
        Test.startTest();
        User adminUser = CXE_TestDataFactory.createAdminUser();
        insert adminUser;
        
        User userAd = [SELECT Id FROM User Where email='bruce.wayne@wayneenterprises.com'];
        System.runAs(userAd){
            //Register for a Portal Account
            List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
            try{
                if(!portalUsers.isEmpty()) {
                    System.runAs(portalUsers.get(0)){
                        String email = 'cxe_testuser2@test.com';
                        String fName = 'mfNametc2';
                        String mName = 'mmNametc2';
                        String lName = 'mlNametc2';
                        String suffix = '';
                        String mobile = '+639999999999';
                        String sin = '293028374839';
                        Decimal amt = 300;
                        String txnDate = '2017-10-15';
                        CXE_CP_SplashPageSelfRegistration_CC.Response response = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                        System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL, response.message);
                        
                        //Sin has been used by Another Portal Account Error
                        CXE_CP_MyAccountsManageService_CC.Response resp1 = CXE_CP_MyAccountsManageService_CC.hasBeenUsedByAnotherPortalAccount(sin);
                        System.assertEquals(CXE_Constants.SERVICE_ENROLLMENT_NOTICE_SIN_HAS_BEEN_USED, resp1.message);
                    }             
                }
            } catch (Exception e) {
                System.assertEquals('', e.getMessage());
            }
        }

        Test.stopTest();
    }
    
    @isTest
    static void test_EnrollServiceHasBeenRegisteredTwice(){
        Test.startTest();
        User adminUser = CXE_TestDataFactory.createAdminUser();
        insert adminUser;
        
        User userAd = [SELECT Id FROM User Where email='bruce.wayne@wayneenterprises.com'];
        System.runAs(userAd){
            //Register for a Portal Account
            List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];

                if(!portalUsers.isEmpty()) {
                    System.runAs(portalUsers.get(0)){
                        String email = 'cxe_testuser2@test.com';
                        String fName = 'mfNametc2';
                        String mName = 'mmNametc2';
                        String lName = 'mlNametc2';
                        String suffix = '';
                        String mobile = '+639999999999';
                        String sin = '293028374839';
                        Decimal amt = 300;
                        String txnDate = '2017-10-15';
                        
                        CXE_CP_SplashPageSelfRegistration_CC.Response resp = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                        System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL, resp.message);
                        
                        CXE_CP_SplashPageSelfRegistration_CC.Response resp1 = CXE_CP_SplashPageSelfRegistration_CC.createUser('cxe_testuser3@test.com', fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                        System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL, resp1.message);
                        
                        //Sin Enrolled to 2 Portal Accounts already Error
                        CXE_CP_MyAccountsManageService_CC.Response resp2 = CXE_CP_MyAccountsManageService_CC.enrollService(sin, amt, txnDate, false);
                        //CXE_CP_SplashPageSelfRegistration_CC.Response response2 = CXE_CP_SplashPageSelfRegistration_CC.createUser('cxe_testuser4@test.com', fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                        System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_ENROLLED_TWICE, resp2.message);
                    }  
                }
        }

        Test.stopTest();
    }
    
    @isTest
    static void test_EnrollServiceSinPrepaid(){
        Test.startTest();
        User adminUser = CXE_TestDataFactory.createAdminUser();
        insert adminUser;
        
        User userAd = [SELECT Id FROM User Where email='bruce.wayne@wayneenterprises.com'];
        System.runAs(userAd){
            //Register for a Portal Account
            List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];

                if(!portalUsers.isEmpty()) {
                    System.runAs(portalUsers.get(0)){
                        String email = 'cxe_testuser2@test.com';
                        String fName = 'mfNametc2';
                        String mName = 'mmNametc2';
                        String lName = 'mlNametc2';
                        String suffix = '';
                        String mobile = '+639999999999';
                        String sin = '293028374839';
                        Decimal amt = 300;
                        String txnDate = '2017-10-15';
                        
                        CXE_CP_SplashPageSelfRegistration_CC.Response resp = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                        System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL, resp.message);
                        
                        CXE_CP_SplashPageSelfRegistration_CC.Response resp1 = CXE_CP_SplashPageSelfRegistration_CC.createUser('cxe_testuser3@test.com', fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                        System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL, resp1.message);
                        
                        //Sin Enrolled to 2 Portal Accounts already Error
                        CXE_CP_MyAccountsManageService_CC.Response resp2 = CXE_CP_MyAccountsManageService_CC.enrollService(sin, amt, txnDate, false);
                        //CXE_CP_SplashPageSelfRegistration_CC.Response response2 = CXE_CP_SplashPageSelfRegistration_CC.createUser('cxe_testuser4@test.com', fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                        System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_ENROLLED_TWICE, resp2.message);
                    }  
                }
        }

        Test.stopTest();
    }
    
    */
    
    

    @isTest static void test_EnrollServiceHMB() {
        User sysAdminUser = [Select Id, Profile.Name From User Where Profile.Name =:CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR And IsActive = True LIMIT 1];
        System.assertEquals(CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR, sysAdminUser.Profile.Name);
        
        System.runAs(sysAdminUser){
            CXE_TestDataFactory.setupPortalData('2', true);
           
        }
        Test.startTest();
        List<User> portalUser = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE And IsActive = True];
        
        System.runAs(portalUser.get(0)){
            CXE_CP_MyAccountsManageService_CC myAcctMngServ = new CXE_CP_MyAccountsManageService_CC();
            
            String email = 'cxe_tcuser@test.com';
            String fName = 'mfNametc';
            String mName = 'mmNametc';
            String lName = 'mlNametc';
            String suffix = '';
            String mobile = '+639999999999';
            String sin = '293028374839';
            Decimal amt = 300;
            String txnDate = '2018-03-15';
            
            CXE_CP_SplashPageSelfRegistration_CC.Response response = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
            System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL, response.message);
            
            CXE_CP_MyAccountsManageService_CC.Response resp = CXE_CP_MyAccountsManageService_CC.enrollService(sin, amt, txnDate, false);
            System.assertEquals(CXE_Constants.SERVICE_ENROLLMENT_SUCCESSFUL, resp.message);
            System.assertEquals(true, resp.isSuccess);
            System.assertEquals('', resp.caseNumber);
        }
        Test.stopTest();
        
    }
    
    @isTest static void test_EnrollServiceSME() {
        User sysAdminUser = [Select Id, Profile.Name From User Where Profile.Name =:CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR And IsActive = True LIMIT 1];
        System.assertEquals(CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR, sysAdminUser.Profile.Name);
        
        System.runAs(sysAdminUser){
            CXE_TestDataFactory.setupPortalData('1', true);
           
        }
        Test.startTest();
        List<User> portalUser = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE And IsActive = True];
        
        System.runAs(portalUser.get(0)){
            CXE_CP_MyAccountsManageService_CC myAcctMngServ = new CXE_CP_MyAccountsManageService_CC();
            
            String email = 'cxe_tcuser2@test.com';
            String fName = 'mfNametc2';
            String mName = 'mmNametc2';
            String lName = 'mlNametc2';
            String suffix = '';
            String mobile = '+639999999998';
            String sin = '293028374839';
            Decimal amt = 300;
            String txnDate = '2017-12-15';
            
            CXE_CP_SplashPageSelfRegistration_CC.Response response = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
            
            CXE_CP_MyAccountsManageService_CC.Response resp = CXE_CP_MyAccountsManageService_CC.enrollService(sin, amt, txnDate, false);
            //System.assertEquals(CXE_Constants.SERVICE_ENROLLMENT_SUCCESSFUL, resp.message);
            System.assertEquals(CXE_Constants.SERVICE_ENROLLMENT_CONGLOMERATE_NOT_ALLOWED, resp.message);
            //System.assertEquals(true, resp.isSuccess);
            System.assertEquals(false, resp.isSuccess);
            System.assertEquals('', resp.caseNumber);
        }
        Test.stopTest();
        
    }
    
    @isTest static void test_EnrollServiceCBG() {
        User sysAdminUser = [Select Id, Profile.Name From User Where Profile.Name =:CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR And IsActive = True LIMIT 1];
        System.assertEquals(CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR, sysAdminUser.Profile.Name);
        
        System.runAs(sysAdminUser){
            CXE_TestDataFactory.setupPortalData('3', true);
           
        }
        Test.startTest();
        List<User> portalUser = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE And IsActive = True];
        
        System.runAs(portalUser.get(0)){
            CXE_CP_MyAccountsManageService_CC myAcctMngServ = new CXE_CP_MyAccountsManageService_CC();
            
            String email = 'cxe_tcuser2@test.com';
            String fName = 'mfNametc2';
            String mName = 'mmNametc2';
            String lName = 'mlNametc2';
            String suffix = '';
            String mobile = '+639999999998';
            String sin = '293028374839';
            Decimal amt = 300;
            String txnDate = '2018-03-15';
            
            CXE_CP_SplashPageSelfRegistration_CC.Response response = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
            
            CXE_CP_MyAccountsManageService_CC.Response resp = CXE_CP_MyAccountsManageService_CC.enrollService(sin, amt, txnDate, false);
            System.assertEquals(CXE_Constants.SERVICE_ENROLLMENT_SUCCESSFUL, resp.message);
            System.assertEquals(true, resp.isSuccess);
            System.assertEquals('', resp.caseNumber);
        }
        Test.stopTest();
    }
    
    @isTest static void test_EnrollServiceInvalidSin() {
        User sysAdminUser = [Select Id, Profile.Name From User Where Profile.Name =:CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR And IsActive = True LIMIT 1];
        System.assertEquals(CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR, sysAdminUser.Profile.Name);
        
        System.runAs(sysAdminUser){
            CXE_TestDataFactory.setupPortalData('2', true);
           
        }
        Test.startTest();
        List<User> portalUser = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE And IsActive = True];
        
        System.runAs(portalUser.get(0)){
            CXE_CP_MyAccountsManageService_CC myAcctMngServ = new CXE_CP_MyAccountsManageService_CC();
            
            String sin = '29302837483';
            Decimal amt = 300;
            String txnDate = '2017-10-15';
            
            CXE_CP_MyAccountsManageService_CC.Response resp = CXE_CP_MyAccountsManageService_CC.enrollService(sin, amt, txnDate, false);
            System.assertEquals(CXE_Constants.SERVICE_ENROLLMENT_SIN_INVALID_LENGTH, resp.message);
            System.assertEquals(false, resp.isSuccess);
            System.assertEquals('', resp.caseNumber);
        }
        Test.stopTest();
        
    }
    
    @isTest static void test_hasBeenUserByAnotherPortalAccount() {
        User sysAdminUser = [Select Id, Profile.Name From User Where Profile.Name =:CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR And IsActive = True LIMIT 1];
        System.assertEquals(CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR, sysAdminUser.Profile.Name);
        
        System.runAs(sysAdminUser){
            CXE_TestDataFactory.setupPortalData('2', true);
           
        }
        Test.startTest();
        List<User> portalUser = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE And IsActive = True];
        
        System.runAs(portalUser.get(0)){
            CXE_CP_MyAccountsManageService_CC myAcctMngServ = new CXE_CP_MyAccountsManageService_CC();
            
            String email = 'cxe_tcuser@test.com';
            String fName = 'mfNametc';
            String mName = 'mmNametc';
            String lName = 'mlNametc';
            String suffix = '';
            String mobile = '+639999999999';
            String sin = '293028374839';
            Decimal amt = 300;
            String txnDate = '2018-03-15';
            
            CXE_CP_SplashPageSelfRegistration_CC.Response response = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
            System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL, response.message);
            
            CXE_CP_MyAccountsManageService_CC.Response resp = CXE_CP_MyAccountsManageService_CC.hasBeenUsedByAnotherPortalAccount(sin);
            //System.assertEquals(CXE_Constants.SERVICE_ENROLLMENT_NOTICE_SIN_HAS_BEEN_USED, resp.message);
            System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_NOTICE_SIN_HAS_BEEN_USED2, resp.message);
            System.assertEquals(true, resp.isSuccess);
            System.assertEquals('', resp.caseNumber);
        }
        Test.stopTest();        
    }

    @isTest static void createCaseBillingTest() {
        User sysAdminUser = [Select Id, Profile.Name From User Where Profile.Name =:CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR And IsActive = True LIMIT 1];
        System.assertEquals(CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR, sysAdminUser.Profile.Name);
        
        System.runAs(sysAdminUser){
            CXE_TestDataFactory.setupPortalData('2', false);
           
        }

        // Implement test code
        Test.startTest();
        
        
        List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
    
        try{
            if(!portalUsers.isEmpty()) {
                Agreement__c service = [SELECT Code_Segment__c, Segment__c, Account__c, Case__c,
                                               Payor__c
                                        FROM Agreement__c WHERE SIN__C = '293028374839'];
                
                delete [SELECT Id FROM Agreement__c WHERE Id = :service.Id];


                List<Agreement__c> createService = CXE_TestDataFactory.createServiceWithLessDetails(1, service.Account__c, service.Case__c,
                                                                service.Payor__c,'');
        
              
                createService[0].Code_Segment__c = '3';
                createService[0].Segment__c = 'SME Business Group';
                createService[0].SIN__c = '293028374839';
                insert createService;

                System.runAs(portalUsers.get(0)){
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2018-03-15';
                    CXE_CP_MyAccountsManageService_CC.Response response =
                        CXE_CP_MyAccountsManageService_CC.enrollService(sin, amt, txnDate, false);

                    System.assert(String.isNotBlank(response.caseNumber));
                }                           
            }
        } catch (Exception e) {
            System.assertEquals('', e.getMessage() + '-' + e.getStackTraceString());
        }
        Test.stopTest();
    }


    @isTest static void createCasePaymentTest() {
        User sysAdminUser = [Select Id, Profile.Name From User Where Profile.Name =:CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR And IsActive = True LIMIT 1];
        System.assertEquals(CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR, sysAdminUser.Profile.Name);
        
        System.runAs(sysAdminUser){
            CXE_TestDataFactory.setupPortalData('2', false);
           
        }

        // Implement test code
        Test.startTest();
        
        
        List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
    
        try{
            if(!portalUsers.isEmpty()) {
                Agreement__c service = [SELECT Code_Segment__c, Segment__c, Account__c, Case__c,
                                               Payor__c
                                        FROM Agreement__c WHERE SIN__C = '293028374839'];
                
                delete [SELECT Id FROM Agreement__c WHERE Id = :service.Id];


                List<Agreement__c> createService = CXE_TestDataFactory.createServiceWithLessDetails(1, service.Account__c, service.Case__c,
                                                                service.Payor__c,'');
        
              
                createService[0].Code_Segment__c = '3';
                createService[0].Segment__c = 'SME Business Group';
                createService[0].SIN__c = '293028374839';
                insert createService;

                System.runAs(portalUsers.get(0)){
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2017-10-15';
                    CXE_CP_MyAccountsManageService_CC.Response response =
                        CXE_CP_MyAccountsManageService_CC.enrollService(sin, amt, txnDate, true);

                    System.assert(String.isBlank(response.caseNumber));
                }                           
            }
        } catch (Exception e) {
            System.assertEquals('', e.getMessage() + '-' + e.getStackTraceString());
        }
        Test.stopTest();
    }


    @isTest static void createIROTest() {
        User sysAdminUser = [Select Id, Profile.Name From User Where Profile.Name =:CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR And IsActive = True LIMIT 1];
        System.assertEquals(CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR, sysAdminUser.Profile.Name);
        
        System.runAs(sysAdminUser){
            CXE_TestDataFactory.setupPortalData('2', false);           
        }

        // Implement test code
        Test.startTest();
        
        
        List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
    
        try{
            if(!portalUsers.isEmpty()) {
                Agreement__c service = [SELECT Code_Segment__c, Segment__c, Account__c, Case__c,
                                               Payor__c
                                        FROM Agreement__c WHERE SIN__C = '293028374839'];
                
                delete [SELECT Id FROM Agreement__c WHERE Id = :service.Id];
                delete [SELECT Id FROM Case WHERE Id = :service.Case__c];
                
                
                Agreement__c serviceNew = new Agreement__c();
                serviceNew.Account__c = service.Account__c;
                serviceNew.Contract__c = service.Payor__c;
                serviceNew.Payor__c = service.Payor__c;
                serviceNew.Rate__c = 'General Service A (GSA)';
                serviceNew.Segment__c = 'Home and Micro Business';
                serviceNew.Service_Status__c = 'Active';
                serviceNew.Service_Supply_Type__c = 'Normal with meter';
                serviceNew.Service_Wire_Material__c = 'Copper';
                serviceNew.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
                serviceNew.Code_Segment__c = '3';
                serviceNew.Segment__c = 'SME Business Group';
                serviceNew.SIN__c = '293028374839';
                insert serviceNew;

                Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
                for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
                    addressReference.put(addRef.Field__c, addRef);
                }

                Address__c createAddress = CXE_TestDataFactory.createAddress(addressReference, true);
                createAddress.Type__c = 'Service';
                createAddress.Service__c = serviceNew.Id;
                createAddress.Address_Street_No__c = '1'; 
                insert createAddress;

                System.runAs(portalUsers.get(0)){
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2018-03-15';
                    CXE_CP_MyAccountsManageService_CC.Response response =
                        CXE_CP_MyAccountsManageService_CC.enrollService(sin, amt, txnDate, false);

                    System.assert(String.isNotBlank(response.caseNumber));
                }                           
            }
        } catch (Exception e) {
            System.assertEquals('', e.getMessage() + '-' + e.getStackTraceString());
        }
        Test.stopTest();
    }


    

    @isTest static void paymentHasExistingServiceTest() {
        User sysAdminUser = [Select Id, Profile.Name From User Where Profile.Name =:CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR And IsActive = True LIMIT 1];
        System.assertEquals(CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR, sysAdminUser.Profile.Name);
        
        System.runAs(sysAdminUser){
            CXE_TestDataFactory.setupPortalData('2', false);
           
        }

        // Implement test code
        Test.startTest();
        
        
        List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
    
        try{
            if(!portalUsers.isEmpty()) {
                System.runAs(portalUsers.get(0)){
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2017-10-15';
                    CXE_CP_MyAccountsManageService_CC.Response response =
                        CXE_CP_MyAccountsManageService_CC.enrollService(sin, amt, txnDate, true);

                    System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_ERROR_HAS_EXISTING_BILLING_RECORD, response.message);
                    System.assert(!response.isSuccess);
                }                           
            }
        } catch (Exception e) {
            System.assertEquals('', e.getMessage() + '-' + e.getStackTraceString());
        }
        Test.stopTest();
    }

}