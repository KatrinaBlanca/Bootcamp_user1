@isTest
private class CXE_BS_Paperless_Enroll_Test {
	
	@isTest static void TestPost() {
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();

		req.requestURI = '/services/apexrest/enrollPaperless';  //Request URL
		req.httpMethod = 'POST';//HTTP Request Type
		req.addHeader('Content-Type', 'application/json');
		//req.requestBody = Blob.valueof(JsonMsg);
		RestContext.request = req;
		RestContext.response= res;
		CXE_BS_Paperless_Enroll.post('asasas@yopmail.com', '1234');
	}
	
	@isTest static void TestGet() {
		
		Test.startTest();
		User portalUser;
	    User adminUser = CXE_TestDataFactory.createAdminUser();
        adminUser.IsActive = true; 
        insert adminUser;
        
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

        System.runAs(portalUser){
			CXE_BS_Alias reqst=new CXE_BS_Alias();
			String JsonMsg=JSON.serialize(reqst);

			RestRequest req = new RestRequest(); 
			RestResponse res = new RestResponse();

			req.requestURI = '/services/apexrest/enrollPaperless';  //Request URL
			req.httpMethod = 'GET';//HTTP Request Type
			req.addHeader('Content-Type', 'application/json');
			//req.requestBody = Blob.valueof(JsonMsg);
			RestContext.request = req;
			RestContext.response= res;
			CXE_BS_Paperless_Enroll.load();
		}
	}
	
	
}