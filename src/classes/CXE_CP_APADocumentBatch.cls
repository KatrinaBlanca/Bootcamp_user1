/* 
 * Description: Scheduled Batch which creates a new APA record per day
 * Author: Von Pernicia (Accenture)
 * Date Created: NOV-09-17
 * Requirement: CSM-13169
 */ 
global class CXE_CP_APADocumentBatch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        Auto_Payment_Arrangement__c newApa = new Auto_Payment_Arrangement__c();
        List<Auto_Payment_Arrangement__c> existingApa = new List<Auto_Payment_Arrangement__c>();
        Date dateYesterday = system.today() - 1;
        existingApa = [SELECT Id FROM Auto_Payment_Arrangement__c WHERE Date__c =:dateYesterday];
        
        if(existingApa.isEmpty()) {
            newApa.Date__c = dateYesterday;
            newApa.Status__c = 'Available';
            insert newApa;
        }
    }


}