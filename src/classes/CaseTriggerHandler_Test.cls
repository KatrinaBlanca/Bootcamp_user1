/* Description: CaseTriggerHandler test class
 * Author: Von Pernicia
 * Date Created: MAR-07-17
 */
@isTest
private class CaseTriggerHandler_Test 
{
    /*static testMethod void validateCaseStatusChanges()
    {   
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        //caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.PSIC__c = psicRecord.id;
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Telephone_No__c = '12312421';
        caseRecord.Mobile_No__c = '1324358765';
        caseRecord.Application_for_Business_Service__c = true;
        insert caseRecord;
        
        test.startTest();
        try
        {
            caseRecord.Status = 'Application Evaluated'; 
            update caseRecord;
        } 
        catch (exception e) 
        {
            system.assertequals(true , e.getMessage().contains('You can not change service application from Meter Socket Issued status to Application Evaluated status'));
            system.assertequals(true , e.getMessage().contains('User does not have permission to change the status at this stage'));
        }
        test.stopTest();
        
        delete caseRecord;
        undelete caseRecord;
    }*/
    
    @testSetup static void setUp() {
        // create References
        List<Reference__c> addressRefList = CXE_TestDataFactory.createSampleReferenceListForAddress();
        insert addressRefList;
        for(Integer i=0 ; i<addressRefList.size() ; i++) {
            if(i>0){
                addressRefList.get(i).Parent__c = addressRefList.get(i-1).Id;
            }
        }
        update addressRefList;      
    }

    static testMethod void updateDepositAmount()
    {   
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Schedule__c> scheduleRecord = CXE_TestDataFactory.createSchedule(5);
        insert scheduleRecord;
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.PSIC__c = psicRecord.id;
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
                
        insert caseRecord;
        
        test.startTest();
    
        //caseRecord.Status = 'Application Approved';
        caseRecord.Applied_Load__c = 2;
        update caseRecord;

        CaseTriggerHandler cas = new CaseTriggerHandler();
        cas.BeforeDelete(null);
        cas.AfterDelete(null);
        cas.AfterUndelete(null);
       
        test.stopTest();
    }
    
    /*static testMethod void caseAssignment()
    {   
        User userRecord = [SELECT Id, Name FROM User where Name =: CXE_Constants.SF_USER_SCC_ADMIN LIMIT 1];
        
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SCS_EMAIL_CASE).getRecordTypeId();
        
        List<Schedule__c> scheduleRecord = CXE_TestDataFactory.createSchedule(5);
        insert scheduleRecord;
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        System.runAs(userRecord)
        {
            Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Meter Socket Issued', 'Private')[0];
            caseRecord.RecordTypeID = servRecTypeId;
            caseRecord.ContactId = contactRecord.id;
            caseRecord.Individual_Business_Tag__c = 'No';
            caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
            caseRecord.PSIC__c = psicRecord.id;
            caseRecord.Initial_Responsible_Office__c = 'RO1';
            caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
            insert caseRecord;
        }
    }*/
    
    static testMethod void picklistTransformation()
    {   
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Schedule__c> scheduleRecord = CXE_TestDataFactory.createSchedule(5);
        insert scheduleRecord;
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;
        
        List<Reference__c> referenceRecord = CXE_TestDataFactory.createReferencePicklist(2, 'Billing Class');
        insert referenceRecord;
        
        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.PSIC__c = psicRecord[0].id;
        caseRecord.Billing_Class__c = 'Name0';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        insert caseRecord;

        test.startTest();
        Case c = [Select id, Code_PSIC__c, Code_Billing_Class__c from Case where Id=:caseRecord.Id];   
        system.assertequals(c.Code_PSIC__c, '77770');
        system.assertequals(c.Code_Billing_Class__c, 0);
        c.Code_Billing_Class__c = 1;
        c.Code_PSIC__c = '77771';
        Update c;
        
        system.assertequals(c.Code_PSIC__c, '77771');
        system.assertequals(c.Code_Billing_Class__c, 1);
        /*
        Case cc = [Select id, Code_PSIC__c, Code_Billing_Class__c from Case where Id=:caseRecord.Id];
               
        system.assertequals(cc.Code_PSIC__c, '77771');
        system.assertequals(cc.Code_Billing_Class__c, 1);
        */
        test.stopTest();
        
    }
    
    static testmethod void updateToApplicationEvaluatedTest(){
        
        Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
        for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
            addressReference.put(addRef.Field__c, addRef);
        }  

        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        insert acc;
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        Office__c office = CXE_TestDataFactory.createOffice(1)[0];
        insert office;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.PSIC__c = psicRecord.id;
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.AccountId = acc.id;
        caseRecord.Applied_Load__c = 6;
        caseRecord.Billing_Class__c = 'billing';
        caseRecord.Responsible_Office_Lookup__c = office.id;
        caseRecord.Customer_Type__c = 'Private';
        caseRecord.Phase__c = 'Single Phase (1Ø), Network';
        caseRecord.Voltage__c = '230 V';
        caseRecord.Application_Type_Subtype__c = 'New Electric Service';
        caseRecord.Demand_Factor__c = 10;
        caseRecord.Load_Factor__c = 5 ;
        caseRecord.Contracted_Capacity__c = 10;
        caseRecord.Service_Supply_Type__c = 'service';
        caseRecord.Project_Type__c = 'project Type';
        caseRecord.Service_Rate_Type__c = 'service rate';
        caseRecord.Deposit_Amount__c = 100;
        caseRecord.Telephone_No__c = '+6312312340';
        caseRecord.Mobile_No__c = '+631324358765';
        caseRecord.Application_for_Business_Service__c = true;
        
