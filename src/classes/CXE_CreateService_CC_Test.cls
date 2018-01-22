/* Description: CXE_CreateService_CC test class
 * Author: Michael Lasala
 * Date Created: MAR-08-17
 */
 @isTest
 public class CXE_CreateService_CC_Test {
	
    //Get service picklist values
    static testMethod void picklistValuesTest(){
        
        Test.StartTest();
        	Map<String, List<String>> testPicklistValues = CXE_CreateService_CC.getServicePicklistValues();
        Test.StopTest();
		
        //-1 for actual results (--None-- value)
        System.assertEquals(Agreement__c.Phase__c.getDescribe().getPicklistValues().size(), testPicklistValues.get('Phase__c').size()-1);
        System.assertEquals(Agreement__c.Service_Wire_Type__c.getDescribe().getPicklistValues().size(), testPicklistValues.get('Service_Wire_Type__c').size()-1);
        System.assertEquals(Agreement__c.Voltage_Level__c.getDescribe().getPicklistValues().size(), testPicklistValues.get('Voltage_Level__c').size()-1);
    }
         
 	//Get contract details
    static testMethod void contractTest(){
		
		Contract testContract = createContract();
		
        //Test.StartTest();
        Contract contractRecord = CXE_CreateService_CC.getContract(testContract.Id);
        //Test.StopTest();
		
		Contract createdContract = [SELECT Id, Case__c, AccountId FROM Contract WHERE Id =: testContract.Id LIMIT 1];
		
        System.assertEquals(createdContract.Id, contractRecord.Id);
		System.assertEquals(createdContract.AccountId, contractRecord.AccountId);
		System.assertEquals(createdContract.Case__c, contractRecord.Case__c);
    }
    
    //Get psic
    static testMethod void psicTest(){
		List<PSIC__c> testPSIC = CXE_TestDataFactory.createPSIC(1);
        insert testPSIC;
		
        Test.StartTest();
        	PSIC__c psic = CXE_CreateService_CC.getPSIC(testPSIC.get(0).Id);
        Test.StopTest();
		
		PSIC__c createdPSIC = [SELECT Id, Name FROM PSIC__c WHERE Id =: psic.Id];
        
		System.assertEquals(createdPSIC.Id, psic.Id);
		System.assertEquals(createdPSIC.Name, psic.Name);
    }
    
	//Save service
    static testMethod void saveTest(){
        
		List<PSIC__c> testPSIC = CXE_TestDataFactory.createPSIC(1);
        insert testPSIC;
		
		/*Contract testContract = createContract();
	
		Account testAccount = [SELECT Id FROM Account LIMIT 1];
		Case testCase = [SELECT Id FROM Case LIMIT 1];
		
		Address__c testAddress = new Address__c(Case__c = testCase.Id, 
												Premise_Type__c = 'Billboard',
												Account__c = testAccount.Id,
												Type__c = 'Service');
		insert testAddress;
		*/

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
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
		Agreement__c testService = new Agreement__c(Case__c = testCase.Id, 
												    Contract__c = testContract.Id, 
												    Account__c = testAccount.Id, 
												    PSIC__c = testPSIC.get(0).Id, 
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
        Test.StartTest();
        	String service = CXE_CreateService_CC.saveService(testService);
        Test.StopTest();

        System.assertEquals('Success', service);
    }
    
    //Validate Required Case Values
    static testMethod void validateRequiredCaseValuesTest(){
        Contract contr = createContractWithCaseNoRequiredFields();
        //Test.StartTest();
        	String errorMsg = CXE_CreateService_CC.validateRequiredCaseValues(contr);
        //Test.StopTest();
		
        // errorMsg should not be blank
        System.assertNotEquals(errorMsg, '');
    }
    
    //get Voltage
    static testMethod void voltageTest(){
        Reference__c refRec1 =  new Reference__c ();
        refRec1.Field__c = 'Voltage';
	    refRec1.Name_Code__c = '0213011281117';
        refRec1.Name ='serviceSupplyVoltage';
        
        Reference__c refRec2 =  new Reference__c ();
        refRec2.Field__c = 'Voltage Level';
	    refRec2.Name_Code__c = '0213011281117';
        refRec2.Name ='serviceSupplyVoltageLevel';
        
        List<Reference__c> refList = new List<Reference__c>();
        refList.add(refRec1);
        refList.add(refRec2);
        
        insert refList;
                                                   
        Test.StartTest();
        	Reference__c ref = CXE_CreateService_CC.getVoltage('serviceSupplyVoltage');
        Test.StopTest();
		
        // ref should not be null
        System.assertNotEquals(null,ref);
    }
    
    //get Account
    static testMethod void getAccountTest(){
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
                                                   
        Test.StartTest();
        	Account acct = CXE_CreateService_CC.getAccount(testAccount.Id);
        Test.StopTest();
		
        // acct should not be null
        System.assertNotEquals(null,acct);
    }
    /*START CommentedOut: Melvin Corbes July-13-2017
    //Validate related Billing Address - validateIfContractHasBillingAddress()
    static testMethod void validateRelatedBillingAddress(){

        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;

        List<Contract> testContractList = CXE_TestDataFactory.createContract(1, testAccount.Id, null);
        Contract testContract = testContractList.get(0);
        insert testContract;

    	//Address__c testAddress = createAddress('Billing');
        Address__c testAddress = createBillingAddress();
    	testAddress.Contract__c = testContract.Id;
    	insert testAddress;
    	
        Test.StartTest();
            Boolean isValid = CXE_CreateService_CC.validateIfContractHasBillingAddress(testContract.Id);
        Test.StopTest();
		
        //test data should be valid
        System.assert(isValid);
    }
    
    //Validate related Service Address - validateIfAccountHasServiceAddress()
    static testMethod void validateRelatedServiceAddress(){
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;

        List<Contract> testContractList = CXE_TestDataFactory.createContract(1, testAccount.Id, null);
        Contract testContract = testContractList.get(0);
        insert testContract;

    	//Address__c testAddress = createAddress('Service');
        Address__c testAddress = createServiceAddress();
    	testAddress.Account__c = testAccount.Id;
    	insert testAddress;
    	
        Test.StartTest();
        	Boolean isValid = CXE_CreateService_CC.validateIfAccountHasServiceAddress(testAccount.Id);
        Test.StopTest();
		
        //test data should be valid
        System.assert(isValid);
    }
	*/ //END CommentedOut: Melvin Corbes July-13-2017   

    //Validate case with valid settings
    static testMethod void validateToCreateServiceTest(){   
        Contract testCont = createContract();
        //Test.StartTest();
        	String errMsg = CXE_CreateService_CC.isValidToCreateService(testCont.Id, 'Application Received', false, '195528957');
        //Test.StopTest();
		
        //Class should not return an errorMsg
        System.assertEquals(errMsg, '');
    }
    
    //Validate case with invalid status
    static testMethod void validateInvalidCaseStatusTest(){
        Contract testCont = createContract();
       
        //Test.StartTest();
        	String errMsg = CXE_CreateService_CC.isValidToCreateService(testCont.Id, 'Energized', false, '195528957');
        //Test.StopTest();
		
        //method should return an error message
        System.assertEquals(errMsg, CXE_Constants.CREATE_SERVICE_ERROR_MESSAGE_INVALID_CASE_STATUS);
    }

    //Validate single-meter case with one related service
    static testMethod void validateSingleMeterTest(){
        /*Contract testCont = createContract();
        
    	Address__c testAddress = createAddress('Service');
    	testAddress.Case__c = testCont.Case__c;
    	testAddress.Account__c = testCont.AccountId;
    	insert testAddress;
    	*/

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

        Test.StartTest();
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
            lstAddress.add(testAddress);
            lstAddress.add(testAddress2);
            insert lstAddress;

            List<Agreement__c> serviceList = CXE_TestDataFactory.createService(1, null,null,testContract.Id, null);
            insert serviceList;
    	
        
        	String errMsg = CXE_CreateService_CC.isValidToCreateService(testContract.Id, 'Application Received', false, '195528957');
        Test.StopTest();
		
        //method should return an error message
        System.assertEquals(errMsg, CXE_Constants.CREATE_SERVICE_ERROR_MESSAGE_SINGLE_METERED_VALIDATION);
    }
    
    //Validate multi-meter case with one related service and invalid status
    static testMethod void validateMultimeterInvalidStatusTest(){
        /*Contract testCont = createContract();

    	Address__c testAddress = createAddress('Service');
    	testAddress.Case__c = testCont.Case__c;
    	testAddress.Account__c = testCont.AccountId;
    	insert testAddress;
        */
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

        Test.StartTest();
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
            lstAddress.add(testAddress);
            lstAddress.add(testAddress2);
            insert lstAddress;

            List<Agreement__c> serviceList = CXE_TestDataFactory.createService(1, null,null,testContract.Id, null);
            insert serviceList;
        
        
        	String errMsg = CXE_CreateService_CC.isValidToCreateService(testContract.Id, 'Application Received', true, '195528957');
        Test.StopTest();
		
        //method should return an error message
        System.assertEquals(errMsg, CXE_Constants.CREATE_SERVICE_ERROR_MESSAGE_MULTI_METERED_VALIDATION);
    }
    
    //Validate multi-meter case with one related service, valid status, but no v10 Account number.
    static testMethod void validateMultimeterNoV10Test(){
        /*Contract testCont = createContract();  

    	Address__c testAddress = createAddress('Billing');
    	testAddress.Contract__c = testCont.Id;
    	insert testAddress; 
        */
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

        Test.StartTest();
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
            lstAddress.add(testAddress);
            lstAddress.add(testAddress2);
            insert lstAddress;

            List<Agreement__c> serviceList = CXE_TestDataFactory.createService(1, null,null,testContract.Id, null);
            insert serviceList;
        
        
        	String errMsg = CXE_CreateService_CC.isValidToCreateService(testContract.Id, 'Contract Finalized', true, '');
        Test.StopTest();
		
        //method should return an error message
        System.assertEquals(errMsg, CXE_Constants.CREATE_SERVICE_ERROR_MESSAGE_CONTRACT_WITHOUT_V10);
    }

    //relate address to service
    static testMethod void relateServiceAddressToServiceTest(){
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

        Test.StartTest();
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
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        

            Agreement__c testService = new Agreement__c(Case__c = testCase.Id, 
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
    		insert testService;
    												    
        
            CXE_CreateService_CC.relateServiceAddressToService(testService.Id);
            Integer addressCount = [SELECT COUNT() FROM Address__c 
                WHERE Account__r.Id =: testAccount.Id AND Case__r.Id =: testCase.Id AND Service__r.Id =: testService.Id AND Type__c = 'Service'];
        Test.StopTest();
        
        System.assert(addressCount > 0);
    }

	//private static Contract createContract(){
	static testMethod Contract createContract(){	
		List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
		
		Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
		
		List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service' , 'Single-meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.Application_for_Business_Service__c = true;
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
		testCase.AccountId = testAccount.Id;
		testCase.Tax_Identification_No__c = '11111';
        insert testCase;
		
		testCase.Status = 'Application Evaluated';
        update testCase;
        
        testCase.Status = 'Meter Socket Issued';
        update testCase;
        
        Test.StartTest();
            Id inspectionFORecordTypeId = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_INSPECTION_FO).getRecordTypeId();
            
            List<Field_Order__c> testFieldOrderList = CXE_TestDataFactory.createFieldOrder(1);
            Field_Order__c testFieldOrder = testFieldOrderList.get(0);
            testFieldOrder.RecordTypeId = inspectionFORecordTypeId;
            testFieldOrder.Case__c = testCase.Id;
            testFieldOrder.Status__c = 'Generated';
            insert testFieldOrder;
            
    		Contract testContract = new Contract(AccountId = testAccount.Id, 
    											 Case__c = testCase.Id, 
                                                 Method_of_Payment__c = 'ADA (Bank)',
            									 Type__c = 'Regular');
    		
    		insert testContract;
        Test.StopTest();
		return testContract;
	}
	
	//private static Contract createContractWithCaseNoRequiredFields(){
	static testMethod Contract createContractWithCaseNoRequiredFields(){	
		List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
		
		Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
		
		List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.Application_for_Business_Service__c = true;
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
		testCase.AccountId = testAccount.Id;
		testCase.Tax_Identification_No__c = '11111';
		testCase.Pole_Code__c = null;
        testCase.Service_Wire_Type__c = null;
        testCase.Service_Wire_Length__c = null;
        testCase.Wire_Size__c = null;
        testCase.Material__c = null;
        testCase.Service_Rate_Type__c = null;
        testCase.Billing_Class__c = null;
        testCase.Applied_Load__c = null;
        testCase.Phase__c = null;
        testCase.Voltage__c = null;
        testCase.PSIC__c = null;
        testCase.Demand_Factor__c = null;
        testCase.Load_Factor__c = null;
        testCase.Contracted_Capacity__c = null;
        testCase.Service_Supply_Type__c = null;
        insert testCase;
		
		testCase.Status = 'Application Evaluated';
        update testCase;
        
        testCase.Status = 'Meter Socket Issued';
        update testCase;
        
        test.startTest();
            Id inspectionFORecordTypeId = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_INSPECTION_FO).getRecordTypeId();
            
            List<Field_Order__c> testFieldOrderList = CXE_TestDataFactory.createFieldOrder(1);
            Field_Order__c testFieldOrder = testFieldOrderList.get(0);
            testFieldOrder.RecordTypeId = inspectionFORecordTypeId;
            testFieldOrder.Case__c = testCase.Id;
            testFieldOrder.Status__c = 'Generated';
            insert testFieldOrder;
            
    		Contract testContract = new Contract(AccountId = testAccount.Id, 
    											 Case__c = testCase.Id, 
                                                 Method_of_Payment__c = 'ADA (Bank)',
            									 Type__c = 'Regular');
    		
    		insert testContract;
        test.stopTest();
		return testContract;
	}
	
	/*private static Address__c createAddress(string addressType){
    //static testMethod Address__c createAddress(string addressType){
		List<Reference__c> refList = CXE_TestDataFactory.createSampleReferenceListForAddress();
		insert refList;
		
		Reference__c createdProvince; //= [SELECT Id FROM Reference__c WHERE Field__c = 'Province' LIMIT 1];
        Reference__c createdCity; //= [SELECT Id FROM Reference__c WHERE Field__c = 'City' LIMIT 1];
        Reference__c createdBarangay; // = [SELECT Id FROM Reference__c WHERE Field__c = 'Barangay' LIMIT 1];
        Reference__c createdSubdivision; //= [SELECT Id FROM Reference__c WHERE Field__c = 'Subdivision' LIMIT 1];
        Reference__c createdStreet; // = [SELECT Id FROM Reference__c WHERE Field__c = 'Street' LIMIT 1];
        
        for(Reference__c ref : refList){
            if(ref.Field__c == 'Province'){
                createdProvince = ref;
            }else if(ref.Field__c == 'City'){
                createdCity = ref;
            }else if(ref.Field__c == 'Barangay'){
                createdBarangay = ref;
            }else if(ref.Field__c == 'Subdivision'){
                createdSubdivision = ref;
            }else if(ref.Field__c == 'Street'){
                createdStreet = ref;
            }            
        }
        
        createdStreet.Parent__c = createdSubdivision.Id;
        createdSubdivision.Parent__c = createdBarangay.Id;
        createdBarangay.Parent__c = createdCity.Id;
        createdCity.Parent__c = createdProvince.Id;

        List<Reference__c> updateReferenceList = new List<Reference__c>();
        updateReferenceList.add(createdStreet);
        updateReferenceList.add(createdSubdivision);
        updateReferenceList.add(createdBarangay);
        updateReferenceList.add(createdCity);
        update updateReferenceList;

        Address__c testAddress = new Address__c(Type__c = addressType, 
        										Premise_Type__c = 'Single-Detached Residential', 
        										Address_Unit_No__c = '1', 
        										Address_Street_No__c = '2', 
        										Address_Street_Name__c = createdStreet.Id,
        										Address_Subdivision__c = createdSubdivision.Id, 
        										Address_Barangay__c = createdBarangay.Id, 
        										Address_City_Municipality__c = createdCity.Id,
        										Address_Province__c = createdProvince.Id);
        //testAddress.put(parentField, parentId);
        //insert testAddress;
        return testAddress;
	}*/

    /* Description: Create Service Address
     * Author: Jerson Poblete
     * Date Created: MAR-31-17
     */
    static testMethod Address__c createServiceAddress(){
        List<Reference__c> refList = CXE_TestDataFactory.createSampleReferenceListForAddress();
        insert refList;
        
        Reference__c createdProvince; //= [SELECT Id FROM Reference__c WHERE Field__c = 'Province' LIMIT 1];
        Reference__c createdCity; //= [SELECT Id FROM Reference__c WHERE Field__c = 'City' LIMIT 1];
        Reference__c createdBarangay; // = [SELECT Id FROM Reference__c WHERE Field__c = 'Barangay' LIMIT 1];
        Reference__c createdSubdivision; //= [SELECT Id FROM Reference__c WHERE Field__c = 'Subdivision' LIMIT 1];
        Reference__c createdStreet; // = [SELECT Id FROM Reference__c WHERE Field__c = 'Street' LIMIT 1];
        
        for(Reference__c ref : refList){
            if(ref.Field__c == 'Province'){
                createdProvince = ref;
            }else if(ref.Field__c == 'City'){
                createdCity = ref;
            }else if(ref.Field__c == 'Barangay'){
                createdBarangay = ref;
            }else if(ref.Field__c == 'Subdivision'){
                createdSubdivision = ref;
            }else if(ref.Field__c == 'Street'){
                createdStreet = ref;
            }            
        }
        
        createdStreet.Parent__c = createdSubdivision.Id;
        createdSubdivision.Parent__c = createdBarangay.Id;
        createdBarangay.Parent__c = createdCity.Id;
        createdCity.Parent__c = createdProvince.Id;

        List<Reference__c> updateReferenceList = new List<Reference__c>();
        updateReferenceList.add(createdStreet);
        updateReferenceList.add(createdSubdivision);
        updateReferenceList.add(createdBarangay);
        updateReferenceList.add(createdCity);
        update updateReferenceList;

        Address__c testAddress = new Address__c(Type__c = 'Service', 
                                                Premise_Type__c = 'Single-Detached Residential', 
                                                Address_Unit_No__c = '1', 
                                                Address_Street_No__c = '2', 
                                                Address_Street_Name__c = createdStreet.Id,
                                                Address_Subdivision__c = createdSubdivision.Id, 
                                                Address_Barangay__c = createdBarangay.Id, 
                                                Address_City_Municipality__c = createdCity.Id,
                                                Address_Province__c = createdProvince.Id);
        //testAddress.put(parentField, parentId);
        //insert testAddress;
        return testAddress;
    }
    static testMethod Address__c createBillingAddress(){
        List<Reference__c> refList = CXE_TestDataFactory.createSampleReferenceListForAddress();
        insert refList;
        
        Reference__c createdProvince; //= [SELECT Id FROM Reference__c WHERE Field__c = 'Province' LIMIT 1];
        Reference__c createdCity; //= [SELECT Id FROM Reference__c WHERE Field__c = 'City' LIMIT 1];
        Reference__c createdBarangay; // = [SELECT Id FROM Reference__c WHERE Field__c = 'Barangay' LIMIT 1];
        Reference__c createdSubdivision; //= [SELECT Id FROM Reference__c WHERE Field__c = 'Subdivision' LIMIT 1];
        Reference__c createdStreet; // = [SELECT Id FROM Reference__c WHERE Field__c = 'Street' LIMIT 1];
        
        for(Reference__c ref : refList){
            if(ref.Field__c == 'Province'){
                createdProvince = ref;
            }else if(ref.Field__c == 'City'){
                createdCity = ref;
            }else if(ref.Field__c == 'Barangay'){
                createdBarangay = ref;
            }else if(ref.Field__c == 'Subdivision'){
                createdSubdivision = ref;
            }else if(ref.Field__c == 'Street'){
                createdStreet = ref;
            }            
        }
        
        createdStreet.Parent__c = createdSubdivision.Id;
        createdSubdivision.Parent__c = createdBarangay.Id;
        createdBarangay.Parent__c = createdCity.Id;
        createdCity.Parent__c = createdProvince.Id;

        List<Reference__c> updateReferenceList = new List<Reference__c>();
        updateReferenceList.add(createdStreet);
        updateReferenceList.add(createdSubdivision);
        updateReferenceList.add(createdBarangay);
        updateReferenceList.add(createdCity);
        update updateReferenceList;

        Address__c testAddress = new Address__c(Type__c = 'Billing', 
                                                Premise_Type__c = 'Single-Detached Residential', 
                                                Address_Unit_No__c = '1', 
                                                Address_Street_No__c = '2', 
                                                Address_Street_Name__c = createdStreet.Id,
                                                Address_Subdivision__c = createdSubdivision.Id, 
                                                Address_Barangay__c = createdBarangay.Id, 
                                                Address_City_Municipality__c = createdCity.Id,
                                                Address_Province__c = createdProvince.Id);
        //testAddress.put(parentField, parentId);
        //insert testAddress;
        return testAddress;
    }
     //START MELVIN CORBES JULY-13-2017
     
     static testMethod void saveErrorService(){

            Agreement__c testService = new Agreement__c(Case__c = null, 
                                                    Contract__c = null, 
                                                    Account__c = null, 
                                                    PSIC__c = null, 
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

            Test.startTest();

            String service = CXE_CreateService_CC.saveService(testService);

            Test.stopTest();

            System.assertNotEquals('Success',service);

    }


     static testMethod void validateIfContractHasBillingAddressTest(){

        // create a contract with a Billing Address

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
         
         Address__c testAddress = new Address__c(Type__c = 'Billing', 
                                                Account__c = testAccount.Id,
                                                Case__c = testCase.Id,
                                                Contract__c = testContract.Id,
                                                Address_Street_No__c = '1');
         
         
        Address__c testAddress2 = new Address__c(Type__c = 'Service', 
                                                Account__c = testAccount.Id,
                                                Case__c = testCase.Id,
                                                Premise_Type__c = 'Single-Detached Residential',
                                                Address_Street_No__c = '1');
         
         
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
               
        insert lstAddress;


        Test.startTest();
         
        Boolean  resultValueBill =CXE_CreateService_CC.validateIfContractHasBillingAddress(testContract.Id);
        Boolean  resultValueService =CXE_CreateService_CC.validateIfAccountHasServiceAddress(testAccount.Id);

        Test.stopTest();

        System.assert(True,resultValueBill);
        System.assert(True,resultValueService);
        
    }

     
     
     
     
     //END MELVIN CORBES JULY-13-2017
     
     
     
}