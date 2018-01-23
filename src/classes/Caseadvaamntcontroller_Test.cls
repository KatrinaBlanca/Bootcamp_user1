@istest
public class Caseadvaamntcontroller_Test
{
    public static Case cs;
    @isTest 
    static void testCaseadvaamntcontroller(){
        cs = new Case(Subject='Test Controller Acct Case');
        insert cs;
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        test.startTest();
        Caseadvaamntcontroller pcc = new Caseadvaamntcontroller(sc);
        test.stopTest();
    }
    
    
    //private static final String ADMIN_PROFILE = 'System Administrator';
   
    //@testSetup static void setUp() {
    //    // create References
    //    List<Reference__c> addressRefList = CXE_TestDataFactory.createSampleReferenceListForAddress();
    //    insert addressRefList;
    //    for(Integer i=0 ; i<addressRefList.size() ; i++) {
    //        if(i>0){
    //            addressRefList.get(i).Parent__c = addressRefList.get(i-1).Id;
    //        }
    //    }
    //    update addressRefList;      
    //}

    //public static testmethod void advamnttest()
    //{
    //    Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
    //    for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
    //        addressReference.put(addRef.Field__c, addRef);
    //    }
    //    Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
    //    List<Reference__c> referenceRecord = CXE_TestDataFactory.createReferencePicklist(2, 'Billing Class');
    //    insert referenceRecord;
    //    Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
    //    caseRecord.RecordTypeId = servRecTypeId;
    //    caseRecord.Billing_Class__c = 'Name0';
    //    insert caseRecord;
    //    Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
    //    addressRec.Case__c = caseRecord.Id;
    //    addressRec.Type__c = 'Billing';
    //    insert addressRec;
    //    List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
    //    Account testAccount = testAccountList.get(0);
    //    insert testAccount; 
    //    Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
    //    insert contactRecord;
    //    caseRecord.ContactId = contactRecord.id;
    //    List<Contract> testContractList = CXE_TestDataFactory.createContract(1, testAccount.Id, null);
    //    Contract testContract = testContractList.get(0);
    //    testContract.Case__c = caseRecord.Id;
    //    insert testContract;
    //    addressRec.Contract__c = testContract.Id;   
    //    addressRec.Account__c = testAccount.Id;
    //    update addressRec;
    //    Integer numberOfServices = 5;
    //    Integer additionalServices = 3;
    //    List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
    //    insert psicRecord;
    //    Agreement__c testAgreement = CXE_TestDataFactory.createService(numberOfServices, testAccount.id, null, testContract.Id, psicRecord[0].Id)[0];

    //    profile prf = [select Id from Profile where Name =: ADMIN_PROFILE Limit 1];
    //    User Testuser = testdatafactorytest.createuser('Lastname',prf.Id,Null);
    //    system.runas(Testuser)
    //    {

    //        /*Account acc = testdatafactorytest.createaccount('Test Account');
    //        Contract con = testdatafactorytest.createcontract(acc,'Inactive',system.today(),12);
    //        Agreement__c agr1 = testdatafactorytest.createagreement(acc,con.id,'12345',100);
    //        Agreement__c agr2 = testdatafactorytest.createagreement(acc,con.id,'123456',200);
    //        case cas = testdatafactorytest.createcase(acc,con.id,'New','Email');*/
    //        //cas.New_Advance_amount__c = 320;
    //        //update cas;
    //        caseRecord.New_Advance_amount__c = 320;
    //        update caseRecord;
    //        system.Test.setCurrentPage(Page.CaseAdvanceAmount);
    //        ApexPages.StandardController cont = new ApexPages.StandardController(caseRecord);
    //        Caseadvaamntcontroller caac = new Caseadvaamntcontroller(cont);
    //        system.test.starttest();
    //            caac.calculatenewval();
    //        system.test.stoptest();    
    //    }
    //   //System.assert(ApexPages.getMessages().get(0).getDetail().contains(''),ApexPages.getMessages().get(0).getDetail());
        
    //}
    
