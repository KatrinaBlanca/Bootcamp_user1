/* Author   : @JRances 
 * Date     : OCT-18-2017
 * Desc.    : Test Class/Code Coverage for CXE_CP_MyBillsSummaryCtlr
 * */

@isTest
public class CXE_CP_MyBillsSummaryCtlr_Test {
    
    @testSetup static void setup() {
        CXE_TestDataFactory.setOrgSettings();
        
        //Create PSIC
        List<PSIC__c> psicLst = CXE_TestDataFactory.createPSIC(1);
        psicLst[0].Name = 'Non-Residential';
        psicLst[0].Demand_Factor__c = .80;
        psicLst[0].PSIC_Code__c = '77770';
        insert psicLst;
        system.assertEquals(true, psicLst[0].Id!=null );
        
        List<Account> acctList = CXE_TestDataFactory.createPersonAccount(1);
        acctList[0].FirstName = 'first';
        acctList[0].MiddleName = 'middle';
        acctList[0].LastName = 'last';
        acctList[0].Email__c = 'first_last_name@yopmail.com';
        acctList[0].Conglomerate__c = true;
        insert acctList;
        system.assertEquals(true, acctList[0].Id!=null );
        
        Account acct = [Select Id, PersonContactId From Account 
                        Where Id =: acctList[0].Id ];
        system.assertEquals(true, acct.PersonContactId!=null );
        
        //Create Case
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();  
        List<Case> createCase = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        createCase[0].RecordTypeId = newServiceApplicationRecordTypeId;
        createCase[0].PSIC__c = psicLst[0].id;
        createCase[0].ContactId = acct.PersonContactId;
        createCase[0].AccountId = acct.Id;
        createCase[0].Applied_Load__c = 6;
        createCase[0].Demand_Factor__c = 0.50;
        createCase[0].Load_Factor__c = 0.25;
        createCase[0].Phase__c = 'Single Phase (1Ø), Network';
        createCase[0].Service_Supply_Type__c = 'Normal with meter';
        createCase[0].Service_Wire_Length__c = 1;
        createCase[0].Material__c = 'Copper';
        createCase[0].Pole_Code__c = '1';
        createCase[0].Wire_Size__c = '#1/0';
        createCase[0].Service_Wire_Type__c = 'Under Copper,Lateral';
        createCase[0].Voltage__c = '2.0 kV';
        createCase[0].Application_for_Business_Customer__c = false;
        createCase[0].Application_for_Residential_Customer__c = true;
        
        insert createCase;
        system.assertEquals(true, createCase[0].Id!=null );
        
        
        //Create Contract
        List<Contract> createContract = CXE_TestDataFactory.createContract(1,acct.id,createCase[0].id);
        insert createContract;
        system.assertEquals(true, createContract[0].Id!=null );
        
        //Create Address
        Address__c createAddress = CXE_TestDataFactory.createAddress(acct.id,createCase[0].id,createContract[0].id);
        insert createAddress;
        system.assertEquals(true, createAddress.Id!=null );
        
        //Create Service
        //Modified by Rom - changed method call from createService() to createServiceWithLessDetails()
        List<Agreement__c> createService = CXE_TestDataFactory.createServiceWithLessDetails(1,acct.id,createCase[0].id,
                                                                                            createContract[0].id,psicLst[0].id);
        createService[0].Payor__c = createContract[0].id;
        insert createService;
        createService[0].SIN__c = '293028374839';
        update createService;
        system.assertEquals(true, createService[0].Id!=null );
        
        
        
    }
    
    @isTest 
    private static void test_RetrievePortalData(){    
        Test.startTest();
        CXE_CP_MyBillsSummaryCtlr.retrievePortalData(true);
        Test.stopTest();
    }
    
