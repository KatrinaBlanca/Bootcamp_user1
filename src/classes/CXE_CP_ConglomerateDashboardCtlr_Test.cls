@isTest
public class CXE_CP_ConglomerateDashboardCtlr_Test {
    
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
    static void getAccountIDofCurrentUser_Test(){

        Test.startTest();        
        	CXE_CP_ConglomerateDashboardCtlr.getAccountIDofCurrentUser();
        Test.stopTest();

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
            CXE_CP_ConglomerateDashboardCtlr.getProfInfoModal();
        }
        
        User  userPortalUser1 =[SELECT Id FROM USER WHERE EMAIL ='test123456789@test.com'];       
        System.runAs ( userPortalUser1 ) {
            CXE_CP_ConglomerateDashboardCtlr.getProfInfoModal();
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

}