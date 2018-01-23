@isTest
private class Myu_GetMyAccountDetails_Test
{
    static testMethod void testDoGet()
    {
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        //Insert Account
        List<Account> acclist = new Account[3];
        // Start CXE Update test class
        acclist[0] = new account(Firstname='Firstname1', LastName='TestName1',Phone='+63123654789',PersonHomePhone = '+63021231234',Mobile_1__pc = '+639221231234',PersonEmail = 'aa@aa.com');
        acclist[1] = new account(Firstname='Firstname2', LastName='TestName2',Phone='+63123654789',PersonHomePhone = '+63021231234',Mobile_1__pc = '+639221231234',PersonEmail = 'aa@aa.com');
        acclist[2] = new account(Firstname='Firstname3', LastName='TestName3',Phone='+63123654789',PersonHomePhone = '+63021231234',Mobile_1__pc = '+639221231234',PersonEmail = 'aa@aa.com');        
        // End CXE Update test class
        insert acclist;       
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String urlMapping = '/GetMyAccount/';         
        req.requestURI = urlMapping + acclist[0].Id;         
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Myu_GetMyAccountDetails.sfdcresponse results1 = Myu_GetMyAccountDetails.doGet();
        //System.assertEquals(Null, results.errorMessage);
        
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        insert testCase;

        List<contract> ctrList = new contract[2];
        ctrList[0]  = new contract(accountid =acclist[1].Id, case__c = testCase.Id );
        ctrList[1]  = new contract(accountid =acclist[2].Id,Method_of_Payment__c='Cash', case__c = testCase.Id );        
        insert ctrList;
        req.requestURI = urlMapping + acclist[1].Id; 
        Myu_GetMyAccountDetails.sfdcresponse results2 = Myu_GetMyAccountDetails.doGet();   
        
        req.requestURI = urlMapping + acclist[2].Id; 
        Myu_GetMyAccountDetails.sfdcresponse results3 = Myu_GetMyAccountDetails.doGet();          
        
        req.requestURI = urlMapping; 
        Myu_GetMyAccountDetails.sfdcresponse results4 = Myu_GetMyAccountDetails.doGet();                            
                 
    }
}