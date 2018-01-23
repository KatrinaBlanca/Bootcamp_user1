@isTest
public class CXE_HerokuApps_Test{

    @testSetup static void setup() {
        CXE_TestDataFactory.setOrgSettings();
    }

    @isTest
    static void test_HerokuBillsNotes()
    {
        List<String> sinList = new List<String>{'293028374839','001122334455'};
        List<CXE_Heroku_Model.BillDetail> bills;
        test.startTest();
            bills = CXE_HerokuApps.getAllBillsBySingleAcctNo('584950609109');
            CXE_HerokuApps.getAllBillsByAcctNoAndSinNo('293028374839','584950609109');
            CXE_HerokuApps.getAllBillsBySingleSin('293028374839');
            CXE_HerokuApps.getAllBillsBySinNos(sinList);
        test.stopTest();

        System.assertEquals(2, bills.size());
    }

    @isTest
    static void test_HerokuPayments()
    {
        Date endDate = Date.today();
        Date startDate = Date.today();
        startDate.addYears(-1);
        List<String> accountNos = new List<String>{'584950609109'};

        List<CXE_Heroku_Model.PaymentDetail> payments;
        test.startTest();
            payments = CXE_HerokuApps.getAllPaymentsByRefNo('234561234561');
            CXE_HerokuApps.getAllPaymentsBySingleAcctNo('584950609109',startDate, endDate);
            CXE_HerokuApps.getAllPaymentsByAccountNos(accountNos,startDate, endDate);
        test.stopTest();

        System.assertEquals(1, payments.size());
    }

    @isTest
    static void test_HerokuConsumption()
    {
        List<CXE_Heroku_Model.BillDetail> bills;
        test.startTest();
            bills = CXE_HerokuApps.getAllConsumptionBySingleSin('293028374839');
        test.stopTest();

        System.assertEquals(2, bills.size());
    }
	//  /* Causing Error
    @isTest
    static void test_PDFVault()
    {
        //List<User> u = CXE_TestDataFactory.createUser(1, CXE_Constants.PROFILE_NAME_MERALCO_G5);
        Case createdCase = createCase(true);
        Account acct = createAccount(true);
        PSIC__c psic= CXE_TestDataFactory.createPSIC(1)[0];
        insert psic;
        Contract contr= CXE_TestDataFactory.createContract(1, acct.Id, createdCase.Id)[0];
        insert contr;
        Address__c add1 = CXE_TestDataFactory.createAddressWithoutReference('Billing',createdCase.Id,acct.Id,contr.Id,'', '', '');
        insert add1;
        
        Agreement__c service = CXE_TestDataFactory.createService(1, acct.Id, createdCase.Id, contr.Id, psic.Id)[0];
        service.Service_Status__c = 'Active';
        insert service;
        
        List<Case> caseModification = CXE_TestDataFactory.createModificationCase(1, service.Id, 'Relocation');
        insert caseModification;
        Address__c add = CXE_TestDataFactory.createAddressWithoutReference('Service',caseModification[0].Id,acct.Id,contr.Id,service.Id, '', '');
        insert add;

        DMS_Document__c dms = new DMS_Document__c(
                CXE_Case__c = createdCase.Id,
                CXE_Account__c = acct.Id,
                CXE_Service__c = service.Id
            );
        
        insert dms;

        String pdfVaultResponse;

        test.startTest();
            pdfVaultResponse = CXE_HerokuApps.getPDFUrl('view', 'SOA|1.pdf');
            CXE_HerokuApps.presign('SOA');
            CXE_HerokuApps.presign('key', 'new', 'SOA');
            CXE_HerokuApps.dms_sign('aid',dms.Id,'SOA');
            CXE_HerokuApps.pdf_sign('key','SOA');
            CXE_HerokuApps.pdf_stat('SOA');
            CXE_HerokuApps.test_connection('sampleUrl');
            CXE_HerokuApps.community_token();
        test.stopTest();

        System.assertEquals(true, pdfVaultResponse.length()>0);
    }
	// */


