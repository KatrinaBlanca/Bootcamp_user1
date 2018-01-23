/* Description: CXE_CP_SplashPageSelfRegistration_CC test class
* Author: Jonel Hestiada    
* Date Created: AUG-17-17
*/
@isTest
public class CXE_CP_SplashPageSelfReg_CC_Test {
    
    static testMethod void test_NotMeralcoCCProfile_loggedIn(){
        //Meralco Customer Community Profile
        
        User createdUser = CXE_TestDataFactory.createUser(1, CXE_Constants.PORTAL_COMMUNITY_PROFILE)[0];
        Account acc = CXE_TestDataFactory.createPersonAccount(1)[0];
        insert acc;
        Account newAccount = [SELECT PersonContactId FROM Account WHERE Id=:acc.Id LIMIT 1];
        createdUser.FirstName = 'juan';
        createdUser.contactId = newAccount.PersonContactId;
        
        /*     createdUser.sin = '123123';
createdUser.amount = 100;
createdUser.transactionDate = '09-19-17';
createdUser.isNew = true;
*/
        
        System.runAs(createdUser) {
            Test.StartTest();
            //system.debug(createdUser);
            CXE_CP_SplashPageSelfRegistration_CC.Response cu = 
                CXE_CP_SplashPageSelfRegistration_CC.createUser(
                    createdUser.Email, 
                    createdUser.FirstName, 
                    createdUser.MiddleName, 
                    createdUser.LastName, 
                    createdUser.Suffix, 
                    createdUser.MobilePhone, '345345',100, '2017-08-17', true);
            Test.StopTest();
            
            System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_ERROR_HAS_SESSION, cu.message);   
            
        }
        
    }
    
    static testMethod void test_SinError(){
        
        User createdUser = CXE_TestDataFactory.createUser(1, CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE)[0];
        system.runAs(createdUser){
            Test.startTest();
            
            CXE_CP_SplashPageSelfRegistration_CC.Response cu = createUserCC(createdUser, '345345',100, '2017-08-17', true);
           
             
            
            Test.stopTest();
              //System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_INVALID_LENGTH, cu.message);
        }
        
        
    }
    
    public static CXE_CP_SplashPageSelfRegistration_CC.Response createUserCC(User createdUser,String sin, Decimal amount, string transactionDate, Boolean isNew)
    {
       // system.debug('userTest: '+user);
       CXE_CP_SplashPageSelfRegistration_CC.Response cu = 
                CXE_CP_SplashPageSelfRegistration_CC.createUser(
                    createdUser.Email, 
                    createdUser.FirstName, 
                    createdUser.MiddleName, 
                    createdUser.LastName, 
                    createdUser.Suffix, 
                    createdUser.MobilePhone, sin, amount, transactionDate, isNew);
        
        return cu;
        
        //
    }


    
    
    
}