    //public static testmethod void advamnttest2()
    //{
    //    Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
    //    for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
    //        addressReference.put(addRef.Field__c, addRef);
    //    }
    //    Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
    //    List<Reference__c> referenceRecord = CXE_TestDataFactory.createReferencePicklist(2, 'Billing Class');
    //    insert referenceRecord;
    //    Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
    //    caseRecord.RecordTypeId = servRecTypeId;
    //    caseRecord.Billing_Class__c = 'Name0';
    //    insert caseRecord;
    //    Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
    //    addressRec.Case__c = caseRecord.Id;
    //    addressRec.Type__c = 'Billing';
    //    insert addressRec;
    //    List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
    //    Account testAccount = testAccountList.get(0);
    //    insert testAccount; 
    //    Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
    //    insert contactRecord;
    //    caseRecord.ContactId = contactRecord.id;
    //    List<Contract> testContractList = CXE_TestDataFactory.createContract(1, testAccount.Id, null);
    //    Contract testContract = testContractList.get(0);
    //    testContract.Case__c = caseRecord.Id;
    //    insert testContract;
    //    addressRec.Contract__c = testContract.Id;   
    //    addressRec.Account__c = testAccount.Id;
    //    update addressRec;
    //    Integer numberOfServices = 5;
    //    Integer additionalServices = 3;
    //    List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
    //    insert psicRecord;
    //    Agreement__c testAgreement = CXE_TestDataFactory.createService(numberOfServices, testAccount.id, null, testContract.Id, psicRecord[0].Id)[0];
    //    profile prf = [select Id from Profile where Name =: ADMIN_PROFILE Limit 1];
    //    User Testuser = testdatafactorytest.createuser('Lastname',prf.Id,Null);
    //    system.runas(Testuser)
    //    {
    //    /*    Account acc = testdatafactorytest.createaccount('Test Account');
    //        Contract con = testdatafactorytest.createcontract(acc,'Inactive',system.today(),12);
    //        Agreement__c agr1 = testdatafactorytest.createagreement(acc,con.id,'12345',100);
    //        Agreement__c agr2 = testdatafactorytest.createagreement(acc,con.id,'123456',200);
    //        case cas = testdatafactorytest.createcase(acc,con.id,'New','Email');
    //        cas.New_Advance_amount__c = 320;
    //        update cas;*/
    //        caseRecord.New_Advance_amount__c = 320;
    //        update caseRecord;
    //        system.Test.setCurrentPage(Page.CaseAdvanceAmount);
    //        ApexPages.StandardController cont = new ApexPages.StandardController(caseRecord);
    //        Caseadvaamntcontroller caac = new Caseadvaamntcontroller(cont);
    //        system.test.starttest();
    //            caac.customsave();
    //        system.test.stoptest();    
    //    }
    //    //system.assertequals(ApexPages.getMessages().get(0).getDetail(),Null);
        
    //}
    
    //public static testmethod void advamnttest3()
    //{
    //    Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
    //    for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
    //        addressReference.put(addRef.Field__c, addRef);
    //    }
    //    Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
    //    List<Reference__c> referenceRecord = CXE_TestDataFactory.createReferencePicklist(2, 'Billing Class');
    //    insert referenceRecord;
    //    Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
    //    caseRecord.RecordTypeId = servRecTypeId;
    //    caseRecord.Billing_Class__c = 'Name0';
    //    insert caseRecord;
    //    Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
    //    addressRec.Case__c = caseRecord.Id;
    //    addressRec.Type__c = 'Billing';
    //    insert addressRec;
    //    List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
    //    Account testAccount = testAccountList.get(0);
    //    insert testAccount; 
    //    Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
    //    insert contactRecord;
    //    caseRecord.ContactId = contactRecord.id;
    //    List<Contract> testContractList = CXE_TestDataFactory.createContract(1, testAccount.Id, null);
    //    Contract testContract = testContractList.get(0);
    //    testContract.Case__c = caseRecord.Id;
    //    insert testContract;
    //    addressRec.Contract__c = testContract.Id;   
    //    addressRec.Account__c = testAccount.Id;
    //    update addressRec;
    //    Integer numberOfServices = 5;
    //    Integer additionalServices = 3;
    //    List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
    //    insert psicRecord;
    //    Agreement__c testAgreement = CXE_TestDataFactory.createService(numberOfServices, testAccount.id, null, testContract.Id, psicRecord[0].Id)[0];
    //    profile prf = [select Id from Profile where Name =: ADMIN_PROFILE Limit 1];
    //    User Testuser = testdatafactorytest.createuser('Lastname',prf.Id,Null);
    //    system.runas(Testuser)
    //    {
    //        /*Account acc = testdatafactorytest.createaccount('Test Account');
    //        Contract con = testdatafactorytest.createcontract(acc,'Inactive',system.today(),12);
    //        Agreement__c agr1 = testdatafactorytest.createagreement(acc,con.id,'12345',100);
    //        Agreement__c agr2 = testdatafactorytest.createagreement(acc,con.id,'123456',200);
    //        case cas = testdatafactorytest.createcase(acc,con.id,'New','Email');*/
    //       // cas.New_Advance_amount__c = 0;
    //       // update cas;
    //        system.Test.setCurrentPage(Page.CaseAdvanceAmount);
    //        ApexPages.StandardController cont = new ApexPages.StandardController(caseRecord);
    //        Caseadvaamntcontroller caac = new Caseadvaamntcontroller(cont);
    //        system.test.starttest();
    //            caac.calculatenewval();
    //        system.test.stoptest();    
    //    }
    //    System.assert(ApexPages.getMessages().get(0).getDetail().contains('New Advance Amount Cannot be Zero'),ApexPages.getMessages().get(0).getDetail());
        
