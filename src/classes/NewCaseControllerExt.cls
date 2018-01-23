public class NewCaseControllerExt {

    //public Map<Id, String> caseRecordTypeIdToNameMap {get; set;}    
    //public Map<Id, String> caseRecordTypeIdToDefaultSubjectMap {get; set;}  
    
    //private ApexPages.StandardController standardController;
    
    public NewCaseControllerExt(ApexPages.StandardController stdController) {
        
        //this.standardController = stdController;
        
        //caseRecordTypeIdToNameMap = new Map<Id, String>();
        //caseRecordTypeIdToDefaultSubjectMap = new Map<Id, String>();
        
        //for (RecordType rt: [select DeveloperName from RecordType where SobjectType = 'Case']) {
        //    caseRecordTypeIdToNameMap.put(rt.Id, rt.DeveloperName);
        //    caseRecordTypeIdToDefaultSubjectMap.put(rt.Id, getDefaultSubject(rt.DeveloperName));
        //}
        
    }
    
    //private String getDefaultSubject(String recordTypeName) {
    //    Case_Record_Type_Rule__c rule = 
    //        Case_Record_Type_Rule__c.getInstance(recordTypeName);
    //    if (rule != null) {
    //        String defaultSubject = rule.Default_Subject__c;
    //        if (defaultSubject == null) {
    //            return '';
    //        } else {
    //            return defaultSubject;            
    //        }
    //    } else {
    //        return '';
    //    }
    //} 
    
    //private String getRedirectURL(Id recordTypeId) {
    //    Case_Record_Type_Rule__c rule = 
    //        Case_Record_Type_Rule__c.getInstance(caseRecordTypeIdToNameMap.get(recordTypeId));
    //    if (rule != null) {
    //        String redirectUrl = rule.Redirect_URL__c;
    //        return redirectUrl;
    //    } else {
    //        return null;
    //    }
    //}     
    
    //public PageReference save() {
    //    Case cse = (Case)standardController.getRecord();
    //    if (cse.Origin == null) {
    //        cse.Origin = 'Phone';
    //    }
        
    //    PageReference pageReference = standardController.save();
    //    if (pageReference == null) {
    //        return null;
    //    } else {
    //        cse = (Case)standardController.getRecord();
    //        String redirectUrl = getRedirectUrl(cse.RecordTypeId);
    //           if(redirectUrl!=null){
    //            pageReference = new PageReference(redirectUrl);
    //            }
    //            pageReference.getParameters().put('id', cse.Id);            
    //    }
        
    //    pageReference.setRedirect(true);
    //    pageReference.getParameters().put('retUrl', standardController.view().getUrl());
    //    return pageReference;
    //}
    
}