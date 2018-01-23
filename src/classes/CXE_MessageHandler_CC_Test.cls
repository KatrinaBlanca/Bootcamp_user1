@isTest
private class CXE_MessageHandler_CC_Test {
    
    static testMethod void CreateCase() {  
        
        test.startTest();
        
        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        insert acc;
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        Office__c office = CXE_TestDataFactory.createOffice(1)[0];
        insert office;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.PSIC__c = psicRecord.id;
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.AccountId = acc.id;
        caseRecord.Applied_Load__c = 6;
        caseRecord.Billing_Class__c = 'billing';
        caseRecord.Responsible_Office_Lookup__c = office.id;
        caseRecord.Customer_Type__c = 'Private';
        caseRecord.Phase__c = 'Single Phase (1Ø), Network';
        caseRecord.Voltage__c = '230 V';
        caseRecord.Application_Type_Subtype__c = 'New Electric Service';
        caseRecord.Demand_Factor__c = 10;
        caseRecord.Load_Factor__c = 5 ;
        caseRecord.Contracted_Capacity__c = 10;
        caseRecord.Service_Supply_Type__c = 'service';
        caseRecord.Project_Type__c = 'project Type';
        caseRecord.Service_Rate_Type__c = 'service rate';
        caseRecord.Deposit_Amount__c = 100;
        caseRecord.Telephone_No__c = '+6312312340';
        caseRecord.Mobile_No__c = '+631324358765';
        caseRecord.Application_for_Business_Service__c = true;
        caseRecord.CXE_Existing_Bill_Deposit_Amount__c = 0;
      
        
        insert caseRecord;
        
         CXE_MessageHandler_CC.getCaseDetails(caseRecord.Id);
	
        test.stopTest();
    }

}