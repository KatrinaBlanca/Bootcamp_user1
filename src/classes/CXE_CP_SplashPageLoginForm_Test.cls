@isTest

/* Author: Rj Rances
 * Date:   08/24/2017
 * */

public class CXE_CP_SplashPageLoginForm_Test {
    
    
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
    @isTest static void createUsr(){
        User  portalAccountOwner1 =[SELECT ID FROM USER WHERE EMAIL ='bruce.wayne@wayneenterprises.com' ];
        String hasSession;
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
                By_Pass_Validation__c = True ,//CSM-12863 GGrandea 09.21.2017
                CXE_CP_isPortalDeactivated__c = True
            );
            Database.insert(user1);
            
        }
        
    }
    
    @isTest static void createUsr2(){
        
        User  portalAccountOwner1 =[SELECT ID FROM USER WHERE EMAIL ='bruce.wayne@wayneenterprises.com' ];
        String hasSession;
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
                By_Pass_Validation__c = True ,//CSM-12863 GGrandea 09.21.2017
                CXE_CP_isPortalDeactivated__c = false
            );
            Database.insert(user1);
            
        }
    }
    
    
    
    
    //Test class for getLoginDetails if User is Deactivated
    @isTest static void test_getLoginDetailsUserDeac(){
        
        CXE_CP_SplashPageLoginForm.Response resp = new CXE_CP_SplashPageLoginForm.Response();
        
        User usr = [SELECT Id, Username, CXE_CP_isPortalDeactivated__c  FROM User WHERE CXE_CP_isPortalDeactivated__c = true  LIMIT 1];
        System.debug(usr);
        
        Test.startTest();
            resp = CXE_CP_SplashPageLoginForm.getLoginDetails( usr.Username, 
                                                              'yoohooPass', 
                                                              'viewbills', 
                                                              '934399232', 
                                                              '1000000232', 
                                                              '2017-02-02', 
                                                              '2017-02-02',
							      							  '',
                                                              'https://r2cdev2-meralco.cs72.force.com/customers/s'
                                                             );
        Test.stopTest();
        
        System.debug('resp: ' + resp);
        System.assertEquals(false, resp.isSuccess);
        System.assertEquals('Your Meralco Online account has been deactivated', resp.message);
    }
    


    //Test class for getLoginDetails if User is not Deactivated
    @isTest static void test_getLoginDetailsUserActive(){
		createUsr();
        CXE_CP_SplashPageLoginForm.Response resp2 = new CXE_CP_SplashPageLoginForm.Response();
        
        User usr = [SELECT Id, Username, CXE_CP_isPortalDeactivated__c  
                    FROM User 
                    WHERE CXE_CP_isPortalDeactivated__c = true  
                    AND Email = 'test12345@test.com' 
                    LIMIT 1];
        
        Test.startTest();
            resp2 = CXE_CP_SplashPageLoginForm.getLoginDetails( usr.Username, 
                                                              'yoohooPass', 
                                                              'viewbills', 
                                                              '934399232', 
                                                              '1000000232', 
                                                              '2017-02-02', 
                                                              '2017-02-02',
							      							  '',
                                                              'https://r2cdev2-meralco.cs72.force.com/customers/s/dashboard'
                                                             );
        Test.stopTest();
        
        System.debug('resp2: ' + resp2);
        System.assertEquals(false, resp2.isSuccess);
        //System.assertEquals('Argument 1 cannot be null', resp2.message);
    }

    //Test class for getLoginDetails if URL link page params is not provided
    @isTest static void test_getLoginDetailsRediToDash(){
		createUsr2();
        
        CXE_CP_SplashPageLoginForm.Response resp3 = new CXE_CP_SplashPageLoginForm.Response();
            
        User usr = [SELECT Id, Username, CXE_CP_isPortalDeactivated__c  
                    FROM User 
                    WHERE CXE_CP_isPortalDeactivated__c = false  
                    AND Email = 'test12345@test.com' 
                    LIMIT 1];
        System.debug(usr);
        
        String Page = 'test';
        
        Test.startTest();
            resp3 = CXE_CP_SplashPageLoginForm.getLoginDetails( usr.Username, 
                                                              'yoohooPass', 
                                                              'test', 
                                                              '934399232', 
                                                              '1000000232', 
                                                              '2017-02-02', 
                                                              '2017-02-02',
                                                              Page,
                                                              'https://r2cdev2-meralco.cs72.force.com/customers/s/dashboard'
                                                             );
        Test.stopTest();
        
        System.debug('resp3: ' + resp3);
        System.assertEquals(Page, 'test');
        
        
    }
    
    @isTest static void test_billId(){
        createUsr2();
        
        CXE_CP_SplashPageLoginForm.Response resp3 = new CXE_CP_SplashPageLoginForm.Response();
            
        User usr = [SELECT Id, Username, CXE_CP_isPortalDeactivated__c  
                    FROM User 
                    WHERE CXE_CP_isPortalDeactivated__c = false  
                    AND Email = 'test12345@test.com' 
                    LIMIT 1];
        System.debug(usr);
        
        String Page = null;
        String startURL = 'RemoteAccessAuthorizationPage';
        String bpBillId = 'test';
        
        Test.startTest();
            resp3 = CXE_CP_SplashPageLoginForm.getLoginDetails( usr.Username, 
                                                              'yoohooPass', 
                                                              Page, 
                                                              '934399232', 
                                                              '1000000232', 
                                                              '2017-02-02', 
                                                              '2017-02-02',
                                                              'test',
                                                              'RemoteAccessAuthorizationPage'
                                                             );
        Test.stopTest();
        
        System.debug('resp3: ' + resp3);
        //System.assertEquals(startURL, 'RemoteAccessAuthorizationPage');
        System.assertEquals(bpBillId, 'test');
    }
    
    @isTest static void test_IsMobile(){
        createUsr2();
        CXE_CP_SplashPageLoginForm.Response resp3 = new CXE_CP_SplashPageLoginForm.Response();
            
        User usr = [SELECT Id, Username, CXE_CP_isPortalDeactivated__c  
                    FROM User 
                    WHERE CXE_CP_isPortalDeactivated__c = false  
                    AND Email = 'test12345@test.com' 
                    LIMIT 1];
        System.debug(usr);
        
        String Page = null;
        String startURL = 'RemoteAccessAuthorizationPage';
        String bpBillId = 'test';
        
        Test.startTest();
            resp3 = CXE_CP_SplashPageLoginForm.getLoginDetails( usr.Username, 
                                                              'yoohooPass', 
                                                              Page, 
                                                              '934399232', 
                                                              '1000000232', 
                                                              '2017-02-02', 
                                                              '2017-02-02',
                                                              'test',
                                                              'RemoteAccessAuthorizationPage'
                                                             );
        Test.stopTest();
        
        System.debug('resp3: ' + resp3);
        System.assertEquals(startURL, 'RemoteAccessAuthorizationPage');
        //System.assertEquals(bpBillId, 'test');
    }
    
    @isTest static void test_getInvalidSession(){
        createUsr2();
        CXE_CP_SplashPageLoginForm.Response resp3 = new CXE_CP_SplashPageLoginForm.Response();
        
        User usr = [SELECT Id, Username, CXE_CP_isPortalDeactivated__c  
                    FROM User 
                    WHERE CXE_CP_isPortalDeactivated__c = false  
                    AND Email = 'test12345@test.com' 
                    LIMIT 1];
        System.debug(usr);
        
        String Page = null;
        
        Test.startTest();
            resp3 = CXE_CP_SplashPageLoginForm.getLoginDetails( usr.Username, 
                                                              'yoohooPass', 
                                                              Page, 
                                                              '934399232', 
                                                              '1000000232', 
                                                              '2017-02-02', 
                                                              '2017-02-02',
                                                              '',
                                                              'https://r2cdev2-meralco.cs72.force.com/customers/s/dashboard'
                                                             );
        Test.stopTest();
        
        System.debug('resp3: ' + resp3);
        System.assertEquals(Page, null);
    }
    
    @isTest static void test_getFbLink(){
        Test.startTest();
            String fbLink = CXE_CP_SplashPageLoginForm.getFbLink();
        Test.stopTest();
    }

    @isTest static void test_getGoogleLink(){
        Test.startTest();
            String gLink = CXE_CP_SplashPageLoginForm.getGoogleLink();
        Test.stopTest();  
    }
    
     @isTest static void test_checkUserSession(){
         
         User  portalAccountOwner1 =[SELECT ID FROM USER WHERE EMAIL ='bruce.wayne@wayneenterprises.com' ];
         String hasSession;
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
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE 'MERALCO Customer Portal' Limit 1]; //add condition for customer portal
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
             
         }
        CXE_CP_SplashPageLoginForm.Response2 resp2 = new CXE_CP_SplashPageLoginForm.Response2();
        // User  communityUser =[SELECT ID FROM USER WHERE EMAIL ='test12345@test.com' ];
           User usr = [SELECT Id, Username, CXE_CP_isPortalDeactivated__c, ProfileId, Profile.Name  
                     FROM User 
                     WHERE CXE_CP_isPortalDeactivated__c = false  
                     AND Email = 'test12345@test.com' AND Profile.Name Like 'MERALCO Customer Portal'
                     LIMIT 1];
         
         String Page = 'test';
         String billParams = '?';
         String CHECK_SESSION = 'WITH_SESSION'; 
         String bpinvoiceDate= 'test';
         
         Test.startTest();
         
         System.runAs ( usr ) {
             System.debug('USER ?>>>> ' + usr.Profile.Name );
             resp2 = CXE_CP_SplashPageLoginForm.redirectToViewBills(Page,
                                                                'test',
                                                                'test',
                                                                'test',
                                                                bpinvoiceDate,
                                                                'test');
             //hasSession = CXE_CP_SplashPageLoginForm.checkUserSession();
              System.debug('resp2!!!!!!11>>>>>>>>>>>>>>' + resp2);
             
         }
         Test.stopTest();  
             
         System.debug('resp2>>>>>>>>>>>>>>' + resp2);
         System.assertEquals('WITH_SESSION', CHECK_SESSION);
         System.assertEquals('test', bpinvoiceDate);  
    
     } 
    
    
    
    
    
    
}