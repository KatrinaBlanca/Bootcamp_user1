/* Author   : @JRances 
 * Date     : OCT-19-2017
 * Desc.    : Test Class/Code Coverage for CXE_CP_RequestTrackApplication_CC
 * */

@isTest
public class CXE_CP_RequestTrackApplication_CC_Test {

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
    static void test_GetCasesRelatedList(){
        //CREATE CONTRACT WITH BILLING DETAILS
        CXE_CP_RequestTrackApplication_CC_Test reqTrackApp = new CXE_CP_RequestTrackApplication_CC_Test();
        
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
                
            }
        
        User  userPortalUser =[SELECT Id FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            List<Account> createdAcct = [SELECT Id, Name FROM Account WHERE Name='TestAccount'];
            
            Id newServiceApplicationRecordTypeId1 = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
            
            List<Case> userCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
            Case userCase = userCaseList.get(0);
            userCase.RecordTypeId = newServiceApplicationRecordTypeId1;
            userCase.Tax_Identification_No__c = '1111111';
            userCase.AccountId = createdAcct[0].Id;
            insert userCase;
            
            CXE_CP_RequestTrackApplication_CC.getCaseList();
            
            List<Case> createdCase = [SELECT Id, CaseNumber FROM Case WHERE AccountId =: createdAcct[0].Id];   
            
            User  userPortalUser1 =[SELECT Id, LastName FROM USER WHERE EMAIL ='test12345@test.com'];
            CXE_CP_RequestTrackApplication_CC.trackApplication(createdCase[0].CaseNumber, userPortalUser1.LastName);
            
            System.assertEquals(1, createdAcct.size());
            System.assertEquals(1, createdCase.size());
            System.assertEquals(userCase.Id, createdCase[0].Id);
        }
        Test.stopTest();

        
    }
    
    static testMethod void caseConglomerateTest(){
    	test.startTest();
        	User  userSysAd =[SELECT ID FROM USER WHERE EMAIL ='bruce.wayne@wayneenterprises.com' ];
            System.runAs ( userSysAd ) {
                List<Account> accList = new List<Account>();
                Account acc = new Account(
                    Name = 'Parent Account',
                    OwnerId = userSysAd.Id,
                    Phone = '+63021234567',
                    Tax_Identification_No__c = '123456789012',
                    Mobile_Phone__c = '+630000000000',
                    Email__c = 'test@test.com'
                );
                Database.insert(acc);
                
                Account account1 = new Account(
                    Name = 'TestAccount',
                    OwnerId = userSysAd.Id,
                    Phone = '+63021234567',
                    Tax_Identification_No__c = '123456789012',
                    Mobile_Phone__c = '+630000000000',
                    Email__c = 'test@test.com',
                    ParentId = acc.id,
                    Conglomerate__c = true
                    
                );
                accList.add(account1);
                Account account2 = new Account(
                    Name = 'TestAccount2',
                    OwnerId = userSysAd.Id,
                    Phone = '+63021234567',
                    Tax_Identification_No__c = '123456789012',
                    Mobile_Phone__c = '+630000000000',
                    Email__c = 'test@test.com'
                );
                accList.add(account2);
                insert accList;
            CXE_CP_RequestTrackApplication_CC req = new CXE_CP_RequestTrackApplication_CC();
        	//CXE_CP_RequestTrackApplication_CC.getCaseConglomerateList(accList.get(1).id);
            }
        test.stopTest();
    }
}