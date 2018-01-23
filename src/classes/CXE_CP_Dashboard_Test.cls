/* Author   : @JRances 
 * Date     : OCT-19-2017
 * Desc.    : Test Class/Code Coverage for CXE_CP_Dashboard
 * */

@isTest
public class CXE_CP_Dashboard_Test {

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
    static void test_LoginDetails(){
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
                    LanguageLocaleKey = 'en_US',
                    By_Pass_Validation__c = true
                );
                Database.insert(pAccountPortalUser);
                
            }
        
        User  userPortalUser =[SELECT Id FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            CXE_CP_Dashboard.LoginDetails();
        }
        Test.stopTest();
        
        Contact cont = [SELECT Id FROM Contact WHERE FirstName ='Test' AND LastName = 'McTesty'];
        User loggedInUser =[SELECT Id, ContactId FROM User WHERE EMAIL ='test12345@test.com'];
        System.assertEquals(cont.Id, loggedInUser.ContactId);
        
    }
  
    @isTest
    static void test_UpdateAutoEnrollment(){
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
                    LanguageLocaleKey = 'en_US',
                     By_Pass_Validation__c = true
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
        
        User  userPortalUser =[SELECT Id, CXE_Auto_Enrolled_Services__c FROM USER WHERE EMAIL ='test12345@test.com'];  
        System.runAs ( userPortalUser ) {
            CXE_CP_Dashboard.UpdateAutoEnrollment();
        }
        Test.stopTest();
        System.assertEquals(false, userPortalUser.CXE_Auto_Enrolled_Services__c);
    }
    
    @isTest
    static void test_GetProfInfoModal(){
            
        Test.startTest();        
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
                    LastName = 'McTesty',
                    AccountId = account1.Id,
                    MobilePhone = '+639268152782',
                    Mobile_2__c = '+639268152781',
                    Phone ='+6325325000',
                    Birthdate = null,
                    Email_2__c = 'test2@test.com',
                    Email = System.now().millisecond() + 'test12345@test.com',
                    CXE_isPortalContact__c = True
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
                    LanguageLocaleKey = 'en_US',
                     By_Pass_Validation__c = true
                );
                Database.insert(pAccountPortalUser);

                Account account2 = new Account(
                    Name = 'TestAccount1',
                    OwnerId = userSysAd.Id,
                    Phone = '+63021234568',
                    Tax_Identification_No__c = '123456789013',
                    Mobile_Phone__c = '+630000000001',
                    Email__c = 'test1@test.com'
                    
                );
                Database.insert(account2);
                
                //CREATE PORTAL USER CONTACT
                Contact contact2 = new Contact(
                    FirstName = 'Test1',
                    LastName = 'McTesty1',
                    AccountId = account2.Id,
                    MobilePhone = '+639268152784',
                    Mobile_2__c = '+639268152783',
                    Phone ='+6325325001',
                    Birthdate =  System.today() - 100,
                    Email_2__c = 'test3@test.com',
                    Email = System.now().millisecond() + 'test123456789@test.com',
                    CXE_isPortalContact__c = True
                );
                Database.insert(contact2);
                
                //CREATE PORTAL USER ACCOUNT
                Profile portalProfile1 = [SELECT Id FROM Profile Limit 1];
                User pAccountPortalUser2 = new User(
                    Username = System.now().millisecond() + 'test123456789@test.com',
                    ContactId = contact2.Id,
                    ProfileId = portalProfile1.Id,
                    Alias = 'test1234',
                    Email = 'test123456789@test.com',
                    EmailEncodingKey = 'UTF-8',
                    LastName = 'McTesty1',
                    CommunityNickname = 'test123456789',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US'
                );
                Database.insert(pAccountPortalUser2);
            }
       
        User  userPortalUser =[SELECT Id FROM USER WHERE EMAIL ='test12345@test.com'];       
        System.runAs ( userPortalUser ) {
            CXE_CP_Dashboard.getProfInfoModal();
        }
        
        User  userPortalUser1 =[SELECT Id FROM USER WHERE EMAIL ='test123456789@test.com'];       
        System.runAs ( userPortalUser1 ) {
            CXE_CP_Dashboard.getProfInfoModal();
        }
        Test.stopTest();
        
        Contact cont = [SELECT Id, Mobile_2__c, Phone, Birthdate, Email_2__c FROM Contact WHERE FirstName ='Test' AND LastName = 'McTesty'];
        User loggedInUser =[SELECT Id, ContactId FROM User WHERE EMAIL ='test12345@test.com'];
        System.assertEquals(cont.Id, loggedInUser.ContactId);
        System.assertEquals('+639268152781', cont.Mobile_2__c);
        System.assertEquals('+6325325000', cont.Phone);
        System.assertEquals(null, cont.Birthdate);
        System.assertEquals('test2@test.com', cont.Email_2__c);
        
        Contact cont1 = [SELECT Id, Mobile_2__c, Phone, Birthdate, Email_2__c FROM Contact WHERE FirstName ='Test1' AND LastName = 'McTesty1'];
        User loggedInUser1 =[SELECT Id, ContactId FROM User WHERE EMAIL ='test123456789@test.com'];
        System.assertEquals(cont1.Id, loggedInUser1.ContactId);
        System.assertEquals('+639268152783', cont1.Mobile_2__c);
        System.assertEquals('+6325325001', cont1.Phone);
        System.assertEquals('test3@test.com', cont1.Email_2__c);
    }

    @isTest
    static void test_GetFeedbackLink(){
        Test.startTest();
            CXE_CP_Dashboard.getFeedbackLink();
        Test.stopTest();
    }
    
    @isTest
    static void test_GetProfilePicture(){
        Test.startTest();
            CXE_CP_Dashboard.getProfilePicture();
        Test.stopTest();
    }
    
    @isTest
    static void test_GetRetrieveLoginHistory(){
            
        Test.startTest();        
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
                    LastName = 'McTesty',
                    AccountId = account1.Id,
                    MobilePhone = '+639268152782',
                    Mobile_2__c = '+639268152781',
                    Phone ='+6325325000',
                    Birthdate = null,
                    Email_2__c = 'test2@test.com',
                    Email = System.now().millisecond() + 'test12345@test.com',
                    CXE_isPortalContact__c = True
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

                Account account2 = new Account(
                    Name = 'TestAccount1',
                    OwnerId = userSysAd.Id,
                    Phone = '+63021234568',
                    Tax_Identification_No__c = '123456789013',
                    Mobile_Phone__c = '+630000000001',
                    Email__c = 'test1@test.com'
                    
                );
                Database.insert(account2);
                
                //CREATE PORTAL USER CONTACT
                Contact contact2 = new Contact(
                    FirstName = 'Test1',
                    LastName = 'McTesty1',
                    AccountId = account2.Id,
                    MobilePhone = '+639268152784',
                    Mobile_2__c = '+639268152783',
                    Phone ='+6325325001',
                    Birthdate =  System.today() - 100,
                    Email_2__c = 'test3@test.com',
                    Email = System.now().millisecond() + 'test123456789@test.com',
                    CXE_isPortalContact__c = True
                );
                Database.insert(contact2);
                
                //CREATE PORTAL USER ACCOUNT
                Profile portalProfile1 = [SELECT Id FROM Profile Limit 1];
                User pAccountPortalUser2 = new User(
                    Username = System.now().millisecond() + 'test123456789@test.com',
                    ContactId = contact2.Id,
                    ProfileId = portalProfile1.Id,
                    Alias = 'test1234',
                    Email = 'test123456789@test.com',
                    EmailEncodingKey = 'UTF-8',
                    LastName = 'McTesty1',
                    CommunityNickname = 'test123456789',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US'
                );
                Database.insert(pAccountPortalUser2);
            }
       
        User  userPortalUser =[SELECT Id FROM USER WHERE EMAIL ='test12345@test.com'];       
        System.runAs ( userPortalUser ) {
            CXE_CP_Dashboard.retrieveLoginHistory();
        }
        List<User> userLoginTime = [SELECT LastLoginDate FROM User WHERE Id =:userPortalUser.Id];
        System.assertEquals(true, userLoginTime.size()!= 0);
        System.assertEquals(1,userLoginTime.size());
        
        
    }
}