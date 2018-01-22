/* 
 * Description: Test Class for CXE_CP_APADocumentBatch
 * Author: Rom Edison Reyes (Accenture)
 * Date Created: JAN-02-2018
 */ 
@isTest
private class CXE_CP_APADocumentBatchTest {

   // CRON expression: midnight on March 15. 
   // Because this is a test, job executes immediately after Test.stopTest(). 
    
   public static String CRON_EXP = '0 0 0 15 3 ? 2022';

   static testmethod void executeAPADocumentBatch() {
      Test.startTest();
      // Schedule the test job 
      String jobId = System.schedule('CXE_CP_APADocumentBatchTest',
                        CRON_EXP, 
                        new CXE_CP_APADocumentBatch());
      Test.stopTest();

      // Now that the scheduled job has executed after Test.stopTest(), 
      Date dateYesterday = system.today() - 1;
      List<Auto_Payment_Arrangement__c> existingApa = [SELECT Id FROM Auto_Payment_Arrangement__c 
                                                         WHERE Date__c =:dateYesterday];
      System.assertEquals(existingApa.size(), 1);

   }
}