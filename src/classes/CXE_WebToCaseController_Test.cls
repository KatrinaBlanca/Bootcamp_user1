/* Description: ConnectionTriggerHandler test class
* Author: Christian Peter Doctolero
* Date Created: MAR-13-17
*/
@isTest
private class CXE_WebToCaseController_Test {
    
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
    
    static testMethod void submitBusinessTest() {
        Test.startTest();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();
        
        Case caseRecord = new Case();
        
        caseRecord.First_Name__c = 'John';
        caseRecord.Last_Name__c = 'Doe';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Mobile_No__c = '+630922123123';
        caseRecord.Email_Address__c = 'sample@email.com';
        caseRecord.Last_Name_Business_Name__c = 'TestBusiness Name';
        caseRecord.Tax_Identification_No__c = '123123';
        Address__c busAdd = new Address__c();
        //Attachment att = new Attachment();
        
        CXE_WebToCaseController  wtc = new CXE_WebToCaseController();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        wtc.caseRecord = caseRecord;
        wtc.caseNumber = '123';
        //wtc.businessAddressRecord = busAdd;
        wtc.emailCb = true;
        wtc.smsCb = false;
        wtc.amcSelect = 'Yes';
        wtc.hasAppliedForSomeone = 'Yes';
        wtc.sameAsServiceAddressSelect = 'True';
        //wtc.sitekey = 'capcha test';
        wtc.getAMCOptions();
        wtc.getSameForBilling();
        wtc.getRelationships();
        wtc.getSalutations();
        wtc.getHomeOwnership();
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','{"success":true}'); 
        //wtc.attachment = att;
        //wtc.upload();
        PageReference wtcpage = wtc.submitBusiness();
        system.debug('wtc>>>>>' + wtcpage); 
        system.assert(wtcpage.getUrl().contains('/apex/cxe_serviceappbusinessthankyou?casenumber'));
        
        
        Test.stopTest();      
    }
    static testMethod void submitResidentialTest() {
        Test.startTest();
        
        //Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();
        RecordType rec = [SELECT Id FROM recordtype WHERE sObjectType='Case' AND Recordtype.Developername='New_Service_Application'];
        Attachment att = new Attachment();
        att.Name = 'TestAttachment';
        att.body = Blob.valueof('Test');
        
        Case caseRecord = new Case();
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.First_Name__c = 'Test';
        caseRecord.Last_Name__c = 'Test';
        caseRecord.Home_Ownership__c = 'Owned';
        caseRecord.Email_Address__c = 'sample@email.com';
        caseRecord.Mobile_No__c = '+630922123123';
        caseRecord.Address_1__c = '123 test';
        caseRecord.Service_Address_City_Municiple__c = 'STO. TOMAS';
        caseRecord.Service_Address_Province__c = 'BATANGAS';
        caseRecord.RecordTypeId = rec.Id;
        caseRecord.Origin = 'Web';
        
        CXE_WebToCaseController  wtc = new CXE_WebToCaseController();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        wtc.caseRecord = caseRecord;
        wtc.caseNumber = '123';
        //wtc.customerAddressRecord = resAdd;
        wtc.emailCb = true;
        wtc.smsCb = false;          
        wtc.amcSelect = 'Yes';
        wtc.hasAppliedForSomeone = 'No';
        wtc.sameAsServiceAddressSelect = 'True';
        wtc.attachment = att;
        //wtc.upload();
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','{"success":true}');         
        PageReference wtcpage = wtc.submitResidential();
        
        system.assertequals(wtcpage, null);
        
        //ApexPages.Message[] pageMessages = ApexPages.getMessages();
        //System.assertNotEquals(0, pageMessages.size());
        
        //String error = '';
        //List<String> errors = new List<String>();
        // //Check that the error message you are expecting is in pageMessages
        //for(ApexPages.Message message : pageMessages) {
        //  errors.add(message.getSummary());               
        //}
        
        //System.assertEquals('error', String.join(errors, ';'));
        //system.assert(wtcpage.getUrl().contains('/apex/cxe_serviceappresidentialthankyou?casenumber'));
        
        Test.stopTest();      
    }
    static testMethod void submitResidentialNegativeTest() {
        Test.startTest();
        Id servRecTypeId = [SELECT Id FROM recordtype WHERE sObjectType='Case' AND Recordtype.Developername='New_Service_Application'].Id;
        
        Case caseRecord = new Case();
        //Address__c resAdd = new Address__c();
        Attachment att = new Attachment();
        
        CXE_WebToCaseController  wtc = new CXE_WebToCaseController();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        wtc.caseRecord = caseRecord;
        wtc.caseNumber = '123';
        //wtc.customerAddressRecord = resAdd;
        wtc.emailCb = true;
        wtc.smsCb = false;          
        wtc.amcSelect = 'Yes';
        wtc.hasAppliedForSomeone = 'Yes';
        wtc.sameAsServiceAddressSelect = 'True';
        wtc.getAMCOptions();
        wtc.getSameForBilling();
        wtc.getRelationships();
        wtc.getSalutations();
        wtc.getHomeOwnership();
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','{"success":true}'); 
        wtc.attachment = att;
        wtc.upload();
        
        PageReference wtcpage = wtc.submitResidential();
        //system.debug('wtc>>>>>' + wtcpage);         
        //system.assertEquals(wtcpage, null);
        Test.stopTest();      
    }
    static testMethod void submitBusinessNegativeTest() {
        Test.startTest();
        Id servRecTypeId = [SELECT Id FROM recordtype WHERE sObjectType='Case' AND Recordtype.Developername='New_Service_Application'].Id;
        
        Case caseRecord = new Case();
        //Address__c resAdd = new Address__c();
        Attachment att = new Attachment();
        
        CXE_WebToCaseController  wtc = new CXE_WebToCaseController();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        wtc.caseRecord = caseRecord;
        //wtc.caseNumber = null;
        //wtc.customerAddressRecord = resAdd;
        wtc.emailCb = true;
        wtc.smsCb = false;          
        wtc.amcSelect = 'Yes';
        wtc.hasAppliedForSomeone = 'Yes';
        wtc.sameAsServiceAddressSelect = 'True';
        wtc.getAMCOptions();
        wtc.getSameForBilling();
        wtc.getRelationships();
        wtc.getSalutations();
        wtc.getHomeOwnership();
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','{"success":true}'); 
        wtc.attachment = att;
        wtc.upload();
        
        PageReference wtcpage = wtc.submitBusiness();
        //system.debug('wtc>>>>>' + wtcpage);         
        // system.assertEquals(wtcpage, null);
        Test.stopTest();      
    }
    static testMethod void getInitialResponsibleOfficeTest() {
        Test.startTest();
        List<Reference__c> ref = CXE_TestDataFactory.createSampleReferenceListForAddress();
        insert ref;
        Id webRecTypeId = Schema.Sobjecttype.Office__c.getRecordTypeInfosByName().get(CXE_Constants.RECORD_TYPE_NAME_OFFICE_WEB).getRecordTypeId();
        Office__c off = CXE_TestDataFactory.createOffice(1)[0];
        off.RecordTypeId = webRecTypeId;
        
        Office_Jurisdiction__c oj = CXE_TestDataFactory.createOfficeJurisdiction(1)[0];
        oj.Office__c = off.Id;          
        
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();
        
        Case caseRecord = new Case();   
        caseRecord.Service_Address_City_Municiple__c = 'STO. TOMAS';
        //caseRecord.Service_Address_City_Municiple__c = 'PASIG CITY';
        //Address__c resAdd = new Address__c();
        Attachment att = new Attachment();
        
        CXE_WebToCaseController  wtc = new CXE_WebToCaseController();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        wtc.caseRecord = caseRecord;
        wtc.caseNumber = '123';
        //wtc.customerAddressRecord = resAdd;
        wtc.emailCb = true;
        wtc.smsCb = false;          
        wtc.amcSelect = 'Yes';
        wtc.hasAppliedForSomeone = 'Yes';
        wtc.sameAsServiceAddressSelect = 'True';
        wtc.getAMCOptions();
        wtc.getSameForBilling();
        wtc.getRelationships();
        wtc.getSalutations();
        wtc.getHomeOwnership();
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','{"success":true}'); 
        wtc.attachment = att;
        wtc.upload();           
        wtc.getInitialResponsibleOffice();
        Test.stopTest(); 
        
    }
    //JAgapito 10/26
    static testMethod void getTest () {
        Test.startTest();
        
        CXE_WebToCaseController wtcc = new CXE_WebToCaseController();
        List <SelectOption> gcm = wtcc.getContractModification();
        List <SelectOption> gfmn = wtcc.getPreferredModeOfNotification();
        List <SelectOption> gsn = wtcc.getServiceModification();

        Test.stopTest();
    }
    static testMethod void submitModifyBusinessTest() {
        Test.startTest();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();
        Case caseRecord = new Case();
        
        caseRecord.First_Name__c = 'John';
        caseRecord.Last_Name__c = 'Doe';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Mobile_No__c = '+630922123123';
        caseRecord.Email_Address__c = 'sample@email.com';
        caseRecord.Last_Name_Business_Name__c = 'TestBusiness Name';
        caseRecord.Tax_Identification_No__c = '123123';
        
        Address__c busAdd = new Address__c();
        
        CXE_WebToCaseController  wtc = new CXE_WebToCaseController();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        wtc.caseRecord = caseRecord;
        wtc.caseNumber = '123';
        wtc.emailCb = true;
        wtc.smsCb = false;
        wtc.amcSelect = 'Yes';
        wtc.hasAppliedForSomeone = 'Yes';
        wtc.sameAsServiceAddressSelect = 'True';
        wtc.getAMCOptions();
        wtc.getSameForBilling();
        wtc.getRelationships();
        wtc.getSalutations();
        wtc.getHomeOwnership();
        
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','{"success":true}'); 
        
        PageReference wtcpage = wtc.submitModifyBusiness();
        system.assert(wtcpage.getUrl().contains('/apex/cxe_serviceappbusinessthankyou?casenumber'));
        
        Test.stopTest();
    }
    
