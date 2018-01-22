public with sharing class CXE_CaseHistoryWrapper {
    @AuraEnabled
    public String caseId {get; set;}

    @AuraEnabled
    public Object NewValue {get; set;}
    
    @AuraEnabled
    public Object OldValue {get; set;}
     
    @AuraEnabled
    public String Remarks {get; set;}
    
    @AuraEnabled
    public String Field {get; set;}

    @AuraEnabled
    public DateTime CreatedDate {get; set;}    
}