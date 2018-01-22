/*Author : Melvin Corbes Jul-14-2017
 *
 */

@isTest
public class CXE_CaseHistoryWrapper_Test {

    @isTest static void CaseHistoryWrapper(){
        
        //create Case
         List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        testCase.Relationship__c ='--- None ---';
        testCase.Service_Address_Province__c ='--- None ---';
        //testCase.Service_Address_City_Municiple__c ='--- None ---';
        testCase.Service_Address_City_Municiple__c ='STO. TOMAS';
        testCase.Billing_Address_Province__c ='--- None ---';
        testCase.Billing_Address_City_Municipal__c ='--- None ---';
        testCase.Last_Name__c ='TestLname';
        testCase.Account_No__c ='370418740101';
        testCase.Same_As_Service_Address__c =TRUE;
        testCase.Address_2__c ='address 2';
        
        
        insert testCase;
        
        Test.startTest();
        
        CXE_CaseHistoryWrapper cxw = new CXE_CaseHistoryWrapper();
        
        cxw.caseId =String.valueOf(testCase.Id);
        cxw.NewValue =testCase;
        cxw.OldValue  =testCase;
        cxw.Remarks ='Remarks';
        cxw.Field ='Field';
        cxw.CreatedDate =System.today();
        
        Test.stopTest();
        
        System.assert(cxw != null);
        
    }      
    
}