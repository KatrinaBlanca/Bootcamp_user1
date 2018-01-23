@isTest
private class CXE_BillDepositUtility_Test
{
	@testSetup static void setUp() {
        // create References
        List<Reference__c> reference = new List<Reference__c>();

        Reference__c r1 = new Reference__c(
        	Name = '216 V',
	        Name_Code__c = 'CTENS00106',
	        Field__c = CXE_Constants.REFERENCE_FIELD_VOLTAGE
        );

        Reference__c r2 = new Reference__c(
        	Name = '69/39 kV',
	        Name_Code__c = 'CTENS00100',
	        Field__c = CXE_Constants.REFERENCE_FIELD_VOLTAGE
        );

        Reference__c r3 = new Reference__c(
        	Name = '115/66 kV',
	        Name_Code__c = 'CTENS00101',
	        Field__c = CXE_Constants.REFERENCE_FIELD_VOLTAGE
        );

        Reference__c r4 = new Reference__c(
        	Name = '6.24/3.60 kV',
	        Name_Code__c = 'CTENS00102',
	        Field__c = CXE_Constants.REFERENCE_FIELD_VOLTAGE
        );

        Reference__c r5 = new Reference__c(
        	Name = '13.2/7.62 kV',
	        Name_Code__c = 'CTENS00103',
	        Field__c = CXE_Constants.REFERENCE_FIELD_VOLTAGE
        );

        reference.add(r1);
        reference.add(r2);
        reference.add(r3);
        reference.add(r4);
        reference.add(r5);

        insert reference;
       
        

    }

	@isTest
	static void withRateListGSA()
	{
		Set<Id> caseId = new Set<Id>();
		Set<String> cityName = new Set<String>{'ALAMINOS'};
		Map<Id, CXE_BillDepositWrapper> getCalculatorMap = new Map<Id, CXE_BillDepositWrapper>();
		Map<String, String> voltageMap = new Map<String, String>();

		Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();		
        
        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        insert acc;

        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.AccountId = acc.Id;
        caseRecord.PSIC__c = psicRecord.Id;
        insert caseRecord;

        caseId.add(caseRecord.Id);

        getCalculatorMap = CXE_BillDepositUtility.getCalculationVariables(caseId);

        Rate__c createRate = CXE_TestDataFactory.createIntegrationSettings(1)[0];
        insert createRate;

        CXE_BillDepositUtility.getRate();

        LFT_TRAC_Table__c createLFT = CXE_TestDataFactory.createLFT_TRAC_Table();
        insert createLFT;

        CXE_BillDepositUtility.getLFTTRAC(cityName);

        CXE_BillDepositUtility.calculateRate(getCalculatorMap.values()[0], createRate, createLFT);

	}

	@isTest
	static void withRateListGSB()
	{
		Set<Id> caseId = new Set<Id>();
		Set<String> cityName = new Set<String>{'ALAMINOS'};
		Map<Id, CXE_BillDepositWrapper> getCalculatorMap = new Map<Id, CXE_BillDepositWrapper>();

		Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();		
        
        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        insert acc;

        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.AccountId = acc.Id;
        caseRecord.PSIC__c = psicRecord.Id;
        caseRecord.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_GSB;
        caseRecord.Applied_Load__c = 30;
        caseRecord.Service_Supply_Type__c = 'Normal with meter';
        insert caseRecord;

        caseId.add(caseRecord.Id);

        getCalculatorMap = CXE_BillDepositUtility.getCalculationVariables(caseId);

        Rate__c createRate = CXE_TestDataFactory.createIntegrationSettings(1)[0];
        insert createRate;

        CXE_BillDepositUtility.getRate();

        LFT_TRAC_Table__c createLFT = CXE_TestDataFactory.createLFT_TRAC_Table();
        insert createLFT;

        CXE_BillDepositUtility.getLFTTRAC(cityName);

        CXE_BillDepositUtility.calculateRate(getCalculatorMap.values()[0], createRate, createLFT);

	}

	@isTest
	static void withRateListGHMSCI()
	{
		Set<Id> caseId = new Set<Id>();
		Set<String> cityName = new Set<String>{'ALAMINOS'};
		Map<Id, CXE_BillDepositWrapper> getCalculatorMap = new Map<Id, CXE_BillDepositWrapper>();

		Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();		
        
        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        insert acc;

        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.AccountId = acc.Id;
        caseRecord.PSIC__c = psicRecord.Id;
        caseRecord.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_GHMSCI;
        caseRecord.Applied_Load__c = 30;
        caseRecord.Service_Supply_Type__c = 'Normal with meter';
        insert caseRecord;

        caseId.add(caseRecord.Id);

        getCalculatorMap = CXE_BillDepositUtility.getCalculationVariables(caseId);

        Rate__c createRate = CXE_TestDataFactory.createIntegrationSettings(1)[0];
        insert createRate;

        CXE_BillDepositUtility.getRate();

        LFT_TRAC_Table__c createLFT = CXE_TestDataFactory.createLFT_TRAC_Table();
        insert createLFT;

        CXE_BillDepositUtility.getLFTTRAC(cityName);

        CXE_BillDepositUtility.calculateRate(getCalculatorMap.values()[0], createRate, createLFT);

	}