    static testMethod void submitMoodifyResidentialTest() {
        Test.startTest();
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();
        Case caseRecord = new Case();
        
        caseRecord.First_Name__c = 'John';
        caseRecord.Last_Name__c = 'Doe';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Mobile_No__c = '+630922123123';
        caseRecord.Email_Address__c = 'sample@email.com';
        caseRecord.Last_Name_Business_Name__c = 'TestBusiness Name';
        caseRecord.Tax_Identification_No__c = '123123';
        
        Address__c busAdd = new Address__c();
        
        CXE_WebToCaseController wtc = new CXE_WebToCaseController();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        wtc.caseRecord = caseRecord;
        wtc.caseNumber = '123';
        wtc.emailCb = true;
        wtc.smsCb = false;
        wtc.amcSelect = 'Yes';
        wtc.hasAppliedForSomeone = 'Yes';
        wtc.sameAsServiceAddressSelect = 'True';
        wtc.getAMCOptions();
        wtc.getSameForBilling();
        wtc.getRelationships();
        wtc.getSalutations();
        wtc.getHomeOwnership();
        
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','{"success":true}'); 
        
        PageReference wtcpage = wtc.submitModifyResidential();

        Test.stopTest();
    }
    
    
    
    
    /*static testMethod void submitCase() {
Test.startTest();
Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();

Case caseRecord = new Case();
caseRecord.First_Name__c = 'John';
caseRecord.Last_Name__c = 'Doe';
caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
caseRecord.Mobile_No__c = '09199999999';
caseREcord.Email_Address__c = 'sample@email.com';


CXE_WebToCaseController  wtc = new CXE_WebToCaseController();
Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
//HttpResponse res = wtc.getInfoFromExternalService();
wtc.caseRecord = caseRecord;
wtc.caseNumber = '123';
wtc.emailCb = true;
wtc.smsCb = false;
wtc.amcSelect = 'Yes';
wtc.sameAsServiceAddressSelect = 'True';
ApexPages.currentPage().getParameters().put('g-recaptcha-response','{"success":true}'); 
wtc.hasAppliedForSomeone = 'Yes';
//wtc.response = '';

//PageReference pgRef = Page.CXE_WebToCaseController;      
//Test.setCurrentPageReference( pgRef );
wtc.getAMCOptions();
wtc.getSameForBilling();
wtc.getRelationships();
wtc.getSalutations();
wtc.getHomeOwnership();
wtc.upload();
Test.stopTest();
wtc.submitResidential();
wtc.submitBusiness();       

}

static testMethod void submitCase2() {
Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();

Case caseRecord = new Case();
caseRecord.First_Name__c = 'John';
caseRecord.Last_Name__c = 'Doe';
CaseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
caseRecord.Mobile_No__c = '09199999999';
caseREcord.Email_Address__c = 'sample@email.com';


CXE_WebToCaseController  wtc = new CXE_WebToCaseController();
Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
//HttpResponse res = wtc.getInfoFromExternalService();
wtc.caseRecord = caseRecord;
wtc.caseNumber = '123';
wtc.emailCb = true;
wtc.smsCb = false;
wtc.amcSelect = 'Yes';
wtc.sameAsServiceAddressSelect = 'True';
//ApexPages.currentPage().getParameters().put('g-recaptcha-response','{"success":true}'); 
wtc.hasAppliedForSomeone = 'Yes';
//wtc.response = '';

//PageReference pgRef = Page.CXE_WebToCaseController;      
//Test.setCurrentPageReference( pgRef );
wtc.getAMCOptions();
wtc.getSameForBilling();
wtc.getRelationships();
wtc.getSalutations();
wtc.getHomeOwnership();
wtc.upload();

wtc.submitResidential();
wtc.submitBusiness();       

}*/
}