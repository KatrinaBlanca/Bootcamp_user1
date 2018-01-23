/* Description: CXE_CreateAccountContactOnCase_CMP test class
 * Author: Michael Lasala
 * Date Created: FEB-15-17
 */
 @isTest
 public class CXE_CreateAccountContactOnCase_CC_Test {
    //BEGIN Account Methods --------------------------------------------------
    static testMethod void test_getCaseDetails() {
        Case createdCase = createCase();
        Test.StartTest();
        Case cs = CXE_CreateAccountContactOnCase_CC.getCaseDetails(createdCase.Id);
        Test.StopTest();
        
        System.assertNotEquals(null, cs);
    }
    
    static testMethod void test_getRelatedAccount_Business() {
        Account acct = createAccount();
        Case createdCase = createCase();
        Test.StartTest();
        List<Account> acctList = CXE_CreateAccountContactOnCase_CC.getRelatedAccounts(createdCase);
        Test.StopTest();
        
        System.assert(acctList.size() > 0);
    }
    
    static testMethod void test_getRelatedAccount_Residential() {
        Account acct = createAccountPerson();
        Case createdCase = createCaseRes();
        Test.StartTest();
        List<Account> acctList = CXE_CreateAccountContactOnCase_CC.getRelatedAccounts(createdCase);
        Test.StopTest();
        
        System.assert(acctList.size() > 0);
    }
    
    static testMethod void test_createAccount_Business() {
        Case createdCase = createCase();
        createdCase.Application_for_Business_Customer__c = true;
        update createdCase;
        
        Test.StartTest();
        CXE_CreateAccountContactOnCase_CC.createAccount(createdCase);
        Test.StopTest();
        
        //System.assertNotEquals(null, acct);
    }
    
    static testMethod void test_createAccount_Residential() {
        Case createdCase = createCaseRes();
        createdCase.Application_for_Residential_Customer__c = true;
        update createdCase;
        Test.StartTest();
        CXE_CreateAccountContactOnCase_CC.createAccount(createdCase);
        Test.StopTest();
        
        //System.assertNotEquals(null, acct);
    }
    
    static testMethod void test_relateCaseToAccount(){
        Account acct = createAccountPerson();
        Case createdCase = createCaseRes();
        Test.StartTest();
        CXE_CreateAccountContactOnCase_CC.relateExistingAccount(createdCase.Id, acct.Id);
        Id acctID = [SELECT AccountId FROM Case WHERE Id =: createdCase.Id].AccountId;
        Test.StopTest();
        
        System.assertEquals(acct.Id, acctID);
    }
    
    /*private static Account createAccount(Boolean isBusiness){
        List<Account> testAccountList = new List<Account>();
        if(isBusiness){
            testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
            testAccountList.get(0).Name = 'Business Account';
            testAccountList.get(0).Email__c = 'test@test.com';
        }else{
            testAccountList = CXE_TestDataFactory.createPersonAccount(1);
            testAccountList.get(0).PersonEmail = 'test@test.com';
            testAccountList.get(0).FirstName = 'FName';
            testAccountList.get(0).LastName = 'LName';
        }
        
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        return testAccount;
    }*/

    /* Description: Create Account Business
     * Author: Christian Peter Doctolero
     * Date Created: MAR-31-17
     */
    private static testMethod Account createAccount(){
        List<Account> testAccountList = new List<Account>();
        testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        testAccountList.get(0).Name = 'Business Account';
        testAccountList.get(0).Email__c = 'test@test.com';
        
        
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        return testAccount;
    }

    /* Description: Create Account Person
     * Author: Christian Peter Doctolero
     * Date Created: MAR-31-17
     */
    private static testMethod Account createAccountPerson(){
        List<Account> testAccountList = new List<Account>();

        testAccountList = CXE_TestDataFactory.createPersonAccount(1);
        testAccountList.get(0).PersonEmail = 'test@test.com';
        testAccountList.get(0).FirstName = 'FName';
        testAccountList.get(0).LastName = 'LName';

        
        Account testAccount = testAccountList.get(0);
        insert testAccount;
        return testAccount;
    }

    
    /*private static Case createCase(Boolean isBusiness){
        List<Case> caseList = CXE_TestDataFactory.createCase(1, 'New Service', 'Single meter', 'Application Received', 'Private');
        Case caseRecord = new Case();
        //caseRecord.Application_Type_Subtype__c = 'New Service';
        //caseRecord.Multimetering__c = 'Single meter';
        //caseRecord.Status = 'Application Received';
        //caseRecord.Customer_Type__c = 'Private';
        caseRecord.Telephone_No__c = '+6325674832';
        caseRecord.Billing_Address_Barangay__c  = 'SAN LORENZO';
        caseRecord.Billing_Address_City_Municipal__c = 'MAKATI CITY';
        caseRecord.Conglomerate_Tag__c = true;
        caseRecord.Date_of_Birth__c = System.today() - 30;
        caseRecord.Email_Address__c = 'test@test.com';
        caseRecord.First_Name__c = 'FName';
        caseRecord.Last_Name__c = 'LName';
        caseRecord.Billing_Address_Street_No__c = '123';
        caseRecord.Last_Name_Business_Name__c = 'Business Account';
        caseRecord.Middle_Name__c = 'Middle';
        caseRecord.Mobile_No__c =   '+631234567890';
        caseRecord.Billing_Address_Province__c = 'METRO MANILA';
        caseRecord.Billing_Address_Street_Name__c = 'Paseo St.';
        caseRecord.Billing_Address_Subdivision__c = 'Insular Building';
        caseRecord.Billing_Address_Unit_No__c= 'Unit 2';
        caseRecord.Tax_Identification_No__c= '123456789011';
        if(isBusiness){
            caseRecord.Application_for_Business_Customer__c = true;
            caseRecord.Application_for_Business_Service__c = true;
        }else{
            caseRecord.Application_for_Residential_Customer__c = true;
            caseRecord.Application_for_Residential_Service__c = true;
            caseRecord.Home_Ownership__c = 'Owned';
        }
        
        insert caseRecord;
        
        //Address__c testAddress = new Address__c(Case__c = caseRecord.Id, Type__c = 'Billing');
        //createAddressWithoutReference(addressType, caseId, acctId, contractId, serviceId, contactId, connectionId)
        Address__c testAddress = CXE_TestDataFactory.createAddressWithoutReference('Billing', caseRecord.Id, null, null, null, null, null);
        insert testAddress;
        
        return caseRecord;
    }*/

    /* Description: Create Case Business
     * Author: Christian Peter Doctolero
     * Date Created: MAR-31-17
     */
    private static testMethod Case createCase(){
        List<Case> caseList = CXE_TestDataFactory.createCase(1, 'New Service', 'Single meter', 'Application Received', 'Private');
        Case caseRecord = new Case();
        //caseRecord.Application_Type_Subtype__c = 'New Service';
        //caseRecord.Multimetering__c = 'Single meter';
        //caseRecord.Status = 'Application Received';
        //caseRecord.Customer_Type__c = 'Private';
        caseRecord.Telephone_No__c = '+6325674832';
        caseRecord.Billing_Address_Barangay__c  = 'SAN LORENZO';
        caseRecord.Billing_Address_City_Municipal__c = 'MAKATI CITY';
        caseRecord.Conglomerate_Tag__c = true;
        caseRecord.Date_of_Birth__c = System.today() - 30;
        caseRecord.Email_Address__c = 'test@test.com';
        caseRecord.First_Name__c = 'FName';
        caseRecord.Last_Name__c = 'LName';
        caseRecord.Billing_Address_Street_No__c = '123';
        caseRecord.Last_Name_Business_Name__c = 'Business Account';
        caseRecord.Middle_Name__c = 'Middle';
        caseRecord.Mobile_No__c =   '+631234567890';
        caseRecord.Billing_Address_Province__c = 'METRO MANILA';
        caseRecord.Billing_Address_Street_Name__c = 'Paseo St.';
        caseRecord.Billing_Address_Subdivision__c = 'Insular Building';
        caseRecord.Billing_Address_Unit_No__c= 'Unit 2';
        caseRecord.Tax_Identification_No__c= '123456789011';
        caseRecord.Application_for_Business_Customer__c = true;
        caseRecord.Application_for_Business_Service__c = true;

        
        insert caseRecord;
        
        //Address__c testAddress = new Address__c(Case__c = caseRecord.Id, Type__c = 'Billing');
        //createAddressWithoutReference(addressType, caseId, acctId, contractId, serviceId, contactId, connectionId)
        Address__c testAddress = CXE_TestDataFactory.createAddressWithoutReference('Billing', caseRecord.Id, null, null, null, null, null);
        insert testAddress;
        
        return caseRecord;
    }

    /* Description: Create Case Residential
     * Author: Christian Peter Doctolero
     * Date Created: MAR-31-17
     */
    private static testMethod Case createCaseRes(){
        List<Case> caseList = CXE_TestDataFactory.createCase(1, 'New Service', 'Single meter', 'Application Received', 'Private');
        Case caseRecord = new Case();
        //caseRecord.Application_Type_Subtype__c = 'New Service';
        //caseRecord.Multimetering__c = 'Single meter';
        //caseRecord.Status = 'Application Received';
        //caseRecord.Customer_Type__c = 'Private';
        caseRecord.Telephone_No__c = '+6356743823';
        caseRecord.Billing_Address_Barangay__c  = 'SAN LORENZO';
        caseRecord.Billing_Address_City_Municipal__c = 'MAKATI CITY';
        caseRecord.Conglomerate_Tag__c = true;
        caseRecord.Date_of_Birth__c = System.today() - 30;
        caseRecord.Email_Address__c = 'test@test.com';
        caseRecord.First_Name__c = 'FName';
        caseRecord.Last_Name__c = 'LName';
        caseRecord.Billing_Address_Street_No__c = '123';
        caseRecord.Last_Name_Business_Name__c = 'Business Account';
        caseRecord.Middle_Name__c = 'Middle';
        caseRecord.Mobile_No__c =   '+631234567890';
        caseRecord.Billing_Address_Province__c = 'METRO MANILA';
        caseRecord.Billing_Address_Street_Name__c = 'Paseo St.';
        caseRecord.Billing_Address_Subdivision__c = 'Insular Building';
        caseRecord.Billing_Address_Unit_No__c= 'Unit 2';
        caseRecord.Tax_Identification_No__c= '123456789011';
        caseRecord.Application_for_Residential_Customer__c = true;
        caseRecord.Application_for_Residential_Service__c = true;
        caseRecord.Home_Ownership__c = 'Owned';
        
        insert caseRecord;
        
        //Address__c testAddress = new Address__c(Case__c = caseRecord.Id, Type__c = 'Billing');
        //createAddressWithoutReference(addressType, caseId, acctId, contractId, serviceId, contactId, connectionId)
        Address__c testAddress = CXE_TestDataFactory.createAddressWithoutReference('Billing', caseRecord.Id, null, null, null, null, null);
        insert testAddress;
        
        return caseRecord;
    }
    //END Account Methods ----------------------------------------------------

    //BEGIN Contact Methods --------------------------------------------------
    //Case has existing Contact
    static testMethod void validateCaseHasContactTest(){
        
        List<Contact> testContactList = CXE_TestDataFactory.createContact(1);
        insert testContactList;

        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.ContactId = testContactList.get(0).Id;
        insert testCase;

        Test.StartTest();
            String errorMessage = CXE_CreateAccountContactOnCase_CC.validateCase(testCase.Id);
        Test.StopTest();
        
        System.assertEquals(CXE_Constants.CREATE_CONTACT_ERROR_MESSAGE_EXISTING_CONTACT, errorMessage);
    }

    //Case has no Account
    static testMethod void validateCaseNoAccountTest(){
        
        List<Contact> testContactList = CXE_TestDataFactory.createContact(1);
        insert testContactList;

        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        insert testCase;

        Test.StartTest();
            String errorMessage = CXE_CreateAccountContactOnCase_CC.validateCase(testCase.Id);
        Test.StopTest();
        
        System.assertEquals(CXE_Constants.CREATE_CONTACT_ERROR_MESSAGE_NO_ACCOUNT, errorMessage);
    }

    //Case Account is a Person Account
    static testMethod void validateCasePersonAccountTest(){
        
        List<Account> testAccountList = CXE_TestDataFactory.createPersonAccount(1);
        insert testAccountList;

        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.AccountId = testAccountList.get(0).Id;
        testCase.First_Name__c = 'test';
        testCase.Last_Name__c = 'test';
        testCase.Application_for_Residential_Customer__c = true;
        testCase.Application_for_Residential_Service__c = true; 
        testCase.Application_for_Business_Customer__c = false;
        testCase.Application_for_Business_Service__c = false; 
        testCase.Service_Rate_Type__c = 'Residential Service (RS)';
        testCase.Billing_Class__c = 'Residential Service (RS)';
        testCase.Email_Address__c = 'test@mail.com';
        testCase.Home_Ownership__c = 'Owned';
        testCase.Date_of_Birth__c = System.today() - 25;
        insert testCase;

        Test.StartTest();
            String errorMessage = CXE_CreateAccountContactOnCase_CC.validateCase(testCase.Id);
        Test.StopTest();
        
        System.assertEquals(CXE_Constants.CREATE_CONTACT_ERROR_MESSAGE_PERSON_ACCOUNT, errorMessage);
    }

    //Case is an application for residential customer
    static testMethod void validateCaseResidentialTest(){
        
        //Id resAccountRecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Residential Customer').getRecordTypeId();
        Account testAccount = CXE_TestDataFactory.createPersonAccount(1)[0];
        //testAccount.RecordTypeId = resAccountRecordTypeId;
        insert testAccount;

        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        //testCase.AccountId = testAccountList.get(0).Id;
        testCase.AccountId = testAccount.Id;
        testCase.First_Name__c = 'test';
        testCase.Last_Name__c = 'test';
        testCase.Application_for_Residential_Customer__c = true; 
        testCase.Application_for_Residential_Service__c = true; 
        testCase.Application_for_Business_Customer__c = false; 
        testCase.Application_for_Business_Service__c = false;         
        testCase.Service_Rate_Type__c = 'Residential Service (RS)';
        testCase.Billing_Class__c = 'Residential Service (RS)';
        testCase.Email_Address__c = 'test@mail.com';
        testCase.Home_Ownership__c = 'Owned';
        insert testCase;

        Test.StartTest();
            String errorMessage = CXE_CreateAccountContactOnCase_CC.validateCase(testCase.Id);
        Test.StopTest();
        System.assertEquals(true, testCase.Application_for_Residential_Customer__c);
        //System.assertEquals(CXE_Constants.CREATE_CONTACT_ERROR_MESSAGE_RESIDENTIAL_CUSTOMER, errorMessage);
    }

    //Case has first name and last name
    static testMethod void validateCaseFullNameTest(){
        
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        insert testAccountList;

        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.AccountId = testAccountList.get(0).Id;
        insert testCase;

        Test.StartTest();
            String errorMessage = CXE_CreateAccountContactOnCase_CC.validateCase(testCase.Id);
        Test.StopTest();
        
        System.assertEquals(CXE_Constants.CREATE_CONTACT_ERROR_MESSAGE_FULL_NAME, errorMessage);
    }

    //Case has valid criteria for create Contact
    static testMethod void validateCasePositiveTest(){
        
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        insert testAccountList;

        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.AccountId = testAccountList.get(0).Id;
        testCase.First_Name__c = 'FName';
        testCase.Middle_Name__c = 'MName';
        testCase.Last_Name__c = 'test';
        testCase.Date_of_Birth__c = System.today() - 30;
        testCase.Tax_Identification_No__c = '123456789011';
        insert testCase;

        Test.StartTest();
            String errorMessage = CXE_CreateAccountContactOnCase_CC.validateCase(testCase.Id);
        Test.StopTest();
        
        System.assertEquals('', errorMessage);
    }

    //Case details has no similar Contacts
    static testMethod void searchContactNoResultsTest(){
        
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        insert testAccountList;

        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.AccountId = testAccountList.get(0).Id;
        testCase.First_Name__c = 'Test';
        testCase.Last_Name__c = 'Test';
        testCase.Mobile_No__c = '+631234567890';
        insert testCase;
        
        //Address__c testAddress = new Address__c(Case__c = testCase.Id, Type__c = 'Billing');
        Address__c testAddress = CXE_TestDataFactory.createAddressWithoutReference('Billing', testCase.Id, null, null, null, null, null);
        insert testAddress;
        
        Test.StartTest();
            List<Contact> testContactList = CXE_CreateAccountContactOnCase_CC.searchContacts(testCase.Id);
        Test.StopTest();
        
        System.assertEquals(true, testContactList.isEmpty());

        Contact createdContact = [SELECT Id, FirstName, LastName, MobilePhone FROM Contact WHERE AccountId =: testAccountList.get(0).Id];
        System.assertEquals(true, testCase.First_Name__c.equalsIgnoreCase(createdContact.FirstName));
        System.assertEquals(true, testCase.Last_Name__c.equalsIgnoreCase(createdContact.LastName));
        System.assertEquals(testCase.Mobile_No__c, createdContact.MobilePhone);
    }

    //Case details has similar Contacts
    static testMethod void searchContactWithResultsTest(){
        
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        insert testAccountList;

        List<Contact> testContactList = CXE_TestDataFactory.createContact(1);
        Contact testContact = testContactList.get(0);
        testContact.FirstName = 'Test';
        testContact.LastName = 'Test';
        testContact.Email = 'test@test.com';
        insert testContact;

        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.AccountId = testAccountList.get(0).Id;
        testCase.First_Name__c = testContact.FirstName;
        testCase.Last_Name__c = 'Test';
        testCase.Email_Address__c = testContact.Email;
        insert testCase;

        
        Test.StartTest();
            List<Contact> existingContactList = CXE_CreateAccountContactOnCase_CC.searchContacts(testCase.Id);
        Test.StopTest();
        
        System.assertEquals(false, existingContactList.isEmpty());

        Contact existingContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id =: testContact.Id];
        System.assertEquals(testCase.First_Name__c, existingContact.FirstName);
        System.assertEquals(testCase.Last_Name__c, existingContact.LastName);
        System.assertEquals(testCase.Email_Address__c, existingContact.Email);
    }

    //Update Case Contact
    static testMethod void updateSelectedContactTest(){
        
        List<Contact> testContactList = CXE_TestDataFactory.createContact(1);
        insert testContactList;

        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        insert testCase;

        Test.StartTest();
            Case caseRecord = CXE_CreateAccountContactOnCase_CC.updateSelectedContact(testContactList.get(0).Id, testCase.Id);
        Test.StopTest();

        System.assertEquals(testContactList.get(0).Id, caseRecord.ContactId);
    }
     //error contact method
     static testMethod void updateSelectedContactTestFailed(){
        
        List<Contact> testContactList = CXE_TestDataFactory.createContact(1);
        insert testContactList;
		
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        insert testCase;

        Test.StartTest();
            Case caseRecord = CXE_CreateAccountContactOnCase_CC.updateSelectedContact(null,testCase.Id);
        Test.StopTest();

        //System.assertEquals(testContactList[0].Id, caseRecord.ContactId);
    }
    //END Contact Methods ----------------------------------------------------
    
    //Retrieve address
    static testMethod void testAddress(){
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        insert testCase;
        
        List<Address__c> lstAddress = new List<Address__c>();
        //Address__c testAddress = new Address__c(Case__c = testCase.Id, Type__c = 'Customer');
        //Address__c testAddress2 = new Address__c(Case__c = testCase.Id, Type__c = 'Billing');
        //CXE_TestDataFactory.createAddressWithoutReference(addressType, caseId, acctId, contractId, serviceId, contactId, connectionId)
        Address__c testAddress = CXE_TestDataFactory.createAddressWithoutReference('Customer', testCase.Id, null, null, null, null, null);
        Address__c testAddress2 = CXE_TestDataFactory.createAddressWithoutReference('Billing', testCase.Id, null, null, null, null, null);
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
        
        insert lstAddress;
        
        Test.StartTest();
            Boolean isAddressExist = CXE_CreateAccountContactOnCase_CC.retrieveAddress(testCase.Id);
            List<String> caseAddressTypes = CXE_CreateAccountContactOnCase_CC.retrieveRelatedCaseAddressTypes(testCase.Id);
        Test.StopTest();
        
        System.assertEquals(true, isAddressExist);
        System.assertEquals(false, caseAddressTypes.isEmpty());
    }
}