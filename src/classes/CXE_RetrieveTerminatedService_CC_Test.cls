/* Description: CXE_RetrieveTerminatedService_CC test class
 * Author: Rom Edison Reyes
 * Date Created: JUL-11-17
 */
@isTest
private class CXE_RetrieveTerminatedService_CC_Test{

static testMethod void testRetrieveFromSFBusinessAccount(){   
    
    List<Case> casesToInsert = new List<Case>(); 
    List<Address__c> lstAddresses = new List<Address__c>();

    //List<Schedule__c> scheduleRecord = CXE_TestDataFactory.createSchedule(5);
    //insert scheduleRecord;
    
    Account testAccount = CXE_TestDataFactory.createBusinessAccount(1)[0];
    insert testAccount;

    //Contact testContact = CXE_TestDataFactory.createContact(1)[0];
    //insert testContact;
    
    PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
    insert psicRecord;
    
    Case testNSACase = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
    //testNSACase.ContactId = testContact.id;
    testNSACase.Individual_Business_Tag__c = 'No';
    testNSACase.Residential_Non_Residential_Tag__c = 'Yes';
    testNSACase.PSIC__c = psicRecord.id;
    testNSACase.Initial_Responsible_Office__c = 'RO1';
    testNSACase.Date_of_Birth__c = date.newInstance(1995, 1, 1);
    testNSACase.Tax_Identification_No__c = '123';
    testNSACase.AccountId = testAccount.Id;
            
    Case testRSACase = CXE_TestDataFactory.createRecontractCase(1, '')[0];
    testRSACase.CXE_Previous_SIN__c = '827364536273';

    casesToInsert.add(testNSACase);
    casesToInsert.add(testRSACase);
    insert casesToInsert;

    Test.startTest();    
    Contract testContract = CXE_TestDataFactory.createContract(1, testAccount.Id, casesToInsert[0].Id)[0];
    insert testContract;

    Address__c testServiceAddressNSA = CXE_TestDataFactory.createAddressWithoutReference('Service',casesToInsert[0].Id, testAccount.Id, testContract.Id, null, null, null);
    Address__c testBillingAddressNSA = CXE_TestDataFactory.createAddressWithoutReference('Billing',casesToInsert[0].Id, testAccount.Id, testContract.Id, null, null, null);
    lstAddresses.add(testServiceAddressNSA);
    lstAddresses.add(testBillingAddressNSA);
    insert lstAddresses;

    Agreement__c testService = CXE_TestDataFactory.createService(1, testAccount.Id, casesToInsert[0].Id, testContract.Id, psicRecord.Id)[0];
    testService.SIN__c = '827364536273';
    testService.Service_Status__c = 'Active';
    insert testService;
    
    Address__c testAddressRSA = CXE_TestDataFactory.createAddressWithoutReference('Service',casesToInsert[1].Id, testAccount.Id, testContract.Id, testService.Id, null, null);
    insert testAddressRSA;
    
    
    String status = CXE_RetrieveTerminatedService_CC.updateCase(casesToInsert[1].Id);
    System.assertEquals(status, 'The SIN you entered is currently active and not eligible for recontracting.');
    Test.stopTest();
}

static testMethod void testRetrieveFromSFIndividualAccount(){   
    
    List<Case> casesToInsert = new List<Case>(); 
    List<Address__c> lstAddresses = new List<Address__c>();
    
    Account testAccount = CXE_TestDataFactory.createPersonAccount(1)[0];
    insert testAccount;
	
    //PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
    //insert psicRecord;
    
    Case testNSACase = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
    testNSACase.Application_for_Business_Customer__c = false;
    testNSACase.Application_for_Business_Service__c = true;
    testNSACase.Application_for_Residential_Customer__c = true;
    testNSACase.Application_for_Residential_Service__c = false;
    testNSACase.Individual_Business_Tag__c = 'No';
    testNSACase.Residential_Non_Residential_Tag__c = 'Yes';
    //testNSACase.PSIC__c = psicRecord.id;
    testNSACase.Initial_Responsible_Office__c = 'RO1';
    testNSACase.Date_of_Birth__c = date.newInstance(1995, 1, 1);
    testNSACase.Tax_Identification_No__c = '123';
    testNSACase.AccountId = testAccount.Id;
         
    insert testNSACase;

    Contract testContract = CXE_TestDataFactory.createContract(1, testAccount.Id, testNSACase.Id)[0];
    insert testContract;

    //Address__c testServiceAddressNSA = CXE_TestDataFactory.createAddressWithoutReference('Service',casesToInsert[0].Id, testAccount.Id, testContract.Id, null, null, null);
    Address__c testBillingAddressNSA = CXE_TestDataFactory.createAddressWithoutReference('Billing',testNSACase.Id, testAccount.Id, testContract.Id, null, null, null);
    //lstAddresses.add(testServiceAddressNSA);
    lstAddresses.add(testBillingAddressNSA);
    insert lstAddresses;
   
    Agreement__c testService = CXE_TestDataFactory.createService(1, testAccount.Id, testNSACase.Id, testContract.Id, null)[0];
    testService.SIN__c = '827364536273';
    testService.Service_Status__c = 'Terminated';
    insert testService;

    //casesToInsert.add(testNSACase);
    //casesToInsert.add(testRSACase);
    

    Test.startTest();

    Address__c testServiceAddressRSA = CXE_TestDataFactory.createAddressWithoutReference('Service',null, testAccount.Id, testContract.Id, testService.Id, null, null);
    testServiceAddressRSA.Service__c = testService.Id;
    insert testServiceAddressRSA;

    Case testRSACase = CXE_TestDataFactory.createRecontractCase(1, '')[0];
    testRSACase.CXE_Previous_SIN__c = '827364536273';
    insert testRSACase;
    
    testService.Service_Status__c = 'Active';
    update testService;

    String status = CXE_RetrieveTerminatedService_CC.updateCase(testRSACase.Id);
    System.assertEquals(status, 'The SIN you entered is currently active and not eligible for recontracting.');
    Test.stopTest();
}

static testMethod void testRetrieveFromSFNonTerminatedService(){   
    
    List<Case> casesToInsert = new List<Case>(); 
    List<Address__c> lstAddresses = new List<Address__c>();
    
    Account testAccount = CXE_TestDataFactory.createBusinessAccount(1)[0];
    insert testAccount;
    
    PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
    insert psicRecord;
    
    Case testNSACase = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
    //testNSACase.ContactId = testContact.id;
    testNSACase.Individual_Business_Tag__c = 'No';
    testNSACase.Residential_Non_Residential_Tag__c = 'Yes';
    testNSACase.PSIC__c = psicRecord.id;
    testNSACase.Initial_Responsible_Office__c = 'RO1';
    testNSACase.Date_of_Birth__c = date.newInstance(1995, 1, 1);
    testNSACase.Tax_Identification_No__c = '123';
    testNSACase.AccountId = testAccount.Id;
            
    

    //casesToInsert.add(testNSACase);
    //casesToInsert.add(testRSACase);
    insert testNSACase;

    Contract testContract = CXE_TestDataFactory.createContract(1, testAccount.Id, testNSACase.Id)[0];
    insert testContract;

    Address__c testServiceAddressNSA = CXE_TestDataFactory.createAddressWithoutReference('Service',testNSACase.Id, testAccount.Id, testContract.Id, null, null, null);
    Address__c testBillingAddressNSA = CXE_TestDataFactory.createAddressWithoutReference('Billing',testNSACase.Id, testAccount.Id, testContract.Id, null, null, null);
    lstAddresses.add(testServiceAddressNSA);
    lstAddresses.add(testBillingAddressNSA);
    insert lstAddresses;

    Agreement__c testService = CXE_TestDataFactory.createService(1, testAccount.Id, testNSACase.Id, testContract.Id, psicRecord.Id)[0];
    testService.SIN__c = '827364536273';
    testService.Service_Status__c = 'Active';
    insert testService;
    
    Test.startTest();   

    try
    {
        Case testRSACase = CXE_TestDataFactory.createRecontractCase(1, '')[0];
        testRSACase.CXE_Previous_SIN__c = '827364536273';
        insert testRSACase;
        
        
        Address__c testAddressRSA = CXE_TestDataFactory.createAddressWithoutReference('Service',testRSACase.Id, testAccount.Id, testContract.Id, testService.Id, null, null);
        insert testAddressRSA;
        String status = CXE_RetrieveTerminatedService_CC.updateCase(testRSACase.Id);
    } 
    catch (exception e)
    {
        system.assertequals(true , e.getMessage().contains(CXE_Constants.CASE_ERROR_ONLY_TERMINATED));
    }

     
    
    Test.stopTest();
}

static testMethod void testServiceAlreadyRetrieved(){   
               
    Case testRSACase = CXE_TestDataFactory.createRecontractCase(1, '')[0];
    testRSACase.CXE_Previous_SIN__c = '827364536273';
    testRSACase.CXE_isServiceRetrieved__c = true;
    insert testRSACase;

    Test.startTest();    
    String status = CXE_RetrieveTerminatedService_CC.updateCase(testRSACase.Id);
    System.assertEquals(CXE_Constants.CASE_ERROR_ALREADY_RETRIEVED, status);
    Test.stopTest();
}


static testMethod void testNoPreviousSIN(){   
               
    Case testRSACase = CXE_TestDataFactory.createRecontractCase(1, '')[0];
    insert testRSACase;

    Test.startTest();    
    String status = CXE_RetrieveTerminatedService_CC.updateCase(testRSACase.Id);
    System.assertEquals(CXE_Constants.CASE_ERROR_NO_PREVIOUS_SIN, status);
    Test.stopTest();
}

/*static testMethod void testDuplicateRecontract(){   
               
    List<Case> lstRSACase = CXE_TestDataFactory.createRecontractCase(2, '827364536273');
    insert lstRSACase;

    Test.startTest();    
    String status = CXE_RetrieveTerminatedService_CC.updateCase(lstRSACase[0].Id);
    System.assertEquals(CXE_Constants.CASE_MODIFICATION_ERROR_DUPLICATE_OR_PENDING_CASE_EXIST, status);
    Test.stopTest();
}

static testMethod void testDuplicateRecontractApplicationClosed(){   
               
    List<Case> lstRSACase = CXE_TestDataFactory.createRecontractCase(2, '827364536273');
    lstRSACase[0].Status = CXE_Constants.CASE_APPLICATION_CLOSED;
    insert lstRSACase;

    Test.startTest();    
    String status = CXE_RetrieveTerminatedService_CC.updateCase(lstRSACase[1].Id);
    System.assertEquals(CXE_Constants.CASE_ERROR_SIN_ALREADY_RECONTRACTED, status);
    Test.stopTest();
}*/

static testMethod void testValidateStatusSuccess(){   
               
    Case testRSACase = CXE_TestDataFactory.createRecontractCase(1, '827364536273')[0];
    insert testRSACase;

    Test.startTest();    
    String status = CXE_RetrieveTerminatedService_CC.validateCaseStatus(testRSACase.Id);
    System.assertEquals('Success', status);
    Test.stopTest();
}

static testMethod void testValidateStatusInvalid(){   
               
    Case testRSACase = CXE_TestDataFactory.createRecontractCase(1, '827364536273')[0];
    testRSACase.Status = CXE_Constants.CASE_APPLICATION_EVALUATED;
    insert testRSACase;

    Test.startTest();    
    String status = CXE_RetrieveTerminatedService_CC.validateCaseStatus(testRSACase.Id);
    System.assertEquals('You cannot retrieve service if status is already Application Evaluated or beyond.', status);
    Test.stopTest();
}

static testMethod void testValidateStatusNoCaseId(){   
               
    Test.startTest();    
    String status = CXE_RetrieveTerminatedService_CC.validateCaseStatus(null);
    System.assertEquals('Invalid Case Id.', status);
    Test.stopTest();
}

static testMethod void testValidateStatusNotRecontract(){   

    Account testAccount = CXE_TestDataFactory.createBusinessAccount(1)[0];
    insert testAccount;
    
    PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
    insert psicRecord;
    
    Case testNSACase = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
    testNSACase.Individual_Business_Tag__c = 'No';
    testNSACase.Residential_Non_Residential_Tag__c = 'Yes';
    testNSACase.PSIC__c = psicRecord.id;
    testNSACase.Initial_Responsible_Office__c = 'RO1';
    testNSACase.Date_of_Birth__c = date.newInstance(1995, 1, 1);
    testNSACase.Tax_Identification_No__c = '123';
    testNSACase.AccountId = testAccount.Id;
    
    insert testNSACase;    

    Test.startTest();    
    String status = CXE_RetrieveTerminatedService_CC.validateCaseStatus(testNSACase.Id);
    System.assertEquals('You can only retrieve service on recontract cases.', status);
    Test.stopTest();
}

static testMethod void testCallout(){   
        Account testAccount = CXE_TestDataFactory.createBusinessAccount(1)[0];
        testAccount.V10_Customer_No__c = '19785';
        insert testAccount;

        Case testRSACase = CXE_TestDataFactory.createRecontractCase(1, '')[0];
        testRSACase.CXE_Previous_SIN__c = '536472263542';
        insert testRSACase;

        List<Integration_Settings__c> lstIntegSettings= CXE_TestDataFactory.createIntegrationSettings();
        insert lstIntegSettings;

        Reference__c r = new Reference__c();
        r.Name = 'Single Commercial';
        r.Type__c = 'Picklist';
        r.Name_Code__c = 'PLTYP00003';
        r.Field__c = 'Premises Type';
        insert r;

        Office__c off = new Office__c();
        off.CMSv10_Office_Code__c  = '1000167';
        off.Name = '1000167';
        insert off;


        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockRetrieveTerminatedService());    
        String status = CXE_RetrieveTerminatedService_CC.updateCase(testRSACase.Id);
        System.assertEquals('Success', status);
        Test.stopTest();
    }
    
    @isTest
    static void test_getResponsibleOffice()
    {
        test.startTest();       
            
            CXE_RetrieveTerminatedService_CC.getResponsibleOffice('Test');
        test.stopTest();
    }

