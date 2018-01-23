public with sharing class CXE_CaseResponseWrapper {
	@AuraEnabled
    public String caseNumber {get; set;}

    @AuraEnabled
    public String caseRecordId {get; set;}

    @AuraEnabled
    public String notificationChannels {get; set;}
     
    @AuraEnabled
    public Boolean hasError {get; set;}

    @AuraEnabled
    public String errorMessage {get; set;}

    @AuraEnabled
    public List<String> errorMessages {get; set;}

    @AuraEnabled
    public Boolean isTerminate {get; set;} // CSM-7248  Jerome To   JUL-04-2017

    @AuraEnabled
    public List<Case_State_Transition__c> caseStateTransitions {get; set;}

    //@AuraEnabled
    //public List<CaseHistory> caseStatusHistoryList {get; set;}

    @AuraEnabled
    public List<CXE_CaseHistoryWrapper> caseStatusHistoryList {get; set;}    

    @AuraEnabled
    public String statusJourney {get; set;}

    @AuraEnabled
    public Case caseRecord {get; set;}
}