    @isTest
    private static void test_RetrieveBillingDetails(){
        List<User> userList = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
        System.assertEquals(1, userList.size());
        List<Agreement__c> agreementList = [Select Id, Contract__c, Payor__c From Agreement__c 
                                            Where SIN__c = '293028374839'];
        System.assertEquals(1, agreementList.size() );
        System.assertEquals(agreementList[0].Contract__c, agreementList[0].Payor__c );
        
        Test.startTest();
        System.runAs(userList[0]){
            CXE_CP_SplashPageSelfRegistration_CC.createUser(
                'first_last_name@yopmail.com', 
                'first', 
                'middle', 
                'last', 
                'Mr', 
                '+639001110011', 
                '293028374839', 
                300, 
                '2018-03-15', 
                false
            );
        }
        
        
        List<User> portalUserList = [SELECT Id, Email FROM User 
                                     WHERE Profile.Name = :CXE_Constants.PORTAL_COMMUNITY_PROFILE
                                     AND Email ='first_last_name@yopmail.com'
                                     AND isActive =TRUE];  
        
        System.runAs(portalUserList[0]){
            CXE_CP_MyBillsSummaryCtlr.retrieveBillingDetailsNoParam();
        }
        System.assertEquals(1, portalUserList.size() );
        Test.stopTest();
    }

    @isTest
    private static void test_RetrieveBillingDetailsWithSIN(){
        List<User> userList = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
        System.assertEquals(1, userList.size());
        List<Agreement__c> agreementList = [Select Id, Contract__c, Payor__c From Agreement__c 
                                            Where SIN__c = '293028374839'];
        System.assertEquals(1, agreementList.size() );
        System.assertEquals(agreementList[0].Contract__c, agreementList[0].Payor__c );
        
        Test.startTest();
        System.runAs(userList[0]){
            CXE_CP_SplashPageSelfRegistration_CC.createUser(
                'first_last_name@yopmail.com', 
                'first', 
                'middle', 
                'last', 
                'Mr', 
                '+639001110011', 
                '293028374839', 
                300, 
                '2018-03-15', 
                false
            );
        }
        
        
        List<User> portalUserList = [SELECT Id, Email FROM User 
                                     WHERE Profile.Name = :CXE_Constants.PORTAL_COMMUNITY_PROFILE
                                     AND Email ='first_last_name@yopmail.com'
                                     AND isActive =TRUE];  
        
        System.runAs(portalUserList[0]){
            List<CXE_Heroku_Model.BillDetail> billDet = CXE_CP_MyBillsSummaryCtlr.retrieveBillingDetails('293028374839');
            
            CXE_CP_MyBillsSummaryCtlr.retrieveFilteredBills(billDet[0].service_number, 
                                                            billDet[0].account_number, 
                                                            billDet[0].bill_type, 
                                                            billDet[0].bill_status);

            CXE_CP_MyBillsSummaryCtlr.errorMessage('1','1');
            CXE_CP_MyBillsSummaryCtlr.retrieveCheckConglomerate();

            List<CXE_CP_MyBillsSummaryCtlr.PayTrans> paymentTransactions = new List<CXE_CP_MyBillsSummaryCtlr.PayTrans>();
            CXE_CP_MyBillsSummaryCtlr.PayTrans paymentTransaction = new CXE_CP_MyBillsSummaryCtlr.PayTrans();
            paymentTransaction.accountNum = billDet[0].account_number; 
            paymentTransaction.serviceNum = billDet[0].service_number;
            paymentTransaction.billId = billDet[0].bill_number;
            paymentTransaction.paymentAmount = '1012';
            paymentTransaction.accountId = 'sas13';

            paymentTransactions.add(paymentTransaction);


            Test.setMock(HttpCalloutMock.class, new MockCCPay()); 
            try {
            CXE_CP_MyBillsSummaryCtlr.payV2('asasa',
                                            '1000',
                                            '12',
                                            '1012',
                                            'test',
                                            'test121232@yopmail.com',
                                            'TIMOPA0003',
                                            '110008',
                                            'address',
                                            paymentTransactions,
                                            'ViewBill',
                                            billDet[0].invoice_id, 
                                            billDet[0].bill_number, 
                                            billDet[0].account_number, 
                                            billDet[0].service_number, 
                                            '1012',
                                            '1012', 
                                            billDet[0].invoice_id, 
                                            billDet[0].service_number,
                                            billDet[0].bill_number, 
                                            billDet[0].invoice_number, 
                                            billDet[0].invoice_number);
            }catch (exception e)
            {}

            //system.assertequals(billDet[0].account_number, null);
        }
        System.assertEquals(1, portalUserList.size() );
        Test.stopTest();
    }

