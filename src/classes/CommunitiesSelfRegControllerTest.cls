/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
@IsTest public with sharing class CommunitiesSelfRegControllerTest {
    @IsTest(SeeAllData=true) 
    public static void testCommunitiesSelfRegController() {
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);  
    }    
    //START RReyes 04/25 - add method for invalid password
    static testMethod void testInvalidPassword() {
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        
        controller.password = 'testClass1';
        controller.confirmPassword = 'testClass2';
        System.assert(controller.registerUser() == null);  
    } 

    /*static testMethod void testCommunitiesSelfRegControllerValid() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Meralco Customer Community Profile']; 
        User u = new User(Alias = 'standt', Email='guestuser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='GuestTest', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='guestuser@testorg.com');
        System.runAs(u) {
            CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
            controller.firstName = 'FirstName';
            controller.lastName = 'LastName';
            controller.email = 'test@force.com';
            controller.communityNickname = 'test';
            
            // registerUser will always return null when the page isn't accessed as a guest user
            System.assert(controller.registerUser() == null);    
            
            controller.password = 'abcd1234';
            controller.confirmPassword = 'abcd123';
            System.assert(controller.registerUser() == null);  
        }
    }  */
    //END RReyes 04/25 - add method for invalid password
}