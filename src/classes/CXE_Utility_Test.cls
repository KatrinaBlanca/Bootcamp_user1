@isTest
 public class CXE_Utility_Test
 {
   private static testMethod void testAddressIdTransformation()
   {
   		List<Reference__c> refProvince = CXE_TestDataFactory.createSampleReferenceListForAddress();
   		insert refProvince;

   		Set<String> setProvinceCode = new Set<String>();
   		for(Reference__c ref : refProvince){
   			if(ref.Field__c == 'Province')
	   			setProvinceCode.add(ref.Name_Code__c);
   		}
		
		Map<String, Id> addressIdMapping = CXE_Utility.getAddressIdTransformation(setProvinceCode);

		System.assert(!addressIdMapping.isEmpty());
   }

   private static testMethod void testAddressCodeTransformation()
   {
   		List<Reference__c> refProvince = CXE_TestDataFactory.createSampleReferenceListForAddress();
   		insert refProvince;

   		Set<Id> setProvinceId = new Set<Id>();
   		for(Reference__c ref : refProvince){
   			if(ref.Field__c == 'Province')
   				setProvinceId.add(ref.Id);
   		}
		
		Map<Id, String> addressCodeMapping = CXE_Utility.getAddressCodeTransformation(setProvinceId);

		System.assert(!addressCodeMapping.isEmpty());
   }

   private static testMethod void testGetProfileIds()
   {
		String profileName = 'MERALCO G1';
		Map<Id, String> profileIdName = CXE_Utility.getProfileIds(profileName);

		System.assert(!profileIdName.isEmpty());
   }

   private static testMethod void testPicklistTransformationDesc()
   {
   		List<Reference__c> refList = CXE_TestDataFactory.createSampleReferenceListForAddress();
   		Reference__c refType = refList[0];
   		refType.Field__c = 'Premises Type';
   		refType.Type__c = 'Picklist';

   		insert refType;
		
		List<List<String>> arrayList = CXE_Constants.ADDRESS_PICKLIST_ARRAY;
        Map<String, String> mapPicklistDesc = CXE_Utility.picklistTransformationDesc(arrayList);

		System.assert(!mapPicklistDesc.isEmpty());
   }

   private static testMethod void testPicklistTransformationCode()
   {
   		List<Reference__c> refList = CXE_TestDataFactory.createSampleReferenceListForAddress();
   		Reference__c refType = refList[0];
   		refType.Field__c = 'Premises Type';
   		refType.Type__c = 'Picklist';

   		insert refType;
		
		List<List<String>> arrayList = CXE_Constants.ADDRESS_PICKLIST_ARRAY;
        Map<String, String> mapPicklistCode = CXE_Utility.picklistTransformationCode(arrayList);

		System.assert(!mapPicklistCode.isEmpty());
   }

   private static testMethod void testPicklistTransformationInsert()
   {		
		List<Reference__c> referenceList = CXE_TestDataFactory.createReferencePicklist(3, 'Customer Type');
		
		Reference__c ref1 = referenceList[0];
		ref1.Name = 'Private';
		ref1.Name_Code__c = 'CT001';

		Reference__c ref2 = referenceList[1];
		ref2.Name = 'National Government';
		ref2.Name_Code__c = 'CT002';

		Reference__c ref3 = referenceList[2];
		ref3.Name = 'Local Government';
		ref3.Name_Code__c = 'CT003';

		referenceList = new List<Reference__c>();
		referenceList.add(ref1);
		referenceList.add(ref2);		
		referenceList.add(ref3);
        insert referenceList;

		List<Account> acctList = CXE_TestDataFactory.createBusinessAccount(1);
		Account acctRecord = acctList[0];

		acctRecord.Name = 'Business Account Name';
		acctRecord.Conglomerate__c = true;
		acctRecord.Email__c = 'test@test.com';
		acctRecord.Mobile_Phone__c = '+631234567890';
		acctRecord.Customer_Type__c = 'Private';
		Test.startTest();
			insert acctRecord;
		Test.stopTest();

		Account acct = [SELECT Customer_Type__c, Code_Customer_Type__c FROM Account Where Id=: acctRecord.Id];
		System.assertNotEquals(null, acct.Code_Customer_Type__c);
		System.assertEquals(acct.Code_Customer_Type__c, 'CT001');
   }

   private static testMethod void testPicklistTransformationUpdate()
   {		
		List<Reference__c> referenceList = CXE_TestDataFactory.createReferencePicklist(3, 'Customer Type');
		
		Reference__c ref1 = referenceList[0];
		ref1.Name = 'Private';
		ref1.Name_Code__c = 'CT001';

		Reference__c ref2 = referenceList[1];
		ref2.Name = 'National Government';
		ref2.Name_Code__c = 'CT002';

		Reference__c ref3 = referenceList[2];
		ref3.Name = 'Local Government';
		ref3.Name_Code__c = 'CT003';

		referenceList = new List<Reference__c>();
		referenceList.add(ref1);
		referenceList.add(ref2);		
		referenceList.add(ref3);
        insert referenceList;

		List<Account> acctList = CXE_TestDataFactory.createBusinessAccount(1);
		Account acctRecord = acctList[0];

		acctRecord.Name = 'Business Account Name';
		acctRecord.Conglomerate__c = true;
		acctRecord.Email__c = 'test@test.com';
		acctRecord.Mobile_Phone__c = '+631234567890';
		acctRecord.Customer_Type__c = 'Private';
		insert acctRecord;

		acctRecord.Customer_Type__c = 'National Government';
		Test.startTest();
			update acctRecord;
		Test.stopTest();

		Account acct = [SELECT Customer_Type__c, Code_Customer_Type__c FROM Account Where Id=: acctRecord.Id];
		System.assertNotEquals(null, acct.Code_Customer_Type__c);
		System.assertEquals(acct.Code_Customer_Type__c, 'CT002');
   }

   private static testMethod void testPicklistTransformationUpdateSRPicklist()
   {    
    List<Reference__c> referenceList = CXE_TestDataFactory.createReferencePicklist(3, 'Customer Type');
    
    Reference__c ref1 = referenceList[0];
    ref1.Name = 'Change in Contract Name';
    ref1.Name_Code__c = 'CT001';
    ref1.Field__c = 'Service Request';

    Reference__c ref2 = referenceList[1];
    ref2.Name = ' Additional Load';
    ref2.Name_Code__c = 'CT002';
    ref2.Field__c = 'Service Request';

    Reference__c ref3 = referenceList[2];
    ref3.Name = 'Remodel';
    ref3.Name_Code__c = 'CT003';
    ref3.Field__c = 'Service Request';

    referenceList = new List<Reference__c>();
    referenceList.add(ref1);
    referenceList.add(ref2);    
    referenceList.add(ref3);
    insert referenceList;

    Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
    caseRecord.GSL4_Check__c = true;
    caseRecord.CXE_Service_Request_s__c = 'Change in Contract Name;Additional Load;Remodel';
    //caseRecord.GSL4_Target_Date__c = system.today();
    //caseRecord.New_GSL4_Target_Date__c = system.today();
    caseRecord.Reason_for_GSL4_Target_Date_Modification__c = 'Test for gsl4 approval';
    //caseRecord.ContactId = contactRecord.id;
    caseRecord.Individual_Business_Tag__c = 'No';
    caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
    //caseRecord.PSIC__c = psicRecord.id;
    caseRecord.Initial_Responsible_Office__c = 'RO1';
    caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
    caseRecord.Tax_Identification_No__c = '123';
    caseRecord.Telephone_No__c = '+6312312421';
    caseRecord.Mobile_No__c = '+631324358765';
    caseRecord.Application_for_Business_Service__c = true;
    caseRecord.CXE_Request_for_Lifting_of_Arrears_Tag__c = true;
    caseRecord.CXE_Reason_for_Lifting_of_Arrears_Tag__c = 'sample';
            
    insert caseRecord;

    //caseRecord.GSL4_Target_Date__c = system.today() + 10;
    caseRecord.CXE_Service_Request_s__c = 'Change in Contract Name;Additional Load';
    update caseRecord;

    /*
    acctRecord.Customer_Type__c = 'National Government';
    Test.startTest();
      update acctRecord;
    Test.stopTest();

    Account acct = [SELECT Customer_Type__c, Code_Customer_Type__c FROM Account Where Id=: acctRecord.Id];
    System.assertNotEquals(null, acct.Code_Customer_Type__c);
    System.assertEquals(acct.Code_Customer_Type__c, 'CT002');
    */
   }

   private static testMethod void testPicklistTransformationUpdateSRCode()
   {    
    List<Reference__c> referenceList = CXE_TestDataFactory.createReferencePicklist(3, 'Customer Type');
    
    Reference__c ref1 = referenceList[0];
    ref1.Name = 'Change in Contract Name';
    ref1.Name_Code__c = 'CT001';
    ref1.Field__c = 'Service Request';

    Reference__c ref2 = referenceList[1];
    ref2.Name = ' Additional Load';
    ref2.Name_Code__c = 'CT002';
    ref2.Field__c = 'Service Request';

    Reference__c ref3 = referenceList[2];
    ref3.Name = 'Remodel';
    ref3.Name_Code__c = 'CT003';
    ref3.Field__c = 'Service Request';

    referenceList = new List<Reference__c>();
    referenceList.add(ref1);
    referenceList.add(ref2);    
    referenceList.add(ref3);
    insert referenceList;

    Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
    caseRecord.GSL4_Check__c = true;
    caseRecord.CXE_Code_Service_Request_s__c = 'CT001;CT002;CT003';
    //caseRecord.GSL4_Target_Date__c = system.today();
    //caseRecord.New_GSL4_Target_Date__c = system.today();
    caseRecord.Reason_for_GSL4_Target_Date_Modification__c = 'Test for gsl4 approval';
    //caseRecord.ContactId = contactRecord.id;
    caseRecord.Individual_Business_Tag__c = 'No';
    caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
    //caseRecord.PSIC__c = psicRecord.id;
    caseRecord.Initial_Responsible_Office__c = 'RO1';
    caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
    caseRecord.Tax_Identification_No__c = '123';
    caseRecord.Telephone_No__c = '+6312312421';
    caseRecord.Mobile_No__c = '+631324358765';
    caseRecord.Application_for_Business_Service__c = true;
    caseRecord.CXE_Request_for_Lifting_of_Arrears_Tag__c = true;
    caseRecord.CXE_Reason_for_Lifting_of_Arrears_Tag__c = 'sample';
            
    insert caseRecord;

    //caseRecord.GSL4_Target_Date__c = system.today() + 10;
    caseRecord.CXE_Code_Service_Request_s__c = 'CT001;CT002';
    update caseRecord;

    /*
    acctRecord.Customer_Type__c = 'National Government';
    Test.startTest();
      update acctRecord;
    Test.stopTest();

    Account acct = [SELECT Customer_Type__c, Code_Customer_Type__c FROM Account Where Id=: acctRecord.Id];
    System.assertNotEquals(null, acct.Code_Customer_Type__c);
    System.assertEquals(acct.Code_Customer_Type__c, 'CT002');
    */
   }

	private static testMethod void testGetCreatedRequirements(){	
		
		Set<String> listRequirement = CXE_Constants.REQUIREMENT_FOR_RECONTRACT;

		Case caseRecord = CXE_TestDataFactory.createRecontractCase(1, '')[0];
        insert caseRecord;

        Set<String> createdRequirement = CXE_Utility.createdRequirements(listRequirement, caseRecord.Id);

        for(String reqType : listRequirement){
        	System.assert(createdRequirement.contains(caseRecord.Id + reqType));
        }
	}

	private static testMethod void testcreateRequirement(){	
		Set<String> listRequirement = CXE_Constants.REQUIREMENT_FOR_RECONTRACT;

		Case caseRecord = CXE_TestDataFactory.createRecontractCase(1, '')[0];
        insert caseRecord;

        Set<String> requirementCaseId = CXE_Utility.createdRequirements(listRequirement, caseRecord.Id);
        listRequirement.add('Additional Requirement');

        List<Requirement__c> createdRequirements = CXE_Utility.createRequirement(listRequirement, caseRecord.Id, requirementCaseId);
        System.assert(createdRequirements.size() == 1);

	}

	private static testMethod void testdoSend(){	
		CXE_Wrapper_EXT.serviceObject servObj = new CXE_Wrapper_EXT.serviceObject();
		servObj.url = 'https://myUrl.com';
		servObj.method = 'method';
		servObj.authtype = 'authtype';
		servObj.username = 'username';
		servObj.password = 'password';
		servObj.clientId = 'clientId';
		servObj.clientSecret = 'clientSecret';
		servObj.bearerTokenSessionId =  'bearerTokenSessionId';
		servObj.codeBlock = 'codeBlock';

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());	
		CXE_Utility util = new CXE_Utility();
		HttpResponse resp = util.doSend(servObj);
		System.assertEquals('OK', resp.getStatus());
	}

	private static testMethod void testgetCaseTransitions(){	

		Account testAccount = CXE_TestDataFactory.createPersonAccount(1)[0];
    	testAccount.LastName = 'LName';
    	insert testAccount;

		Case caseRecord = CXE_TestDataFactory.createRecontractCase(1, '')[0];
		caseRecord.AccountId = testAccount.Id;
        insert caseRecord;

        String caseNum = [SELECT Id, CaseNumber FROM Case WHERE Id=:caseRecord.Id LIMIT 1].CaseNumber;

        Case_State_Transition__c cst = new Case_State_Transition__c();
        cst.Case__c = caseRecord.Id;
        cst.From_Date_Stamp__c = System.today();
        cst.To_Date_Stamp__c = System.today();
        cst.From_State__c = 'FROM';
        cst.To_State__c = 'TO';
        insert cst;

        Test.startTest();
        List<Case_State_Transition__c> cstList = CXE_Utility.getCaseTransitions(caseNum, testAccount.LastName);
        System.assert(!cstList.isEmpty());
        Test.stopTest();

	}

	static testMethod void testgetCaseStatusHistory()
    {  

        List<Reference__c> addressRefList = CXE_TestDataFactory.createSampleReferenceListForAddress();
        insert addressRefList;
        for(Integer i=0 ; i<addressRefList.size() ; i++) {
            if(i>0){
                addressRefList.get(i).Parent__c = addressRefList.get(i-1).Id;
            }
        }
        update addressRefList;      

        Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
        for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
            addressReference.put(addRef.Field__c, addRef);
        } 

        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_RECONTRACT_OF_ELECTRIC_SERVICE).getRecordTypeId();        
        
        List<Account> listAccount = new List<Account>();

        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        listAccount.add(acc);
        
        Account ExecutingPersonelAcc = CXE_TestDataFactory.createExecutingPersonel(1)[0];
        listAccount.add(ExecutingPersonelAcc);
        insert listAccount;

        Office__c office = CXE_TestDataFactory.createOffice(1)[0];
        insert office;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.AccountId = acc.Id;
        caseRecord.Responsible_Office_Lookup__c = office.id;
        insert caseRecord;

        Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
        addressRec.Case__c = caseRecord.Id;
        addressRec.Type__c = 'Service';
        insert addressRec;

        Address__c addressRec2 = CXE_TestDataFactory.createAddress(addressReference, true);
        addressRec2.Case__c = caseRecord.Id;
        addressRec2.Type__c = 'Billing';
        insert addressRec2;

        caseRecord.Status = CXE_Constants.CASE_STATUS_APPLICATION_VALIDATED;
        update caseRecord;
     
        Test.startTest();
     
            Id surveyFORecTypeId = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_SURVEY_FO).getRecordTypeId();
           
            Field_Order__c foRecord = new Field_Order__c();
            foRecord.RecordTypeId = surveyFORecTypeId;
            foRecord.Case__c = caseRecord.Id;
            foRecord.Survey_Instructions__c = 'Sample Instructions';
            insert foRecord;
       
            foRecord.Schedule_Date__c = System.today();
            update foRecord;

            CaseHistory ch = new CaseHistory();
            ch.caseId = caseRecord.Id;
            ch.Field = 'Status';
            insert ch;

            CaseHistory caseHis = [SELECT NewValue, OldValue from CaseHistory WHERE Id=:ch.Id LIMIT 1];

            System.assertEquals(null, caseHis.NewValue);
            System.assertEquals(null, caseHis.OldValue);
            Map<String, Case_Status_Setting__mdt> caseSetting = new Map<String, Case_Status_Setting__mdt>();
            List<CXE_CaseHistoryWrapper> lst = CXE_Utility.getCaseStatusHistory(caseRecord, caseSetting);
            System.assert(!lst.isEmpty());
            /*
            foRecord.Schedule_Date__c = System.today();
            foRecord.Executing_Personnel_FO__c = ExecutingPersonelAcc.Id;
            foRecord.Resolution_Date__c = System.today();
            foRecord.Resolution_Remarks__c = 'Sample Remarks';
            foRecord.Inspection_Result__c = 'Approved';
            foRecord.TLN__c = '12';
            foRecord.Pole_Code__c = '1';
            foRecord.Service_Wire_Type__c = 'Aerial Alum.,Bundled';
            foRecord.Service_Wire_Length__c = 1;
            foRecord.Service_Wire_Size__c = '#1/0';
            foRecord.Material__c = 'Aluminum';
            foRecord.Metering_Scheme__c = 'NORMAL';
            foRecord.Mode_of_Retrieval__c = 'REMOTE';
            update foRecord;
			
            caseRecord = [SELECT Id, Re_Inspection_FO_Resolution_Remarks__c FROM Case WHERE Id =: caseRecord.Id];
            */
        Test.stopTest();
    }
   
}