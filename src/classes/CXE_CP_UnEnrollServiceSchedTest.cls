/* 
 * Description: Test Class for CXE_CP_UnEnrollServiceSched
 * Author: Rom Edison Reyes (Accenture)
 * Date Created: JAN-02-2018
 */ 
@isTest
private class CXE_CP_UnEnrollServiceSchedTest {

   // CRON expression: midnight on March 15. 
   // Because this is a test, job executes immediately after Test.stopTest(). 
    
   public static String CRON_EXP = '0 0 0 15 3 ? 2022';

   static testmethod void executeUnenroll() {
      Test.startTest();
      // Schedule the test job 
      String jobId = System.schedule('CXE_CP_UnEnrollServiceSchedTest',
                        CRON_EXP, 
                        new CXE_CP_UnEnrollServiceSched());
      System.assertNotEquals(jobId, '');
      System.assertNotEquals(jobId, null);
      Test.stopTest();

   }
}