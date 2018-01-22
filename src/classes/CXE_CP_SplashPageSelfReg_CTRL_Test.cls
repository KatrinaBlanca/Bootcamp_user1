/* Description: CXE_CP_SplashPageSelfRegistration_CTRL test class
* Author: Jonel Hestiada    
* Date Created: AUG-16-17
*/
@isTest
public class CXE_CP_SplashPageSelfReg_CTRL_Test {
    
       @testSetup static void createUser(){
            
           Profile profile1 = [Select Id from Profile where Name=:CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE ];
           User portalAccountOwner1 = new User(
               ProfileId = profile1.Id,
               Username = System.now().millisecond() + 'test2@test.com',
               Alias = 'Sylar',
               Email='Sylar@heroes.com',
               EmailEncodingKey='UTF-8',
               Firstname='Gabriel',
               Lastname='Petrilli',
               LanguageLocaleKey='en_US',
               LocaleSidKey='en_US',
               TimeZoneSidKey='America/Chicago'
               
           );
           Database.insert(portalAccountOwner1);
           
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
    private static void hasSinPaperLessBilling_Test(){
        Test.startTest();
        User  createdUser =[SELECT ID, FirstName, MiddleName,LastName,Suffix, MobilePhone
                            FROM USER 
                            WHERE EMAIL ='Sylar@heroes.com' ];
        
       // Insert Contact to be Used and Account
        CXE_CP_SplashPageSelfRegistration_CTRL.Response cu ;
        System.runAs ( createdUser ) {
            CXE_CP_SplashPageSelfRegistration_CTRL.getHiearchySettings();     
            cu = CXE_CP_SplashPageSelfRegistration_CTRL.createUser('creatinguser@yopmail.com', createdUser.FirstName, createdUser.MiddleName, createdUser.LastName, createdUser.Suffix, createdUser.MobilePhone);
        }
        Test.stopTest();
       // System.assertEquals('Response:[isSuccess=false, message=Insert failed. First exception on row 0; first error: INVALID_CROSS_REFERENCE_KEY, Cannot create a portal user without contact: [ContactId]]',cu)
      }
    
    //test method for validating profile logged in as not Meralco Community Customer Profile
    static testMethod void test_NotMeralcoCCProfile_loggedIn(){
        //Meralco Customer Community Profile
        User createdUser = CXE_TestDataFactory.createUser(1, 'System Administrator')[0];
        
        System.runAs(createdUser) {
            Test.StartTest();
            
            CXE_CP_SplashPageSelfRegistration_CTRL.Response cu = 
                CXE_CP_SplashPageSelfRegistration_CTRL.createUser(createdUser.Email, createdUser.FirstName, createdUser.MiddleName, createdUser.LastName, createdUser.Suffix, createdUser.MobilePhone);
            Test.StopTest();
            
            System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_ERROR_HAS_SESSION, cu.message);   
        }
        
    }
    /*
    static testMethod void test_createReq(){
        User createdUser = CXE_TestDataFactory.createUser(1, CXE_Constants.PORTAL_COMMUNITY_PROFILE)[0];
        User userLoggedIn = CXE_TestDataFactory.createUser(1, CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE)[0];
        
        
        Account acc = CXE_TestDataFactory.createPersonAccount(1)[0];
        insert acc;
        Account newAccount = [SELECT PersonContactId FROM Account WHERE Id=:acc.Id LIMIT 1];
        createdUser.contactId = newAccount.PersonContactId;
        createdUser.Username = 'UserRecordTest1@isTest.com';
        
        insert createdUser;
        
        System.runAs(userLoggedIn){
            Test.StartTest();
            CXE_CP_SplashPageSelfRegistration_CTRL.Response cu = 
                CXE_CP_SplashPageSelfRegistration_CTRL.createUser(createdUser.Email, createdUser.FirstName, createdUser.MiddleName, createdUser.LastName, createdUser.Suffix, createdUser.MobilePhone);
            Test.StopTest();    
            
            System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_ERROR_DUPLICATE_EMAIL, cu.message);
        }
        
    }
    */
    static testMethod void test_errorHandler(){
        //Meralco Customer Community Profile
        User createdUser = CXE_TestDataFactory.createUser(1, CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE)[0];
        
        System.runAs(createdUser) {
            Test.StartTest();
            
            CXE_CP_SplashPageSelfRegistration_CTRL.Response cu = 
                CXE_CP_SplashPageSelfRegistration_CTRL.createUser(createdUser.Email, createdUser.FirstName, createdUser.MiddleName, createdUser.LastName, createdUser.Suffix, createdUser.MobilePhone);
            
            Test.StopTest();
            
            System.assertEquals('Attempt to de-reference a null object', cu.message);
            
        }
        
    }
    
 
}