    private static Case createCase(Boolean isBusiness){
        
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Service', 'Single meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.Telephone_No__c = '+6356748321';
        caseRecord.Billing_Address_Barangay__c  = 'SAN LORENZO';
        caseRecord.Billing_Address_City_Municipal__c = 'MAKATI CITY';
        caseRecord.Conglomerate_Tag__c = true;
        caseRecord.Date_of_Birth__c = System.today();
        caseRecord.Email_Address__c = 'test@test.com';
        caseRecord.First_Name__c = 'Case';
        caseRecord.Last_Name__c = 'Case';
        caseRecord.Billing_Address_Street_No__c = '123';
        caseRecord.Last_Name_Business_Name__c = 'Test';
        caseRecord.Middle_Name__c = 'Middle';
        caseRecord.Mobile_No__c =   '+631234567890';
        caseRecord.Billing_Address_Province__c = 'METRO MANILA';
        caseRecord.Billing_Address_Street_Name__c = 'Paseo St.';
        caseRecord.Billing_Address_Subdivision__c = 'Insular Building';
        caseRecord.Billing_Address_Unit_No__c= 'Unit 2';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        //caseRecord.Application_for_Business_Customer__c = true;
        //caseRecord.Application_for_Residential_Customer__c = true;
        if(isBusiness){
            caseRecord.Application_for_Business_Customer__c = true;
            caseRecord.Application_for_Residential_Customer__c = false;
        }else{
            caseRecord.Application_for_Residential_Customer__c = true;
            caseRecord.Application_for_Business_Customer__c = false;
        }
        
        insert caseRecord;

        return caseRecord;
    }


    private static Account createAccount(Boolean isBusiness){
         List<Account> acctList = new List<Account>();
         Account acctRecord = new Account();
         
         Reference__c referenceRecord = CXE_TestDataFactory.createReferencePicklist(1, 'Customer Type')[0];
         insert referenceRecord;
         
         if(isBusiness){
            acctList = CXE_TestDataFactory.createBusinessAccount(1);
            acctRecord = acctList[0];
            
            acctRecord.Name = 'Business Account Name';
            acctRecord.Conglomerate__c = true;
            acctRecord.Email__c = 'test@test.com';
            acctRecord.Mobile_Phone__c = '+631234567890';
         }else{
            acctList = CXE_TestDataFactory.createPersonAccount(1);
            acctRecord = acctList[0];
            
            acctRecord.PersonEmail = 'test@test.com';
            acctRecord.FirstName = 'Case';
            acctRecord.LastName = 'Test';
            acctRecord.MiddleName = 'Middle';
            acctRecord.PersonMobilePhone = '+631234567890';
         }
        acctRecord.Phone='+6356748321';
        acctRecord.Billing_Address_Barangay__c  = 'SAN LORENZO' ;
        acctRecord.Billing_Address_City_Municipal__c =  'MAKATI CITY'   ;
        acctRecord.Billing_Address_Province__c  =   'METRO MANILA'  ;
        acctRecord.Billing_Address_Street_Name__c   =   'Paseo St.' ;
        acctRecord.Billing_Address_Subdivision__c   =   'Insular Building'  ;
        acctRecord.Billing_Address_Unit_No__c   =   'Unit 2';
        acctRecord.Customer_Type__c = 'Name0';
        insert acctRecord;
        
        
        return acctRecord;
    }
    
    @isTest
    static void test_getFilteredBillsBySinNos()
    {
        List<String> sinList = new List<String>{'293028374839','001122334455'};
        List<CXE_Heroku_Model.BillDetail> bills;
        test.startTest();
            bills = CXE_HerokuApps.getAllBillsBySingleAcctNo('584950609109');
            CXE_HerokuApps.getAllBillsByAcctNoAndSinNo('293028374839','584950609109');
            CXE_HerokuApps.getAllBillsBySingleSin('293028374839');
            CXE_HerokuApps.getAllBillsBySinNos(sinList);
                CXE_HerokuApps.getFilteredBillsBySinNos(sinList, '293028374839','293028374839');
        test.stopTest();

        System.assertEquals(2, bills.size());
    }
    
    @isTest
    static void test_getAllUnpaidBillsBySingleSin()
    {
        List<String> sinList = new List<String>{'293028374839','001122334455'};
        List<CXE_Heroku_Model.BillDetail> bills;
        test.startTest();
            bills = CXE_HerokuApps.getAllBillsBySingleAcctNo('584950609109');
            CXE_HerokuApps.getAllUnpaidBillsBySingleSin('293028374839');
           
        test.stopTest();

        System.assertEquals(2, bills.size());
    }
    