    //}
    
    //public static testmethod void advamnttest4()
    //{
    //    Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
    //    for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
    //        addressReference.put(addRef.Field__c, addRef);
    //    }
    //    Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
    //    List<Reference__c> referenceRecord = CXE_TestDataFactory.createReferencePicklist(2, 'Billing Class');
    //    insert referenceRecord;
    //    Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
    //    caseRecord.RecordTypeId = servRecTypeId;
    //    caseRecord.Billing_Class__c = 'Name0';
    //    insert caseRecord;
    //    Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
    //    addressRec.Case__c = caseRecord.Id;
    //    addressRec.Type__c = 'Billing';
    //    insert addressRec;
    //    List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
    //    Account testAccount = testAccountList.get(0);
    //    insert testAccount; 
    //    Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
    //    insert contactRecord;
    //    caseRecord.ContactId = contactRecord.id;
    //    List<Contract> testContractList = CXE_TestDataFactory.createContract(1, testAccount.Id, null);
    //    Contract testContract = testContractList.get(0);
    //    testContract.Case__c = caseRecord.Id;
    //    insert testContract;
    //    addressRec.Contract__c = testContract.Id;   
    //    addressRec.Account__c = testAccount.Id;
    //    update addressRec;
    //    Integer numberOfServices = 5;
    //    Integer additionalServices = 3;
    //    List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
    //    insert psicRecord;
    //    Agreement__c testAgreement = CXE_TestDataFactory.createService(numberOfServices, testAccount.id, null, testContract.Id, psicRecord[0].Id)[0];
    //    profile prf = [select Id from Profile where Name =: ADMIN_PROFILE Limit 1];
    //    User Testuser = testdatafactorytest.createuser('Lastname',prf.Id,Null);
    //    system.runas(Testuser)
    //    {
    //       /* Account acc = testdatafactorytest.createaccount('Test Account');
    //        Contract con = testdatafactorytest.createcontract(acc,'Inactive',system.today(),12);
    //        Agreement__c agr1 = testdatafactorytest.createagreement(acc,con.id,'12345',100);
    //        Agreement__c agr2 = testdatafactorytest.createagreement(acc,con.id,'123456',200);
    //        case cas = testdatafactorytest.createcase(acc,con.id,'New','Email');
    //        cas.New_Advance_amount__c = 102;
    //        update cas;*/
    //        caseRecord.New_Advance_amount__c = 102;
    //        update caseRecord;
            
    //        system.Test.setCurrentPage(Page.CaseAdvanceAmount);
    //        ApexPages.StandardController cont = new ApexPages.StandardController(caseRecord);
    //        Caseadvaamntcontroller caac = new Caseadvaamntcontroller(cont);
    //        system.test.starttest();
    //            caac.calculatenewval();
    //        system.test.stoptest();    
    //    }
    //    System.assert(ApexPages.getMessages().get(0).getDetail().contains('The new Advance amount may not be 25% higher or lower than the original Advance amount'),ApexPages.getMessages().get(0).getDetail());
        
    //}
    
