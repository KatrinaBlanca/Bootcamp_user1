@isTest
private Class CXE_ServiceApplication_Test{
    @testSetup
    static void createTestReqs(){
        
        User adminUser = CXE_TestDataFactory.createAdminUser();
        insert adminUser;
        
		User  userSysAd =[SELECT ID FROM USER WHERE EMAIL ='bruce.wayne@wayneenterprises.com' ];
        System.runAs ( userSysAd ) {
            Account account1 = new Account(
                Name = 'TestAccount',
                OwnerId = userSysAd.Id,
                Phone = '+63021234567',
                Tax_Identification_No__c = '123456789012',
                Mobile_Phone__c = '+630000000000',
                Email__c = 'test@test.com'
            );
            Database.insert(account1);
            
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = account1.Id,
                Email = System.now().millisecond() + 'test@test.com',
                CXE_isPortalContact__c =False
            );
            Database.insert(contact1);
            
            //CREATE PORTAL USER ACCOUNT
            Profile portalProfile = [SELECT Id FROM Profile Limit 1];
            User pAccountPortalUser = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(pAccountPortalUser);
        }
    }
    @isTest
    static void MethodTest(){
        Test.startTest();
        CXE_ServiceApplication.getServiceModifications();
        CXE_ServiceApplication.getContractModifications();
        CXE_ServiceApplication.newPortalCase();
        CXE_ServiceApplication.getPersona();
        Case inistNewCase = CXE_ServiceApplication.initNewCase();
        Test.stopTest();
    }
    
    @isTest
    static void createPortalUser(){
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
            
        );
        Database.insert(portalAccountOwner1);
        
    }
   
    @isTest
    static void SubmitServiceApplication(){
       
		//CREATE ACCOUNT
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        //CREATE CONTACT
        List<Contact> testContact = CXE_TestDataFactory.createContact(1);
        insert testContact;
        
        //CREATE PSIC
        List<PSIC__c> testPsic = CXE_TestDataFactory.createPSIC(1);
        insert testPsic;
        
        //CREATE CASE CASE_SERVICE_APPLICATION
       	List<Case> CaseList = new List<Case>();
        Id newServiceApplicationRecordTypeId1 = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        Id newServiceApplicationRecordTypeId2 = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_PAPERLESS_BILLING).getRecordTypeId();
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
     	Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId1;  
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        testCase.Relationship__c = '--- None ---';
        testCase.Service_Address_Province__c = '--- None ---';
        testCase.Service_Address_City_Municiple__c = '--- None ---';
        testCase.Billing_Address_Province__c = '--- None ---';
        testCase.Billing_Address_City_Municipal__c = '--- None ---';
     	CaseList.add(testCase);
        
        Case testCase1 = new Case();
        testCase1.RecordTypeId = newServiceApplicationRecordTypeId2;  
        testCase.Tax_Identification_No__c = '1111111';
        testCase1.AccountId = testAccount.Id;
        testCase1.Account_No__c = '123456789123';
        testCase1.Relationship__c = '--- None ---';
        CaseList.add(testCase1);
        
        Case testCase2 = new Case();
        testCase2.RecordTypeId = newServiceApplicationRecordTypeId2;  
        testCase2.Tax_Identification_No__c = '1111111';
        testCase2.AccountId = testAccount.Id;
        testCase2.Relationship__c = '--- None ---';
       	insert testCase2;
        
        String myJSON = JSON.serialize(CaseList.get(0));
        String myJSON1 = JSON.serialize(CaseList.get(1));
        String myJSON2 = JSON.serialize(testCase2);
    	//get recordType
        RecordType recType = [SELECT Id, DeveloperName FROM RecordType WHERE id =:newServiceApplicationRecordTypeId1];
        RecordType recType1 = [SELECT Id, DeveloperName FROM RecordType WHERE id =:newServiceApplicationRecordTypeId2];
        //CREATE CONTRACT       
        List<Contract> testContract = CXE_TestDataFactory.createContract(1, testAccount.Id, testCase2.Id);
        testContract[0].V10_Account_No__c = '12345678';
        testContract[0].Type__c = 'Regular';
        insert testContract;
        
        //CREATE ADDRESS
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Contract__c = testContract[0].Id, Case__c = testCase2.Id,  Address_Street_No__c = '1');
        insert testAddress;
        
        //CREATE SERVICE
        List<Agreement__c> service = CXE_TestDataFactory.createService(1,testAccount.Id, testCase2.Id, testContract[0].Id, testPsic[0].Id);
        service[0].Payor__c= testContract[0].Id;
        service[0].SIN__c = '123456789123';
        insert service;
        
        List<Agreement__c> service1 = CXE_TestDataFactory.createService(1,testAccount.Id, testCase2.Id, testContract[0].Id, testPsic[0].Id);
        service1[0].Payor__c= testContract[0].Id;
        service1[0].SIN__c = '5352345';
        insert service1;
            
        test.startTest();    
        User  userPortalUser =[SELECT Id FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs(userPortalUser){

        try{
            CXE_CP_PortalUtility.getCurrentUserContacId();     
            
            CXE_ServiceApplication.submitServiceApplication(myJSON, recType.DeveloperName);
            CXE_ServiceApplication.submitServiceApplication(myJSON1, recType1.DeveloperName);
            CXE_ServiceApplication.submitServiceApplication(myJSON2, recType1.DeveloperName);
            test.stopTest();
        }
        catch(Exception e){
            System.assertEquals(null, e.getMessage());
	        }
        }
    }
   
    @isTest
    static void trackApplication(){
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        //CREATE CONTACT
        List<Contact> testContact = CXE_TestDataFactory.createContact(1);
        insert testContact;
        
        //CREATE PSIC
        List<PSIC__c> testPsic = CXE_TestDataFactory.createPSIC(1);
        insert testPsic;
        
        //CREATE CASE CASE_SERVICE_APPLICATION
       
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
     	Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;  
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        testCase.Last_Name__c = 'LastName';
        insert testCase;    
        List<Case> checkCase = [select id, CaseNumber, Last_Name__c from Case];
       
        test.startTest();    
        
        CXE_ServiceApplication.trackApplication(checkCase[0].CaseNumber, checkCase[0].Last_Name__c);
        CXE_ServiceApplication.trackApplication(null, null);
        
        test.stopTest();
    }
    
    @isTest
    static void getRelationToCustomer(){
        test.startTest();    
        CXE_ServiceApplication.getRelationToCustomer('Contractor');
         CXE_ServiceApplication.getRelationToCustomer('Spouse');
        test.stopTest();
    }
    
     @isTest
    static void getInitialResponsibleOffice(){
        //CREATE ACCOUNT
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        //CREATE CONTACT
        List<Contact> testContact = CXE_TestDataFactory.createContact(1);
        insert testContact;
        
         //CREATE CASE CASE_SERVICE_APPLICATION
       	List<Case> CaseList = new List<Case>();
        Id newServiceApplicationRecordTypeId1 = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        Id newServiceApplicationRecordTypeId2 = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_PAPERLESS_BILLING).getRecordTypeId();
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
     	Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId1;  
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        testCase.Relationship__c = '--- None ---';
        testCase.Service_Address_City_Municiple__c = 'Bacoor';
     	//insert testCase;
        
        String myJSON = JSON.serialize(testCase);
        
         //Create Reference
        List<Reference__c> reference = CXE_TestDataFactory.createSampleReferenceListForAddress();
        reference[0].Name='Bacoor';
        reference[0].Field__c = 'City';
        insert reference;
        //Create Office
        List<Office__c> office = CXE_TestDataFactory.createOffice(1);
        insert office;
        
        //get recordType
        RecordType recType = [SELECT Id, DeveloperName FROM RecordType WHERE id =:newServiceApplicationRecordTypeId1];
        CXE_ServiceApplication.submitServiceApplication(myJSON, recType.DeveloperName);
    }
    
    
}