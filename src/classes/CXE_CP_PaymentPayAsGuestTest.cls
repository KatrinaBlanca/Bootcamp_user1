/* 
 * Description: Test Class for CXE_CP_PaymentPayAsGuest
 * Author: Rom Edison Reyes (Accenture)
 * Date Created: JAN-06-2018
 */ 
@isTest
public class CXE_CP_PaymentPayAsGuestTest {
    
    @testSetup
    static void setupOrgData(){
        OrganizationSettings__c orgSet = new OrganizationSettings__c();
        orgSet.Heroku_Basic_Auth__c = 'Basic TEST=';
        orgSet.HerukoEndpointGetBills__c = 'https://cxe-testonly.herokuapp.com/billing/viewbills';
        orgSet.HerukoEndpointGetBillsByInvoice__c = 'https://cxe-testonly.herokuapp.com/billing/invoice/check?id=';
        orgSet.Terms_And_Conditions_Link__c = 'http://www.meralco.com.ph/privacy-policy';
        insert orgSet;
    }

    static testmethod void getHiearchySettingsTest(){
        test.startTest();
        System.assertEquals('http://www.meralco.com.ph/privacy-policy', CXE_CP_PaymentPayAsGuest.getHiearchySettings());
        test.stopTest();  
    }

    static testmethod void getBooleanServiceStatusTest(){
        test.startTest();
        System.assert(!CXE_CP_PaymentPayAsGuest.getBooleanServiceStatus());
        test.stopTest();  
    }

    static testmethod void testServiceDisconnectedEqual(){
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
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '584950609109',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        //CREATE SERVICE
        Agreement__c service = new Agreement__c();
        service.Account__c = testAccount.Id;
        service.Case__c = testCase.Id;
        service.Contract__c = testContract.Id;
        service.Rate__c = 'General Power (GP)';
        service.Segment__c = 'Home and Micro Business';
        service.Service_Supply_Type__c = 'Normal with meter';
        service.Service_Wire_Material__c = 'Copper';
        service.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
        service.Service_Wire_Size__c = '#1/0';
        service.Service_Wire_Type__c = 'Under Copper,Lateral';
        service.Voltage_Level__c = '4.8 kV';
        service.Applied_Load__c = 50; 
        service.Payor__c= testContract.Id;
        service.SIN__c = '293028374839';
        service.Service_Status__c = 'Active - Disconnected';
        insert service;

        test.startTest();
        CXE_CP_PaymentPayAsGuest.ReturnData result = CXE_CP_PaymentPayAsGuest.validateData('serviceRadio', '293028374839', 3920.34, null);
        System.assertEquals(true, result.isDisconnected);
        System.assertEquals('reactivate pending 2', result.errorMessage);
        System.assertEquals('Exact', result.payment_status);
        test.stopTest();
    }

    static testmethod void testServiceTerminatedPartialOver(){
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
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '584950609109',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        //CREATE SERVICE
        Agreement__c service = new Agreement__c();
        service.Account__c = testAccount.Id;
        service.Case__c = testCase.Id;
        service.Contract__c = testContract.Id;
        service.Rate__c = 'General Power (GP)';
        service.Segment__c = 'Home and Micro Business';
        service.Service_Supply_Type__c = 'Normal with meter';
        service.Service_Wire_Material__c = 'Copper';
        service.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
        service.Service_Wire_Size__c = '#1/0';
        service.Service_Wire_Type__c = 'Under Copper,Lateral';
        service.Voltage_Level__c = '4.8 kV';
        service.Applied_Load__c = 50; 
        service.Payor__c= testContract.Id;
        service.SIN__c = '293028374839';
        service.Service_Status__c = 'Terminated';
        insert service;

        test.startTest();
        CXE_CP_PaymentPayAsGuest.ReturnData result = CXE_CP_PaymentPayAsGuest.validateData('serviceRadio', '293028374839', 920.34, 'test@test.com');
        System.assertEquals(true, result.isTerminated);
        System.assertEquals('active', result.errorMessage);
        System.assertEquals('Partial', result.payment_status);
        
        CXE_CP_PaymentPayAsGuest.ReturnData resultOver = CXE_CP_PaymentPayAsGuest.validateData('serviceRadio', '293028374839', 4000, 'test@test.com');
        System.assertEquals('Over', resultOver.payment_status);
        test.stopTest();
    }

    static testmethod void testServiceInvalidService(){
        test.startTest();
        CXE_CP_PaymentPayAsGuest.ReturnData result = CXE_CP_PaymentPayAsGuest.validateData('serviceRadio', '384028374839', 920.34, null);
        System.assertEquals('Invalid Service ID No.', result.errorMessage);
        test.stopTest();
    }

    static testmethod void testAccountDisconnectedEqual(){
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
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '584950609109',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        //CREATE SERVICE
        Agreement__c service = new Agreement__c();
        service.Account__c = testAccount.Id;
        service.Case__c = testCase.Id;
        service.Contract__c = testContract.Id;
        service.Rate__c = 'General Power (GP)';
        service.Segment__c = 'Home and Micro Business';
        service.Service_Supply_Type__c = 'Normal with meter';
        service.Service_Wire_Material__c = 'Copper';
        service.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
        service.Service_Wire_Size__c = '#1/0';
        service.Service_Wire_Type__c = 'Under Copper,Lateral';
        service.Voltage_Level__c = '4.8 kV';
        service.Applied_Load__c = 50; 
        service.Payor__c= testContract.Id;
        service.SIN__c = '293028374839';
        service.Service_Status__c = 'Active - Disconnected';
        insert service;

        test.startTest();
        CXE_CP_PaymentPayAsGuest.ReturnData result = CXE_CP_PaymentPayAsGuest.validateData('accountRadio', '584950609109', 3920.34, null);
        System.assertEquals(true, result.isDisconnected);
        System.assertEquals('reactivate pending 2', result.errorMessage);
        System.assertEquals('Exact', result.payment_status);
        test.stopTest();
    }

