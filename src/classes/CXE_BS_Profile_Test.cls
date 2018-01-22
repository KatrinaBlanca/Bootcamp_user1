@isTest
private class CXE_BS_Profile_Test {
	
	 @testSetup static void creaUser(){
        
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

    @isTest static void TestPost() {

    	User  userSysAd =[SELECT ID, ContactId FROM USER WHERE EMAIL ='bruce.wayne@wayneenterprises.com' ];
        
        System.runAs(userSysAd)
        {     
            test.startTest();
            
            Profile portalProfile = [SELECT Id FROM Profile Limit 1];
            
            Account account1 = new Account(
                Name = 'TestAccount',
                OwnerId = userSysAd.Id,
                Phone = '+63021234567',
                Tax_Identification_No__c = '123456789012',
                Mobile_Phone__c = '+630000000000',
                Email__c = 'test@meralco.test.com'
            );   
            Database.insert(account1);
            
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = account1.Id,
                Email = System.now().millisecond() + 'test@meralco.test.com',
                CXE_isPortalContact__c =False
            );
            Database.insert(contact1);
            
            String MobileNum = '+639090090909', 
                Mobile2 = '+639111111111', 
                Phone = '+6321234567',
                SecondaryEmail = 'test@testing.com',
                Salutation = 'Mr.',
                Birthdate = String.valueOf(Date.today().addYears(-20));
            //create portal user
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@meralco.test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                MobilePhone = MobileNum,
                Phone = Phone,
                Alias = 'test123',
                Email = 'test12345@meralco.test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
            
            
        }
        
        User portalUser = [SELECT ID, ContactId FROM User WHERE Email='test12345@meralco.test.com'];
       
        System.runAs(portalUser) {
            
            String MobileNum = '+639090090909', 
            Mobile2 = '+639111111111', 
            Phone = '+6321234567',
            SecondaryEmail = 'test@testing.com',
            Salutation = 'Mr.',
            Birthdate = String.valueOf(Date.today().addYears(-20));
               
           	RestRequest req = new RestRequest(); 
			RestResponse res = new RestResponse();

			req.requestURI = '/services/apexrest/CXE_BS_Profile';  //Request URL
			req.httpMethod = 'POST';//HTTP Request Type
			req.addHeader('Content-Type', 'application/json');
			//req.requestBody = Blob.valueof(JsonMsg);
			RestContext.request = req;
			RestContext.response= res;
			CXE_BS_Profile.post(MobileNum, Mobile2, Phone, Birthdate, secondaryEmail, salutation, 'test', 'test', 'test', 'test');

            test.stopTest();
        }

		
	}

	@isTest static void TestGet() {
		
		 List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;

        
        System.assertEquals(False,testAccount.IsPersonAccount );
        
       
        
        //System.assert(null,[SELECT (SELECT Name,Id FROM Contacts) FROM Account WHERE Id =:testAccount.Id]);
        
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        //testCase.Reason_for_Manual_Deposit_Input__c ='Manual Deposit Reason';
        //
        insert testCase;

         
      
         
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             //Bill_Print_Mode__c ='Paper',
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Type__c = 'Regular');
        insert testContract;
        List<Address__c> lstAddress = new List<Address__c>();
         
         Address__c testAddress = new Address__c(Type__c = 'Billing', 
                                                Account__c = testAccount.Id,
                                                Case__c = testCase.Id,
                                                Contract__c = testContract.Id,
                                                Address_Street_No__c = '1');
         
         
        Address__c testAddress2 = new Address__c(Type__c = 'Service', 
                                                Account__c = testAccount.Id,
                                                Case__c = testCase.Id,
                                                Premise_Type__c = 'Single-Detached Residential',
                                                Address_Street_No__c = '1');
         
         
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
               
        insert lstAddress;
        
       
 
        Agreement__c service = new Agreement__c();
        service.Account__c = testAccount.Id;
        service.Case__c = testCase.Id;
        service.Contract__c = testContract.Id;
        //service.PSIC__c = psicId;
        service.Rate__c = 'General Power (GP)';
        service.Segment__c = 'Home and Micro Business';
        service.Service_Supply_Type__c = 'Normal with meter';
        service.Service_Wire_Material__c = 'Copper';
        service.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
        service.Service_Wire_Size__c = '#1/0';
        service.Service_Wire_Type__c = 'Under Copper,Lateral';
        service.Voltage_Level__c = '4.8 kV';
        service.Applied_Load__c = 50; //START/END RReyes JUL-08-17 changed to prevent validation
        service.payor__c=testContract.Id;
        
        
        insert service;
        
        
        User  portalAccountOwner1 =[SELECT ID FROM USER WHERE EMAIL ='bruce.wayne@wayneenterprises.com' ];
        
       System.runAs ( portalAccountOwner1 ) {
            
            //Create account
            
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id,
                Phone = '+63021234567',
                Tax_Identification_No__c = '123456789012',
                Mobile_Phone__c = '+630000000000',
                Email__c = 'test@test.com'
               
            );
            Database.insert(portalAccount1);
            
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@test.com',
                CXE_isPortalContact__c =False
            );
           
            Database.insert(contact1);
           // Id  contactIds =[select PersonContactId FROM account where ID =: testAccount.Id].PersonContactId;
          // System.assertEquals(contactIds,[select PersonContactId  from Account where id =:testAccount.Id].Id);
           
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile Limit 1];
            User user1 = new User(
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
                LanguageLocaleKey = 'en_US',
                By_Pass_Validation__c = True //CSM-12863 GGrandea 09.21.2017
            );
            Database.insert(user1);
           //System.assertEquals('true emails WalangKwenta',String.valueOf(user1.Id));
           
           
     
           CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
           cxe.CXE_ServiceId__c = service.Id;
           cxe.CXE_UserId__c = user1.ID;
           cxe.CXE_IsActive__c =True;
           cxe.CXE_Type__c ='Payor';
           insert cxe;
          
           CXE_Service_Enrollment__c cxe_nonPayor = new CXE_Service_Enrollment__c();
           cxe_nonPayor.CXE_ServiceId__c = service.Id;
           cxe_nonPayor.CXE_UserId__c = user1.ID;
           cxe_nonPayor.CXE_IsActive__c =True;
           cxe_nonPayor.CXE_Type__c ='Non-Payor';
           insert cxe_nonPayor;
           
        }
        
        Test.startTest();
        
        
         User  portalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com' ];
        
         System.runAs ( portalUser ) {
             
            RestRequest req = new RestRequest(); 
			RestResponse res = new RestResponse();

			req.requestURI = '/services/apexrest/profile';  //Request URL
			req.httpMethod = 'Get';//HTTP Request Type
			req.addHeader('Content-Type', 'application/json');
			//req.requestBody = Blob.valueof(JsonMsg);
			RestContext.request = req;
			RestContext.response= res;
			CXE_BS_Profile.get();
             
         }




	}
	
}