    //public static testmethod void advamnttest5()
    //{
    //    Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
    //    for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
    //        addressReference.put(addRef.Field__c, addRef);
    //    }
    //    Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
    //    List<Reference__c> referenceRecord = CXE_TestDataFactory.createReferencePicklist(2, 'Billing Class');
    //    insert referenceRecord;
    //    Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
    //    caseRecord.RecordTypeId = servRecTypeId;
    //    caseRecord.Billing_Class__c = 'Name0';
    //    insert caseRecord;
    //    Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
    //    addressRec.Case__c = caseRecord.Id;
    //    addressRec.Type__c = 'Billing';
    //    insert addressRec;
    //    List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
    //    Account testAccount = testAccountList.get(0);
    //    insert testAccount; 
    //    Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
    //    insert contactRecord;
    //    caseRecord.ContactId = contactRecord.id;
    //    List<Contract> testContractList = CXE_TestDataFactory.createContract(1, testAccount.Id, null);
    //    Contract testContract = testContractList.get(0);
    //    testContract.Case__c = caseRecord.Id;
    //    insert testContract;
    //    addressRec.Contract__c = testContract.Id;   
    //    addressRec.Account__c = testAccount.Id;
    //    update addressRec;
    //    Integer numberOfServices = 5;
    //    Integer additionalServices = 3;
    //    List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
    //    insert psicRecord;
    //    Agreement__c testAgreement = CXE_TestDataFactory.createService(numberOfServices, testAccount.id, null, testContract.Id, psicRecord[0].Id)[0];
    //    profile prf = [select Id from Profile where Name =: ADMIN_PROFILE Limit 1];
    //    User Testuser = testdatafactorytest.createuser('Lastname',prf.Id,Null);
    //    system.runas(Testuser)
    //    {
    //        /*Account acc = testdatafactorytest.createaccount('Test Account');
    //        Contract con = testdatafactorytest.createcontract(acc,'Inactive',system.today(),12);
    //        Agreement__c agr1 = testdatafactorytest.createagreement(acc,con.id,'12345',100);
    //        Agreement__c agr2 = testdatafactorytest.createagreement(acc,con.id,'123456',200);
    //        case cas = testdatafactorytest.createcase(acc,con.id,'New','Email');
    //        cas.New_Advance_amount__c = 300;
    //        update cas;*/
    //        caseRecord.New_Advance_amount__c = 300;
    //        update caseRecord;
    //        system.Test.setCurrentPage(Page.CaseAdvanceAmount);
    //        ApexPages.StandardController cont = new ApexPages.StandardController(caseRecord);
    //        Caseadvaamntcontroller caac = new Caseadvaamntcontroller(cont);
    //        system.test.starttest();
    //            caac.calculatenewval();
    //        system.test.stoptest();    
    //    }
    //    //System.assert(ApexPages.getMessages().get(0).getDetail().contains('New and Old Advance Amounts are same. Please change the New Advance Amount'),ApexPages.getMessages().get(0).getDetail());
        
    //}
    
    //public static testmethod void advamnttest6()
    //{
    //    Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
    //    for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
    //        addressReference.put(addRef.Field__c, addRef);
    //    }
    //    Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
    //    List<Reference__c> referenceRecord = CXE_TestDataFactory.createReferencePicklist(2, 'Billing Class');
    //    insert referenceRecord;
    //    Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
    //    caseRecord.RecordTypeId = servRecTypeId;
    //    caseRecord.Billing_Class__c = 'Name0';
    //    insert caseRecord;
    //    Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
    //    addressRec.Case__c = caseRecord.Id;
    //    addressRec.Type__c = 'Billing';
    //    insert addressRec;
    //    List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
    //    Account testAccount = testAccountList.get(0);
    //    insert testAccount; 
    //    Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
    //    insert contactRecord;
    //    caseRecord.ContactId = contactRecord.id;
    //    List<Contract> testContractList = CXE_TestDataFactory.createContract(1, testAccount.Id, null);
    //    Contract testContract = testContractList.get(0);
    //    testContract.Case__c = caseRecord.Id;
    //    insert testContract;
    //    addressRec.Contract__c = testContract.Id;   
    //    addressRec.Account__c = testAccount.Id;
    //    update addressRec;
    //    Integer numberOfServices = 5;
    //    Integer additionalServices = 3;
    //    List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
    //    insert psicRecord;
    //    profile prf = [select Id from Profile where Name =: ADMIN_PROFILE Limit 1];
    //    User Testuser = testdatafactorytest.createuser('Lastname',prf.Id,Null);
    //    system.runas(Testuser)
    //    {
    //        /*Account acc = testdatafactorytest.createaccount('Test Account');
    //        Contract con = testdatafactorytest.createcontract(acc,'Inactive',system.today(),12);
    //        Agreement__c agr1 = testdatafactorytest.createagreement(acc,con.id,'12345',100);
    //        Agreement__c agr2 = testdatafactorytest.createagreement(acc,con.id,'123456',200);
    //        case cas = testdatafactorytest.createcase(acc,con.id,'New','Email');
    //        cas.New_Advance_amount__c = 320;
    //        update cas;*/
    //        caseRecord.New_Advance_amount__c = 320;
    //        update caseRecord;
    //        system.Test.setCurrentPage(Page.CaseAdvanceAmount);
    //        ApexPages.StandardController cont = new ApexPages.StandardController(caseRecord);
    //        Caseadvaamntcontroller caac = new Caseadvaamntcontroller(cont);
    //        system.test.starttest();
    //            caac.cancel();
    //        system.test.stoptest();    
    //    }
    //    //system.assertequals(ApexPages.getMessages().get(0).getDetail(),Null);
        
    //}
    
}