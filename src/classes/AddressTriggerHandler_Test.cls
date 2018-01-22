/* Description: AgreementTriggerHandler test class
 * Author: Jerome To
 * Date Created: MAR-07-17
 */
@isTest
private class AddressTriggerHandler_Test {
	
	@testSetup static void setUp() {
		// create References
		List<Reference__c> addressRefList = CXE_TestDataFactory.createSampleReferenceListForAddress();
		insert addressRefList;
		for(Integer i=0 ; i<addressRefList.size() ; i++) {
			if(i>0){
				addressRefList.get(i).Parent__c = addressRefList.get(i-1).Id;
			}
		}
		update addressRefList;		
	}

	@isTest static void validateAddressCreationUsingLookUp() {
        // Implement test code
		Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
		for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
			addressReference.put(addRef.Field__c, addRef);
		}
		Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
		insert addressRec;
		Test.startTest();
		Address__c	newAddressRec = [SELECT Address_Province__c, Address_City_Municipality__c, Address_Barangay__c, 
								 			Address_Street_Name__c, Address_Subdivision__c,
								 			Code_Address_Province__c, Code_Address_City_Municipality__c, Code_Address_Barangay__c, 
								 			Code_Address_Street_Name__c, Code_Address_Subdivision__c 
						  			 FROM Address__c
						  			 WHERE Id=:addressRec.Id];

