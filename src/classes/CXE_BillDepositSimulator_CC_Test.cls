/* Description: CXE_BillDepositSimulator_CC test class
 * Author: Michael Lasala
 * Date Created: MAR-13-17
 * Updated :
 *			Jerome To 		MAY-29-17		start test class coverage
 */
@isTest
public class CXE_BillDepositSimulator_CC_Test {

 	@testSetup static void setUp() {
		// create Rate
		Rate__c rateRecord = CXE_TestDataFactory.createRate();
		insert rateRecord;
		// create Address Reference
		List<Reference__c> addressRefList = CXE_TestDataFactory.createSampleReferenceListForAddress();
        insert addressRefList;
        for(Integer i=0 ; i<addressRefList.size() ; i++) {
            if(i>0){
                addressRefList.get(i).Parent__c = addressRefList.get(i-1).Id;
            }
        }
        update addressRefList;      

	}

    static testMethod void billDepositTest() {        
        Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
        for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
            addressReference.put(addRef.Field__c, addRef);
        }  

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
        
        insert caseRecord;
        
        test.startTest();

        Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
        addressRec.Case__c = caseRecord.Id;
        addressRec.Type__c = 'Service';
        insert addressRec;

        Address__c addressRec2 = CXE_TestDataFactory.createAddress(addressReference, true);
        addressRec2.Case__c = caseRecord.Id;
        addressRec2.Type__c = 'Billing';
        insert addressRec2;

        Field_Order__c fo = CXE_TestDataFactory.createFieldOrder(1)[0];
        fo.Case__c = caseRecord.Id;
        insert fo;
        
        
        caseRecord.Status = CXE_Constants.CASE_PRE_SURVEY_FO_FEASIBLE;
        caseRecord.Load_Factor__c = 4 ;
        
        update caseRecord;      
 
        CXE_BillDepositSimulator_CC.validateBillDeposit(caseRecord.Id);
        CXE_BillDepositSimulator_CC.simulateBillDeposit(caseRecord.Id);
        CXE_BillDepositSimulator_CC.getServiceRateTypes();
        CXE_BillDepositSimulator_CC.calculateBillDeposit(caseRecord.Id , True, 'localFranchiseTax', 'lifelineDiscount', 'lifelineSubsidy', 'scSubsidy', 'energyTax', 'zeroRated');
       	
        String mockJSON = 'MockJSON';
        String myJSON = JSON.serialize(mockJSON);
        
        CXE_BillDepositWrapper bdw = new CXE_BillDepositWrapper();
        String bdwJSON = JSON.serialize(bdw);
        CXE_BillDepositSimulator_CC.reCalculateBillDeposit(bdwJSON);
        test.stopTest(); 
        
    }
}