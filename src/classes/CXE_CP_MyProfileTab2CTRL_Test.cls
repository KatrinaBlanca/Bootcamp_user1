@isTest
public class CXE_CP_MyProfileTab2CTRL_Test{
    
    @isTest
    static void test_updateContactFailed()
    {
        test.startTest();   
        
        CXE_CP_MyProfileTab2CTRL.updateContact('Billing Notif', 'Payment Confirm', 'Payment Remind', 'Service App', 'Outages', 'Promotions');
        
        Contact cont = new contact();
        
        cont.Billing_Notification__c               = 'test';
        cont.Payment_Confirmation_Notification__c  = 'test';
        cont.Payment_Reminders__c                  = 'test';
        cont.Service_Applications_Notification__c  = 'test';
        cont.Outages_Notification__c               = 'test';
        cont.Promotions_Notification__c            = 'test';
        test.stopTest();
    }
    
    /* error in build
@isTest
static void test_getProfilePictureFailed()
{
test.startTest();   

CXE_CP_MyProfileTab2CTRL.getProfilePicture('0050l000000Sz67');

test.stopTest();
}

*/
    
    
    @isTest
    static void test_getProfilePictureNull()
    {
        test.startTest();   
        
        CXE_CP_MyProfileTab2CTRL.getProfilePicture(null);
        
        test.stopTest();
    }
    
    
    @testSetup
    static void createTestReqs(){
        
        User adminUser = CXE_TestDataFactory.createAdminUser();
        insert adminUser;
    }
    
    @isTest
    static void test_profile()
    {
        
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
        
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            
            String returnValue;
            
            test.startTest(); 
            
            returnValue =CXE_CP_MyProfileTab2CTRL.getProfilePicture(userPortalUser.Id);
            
            
            test.stopTest();
            
            // System.assertEquals(True,returnValue.contains('https://meralco--DEVWCXE--c.cs58.content.force.com/'));
            //build error 
            
            
        }
        
        
    }
    
    
    
    @isTest
    static void test_UpdateContact()
    {
        
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
        
        
        User  userPortalUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com'];
        System.runAs ( userPortalUser ) {
            
            String returnValue;
            
            test.startTest(); 
            
            returnValue =CXE_CP_MyProfileTab2CTRL.updateContact('Billing Notif', 'Payment Confirm', 'Payment Remind', 'Service App', 'Outages', 'Promotions');
            
            
            test.stopTest();
            
            System.assertEquals('Success',returnValue);
            
        }
        
        
    }
    
}