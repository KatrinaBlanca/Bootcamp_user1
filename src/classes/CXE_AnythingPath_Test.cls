@isTest
private class CXE_AnythingPath_Test {
    
    @isTest 
    static void testDynamicTopic(){
        CXE_AnythingPath_CC.dynamicTopic('Case', 'Status');
    }

    @isTest 
    static void testDynamicTopicBAD(){
        CXE_AnythingPath_CC.dynamicTopic('NoOneWouldEverNameAnObjectThis__c', 'NoOneWouldEverNameAFieldThis__c');
    }

    @isTest 
    static void testgetPicklistOptions(){
        list<case> cases = [select id from Case];
        CXE_AnythingPath_CC.getPicklistOptions(cases[0].id, 'Status', 'Case');
    }

    @isTest 
    static void testgetPicklistOptionsNull(){
        //list<case> cases = [select id from Case];
        CXE_AnythingPath_CC.getPicklistOptions(null, 'Status', 'Case');
    }

    @isTest 
    static void testGetCurrentValue(){
        list<case> cases = [select id from Case];
        CXE_AnythingPath_CC.getCurrentValue(cases[0].id, 'Status', 'Case');
    }

    @isTest 
    static void testSetNewValue(){
        list<case> cases = [select id from Case];
        CXE_AnythingPath_CC.setNewValue(cases[0].id, 'Status', 'Closed');
    }

    @isTest
    static void itShouldReturnSessionId(){
        string sid = CXE_AnythingPath_CC.sessionId();
        system.assertNotEquals(sid, null);      
    }

    @isTest static void testQuery() {
        CXE_AnythingPath_CC.query('select id from case');
    }

    @isTest static void testQueryJSON() {
        CXE_AnythingPath_CC.queryJSON('select id from case');
    }
    
    /*@isTest static void testDescribe() {
        CXE_AnythingPath_CC.describe('Case');
    }*/ // CSM-14144
    
    @isTest static void testPlural(){
        CXE_AnythingPath_CC.whatsMyPlural('Case');    
    }
    
    //START CSM-14144 10.27.2017 disable code not being used
    /*
    @isTest static void testBadDescribe() {
        CXE_AnythingPath_CC.describe('YourMom');
    }
    
    @isTest static void testUpdate() {
        list<case> cases = [select id from Case];
        CXE_AnythingPath_CC.updateField(cases[0].Id, 'Subject', 'your software REALLY sucks');
    }
    
    @isTest static void testUpdateDateTime() {
        list<Lead> Leads = [select id from Lead];        
        CXE_AnythingPath_CC.updateField(Leads[0].Id, 'EmailBouncedDate', '2016-11-26T23:30:00.000Z');
    }

    @isTest static void testCreate(){        
        String fields = '{"Name": "TestName"' +
                            ',"AccountNumber" : "327823782"' + 
            ',"AnnualRevenue" : 2500' +
            ',"Rating" : "Hot" ' +
            ',"Email__c" : "test@test.com" ' + 
            ',"Mobile_Phone__c" : "+631234567890" ' + 
            ',"Telephone_No__c" : "+6356748321" ' + 
            ',"V10_Customer_No__c" : "5558957842" ' + 
            '}';
        system.debug(fields);
        string result = CXE_AnythingPath_CC.create('Account', fields);
        system.debug(result);
    }

    @isTest static void testCreateBad(){        
        String fields = '{"Name": ""' +
            ',"AccountNumber" : "327823782"' + 
            ',"AnnualRevenue" : 2500' +
            ',"Rating" : "Hot" ' +
            ',"Email__c" : "test@test.com" ' + 
            ',"Mobile_Phone__c" : "+631234567890" ' + 
            ',"Telephone_No__c" : "+6356748321" ' + 
            ',"V10_Customer_No__c" : "5558957842" ' + 
            '}';
        system.debug(fields);
        string result = CXE_AnythingPath_CC.create('Account', fields);
        system.debug(result);
    }


    
    @isTest static void testBadFieldCreate(){        
        String fields = '{"Name": "TestName"' +
                            ',"NoOneWouldEverNameAFieldThis__c" : "327823782"' + 
            ',"AnnualRevenue" : 2500' +
            ',"Rating" : "Hot" ' +
            ',"Fax" : "5558957842" ' + 
                            '}';
        system.debug(fields);
        string result = CXE_AnythingPath_CC.create('Account', fields);
        system.debug(result);
    }
    
    @isTest static void testUnsetableFieldCreate(){        
        String fields = '{"Name": "TestName"' +
            ',"CreatedDate" : 2500' +
            ',"Rating" : "Hot" ' +
            ',"Fax" : "5558957842" ' + 
                            '}';
        system.debug(fields);
        string result = CXE_AnythingPath_CC.create('Account', fields);
        system.debug(result);
    }
    */
    //END CSM-14144
    
