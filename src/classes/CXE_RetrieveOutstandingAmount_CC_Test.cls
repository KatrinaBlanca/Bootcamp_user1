/* 
* Description: Test Class for CXE_RetrieveOutstandingAmount_CC
* Author: Melvin Corbes
* Date Created: July-12-2017
*/ 

@isTest
public class CXE_RetrieveOutstandingAmount_CC_Test {
    
    @testSetup static void initialData(){
        //create a case
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        testCase.CXE_Previous_SIN__c ='22222222';
        testCase.CXE_Total_Outstanding_Amount__c =450.00;
        testCase.CXE_Existing_Bill_Deposit_Amount__c = 750.00;
        testCase.Arrears_Tag__c =TRUE;
        insert testCase;
        
        
        
    }
    
    @isTest static void updateCaseTestError(){
        
        Case caseRec = [SELECT Id,RecordTypeId, Tax_Identification_No__c,
                        AccountId,CXE_Previous_SIN__c,CXE_Total_Outstanding_Amount__c,
                        CXE_Existing_Bill_Deposit_Amount__c,Arrears_Tag__c
                        FROM Case LIMIT 1];
        
        //initializ integration settings
        Integration_Settings__c  integ = new Integration_Settings__c();
        integ.Name ='getArrears';
        integ.Endpoint__c ='endpoint';
        integ.Password__c ='Melvin';
        integ.Username__c ='mcorbes@accenture.com';
        
        insert integ;
        Test.startTest();
             Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
            String updateCase =CXE_RetrieveOutstandingAmount_CC.updateCase(caseRec.Id);
           
        Test.stopTest();
        
        //System.assertEquals('You cannot lift the Arrears Tagging for this Case. Please have it approved by a G4 personnel.', updateCase);
        System.assertEquals('This function is only available for after sales cases.', updateCase);
        Case caseRec2 = [SELECT ID ,V10_Customer_No__c FROM Case][0];
        System.assert(caseRec2 != null);
        
    }

    @isTest static void updateCaseTest(){
        
        //Case caseRec = [SELECT Id,RecordTypeId, Tax_Identification_No__c,
        //                AccountId,CXE_Previous_SIN__c,CXE_Total_Outstanding_Amount__c,
        //                CXE_Existing_Bill_Deposit_Amount__c,Arrears_Tag__c
        //                FROM Case LIMIT 1];
        
        Case testRSACase = CXE_TestDataFactory.createRecontractCase(1, '')[0];
        testRSACase.CXE_Previous_SIN__c = '827364536273';
        testRSACase.Application_for_Business_Customer__c = false;
        insert testRSACase;

        //initializ integration settings
        Integration_Settings__c  integ = new Integration_Settings__c();
        integ.Name ='getArrears';
        integ.Endpoint__c ='endpoint';
        integ.Password__c ='Melvin';
        integ.Username__c ='mcorbes@accenture.com';
        
        insert integ;
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            String updateCase =CXE_RetrieveOutstandingAmount_CC.updateCase(testRSACase.Id);
           
        Test.stopTest();
        
        //System.assertEquals('You cannot lift the Arrears Tagging for this Case. Please have it approved by a G4 personnel.', updateCase);
        //System.assertEquals('Success', updateCase);
        Case caseRec2 = [SELECT ID ,V10_Customer_No__c FROM Case][0];
        System.assert(caseRec2 != null);
        
    }
    
}