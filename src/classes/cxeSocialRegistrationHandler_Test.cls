@isTest
public class cxeSocialRegistrationHandler_Test {
    
    @isTest static void canCreateUser_Test(){
        Test.startTest();
        Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
                                                     'testFirst testLast', 'testuser@example.org', null, 'testuserlong', 'en_US', 'facebook',
                                                     null, new Map<String, String>{'language' => 'en_US'});
        
        CXE_TestDataFactory.setOrgSettings();    
        cxeSocialRegistrationHandler cxeRegHandler = new cxeSocialRegistrationHandler();
        cxeRegHandler.canCreateUser(sampleData);
        Test.stopTest();
    }
    
   
    
    @isTest static void createUpdateUser_Test(){
        Test.startTest();
        Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
                                                     'testFirst testLast', 'testuser@example.org', null, 'testuserlong', 'en_US', 'facebook',
                                                     null, new Map<String, String>{'language' => 'en_US'});
        
        User userId = [Select Id From User LIMIT 1];
        
        CXE_TestDataFactory.setOrgSettings();    
        cxeSocialRegistrationHandler cxeRegHandler = new cxeSocialRegistrationHandler();
        cxeRegHandler.createUser(userId.ID, sampleData);
        
        cxeRegHandler.updateUser(userId.Id, userId.Id, sampleData);
        Test.stopTest();
        
        
    }



}