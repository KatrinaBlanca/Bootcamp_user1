/* 
 * The test Class covers only the following:
 * 
 * CaseStateTransitionHelper getPreciousMediator()
 * CaseStateTransitionHelper getRcordByName()
 * CaseStateTransitionHelper getPreviousFromDate()
 * CaseStateTransitionHelper getCaseTransitionByName()
 * 
 * The remaining methods of CaseTransitionHelper is
 * already covered by CaseTriggerHandler_Test
 * 
 * Author: JAgapito
 * Date: Oct.27, 2017
 * 
 * */


@isTest
public class CaseStateTransitionHelper_Test {
    
    
    static testMethod void CaseTransitionHelperTest() {
        
        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
      
        Set <String> mockRecordNames = new Set<String>();
        String mockState = 'Active';
        List <Case_State_Transition__c> cst = new List <Case_State_Transition__c>();
        
        cst = CaseStateTransitionHelper.getCaseTransitionsByName(MockRecordNames);
        
        Date prevDate = CaseStateTransitionHelper.getPreviousFromDate(caseRecord.id, mockState);
        
        Case_State_Transition__c c = CaseStateTransitionHelper.getPreviousMediator(caseRecord.Id, mockState);
        Case_State_Transition__c cc = CaseStateTransitionHelper.getRcordByName(caseRecord.First_Name__c);
        
    }
}