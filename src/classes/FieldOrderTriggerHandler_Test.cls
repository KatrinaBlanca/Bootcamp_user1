/* Description: FieldOrderTriggerHandler test class
 * Author: Christian Peter Doctolero
 * Date Created: MAR-21-17
 */
@isTest
private class FieldOrderTriggerHandler_Test 
{
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

    static testMethod void insertFoRecord()
    {  
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_RECONTRACT_OF_ELECTRIC_SERVICE).getRecordTypeId();     
        
        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        insert acc;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_MS_ISSUED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.AccountId = acc.Id;
        insert caseRecord;

        Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
        for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
            addressReference.put(addRef.Field__c, addRef);
        } 

        Test.startTest();
            
            Id foRecTypeId = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_INSPECTION_FO).getRecordTypeId();
            
            Field_Order__c foRecord = CXE_TestDataFactory.createFieldOrder(1)[0];
            foRecord.RecordTypeId = foRecTypeId;
            foRecord.Case__c = caseRecord.Id;
            insert foRecord;
            foRecord.Inspection_Instructions__c = 'Sample Instruction';
            System.assertEquals('Sample Instruction', foRecord.Inspection_Instructions__c);
            update foRecord;
            delete foRecord;
            undelete foRecord;
        Test.stopTest();   
    }

    static testMethod void testUdateSAwithResolutionRemark()
    {  
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_RECONTRACT_OF_ELECTRIC_SERVICE).getRecordTypeId();        
        
        List<Account> listAccount = new List<Account>();

        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        listAccount.add(acc);
        
        Account ExecutingPersonelAcc = CXE_TestDataFactory.createExecutingPersonel(1)[0];
        listAccount.add(ExecutingPersonelAcc);
        insert listAccount;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_MS_ISSUED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.AccountId = acc.Id;
        insert caseRecord;
     
        
     
            Id foRecTypeId = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_INSPECTION_FO).getRecordTypeId();
           
            Field_Order__c foRecord = new Field_Order__c();
            foRecord.RecordTypeId = foRecTypeId;
            foRecord.Case__c = caseRecord.Id;
            foRecord.Inspection_Instructions__c = 'Sample Instructions';
            insert foRecord;
            
        Test.startTest();
            foRecord.Schedule_Date__c = System.today();
            update foRecord;
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
        Test.stopTest();

        System.assertEquals(foRecord.Resolution_Remarks__c, caseRecord.Re_Inspection_FO_Resolution_Remarks__c);
        
    }
}