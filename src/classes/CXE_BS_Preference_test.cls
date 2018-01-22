@isTest
public class CXE_BS_Preference_test {
    
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

   static testmethod void testBS_Preference() {

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
       contactRecord.Billing_Notification__c               = 'Email';
       contactRecord.Payment_Confirmation_Notification__c  = 'Email';
       contactRecord.Payment_Reminders__c                  = 'Email';    
       contactRecord.Service_Applications_Notification__c  = 'Email'; 
       contactRecord.Outages_Notification__c               = 'Email';            
       contactRecord.Promotions_Notification__c            = 'Email'; 
     insert contactRecord;
     
     RestContext.request = new RestRequest();
     RestContext.response = new RestResponse();
     CXE_BS_Preference.post('Email', 'Email', 'Email', 'Email', 'Email', 'Email');
     Test.stopTest();

     System.assertEquals(RestContext.response.headers.get('Content-Type'), 'application/json');
   }

}