		System.assertEquals(newAddressRec.Address_Province__c, addressReference.get('Province').Id);
		System.assertEquals(newAddressRec.Address_City_Municipality__c, addressReference.get('City').Id);
		System.assertEquals(newAddressRec.Address_Barangay__c, addressReference.get('Barangay').Id);
		System.assertEquals(newAddressRec.Address_Street_Name__c, addressReference.get('Street').Id);
		System.assertEquals(newAddressRec.Address_Subdivision__c, addressReference.get('Subdivision').Id);
		System.assertEquals(newAddressRec.Code_Address_Province__c, addressReference.get('Province').Name_Code__c);
		System.assertEquals(newAddressRec.Code_Address_City_Municipality__c, addressReference.get('City').Name_Code__c);
		System.assertEquals(newAddressRec.Code_Address_Barangay__c, addressReference.get('Barangay').Name_Code__c);
		System.assertEquals(newAddressRec.Code_Address_Street_Name__c, addressReference.get('Street').Name_Code__c);
		System.assertEquals(newAddressRec.Code_Address_Subdivision__c, addressReference.get('Subdivision').Name_Code__c);
		Test.stopTest();

	}

	@isTest static void validateAddressCreationUsingCode() {
		// Implement test code
		Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
		for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
			addressReference.put(addRef.Field__c, addRef);
		}
		Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, false);
		insert addressRec;
		Test.startTest();
		Address__c	newAddressRec = [SELECT Code_Address_Province__c, Code_Address_City_Municipality__c, Code_Address_Barangay__c, 
								 			Code_Address_Street_Name__c, Code_Address_Subdivision__c,
								 			Address_Province__c, Address_City_Municipality__c, Address_Barangay__c, 
								 			Address_Street_Name__c, Address_Subdivision__c 
						  			 FROM Address__c
						  			 WHERE Id=:addressRec.Id];

		System.assertEquals(newAddressRec.Code_Address_Province__c, addressReference.get('Province').Name_Code__c);
		System.assertEquals(newAddressRec.Code_Address_City_Municipality__c, addressReference.get('City').Name_Code__c);
		System.assertEquals(newAddressRec.Code_Address_Barangay__c, addressReference.get('Barangay').Name_Code__c);
		System.assertEquals(newAddressRec.Code_Address_Street_Name__c, addressReference.get('Street').Name_Code__c);
		System.assertEquals(newAddressRec.Code_Address_Subdivision__c, addressReference.get('Subdivision').Name_Code__c);
		System.assertEquals(newAddressRec.Address_Province__c, addressReference.get('Province').Id);
		System.assertEquals(newAddressRec.Address_City_Municipality__c, addressReference.get('City').Id);
		System.assertEquals(newAddressRec.Address_Barangay__c, addressReference.get('Barangay').Id);
		System.assertEquals(newAddressRec.Address_Street_Name__c, addressReference.get('Street').Id);
		System.assertEquals(newAddressRec.Address_Subdivision__c, addressReference.get('Subdivision').Id);
		Test.stopTest();
	}

	@isTest static void validateAddressUpdateUsingCode() {
		// Implement test code
		//List<Reference__c> addList = CXE_TestDataFactory.createSampleReferenceListForAddress();
        //insert addList;
		Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
		for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
			addressReference.put(addRef.Field__c, addRef);
		}
		Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
		insert addressRec;
		
		Address__c	newAddressRec = [SELECT Address_Province__c, Address_City_Municipality__c, Address_Barangay__c, 
								 			Address_Street_Name__c, Address_Subdivision__c,
								 			Code_Address_Province__c, Code_Address_City_Municipality__c, Code_Address_Barangay__c, 
								 			Code_Address_Street_Name__c, Code_Address_Subdivision__c  
						  			 FROM Address__c
						  			 WHERE Id=:addressRec.Id];
		newAddressRec.Address_Province__c = null;
		newAddressRec.Address_City_Municipality__c = null;
		newAddressRec.Address_Barangay__c = null;
		newAddressRec.Address_Street_Name__c = null;
		newAddressRec.Address_Subdivision__c = null;
		update newAddressRec;
		Test.startTest();
		Address__c	updatedAddress = [SELECT Address_Province__c, Address_City_Municipality__c, Address_Barangay__c, 
								 			 Address_Street_Name__c, Address_Subdivision__c 
						  			  FROM Address__c
						  			  WHERE Id=:addressRec.Id];		

		System.assertEquals(updatedAddress.Address_Province__c, null);
		System.assertEquals(updatedAddress.Address_City_Municipality__c, null);
		System.assertEquals(updatedAddress.Address_Barangay__c, null);
		System.assertEquals(updatedAddress.Address_Street_Name__c, null);
		System.assertEquals(updatedAddress.Address_Subdivision__c, null);
		Test.stopTest();
	}

	@isTest static void validateAddressUpdateUsingLookUp() {
		// Implement test code
		Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
		for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
			addressReference.put(addRef.Field__c, addRef);
		}
		Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
		insert addressRec;

		Address__c	newAddressRec = [SELECT Address_Province__c, Address_City_Municipality__c, Address_Barangay__c, 
								 			Address_Street_Name__c, Address_Subdivision__c,
								 			Code_Address_Province__c, Code_Address_City_Municipality__c, Code_Address_Barangay__c, 
								 			Code_Address_Street_Name__c, Code_Address_Subdivision__c  
						  			 FROM Address__c
						  			 WHERE Id=:addressRec.Id];
		newAddressRec.Code_Address_Province__c = '';
		newAddressRec.Code_Address_City_Municipality__c = '';
		newAddressRec.Code_Address_Barangay__c = '';
		newAddressRec.Code_Address_Street_Name__c = '';
		newAddressRec.Code_Address_Subdivision__c = '';
		update newAddressRec;
		Test.startTest();
		Address__c	updatedAddress = [SELECT Code_Address_Province__c, Code_Address_City_Municipality__c, Code_Address_Barangay__c, 
								 			 Code_Address_Street_Name__c, Code_Address_Subdivision__c 
						  			  FROM Address__c
						  			  WHERE Id=:addressRec.Id];		

		System.assertEquals(updatedAddress.Code_Address_Province__c, null);
		System.assertEquals(updatedAddress.Code_Address_City_Municipality__c, null);
		System.assertEquals(updatedAddress.Code_Address_Barangay__c, null);
		System.assertEquals(updatedAddress.Code_Address_Street_Name__c, null);
		System.assertEquals(updatedAddress.Code_Address_Subdivision__c, null);
		Test.stopTest();
	}
    
    @isTest static void createAddressWithCase() {
		// Implement test code   
		//List<Reference__c> refList = CXE_TestDataFactory.createSampleReferenceListForAddress();
        //insert refList;
		
		List<Reference__c> referenceRecord = CXE_TestDataFactory.createReferencePicklist(2, 'Billing Class');
        insert referenceRecord;

		Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
		//caseRecord.Application_for_Residential_Service__c = true;
		caseRecord.Date_of_Birth__c = system.today() - 1000;
		caseRecord.Tax_Identification_No__c = '123124123';
		caseRecord.Billing_Class__c = 'Name0';
        insert caseRecord;
        
		Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
		for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
			addressReference.put(addRef.Field__c, addRef);
		}
        
        Id offRecTypeId = Schema.Sobjecttype.Office__c.getRecordTypeInfosByName().get(CXE_Constants.OFFICE_WEB).getRecordTypeId();
        Office__c officeRec = CXE_TestDataFactory.createOffice(1)[0];
        officeRec.RecordTypeId = offRecTypeId;
        
        insert officeRec;
        
        Office_Jurisdiction__c officeJurRec = CXE_TestDataFactory.createOfficeJurisdiction(1)[0];
        officeJurRec.Province__c = addressReference.get('Province').Id;
        officeJurRec.City__c = addressReference.get('City').Id;
        officeJurRec.Barangay__c = addressReference.get('Barangay').Id;
        officeJurRec.Street_Name__c = addressReference.get('Street').Id;
        officeJurRec.Subdivision__c = addressReference.get('Subdivision').Id;
        officeJurRec.Office__c = officeRec.Id;
        
        insert officeJurRec;
        
        Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
        addressRec.Type__c = 'Service';
        addressRec.Case__c = caseRecord.Id;
		insert addressRec;
		
	}
	
}