@isTest
private class CXE_BS_Alias_Test {
	
	@testSetup static void setup(){
        
        CXE_TestDataFactory.setupPortalData('2', true);

    }

	private static testMethod void TestPost(){

		Agreement__c service;
		User portalUser;
		CXE_Service_Enrollment__c cxe;

		Test.startTest();
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
	            
	            service =[SELECT Id, SIN__C FROM Agreement__c WHERE SIN__C= '293028374839' LIMIT  1]; 
	            //Insert service enrollment for portal user
	            cxe = new CXE_Service_Enrollment__c();
	            cxe.CXE_ServiceId__c = service.Id;
	            cxe.CXE_UserId__c = portalUser.ID;
	            cxe.CXE_IsActive__c =True;
	            
	            insert cxe;
	            
	            System.assert(cxe!=null);
	        }

		Test.stopTest();


		System.runAs(portalUser){
			CXE_BS_Alias reqst=new CXE_BS_Alias();
			String JsonMsg=JSON.serialize(reqst);

			RestRequest req = new RestRequest(); 
			RestResponse res = new RestResponse();

			req.requestURI = '/services/apexrest/alias-icon';  //Request URL
			req.httpMethod = 'POST';//HTTP Request Type
			req.addHeader('Content-Type', 'application/json');
			req.requestBody = Blob.valueof(JsonMsg);
			RestContext.request = req;
			RestContext.response= res;
			CXE_BS_Alias.post(service.id, 'alias', 'icon');
		}
	}

	private static testMethod void testGet(){

		Agreement__c service;
		User portalUser;
		CXE_Service_Enrollment__c cxe;

		Test.startTest();
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
	            
	            service =[SELECT Id, SIN__C FROM Agreement__c WHERE SIN__C= '293028374839' LIMIT  1]; 
	            //Insert service enrollment for portal user
	            cxe = new CXE_Service_Enrollment__c();
	            cxe.CXE_ServiceId__c = service.Id;
	            cxe.CXE_UserId__c = portalUser.ID;
	            cxe.CXE_IsActive__c =True;
	            
	            insert cxe;
	            
	            System.assert(cxe!=null);
	        }

		Test.stopTest();


		System.runAs(portalUser){
			CXE_BS_Alias reqst=new CXE_BS_Alias();
			String JsonMsg=JSON.serialize(reqst);

			RestRequest req = new RestRequest(); 
			RestResponse res = new RestResponse();

			req.params.put('sid', service.id);
			req.requestURI = '/services/apexrest/alias-icon';  //Request URL
			req.httpMethod = 'GET';//HTTP Request Type
			req.addHeader('Content-Type', 'application/json');
			//req.requestBody = Blob.valueof(JsonMsg);
			RestContext.request = req;
			RestContext.response= res;
			CXE_BS_Alias.load();
		}
	}


}