@isTest
private class CaseStateTransitionTest {
    // Comment out code as this should be handle by CaseTriggerHandler_test

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
    /*
    @isTest
    public  static  void runMe(){
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('New Service Application').getRecordTypeId();
        Id PersonAccountRecTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        id foPreSurveyRecTypeId= Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get('Survey FO').getRecordTypeId();
        account a = new account (firstname='Test', lastname='test person account', recordtypeid=PersonAccountRecTypeId);
        insert a;
		a = [select id, personcontactid from account where id=:a.id];
        PSIC__c pc  = new PSIC__c ();
		pc.Demand_Factor__c =1;
        pc.Load_Factor__c =1;
        pc.name ='test';
        pc.PSIC_Code__c='2'; 
		insert pc;
        Schedule__c  sc = new Schedule__c ();
        sc.Non_Residential_Rate__c =500;
        sc.Residential_Rate__c= 200;
        sc.Schedule_Selector__c='S-2';
        insert sc;
        Case c = new Case(subject='test case', recordtypeid=servRecTypeId);
        c.account=a;
		c.contactid=a.personcontactid;
		c.Last_Name_Business_Name__c='test';
		c.Mobile_No__c ='+639221231234';
        c.Application_for_Residential_Customer__c = true;
        c.Application_for_Residential_Service__c = true;
        c.Application_for_Business_Service__c  = false;
        c.Application_for_Business_Customer__c = false;
        c.Home_Ownership__c = 'Owned';
        c.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        CaseStateTransitionHelper.processedCaseId=null;
		insert c;
        c.Status='Application Received';
		c.Billing_Address_Province__c ='METRO MANILA';
		c.Billing_Address_Barangay__c ='ADDITION HILLS';
        c.Billing_Address_City_Municipal__c='ANGONO';
        c.Billing_Address_Street_Name__c ='test';
        c.Billing_Address_Street_No__c ='test';
        c.Billing_Address_Subdivision__c ='test';
        c.Billing_Address_Unit_No__c='test'; 
        c.Target_Energization_Date__c=date.today().addDays(10); 
        c.Billing_Class__c ='Residential Service(RS)';
        c.Deposit_Amount__c =100;
        c.Service_Rate_Type__c ='Government Hospitals, Metered Streetlights & Charitable Institutions (GHMSCI)';
		c.Phase__c ='Single Phase (1Ø), Two (2)-Wire';
		c.Voltage__c ='216 V';
		c.Demand_Factor__c =1;
		c.Project_Type__c='Simple Connection';
        c.Service_Supply_Type__c='Normal without meter';
        c.Applied_Load__c  =3;
        c.Load_Factor__c =1;
        c.Contracted_Capacity__c =1000;
        c.Mode_of_Retrieval__c ='REMOTE';
        c.Metering_Scheme__c ='NORMAL';
        c.Service_Wire_Type__c ='Aerial Alum.,Bundled';
        c.Wire_Size__c ='#1/0';
        c.Service_Wire_Length__c =1;
        c.Material__c ='Aluminum';
        c.TLN__c='1';
        c.Pole_Code__c='test';
        c.Customer_Type__c ='Private';
        c.Residential_Non_Residential_Tag__c ='No';
        c.Application_Type_Subtype__c='New Electric Service';
        c.PSIC__c =pc.id; 
		c.Preliminary_survey_result_is_feasible__c =true;
        c.Date_of_Birth__c = date.today().adddays(-100);
        c.Individual_Business_Tag__c ='No';
        update c;

        c.Status='Application Validated';
        CaseStateTransitionHelper.processedCaseId=null;
        update c;
        Field_Order__c fo = new Field_Order__c ();
        fo.recordtypeid=foPreSurveyRecTypeId;
        fo.Case__c= c.id;
        CaseStateTransitionHelper.processedCaseId=null;
        insert fo;
        fo.Schedule_Date__c= date.today();
        CaseStateTransitionHelper.processedCaseId=null;
        update fo;
        fo.Pre_Survey_Result__c='feasible';
        fo.Resolution_Date__c=date.today();
        fo.Resolution_Remarks__c='test';
        CaseStateTransitionHelper.processedCaseId=null;
        update fo;
        
        
        User u = [select id, Can_Change_Case_Status_Manually__c from user where id=:userinfo.getuserid()];
        u.Can_Change_Case_Status_Manually__c = true;
        update u;
        system.runas(u){
          
            c.Status='Application Approved';
            CaseStateTransitionHelper.processedCaseId=null;
            update c;
            c.Status='Contract Finalized';
            CaseStateTransitionHelper.processedCaseId=null;
            update c;
            c.Status='Application Ready for Connection';
            CaseStateTransitionHelper.processedCaseId=null;
            update c;
            c.Status='Pending Energization';
            CaseStateTransitionHelper.processedCaseId=null;
            update c;
            c.Status='Energized';
            CaseStateTransitionHelper.processedCaseId=null;
            update c;
        }
        
        
    }*/
    
    static testmethod void runMe(){
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
        
    }
}