    @isTest
    private static void test_PayAsGuestInvoice(){
        List<User> userList = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
        System.assertEquals(1, userList.size());
        List<Agreement__c> agreementList = [Select Id, Contract__c, Payor__c From Agreement__c 
                                            Where SIN__c = '293028374839'];
        System.assertEquals(1, agreementList.size() );
        System.assertEquals(agreementList[0].Contract__c, agreementList[0].Payor__c );
        
        Test.startTest();
        System.runAs(userList[0]){
            CXE_CP_SplashPageSelfRegistration_CC.createUser(
                'first_last_name@yopmail.com', 
                'first', 
                'middle', 
                'last', 
                'Mr', 
                '+639001110011', 
                '293028374839', 
                300, 
                '2018-03-15', 
                false
            );
        }
        
        
        List<User> portalUserList = [SELECT Id, Email FROM User 
                                     WHERE Profile.Name = :CXE_Constants.PORTAL_COMMUNITY_PROFILE
                                     AND Email ='first_last_name@yopmail.com'
                                     AND isActive =TRUE];  
        
        System.runAs(portalUserList[0]){
            List<CXE_Heroku_Model.BillDetail> billDet = CXE_CP_MyBillsSummaryCtlr.retrieveBillingDetails('293028374839');
            

            List<CXE_CP_MyBillsSummaryCtlr.PayTrans> paymentTransactions = new List<CXE_CP_MyBillsSummaryCtlr.PayTrans>();
            CXE_CP_MyBillsSummaryCtlr.PayTrans paymentTransaction = new CXE_CP_MyBillsSummaryCtlr.PayTrans();
            paymentTransaction.accountNum = billDet[0].account_number; 
            paymentTransaction.serviceNum = billDet[0].service_number;
            paymentTransaction.billId = billDet[0].bill_number;
            paymentTransaction.paymentAmount = '1012';
            paymentTransaction.accountId = 'sas13';

            paymentTransactions.add(paymentTransaction);


            Test.setMock(HttpCalloutMock.class, new MockCCPay()); 
            try {
            CXE_CP_MyBillsSummaryCtlr.payV2('asasa',
                                            '1000',
                                            '12',
                                            '1012',
                                            'test',
                                            'test121232@yopmail.com',
                                            'TIMOPA0003',
                                            '110008',
                                            'address',
                                            paymentTransactions,
                                            'PayAsGuestInvoice',
                                            billDet[0].invoice_id, 
                                            billDet[0].bill_number, 
                                            billDet[0].account_number, 
                                            billDet[0].service_number, 
                                            '1012',
                                            '1012', 
                                            billDet[0].invoice_id, 
                                            billDet[0].service_number,
                                            billDet[0].bill_number, 
                                            billDet[0].invoice_number, 
                                            billDet[0].invoice_number);
            }catch (exception e)
            {}

            //system.assertequals(billDet[0].account_number, null);
        }
        System.assertEquals(1, portalUserList.size() );
        Test.stopTest();
    }

