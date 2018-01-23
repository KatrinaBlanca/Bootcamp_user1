@isTest
private class Myu_PostAccountDetails_Test 
{
    static testMethod void testDopost()
    {
        //Insert Account
        Account accTest = new Account();
        // Start CXE Update test class
        accTest.Firstname='Firsname';
        // End CXE Update test class
        accTest.LastName='TestName';
        accTest.PersonHomePhone='+63212365479';
        accTest.PersonEmail='test@test.com';
        acctest.PersonMobilePhone='+631221112221';
        acctest.Phone = '+63464187364';//START/END R2 RReyes JUL-08-17 - added phone to pass validation
        acctest.PersonHomePhone = '+63021231234';
        acctest.Mobile_1__pc = '+639221231234';
        acctest.PersonEmail = 'aa@aa.com';

        insert accTest;
               
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/PostAccountDetail';  
        //req.addParameter('accountId',accTest.Id);
        //req.addParameter('password','salesforce');        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        string accountid = acctest.Id;
        string phone = '+63212365479';
        string email = 'test@gmail.com';
        Myu_PostAccountDetails.sfdcresponse results = Myu_PostAccountDetails.doPost(accountId,phone,email);
        System.assertEquals(Null, results.error);
        email = '123';
        Myu_PostAccountDetails.sfdcresponse results2 = Myu_PostAccountDetails.doPost(accountId,phone,email);        
    }
    
    static testMethod void testDopost2()
    {
        //Insert Account
        Account accTest = new Account();
        // Start CXE Update test class
        accTest.Firstname='Firsname';
        // End CXE Update test class
        accTest.LastName='TestName';
        accTest.PersonHomePhone='+6321236547';
        accTest.PersonEmail='test@test.com';
        acctest.PersonMobilePhone='+631221112221';
        acctest.Phone = '+63464187364';//START/END R2 RReyes JUL-08-17 - added phone to pass validation
        insert accTest;
               
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/PostAccountDetail';  
        //req.addParameter('accountId',accTest.Id);
        //req.addParameter('password','salesforce');        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        string accountid = Null;
        string phone = '+63212365479';
        string email = 'test@gmail.com';
        Myu_PostAccountDetails.sfdcresponse results = Myu_PostAccountDetails.doPost(accountId,phone,email);
        System.assertEquals('accountId cannot be blank', results.error);
    }
    
    static testMethod void testDopost3()
    {
        //Insert Account
        Account accTest = new Account();
        // Start CXE Update test class
        accTest.Firstname='Firsname';
        // End CXE Update test class
        accTest.LastName='TestName';
        accTest.PersonHomePhone='+6321236547';
        accTest.PersonEmail='test@test.com';
        acctest.PersonMobilePhone='+631221112221';
        acctest.Phone = '+63464187364';//START/END R2 RReyes JUL-08-17 - added phone to pass validation
        insert accTest;
               
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/PostAccountDetail';
        //req.addParameter('accountId',accTest.Id);
        //req.addParameter('password','salesforce');        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        string accountid = '12345';
        string phone = '+63212365479';
        string email = 'test@gmail.com';
        Myu_PostAccountDetails.sfdcresponse results = Myu_PostAccountDetails.doPost(accountId,phone,email);
        System.assertEquals('no account record matched in SFDC', results.error);

    }
}