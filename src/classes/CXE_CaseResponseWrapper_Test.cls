/* Author : Melvin Corbes Jul-14-2017
 * 
 */
@isTest
public class CXE_CaseResponseWrapper_Test {

    @isTest static void CXE_CaseResponseWrapperTest(){
        Test.startTest();
        CXE_CaseResponseWrapper cxe  = new CXE_CaseResponseWrapper();

        cxe.caseNumber ='0001';
        cxe.caseRecordId ='0002';
        cxe.notificationChannels ='Notify';
        cxe.hasError =false;
        cxe.errorMessage ='Error Message';  
        List<String> adderror = new List<String>();
        cxe.errorMessages =adderror;
        cxe.isTerminate =TRUE;
        cxe.statusJourney ='Journey';
        
		List<CXE_CaseHistoryWrapper> cxHistorywpper = new List<CXE_CaseHistoryWrapper>();
        cxe.caseStatusHistoryList =cxHistorywpper;
		List<Case_State_Transition__c> cstateTrans = new List<Case_State_Transition__c>();
        cxe.caseStateTransitions =cstateTrans;
        Test.stopTest();    
        System.assert(cxe != null);    
   
  
    }
    
    
}