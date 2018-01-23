@isTest
private class DMS_Document_Test
{
	@testSetup static void setUp() {
	 
        List<User> u = CXE_TestDataFactory.createUser(1, CXE_Constants.PROFILE_NAME_MERALCO_G5);
        System.runAs(u[0]){
            Case createdCase = createCase(true);
            Account acct = createAccount(true);
            PSIC__c psic= CXE_TestDataFactory.createPSIC(1)[0];
            insert psic;
            Contract contr= CXE_TestDataFactory.createContract(1, acct.Id, createdCase.Id)[0];
            insert contr;
            Address__c add1 = CXE_TestDataFactory.createAddressWithoutReference('Billing',createdCase.Id,acct.Id,contr.Id,'', '', '');
            insert add1;
            
            Test.startTest();
            Agreement__c service = CXE_TestDataFactory.createService(1, acct.Id, createdCase.Id, contr.Id, psic.Id)[0];
            service.Service_Status__c = 'Active';
            insert service;
            
            List<Case> caseModification = CXE_TestDataFactory.createModificationCase(1, service.Id, 'Relocation');
            insert caseModification;
            Address__c add = CXE_TestDataFactory.createAddressWithoutReference('Service',caseModification[0].Id,acct.Id,contr.Id,service.Id, '', '');
            insert add;

            DMS_Document__c dms = new DMS_Document__c(
            		CXE_Case__c = createdCase.Id,
            		CXE_Account__c = acct.Id,
            		CXE_Service__c = service.Id
            	);
			
			insert dms;
			Test.stopTest();

			//delete dms;

            
        }
        
    }

    static testMethod void deleteDMS() {

		DMS_Document__c dms = [Select id from DMS_Document__c limit 1];

    	delete dms;
    }

    private static Case createCase(Boolean isBusiness){
        
    	Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Service', 'Single meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
		caseRecord.RecordTypeID = servRecTypeId;
		caseRecord.Telephone_No__c = '+6356748321';
		caseRecord.Billing_Address_Barangay__c	= 'SAN LORENZO';
		caseRecord.Billing_Address_City_Municipal__c = 'MAKATI CITY';
		caseRecord.Conglomerate_Tag__c = true;
		caseRecord.Date_of_Birth__c = System.today();
		caseRecord.Email_Address__c = 'test@test.com';
		caseRecord.First_Name__c = 'Case';
		caseRecord.Last_Name__c = 'Case';
		caseRecord.Billing_Address_Street_No__c = '123';
		caseRecord.Last_Name_Business_Name__c = 'Test';
		caseRecord.Middle_Name__c = 'Middle';
		caseRecord.Mobile_No__c =	'+631234567890';
		caseRecord.Billing_Address_Province__c = 'METRO MANILA';
		caseRecord.Billing_Address_Street_Name__c = 'Paseo St.';
		caseRecord.Billing_Address_Subdivision__c = 'Insular Building';
		caseRecord.Billing_Address_Unit_No__c= 'Unit 2';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
		//caseRecord.Application_for_Business_Customer__c = true;
		//caseRecord.Application_for_Residential_Customer__c = true;
        if(isBusiness){
            caseRecord.Application_for_Business_Customer__c = true;
            caseRecord.Application_for_Residential_Customer__c = false;
        }else{
            caseRecord.Application_for_Residential_Customer__c = true;
            caseRecord.Application_for_Business_Customer__c = false;
        }
        
        insert caseRecord;

		return caseRecord;
    }

    private static Account createAccount(Boolean isBusiness){
		 List<Account> acctList = new List<Account>();
		 Account acctRecord = new Account();
		 
		 Reference__c referenceRecord = CXE_TestDataFactory.createReferencePicklist(1, 'Customer Type')[0];
         insert referenceRecord;
		 
		 if(isBusiness){
			acctList = CXE_TestDataFactory.createBusinessAccount(1);
			acctRecord = acctList[0];
			
            acctRecord.Name = 'Business Account Name';
			acctRecord.Conglomerate__c = true;
			acctRecord.Email__c = 'test@test.com';
			acctRecord.Mobile_Phone__c = '+631234567890';
		 }else{
			acctList = CXE_TestDataFactory.createPersonAccount(1);
			acctRecord = acctList[0];
			
			acctRecord.PersonEmail = 'test@test.com';
			acctRecord.FirstName = 'Case';
			acctRecord.LastName = 'Test';
			acctRecord.MiddleName = 'Middle';
			acctRecord.PersonMobilePhone = '+631234567890';
		 }
		acctRecord.Phone='+6356748321';
		acctRecord.Billing_Address_Barangay__c	= 'SAN LORENZO'	;
		acctRecord.Billing_Address_City_Municipal__c =  'MAKATI CITY'	;
		acctRecord.Billing_Address_Province__c	=	'METRO MANILA'	;
		acctRecord.Billing_Address_Street_Name__c	=	'Paseo St.'	;
		acctRecord.Billing_Address_Subdivision__c	=	'Insular Building'	;
		acctRecord.Billing_Address_Unit_No__c	=	'Unit 2';
		acctRecord.Customer_Type__c = 'Name0';
		insert acctRecord;
        
        
		return acctRecord;
    }
}