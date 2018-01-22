/* Description: CXE_CreateContract_CC test class
 * Author: Michael Lasala
 * Date Created: MAR-10-17
 */
@isTest
 public class CXE_CreateContract_CC_Test {
    
    //Get contract picklist values
    static testMethod void picklistValuesTest(){
        
        Test.StartTest();
            Map<String, List<String>> testPicklistValues = CXE_CreateContract_CC.getContractPicklistValues();
        Test.StopTest();
        
        //-1 for actual results (--None-- value)
        System.assertEquals(Contract.Status.getDescribe().getPicklistValues().size(), testPicklistValues.get('Status').size()-1);
        System.assertEquals(Contract.Type__c.getDescribe().getPicklistValues().size(), testPicklistValues.get('Type__c').size()-1);
        System.assertEquals(Contract.Method_of_Payment__c.getDescribe().getPicklistValues().size(), testPicklistValues.get('Method_of_Payment__c').size()-1);
    }
         
    //Get case details
    static testMethod void caseTest(){
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        insert testCase;
        
        Test.StartTest();
            Case contractCase = CXE_CreateContract_CC.getCase(testCase.Id);
        Test.StopTest();

        System.assertEquals(testCase.Id, contractCase.Id);
    }
    
    //Get user details
    static testMethod void userTest(){
        String userFullName = UserInfo.getFirstName()+' '+UserInfo.getLastName();
        
        Test.StartTest();
            String contractUserFullName = CXE_CreateContract_CC.getUser();
        Test.StopTest();

        System.assertEquals(userFullName, contractUserFullName);
    }
    
    //Save contract
    /*
    static testMethod void saveTest(){
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Type__c = 'Regular',
                                             Status = 'Draft');
        
        Test.StartTest();
            Account acc = CXE_CreateContract_CC.getAccount(testAccount.Id);
            String contract = CXE_CreateContract_CC.saveContract(testContract);
        Test.StopTest();

        System.assertEquals(testAccount.Id, acc.Id);
        System.assertEquals('Success', contract);
    }
     */
    //Save multimeter case contract
    static testMethod void saveMultimeterTest(){
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.Multimetering__c = true;
        insert testCase;

        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Type__c = 'Regular', 
                                             Case__c = testCase.Id);
        
        Test.StartTest();
            String contract = CXE_CreateContract_CC.saveContract(testContract);
        Test.StopTest();

        System.assertEquals('Success', contract);
    }
    
    //relate address to contract
    static testMethod void relateBillingAddressToContractTest(){
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;

        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        insert testCase;

        /*Address__c testAddress = new Address__c(Type__c = 'Billing', 
                                                Account__c = testAccount.Id,
                                                Case__c = testCase.Id, 
                                                Address_Street_No__c = '1');*/
        Address__c testAddress = CXE_TestDataFactory.createAddressWithoutReference('Billing', testCase.Id, testAccount.Id, null, null, null, null); 

        insert testAddress;
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Type__c = 'Regular');
        insert testContract;
        
        Test.StartTest();
            CXE_CreateContract_CC.relateBillingAddressToContract(testContract.Id);
            Integer addressCount = [SELECT COUNT() FROM Address__c 
                WHERE Account__r.Id =: testAccount.Id AND Case__r.Id =: testCase.Id AND Contract__r.Id =: testContract.Id AND Type__c = 'Billing'];
        Test.StopTest();
        
        System.assert(addressCount > 0);
    }
    

    //Validate contract
    static testMethod void validationTest(){
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        insert testCase;

        /*Address__c testAddress = new Address__c(Type__c = 'Billing', 
                                                Account__c = testAccount.Id,
                                                Case__c = testCase.Id,
                                                Address_Street_No__c = '1');*/
        Address__c testAddress = CXE_TestDataFactory.createAddressWithoutReference('Billing', testCase.Id, testAccount.Id, null, null, null, null); 

        insert testAddress;
        
        List<Contract> testContract = CXE_TestDataFactory.createContract(1, testAccount.Id, testCase.Id);
        insert testContract;

        Test.StartTest();
            Boolean isAccountAddressValid = CXE_CreateContract_CC.validateIfAccountHasBillingAddress(testAccount.Id);
            Boolean isCaseAddressValid = CXE_CreateContract_CC.validateIfCaseHasBillingAddress(testCase.Id);
            String isCreateContractValid = CXE_CreateContract_CC.isValidToCreateContract(testCase.Id, testCase.Status, false);
        Test.StopTest();

        System.assertEquals(true, isAccountAddressValid);
        System.assertEquals(true, isCaseAddressValid);
        System.assertEquals(CXE_Constants.CREATE_CONTRACT_ERROR_MESSAGE_SINGLE_METERED_VALIDATION, isCreateContractValid);
    }

    //Validate multimeter case contract
    static testMethod void validateMultimeterTest(){
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        insert testCase;
        
        List<Contract> testContract = CXE_TestDataFactory.createContract(1, testAccount.Id, testCase.Id);
        insert testContract;

        Test.StartTest();
            String isCreateContractValid = CXE_CreateContract_CC.isValidToCreateContract(testCase.Id, testCase.Status, true);
        Test.StopTest();

        System.assertEquals(CXE_Constants.CREATE_CONTRACT_ERROR_MESSAGE_MULTI_METERED_VALIDATION, isCreateContractValid);
    }

    //Validate invalid case status
    static testMethod void validateInvalidCaseTest(){
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        insert testCase;
        
        testCase.Status = 'Application with insufficient data';
        update testCase;

        List<Contract> testContract = CXE_TestDataFactory.createContract(1, testAccount.Id, testCase.Id);
        insert testContract;

        Test.StartTest();
            String isCreateContractValid = CXE_CreateContract_CC.isValidToCreateContract(testCase.Id, testCase.Status, true);
        Test.StopTest();

        System.assertEquals(CXE_Constants.CREATE_CONTRACT_ERROR_MESSAGE_INVALID_CASE_STATUS, isCreateContractValid);
    }
}