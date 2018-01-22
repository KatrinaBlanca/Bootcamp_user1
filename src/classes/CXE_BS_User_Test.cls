@isTest
private class CXE_BS_User_Test {
	
	private static testMethod void testGet() {
		
		User portalUser;

		User adminUser = CXE_TestDataFactory.createAdminUser();
        adminUser.IsActive = true; 
        insert adminUser;
        Test.startTest();
        System.runAs(adminUser){
        
            
            Account acct = CXE_TestDataFactory.createSingleAccountForPortalUser(adminUser.Id);
            insert acct;
            Contact  cont =CXE_TestDataFactory.createContact(acct.Id);
            insert cont;
            
            portalUser = CXE_TestDataFactory.createPortalUser(cont.Id);
            portalUser.IsActive = true;
            insert portalUser; 
            
            System.assert(portalUser!=null);
        }

        User  userPortalUser2 =[SELECT Id FROM USER WHERE id =: portalUser.Id];       
        System.runAs ( userPortalUser2 ) {
            CXE_CP_Dashboard.retrieveLoginHistory();
        }

        Test.stopTest();
        
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();

		req.requestURI = '/services/apexrest/loginHistory';  //Request URL
		req.httpMethod = 'GET';//HTTP Request Type
		req.addHeader('Content-Type', 'application/json');
		//req.requestBody = Blob.valueof(JsonMsg);
		RestContext.request = req;
		RestContext.response= res;
		CXE_BS_User.get();
		
	}
}