    @isTest
    private static void test_Over(){
        List<User> userList = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
        System.assertEquals(1, userList.size());
        List<Agreement__c> agreementList = [Select Id, Contract__c, Payor__c From Agreement__c 
                                            Where SIN__c = '293028374839'];
        System.assertEquals(1, agreementList.size() );
        System.assertEquals(agreementList[0].Contract__c, agreementList[0].Payor__c );
        
        Test.startTest();
        System.runAs(userList[0]){
            CXE_CP_SplashPageSelfRegistration_CC.createUser(
                'first_last_name@yopmail.com', 
                'first', 
                'middle', 
                'last', 
                'Mr', 
                '+639001110011', 
                '293028374839', 
                300, 
                '2018-03-15', 
                false
            );
        }
        
        
        List<User> portalUserList = [SELECT Id, Email FROM User 
                                     WHERE Profile.Name = :CXE_Constants.PORTAL_COMMUNITY_PROFILE
                                     AND Email ='first_last_name@yopmail.com'
                                     AND isActive =TRUE];  
        
        System.runAs(portalUserList[0]){
            List<CXE_Heroku_Model.BillDetail> billDet = CXE_CP_MyBillsSummaryCtlr.retrieveBillingDetails('293028374839');
            

            List<CXE_CP_MyBillsSummaryCtlr.PayTrans> paymentTransactions = new List<CXE_CP_MyBillsSummaryCtlr.PayTrans>();
            CXE_CP_MyBillsSummaryCtlr.PayTrans paymentTransaction = new CXE_CP_MyBillsSummaryCtlr.PayTrans();
            paymentTransaction.accountNum = billDet[0].account_number; 
            paymentTransaction.serviceNum = billDet[0].service_number;
            paymentTransaction.billId = billDet[0].bill_number;
            paymentTransaction.paymentAmount = '5000';
            paymentTransaction.accountId = 'sas13';

            paymentTransactions.add(paymentTransaction);


            Test.setMock(HttpCalloutMock.class, new MockCCPay()); 
            try {
            CXE_CP_MyBillsSummaryCtlr.payV2('asasa',
                                            '5000',
                                            '0',
                                            '3920.34',
                                            'test',
                                            'test121232@yopmail.com',
                                            'TIMOPA0003',
                                            '110008',
                                            'address',
                                            paymentTransactions,
                                            'PayAsGuestInvoice',
                                            billDet[0].invoice_id, 
                                            billDet[0].bill_number, 
                                            billDet[0].account_number, 
                                            billDet[0].service_number, 
                                            '3920.34',
                                            '3920.34', 
                                            billDet[0].invoice_id, 
                                            billDet[0].service_number,
                                            billDet[0].bill_number, 
                                            billDet[0].invoice_number, 
                                            billDet[0].invoice_number);
            }catch (exception e)
            {}

            //system.assertequals(billDet[0].account_number, null);
        }
        System.assertEquals(1, portalUserList.size() );
        Test.stopTest();
    }

     @isTest
    private static void test_Exact(){
        List<User> userList = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
        System.assertEquals(1, userList.size());
        List<Agreement__c> agreementList = [Select Id, Contract__c, Payor__c From Agreement__c 
                                            Where SIN__c = '293028374839'];
        System.assertEquals(1, agreementList.size() );
        System.assertEquals(agreementList[0].Contract__c, agreementList[0].Payor__c );
        
        Test.startTest();
        System.runAs(userList[0]){
            CXE_CP_SplashPageSelfRegistration_CC.createUser(
                'first_last_name@yopmail.com', 
                'first', 
                'middle', 
                'last', 
                'Mr', 
                '+639001110011', 
                '293028374839', 
                300, 
                '2018-03-15', 
                false
            );
        }
        
        
        List<User> portalUserList = [SELECT Id, Email FROM User 
                                     WHERE Profile.Name = :CXE_Constants.PORTAL_COMMUNITY_PROFILE
                                     AND Email ='first_last_name@yopmail.com'
                                     AND isActive =TRUE];  
        
        System.runAs(portalUserList[0]){
            List<CXE_Heroku_Model.BillDetail> billDet = CXE_CP_MyBillsSummaryCtlr.retrieveBillingDetails('293028374839');
            

            List<CXE_CP_MyBillsSummaryCtlr.PayTrans> paymentTransactions = new List<CXE_CP_MyBillsSummaryCtlr.PayTrans>();
            CXE_CP_MyBillsSummaryCtlr.PayTrans paymentTransaction = new CXE_CP_MyBillsSummaryCtlr.PayTrans();
            paymentTransaction.accountNum = billDet[0].account_number; 
            paymentTransaction.serviceNum = billDet[0].service_number;
            paymentTransaction.billId = billDet[0].bill_number;
            paymentTransaction.paymentAmount = '3920.34';
            paymentTransaction.accountId = 'sas13';

            paymentTransactions.add(paymentTransaction);


            Test.setMock(HttpCalloutMock.class, new MockCCPay()); 
            try {
            CXE_CP_MyBillsSummaryCtlr.payV2('asasa',
                                            '3920.34',
                                            '0',
                                            '3920.34',
                                            'test',
                                            'test121232@yopmail.com',
                                            'TIMOPA0003',
                                            '110008',
                                            'address',
                                            paymentTransactions,
                                            'PayAsGuestInvoice',
                                            billDet[0].invoice_id, 
                                            billDet[0].bill_number, 
                                            billDet[0].account_number, 
                                            billDet[0].service_number, 
                                            '3920.34',
                                            '3920.34', 
                                            billDet[0].invoice_id, 
                                            billDet[0].service_number,
                                            billDet[0].bill_number, 
                                            billDet[0].invoice_number, 
                                            billDet[0].invoice_number);
            }catch (exception e)
            {}

            //system.assertequals(billDet[0].account_number, null);
        }
        System.assertEquals(1, portalUserList.size() );
        Test.stopTest();
    }

