@isTest
public class CXE_BS_Paperles_Cancel_Test {
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

   static testmethod void testBS_PaperlessCancel() {

     Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
     
     Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
     for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
         addressReference.put(addRef.Field__c, addRef);
     } 

     Test.startTest();
     Account testAccount = CXE_TestDataFactory.createBusinessAccount(1)[0];
       testAccount.AccountNumber = '0012238';
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
     caseRecord.CXE_Paperless_BillingCancellationReason__c = 'I want to deactivate my Meralco Online account';
     insert caseRecord;

     Contract testContract = CXE_TestDataFactory.createContract(1, testAccount.Id, null)[0];
     testContract.Bill_Print_Mode__c = CXE_Constants.BPM_PAPERLESS;
     testContract.Case__c = caseRecord.Id;
     insert testContract;

     Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
     addressRec.Case__c = caseRecord.Id;
     addressRec.Contract__c = testContract.Id;
     addressRec.Type__c = 'Billing';
     insert addressRec;

     Agreement__c testAgreement = CXE_TestDataFactory.createService(1, testAccount.id, null, testContract.Id, psicRecord[0].Id)[0];
     testAgreement.Applied_Load__c = 200;
     testAgreement.Payor__c = testContract.Id;
     testAgreement.SIN__c = '1096854311';
     insert testAgreement;

     RestContext.request = new RestRequest();
     RestContext.response = new RestResponse();
     CXE_BS_Paperles_Cancel.create('0012238', 'I want to deactivate my Meralco Online account', null);
     Test.stopTest();

     String RTN_MSG_PAPERLESS = 'PAPERLESS';
     System.assertEquals(RestContext.response.headers.get('Content-Type'), 'application/json');
     //System.assertEquals(RestContext.response.responseBody, Blob.valueOf('{"result": "'+ RTN_MSG_PAPERLESS +'"}')); 
   }

}