@isTest
public class CXE_CP_ConglomerateViewCtrl_Test {

    @isTest
    public static void checkAccountIfConglomerate(){
        
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
        
        	CXE_CP_ConglomerateViewCtrl.checkAccountIfConglomerate(accountList[0].Id);
        test.stopTest();
    }
}