	@isTest
	static void withRateListGPSmall()
	{
		Set<Id> caseId = new Set<Id>();
		Set<String> cityName = new Set<String>{'ALAMINOS'};
		Map<Id, CXE_BillDepositWrapper> getCalculatorMap = new Map<Id, CXE_BillDepositWrapper>();

		Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();		
        
        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        insert acc;

        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.AccountId = acc.Id;
        caseRecord.PSIC__c = psicRecord.Id;
        caseRecord.Service_Rate_Type__c = 'General Power (GP)';
        caseRecord.Applied_Load__c = 60;
        caseRecord.Service_Supply_Type__c = 'Streetlight with meter';
        insert caseRecord;

        caseId.add(caseRecord.Id);

        getCalculatorMap = CXE_BillDepositUtility.getCalculationVariables(caseId);

        Rate__c createRate = CXE_TestDataFactory.createIntegrationSettings(1)[0];
        insert createRate;

        CXE_BillDepositUtility.getRate();

        LFT_TRAC_Table__c createLFT = CXE_TestDataFactory.createLFT_TRAC_Table();
        insert createLFT;

        CXE_BillDepositUtility.getLFTTRAC(cityName);

        CXE_BillDepositUtility.calculateRate(getCalculatorMap.values()[0], createRate, createLFT);

	}

	@isTest
	static void withRateListGPLarge()
	{
		Set<Id> caseId = new Set<Id>();
		Set<String> cityName = new Set<String>{'ALAMINOS'};
		Map<Id, CXE_BillDepositWrapper> getCalculatorMap = new Map<Id, CXE_BillDepositWrapper>();

		Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();		
        
        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        insert acc;

        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.AccountId = acc.Id;
        caseRecord.PSIC__c = psicRecord.Id;
        caseRecord.Service_Rate_Type__c = 'General Power (GP)';
        caseRecord.Applied_Load__c = 500;
        caseRecord.Service_Supply_Type__c = 'Streetlight with meter';
        insert caseRecord;

        caseId.add(caseRecord.Id);

        getCalculatorMap = CXE_BillDepositUtility.getCalculationVariables(caseId);

        Rate__c createRate = CXE_TestDataFactory.createIntegrationSettings(1)[0];
        insert createRate;

        CXE_BillDepositUtility.getRate();

        LFT_TRAC_Table__c createLFT = CXE_TestDataFactory.createLFT_TRAC_Table();
        insert createLFT;

        CXE_BillDepositUtility.getLFTTRAC(cityName);

        CXE_BillDepositUtility.calculateRate(getCalculatorMap.values()[0], createRate, createLFT);

	}

	@isTest
	static void withRateListGPExLarge()
	{
		Set<Id> caseId = new Set<Id>();
		Set<String> cityName = new Set<String>{'ALAMINOS'};
		Map<Id, CXE_BillDepositWrapper> getCalculatorMap = new Map<Id, CXE_BillDepositWrapper>();

		Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();		
        
        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        insert acc;

        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.AccountId = acc.Id;
        caseRecord.PSIC__c = psicRecord.Id;
        caseRecord.Service_Rate_Type__c = 'General Power (GP)';
        caseRecord.Applied_Load__c = 1000;
        caseRecord.Service_Supply_Type__c = 'Streetlight with meter';
        insert caseRecord;

        caseId.add(caseRecord.Id);

        getCalculatorMap = CXE_BillDepositUtility.getCalculationVariables(caseId);

        Rate__c createRate = CXE_TestDataFactory.createIntegrationSettings(1)[0];
        insert createRate;

        CXE_BillDepositUtility.getRate();

        LFT_TRAC_Table__c createLFT = CXE_TestDataFactory.createLFT_TRAC_Table();
        insert createLFT;

        CXE_BillDepositUtility.getLFTTRAC(cityName);

        CXE_BillDepositUtility.calculateRate(getCalculatorMap.values()[0], createRate, createLFT);

	}

	@isTest
	static void withoutRateList()
	{
		Set<Id> caseId = new Set<Id>();
		Map<Id, CXE_BillDepositWrapper> getCalculatorMap = new Map<Id, CXE_BillDepositWrapper>();

		Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();		
        
        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        insert acc;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.AccountId = acc.Id;
        insert caseRecord;

        caseId.add(caseRecord.Id);

        getCalculatorMap = CXE_BillDepositUtility.getCalculationVariables(caseId);

        CXE_BillDepositUtility.getRate();
	}
}