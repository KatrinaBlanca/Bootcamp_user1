@isTest
private class Myu_ReportOutageClass_Test
{
    static testMethod void Myu_ReportOutageClassTest()
    {
        //Insert Account
        List<Account> acclist = new Account[1];
        // Start CXE Update test class
        acclist[0] = new account(Firstname='Firstname',LastName='TestName1',Phone='+63123654789',PersonHomePhone = '+63021231234',Mobile_1__pc = '+639221231234',PersonEmail = 'aa@aa.com');
        // End CXE Update test class
       
        insert acclist;       
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/ReportOutage/';         
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        Id accId = acclist[0].Id;
        String TypeOfPowerOutage='test';
        String NeighboursPowerAvailability = 'test';
        String AdditionalOutageInfo = 'test';
        Myu_ReportOutageClass.sfdcresponse results1 = Myu_ReportOutageClass.doPost(accId ,TypeOfPowerOutage,NeighboursPowerAvailability,AdditionalOutageInfo);
        
        Myu_ReportOutageClass.sfdcresponse results2 = Myu_ReportOutageClass.doPost('34343',TypeOfPowerOutage,NeighboursPowerAvailability,AdditionalOutageInfo);        
        
                           
                 
    }
}