     @isTest
    private static void test_Partial(){
        List<User> userList = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
        System.assertEquals(1, userList.size());
        List<Agreement__c> agreementList = [Select Id, Contract__c, Payor__c From Agreement__c 
                                            Where SIN__c = '293028374839'];
        System.assertEquals(1, agreementList.size() );
        System.assertEquals(agreementList[0].Contract__c, agreementList[0].Payor__c );
        
        Test.startTest();
        System.runAs(userList[0]){
            CXE_CP_SplashPageSelfRegistration_CC.createUser(
                'first_last_name@yopmail.com', 
                'first', 
                'middle', 
                'last', 
                'Mr', 
                '+639001110011', 
                '293028374839', 
                300, 
                '2018-03-15', 
                false
            );
        }
        
        
        List<User> portalUserList = [SELECT Id, Email FROM User 
                                     WHERE Profile.Name = :CXE_Constants.PORTAL_COMMUNITY_PROFILE
                                     AND Email ='first_last_name@yopmail.com'
                                     AND isActive =TRUE];  
        
        System.runAs(portalUserList[0]){
            List<CXE_Heroku_Model.BillDetail> billDet = CXE_CP_MyBillsSummaryCtlr.retrieveBillingDetails('293028374839');
            

            List<CXE_CP_MyBillsSummaryCtlr.PayTrans> paymentTransactions = new List<CXE_CP_MyBillsSummaryCtlr.PayTrans>();
            CXE_CP_MyBillsSummaryCtlr.PayTrans paymentTransaction = new CXE_CP_MyBillsSummaryCtlr.PayTrans();
            paymentTransaction.accountNum = billDet[0].account_number; 
            paymentTransaction.serviceNum = billDet[0].service_number;
            paymentTransaction.billId = billDet[0].bill_number;
            paymentTransaction.paymentAmount = '500';
            paymentTransaction.accountId = 'sas13';

            paymentTransactions.add(paymentTransaction);


            Test.setMock(HttpCalloutMock.class, new MockCCPay()); 
            try {
            CXE_CP_MyBillsSummaryCtlr.payV2('asasa',
                                            '500',
                                            '0',
                                            '3920.34',
                                            'test',
                                            'test121232@yopmail.com',
                                            'TIMOPA0003',
                                            '110008',
                                            'address',
                                            paymentTransactions,
                                            'PayAsGuestInvoice',
                                            billDet[0].invoice_id, 
                                            billDet[0].bill_number, 
                                            billDet[0].account_number, 
                                            billDet[0].service_number, 
                                            '3920.34',
                                            '3920.34', 
                                            billDet[0].invoice_id, 
                                            billDet[0].service_number,
                                            billDet[0].bill_number, 
                                            billDet[0].invoice_number, 
                                            billDet[0].invoice_number);
            }catch (exception e)
            {}

            //system.assertequals(billDet[0].account_number, null);
        }
        System.assertEquals(1, portalUserList.size() );
        Test.stopTest();
    }
    
    @isTest
    static void test_retrieveCheckConglomerate(){
        //CXE_CP_MyBillsSummaryCtlr con = new CXE_CP_MyBillsSummaryCtlr();
        CXE_CP_MyBillsSummaryCtlr.retrieveCheckConglomerate();
    }
}