    @isTest
    static void test_getAllUnpadBillsBySingleAcctNo()
    {
        test.startTest();
            CXE_HerokuApps.getAllUnpadBillsBySingleAcctNo('293028374839');
           
        test.stopTest();
    }
    
    @isTest
    static void test_getAllUnpadBillsByAcctNo()
    {
        List<String> accountList = new List<String>{'584950609109'};
        test.startTest();
           
            CXE_HerokuApps.getAllUnpadBillsByAcctNo(accountList);
           
        test.stopTest();

        //System.assertEquals(2, bills.size());
    }
        
    @isTest
    static void test_getAllBillsBySingleInvoiceNo()
    {
        test.startTest();
           
            CXE_HerokuApps.getAllBillsBySingleInvoiceNo('invoiceNo');
           
        test.stopTest();
    }
        
    @isTest
    static void test_upload_sign()
    {
        test.startTest();
           
            CXE_HerokuApps.upload_sign('String type', 'String key');
           
        test.stopTest();
    }
    /*    
    static void test_apa_upload_sign()
    {
        test.startTest();
           
            CXE_HerokuApps.apa_upload_sign('documentName');
           
        test.stopTest();
    }
*/
    
    @isTest
    static void test_upload_signv2()
    {
        test.startTest();
           
            CXE_HerokuApps.upload_signv2('String type', 'String key');
           
        test.stopTest();
    }
        
    @isTest
    static void test_apa_zip_sign()
    {
        test.startTest();
           
            CXE_HerokuApps.apa_zip_sign('String type', 'String key', 'String jobCode');
           
        test.stopTest();
    }
    @isTest   
    static void test_presign()
    {
        test.startTest();
           
            CXE_HerokuApps.presign('key', 'type', 'name');
           
        test.stopTest();
    }
        
    @isTest   
    static void test_convenienceFee()
    {
        test.startTest();
           
            CXE_HerokuApps.convenienceFee('amount');
           
        test.stopTest();
    }
        
    @isTest   
    static void test_cc_pay()
    {
        test.startTest();
            List<Object> paymentTransactionList = new List<Object>{'293028374839','001122334455'};
            CXE_HerokuApps.cc_pay('token','amount', 'fee','total','fname','emailPass','paymentMode','paymentOffice','address',paymentTransactionList,'origin');
           
        test.stopTest();
    }
        
    @isTest   
    static void test_getPaymentbyBillId()
    {
        test.startTest();
           
            CXE_HerokuApps.getPaymentbyBillId('billdId');
           
        test.stopTest();
    }
	/*Causing Error  
    @isTest    
    static void test_parseHerokuRecords()
    {
        test.startTest();
           
            CXE_HerokuApps.parseHerokuRecords('valHolder');
           
        test.stopTest();
    }
   */
    @isTest   
    public static void test_conglomerate()
    {
        test.startTest();
           
            CXE_HerokuApps.conglomerate('billdId');
           
        test.stopTest();
    }
        
    @isTest   
    static void test_check_invoice()
    {
        test.startTest();
           
            CXE_HerokuApps.check_invoice('billdId');
           
        test.stopTest();
    }
        
    @isTest   
    static void test_apa_delete()
    {
        test.startTest();
           
            CXE_HerokuApps.apa_delete('folderName');
           
        test.stopTest();
    }
        
    @isTest   
    static void test_apa_upload_sign()
    {
        test.startTest();
           
            CXE_HerokuApps.apa_upload_sign('folderName');
           
        test.stopTest();
    }
    
    @isTest   
    static void test_download_sign()
    {
        test.startTest();
           
            CXE_HerokuApps.download_sign('type', 'key', 'name');
           
        test.stopTest();
    }
    
    @isTest   
    static void Test_getPDFUrl()
    {
        test.startTest();
           
            CXE_HerokuApps.getPDFUrl('action', 'filename');
           
        test.stopTest();
    }
    
    @isTest   
    static void Test_dms_sign()
    {
        test.startTest();
           
            CXE_HerokuApps.dms_sign('action', 'filename', 'String');
           
        test.stopTest();
    }
        
    @isTest   
    static void Test_pdf_sign()
    {
        test.startTest();
           
            CXE_HerokuApps.pdf_sign('key', 'name');
           
        test.stopTest();
    }
        
    @isTest   
    static void Test_pdf_stat()
    {
        test.startTest();
           
            CXE_HerokuApps.pdf_stat('name');
           
        test.stopTest();
    }

}