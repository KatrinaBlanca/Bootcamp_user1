/* Description: Test Class for PartnerTrgger Handler
 * Author: Von Pernicia
 * Date Created: FEB-15-17
 */
@isTest
private class PartnerTriggerHandlerTest {

    static testMethod void createPartnerRecord() {
        Test.startTest();
     
        List<Account> generateAccts = CXE_TestDataFactory.createBusinessAccount(1);
        insert generateAccts;
        
        Partner__c partnerRecord = new Partner__c();
            
       // partnerRecord.Partners__c =generateAccts[0].Id;
        partnerRecord.Role__c ='Supplier';
        partnerRecord.Account_Name__c =generateAccts[0].Id;
        
        insert partnerRecord;
        Test.stopTest();
        System.AssertEquals(generateAccts, generateAccts);
        System.AssertEquals( partnerRecord, partnerRecord);
        
    }
    
    
    static testMethod void deletePartnerRecord() {
        Test.startTest();
        
        List<Account> generateAccts = CXE_TestDataFactory.createBusinessAccount(1);
        insert generateAccts;
        
        Partner__c partnerRecord = new Partner__c();
        
        // partnerRecord.Partners__c =generateAccts[0].Id;
        partnerRecord.Role__c ='Supplier';
        partnerRecord.Account_Name__c =generateAccts[0].Id;
        
        insert partnerRecord;
        
        Partner__c deleteRec = [SELECT Id FROM  Partner__c LIMIT 1];

        delete deleteRec;
        
        
        PartnerTriggerHandler pt = new PartnerTriggerHandler();
        pt.BeforeUpdate(null,null);
        pt.AfterUpdate(null,null);
        pt.AfterUndelete(null);
        
        Test.stopTest();
        System.AssertEquals(generateAccts, generateAccts);
        System.AssertEquals( partnerRecord, partnerRecord);
        
    }
    
    
    
    
        
        /*
        List<Account> accountRecord = CXE_TestDataFactory.createPersonAccount(2);
        insert accountRecord;
        
        Partner__c partnerRecord = CXE_TestDataFactory.createPartnerRole(1, accountRecord[0].id, accountRecord[1].id)[0];
        
        test.startTest();
        insert partnerRecord;
        test.stopTest();
        
        PartnerTriggerHandler pt = new PartnerTriggerHandler();
        pt.BeforeUpdate(null,null);
        pt.AfterUpdate(null,null);
        pt.AfterUndelete(null);
        
        List<Partner__c> partnerList = [Select id from Partner__c];
        system.assertequals(2, partnerList.size());
        System.debug('Umaasa sa logs >>>>>>>>>>>'+partnerRecord.Id);
			
        */
        
    

    /*    
    static testMethod void deletePartnerRecord() {
        
        List<Account> accountRecord = CXE_TestDataFactory.createPersonAccount(2);
        insert accountRecord;
        
        Partner__c partnerRecord = CXE_TestDataFactory.createPartnerRole(1, accountRecord[0].id, accountRecord[1].id)[0];
        test.startTest();
        insert partnerRecord;
        test.stopTest();
        
        delete partnerRecord;
        
        PartnerTriggerHandler pt = new PartnerTriggerHandler();
        pt.BeforeUpdate(null,null);
        pt.AfterUpdate(null,null);
        pt.AfterUndelete(null);
        
        List<Partner__c> partnerList = [Select id from Partner__c];
        system.assertequals(0, partnerList.size());
    }
    */
}