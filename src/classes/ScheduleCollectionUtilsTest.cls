@isTest
public class ScheduleCollectionUtilsTest {

    public static testmethod void TestUpdateCaseWithScheduleDepositInfo(){
        
        List<Schedule__c> allSchedules  = TestDataUtils.getTestBillSchedules();
        
        String sysAdmin = CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR;
        //Case cs = TestDataUtils.getTestCase();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;
        
        Case cs = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
        cs.RecordTypeID = servRecTypeId;
        cs.ContactId = contactRecord.id;
        cs.Individual_Business_Tag__c = 'No';
        cs.Residential_Non_Residential_Tag__c = 'Yes';
        cs.PSIC__c = psicRecord[1].id;
        cs.Initial_Responsible_Office__c = 'RO1';
        cs.Applied_Load__c = 0.1;
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_RES;
        cs.Home_Ownership__c = 'Owned';
        cs.Application_for_Business_Service__c = false;
        cs.Application_for_Residential_Service__c = true;
        cs.Application_for_Business_Customer__c = false;
        cs.Application_for_Residential_Customer__c = true;
        insert cs;
        
        Test.StartTest();

        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 100);
        cs.PSIC__c = psicRecord[0].id;
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_GSA;
        cs.Application_for_Business_Service__c = true;
        cs.Application_for_Residential_Service__c = false;
        cs.Application_for_Business_Customer__c = true;
        cs.Application_for_Residential_Customer__c = false;
        update cs;
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 1000);
        
        /*Contract testContract = CXE_TestDataFactory.createContract(1, testAccount.Id, null)[0];
        testContract.Case__c = cs.Id;
        insert testContract;

        Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
        addressRec.Case__c = cs.Id;
        addressRec.Contract__c = testContract.Id;
        addressRec.Type__c = 'Billing';
        insert addressRec;
        Test.stopTest();

        Agreement__c testAgreement = CXE_TestDataFactory.createService(1, testAccount.id, null, testContract.Id, psicRecord[0].Id)[0];
        testAgreement.Applied_Load__c = 200;
        insert testAgreement;
        */
        
        Test.StopTest();
    }

     public static testmethod void TestUpdateCaseWithScheduleDepositInfo2(){
        
        List<Schedule__c> allSchedules  = TestDataUtils.getTestBillSchedules();
        
        String sysAdmin = CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR;
        //Case cs = TestDataUtils.getTestCase();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;
        
        Case cs = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
        cs.RecordTypeID = servRecTypeId;
        cs.ContactId = contactRecord.id;
        cs.Individual_Business_Tag__c = 'No';
        cs.Residential_Non_Residential_Tag__c = 'Yes';
        cs.PSIC__c = psicRecord[1].id;
        cs.Initial_Responsible_Office__c = 'RO1';
        cs.Applied_Load__c = 1.1;
        cs.Home_Ownership__c = 'Owned';
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_RES;
        cs.Application_for_Business_Service__c = false;
        cs.Application_for_Residential_Service__c = true;
        cs.Application_for_Business_Customer__c = false;
        cs.Application_for_Residential_Customer__c = true;
        insert cs;
        
        Test.StartTest();

        //cs = TestDataUtils.getTestCase();
        //cs.Applied_Load__c = 1.1;
        //cs.Home_Ownership__c = 'Owned';
        //cs.Application_for_Business_Service__c = false;
        //cs.Application_for_Residential_Service__c = true;
        //cs.Application_for_Business_Customer__c = false;
        //cs.Application_for_Residential_Customer__c = true;
        //update cs;
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 200);
        cs.PSIC__c = psicRecord[0].id;
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_GSA;
        cs.Application_for_Business_Service__c = true;
        cs.Application_for_Residential_Service__c = false;
        cs.Application_for_Business_Customer__c = true;
        cs.Application_for_Residential_Customer__c = false;
        update cs;
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 2000);
        
        Test.StopTest();
    }

     public static testmethod void TestUpdateCaseWithScheduleDepositInfo3(){
        
        List<Schedule__c> allSchedules  = TestDataUtils.getTestBillSchedules();
        
        String sysAdmin = CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR;
        //Case cs = TestDataUtils.getTestCase();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;
        
        Case cs = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
        cs.RecordTypeID = servRecTypeId;
        cs.ContactId = contactRecord.id;
        cs.Individual_Business_Tag__c = 'No';
        cs.Residential_Non_Residential_Tag__c = 'Yes';
        cs.PSIC__c = psicRecord[1].id;
        cs.Initial_Responsible_Office__c = 'RO1';
        cs.Applied_Load__c = 1.6;
        cs.Home_Ownership__c = 'Owned';
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_RES;
        cs.Application_for_Business_Service__c = false;
        cs.Application_for_Residential_Service__c = true;
        cs.Application_for_Business_Customer__c = false;
        cs.Application_for_Residential_Customer__c = true;
        insert cs;
        
        Test.StartTest();
        //cs = TestDataUtils.getTestCase();
        
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 300);
        cs.PSIC__c = psicRecord[0].id;
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_GSA;
        cs.Application_for_Business_Service__c = true;
        cs.Application_for_Residential_Service__c = false;
        cs.Application_for_Business_Customer__c = true;
        cs.Application_for_Residential_Customer__c = false;
        update cs;
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 3000);
        
        
        Test.StopTest();
    }

     public static testmethod void TestUpdateCaseWithScheduleDepositInfo4(){
        
        List<Schedule__c> allSchedules  = TestDataUtils.getTestBillSchedules();
        
        String sysAdmin = CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR;
        //Case cs = TestDataUtils.getTestCase();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;
        
        Case cs = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
        cs.RecordTypeID = servRecTypeId;
        cs.ContactId = contactRecord.id;
        cs.Individual_Business_Tag__c = 'No';
        cs.Residential_Non_Residential_Tag__c = 'Yes';
        cs.PSIC__c = psicRecord[1].id;
        cs.Initial_Responsible_Office__c = 'RO1';
        cs.Applied_Load__c = 2.4;
        cs.Home_Ownership__c = 'Owned';
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_RES;
        cs.Application_for_Business_Service__c = false;
        cs.Application_for_Residential_Service__c = true;
        cs.Application_for_Business_Customer__c = false;
        cs.Application_for_Residential_Customer__c = true;
        insert cs;
        
        Test.StartTest();

        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 400);
        cs.PSIC__c = psicRecord[0].id;
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_GSA;
        cs.Application_for_Business_Service__c = true;
        cs.Application_for_Residential_Service__c = false;
        cs.Application_for_Business_Customer__c = true;
        cs.Application_for_Residential_Customer__c = false;
        update cs;
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 4000);
        
        Test.StopTest();
    }

     public static testmethod void TestUpdateCaseWithScheduleDepositInfo5(){
        
        List<Schedule__c> allSchedules  = TestDataUtils.getTestBillSchedules();
        
        String sysAdmin = CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR;
        //Case cs = TestDataUtils.getTestCase();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;
        
        Case cs = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
        cs.RecordTypeID = servRecTypeId;
        cs.ContactId = contactRecord.id;
        cs.Individual_Business_Tag__c = 'No';
        cs.Residential_Non_Residential_Tag__c = 'Yes';
        cs.PSIC__c = psicRecord[1].id;
        cs.Initial_Responsible_Office__c = 'RO1';
        cs.Applied_Load__c = 3.6;
        cs.Home_Ownership__c = 'Owned';
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_RES;
        cs.Application_for_Business_Service__c = false;
        cs.Application_for_Residential_Service__c = true;
        cs.Application_for_Business_Customer__c = false;
        cs.Application_for_Residential_Customer__c = true;
        insert cs;
        
        Test.StartTest();

        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 500);
        cs.PSIC__c = psicRecord[0].id;
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_GSA;
        cs.Application_for_Business_Service__c = true;
        cs.Application_for_Residential_Service__c = false;
        cs.Application_for_Business_Customer__c = true;
        cs.Application_for_Residential_Customer__c = false;
        update cs;
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 5000);
        
        Test.StopTest();
    }

     public static testmethod void TestUpdateCaseWithScheduleDepositInfo6(){
        
        List<Schedule__c> allSchedules  = TestDataUtils.getTestBillSchedules();
        
        String sysAdmin = CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR;
        //Case cs = TestDataUtils.getTestCase();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;
        
        Case cs = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
        cs.RecordTypeID = servRecTypeId;
        cs.ContactId = contactRecord.id;
        cs.Individual_Business_Tag__c = 'No';
        cs.Residential_Non_Residential_Tag__c = 'Yes';
        cs.PSIC__c = psicRecord[1].id;
        cs.Initial_Responsible_Office__c = 'RO1';
        cs.Applied_Load__c = 4.4;
        cs.Home_Ownership__c = 'Owned';
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_RES;
        cs.Application_for_Business_Service__c = false;
        cs.Application_for_Residential_Service__c = true;
        cs.Application_for_Business_Customer__c = false;
        cs.Application_for_Residential_Customer__c = true;
        insert cs;
       
        Test.StartTest();

        
        update cs;
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 600);
        cs.PSIC__c = psicRecord[0].id;
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_GSA;
        cs.Application_for_Business_Service__c = true;
        cs.Application_for_Residential_Service__c = false;
        cs.Application_for_Business_Customer__c = true;
        cs.Application_for_Residential_Customer__c = false;
        update cs;
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 6000);
        
        // CXE
        cs.Override_Auto_Deposit_Amount__c = true;
        cs.Deposit_Amount__c = 500;
        update cs;
        //ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,true,sysAdmin);
        System.assertEquals(cs.Deposit_Amount__c, 500);


        /*Contract testContract = CXE_TestDataFactory.createContract(1, testAccount.Id, null)[0];
        testContract.Case__c = cs.Id;
        insert testContract;

        Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
        addressRec.Case__c = cs.Id;
        addressRec.Contract__c = testContract.Id;
        addressRec.Type__c = 'Billing';
        insert addressRec;
        Test.stopTest();

        Agreement__c testAgreement = CXE_TestDataFactory.createService(1, testAccount.id, null, testContract.Id, psicRecord[0].Id)[0];
        testAgreement.Applied_Load__c = 200;
        insert testAgreement;
        */
        
        Test.StopTest();
    }