        insert caseRecord;
        
        test.startTest();

        Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
        addressRec.Case__c = caseRecord.Id;
        addressRec.Type__c = 'Service';
        insert addressRec;

        Address__c addressRec2 = CXE_TestDataFactory.createAddress(addressReference, true);
        addressRec2.Case__c = caseRecord.Id;
        addressRec2.Type__c = 'Billing';
        insert addressRec2;
        
        Address__c addressRec3 = CXE_TestDataFactory.createAddress(addressReference, true);
        addressRec3.Case__c = caseRecord.Id;
        addressRec3.Type__c = 'Customer';
        insert addressRec3;
        
        Case c = [Select Status from Case Where Id =: caseRecord.Id];
        c.Project_Type__c = 'Simple Connection';
        
        Field_Order__c fo = CXE_TestDataFactory.createFieldOrder(1)[0];
        fo.Case__c = caseRecord.Id;
        insert fo;
        
        
        caseRecord.Status = CXE_Constants.CASE_PRE_SURVEY_FO_FEASIBLE;
        caseRecord.Load_Factor__c = 4 ;
        
        update caseRecord;      
 
        test.stopTest();

         //Check if the status is Pre-survey FO Resolved - Feasible 
        Case c1 = [Select Status from Case Where Id =: caseRecord.Id];
        //system.assertequals(CXE_Constants.CASE_APPLICATION_EVALUATED, c1.Status); CASE_PRE_SURVEY_FO_FEASIBLE
        system.assertequals('Pre-Survey FO Resolved - Feasible', c1.Status); 
    }

    static testmethod void validateResponsibleOfficeTest(){
        
        Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
        for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
            addressReference.put(addRef.Field__c, addRef);
        }  

        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        acc.Doing_Business_As__c = 'test';
        insert acc;
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        contactRecord.Salutation = 'Mr';
        contactRecord.MiddleName = 'MiddleName';
        contactRecord.Phone = '+6321231234';
        contactRecord.MobilePhone = '+639221231234';
        contactRecord.Email = 'aa@aa.com';
        contactRecord.Birthdate = system.today() - 1;
        insert contactRecord;
        
        Office__c office = CXE_TestDataFactory.createOffice(1)[0];
        insert office;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.PSIC__c = psicRecord.id;
        caseRecord.Initial_Responsible_Office__c = 'G4';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.AccountId = acc.id;
        caseRecord.Applied_Load__c = 6;
        caseRecord.Billing_Class__c = 'billing';
        caseRecord.Customer_Type__c = 'Private';
        caseRecord.Phase__c = 'Single Phase (1Ø), Network';
        caseRecord.Voltage__c = '230 V';
        caseRecord.Application_Type_Subtype__c = 'New Electric Service';
        caseRecord.Demand_Factor__c = 10;
        caseRecord.Load_Factor__c = 5 ;
        caseRecord.Contracted_Capacity__c = 10;
        caseRecord.Service_Supply_Type__c = 'service';
        caseRecord.Project_Type__c = 'project Type';
        caseRecord.Service_Rate_Type__c = 'service rate';
        caseRecord.Deposit_Amount__c = 100;
        caseRecord.Telephone_No__c = '+6312312340';
        caseRecord.Mobile_No__c = '+631324358765';
        caseRecord.Application_for_Business_Service__c = true;
        
        insert caseRecord;
        
        try
        {
            caseRecord.Responsible_Office_Lookup__c = office.id;
            update caseRecord;
        } catch (exception e)
        {
            system.assertequals( true , e.getMessage().contains( CXE_Constants.CASE_ERROR_MESSAGE_INVALID_RESPONSIBLE_OFFICE ) );
        }

    }

    static testmethod void validateResponsibleOfficeTest2(){
        
        Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
        for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
            addressReference.put(addRef.Field__c, addRef);
        }  

        Account acc = CXE_TestDataFactory.createPersonAccount(1)[0];
        acc.Salutation = 'Mr.';
        insert acc;
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        Office__c office = CXE_TestDataFactory.createOffice(1)[0];
        insert office;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.PSIC__c = psicRecord.id;
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.AccountId = acc.id;
        caseRecord.Applied_Load__c = 6;
        caseRecord.Billing_Class__c = 'billing';
        caseRecord.Customer_Type__c = 'Private';
        caseRecord.Phase__c = 'Single Phase (1Ø), Network';
        caseRecord.Voltage__c = '230 V';
        caseRecord.Application_Type_Subtype__c = 'New Electric Service';
        caseRecord.Demand_Factor__c = 10;
        caseRecord.Load_Factor__c = 5 ;
        caseRecord.Contracted_Capacity__c = 10;
        caseRecord.Service_Supply_Type__c = 'service';
        caseRecord.Project_Type__c = 'project Type';
        caseRecord.Service_Rate_Type__c = 'service rate';
        caseRecord.Deposit_Amount__c = 100;
        caseRecord.Telephone_No__c = '+6312312340';
        caseRecord.Mobile_No__c = '+631324358765';
        caseRecord.Application_for_Residential_Customer__c = true;
        caseRecord.Application_for_Residential_Service__c = true;
        caseRecord.Application_for_Business_Service__c  = false;
        caseRecord.Application_for_Business_Customer__c = false;
        caseRecord.Home_Ownership__c = 'Owned';

        insert caseRecord;
        
        try
        {
            caseRecord.Responsible_Office_Lookup__c = office.id;
            caseRecord.Origin = CXE_Constants.RECORD_TYPE_NAME_OFFICE_WEB;
            update caseRecord;
        }
        catch (exception e)
        {
            system.assertequals( true , e.getMessage().contains( CXE_Constants.CASE_ERROR_MESSAGE_NO_INITIAL_RESPONSIBLE_OFFICE ) );
        }
    }

    static testMethod void caseAssignmentTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', Firstname = 'SCC', LastName='Admin', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser111111@testorg.com');
        insert u;
        Id emailRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('SCS Email Case').getRecordTypeId();
        Id socialRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('SCS Social Media Case').getRecordTypeId();

        User integrationUserObj = [SELECT Id, Name FROM User where Name = 'SCC Admin' LIMIT 1];

        System.assertEquals(integrationUserObj.Name, 'SCC Admin');
                        
        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = socialRecTypeId;
        caseRecord.OwnerId = integrationUserObj.Id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';

        insert caseRecord;

    }

    //START RReyes JUL-08-17 - test validation of V10 Customer Number
    static testmethod void testValidateV10AccountNumber(){
        List<Account> accList = CXE_TestDataFactory.createBusinessAccount(2);
        accList[1].V10_Customer_No__c = '';
        insert accList;

        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        Office__c office = CXE_TestDataFactory.createOffice(1)[0];
        insert office;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.AccountId = accList[0].Id;
        caseRecord.isAccountNew__c = true;
        insert caseRecord;
        
        test.startTest();
        String errorMsg = '';
        caseRecord.AccountId = accList[1].Id; 
        try{
            update caseRecord; 
            System.assertEquals('', errorMsg);
            
        }catch(DmlException e){
            errorMsg = e.getDmlMessage(0);
            System.assertEquals(CXE_Constants.CASE_ERROR_ACCOUNT_WITHOUT_V10_NUM, errorMsg);
        }
        test.stopTest();
    }
    //END RReyes JUL-08-17

    //START RReyes JUL-08-17 - test validation of V10 Customer Number
    static testmethod void testRecontractRelateAccountToAddress(){

        Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
        for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
            addressReference.put(addRef.Field__c, addRef);
        }  


        List<Account> accList = CXE_TestDataFactory.createBusinessAccount(1);
        insert accList;

        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        Office__c office = CXE_TestDataFactory.createOffice(1)[0];
        insert office;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        Case caseRecord = CXE_TestDataFactory.createRecontractCase(1, '')[0];
        caseRecord.AccountId = accList[0].Id;
        caseRecord.isAccountNew__c = true;
        insert caseRecord;
        
        Address__c billingAddress = CXE_TestDataFactory.createAddress(addressReference, true);
        billingAddress.Case__c = caseRecord.Id;
        billingAddress.Type__c = 'Billing';
        billingAddress.Account__c = accList[0].Id;
        insert billingAddress;

        test.startTest();
        //caseRecord.AccountId = accList[0].Id; 
        //update caseRecord;

        Address__c addr = [SELECT Id, Account__c FROM Address__c WHERE Id=:billingAddress.Id LIMIT 1];
        System.assertEquals(caseRecord.AccountId, addr.Account__c);
        
        test.stopTest();
    }
    //END RReyes JUL-08-17

    //START RReyes JUL-08-17 - update account details on change of account
    static testmethod void testAutopopulateAccountDetailsIndividual(){

        List<Account> accList = CXE_TestDataFactory.createPersonAccount(1);
        accList[0].FirstName = 'NEW FIRST NAME';
        insert accList;

        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        Office__c office = CXE_TestDataFactory.createOffice(1)[0];
        insert office;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        Case caseRecord = CXE_TestDataFactory.createRecontractCase(1, '')[0];
        caseRecord.AccountId = accList[0].Id;
        insert caseRecord;
        
        System.assertNotEquals(accList[0].FirstName, caseRecord.First_Name__c);
        test.startTest();
        caseRecord.AccountId = accList[0].Id; 
        update caseRecord;

        Case c = [SELECT Id, First_Name__c FROM Case WHERE Id =: caseRecord.Id LIMIT 1];
        System.assertEquals(accList[0].FirstName, c.First_Name__c);
        
        test.stopTest();
    }
    //END RReyes JUL-08-17
}