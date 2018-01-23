/* 
 * Description: Component Controller for ServiceApplication App and Components
 * Returns: Return type
 * Author: Jerome To
 * Date Created: MAR-14-17
*/ 
public with sharing class CXE_WebToCaseApplication {
	//@AuraEnabled
 //   public static List<String> getHomeOwnership(){
 //   	List<String> options = new List<String>();
	//	Schema.DescribeFieldResult fieldResult = Case.Home_Ownership__c.getDescribe();
	//	List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	//	for (Schema.PicklistEntry f: ple) {
	//	    options.add(f.getLabel());
	//	}
	//	return options;
 //   }

 //   @AuraEnabled
 //   public static List<String> getSalutations(){
 //   	List<String> options = new List<String>();
	//	Schema.DescribeFieldResult fieldResult = Case.Salutation__c.getDescribe();
	//	List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	//	for (Schema.PicklistEntry f: ple) {
	//	    options.add(f.getLabel());
	//	}
	//	return options;
 //   }

 //   @AuraEnabled
 //   public static CXE_CaseResponseWrapper submitCaseApplication(Case caseApplication, Address__c addressRecord) {
 //   	List<CXE_CaseResponseWrapper> responseList = new List<CXE_CaseResponseWrapper>();
 //   	Set<Id> newCases = new Set<Id>();

	//	// Specify DML options to ensure the assignment rules are executed
	//	Database.DMLOptions dmlOpts = new Database.DMLOptions();
	//	dmlOpts.assignmentRuleHeader.useDefaultRule = true;
	//	caseApplication.setOptions(dmlOpts);
	//	caseApplication.Origin = CXE_Constants.CASE_ORIGIN_WEB;

 //   	List<Database.SaveResult> srList = Database.insert(new List<Case> {caseApplication}, false);

	//	for (Database.SaveResult sr : srList) {
	//	    if (sr.isSuccess()) {
	//	    	CXE_CaseResponseWrapper response = new CXE_CaseResponseWrapper();
	//	    	response.hasError=false;
	//	    	response.caseRecordId=sr.getId();
	//	        responseList.add(response);

	//	        newCases.add(sr.getId());
	//	    }
	//	    else {
	//	    	String errors = '';		    	
	//	    	List<String> errorList = new List<String>();
	//	    	errorList.add(CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING1);
	//	        for(Database.Error err : sr.getErrors()) {
	//	            //errors += err.getStatusCode() + ': ' + err.getMessage();
	//	            errorList.add(err.getMessage());
	//	            //errors += CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING2 + err.getFields();
	//	        }
	//	        errors += String.join(errorList, '');
	//	        CXE_CaseResponseWrapper response = new CXE_CaseResponseWrapper();
	//	    	response.hasError=true;
	//	    	response.errorMessage=errors;
	//	        responseList.add(response);
	//	    }
	//	}

	//	if(!newCases.isEmpty()) {
	//		Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, CaseNumber FROM Case WHERE Id=:newCases]);
	//		for(CXE_CaseResponseWrapper response : responseList) {
	//			if(!response.hasError) {
	//				response.caseNumber = caseMap.get(response.caseRecordId).CaseNumber;
	//			}
	//		}
	//	}

	//	if(addressRecord != null) {
			
 //   		addressRecord.Type__c = CXE_Constants.ADDRESS_TYPE_CUSTOMER;
	//		addressRecord.Case__c = responseList.get(0).caseRecordId;
	//		List<Database.SaveResult> addressResultList = Database.insert(new List<Address__c> {addressRecord}, false);
			
	//		for (Database.SaveResult sr : addressResultList) {
	//		    if (!sr.isSuccess()) {
	//		    	String errors = '';		    	
	//		    	List<String> errorList = new List<String>();
	//		    	errorList.add(String.format(CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING3, new List<String>{responseList.get(0).caseNumber}));
	//		        errorList.add(CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING1);
	//		        for(Database.Error err : sr.getErrors()) {
	//		            //errors += err.getStatusCode() + ': ' + err.getMessage();
	//		            errorList.add(err.getMessage());
	//		            //errors += CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING2 + err.getFields();
	//		        }
	//		        errors += String.join(errorList, '');
			        
	//		    	responseList.get(0).hasError=true;
	//		    	responseList.get(0).errorMessage=errors;
	//		    }			   
	//		}
	//	}

	//	return responseList.get(0);
 //   }

 //   @AuraEnabled
	//public static List<Reference__c> getAddressReference(String searchInput, String fieldGroup) {   
	//	List<Reference__c> refList = new List<Reference__c>();
	//	if(!String.isBlank(searchInput)) {			
	//		String queryFilter = searchInput+'%';
	//		for(Reference__c addRec: [SELECT Id, Name, Field__c, Parent_Code__c, 
	//										  Name_Code__c, Parent__r.Name, Block__c,
	//										  Parent__r.Id
	//								   FROM Reference__c 
	//								   WHERE Name LIKE: queryFilter
	//								   AND Type__c = 'Geo'
	//								   AND Field__c = :fieldGroup]) {				
	//			refList.add(addRec);
	//		}			
			
	//	}
	//	return refList;
	//}

	//@AuraEnabled
 //   public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) { 
 //       base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
 //       Attachment a = new Attachment();
 //       a.parentId = parentId;

 //       a.Body = EncodingUtil.base64Decode(base64Data);
 //       a.Name = fileName;
 //       a.ContentType = contentType;
        
 //       insert a;
        
 //       return a.Id;
 //   }

}