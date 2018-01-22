/* Author: Joebhelle Rances
 * Date: OCT-23-2017
*/
@isTest
public class CXE_CP_PaperlessBillingUnSubscribe_Test {
    
    
    
    @testSetup static void createPortalUser(){
        
        
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
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        insert testCase;
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c ='12532635',
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Contract_External_ID__c = '16967',
                                             Bill_Print_Mode__c ='BILPRNT003',
                                             Type__c = 'Regular'
                                            );
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
            
            CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
            cxe.CXE_ServiceId__c = service.Id;
            cxe.CXE_UserId__c = user1.ID;
            cxe.CXE_IsActive__c =True;
            cxe.CXE_Type__c ='Payor';
            insert cxe;
        }
        
        User  portalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs(portalUser){
            CXE_CP_PaperlessBillingUnSubscribe.loadAccounts();
            CXE_CP_PaperlessBillingUnSubscribe.PortalData pdata = CXE_CP_PaperlessBillingUnSubscribe.insertCase(testContract.V10_Account_No__c,'reason',true);  
            System.assertEquals(true, pdata.ReturnMe != null);
            System.assertEquals(true, pdata.lockIn == null);
            
            CXE_CP_PaperlessBillingUnSubscribe.PortalData pdata1 = CXE_CP_PaperlessBillingUnSubscribe.insertCase(testContract.V10_Account_No__c,'reason',false);  
            System.assertEquals(true, pdata1.ReturnMe != null);
            System.assertEquals(true, pdata1.lockIn == null);
            
        }
        Test.stopTest();
    }    
    
    static testMethod void SingleEnrollmentRecordWithLockInPeriod(){
        
        // create a contract with a Billing Address
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        System.assertEquals(False,testAccount.IsPersonAccount );
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        insert testCase;
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c ='12532635',
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Contract_External_ID__c = '16967',
                                             Bill_Print_Mode__c ='BILPRNT003',
                                             Type__c = 'Regular',
                                             CXE_PaperlessBIllingEnrollment_Effective__c = Date.today()
                                            );
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
            
            CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
            cxe.CXE_ServiceId__c = service.Id;
            cxe.CXE_UserId__c = user1.ID;
            cxe.CXE_IsActive__c =True;
            cxe.CXE_Type__c ='Payor';
            insert cxe;
        }
        
        User  portalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs(portalUser){
            Date todayd = Date.today() - 1;
            String dtoday = String.valueOf(todayd.addMonths(6));
            CXE_CP_PaperlessBillingUnSubscribe.loadAccounts();
            CXE_CP_PaperlessBillingUnSubscribe.PortalData pdata = CXE_CP_PaperlessBillingUnSubscribe.insertCase(testContract.V10_Account_No__c,'reason',true);  
            
        }
        Test.stopTest();
    }
}