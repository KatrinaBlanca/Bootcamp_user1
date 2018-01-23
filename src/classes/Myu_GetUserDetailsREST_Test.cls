@isTest
private class Myu_GetUserDetailsREST_Test
{
    static testMethod void testDoGet()
    {
        //Insert Account
        Account accTest = new Account();
        // Start CXE Update test class
        accTest.Firstname='Firsname';
        // End CXE Update test class
        accTest.LastName='TestName';
        accTest.Phone='+63123654789';
        accTest.UserName__pc = 'testuser';
        acctest.Password__pc = 'salesforce';
        acctest.PersonHomePhone = '+63021231234';
        acctest.Mobile_1__pc = '+639221231234';
        acctest.PersonEmail = 'aa@aa.com';
        insert accTest;       
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/GetUserDetails';  
        req.addParameter('username','testuser');
        req.addParameter('password','salesforce');        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Myu_GetUserDetailsREST.GetUserDetailsResponse results = Myu_GetUserDetailsREST.doGet();
        System.assertEquals(Null, results.errorMessage);
    }
    
    static testMethod void testDoGet2()
    {
        //Insert Account
        Account accTest = new Account();
        // Start CXE Update test class
        accTest.Firstname='Firsname';
        // End CXE Update test class
        accTest.LastName='TestName';
        accTest.Phone='+6312365478';
        accTest.UserName__pc = 'testuser';
        acctest.Password__pc = 'salesforce';
        acctest.PersonHomePhone = '+63021231234';
        acctest.Mobile_1__pc = '+639221231234';
        acctest.PersonEmail = 'aa@aa.com';
        insert accTest;        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/GetUserDetails';
        req.addParameter('username',Null);
        req.addParameter('password',Null);        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Myu_GetUserDetailsREST.GetUserDetailsResponse results = Myu_GetUserDetailsREST.doGet();
        System.assertEquals('username or password cannot be blank', results.errorMessage);
    }
    
    static testMethod void testDoGet3()
    {
        //Insert Account
        Account accTest = new Account();
        // Start CXE Update test class
        accTest.Firstname='Firsname';
        // End CXE Update test class
        accTest.LastName='TestName';
        accTest.Phone='+6312365478';
        accTest.UserName__pc = 'testuser';
        acctest.Password__pc = 'salesforce';
        acctest.PersonHomePhone = '+63021231234';
        acctest.Mobile_1__pc = '+639221231234';
        acctest.PersonEmail = 'aa@aa.com';
        insert accTest;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/GetUserDetails';
        req.addParameter('username','testuser1');
        req.addParameter('password','salesforce1');       
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Myu_GetUserDetailsREST.GetUserDetailsResponse results = Myu_GetUserDetailsREST.doGet();
        System.assertEquals('There is no account for the user name and password suppliedtestuser1 salesforce1', results.errorMessage);
    }    
    
}