/* Author   : @JRances 
 * Date     : OCT-18-2017
 * Desc.    : Test Class/Code Coverage for CXE_CP_MyAccounts 
 * */

@isTest
public class CXE_CP_MyAccounts_Test {
    
    @testSetup
    static void createTestReqs(){
        
        User adminUser = CXE_TestDataFactory.createAdminUser();
        insert adminUser;
    }
    
    @isTest
    static void getBills(){
        Test.startTest();
        CXE_CP_MyAccounts.getBills();
        Test.stopTest();
    }
    
    @isTest
    static void test_SelectedDataWithV10AccountNum(){
        //CREATE CONTRACT WITH BILLING DETAILS
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
       
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
                
                //CREATE PORTAL USER CONTACT
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
                
                //CREATE SERVICE ENROLLMENT
                CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
                cxe.CXE_ServiceId__c = service.Id;
                cxe.CXE_UserId__c = pAccountPortalUser.Id;
                cxe.CXE_IsActive__c =True;
                insert cxe;
            }
        
        List<CXE_Service_Enrollment__c> selected = [SELECT CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c, CXE_ServiceId__r.Payor__r.V10_Account_No__c FROM CXE_Service_Enrollment__c];
        System.assertEquals(1, selected.size());
        
        // List<Account> selectedAccount = [SELECT Id, Name FROM Account WHERE Name= 'TestAccount'];
        //System.assertEquals(1, selectedAccount.size());
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            CXE_CP_MyAccounts.ReturnData returnNoAWA = CXE_CP_MyAccounts.SelectedData(selected[0].CXE_ServiceId__r.Payor__r.V10_Account_No__c, selected[0].CXE_ServiceId__r.SIN__c);
            System.assertEquals(returnNoAWA.AWA, 'No');
        }

        Account_Characteristic__c ac = new Account_Characteristic__c();
        ac.Type__c ='CWT';
        ac.Contract_ID__c = testContract.Id;
        insert ac;

        System.runAs ( userPortalUser ) {
            CXE_CP_MyAccounts.ReturnData returnWithAWA = CXE_CP_MyAccounts.SelectedData(selected[0].CXE_ServiceId__r.Payor__r.V10_Account_No__c, selected[0].CXE_ServiceId__r.SIN__c);
            System.assertEquals(returnWithAWA.AWA, 'Yes');
        }

        Test.stopTest(); 
    }

    @isTest
    static void test_SelectedDataNoV10AccountNum(){
        //CREATE CONTRACT WITH BILLING DETAILS
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
       
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
                
                //CREATE PORTAL USER CONTACT
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
                
                //CREATE SERVICE ENROLLMENT
                CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
                cxe.CXE_ServiceId__c = service.Id;
                cxe.CXE_UserId__c = pAccountPortalUser.Id;
                cxe.CXE_IsActive__c =True;
                insert cxe;
            }
        
        List<CXE_Service_Enrollment__c> selected = [SELECT CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c FROM CXE_Service_Enrollment__c];
        System.assertEquals(1, selected.size());
        
        // List<Account> selectedAccount = [SELECT Id, Name FROM Account WHERE Name= 'TestAccount'];
        //System.assertEquals(1, selectedAccount.size());
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            CXE_CP_MyAccounts.ReturnData returnNoAWA = CXE_CP_MyAccounts.SelectedData(null, selected[0].CXE_ServiceId__r.SIN__c);
            System.assertEquals(returnNoAWA.AWA, 'No');
        }

        Account_Characteristic__c ac = new Account_Characteristic__c();
        ac.Type__c ='CWT';
        ac.Contract_ID__c = testContract.Id;
        insert ac;

        System.runAs ( userPortalUser ) {
            CXE_CP_MyAccounts.ReturnData returnWithAWA = CXE_CP_MyAccounts.SelectedData(null, selected[0].CXE_ServiceId__r.SIN__c);
            System.assertEquals(returnWithAWA.AWA, 'Yes');
        }
        Test.stopTest(); 
    }

    @isTest
    static void test_TableData(){
        CXE_CP_MyAccounts.TableData tbdata = new CXE_CP_MyAccounts.TableData();
        tbdata.AccountId = 'AccountIdTest';
        tbdata.Address = 'AddressTest';
        tbdata.Status = 'StatusTest';
        tbdata.SinList = new List<Agreement__c>();

        System.assertEquals(tbdata.AccountId, 'AccountIdTest');
        System.assertEquals(tbdata.Address, 'AddressTest');
        System.assertEquals(tbdata.Status, 'StatusTest');
        System.assertEquals(tbdata.SinList.size(), 0);
    }
    
    @isTest
    static void test_changeAura(){
        //CREATE CONTRACT WITH BILLING DETAILS
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
                
                //CREATE PORTAL USER CONTACT
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
                
                //CREATE SERVICE ENROLLMENT
                CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
                cxe.CXE_ServiceId__c = service.Id;
                cxe.CXE_UserId__c = pAccountPortalUser.Id;
                cxe.CXE_IsActive__c =True;
                insert cxe;
            }
        
        List<CXE_Service_Enrollment__c> selected = [SELECT CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c FROM CXE_Service_Enrollment__c];
        System.assertEquals(1, selected.size());
        
        List<Account> selectedAccount = [SELECT Id, Name FROM Account WHERE Name= 'TestAccount'];
        System.assertEquals(1, selectedAccount.size());
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            CXE_CP_MyAccounts.changeAura(selected[0].CXE_ServiceId__r.SIN__c, 'NewAura');
            CXE_CP_MyAccounts.changeAura(selected[0].CXE_ServiceId__r.Id, 'NewAura');
        }
        Test.stopTest();
    }
    
    
   @isTest
    static void test_Unenroll(){
        //CREATE CONTRACT WITH BILLING DETAILS
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
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paperless',
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
            User  userSysAd =[SELECT ID FROM USER WHERE EMAIL ='bruce.wayne@wayneenterprises.com' ];
            User pAccountPortalUser = new User();
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
                
                //CREATE PORTAL USER CONTACT
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
                pAccountPortalUser = new User(
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
                insert cxe;
            }
        
        List<Account> selectedAccount = [SELECT Id, Name FROM Account WHERE Name= 'TestAccount'];
        System.assertEquals(1, selectedAccount.size());

        //User  userPortalUser = [SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs (pAccountPortalUser) {
            List<Contract> listContract = CXE_CP_MyAccounts.unenroll(testContract.V10_Account_No__c);
            System.assert(listContract.size() > 0);
        }

        List<Contract> listContract = CXE_CP_MyAccounts.unenroll(testContract.V10_Account_No__c);
        System.assert(listContract.size() == 0);
        
        Test.stopTest();

    }
    
    @isTest
    static void test_EnrollPaperless(){
        //CREATE CONTRACT WITH BILLING DETAILS
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
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paperplus',
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
                
                //CREATE PORTAL USER CONTACT
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
                
                //CREATE SERVICE ENROLLMENT
                CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
                cxe.CXE_ServiceId__c = service.Id;
                cxe.CXE_UserId__c = pAccountPortalUser.Id;
                cxe.CXE_IsActive__c =True;
                insert cxe;
            }
        
        //List<Agreement__c> selected = [SELECT Id, Account__r.Id FROM Agreement__c WHERE Id =: service.Id];
       // System.assertEquals(1, selected.size());
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        
        /*
         List<CXE_Service_Enrollment__c> getSignificantEnroll = [Select Id, CXE_ServiceId__c, CXE_Alias__c  
                                                                , CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c
                                                                , CXE_ServiceId__r.Payor__r.V10_Account_No__c
                                                                From CXE_Service_Enrollment__c WHERE  CXE_UserId__c =:userPortalUser.Id];
         
        
        System.assertEquals('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>asan ka',
                            String.valueOf(getSignificantEnroll[0].CXE_ServiceId__r.Account__c) + ' '+
                            String.valueOf(getSignificantEnroll[0].CXE_ServiceId__r.Payor__r.V10_Account_No__c ));
        
        
        */
       
       System.runAs ( userPortalUser ) {
           CXE_CP_MyAccounts.enrollPaperless(String.valueOf(testContract.V10_Account_No__c));
        }
        Test.stopTest();
        
}
    
    @isTest
    static void test_GetCaseVariables(){
        //CREATE CONTRACT WITH BILLING DETAILS
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
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;        
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress1 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress1);
        insert lstAddress;
        
        Test.startTest();
            //CREATE SERVICE
            Agreement__c service = new Agreement__c();
            service.Account__c = testAccount.Id;
            //service.Case__c = testCase.Id;
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
            service.SIN__c = '123456789123';
       		service.Service_Status__c = 'Active';
            insert service;
        
            List<Address__c> lstAddress2 = new List<Address__c>();
            Address__c testAddress2 = new Address__c(Type__c = 'Service', Service__c = Service.id, Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
                      
            lstAddress2.add(testAddress2);
            insert lstAddress2;
            //GET SYSTEM AD USER
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
                
                //CREATE PORTAL USER CONTACT
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
                
                //CREATE SERVICE ENROLLMENT
                CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
                cxe.CXE_ServiceId__c = service.Id;
                cxe.CXE_UserId__c = pAccountPortalUser.Id;
                cxe.CXE_IsActive__c =True;
                insert cxe;
            }

      //  List<Agreement__c> selectedSIN = [SELECT Id, SIN__c  FROM Agreement__c WHERE SIN__c= '123456789123'];
       // System.assertEquals(1, selectedSIN.size());
        
        List<Agreement__c> serviceList = [SELECT Id, SIN__c FROM Agreement__c ];//WHERE SIN__c =:selectedSIN[0].Id];
       // System.assertEquals(null, serviceList[0].SIN__c);
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            CXE_CP_MyAccounts.getCaseVariable(null, 'Active');
            CXE_CP_MyAccounts.getCaseVariable(serviceList[0].SIN__c, 'Active');
        }
        Test.stopTest();
        
    }

    @isTest
    static void test_ListOfServices_WithSinWithAccountEnrollBiz(){
        //CREATE CONTRACT WITH BILLING DETAILS
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
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
       
        
        //start ra
         Contract testContract1 = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345687',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract1;
        //end ra
        
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        Test.startTest();
            List<Agreement__c> serviceList = new List<Agreement__c>();
            
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
            service.SIN__c = '123456789123';
            serviceList.add(service);   
      
            Agreement__c service1 = new Agreement__c();
            service1.Account__c = testAccount.Id;
            service1.Case__c = testCase.Id;
            service1.Contract__c = testContract.Id;
            service1.Rate__c = 'General Power (GP)';
            service1.Segment__c = 'Home and Micro Business';
            service1.Service_Supply_Type__c = 'Normal with meter';
            service1.Service_Wire_Material__c = 'Copper';
            service1.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service1.Service_Wire_Size__c = '#1/0';
            service1.Service_Wire_Type__c = 'Under Copper,Lateral';
            service1.Voltage_Level__c = '4.8 kV';
            service1.Applied_Load__c = 50; 
            service1.Payor__c= testContract1.Id;
            service1.SIN__c = '123456789321';
            serviceList.add(service1);
           
            Agreement__c service2 = new Agreement__c();
            service2.Account__c = testAccount.Id;
            service2.Case__c = testCase.Id;
            service2.Contract__c = testContract.Id;
            service2.Rate__c = 'General Power (GP)';
            service2.Segment__c = 'Home and Micro Business';
            service2.Service_Supply_Type__c = 'Normal with meter';
            service2.Service_Wire_Material__c = 'Copper';
            service2.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service2.Service_Wire_Size__c = '#1/0';
            service2.Service_Wire_Type__c = 'Under Copper,Lateral';
            service2.Voltage_Level__c = '4.8 kV';
            service2.Applied_Load__c = 50; 
            service2.Payor__c= testContract1.Id;
            service2.SIN__c = '123456789132';
            serviceList.add(service2);
            insert serviceList;

        
            List<Agreement__c> checkService = [SELECT ID from Agreement__c];
            
            //GET SYSTEM AD USER
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
                
                //CREATE PORTAL USER CONTACT
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
                
                List<CXE_Service_Enrollment__c> serviceEnrollList = new List<CXE_Service_Enrollment__c>();
                //CREATE SERVICE ENROLLMENT
                CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
                cxe.CXE_ServiceId__c = serviceList[0].Id;
                cxe.CXE_UserId__c = pAccountPortalUser.Id;
                cxe.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe);
                
                CXE_Service_Enrollment__c cxe1 = new CXE_Service_Enrollment__c();
                cxe1.CXE_ServiceId__c = serviceList[1].Id;
                cxe1.CXE_UserId__c = pAccountPortalUser.Id;
                cxe1.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe1);
                
                CXE_Service_Enrollment__c cxe2 = new CXE_Service_Enrollment__c();
                cxe2.CXE_ServiceId__c = serviceList[2].Id;
                cxe2.CXE_UserId__c = pAccountPortalUser.Id;
                cxe2.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe2);

                insert serviceEnrollList;
                
            }
        
        List<CXE_Service_Enrollment__c> selected = [SELECT CXE_ServiceId__r.Payor__r.V10_Account_No__c, CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c FROM CXE_Service_Enrollment__c]; //where CXE_ServiceId__c =: '123456789123'];
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c, selected[0].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            //CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c,'none' );
            //CXE_CP_MyAccounts.ListofServices('none', Selected[1].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            //CXE_CP_MyAccounts.ListofServices('none', 'none');
        }
        Test.stopTest();
    }

    @isTest
    static void test_ListOfServices_WithSinWithAccountCancelInd(){
        //CREATE CONTRACT WITH BILLING DETAILS
        List<Account> testAccountList = CXE_TestDataFactory.createPersonAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        testCase.Application_for_Business_Customer__c = false;
        testCase.Application_for_Residential_Customer__c  = true;
        insert testCase;
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
       
        
        //start ra
         Contract testContract1 = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345687',
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract1;
        //end ra
        
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        Test.startTest();
            List<Agreement__c> serviceList = new List<Agreement__c>();
            
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
            service.SIN__c = '123456789123';
            serviceList.add(service);   
      
            Agreement__c service1 = new Agreement__c();
            service1.Account__c = testAccount.Id;
            service1.Case__c = testCase.Id;
            service1.Contract__c = testContract.Id;
            service1.Rate__c = 'General Power (GP)';
            service1.Segment__c = 'Home and Micro Business';
            service1.Service_Supply_Type__c = 'Normal with meter';
            service1.Service_Wire_Material__c = 'Copper';
            service1.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service1.Service_Wire_Size__c = '#1/0';
            service1.Service_Wire_Type__c = 'Under Copper,Lateral';
            service1.Voltage_Level__c = '4.8 kV';
            service1.Applied_Load__c = 50; 
            service1.Payor__c= testContract1.Id;
            service1.SIN__c = '123456789321';
            serviceList.add(service1);
           
            Agreement__c service2 = new Agreement__c();
            service2.Account__c = testAccount.Id;
            service2.Case__c = testCase.Id;
            service2.Contract__c = testContract.Id;
            service2.Rate__c = 'General Power (GP)';
            service2.Segment__c = 'Home and Micro Business';
            service2.Service_Supply_Type__c = 'Normal with meter';
            service2.Service_Wire_Material__c = 'Copper';
            service2.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service2.Service_Wire_Size__c = '#1/0';
            service2.Service_Wire_Type__c = 'Under Copper,Lateral';
            service2.Voltage_Level__c = '4.8 kV';
            service2.Applied_Load__c = 50; 
            service2.Payor__c= testContract1.Id;
            service2.SIN__c = '123456789132';
            serviceList.add(service2);
            insert serviceList;

        
            List<Agreement__c> checkService = [SELECT ID from Agreement__c];
            
            //GET SYSTEM AD USER
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
                
                //CREATE PORTAL USER CONTACT
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
                
                List<CXE_Service_Enrollment__c> serviceEnrollList = new List<CXE_Service_Enrollment__c>();
                //CREATE SERVICE ENROLLMENT
                CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
                cxe.CXE_ServiceId__c = serviceList[0].Id;
                cxe.CXE_UserId__c = pAccountPortalUser.Id;
                cxe.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe);
                
                CXE_Service_Enrollment__c cxe1 = new CXE_Service_Enrollment__c();
                cxe1.CXE_ServiceId__c = serviceList[1].Id;
                cxe1.CXE_UserId__c = pAccountPortalUser.Id;
                cxe1.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe1);
                
                CXE_Service_Enrollment__c cxe2 = new CXE_Service_Enrollment__c();
                cxe2.CXE_ServiceId__c = serviceList[2].Id;
                cxe2.CXE_UserId__c = pAccountPortalUser.Id;
                cxe2.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe2);

                insert serviceEnrollList;
                
            }
        
        List<CXE_Service_Enrollment__c> selected = [SELECT CXE_ServiceId__r.Payor__r.V10_Account_No__c, CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c FROM CXE_Service_Enrollment__c]; //where CXE_ServiceId__c =: '123456789123'];
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c, selected[0].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            //CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c,'none' );
            //CXE_CP_MyAccounts.ListofServices('none', Selected[1].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            //CXE_CP_MyAccounts.ListofServices('none', 'none');
        }
        Test.stopTest();
    }

    @isTest
    static void test_ListOfServices_WithSinNoAccount_EnrollBiz(){
        //CREATE CONTRACT WITH BILLING DETAILS
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
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
       
        
        //start ra
         Contract testContract1 = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345687',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract1;
        //end ra
        
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        Test.startTest();
            List<Agreement__c> serviceList = new List<Agreement__c>();
            
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
            service.SIN__c = '123456789123';
            serviceList.add(service);   
      
            Agreement__c service1 = new Agreement__c();
            service1.Account__c = testAccount.Id;
            service1.Case__c = testCase.Id;
            service1.Contract__c = testContract.Id;
            service1.Rate__c = 'General Power (GP)';
            service1.Segment__c = 'Home and Micro Business';
            service1.Service_Supply_Type__c = 'Normal with meter';
            service1.Service_Wire_Material__c = 'Copper';
            service1.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service1.Service_Wire_Size__c = '#1/0';
            service1.Service_Wire_Type__c = 'Under Copper,Lateral';
            service1.Voltage_Level__c = '4.8 kV';
            service1.Applied_Load__c = 50; 
            service1.Payor__c= testContract1.Id;
            service1.SIN__c = '123456789321';
            serviceList.add(service1);
           
            Agreement__c service2 = new Agreement__c();
            service2.Account__c = testAccount.Id;
            service2.Case__c = testCase.Id;
            service2.Contract__c = testContract.Id;
            service2.Rate__c = 'General Power (GP)';
            service2.Segment__c = 'Home and Micro Business';
            service2.Service_Supply_Type__c = 'Normal with meter';
            service2.Service_Wire_Material__c = 'Copper';
            service2.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service2.Service_Wire_Size__c = '#1/0';
            service2.Service_Wire_Type__c = 'Under Copper,Lateral';
            service2.Voltage_Level__c = '4.8 kV';
            service2.Applied_Load__c = 50; 
            service2.Payor__c= testContract.Id;
            service2.SIN__c = '123456789132';
            serviceList.add(service2);
            insert serviceList;

        
            List<Agreement__c> checkService = [SELECT ID from Agreement__c];
            
            //GET SYSTEM AD USER
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
                
                //CREATE PORTAL USER CONTACT
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
                
                List<CXE_Service_Enrollment__c> serviceEnrollList = new List<CXE_Service_Enrollment__c>();
                //CREATE SERVICE ENROLLMENT
                CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
                cxe.CXE_ServiceId__c = serviceList[0].Id;
                cxe.CXE_UserId__c = pAccountPortalUser.Id;
                cxe.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe);
                
                CXE_Service_Enrollment__c cxe1 = new CXE_Service_Enrollment__c();
                cxe1.CXE_ServiceId__c = serviceList[1].Id;
                cxe1.CXE_UserId__c = pAccountPortalUser.Id;
                cxe1.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe1);
                
                CXE_Service_Enrollment__c cxe2 = new CXE_Service_Enrollment__c();
                cxe2.CXE_ServiceId__c = serviceList[2].Id;
                cxe2.CXE_UserId__c = pAccountPortalUser.Id;
                cxe2.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe2);

                insert serviceEnrollList;
                
            }
        
        List<CXE_Service_Enrollment__c> selected = [SELECT CXE_ServiceId__r.Payor__r.V10_Account_No__c, CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c FROM CXE_Service_Enrollment__c]; //where CXE_ServiceId__c =: '123456789123'];
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            //CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c, selected[0].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c,'none' );
            //CXE_CP_MyAccounts.ListofServices('none', Selected[1].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            //CXE_CP_MyAccounts.ListofServices('none', 'none');
        }
        Test.stopTest();
    }

    @isTest
    static void test_ListOfServices_WithSinNoAccount_CancelInd(){
        //CREATE CONTRACT WITH BILLING DETAILS
        List<Account> testAccountList = CXE_TestDataFactory.createPersonAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        testCase.Application_for_Business_Customer__c = false;
        testCase.Application_for_Residential_Customer__c  = true;
        insert testCase;
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
       
        
        //start ra
         Contract testContract1 = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345687',
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract1;
        //end ra
        
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        Test.startTest();
            List<Agreement__c> serviceList = new List<Agreement__c>();
            
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
            service.SIN__c = '123456789123';
            serviceList.add(service);   
      
            Agreement__c service1 = new Agreement__c();
            service1.Account__c = testAccount.Id;
            service1.Case__c = testCase.Id;
            service1.Contract__c = testContract.Id;
            service1.Rate__c = 'General Power (GP)';
            service1.Segment__c = 'Home and Micro Business';
            service1.Service_Supply_Type__c = 'Normal with meter';
            service1.Service_Wire_Material__c = 'Copper';
            service1.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service1.Service_Wire_Size__c = '#1/0';
            service1.Service_Wire_Type__c = 'Under Copper,Lateral';
            service1.Voltage_Level__c = '4.8 kV';
            service1.Applied_Load__c = 50; 
            service1.Payor__c= testContract1.Id;
            service1.SIN__c = '123456789321';
            serviceList.add(service1);
           
            Agreement__c service2 = new Agreement__c();
            service2.Account__c = testAccount.Id;
            service2.Case__c = testCase.Id;
            service2.Contract__c = testContract.Id;
            service2.Rate__c = 'General Power (GP)';
            service2.Segment__c = 'Home and Micro Business';
            service2.Service_Supply_Type__c = 'Normal with meter';
            service2.Service_Wire_Material__c = 'Copper';
            service2.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service2.Service_Wire_Size__c = '#1/0';
            service2.Service_Wire_Type__c = 'Under Copper,Lateral';
            service2.Voltage_Level__c = '4.8 kV';
            service2.Applied_Load__c = 50; 
            service2.Payor__c= testContract1.Id;
            service2.SIN__c = '123456789132';
            serviceList.add(service2);
            insert serviceList;

        
            List<Agreement__c> checkService = [SELECT ID from Agreement__c];
            
            //GET SYSTEM AD USER
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
                
                //CREATE PORTAL USER CONTACT
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
                
                List<CXE_Service_Enrollment__c> serviceEnrollList = new List<CXE_Service_Enrollment__c>();
                //CREATE SERVICE ENROLLMENT
                CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
                cxe.CXE_ServiceId__c = serviceList[0].Id;
                cxe.CXE_UserId__c = pAccountPortalUser.Id;
                cxe.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe);
                
                CXE_Service_Enrollment__c cxe1 = new CXE_Service_Enrollment__c();
                cxe1.CXE_ServiceId__c = serviceList[0].Id;
                cxe1.CXE_UserId__c = pAccountPortalUser.Id;
                cxe1.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe1);
                
                CXE_Service_Enrollment__c cxe2 = new CXE_Service_Enrollment__c();
                cxe2.CXE_ServiceId__c = serviceList[2].Id;
                cxe2.CXE_UserId__c = pAccountPortalUser.Id;
                cxe2.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe2);

                insert serviceEnrollList;
                
            }
        
        List<CXE_Service_Enrollment__c> selected = [SELECT CXE_ServiceId__r.Payor__r.V10_Account_No__c, CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c FROM CXE_Service_Enrollment__c where CXE_ServiceId__c =: serviceList[0].Id]; //where CXE_ServiceId__c =: '123456789123'];
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            //CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c, selected[0].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c,'none' );
            //CXE_CP_MyAccounts.ListofServices('none', Selected[1].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            //CXE_CP_MyAccounts.ListofServices('none', 'none');
        }
        Test.stopTest();
    }

    @isTest
    static void test_ListOfServices_NoSinWithAccount_EnrolBiz(){
        //CREATE CONTRACT WITH BILLING DETAILS
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
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
       
        
        //start ra
         Contract testContract1 = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345677',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract1;
        //end ra
        
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        Test.startTest();
            List<Agreement__c> serviceList = new List<Agreement__c>();
            
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
            service.SIN__c = '123456789123';
            serviceList.add(service);   
      
            Agreement__c service1 = new Agreement__c();
            service1.Account__c = testAccount.Id;
            service1.Case__c = testCase.Id;
            service1.Contract__c = testContract.Id;
            service1.Rate__c = 'General Power (GP)';
            service1.Segment__c = 'Home and Micro Business';
            service1.Service_Supply_Type__c = 'Normal with meter';
            service1.Service_Wire_Material__c = 'Copper';
            service1.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service1.Service_Wire_Size__c = '#1/0';
            service1.Service_Wire_Type__c = 'Under Copper,Lateral';
            service1.Voltage_Level__c = '4.8 kV';
            service1.Applied_Load__c = 50; 
            service1.Payor__c= testContract1.Id;
            service1.SIN__c = '123456789321';
            serviceList.add(service1);
           
            Agreement__c service2 = new Agreement__c();
            service2.Account__c = testAccount.Id;
            service2.Case__c = testCase.Id;
            service2.Contract__c = testContract.Id;
            service2.Rate__c = 'General Power (GP)';
            service2.Segment__c = 'Home and Micro Business';
            service2.Service_Supply_Type__c = 'Normal with meter';
            service2.Service_Wire_Material__c = 'Copper';
            service2.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service2.Service_Wire_Size__c = '#1/0';
            service2.Service_Wire_Type__c = 'Under Copper,Lateral';
            service2.Voltage_Level__c = '4.8 kV';
            service2.Applied_Load__c = 50; 
            service2.Payor__c= testContract1.Id;
            service2.SIN__c = '123456789132';
            serviceList.add(service2);
            insert serviceList;

        
            List<Agreement__c> checkService = [SELECT ID from Agreement__c];
            
            //GET SYSTEM AD USER
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
                
                //CREATE PORTAL USER CONTACT
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
                
                List<CXE_Service_Enrollment__c> serviceEnrollList = new List<CXE_Service_Enrollment__c>();
                //CREATE SERVICE ENROLLMENT
                CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
                cxe.CXE_ServiceId__c = serviceList[0].Id;
                cxe.CXE_UserId__c = pAccountPortalUser.Id;
                cxe.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe);
                
                CXE_Service_Enrollment__c cxe1 = new CXE_Service_Enrollment__c();
                cxe1.CXE_ServiceId__c = serviceList[1].Id;
                cxe1.CXE_UserId__c = pAccountPortalUser.Id;
                cxe1.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe1);
                
                CXE_Service_Enrollment__c cxe2 = new CXE_Service_Enrollment__c();
                cxe2.CXE_ServiceId__c = serviceList[2].Id;
                cxe2.CXE_UserId__c = pAccountPortalUser.Id;
                cxe2.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe2);

                insert serviceEnrollList;
                
            }
        
        List<CXE_Service_Enrollment__c> selected = [SELECT CXE_ServiceId__r.Payor__r.V10_Account_No__c, CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c FROM CXE_Service_Enrollment__c where CXE_ServiceId__r.Payor__c =: testContract1.Id]; //where CXE_ServiceId__c =: '123456789123'];
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            //CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c, selected[0].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            //CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c,'none' );
            CXE_CP_MyAccounts.ListofServices('none', selected[0].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            //CXE_CP_MyAccounts.ListofServices('none', 'none');
        }
        Test.stopTest();
    }

    @isTest
    static void test_ListOfServices_NoSinWithAccount_CancelInd(){
        //CREATE CONTRACT WITH BILLING DETAILS
        List<Account> testAccountList = CXE_TestDataFactory.createPersonAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        testCase.Application_for_Business_Customer__c = false;
        testCase.Application_for_Residential_Customer__c  = true;
        insert testCase;
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
       
        
        //start ra
         Contract testContract1 = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345687',
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract1;
        //end ra
        
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        Test.startTest();
            List<Agreement__c> serviceList = new List<Agreement__c>();
            
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
            service.SIN__c = '123456789123';
            serviceList.add(service);   
      
            Agreement__c service1 = new Agreement__c();
            service1.Account__c = testAccount.Id;
            service1.Case__c = testCase.Id;
            service1.Contract__c = testContract.Id;
            service1.Rate__c = 'General Power (GP)';
            service1.Segment__c = 'Home and Micro Business';
            service1.Service_Supply_Type__c = 'Normal with meter';
            service1.Service_Wire_Material__c = 'Copper';
            service1.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service1.Service_Wire_Size__c = '#1/0';
            service1.Service_Wire_Type__c = 'Under Copper,Lateral';
            service1.Voltage_Level__c = '4.8 kV';
            service1.Applied_Load__c = 50; 
            service1.Payor__c= testContract1.Id;
            service1.SIN__c = '123456789321';
            serviceList.add(service1);
           
            Agreement__c service2 = new Agreement__c();
            service2.Account__c = testAccount.Id;
            service2.Case__c = testCase.Id;
            service2.Contract__c = testContract.Id;
            service2.Rate__c = 'General Power (GP)';
            service2.Segment__c = 'Home and Micro Business';
            service2.Service_Supply_Type__c = 'Normal with meter';
            service2.Service_Wire_Material__c = 'Copper';
            service2.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service2.Service_Wire_Size__c = '#1/0';
            service2.Service_Wire_Type__c = 'Under Copper,Lateral';
            service2.Voltage_Level__c = '4.8 kV';
            service2.Applied_Load__c = 50; 
            service2.Payor__c= testContract1.Id;
            service2.SIN__c = '123456789132';
            serviceList.add(service2);
            insert serviceList;

        
            List<Agreement__c> checkService = [SELECT ID from Agreement__c];
            
            //GET SYSTEM AD USER
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
                
                //CREATE PORTAL USER CONTACT
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
                
                List<CXE_Service_Enrollment__c> serviceEnrollList = new List<CXE_Service_Enrollment__c>();
                //CREATE SERVICE ENROLLMENT
                CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
                cxe.CXE_ServiceId__c = serviceList[0].Id;
                cxe.CXE_UserId__c = pAccountPortalUser.Id;
                cxe.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe);
                
                CXE_Service_Enrollment__c cxe1 = new CXE_Service_Enrollment__c();
                cxe1.CXE_ServiceId__c = serviceList[1].Id;
                cxe1.CXE_UserId__c = pAccountPortalUser.Id;
                cxe1.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe1);
                
                CXE_Service_Enrollment__c cxe2 = new CXE_Service_Enrollment__c();
                cxe2.CXE_ServiceId__c = serviceList[2].Id;
                cxe2.CXE_UserId__c = pAccountPortalUser.Id;
                cxe2.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe2);

                insert serviceEnrollList;
                
            }
        
        List<CXE_Service_Enrollment__c> selected = [SELECT CXE_ServiceId__r.Payor__r.V10_Account_No__c, CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c FROM CXE_Service_Enrollment__c]; //where CXE_ServiceId__c =: '123456789123'];
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            //CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c, selected[0].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            //CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c,'none' );
            CXE_CP_MyAccounts.ListofServices('none', Selected[1].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            //CXE_CP_MyAccounts.ListofServices('none', 'none');
        }
        Test.stopTest();
    }

    @isTest
    static void test_ListOfServices_NoSinNoAccount_EnrollBiz(){
        //CREATE CONTRACT WITH BILLING DETAILS
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
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
       
        
        //start ra
         Contract testContract1 = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345687',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract1;
        //end ra
        
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        Test.startTest();
            List<Agreement__c> serviceList = new List<Agreement__c>();
            
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
            service.SIN__c = '123456789123';
            serviceList.add(service);   
      
            Agreement__c service1 = new Agreement__c();
            service1.Account__c = testAccount.Id;
            service1.Case__c = testCase.Id;
            service1.Contract__c = testContract.Id;
            service1.Rate__c = 'General Power (GP)';
            service1.Segment__c = 'Home and Micro Business';
            service1.Service_Supply_Type__c = 'Normal with meter';
            service1.Service_Wire_Material__c = 'Copper';
            service1.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service1.Service_Wire_Size__c = '#1/0';
            service1.Service_Wire_Type__c = 'Under Copper,Lateral';
            service1.Voltage_Level__c = '4.8 kV';
            service1.Applied_Load__c = 50; 
            service1.Payor__c= testContract1.Id;
            service1.SIN__c = '123456789321';
            serviceList.add(service1);
           
            Agreement__c service2 = new Agreement__c();
            service2.Account__c = testAccount.Id;
            service2.Case__c = testCase.Id;
            service2.Contract__c = testContract.Id;
            service2.Rate__c = 'General Power (GP)';
            service2.Segment__c = 'Home and Micro Business';
            service2.Service_Supply_Type__c = 'Normal with meter';
            service2.Service_Wire_Material__c = 'Copper';
            service2.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service2.Service_Wire_Size__c = '#1/0';
            service2.Service_Wire_Type__c = 'Under Copper,Lateral';
            service2.Voltage_Level__c = '4.8 kV';
            service2.Applied_Load__c = 50; 
            service2.Payor__c= testContract1.Id;
            service2.SIN__c = '123456789132';
            serviceList.add(service2);
            insert serviceList;

        
            List<Agreement__c> checkService = [SELECT ID from Agreement__c];
            
            //GET SYSTEM AD USER
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
                
                //CREATE PORTAL USER CONTACT
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
                
                List<CXE_Service_Enrollment__c> serviceEnrollList = new List<CXE_Service_Enrollment__c>();
                //CREATE SERVICE ENROLLMENT
                CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
                cxe.CXE_ServiceId__c = serviceList[0].Id;
                cxe.CXE_UserId__c = pAccountPortalUser.Id;
                cxe.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe);
                
                CXE_Service_Enrollment__c cxe1 = new CXE_Service_Enrollment__c();
                cxe1.CXE_ServiceId__c = serviceList[1].Id;
                cxe1.CXE_UserId__c = pAccountPortalUser.Id;
                cxe1.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe1);
                
                CXE_Service_Enrollment__c cxe2 = new CXE_Service_Enrollment__c();
                cxe2.CXE_ServiceId__c = serviceList[2].Id;
                cxe2.CXE_UserId__c = pAccountPortalUser.Id;
                cxe2.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe2);

                insert serviceEnrollList;
                
            }
        
        List<CXE_Service_Enrollment__c> selected = [SELECT CXE_ServiceId__r.Payor__r.V10_Account_No__c, CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c FROM CXE_Service_Enrollment__c]; //where CXE_ServiceId__c =: '123456789123'];
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            //CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c, selected[0].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            //CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c,'none' );
            //CXE_CP_MyAccounts.ListofServices('none', Selected[1].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            CXE_CP_MyAccounts.ListofServices('none', 'none');
        }
        Test.stopTest();
    }

    @isTest
    static void test_ListOfServices_NoSinNoAccount_CancelInd(){
        //CREATE CONTRACT WITH BILLING DETAILS
        List<Account> testAccountList = CXE_TestDataFactory.createPersonAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        //System.assertEquals(true,testAccount.IsPersonAccount );
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        testCase.Application_for_Business_Customer__c = false;
        testCase.Application_for_Residential_Customer__c  = true;
        insert testCase;
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
       
        
        //start ra
         Contract testContract1 = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345687',
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract1;
        //end ra
        
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        Test.startTest();
            List<Agreement__c> serviceList = new List<Agreement__c>();
            
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
            service.SIN__c = '123456789123';
            serviceList.add(service);   
      
            Agreement__c service1 = new Agreement__c();
            service1.Account__c = testAccount.Id;
            service1.Case__c = testCase.Id;
            service1.Contract__c = testContract.Id;
            service1.Rate__c = 'General Power (GP)';
            service1.Segment__c = 'Home and Micro Business';
            service1.Service_Supply_Type__c = 'Normal with meter';
            service1.Service_Wire_Material__c = 'Copper';
            service1.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service1.Service_Wire_Size__c = '#1/0';
            service1.Service_Wire_Type__c = 'Under Copper,Lateral';
            service1.Voltage_Level__c = '4.8 kV';
            service1.Applied_Load__c = 50; 
            service1.Payor__c= testContract1.Id;
            service1.SIN__c = '123456789321';
            serviceList.add(service1);
           
            Agreement__c service2 = new Agreement__c();
            service2.Account__c = testAccount.Id;
            service2.Case__c = testCase.Id;
            service2.Contract__c = testContract.Id;
            service2.Rate__c = 'General Power (GP)';
            service2.Segment__c = 'Home and Micro Business';
            service2.Service_Supply_Type__c = 'Normal with meter';
            service2.Service_Wire_Material__c = 'Copper';
            service2.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service2.Service_Wire_Size__c = '#1/0';
            service2.Service_Wire_Type__c = 'Under Copper,Lateral';
            service2.Voltage_Level__c = '4.8 kV';
            service2.Applied_Load__c = 50; 
            service2.Payor__c= testContract1.Id;
            service2.SIN__c = '123456789132';
            serviceList.add(service2);
            insert serviceList;

        
            List<Agreement__c> checkService = [SELECT ID from Agreement__c];
            
            //GET SYSTEM AD USER
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
                
                //CREATE PORTAL USER CONTACT
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
                
                List<CXE_Service_Enrollment__c> serviceEnrollList = new List<CXE_Service_Enrollment__c>();
                //CREATE SERVICE ENROLLMENT
                CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
                cxe.CXE_ServiceId__c = serviceList[0].Id;
                cxe.CXE_UserId__c = pAccountPortalUser.Id;
                cxe.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe);
                
                CXE_Service_Enrollment__c cxe1 = new CXE_Service_Enrollment__c();
                cxe1.CXE_ServiceId__c = serviceList[1].Id;
                cxe1.CXE_UserId__c = pAccountPortalUser.Id;
                cxe1.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe1);
                
                CXE_Service_Enrollment__c cxe2 = new CXE_Service_Enrollment__c();
                cxe2.CXE_ServiceId__c = serviceList[2].Id;
                cxe2.CXE_UserId__c = pAccountPortalUser.Id;
                cxe2.CXE_IsActive__c =True;
                serviceEnrollList.add(cxe2);

                insert serviceEnrollList;
                
            }
        
        List<CXE_Service_Enrollment__c> selected = [SELECT CXE_ServiceId__r.Payor__r.V10_Account_No__c, CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c FROM CXE_Service_Enrollment__c]; //where CXE_ServiceId__c =: '123456789123'];
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            //CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c, selected[0].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            //CXE_CP_MyAccounts.ListofServices(selected[0].CXE_ServiceId__r.SIN__c,'none' );
            //CXE_CP_MyAccounts.ListofServices('none', Selected[1].CXE_ServiceId__r.Payor__r.V10_Account_No__c);
            CXE_CP_MyAccounts.ListofServices('none', 'none');
        }
        Test.stopTest();
    }
}