    static testmethod void testAccountTerminatedPartialOver(){
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
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '584950609109',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        //CREATE SERVICE
        Agreement__c service = new Agreement__c();
        service.Account__c = testAccount.Id;
        service.Case__c = testCase.Id;
        service.Contract__c = testContract.Id;
        service.Rate__c = 'General Power (GP)';
        service.Segment__c = 'Home and Micro Business';
        service.Service_Supply_Type__c = 'Normal with meter';
        service.Service_Wire_Material__c = 'Copper';
        service.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
        service.Service_Wire_Size__c = '#1/0';
        service.Service_Wire_Type__c = 'Under Copper,Lateral';
        service.Voltage_Level__c = '4.8 kV';
        service.Applied_Load__c = 50; 
        service.Payor__c= testContract.Id;
        service.SIN__c = '293028374839';
        service.Service_Status__c = 'Terminated';
        insert service;

        test.startTest();
        CXE_CP_PaymentPayAsGuest.ReturnData result = CXE_CP_PaymentPayAsGuest.validateData('accountRadio', '584950609109', 920.34, 'test@test.com');
        System.assertEquals(true, result.isTerminated);
        System.assertEquals('active', result.errorMessage);
        System.assertEquals('Partial', result.payment_status);

        CXE_CP_PaymentPayAsGuest.ReturnData resultOver = CXE_CP_PaymentPayAsGuest.validateData('accountRadio', '584950609109', 4000, 'test@test.com');
        System.assertEquals('Over', resultOver.payment_status);
        test.stopTest();
    }

    static testmethod void testInvoiceDisconnectedEqual(){
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
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '584950609109',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        //CREATE SERVICE
        Agreement__c service = new Agreement__c();
        service.Account__c = testAccount.Id;
        service.Case__c = testCase.Id;
        service.Contract__c = testContract.Id;
        service.Rate__c = 'General Power (GP)';
        service.Segment__c = 'Home and Micro Business';
        service.Service_Supply_Type__c = 'Normal with meter';
        service.Service_Wire_Material__c = 'Copper';
        service.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
        service.Service_Wire_Size__c = '#1/0';
        service.Service_Wire_Type__c = 'Under Copper,Lateral';
        service.Voltage_Level__c = '4.8 kV';
        service.Applied_Load__c = 50; 
        service.Payor__c= testContract.Id;
        service.SIN__c = '293028374839';
        service.Service_Status__c = 'Active - Disconnected';
        insert service;

        test.startTest();
        CXE_CP_PaymentPayAsGuest.ReturnData result = CXE_CP_PaymentPayAsGuest.validateData('invoiceRadio', '1000000003998', 3920.34, null);
        System.assertEquals(true, result.isDisconnected);
        System.assertEquals('reactivate pending 2', result.errorMessage);
        System.assertEquals('Exact', result.payment_status);
        test.stopTest();
    }

    static testmethod void testInvoiceTerminatedPartialOver(){
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
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '584950609109',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;
        
        List<Address__c> lstAddress = new List<Address__c>();
        
        Address__c testAddress = new Address__c(Type__c = 'Billing', Account__c = testAccount.Id, Case__c = testCase.Id, Contract__c = testContract.Id, Address_Street_No__c = '1');
        Address__c testAddress2 = new Address__c(Type__c = 'Service', Account__c = testAccount.Id, Case__c = testCase.Id, Premise_Type__c = 'Single-Detached Residential', Address_Street_No__c = '1');
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        insert lstAddress;
        
        //CREATE SERVICE
        Agreement__c service = new Agreement__c();
        service.Account__c = testAccount.Id;
        service.Case__c = testCase.Id;
        service.Contract__c = testContract.Id;
        service.Rate__c = 'General Power (GP)';
        service.Segment__c = 'Home and Micro Business';
        service.Service_Supply_Type__c = 'Normal with meter';
        service.Service_Wire_Material__c = 'Copper';
        service.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
        service.Service_Wire_Size__c = '#1/0';
        service.Service_Wire_Type__c = 'Under Copper,Lateral';
        service.Voltage_Level__c = '4.8 kV';
        service.Applied_Load__c = 50; 
        service.Payor__c= testContract.Id;
        service.SIN__c = '293028374839';
        service.Service_Status__c = 'Terminated';
        insert service;

        test.startTest();
        CXE_CP_PaymentPayAsGuest.ReturnData result = CXE_CP_PaymentPayAsGuest.validateData('invoiceRadio', '1000000003998', 920.34, 'test@test.com');
        System.assertEquals(true, result.isTerminated);
        System.assertEquals('active', result.errorMessage);
        System.assertEquals('Partial', result.payment_status);
        
        CXE_CP_PaymentPayAsGuest.ReturnData resultOver = CXE_CP_PaymentPayAsGuest.validateData('invoiceRadio', '1000000003998', 4000, 'test@test.com');
        System.assertEquals('Over', resultOver.payment_status);
        test.stopTest();
    }

}