static testMethod void testRetrieveFromSFIndividualAccount_TerminatedService(){   
    
    List<Case> casesToInsert = new List<Case>(); 
    List<Address__c> lstAddresses = new List<Address__c>();
    
    Account testAccount = CXE_TestDataFactory.createPersonAccount(1)[0];
    insert testAccount;
    
    //PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
    //insert psicRecord;
    
    Case testNSACase = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
    testNSACase.Application_for_Business_Customer__c = false;
    testNSACase.Application_for_Business_Service__c = true;
    testNSACase.Application_for_Residential_Customer__c = true;
    testNSACase.Application_for_Residential_Service__c = false;
    testNSACase.Individual_Business_Tag__c = 'No';
    testNSACase.Residential_Non_Residential_Tag__c = 'Yes';
    //testNSACase.PSIC__c = psicRecord.id;
    testNSACase.Initial_Responsible_Office__c = 'RO1';
    testNSACase.Date_of_Birth__c = date.newInstance(1995, 1, 1);
    testNSACase.Tax_Identification_No__c = '123';
    testNSACase.AccountId = testAccount.Id;
         
    insert testNSACase;

    Contract testContract = CXE_TestDataFactory.createContract(1, testAccount.Id, testNSACase.Id)[0];
    insert testContract;

    //Address__c testServiceAddressNSA = CXE_TestDataFactory.createAddressWithoutReference('Service',casesToInsert[0].Id, testAccount.Id, testContract.Id, null, null, null);
    Address__c testBillingAddressNSA = CXE_TestDataFactory.createAddressWithoutReference('Billing',testNSACase.Id, testAccount.Id, testContract.Id, null, null, null);
    //lstAddresses.add(testServiceAddressNSA);
    lstAddresses.add(testBillingAddressNSA);
    insert lstAddresses;
   
    Agreement__c testService = CXE_TestDataFactory.createService(1, testAccount.Id, testNSACase.Id, testContract.Id, null)[0];
    testService.SIN__c = '827364536273';
    testService.Service_Status__c = 'Terminated';
    insert testService;

    //casesToInsert.add(testNSACase);
    //casesToInsert.add(testRSACase);
    

    Test.startTest();

    Address__c testServiceAddressRSA = CXE_TestDataFactory.createAddressWithoutReference('Service',null, testAccount.Id, testContract.Id, testService.Id, null, null);
    testServiceAddressRSA.Service__c = testService.Id;
    insert testServiceAddressRSA;

    Case testRSACase = CXE_TestDataFactory.createRecontractCase(1, '')[0];
    testRSACase.CXE_Previous_SIN__c = '827364536273';
    insert testRSACase;

    String status = CXE_RetrieveTerminatedService_CC.updateCase(testRSACase.Id);
    System.assertEquals('Success', status);
    Test.stopTest();
}

}