    /* Fails in SDOs because of callout trigger / IFTTT app
    @isTest static void testOpptyUpdates() {
        list<opportunity> opptys = [select id from opportunity];
        CXE_AnythingPath_CC.updateField(opptys[0].Id, 'Amount', '6.25');
        CXE_AnythingPath_CC.updateField(opptys[0].Id, 'Probability', '0.75');        
    }*/
    
    //START CSM-14144 10.27.2017 disable code not being used
    /*
    @isTest static void testUpdateCurrency() {
        list<Lead> leads = [select id from Lead];
        CXE_AnythingPath_CC.updateField(leads[0].Id, 'AnnualRevenue', '87');
    } 
    
    @isTest static void testUpdateInteger() {
        list<Lead> leads = [select id from Lead];
        CXE_AnythingPath_CC.updateField(leads[0].Id, 'NumberOfEmployees', '13');
    }
    */
    //END CSM-14144
    
    //public static Schema.DisplayType getFieldType(string objectName, string fieldname){
    @isTest static void testGetTotalDays(){
        list<Case> cases = [select id from Case LIMIT 1];
        String totalDays = CXE_AnythingPath_CC.getTotalDays(cases[0].Id);
        System.assertNotEquals(null, totalDays);
    }
    
    @isTest static void testGetRecordTypeName(){
        list<Case> cases = [select id from Case LIMIT 1];
        String rTypeName = CXE_AnythingPath_CC.getRecordTypeName(cases[0].Id);
        System.assertEquals('New_Service_Application', rTypeName);
    }
    
    @isTest static void testGetCaseDetails(){
        list<Case> cases = [select id from Case LIMIT 1];
        Case myCase = CXE_AnythingPath_CC.getCaseDetails(cases[0].Id);
        System.assertNotEquals(null, myCase);
    }
       
    @testSetup static void testSetupCoreObjects() {
        /*case c = new case();
        c.status = 'New';
        c.Subject = 'your software sucks';
        insert c;*/
        Id newServiceRType = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        //caseRecord.RecordTypeID = servRecTypeId;
        //caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        //caseRecord.PSIC__c = psicRecord.id;
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Telephone_No__c = '+63464180878';
        caseRecord.Mobile_No__c = '+639178273645';
        caseRecord.Application_for_Business_Service__c = true;
        caseRecord.Status = 'Application Received';
        caseRecord.CXE_StatusPath__c = 'Apply';
        caseRecord.RecordTypeId = newServiceRType;
        insert caseRecord;
        
        lead l = new lead();
        l.firstname = 'Washington';
        l.lastname = 'McLaughlin';
        l.Company = 'Pollos Hermanos';
        l.MobilePhone = '+639178372635';
        insert l;
        
        /*account a = new account();
        a.name = 'Pizza King';
        insert a;*/
        List<Account> acctList = CXE_TestDataFactory.createBusinessAccount(1);
        Account acctRecord = acctList[0];
        acctRecord.Name = 'Business Account Name';
        acctRecord.Conglomerate__c = true;
        acctRecord.Email__c = 'test@test.com';
        acctRecord.Mobile_Phone__c = '+631234567890';
        acctRecord.Phone='+6356748321';
        acctRecord.Billing_Address_Barangay__c  = 'SAN LORENZO'  ;
        acctRecord.Billing_Address_City_Municipal__c =  'MAKATI CITY'  ;
        acctRecord.Billing_Address_Province__c  =  'METRO MANILA'  ;
        acctRecord.Billing_Address_Street_Name__c  =  'Paseo St.'  ;
        acctRecord.Billing_Address_Subdivision__c  =  'Insular Building'  ;
        acctRecord.Billing_Address_Unit_No__c  =  'Unit 2';
        acctRecord.Customer_Type__c = 'Name0';
        insert acctRecord;
        
        /*opportunity o = new opportunity();
        o.name = 'Pizza King Oppty';
        o.AccountId = a.Id;
        o.CloseDate = system.today();
        o.StageName = 'New';
        insert o;*/
    }
    
}