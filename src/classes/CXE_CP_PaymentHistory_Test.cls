@isTest
public class CXE_CP_PaymentHistory_Test {
    @testSetup
    static void createTestReqs(){
        
        //CREATE SYSTEM ADMIN USER
        UserRole pRoleNone = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profSysAd = [Select Id from Profile where name = 'System Administrator'];
        
        User pAccountSysAd = new User(
            UserRoleId = pRoleNone.Id,
            ProfileId = profSysAd.Id,
            Username = System.now().millisecond() + 'bwtest@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
            
        );
        Database.insert(pAccountSysAd);
    }
    
    @isTest
    static void test_retrievePayment(){
        //CREATE CONTRACT WITH BILLING DETAILS
        User  userSysAd =[SELECT ID FROM USER WHERE EMAIL ='bruce.wayne@wayneenterprises.com' ];
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        testAccountList[0].OwnerId = userSysAd.Id;
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        System.assertEquals(False,testAccount.IsPersonAccount );
        System.assertEquals('Test0', testAccount.Name);
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        insert testCase;
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        Test.startTest();
        //CREATE SERVICE
        Agreement__c service = new Agreement__c();
        service.Account__c = testAccount.Id;
        service.Case__c = testCase.Id;
        service.Contract__c = testContract.Id;
        service.Rate__c = 'General Power (GP)';
        service.Segment__c = 'Home and Micro Business';
        service.Service_Supply_Type__c = 'Normal with meter';
        service.Service_Wire_Material__c = 'Copper';
        service.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
        service.Service_Wire_Size__c = '#1/0';
        service.Service_Wire_Type__c = 'Under Copper,Lateral';
        service.Voltage_Level__c = '4.8 kV';
        service.Applied_Load__c = 50; 
        service.Payor__c= testContract.Id;
        insert service;
        service.SIN__c = '123456789123';
        update service;
        //GET SYSTEM AD USER
      
        System.runAs ( userSysAd ) {
           /* Account account1 = new Account(
                Name = 'TestAccount',
                OwnerId = userSysAd.Id,
                Phone = '+63021234567',
                Tax_Identification_No__c = '123456789012',
                Mobile_Phone__c = '+630000000000',
                Email__c = 'test@test.com'
            );
            Database.insert(account1);
            */
            //CREATE PORTAL USER CONTACT
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = testAccount.Id,
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
            
            //CREATE SERVICE ENROLLMENT
            CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
            cxe.CXE_ServiceId__c = service.Id;
            cxe.CXE_UserId__c = pAccountPortalUser.Id;
            cxe.CXE_IsActive__c =True;
            cxe.CXE_Type__c = 'Payor';
            insert cxe;
            
        }
        
        List<Account> acct =[SELECT Id, Name FROM Account WHERE Name = 'TEST0'];
        
        System.assertEquals('TEST0', acct[0].Name); //assertion failed
        
        User  userPortalUser =[SELECT Id FROM USER WHERE EMAIL ='test12345@test.com'];
        
        System.runAs ( userPortalUser ) {
            
            Contract ctrct = [SELECT Id, V10_Account_No__c FROM Contract WHERE AccountId =:acct[0].Id];
            System.assertEquals('12345678', ctrct.V10_Account_No__c);
            
            List<String> acctList = new List<String>();
            acctList.add('48990832');//(String.valueOf(ctrct.V10_Account_No__c));
           // System.assertEquals(String.valueOf(ctrct.V10_Account_No__c), null);
            Date startdate = date.newInstance(2017, 1, 1);
            Date enddate = date.newInstance(2017, 12, 1);
            
            CXE_TestDataFactory.setOrgSettings();
            CXE_CP_PaymentHistory.retrievePayment();
            CXE_HerokuApps.getAllPaymentsByAccountNos(acctList,startdate,enddate);
            
            /* try {
            CXE_CP_PaymentHistory.retrievePayment();
                System.assertEquals(1, acct.size());
                System.assertEquals('12345678', ctrct.V10_Account_No__c );
                } catch (exception e) {
                Boolean expectedExceptionThrown =  e.getMessage().contains('My Error Message') ? true:false;
                System.AssertEquals(expectedExceptionThrown, true);
                system.debug(e.getMessage());
            }  */
        }
        Test.stopTest();
    }
    
    
    @isTest
    static void test_comparableEqualZero(){
        
        Test.startTest();
         
      
        
        CXE_CP_PaymentHistory.paymentList compare1  = new  CXE_CP_PaymentHistory.paymentList();
        compare1.AmountPaid =100.00;
        compare1.PaymentDate ='10/17/2017';
        compare1.PaymentMode ='Posted';
        compare1.PaymentStatus ='Pending';
        compare1.PostingDate ='10/17/2017';

        CXE_CP_PaymentHistory.paymentList compare2 = new  CXE_CP_PaymentHistory.paymentList();
        compare2.AmountPaid =200.00;
        compare2.PaymentDate ='10/17/2017';
        compare2.PaymentMode ='Posted';
        compare2.PaymentStatus ='Paid';
        compare2.PostingDate ='10/17/2017';
        
        Integer num =compare1.compareTo(compare1);
        
        
        Test.stopTest();
        
       System.assertEquals(0,num );
        

    }
    
     
   
}