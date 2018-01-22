/* Description: AgreementTriggerHandler test class
 * Author: Jerome To
 * Date Created: MAR-07-17
 */
@isTest
private class AgreementTriggerHandler_Test {

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

	
	@isTest static void validateContractWithAddressAndPrimaryService() {
		
        Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
		for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
			addressReference.put(addRef.Field__c, addRef);
		}  
        
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
      
        List<Reference__c> referenceRecord = CXE_TestDataFactory.createReferencePicklist(2, 'Billing Class');
        insert referenceRecord;
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount; 

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeId = servRecTypeId;
        caseRecord.Billing_Class__c = 'Name0';
        caseRecord.AccountId = testAccount.Id;
        insert caseRecord;
        
        Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
    	addressRec.Case__c = caseRecord.Id;
        addressRec.Type__c = 'Billing';
    	insert addressRec;
                
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Status = 'Inspection FO Generated';
         Test.StartTest();
        update caseRecord;
        
        List<Contract> testContractList = CXE_TestDataFactory.createContract(1, testAccount.Id, null);
        Contract testContract = testContractList.get(0);
        testContract.Case__c = caseRecord.Id;
        insert testContract;

        addressRec.Contract__c = testContract.Id;  	
        addressRec.Account__c = testAccount.Id;
		update addressRec;

    	Integer numberOfServices = 5;
    	Integer additionalServices = 3;

        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;

    	List<Agreement__c> testAgreementList = CXE_TestDataFactory.createService(numberOfServices, testAccount.id, null, testContract.Id, psicRecord[0].Id);
    	List<Agreement__c> testAgreementList2 = CXE_TestDataFactory.createService(additionalServices, testAccount.id, null, testContract.Id, psicRecord[0].Id);
        
        Agreement__c testAgreement = testAgreementList[0];
        Agreement__c testAgreement2 = testAgreementList2[0];
        
        //System.debug('Agreement Record: ' + testAgreement);
        
        insert testAgreement;
        insert testAgreement2;

        //Test.StartTest();
        	Integer serviceCount = 0;
        	Integer primaryServiceCount = 0;

        	for (Agreement__c serviceRec : [SELECT Case__c, Parent_Tag__c, Account__c FROM Agreement__c WHERE Case__c=:caseRecord.Id]) {
        		serviceCount++;
        		if(serviceRec.Parent_Tag__c) {
        			primaryServiceCount++;
        		}
        		System.assertEquals(testAccount.Id, serviceRec.Account__c);
        	}

        	//System.assertEquals(1, primaryServiceCount);
			//System.assertEquals(numberOfServices + additionalServices, serviceCount);

        Test.StopTest();
        
        //Agreement__c agreementUpdate = [Select Case__c from Agreement__c where id=:testAgreement.id];
        //agreementUpdate.Case__c = caseRecord.Id;
        
        //update testAgreement;
	}

	@isTest static void validateContractWithOutAddress() {
		List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;

        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        //caseRecord.RecordTypeID = servRecTypeId; //START/END RReyes JUL-08-17
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.PSIC__c = psicRecord.id;
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.AccountId = testAccount.Id;
        insert caseRecord;

        //caseRecord.status = CXE_Constants.CASE_MS_ISSUED;
        
        caseRecord.Status = 'Inspection FO Generated';
        update CaseRecord;

        List<Contract> testContractList = CXE_TestDataFactory.createContract(1, testAccount.Id, null);
        Contract testContract = testContractList.get(0);
        testContract.Case__c = caseRecord.Id;
        insert testContract;

        Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
		for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
			addressReference.put(addRef.Field__c, addRef);
		}    	
    	
    	
    	Test.StartTest();
    	try{
    		insert CXE_TestDataFactory.createService(1, null, CaseRecord.Id, testContract.Id, psicRecord.Id);
    	} catch(Exception e) {
    		Boolean isExpectedExceptionThrown =  e.getMessage().contains(CXE_Constants.CREATE_SERVICE_ERROR_MESSAGE_CONTRACT_WITHOUT_ADDRESS) ? true : false;
			System.AssertEquals(true, isExpectedExceptionThrown);
    	}
        Test.StopTest();
	}

    @isTest static void createUpdateService() {
        
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
        for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
            addressReference.put(addRef.Field__c, addRef);
        } 

        Test.startTest();
        Account testAccount = CXE_TestDataFactory.createBusinessAccount(1)[0];
        insert testAccount;

        List<Schedule__c> scheduleRecord = CXE_TestDataFactory.createSchedule(5);
        insert scheduleRecord;
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;
        
        List<Reference__c> referenceRecord = CXE_TestDataFactory.createReferencePicklist(2, 'Billing Class');
        insert referenceRecord;
        //Test.stopTest();

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.PSIC__c = psicRecord[0].id;
        caseRecord.Billing_Class__c = 'Name0';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        insert caseRecord;

        Contract testContract = CXE_TestDataFactory.createContract(1, testAccount.Id, null)[0];
        testContract.Case__c = caseRecord.Id;
        insert testContract;

        Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
        addressRec.Case__c = caseRecord.Id;
        addressRec.Contract__c = testContract.Id;
        addressRec.Type__c = 'Billing';
        insert addressRec;
        Test.stopTest();

        Agreement__c testAgreement = CXE_TestDataFactory.createService(1, testAccount.id, null, testContract.Id, psicRecord[0].Id)[0];
        testAgreement.Applied_Load__c = 200;
        insert testAgreement;
        
        Agreement__c a = [Select id, Code_PSIC__c, Code_Billing_Class__c from Agreement__c where Id=:testAgreement.Id];
        
        system.assertequals(a.Code_PSIC__c, '77770');
        //system.assertequals(a.Code_Billing_Class__c, 0);

        testAgreement.Applied_Load__c = 100;
        testAgreement.Code_PSIC__c = '77771';
        testAgreement.Agreement_Start_Date__c = system.today() + 1;
        testAgreement.SIN__c  = '999';
        update testAgreement;

        AgreementTriggerHandler aggree = new AgreementTriggerHandler();
        aggree.BeforeDelete(null);
        aggree.AfterDelete(null);
        aggree.AfterUndelete(null);
        
    }
	
}