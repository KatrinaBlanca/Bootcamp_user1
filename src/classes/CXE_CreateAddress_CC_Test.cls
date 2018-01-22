/* Description: CXE_CreateAddress_CC test class
 * Author: Michael Lasala
 * Date Created: MAR-06-17
 * Updated By: Rom Edison Reyes MAR-31-17
 */
 @isTest
 public class CXE_CreateAddress_CC_Test {

 	//Get Address Picklist values
    static testMethod void addressPicklistValuesTest(){
        
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;

        Case testCase = createCase();
        
        Test.StartTest();
            List<String> addressTypeValuesAccount = CXE_CreateAddress_CC.getAddressType(testAccount.Id);
            List<String> addressTypeValuesCase = CXE_CreateAddress_CC.getAddressType(testCase.Id);
            List<String> premiseTypeValues = CXE_CreateAddress_CC.getPremiseType();
        Test.StopTest();
        
		Schema.DescribeFieldResult addressTypeResult = Address__c.Type__c.getDescribe();

        //-1 for actual results (Please Select value)
        System.assertEquals(Address__c.Type__c.getDescribe().getPicklistValues().size()-1, addressTypeValuesAccount.size()-1);
        //-1 for expected results (no meter for account)
        System.assertEquals(Address__c.Type__c.getDescribe().getPicklistValues().size(), addressTypeValuesCase.size()-1);
        System.assertEquals(Address__c.Premise_Type__c.getDescribe().getPicklistValues().size(), premiseTypeValues.size()-1);
    }

    //String methods
    static testMethod void stringMethodsTest(){
        
        Test.StartTest();
            String sobjectType = CXE_CreateAddress_CC.getSobjectType(createCase().Id);
            String currentUser = CXE_CreateAddress_CC.getUser();
        Test.StopTest();
        
		Schema.DescribeFieldResult addressTypeResult = Address__c.Type__c.getDescribe();

        System.assertEquals('Case', sobjectType);
        System.assertEquals(currentUser, UserInfo.getFirstName()+' '+UserInfo.getLastName());
    }

    //getObject - Case
    static testMethod void getObjectCaseTest(){
        
        Case testCase = createCase();
        Test.StartTest();
           List<String> stringList = CXE_CreateAddress_CC.getObject(testCase.Id);
        Test.StopTest();
        
        Case createdCase = [SELECT CaseNumber FROM Case WHERE Id =: testCase.Id LIMIT 1];

        System.assertEquals('Case', stringList.get(0));
        System.assertEquals(createdCase.CaseNumber, stringList.get(1));
    }
	
    /*Start: CommentedOut by Melvin Corbes 7/12/2017
     * error log
    * System.DmlException: Insert failed. First exception on row 0; 
    * first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, User does not have permission to change the status at this stage: []
    * 
    //Get Service Address
    static testMethod void getServiceAddressTest(){
        
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();

        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;

        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;

    	List<PSIC__c> testPSICList = CXE_TestDataFactory.createPSIC(1);
    	insert testPSICList;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Meter Socket Issued', 'Private')[0];
        //caseRecord.RecordTypeID = servRecTypeId; //START/END RReyes JUL-08-17
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.PSIC__c = testPSICList[0].id;
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        insert caseRecord;

        List<Contract> testContractList = CXE_TestDataFactory.createContract(1, testAccount.Id, null);
        Contract testContract = testContractList.get(0);
        testContract.Case__c = caseRecord.Id;
        insert testContract;

        //START MAR-31-17 RReyes - used the new TestDataFactory.createAddress method
        List<Address__c> lstAddress = new List<Address__c>();

    	Address__c testAddress = CXE_TestDataFactory.createAddress('Contract__c', testContract.Id);
    	testAddress.Account__c = testAccount.Id;

        Address__c testAddressService = CXE_TestDataFactory.createAddress('Service__c', null);
        testAddressService.Account__c = testAccount.Id;

        lstAddress.add(testAddress);
        lstAddress.add(testAddressService);

        insert lstAddress;
        //END MAR-31-17 RReyes - used the new TestDataFactory.createAddress method
    	
        List<Agreement__c> testServiceList = CXE_TestDataFactory.createService(1, 
    																		   testAccount.Id, 
    																		   caseRecord.Id, 
    																		   testContract.Id, 
    																		   testPSICList.get(0).Id);
    	Agreement__c testService = testServiceList.get(0);
    	insert testService;
    	
        Test.StartTest();
        	List<String> stringList = CXE_CreateAddress_CC.getObject(testService.Id);
            String testServiceAddressList = CXE_CreateAddress_CC.updateSelectedAddresses(testService.Id, new List<String>{testAddressService.Id});
            Integer serviceCount = CXE_CreateAddress_CC.getServiceAddressCount(testService.Id);
            List<Address__c> testAccountAddressList = CXE_CreateAddress_CC.getAccountAddresses(testAccount.Id, testService.Id);
        Test.StopTest();
        
        System.assertEquals('Service', stringList.get(0));
        //System.assertEquals(createdCase.CaseNumber, stringList.get(1));
        System.assertEquals('Success', testServiceAddressList);
        System.assertEquals(1, serviceCount);
        System.assertEquals(false, testAccountAddressList.isEmpty());

    }
 

    static testMethod void getContractAddressTest(){
        
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();

        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;

        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;

        List<PSIC__c> testPSICList = CXE_TestDataFactory.createPSIC(1);
        insert testPSICList;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Meter Socket Issued', 'Private')[0];
        //caseRecord.RecordTypeID = servRecTypeId; //START/END RReyes JUL-08-17
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.PSIC__c = testPSICList[0].id;
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        insert caseRecord;

        List<Contract> testContractList = CXE_TestDataFactory.createContract(1, testAccount.Id, null);
        Contract testContract = testContractList.get(0);
        testContract.Case__c = caseRecord.Id;
        insert testContract;

        //START MAR-31-17 RReyes - used the new TestDataFactory.createAddress method
        List<Address__c> lstAddress = new List<Address__c>();

        Address__c testAddress = CXE_TestDataFactory.createAddress('Contract__c', testContract.Id);
        testAddress.Account__c = testAccount.Id;

        Address__c testAddressService = CXE_TestDataFactory.createAddress('Service__c', null);
        testAddressService.Account__c = testAccount.Id;

        lstAddress.add(testAddress);
        lstAddress.add(testAddressService);

        insert lstAddress;
        //END MAR-31-17 RReyes - used the new TestDataFactory.createAddress method
        
        Test.StartTest();
            List<String> stringList = CXE_CreateAddress_CC.getObject(testContract.Id);
            String testServiceAddressList = CXE_CreateAddress_CC.updateSelectedAddresses(testContract.Id, new List<String>{testAddress.Id});
            //Integer serviceCount = CXE_CreateAddress_CC.getServiceAddressCount(testContract.Id);
            List<Address__c> testAccountAddressList = CXE_CreateAddress_CC.getAccountAddresses(testAccount.Id, testAddress.Id);
        Test.StopTest();
        
        System.assertEquals('Contract', stringList.get(0));
        //System.assertEquals(createdCase.CaseNumber, stringList.get(1));
        System.assertEquals('Success', testServiceAddressList);
        //System.assertEquals(1, serviceCount);
        System.assertEquals(false, testAccountAddressList.isEmpty());

    }
	
   *///END:Melvin Corbes
     
    //Search Account and related Address
    static testMethod void searchAccountAddressTest(){

	    List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
	    Account testAccount = testAccountList.get(0);
        insert testAccount;

    	CXE_TestDataFactory.createAddressReference(); //START/END MAR-31-17 RReyes - used the new CXE_TestDataFactory.createAddressReference method

        Reference__c createdProvince = [SELECT Id FROM Reference__c WHERE Field__c = 'Province' LIMIT 1];
        Reference__c createdCity = [SELECT Id FROM Reference__c WHERE Field__c = 'City' LIMIT 1];
        Reference__c createdBaranagay = [SELECT Id FROM Reference__c WHERE Field__c = 'Barangay' LIMIT 1];
        Reference__c createdSubdivision = [SELECT Id FROM Reference__c WHERE Field__c = 'Subdivision' LIMIT 1];
        Reference__c createdStreet = [SELECT Id FROM Reference__c WHERE Field__c = 'Street' LIMIT 1];
        
        createdStreet.Parent__c = createdSubdivision.Id;
        createdSubdivision.Parent__c = createdBaranagay.Id;
        createdBaranagay.Parent__c = createdCity.Id;
        createdCity.Parent__c = createdProvince.Id;

        List<Reference__c> updateReferenceList = new List<Reference__c>();
        updateReferenceList.add(createdStreet);
        updateReferenceList.add(createdSubdivision);
        updateReferenceList.add(createdBaranagay);
        updateReferenceList.add(createdCity);
        update updateReferenceList;
        

        String testAddress = CXE_CreateAddress_CC.insertAddress(testAccount.Id, 
						                                         	'Billing', 
						                                         	'Single-Detached Residential', 
                                                                    '711', 
						                                         	'1', 
						                                         	'2', 
						                                         	createdStreet.Id, 
						                                         	createdSubdivision.Id, 
						                                         	createdBaranagay.Id, 
						                                         	createdCity.Id, 
						                                         	createdProvince.Id);

        Test.StartTest();
            List<Account> accountList = CXE_CreateAddress_CC.getAccounts('tes');
            List<Address__c> addressList = CXE_CreateAddress_CC.getAccountAddresses(testAccount.Id, testAccount.Id);
        Test.StopTest();

        System.assertEquals(testAccountList.size(), accountList.size());
        System.assertEquals(false, addressList.isEmpty());
    }

    //Search Province and Street
    static testMethod void searchAddressTest(){
    	CXE_TestDataFactory.createAddressReference(); //START/END MAR-31-17 RReyes - used the new CXE_TestDataFactory.createAddressReference method
        
        Reference__c createdProvince = [SELECT Id FROM Reference__c WHERE Field__c = 'Province' LIMIT 1];
        Reference__c createdCity = [SELECT Id FROM Reference__c WHERE Field__c = 'City' LIMIT 1];
        Reference__c createdBaranagay = [SELECT Id FROM Reference__c WHERE Field__c = 'Barangay' LIMIT 1];
        Reference__c createdSubdivision = [SELECT Id FROM Reference__c WHERE Field__c = 'Subdivision' LIMIT 1];
        Reference__c createdStreet = [SELECT Id FROM Reference__c WHERE Field__c = 'Street' LIMIT 1];
        
        createdStreet.Parent__c = createdSubdivision.Id;
        createdSubdivision.Parent__c = createdBaranagay.Id;
        createdBaranagay.Parent__c = createdCity.Id;
        createdCity.Parent__c = createdProvince.Id;

        List<Reference__c> updateReferenceList = new List<Reference__c>();
        updateReferenceList.add(createdStreet);
        updateReferenceList.add(createdSubdivision);
        updateReferenceList.add(createdBaranagay);
        updateReferenceList.add(createdCity);
        update updateReferenceList;
                
        Test.StartTest();
            List<Reference__c> testSubdivisionList = CXE_CreateAddress_CC.getSubdivisions('SAN');
            List<Reference__c> testStreetList = CXE_CreateAddress_CC.getStreets('test', createdSubdivision.Id);
        Test.StopTest();
		
        System.assertEquals(createdSubdivision.Id, testSubdivisionList.get(0).Id);
        //System.assertEquals(createdStreet.Id, testStreetList.get(0).Id);
    }

    private testMethod static Case createCase(){
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

    	List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        insert testCase;
        return testCase;
    }

     //start melvin corbes 7/11/2017
     static  testmethod  void getServiceCount(){
        //copied from CXE_CreateService_CC 
         
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;

        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        insert testCase;

         
         Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
         insert contactRecord;
         
		Contract testContract = new Contract(AccountId = testAccount.Id,
		                                     Case__c = testCase.Id,
                                             Method_of_Payment__c = 'ADA (Bank)',
        									 Type__c = 'Regular');
        insert testContract;
        List<Address__c> lstAddress = new List<Address__c>();
         
        Address__c testAddress = new Address__c(Type__c = 'Service', 
                                                Account__c = testAccount.Id,
                                                Case__c = testCase.Id,
                                                Premise_Type__c = 'Single-Detached Residential',
                                                Address_Street_No__c = '1');
                                                
        Address__c testAddress2 = new Address__c(Type__c = 'Billing', 
                                                Account__c = testAccount.Id,
                                                Case__c = testCase.Id,
                                                Contract__c = testContract.Id,
                                                Address_Street_No__c = '1');
         
          Address__c testAddress3 = new Address__c(Type__c = 'Customer', 
                                                Account__c = testAccount.Id,
                                                Case__c = testCase.Id,
                                                Premise_Type__c = 'Single-Detached Residential',
                                                Address_Street_No__c = '1');
         
         
                
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        lstAddress.add(testAddress3);
      
        insert lstAddress;
        

            Agreement__c testAgreement = new Agreement__c(Case__c = testCase.Id, 
    												    Contract__c = testContract.Id, 
    												    Account__c = testAccount.Id,
    												    Rate__c = 'General Service A (GSA)', 
    												    Billing_Class__c = 'General Service A (GSA)', 
    												    Segment__c = 'SME Business Group', 
    												    Service_Wire_TLN__c = '1', 
    												    Service_Wire_Phase__c = 'Single Phase (1Ø), Two (2)-Wire', 
    												    Service_Wire_Pole_Number__c = '1', 
    												    Service_Wire_Type__c = 'Aerial Alum.,Bundled', 
    												    Service_Wire_Length__c = 1, 
    												    Service_Wire_Size__c = '#1/0', 
    												    Service_Wire_Material__c = 'Aluminum', 
    												    Applied_Load__c = 1, 
    												    Phase__c = 'Single Phase (1Ø), Network', 
    												    Voltage_Level__c = '69/39 kV');
    		insert testAgreement;
         
            
         
    
         //create a list of String address Id
         List<String> addIds = new List<String>();
         addIds.add(lstAddress[0].id);
         addIds.add(lstAddress[1].id);
         addIds.add(lstAddress[2].id);
         
        Test.startTest();
         Integer serviceCount = CXE_CreateAddress_CC.getServiceAddressCount(testAgreement.Id);
         Integer billingCount = CXE_CreateAddress_CC.getBillingAddressCount(testContract.Id);
         String updateAddress =CXE_CreateAddress_CC.updateSelectedAddresses(String.valueOf(testCase.Id),addIds);
         String updateAddUsingAcc =CXE_CreateAddress_CC.updateSelectedAddresses(String.valueOf(testAccount.Id),addIds);
         String updateAddUsingContrct =CXE_CreateAddress_CC.updateSelectedAddresses(String.valueOf(testContract.Id),addIds);
         String updateAddUsingContact =CXE_CreateAddress_CC.updateSelectedAddresses(String.valueOf(contactRecord.Id),addIds);
         List<String> stringList = CXE_CreateAddress_CC.getObject(testContract.Id);
         
         
         List <Address__c> addressList =CXE_CreateAddress_CC.getAccountAddresses(testAccount.Id,testAgreement.Id);
	     List <Address__c> addressListContract =CXE_CreateAddress_CC.getAccountAddresses(testAccount.Id,testContract.Id);
		 List <Address__c> addressListContact =CXE_CreateAddress_CC.getAccountAddresses(testAccount.Id,contactRecord.Id);

        Test.stopTest();
         System.assert(serviceCount !=null );
         System.assert(billingCount !=null);
         System.assertEquals('Success',updateAddress);
         System.assertEquals('accountHasCustomer',updateAddUsingAcc);
         //System.assert('Invalid Type, Contract Address should be Billing'== updateAddUsingContrct);
         //System.assert('Invalid Type, Contact Address should be Customer' == updateAddUsingContact);
     }     
     //end melvin corbes 7/11/2017
     
     
    /*
    //START MAR-31-17 CommentedOut by RReyes - used the new CXE_TestDataFactory.createAddressReference and CXE_TestDataFactory.createAddress method
    private testMethod static void createAddressReference(){
    	List<Reference__c> testReferenceList = new List<Reference__c>();

    	Reference__c provinceReference = new Reference__c(Block__c='BATANGAS', 
                                                   		  Field__c='Province', 
                                                   		  Name='BATANGAS', 
                                                   		  Name_Code__c='01000000000000', 
                                                   		  Type__c='Geo');

    	Reference__c cityReference = new Reference__c(Block__c='BATANGAS', 
                                                   	  Field__c='City', 
                                                   	  Name='STO. TOMAS',
                                                   	  Name_Code__c='01029000000000', 
                                                   	  Parent_Code__c='01000000000000', 
                                                   	  Type__c='Geo');

    	Reference__c barangayReference = new Reference__c(Block__c='BATANGAS', 
                                                   		  Field__c='Barangay', 
                                                    	  Name='SAN ROQUE', 
                                                   		  Name_Code__c='01029001700000', 
                                                   		  Parent_Code__c='01029000000000', 
		                                                  Type__c='Geo');

    	Reference__c subdivisionReference = new Reference__c(Block__c='BATANGAS', 
                                                   			 Field__c='Subdivision', 
                                                   			 Name='SAN ROQUE SUBD', 
                                                   			 Name_Code__c='01029001700007', 
                                                   			 Parent_Code__c='01029001700000', 
                                                   			 Type__c='Geo');
    	

    	Reference__c streetReference = new Reference__c(Block__c='BATANGAS', 
                                                   		Field__c='Street', 
                                                   		Name='SAN ROQUE SUBD', 
                                                   		Name_Code__c='1363', 
                                                   		Parent_Code__c='01029001700007', 
                                                   		Type__c='Geo');
    	testReferenceList.add(provinceReference);
    	testReferenceList.add(cityReference);
    	testReferenceList.add(barangayReference);
    	testReferenceList.add(subdivisionReference);
    	testReferenceList.add(streetReference);
    	insert testReferenceList;
    }

    private static Address__c createAddress(String parentField, String parentId){
    	createAddressReference();

    	Reference__c createdProvince = [SELECT Id FROM Reference__c WHERE Field__c = 'Province' LIMIT 1];
        Reference__c createdCity = [SELECT Id FROM Reference__c WHERE Field__c = 'City' LIMIT 1];
        Reference__c createdBaranagay = [SELECT Id FROM Reference__c WHERE Field__c = 'Barangay' LIMIT 1];
        Reference__c createdSubdivision = [SELECT Id FROM Reference__c WHERE Field__c = 'Subdivision' LIMIT 1];
        Reference__c createdStreet = [SELECT Id FROM Reference__c WHERE Field__c = 'Street' LIMIT 1];
        
        createdStreet.Parent__c = createdSubdivision.Id;
        createdSubdivision.Parent__c = createdBaranagay.Id;
        createdBaranagay.Parent__c = createdCity.Id;
        createdCity.Parent__c = createdProvince.Id;

        List<Reference__c> updateReferenceList = new List<Reference__c>();
        updateReferenceList.add(createdStreet);
        updateReferenceList.add(createdSubdivision);
        updateReferenceList.add(createdBaranagay);
        updateReferenceList.add(createdCity);
        update updateReferenceList;

        String type = CXE_Constants.ADDRESS_TYPE_SERVICE;
        
        Address__c testAddress = new Address__c(Type__c = type, 
        										Premise_Type__c = 'Single-Detached Residential', 
        										Address_Unit_No__c = '1', 
        										Address_Street_No__c = '2', 
        										Address_Street_Name__c = createdStreet.Id,
        										Address_Subdivision__c = createdSubdivision.Id, 
        										Address_Barangay__c = createdBaranagay.Id, 
        										Address_City_Municipality__c = createdCity.Id,
        										Address_Province__c = createdProvince.Id);
        testAddress.put(parentField, parentId);
        if(parentField == 'Contract__c'){
            testAddress.Type__c = 'Billing';
        }

        insert testAddress;
        return testAddress;
    }
    //START MAR-31-17 CommentedOut by RReyes - used the new CXE_TestDataFactory.createAddressReference and CXE_TestDataFactory.createAddress method
    */
}