@isTest
public class CXE_FileController_Test {

    @testSetup static void setUp() {
    
        Rate__c rateRecord = CXE_TestDataFactory.createRate();
        insert rateRecord;
        
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

        Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
            addressRec.Case__c = caseRecord.Id;
            addressRec.Type__c = 'Service';
        insert addressRec;

        Address__c addressRec2 = CXE_TestDataFactory.createAddress(addressReference, true);
            addressRec2.Case__c = caseRecord.Id;
            addressRec2.Type__c = 'Billing';
        insert addressRec2;

    }
    
    static testMethod void saveTheFile(){
        Case caseId = [SELECT Id FROM Case LIMIT 1][0]; 
        Id parId = caseId.Id;

        test.startTest();
          Id newRec = CXE_FileController.saveTheFile(parId, 'testFileName', 'testBase64Data', 'testContent');
        test.stopTest();
        
        System.assertEquals(caseId.Id, parId);
        System.debug('newRec Id: ==================>'+ newRec);
        System.assertEquals(false, string.isEmpty(newRec));
    }
    
    static testMethod void saveTheChunkFileIdNull(){
        Case caseId = [SELECT id FROM Case LIMIT 1][0]; 
        Id parId = caseId.Id;

        test.startTest();
          Id newRec = CXE_FileController.saveTheChunk(parId, 'testFileName', 'testBase64Data', 'testContent', null);
        test.stopTest();
        
        System.assertEquals(caseId.Id, parId);
        System.assertEquals(false, string.isEmpty(newRec));
        System.debug('newRec Id: ==================>'+ newRec);
    }
    
    static testMethod void saveTheChunkFile(){
        Case caseId = [SELECT Id FROM Case LIMIT 1][0]; 
        Id parId = caseId.Id;

        test.startTest();
          Attachment a = new Attachment();
                a.parentId = parId;
                a.Body = EncodingUtil.base64Decode('base64Data');
                a.Name = 'fileName';
                a.ContentType = 'contentType';
                a.IsPrivate = false;
            insert a;
        
          Attachment fieldId = [SELECT Id FROM Attachment LIMIT 1][0];
          Id fieId = fieldId.Id;
        
          Id newRec = CXE_FileController.saveTheChunk(parId, 'testFileName', 'testBase64Data', 'testContent', fieId);
        
        test.stopTest();
        
        System.assertEquals(caseId.Id, parId);
        System.assertEquals(false, string.isEmpty(newRec));
        System.debug('newRec Id: ==================>'+ newRec);
        System.assertEquals(fieldId.Id, fieId);
    }
    
    
    static testMethod void init_attachmentTest(){
        
         Case caseId = [SELECT id FROM Case LIMIT 1][0]; 
        Id parId = caseId.Id;
        
        
        Attachment attch = new Attachment();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attch.Body =bodyBlob;
        attch.ContentType ='image/jpeg';
        attch.Name ='Uploaded file';
        attch.ParentId =parId;
        
        insert attch;
        
        Test.startTest();
        Id attachId = CXE_FileController.init_attachment(attch.ParentId,String.valueOf(attch.name), String.valueOf(attch.ContentType));
        
        
        Integer num = CXE_FileController.append_attachment(attch.Id, String.valueOf(attch.Body));
        
        Test.stopTest();	
        
        System.assertEquals(0, num);
        System.assert(attachId!=null);
        
        
        
        
    }
    /*
    static testMethod void tieFileToCase(){
        Case caseId = [SELECT Id FROM Case LIMIT 1][0]; 
        Id parId = caseId.Id;
        
        Blob myBlob = Blob.valueof('myString');

        ContentVersion con = new ContentVersion();
        con.Title = 'test';
        con.PathOnClient = 'test.png';
        con.VersionData = myBlob;
        insert con;
        
        ContentVersion conVer = [SELECT Id, title, ContentDocumentId FROM ContentVersion LIMIT 1];

        test.startTest();
          CXE_FileController.tieFileToCase(conVer.Id, parId);
        test.stopTest();        
    }
    */
 
}