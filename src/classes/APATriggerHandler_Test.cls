@isTest
public class APATriggerHandler_Test {
    
    @isTest
    static void testUpdateStatusToDownloaded(){
        DateTime lastDownloadedTime = System.now() - 10;
        Auto_Payment_Arrangement__c apaRec = new Auto_Payment_Arrangement__c();
        apaRec.Status__c = 'Available';
        apaRec.Date__c = date.today();
        apaRec.Last_Downloaded_Time__c = lastDownloadedTime;
        insert apaRec;

        test.startTest();
        apaRec.Status__c = 'Downloaded';
        update apaRec;

        Auto_Payment_Arrangement__c updatedAPARec = [SELECT Last_Downloaded_Time__c 
                                                        FROM Auto_Payment_Arrangement__c 
                                                        WHERE Id=:apaRec.Id LIMIT 1];

        System.assertNotEquals(updatedAPARec.Last_Downloaded_Time__c, lastDownloadedTime);
        test.stopTest();
    }

    @isTest
    static void testAutoPurge(){
        DateTime lastDownloadedTime = System.now();
        Auto_Payment_Arrangement__c apaRec = new Auto_Payment_Arrangement__c();
        apaRec.Status__c = 'Downloaded';
        apaRec.Date__c = date.today();
        apaRec.Last_Downloaded_Time__c = lastDownloadedTime;
        insert apaRec;

        test.startTest();
        apaRec.CXE_isForPurging__c = true;
        update apaRec;

        Auto_Payment_Arrangement__c updatedAPARec = [SELECT Status__c 
                                                        FROM Auto_Payment_Arrangement__c 
                                                        WHERE Id=:apaRec.Id  LIMIT 1];
                                                        
        System.assertEquals('Deleted', updatedAPARec.Status__c);
        test.stopTest();
    }

    @isTest
    static void testDeleteUndelete(){
        Map<Id, SObject> oldMap = new Map<Id, SObject>();
        APATriggerHandler apa = new APATriggerHandler();
        apa.BeforeDelete(oldMap);
        apa.AfterDelete(oldMap);
        apa.AfterUndelete(oldMap);
    }
}