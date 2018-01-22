@isTest
public class CXE_CP_ConglomerateTableCtrl_Test {
    @testSetup
    static void setupOrgData(){
        OrganizationSettings__c orgSet = new OrganizationSettings__c();
        orgSet.Heroku_Basic_Auth__c = 'Basic TEST=';
        insert orgSet;
    }
    
    @isTest 
    static void test_retrieveConglomerateDetails(){
        
        test.startTest();
        Boolean checker;
        Integer count = 1;
        List<Account> accountList = new List<Account>();
        
        Id personAccountRecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(CXE_Constants.RECORD_TYPE_NAME_ACCOUNT_PERSON).getRecordTypeId();
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            
            Account acc = new Account();
            
            acc.RecordTypeId = personAccountRecordTypeId;
            acc.FirstName = 'FName: ' + recordCount + count;
            acc.MiddleName = 'MName: '+recordCount + count;
            acc.LastName = 'LName: '+recordCount + count;
            acc.PersonBirthdate = System.today() - 30;
            acc.Phone = '+6300000000';
            acc.PersonMobilePhone = '+630000000000'; 
            acc.PersonEmail = 'test@test.com';
            acc.Tax_Identification_No__c = '123456789012';
            acc.Mobile_Phone__c = '+630000000000';
            acc.Email__c = 'test@test.com';
            acc.Conglomerate__c = true;            
            accountList.add(acc);
        }
        
        insert(accountList);
        try{    
            CXE_CP_ConglomerateTableCtrl.retrieveConglomerateDetails(accountList[0].Id);
        }catch(Exception e){}
        test.stopTest();
        
        
    }
    
    @isTest static void test_conglomerateDisplay(){
        test.startTest();
                Boolean checker;
        Integer count = 1;
        List<Account> accountList = new List<Account>();
        
        Id personAccountRecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(CXE_Constants.RECORD_TYPE_NAME_ACCOUNT_PERSON).getRecordTypeId();
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            
            Account acc = new Account();
            
            acc.RecordTypeId = personAccountRecordTypeId;
            acc.FirstName = 'FName: ' + recordCount + count;
            acc.MiddleName = 'MName: '+recordCount + count;
            acc.LastName = 'LName: '+recordCount + count;
            acc.PersonBirthdate = System.today() - 30;
            acc.Phone = '+6300000000';
            acc.PersonMobilePhone = '+630000000000'; 
            acc.PersonEmail = 'test@test.com';
            acc.Tax_Identification_No__c = '123456789012';
            acc.Mobile_Phone__c = '+630000000000';
            acc.Email__c = 'test@test.com';
            acc.Conglomerate__c = true;            
            accountList.add(acc);
        }
        
        insert(accountList);

        List<CXE_Heroku_Model.ConglomerateDetail> congloDetails = new List<CXE_Heroku_Model.ConglomerateDetail>();
        CXE_Heroku_Model.ConglomerateDetail congloDetail = new CXE_Heroku_Model.ConglomerateDetail();
        conglodetail.account_id = accountList[0].Id;
        conglodetail.parent_id = '';
        conglodetail.direct_sin = 123456789;
        conglodetail.direct_kwh = 100;
        conglodetail.direct_bill_demand = 200;
        conglodetail.direct_prev_bal = 300;
        conglodetail.direct_bill_amt = 400;
        conglodetail.direct_pay_amt = 500;
        conglodetail.direct_pending_amt = 600;
        conglodetail.total_sin = 700;
        conglodetail.total_kwh = 800;
        conglodetail.total_bill_demand = 900;
        conglodetail.total_prev_bal = 1000;
        conglodetail.total_bill_amt = 1100;
        conglodetail.total_pay_amt = 1200;
        conglodetail.total_pending_amt = 1200;
        congloDetails.add(congloDetail);
        
        CXE_CP_ConglomerateTableCtrl.ConglomerateData conglodata = CXE_CP_ConglomerateTableCtrl.conglomerateDisplay(congloDetails, accountList[0].Id);
        System.assert(conglodata != null);
        test.stopTest();
    }

}