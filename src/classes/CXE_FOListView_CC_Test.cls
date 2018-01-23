@isTest
private class CXE_FOListView_CC_Test
{
	static testMethod void testgetInspectionFO(){

        Id recontractCaseRType = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_RECONTRACT_OF_ELECTRIC_SERVICE).getRecordTypeId();        
        Id inspectionFORType = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_INSPECTION_FO).getRecordTypeId();
        List<Account> listAccount = new List<Account>();

        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        listAccount.add(acc);
        
        Account ExecutingPersonelAcc = CXE_TestDataFactory.createExecutingPersonel(1)[0];
        listAccount.add(ExecutingPersonelAcc);
        insert listAccount;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_MS_ISSUED, 'Private')[0];
        caseRecord.RecordTypeID = recontractCaseRType;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.AccountId = acc.Id;
        insert caseRecord;

        

        Field_Order__c foRecord = new Field_Order__c();
        foRecord.RecordTypeId = inspectionFORType;
        foRecord.Case__c = caseRecord.Id;
        foRecord.Inspection_Instructions__c = 'Sample Instructions';
        insert foRecord;
   		
   		Test.startTest();
        
        CXE_FOListView_CC.Response res = new CXE_FOListView_CC.Response();
        res = CXE_FOListView_CC.getFieldOrders();
        
        System.assertequals(res.Status, 'SUCCESS');

        Test.stopTest();  
    }

    static testMethod void testgetSurveyFO(){

        Id recontractCaseRType = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_RECONTRACT_OF_ELECTRIC_SERVICE).getRecordTypeId();        
        Id presurveyFORType = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_SURVEY_FO).getRecordTypeId();
        List<Account> listAccount = new List<Account>();

        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        listAccount.add(acc);
        
        Account ExecutingPersonelAcc = CXE_TestDataFactory.createExecutingPersonel(1)[0];
        listAccount.add(ExecutingPersonelAcc);
        insert listAccount;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_PRE_SURVEY_FO_NOTFEASIBLE, 'Private')[0];
        caseRecord.RecordTypeID = recontractCaseRType;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.AccountId = acc.Id;
        insert caseRecord;

        Test.startTest();

        Field_Order__c foRecord = new Field_Order__c();
        foRecord.RecordTypeId = presurveyFORType;
        foRecord.Case__c = caseRecord.Id;
        foRecord.Survey_Instructions__c = 'Sample Instructions';
        insert foRecord;
   
        CXE_FOListView_CC.Response res = new CXE_FOListView_CC.Response();
        res = CXE_FOListView_CC.getFieldOrders();

        System.assertequals(res.Status, 'SUCCESS');
        Test.stopTest();  
    }


    static testMethod void testgetMeterSocketFO(){

        Id recontractCaseRType = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_RECONTRACT_OF_ELECTRIC_SERVICE).getRecordTypeId();        
        Id meterSocketFORType = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_MeterSocket_FO).getRecordTypeId();
        List<Account> listAccount = new List<Account>();

        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        listAccount.add(acc);
        
        Account ExecutingPersonelAcc = CXE_TestDataFactory.createExecutingPersonel(1)[0];
        listAccount.add(ExecutingPersonelAcc);
        insert listAccount;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Meter Socket Not Delivered', 'Private')[0];
        caseRecord.RecordTypeID = recontractCaseRType;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.AccountId = acc.Id;
        caseRecord.Meter_Socket_Delivery_Tag__c = true;
        caseRecord.Delivery_Address__c = 'test Address';

        insert caseRecord;

        Test.startTest();

        Field_Order__c foRecord = new Field_Order__c();
        foRecord.RecordTypeId = meterSocketFORType;
        foRecord.Case__c = caseRecord.Id;
        insert foRecord;
   
        foRecord.Schedule_Date__c = System.today();
        update foRecord;

        CXE_FOListView_CC.Response res = new CXE_FOListView_CC.Response();
        res = CXE_FOListView_CC.getFieldOrders();

        System.assertequals(res.Status, 'SUCCESS');
        Test.stopTest();  
    }
}