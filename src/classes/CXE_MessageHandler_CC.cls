public class CXE_MessageHandler_CC {
	@AuraEnabled
    public static Case getCaseDetails(String caseId){
        Case caseRec = new Case();
        if(caseId != null){
    		caseRec = [SELECT Id, RecordType.DeveloperName, CXE_isRequireArrears__c, CXE_isClickBillDepositButton__c 
    					FROM Case WHERE Id=:caseId LIMIT 1];
        }
        return caseRec;
    }
}