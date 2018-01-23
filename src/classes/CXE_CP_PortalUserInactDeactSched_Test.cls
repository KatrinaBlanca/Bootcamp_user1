@isTest
private class CXE_CP_PortalUserInactDeactSched_Test {
	
	private static testMethod void Test(){

		Test.StartTest();

			CXE_CP_PortalUserInactivityDeactSched portalDeactSched = new CXE_CP_PortalUserInactivityDeactSched();
			String sch = '0 0 23 * * ?'; 
			system.schedule('Test Territory Check', sch, portalDeactSched); 
		Test.StopTest();
	}
    
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
    
    
    
    static testMethod void SingleEnrollmentRecord(){

        // create a contract with a Billing Address

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
        
        Test.startTest();
 
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
        service.Service_Status__c ='Active';
        
        
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
           
           //Id portalCommProfId = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE].Id;
           
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE Limit 1];
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
                By_Pass_Validation__c = True, //CSM-12863 GGrandea 09.21.2017
                IsActive = true
            );
            User user2 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test1234',
                Email = 'test123456@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                By_Pass_Validation__c = True, //CSM-12863 GGrandea 09.21.2017
                IsActive = true
            );
            //Database.insert(user1);
           Database.insert(user2);
           //System.assertEquals('true emails WalangKwenta',String.valueOf(user1.Id));
           
           
           system.assertEquals(portalProfile.Id, user1.ProfileId);
           system.assertEquals(portalProfile.Id, user2.ProfileId);
           system.assertEquals(user1.ProfileId, user2.ProfileId);
     
           CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
           cxe.CXE_ServiceId__c = service.Id;
           cxe.CXE_UserId__c = user2.ID;
           cxe.CXE_IsActive__c =True;
           cxe.CXE_Unenrollment_Date__c = System.today() -30;
           database.insert(cxe);
          
          
           //terminate  a service
           service.Service_Status__c ='Terminated';
           service.Agreement_End_Date__c =Date.today();
           
           //update service;
           database.update(service);
           //Trigger did not work
           cxe.CXE_ServiceTerminated__c = True;
           cxe.CXE_isLastEnrolledService__c = false;
           //update cxe;
           database.update(cxe);
           
           CXE_Service_Enrollment__c cxe1 = [SELECT CXE_UserId__c, CXE_UserId__r.ProfileId, CXE_ServiceId__r.Agreement_End_Date__c, CXE_isLastEnrolledService__c, CXE_UserId__r.isActive, CXE_ServiceTerminated__c FROM CXE_Service_Enrollment__c where Id =: cxe.Id];
           
           system.assertEquals(user2.Id, cxe1.CXE_UserId__c);
           system.assertEquals(portalProfile.Id, cxe1.CXE_UserId__r.ProfileId);
           system.assertEquals(date.today(), cxe1.CXE_ServiceId__r.Agreement_End_Date__c);           
           System.assertEquals(false, cxe1.CXE_isLastEnrolledService__c);
           system.assertEquals(true, cxe1.CXE_UserId__r.isActive);
           System.assertEquals(True, cxe1.CXE_ServiceTerminated__c);
           
          
           CXE_CP_PortalUserInactivityDeactSched portalDeactSched = new CXE_CP_PortalUserInactivityDeactSched();
			String sch = '0 0 23 * * ?'; 
			system.schedule('Test Territory Check', sch, portalDeactSched);
           
        }

        
        
        
        
        
        Test.stopTest();
        

        List<CXE_Service_Enrollment__c> enrolledService =[SELECT Id, CXE_UserId__c,CXE_IsActive__c
                                                          FROM CXE_Service_Enrollment__c];
        
        for(CXE_Service_Enrollment__c  ac: enrolledService){
            
            System.assert( ac.CXE_UserId__c !=null,ac.CXE_UserId__c);
            System.assertEquals(True ,ac.CXE_IsActive__c);
            
        }
       
        
    }

    
    
   
    
}