/*
     public static testmethod void TestUpdateCaseWithScheduleDepositInfo7(){
        
        List<Schedule__c> allSchedules  = TestDataUtils.getTestBillSchedules();
        
        String sysAdmin = CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR;
        //Case cs = TestDataUtils.getTestCase();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;
        
        Case cs = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
        cs.RecordTypeID = servRecTypeId;
        cs.ContactId = contactRecord.id;
        cs.Individual_Business_Tag__c = 'No';
        cs.Residential_Non_Residential_Tag__c = 'Yes';
        cs.PSIC__c = psicRecord[1].id;
        cs.Initial_Responsible_Office__c = 'RO1';
        cs.Home_Ownership__c = 'Owned';
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_GSA;
        cs.Applied_Load__c = 0.1;
        cs.Application_for_Business_Service__c = false;
        cs.Application_for_Residential_Service__c = true;
        cs.Application_for_Business_Customer__c = false;
        cs.Application_for_Residential_Customer__c = true;
        cs.Override_Auto_Deposit_Amount__c = true;
        cs.Deposit_Amount__c = 500;
        insert cs;
       
        Test.StartTest();
        
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,true,sysAdmin);
        System.assertEquals(cs.Deposit_Amount__c, 500);
        
        Test.StopTest();
    }

    //START RReyes 04/24
    public static testmethod void TestUpdateCaseWithScheduleDepositInfo8(){
        
        List<Schedule__c> allSchedules  = TestDataUtils.getTestBillSchedules();
        
        String sysAdmin = CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR;
        String mecG4 = CXE_Constants.PROFILE_NAME_MERALCO_G4;
        //Case cs = TestDataUtils.getTestCase();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        List<Case> cs = CXE_TestDataFactory.createCase(3, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        cs[0].RecordTypeID = servRecTypeId;
        cs[0].ContactId = contactRecord.id;
        cs[0].Individual_Business_Tag__c = 'No';
        cs[0].Residential_Non_Residential_Tag__c = 'Yes';
        cs[0].PSIC__c = psicRecord.id;
        cs[0].Initial_Responsible_Office__c = 'RO1';
        cs[0].applied_load__c = 6;

        cs[1].RecordTypeID = servRecTypeId;
        cs[1].ContactId = contactRecord.id;
        cs[1].Individual_Business_Tag__c = 'No';
        cs[1].Residential_Non_Residential_Tag__c = 'Yes';
        cs[1].PSIC__c = psicRecord.id;
        cs[1].Initial_Responsible_Office__c = 'RO1';
        cs[1].Override_Auto_Deposit_Amount__c = true;
        cs[1].Deposit_Amount__c = 500;

        cs[2].RecordTypeID = servRecTypeId;
        cs[2].ContactId = contactRecord.id;
        cs[2].Individual_Business_Tag__c = 'No';
        cs[2].Residential_Non_Residential_Tag__c = 'Yes';
        cs[2].PSIC__c = psicRecord.id;
        cs[2].Initial_Responsible_Office__c = 'RO1';
        cs[2].Deposit_Amount__c = 1500;

        insert cs;
       
        Test.StartTest();
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs[1],allSchedules,cs[2],true,mecG4);
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs[1],allSchedules,cs[2],true,'InvalidProfile');
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs[0],allSchedules,cs[0],true,sysAdmin);
        System.assertEquals(cs[0].Bill_Deposit_Schedule__c, null);
        
        Test.StopTest();
    }
*/
    public static testmethod void testUpdateServiceWithScheduleDepositInfoS1(){
        
        List<Schedule__c> allSchedules  = TestDataUtils.getTestBillSchedules();
        
        String sysAdmin = CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR;
        //Case cs = TestDataUtils.getTestCase();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount; 

        Case cs = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
        cs.status = 'Application Received';
        cs.RecordTypeID = servRecTypeId;
        cs.ContactId = contactRecord.id;
        cs.Individual_Business_Tag__c = 'No';
        cs.Residential_Non_Residential_Tag__c = 'Yes';
        cs.PSIC__c = psicRecord.id;
        cs.Initial_Responsible_Office__c = 'RO1';
        insert cs;
       
        Contract createdContract = CXE_TestDataFactory.createContract(1, testAccount.Id, cs.Id)[0];
        createdContract.Type__c = 'Regular';
        insert createdContract; 

        Address__c addressRec = CXE_TestDataFactory.createAddressWithoutReference('Billing', cs.Id, testAccount.Id, createdContract.Id, null, null, null);
        insert addressRec;

        List<Agreement__c> testAgreementList = CXE_TestDataFactory.createService(6, testAccount.id, cs.id, createdContract.Id, psicRecord.Id);
        
        testAgreementList[0].Rate__c = 'General Service A (GSA)';
        testAgreementList[1].Rate__c = 'General Service A (GSA)';
        testAgreementList[2].Rate__c = 'General Service A (GSA)';
        testAgreementList[3].Rate__c = 'General Service A (GSA)';
        testAgreementList[4].Rate__c = 'General Service A (GSA)';
        testAgreementList[5].Rate__c = 'General Service A (GSA)';
        
        
        testAgreementList[0].Billing_Class__c = 'General Service A (GSA)';
        testAgreementList[1].Billing_Class__c = 'General Service A (GSA)';
        testAgreementList[2].Billing_Class__c = 'General Service A (GSA)';
        testAgreementList[3].Billing_Class__c = 'General Service A (GSA)';
        testAgreementList[4].Billing_Class__c = 'General Service A (GSA)';
        testAgreementList[5].Billing_Class__c = 'General Service A (GSA)';
        
        testAgreementList[0].applied_load__c = 0.5;
        testAgreementList[1].applied_load__c = 1.3;
        testAgreementList[2].applied_load__c = 1.8;
        testAgreementList[3].applied_load__c = 2.5;
        testAgreementList[4].applied_load__c = 3.5;
        testAgreementList[5].applied_load__c = 4.1;
        testAgreementList[0].Override_Auto_Deposit_Amount__c = false;
        testAgreementList[1].Override_Auto_Deposit_Amount__c = false;
        testAgreementList[2].Override_Auto_Deposit_Amount__c = false;
        testAgreementList[3].Override_Auto_Deposit_Amount__c = false;
        testAgreementList[4].Override_Auto_Deposit_Amount__c = false;
        testAgreementList[5].Override_Auto_Deposit_Amount__c = false;
        insert testAgreementList;

        ScheduleCollectionUtils.UpdateServiceWithScheduleDepositInfo(testAgreementList[0], allSchedules, testAgreementList[0] , false, sysAdmin, cs);
        System.assertNotEquals(cs.Deposit_Amount__c, 0);
        ScheduleCollectionUtils.UpdateServiceWithScheduleDepositInfo(testAgreementList[1], allSchedules, testAgreementList[1] , false, sysAdmin, cs);
        System.assertNotEquals(cs.Deposit_Amount__c, 0);
        ScheduleCollectionUtils.UpdateServiceWithScheduleDepositInfo(testAgreementList[2], allSchedules, testAgreementList[2] , false, sysAdmin, cs);
        System.assertNotEquals(cs.Deposit_Amount__c, 0);
        ScheduleCollectionUtils.UpdateServiceWithScheduleDepositInfo(testAgreementList[3], allSchedules, testAgreementList[3] , false, sysAdmin, cs);
        System.assertNotEquals(cs.Deposit_Amount__c, 0);
        ScheduleCollectionUtils.UpdateServiceWithScheduleDepositInfo(testAgreementList[4], allSchedules, testAgreementList[4] , false, sysAdmin, cs);
        System.assertNotEquals(cs.Deposit_Amount__c, 0);
        ScheduleCollectionUtils.UpdateServiceWithScheduleDepositInfo(testAgreementList[5], allSchedules, testAgreementList[5] , false, sysAdmin, cs);
        System.assertNotEquals(cs.Deposit_Amount__c, 0);
    }
