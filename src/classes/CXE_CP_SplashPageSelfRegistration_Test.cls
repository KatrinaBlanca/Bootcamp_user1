@isTest
private class CXE_CP_SplashPageSelfRegistration_Test {
    
    
    
    @testSetup static void setup(){
        
        CXE_TestDataFactory.setupPortalData('2', true);
        
        
    }
      @isTest static void createUserTestFalse() {
        // Implement test code
        Test.startTest();
        
        
        CXE_CP_SplashPageSelfRegistration_CC splashPageSelfReg = new CXE_CP_SplashPageSelfRegistration_CC();
       
        
        List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
    
        try{
            
            if(!portalUsers.isEmpty()) {
                
                System.runAs(portalUsers.get(0)){
                    String email = 'cxe_tcuser2@test.com';
                    String fName = 'mfNametc2';
                    String mName = 'mmNametc2';
                    String lName = 'mlNametc2';
                    String suffix = '';
                    String mobile = '+639999999999';
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2018-03-15';
                    CXE_CP_SplashPageSelfRegistration_CC.Response response =
                        CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);

                    System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_SUCCESSFUL, response.message);
                }                           
                
            }
            
        } catch (Exception e) {
            System.assertEquals('', e.getMessage());
        }
        Test.stopTest();
    }
  
    
    
    
    @isTest static void createUserTestTrue() {
        // Implement test code
        Test.startTest();
        
        CXE_CP_SplashPageSelfRegistration_CC splashPageSelfReg = new CXE_CP_SplashPageSelfRegistration_CC();
        
        List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
    
        try{
            
            if(!portalUsers.isEmpty()) {
                
                System.runAs(portalUsers.get(0)){
                    String email = 'cxe_tcuser2@test.com';
                    String fName = 'mfNametc2';
                    String mName = 'mmNametc2';
                    String lName = 'mlNametc2';
                    String suffix = '';
                    String mobile = '+639999999999';
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2018-03-15';
                    CXE_CP_SplashPageSelfRegistration_CC.Response response =
                        CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, True);
                    
                    System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_ERROR_HAS_EXISTING_BILLING_RECORD, response.message);
                }                           
                
            }
            
        } catch (Exception e) {
            System.assertEquals('', e.getMessage());
        }
        Test.stopTest();
    }
    
    
    
    @isTest static void createUserDifferentProfile() {
        // Implement test code
        try{
            User adminUser = CXE_TestDataFactory.createAdminUser();
            adminUser.IsActive = true; //START/END RReyes JAN-03-18
            insert adminUser;
           // CXE_TestDataFactory.setupPortalData('3');
            List<User> portalUsers = [SELECT Id FROM User WHERE Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
            
            //if(!portalUsers.isEmpty()) {
                Test.startTest();
                
                System.runAs(adminUser){
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
                    System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_ERROR_HAS_SESSION, response.message);
                }
                Test.stopTest();
            //}
        } catch (Exception e) {
            System.assertEquals('', e.getMessage());
        }
    }
    
    @isTest static void createUserSinInvalidLength() {
        // Implement test code
        try{
            //CXE_TestDataFactory.setupPortalData('3');
            List<User> portalUsers = [SELECT Id FROM User WHERE Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
            
            if(!portalUsers.isEmpty()) {
                Test.startTest();
                
                System.runAs(portalUsers.get(0)){
                    String email = 'cxe_tcuser@test.com';
                    String fName = 'mfNametc';
                    String mName = 'mmNametc';
                    String lName = 'mlNametc';
                    String suffix = '';
                    String mobile = '+639999999999';
                    String sin = '29302837483';
                    Decimal amt = 300;
                    String txnDate = '2018-03-15';
                    CXE_CP_SplashPageSelfRegistration_CC.Response response = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                    System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_INVALID_LENGTH, response.message);
                }
                Test.stopTest();
            }
        } catch (Exception e) {
            System.assertEquals('', e.getMessage());
        }
    }
    
    @isTest static void createUserHMB() {
         Test.startTest();
        // Implement test code
        try{
           // CXE_TestDataFactory.setupPortalData('1');
            List<Contact> contacts = CXE_TestDataFactory.createContact(1);
            insert contacts;
            
            
            List<User> portalUsers = [SELECT Id FROM User WHERE Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
            
            if(!portalUsers.isEmpty()) {
               
                
                System.runAs(portalUsers.get(0)){
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
                    
                }
               
            }
        } catch (Exception e) {
            System.assertEquals('', e.getMessage());
        }
         Test.stopTest();
    }
    
    @isTest
    static void hasBeenUsedByAnotherMethod(){
        
        Test.startTest();
        User adminUser = CXE_TestDataFactory.createAdminUser();
        adminUser.IsActive = true; //START/END RReyes JAN-03-18
        insert adminUser;
        
        //User userAd = [SELECT Id FROM User Where email='bruce.wayne@wayneenterprises.com'];
        System.runAs(adminUser){
            // CXE_TestDataFactory.setupPortalData('1');
            
            Account acct = CXE_TestDataFactory.createSingleAccountForPortalUser(adminUser.Id);
            insert acct;
            Contact  cont =CXE_TestDataFactory.createContact(acct.Id);
            insert cont;
            
            User portalUser = CXE_TestDataFactory.createPortalUser(cont.Id);
            portalUser.IsActive = true;
            insert portalUser; 
            
            System.assert(portalUser!=null);
            
            Agreement__c service =[SELECT Id FROM Agreement__c WHERE SIN__C= '293028374839' LIMIT  1]; 
            //Insert service enrollment for portal user
            CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
            cxe.CXE_ServiceId__c = service.Id;
            cxe.CXE_UserId__c = portalUser.ID;
            cxe.CXE_IsActive__c =True;
            
            insert cxe;
            
            System.assert(cxe!=null);
        }
        
        List<User> portalUsers = [SELECT Id FROM User WHERE Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
        System.runAs(portalUsers[0]){ //rom
            String email = 'cxe_tcuser@test.com';
            String fName = 'mfNametc';
            String mName = 'mmNametc';
            String lName = 'mlNametc';
            String suffix = '';
            String mobile = '+639999999999';
            String sin = '293028374839';
            Decimal amt = 300;
            String txnDate = '2018-03-15';
            CXE_CP_SplashPageSelfRegistration_CC.Response response = CXE_CP_SplashPageSelfRegistration_CC.hasBeenUsedByAnotherPortalAccount('293028374839');
           
        }    
        // guestPortalRegistration();
        Test.stopTest();
    }
    
  
    @isTest
    static void Wrapper_Test(){
        Test.startTest();
        List<String> errorMessages = new List<String>();
        errorMessages.add('message 1');
        errorMessages.add('message 2');
        
        CXE_CP_SplashPageSelfRegistration_CC.BillWrapper bwrap = new CXE_CP_SplashPageSelfRegistration_CC.BillWrapper(True);
        CXE_CP_SplashPageSelfRegistration_CC.BillWrapper bwrapErrorList = new CXE_CP_SplashPageSelfRegistration_CC.BillWrapper(errorMessages);
        CXE_CP_SplashPageSelfRegistration_CC.SINWrapper SINWrappers = new CXE_CP_SplashPageSelfRegistration_CC.SINWrapper(True,'caseNumber');
        CXE_CP_SplashPageSelfRegistration_CC.Response resp = new CXE_CP_SplashPageSelfRegistration_CC.Response('caseNumber');
        
        System.assert(bwrap !=null);
        System.assert(bwrapErrorList !=null);
        System.assert(SINWrappers !=null); 
        System.assert(resp !=null);
        
        Test.stopTest();
    }    
    
    @isTest
    static void InactiveSin_Test(){
        
        Test.startTest();
        
        
        Agreement__c service =[SELECT Id, Service_Status__c  FROM Agreement__c WHERE SIN__C= '293028374839' LIMIT  1]; 
        service.Service_Status__c ='Terminated';
        
        update service;
        
        CXE_CP_SplashPageSelfRegistration_CC splashPageSelfReg = new CXE_CP_SplashPageSelfRegistration_CC();
        
        List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
        
        try{
            if(!portalUsers.isEmpty()) {
                System.runAs(portalUsers.get(0)){
                    String email = 'cxe_tcuser2@test.com';
                    String fName = 'mfNametc2';
                    String mName = 'mmNametc2';
                    String lName = 'mlNametc2';
                    String suffix = '';
                    String mobile = '+639999999999';
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2018-03-15';
                    CXE_CP_SplashPageSelfRegistration_CC.Response response = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                    
                    System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_INACTIVE, response.message);
                }                           
                
            }
            
        } catch (Exception e) {
            System.assertEquals('', e.getMessage());
        }
        
        Test.stopTest();
        
        
    }    
    
    @isTest 
    static void hasBeenRegisteredTwice_Test(){
        
        Test.startTest();

        User adminUser = CXE_TestDataFactory.createAdminUser();
        insert adminUser;
        
        User userAd = [SELECT Id FROM User Where email='bruce.wayne@wayneenterprises.com'];
        System.runAs(userAd){
            Agreement__c serviceRec =[SELECT Id, Service_Status__c ,Code_Segment__c,Segment__c  FROM Agreement__c WHERE SIN__C= '293028374839' LIMIT  1]; 
            serviceRec.Code_Segment__c = '2';
            serviceRec.Segment__c = 'Home and Micro Business';
            
            update serviceRec;
            // CXE_TestDataFactory.setupPortalData('1');
            
            Account acct = CXE_TestDataFactory.createSingleAccountForPortalUser(userAd.Id);
            insert acct;
            Contact  cont =CXE_TestDataFactory.createContact(acct.Id);
            insert cont;
            
            User portalUser = CXE_TestDataFactory.createPortalUser(cont.Id);
            insert portalUser; 
            portalUser.CommunityNickname ='CorbesTest';
            update portalUser;
            
            System.assert(portalUser!=null);
            
            Agreement__c service =[SELECT Id FROM Agreement__c WHERE SIN__C= '293028374839' LIMIT  1]; 
            //Insert service enrollment for portal user
            CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
            cxe.CXE_ServiceId__c = service.Id;
            cxe.CXE_UserId__c = portalUser.ID;
            cxe.CXE_IsActive__c =True;
            
            insert cxe;
            
            System.assert(cxe!=null);
            
            //insert record in portal and Enrollments
            Account acct2= CXE_TestDataFactory.createSingleAccountForPortalUser(userAd.Id);
            insert acct2;
            Contact  cont2 =CXE_TestDataFactory.createContact(acct2.Id);
            insert cont2;
            
            User portalUser2 = CXE_TestDataFactory.createPortalUser(cont2.Id);
            insert portalUser2; 
           
            System.assert(portalUser2!=null);
            
            Agreement__c service2 =[SELECT Id FROM Agreement__c WHERE SIN__C= '293028374839' LIMIT  1]; 
            //Insert service enrollment for portal user
            CXE_Service_Enrollment__c cxe2 = new CXE_Service_Enrollment__c();
            cxe2.CXE_ServiceId__c = service2.Id;
            cxe2.CXE_UserId__c = portalUser2.ID;
            cxe2.CXE_IsActive__c =True;
            
            insert cxe2;
        }
        List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
        try{
            if(!portalUsers.isEmpty()) {
                System.runAs(portalUsers.get(0)){
                    String email = 'cxe_tcuser2@test.com';
                    String fName = 'mfNametc2';
                    String mName = 'mmNametc2';
                    String lName = 'mlNametc2';
                    String suffix = '';
                    String mobile = '+639999999999';
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2018-03-15';
                    CXE_CP_SplashPageSelfRegistration_CC.Response response = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                    
                    System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_ENROLLED_TWICE, response.message);
                }                           
                
            }
            
        } catch (Exception e) {
            System.assertEquals('', e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void hasDuplicateEmail_Test(){
        Test.startTest();
            /*
        User adminUser = CXE_TestDataFactory.createAdminUser();
        insert adminUser;
        
        User userAd = [SELECT Id FROM User Where email='bruce.wayne@wayneenterprises.com'];
        System.runAs(userAd){
            
            
            Agreement__c serviceRec =[SELECT Id, Service_Status__c ,Code_Segment__c,Segment__c  FROM Agreement__c WHERE SIN__C= '293028374839' LIMIT  1]; 
            serviceRec.Code_Segment__c = '2';
            serviceRec.Segment__c = 'Home and Micro Business';
            
            update serviceRec;
            
            // CXE_TestDataFactory.setupPortalData('1');
            
            Account acct = CXE_TestDataFactory.createSingleAccountForPortalUser(userAd.Id);
            insert acct;
            Contact  cont =CXE_TestDataFactory.createContact(acct.Id);
            insert cont;
            
            User portalUser = CXE_TestDataFactory.createPortalUser(cont.Id);
            insert portalUser; 
            portalUser.CommunityNickname ='CorbesTest';
            update portalUser;
            
            System.assert(portalUser!=null);
            
            Agreement__c service =[SELECT Id FROM Agreement__c WHERE SIN__C= '293028374839' LIMIT  1]; 
            //Insert service enrollment for portal user
            CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
            cxe.CXE_ServiceId__c = service.Id;
            cxe.CXE_UserId__c = portalUser.ID;
            cxe.CXE_IsActive__c =True;
            
            insert cxe;
            
            System.assert(cxe!=null);

        }
       */
        List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
        try{
            if(!portalUsers.isEmpty()) {
                System.runAs(portalUsers.get(0)){
                    String email = 'test12345@test.com';
                    String fName = 'mfNametc2';
                    String mName = 'mmNametc2';
                    String lName = 'mlNametc2';
                    String suffix = '';
                    String mobile = '+639999999999';
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2018-03-15';
                    CXE_CP_SplashPageSelfRegistration_CC.Response response = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                    CXE_CP_SplashPageSelfRegistration_CC.Response response1 = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                   
                    System.assertEquals( CXE_Constants.PORTAL_REGISTRATION_ERROR_DUPLICATE_EMAIL, response1.message);
                }                           
            }
        } catch (Exception e) {
            System.assertEquals('', e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest 
    static void testforCatchError(){
        
        
        Test.startTest();
        User adminUser = CXE_TestDataFactory.createAdminUser();
        insert adminUser;
        
        User userAd = [SELECT Id FROM User Where email='bruce.wayne@wayneenterprises.com'];
        System.runAs(userAd){
         
            Agreement__c service =[SELECT Id, Payor__c  
                                   FROM Agreement__c WHERE SIN__C= '293028374839' LIMIT  1]; 
            
            service.Payor__c =null;

            update service;
            
            System.assertEquals(false, service.Payor__r.Account.IsPersonAccount);    
            
        }
        //create new Account
        
        List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
        
        try{
            
            if(!portalUsers.isEmpty()) {
                
                
                
                System.runAs(portalUsers.get(0)){
                    String email = 'cxe_tcuser2@test.com';
                    String fName = 'mfNametc2';
                    String mName = 'mmNametc2';
                    String lName = 'mlNametc2';
                    String suffix = '';
                    String mobile = '+639999999999';
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2018-03-15';
                    CXE_CP_SplashPageSelfRegistration_CC.Response response = CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                    
                   
                }                           
                
            }
            
        } catch (Exception e) {
            System.assert(e.getMessage()!=null) ;
        }
        Test.stopTest();
    }



     @isTest static void createCaseTest() {
        // Implement test code
        Test.startTest();
        
        CXE_CP_SplashPageSelfRegistration_CC splashPageSelfReg = new CXE_CP_SplashPageSelfRegistration_CC();
        
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
                    String email = 'cxe_tcuser2@test.com';
                    String fName = 'mfNametc2';
                    String mName = 'mmNametc2';
                    String lName = 'mlNametc2';
                    String suffix = '';
                    String mobile = '+639999999999';
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2018-03-15';
                    CXE_CP_SplashPageSelfRegistration_CC.Response response =
                        CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);

                    System.assert(String.isNotBlank(response.caseNumber));
                }                           
            }
        } catch (Exception e) {
            System.assertEquals('', e.getMessage());
        }
        Test.stopTest();
    }


    @isTest static void createIROTest() {
        // Implement test code
        Test.startTest();
        
        CXE_CP_SplashPageSelfRegistration_CC splashPageSelfReg = new CXE_CP_SplashPageSelfRegistration_CC();
        
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
                    String email = 'cxe_tcuser2@test.com';
                    String fName = 'mfNametc2';
                    String mName = 'mmNametc2';
                    String lName = 'mlNametc2';
                    String suffix = '';
                    String mobile = '+639999999999';
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2018-03-15';
                    CXE_CP_SplashPageSelfRegistration_CC.Response response =
                        CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);

                    System.assert(String.isNotBlank(response.caseNumber));
                }                           
            }
        } catch (Exception e) {
            System.assertEquals('', e.getMessage());
        }
        Test.stopTest();
    }


    @isTest static void sendCBGRMEmailTest() {
        // Implement test code
        Test.startTest();
        
        CXE_CP_SplashPageSelfRegistration_CC splashPageSelfReg = new CXE_CP_SplashPageSelfRegistration_CC();
        
        List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
    
        try{
            if(!portalUsers.isEmpty()) {
                Agreement__c service = [SELECT Code_Segment__c, Segment__c, Account__c, Case__c,
                                               Payor__c, Payor__r.Account.Owner.Name
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
                serviceNew.Code_Segment__c = '1';
                serviceNew.Segment__c = 'Corporate Business Group';
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
                    String email = 'cxe_tcuser2@test.com';
                    String fName = 'mfNametc2';
                    String mName = 'mmNametc2';
                    String lName = 'mlNametc2';
                    String suffix = '';
                    String mobile = '+639999999999';
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2018-03-15';
                    CXE_CP_SplashPageSelfRegistration_CC.Response response =
                        CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);

                    System.assertEquals(String.format(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_CBG_ACCOUNT, new List<String>{ service.Payor__r.Account.Owner.Name }), response.message);
                }                           
            }
        } catch (Exception e) {
            System.assertEquals('', e.getMessage());
        }
        Test.stopTest();
    }
       
    
    
}