/*
        public static testmethod void testUpdateServiceWithScheduleDepositInfoS2(){
        
        List<Schedule__c> allSchedules  = TestDataUtils.getTestBillSchedules();
        
        String sysAdmin = CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR;
        String mecG4 = CXE_Constants.PROFILE_NAME_MERALCO_G4;
        //Case cs = TestDataUtils.getTestCase();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;
        
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount; 

        Case cs = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
        cs.status = 'Application Received';
        cs.RecordTypeID = servRecTypeId;
        cs.ContactId = contactRecord.id;
        cs.Individual_Business_Tag__c = 'No';
        cs.Residential_Non_Residential_Tag__c = 'Yes';
        cs.PSIC__c = psicRecord[1].id;
        cs.Initial_Responsible_Office__c = 'RO1';
        cs.Home_Ownership__c = 'Owned';
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_GSA;
        cs.Application_for_Business_Service__c = false;
        cs.Application_for_Residential_Service__c = true;
        cs.Application_for_Business_Customer__c = false;
        cs.Application_for_Residential_Customer__c = true;
        cs.Override_Auto_Deposit_Amount__c = true;
        insert cs;
       
        Contract createdContract = CXE_TestDataFactory.createContract(1, testAccount.Id, cs.Id)[0];
        createdContract.Type__c = 'Regular';
        insert createdContract; 

        Address__c addressRec = CXE_TestDataFactory.createAddressWithoutReference('Billing', cs.Id, testAccount.Id, createdContract.Id, null, null, null);
        insert addressRec;

        List<Agreement__c> testAgreementList = CXE_TestDataFactory.createService(3, testAccount.id, cs.id, createdContract.Id, psicRecord[1].Id);
        
        testAgreementList[0].Rate__c = 'General Service A (GSA)';
        testAgreementList[1].Rate__c = 'General Service A (GSA)';
        testAgreementList[2].Rate__c = 'General Service A (GSA)';
        
        
        testAgreementList[0].Billing_Class__c = 'General Service A (GSA)';
        testAgreementList[1].Billing_Class__c = 'General Service A (GSA)';
        testAgreementList[2].Billing_Class__c = 'General Service A (GSA)';

 
 
        testAgreementList[0].applied_load__c = 0.5;
        testAgreementList[1].applied_load__c = 6;
        testAgreementList[2].Deposit_Amount__c = 1050;
        testAgreementList[0].Override_Auto_Deposit_Amount__c = true;
        testAgreementList[1].Override_Auto_Deposit_Amount__c = false;
        insert testAgreementList;

        ScheduleCollectionUtils.UpdateServiceWithScheduleDepositInfo(testAgreementList[0], allSchedules, testAgreementList[2], true, mecG4, cs);
        ScheduleCollectionUtils.UpdateServiceWithScheduleDepositInfo(testAgreementList[0], allSchedules, testAgreementList[2], true, 'InvalidProfile', cs);
        //System.assertNotEquals(cs.Deposit_Amount__c, 0);
        ScheduleCollectionUtils.UpdateServiceWithScheduleDepositInfo(testAgreementList[1], allSchedules, testAgreementList[1] , false, sysAdmin, cs);
        System.assertEquals(testAgreementList[1].Deposit_Schedule__c, null);
    }
    //END RReyes 04/24
*/

     public static testmethod void TestUpdateCaseWithScheduleDepositInfo7(){
        
        List<Schedule__c> allSchedules  = TestDataUtils.getTestBillSchedules();
        
        String sysAdmin = CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR;
        //Case cs = TestDataUtils.getTestCase();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;
        
        Case cs = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
        cs.RecordTypeID = servRecTypeId;
        cs.ContactId = contactRecord.id;
        cs.Individual_Business_Tag__c = 'No';
        cs.Residential_Non_Residential_Tag__c = 'Yes';
        cs.PSIC__c = psicRecord[1].id;
        cs.Initial_Responsible_Office__c = 'RO1';
        cs.Applied_Load__c = 40;
        cs.Home_Ownership__c = 'Owned';
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_RES;
        cs.Application_for_Business_Service__c = false;
        cs.Application_for_Residential_Service__c = true;
        cs.Application_for_Business_Customer__c = false;
        cs.Application_for_Residential_Customer__c = true;
        insert cs;
        
        Test.StartTest();

        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 1000);
        //cs.PSIC__c = psicRecord[0].id;
        //cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_GSA;
        cs.Application_for_Business_Service__c = true;
        cs.Application_for_Residential_Service__c = false;
        cs.Application_for_Business_Customer__c = true;
        cs.Application_for_Residential_Customer__c = false;
        update cs;
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,false,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 1000);
        
        Test.StopTest();
    }

    public static testmethod void TestUpdateCaseWithScheduleDepositInfo8(){
        
        List<Schedule__c> allSchedules  = TestDataUtils.getTestBillSchedules();
        
        String sysAdmin = CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR;
        //Case cs = TestDataUtils.getTestCase();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_RECONTRACT_OF_ELECTRIC_SERVICE).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;
        
        Case cs = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
        cs.RecordTypeID = servRecTypeId;
        cs.ContactId = contactRecord.id;
        cs.Individual_Business_Tag__c = 'No';
        cs.Residential_Non_Residential_Tag__c = 'Yes';
        cs.PSIC__c = psicRecord[1].id;
        cs.Initial_Responsible_Office__c = 'RO1';
        cs.Applied_Load__c = 3.6;
        cs.Home_Ownership__c = 'Owned';
        cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_RES;
        cs.Application_for_Business_Service__c = false;
        cs.Application_for_Residential_Service__c = true;
        cs.Application_for_Business_Customer__c = false;
        cs.Application_for_Residential_Customer__c = true;
        insert cs;
        
        Test.StartTest();

        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,true,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 500);
        //cs.PSIC__c = psicRecord[0].id;
        //cs.Service_Rate_Type__c = CXE_Constants.SERVICE_RATE_TYPE_GSA;
        cs.Application_for_Business_Service__c = true;
        cs.Application_for_Residential_Service__c = false;
        cs.Application_for_Business_Customer__c = true;
        cs.Application_for_Residential_Customer__c = false;
        cs.Reason_for_Manual_Deposit_Input__c = 'aa';
        update cs;
        ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(cs,allSchedules,cs,true,sysAdmin, false, false, false);
        System.assertEquals(cs.Deposit_Amount__c, 500);
        
        Test.StopTest();
    }
}