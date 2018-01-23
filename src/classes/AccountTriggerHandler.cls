/* 
 * Description: Handles the logic for Lead Trigger
 * Author: Jerson Poblete (Accenture)
 * Date Created: MAR-0-17
 */ 
public with sharing class AccountTriggerHandler implements TriggerInterface { 

    //CSM-12509 START JEROME TO   SEP-11-2017
    static final Map<String, String> picklistCodeMapping;
    static final Map<String, String> picklistDescMapping;
    static{        
        picklistDescMapping = new Map<String, String>();
        picklistCodeMapping = new Map<String, String>();
        List<List<String>> arrayList = CXE_Constants.CASE_PICKLIST_ARRAY;
        List<String> sTypeList = new List<String>();
        
        for (Integer x = 0; x < arrayList.size(); x++)
        {
          sTypeList.add(arrayList[x][2]);
        }
        
        for(Reference__c ref : [SELECT Name, Name_Code__c, Field__c FROM Reference__c WHERE Field__c IN: sTypeList and Type__c = 'Picklist' ORDER BY Field__c]){
            picklistDescMapping.put(ref.Name_Code__c + ref.Field__c, ref.Name);
            picklistCodeMapping.put(ref.Name + ref.Field__c, ref.Name_Code__c);
        }

        system.debug(picklistDescMapping.size());
        system.debug(picklistCodeMapping.size());
    }
    static Boolean isAdministrator = CXE_Utility.isAdmin();
    //CSM-12509 END JEROME TO   SEP-11-2017

    //START JEROME TO   MAY-29-17
    static final Map<String, Id> accountRecordTypes;
    static{
        accountRecordTypes = new Map<String, Id>();
        for(RecordType recType : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND IsActive = true]){
            accountRecordTypes.put(recType.DeveloperName, recType.Id);
        }
    }
    //END JEROME TO   MAY-29-17

    //Checks to see if the trigger has been disabled either by custom setting or by running code
    public Boolean IsDisabled() {
        //Added trigger control from heirarchy custom setting
        TriggerControl__c triggerControl = TriggerControl__c.getInstance();
        return triggerControl.Account__c;
    }

    public void BeforeInsert(List<SObject> newList) {
        //Begin CSM-973: Von Pernicia Feb-24-17
        List<Account> newLists = (List<Account>)newList;
        PopulateField(newLists);
        picklistTransformation(null, null, newLists, false);        
        //End CSM-973: Von Pernicia Feb-24-17
        
        // START R2C CSM-13259 Shayne 10/26/2017
        checkLevelHierarchyConglomerate(newLists);
        // START R2C CSM-13259 Shayne 10/26/2017
    } 
    
    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        //Begin CSM-973: Von Pernicia Feb-24-17
        Map<id, Account> newMaps = (Map<id, Account>)newMap;
        Map<id, Account> oldMaps = (Map<id, Account>)oldMap;
        
        picklistTransformation(newMaps, oldMaps, null, true);
        //End CSM-973: Von Pernicia Feb-24-17
        validateAccountUpdate(newMaps.values(), oldMaps); // JEROME TO   MAY-30-17
        
        // START R2C CSM-13259 Shayne 10/26/2017
        List<SObject> newList = newMap.values();
        List<Account> AccountList = (List<Account>) newList;
        checkLevelHierarchyConglomerate(AccountList);
        // START R2C CSM-13259 Shayne 10/26/2017
        
    }
    
    public void BeforeDelete(Map<Id, SObject> oldMap){}

    public void AfterInsert(Map<Id, SObject> newMap){}

    public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {}
    
    public void AfterDelete(Map<Id, SObject> oldMap){}

    public void AfterUndelete(Map<Id, SObject> oldMap){}   
    
/* 
 * Description: Transformation Picklist Code and Description
 * Parameters: Case Mapping 
 * Returns: N/A
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-24-17
*/  
//Begin CSM-973: Von Pernicia Feb-24-17
    public void picklistTransformation(Map<Id, Account> newAccountMappings, Map<Id, Account> oldAccountMappings, List<Account> newAccounttList, Boolean isUpdate)
    {   
        List<List<String>> arrayList = CXE_Constants.ACCOUNT_PICKLIST_ARRAY;
        //CSM-12509 START JEROME TO   SEP-11-2017
        //Map<String, String> mapPicklistCode = CXE_Utility.picklistTransformationCode(arrayList);
        //Map<String, String> mapPicklistDesc = CXE_Utility.picklistTransformationDesc(arrayList);

        Map<String, String> mapPicklistCode = picklistCodeMapping;
        Map<String, String> mapPicklistDesc = picklistDescMapping;
        //CSM-12509 END JEROME TO   SEP-11-2017
        
        CXE_Utility utilClass = new CXE_Utility();
        
        if (!isUpdate)
        {
            utilClass.picklistTransformationInsert(newAccounttList, arrayList, mapPicklistCode, mapPicklistDesc);
        }
        else
        {   
            utilClass.picklistTransformationUpdate(newAccountMappings, oldAccountMappings, arrayList, mapPicklistCode, mapPicklistDesc);
        }
    }  
//End CSM-973: Von Pernicia Feb-24-17

    /* 
     * Description: Prevent modififcation of account if account is associated to an active service for non system administrator. 
     * Suggested warning: Please wait for application <CaseNumber> to be closed before creating a new application.
     * Parameters: List<Account> 
     * Returns: N/A
     * Author: Jerome To
     * Date Created: MAY-30-17
    */  
    private void validateAccountUpdate(List<Account> accountList, Map<Id, Account> oldMap) {   
        //CSM-12509 START JEROME TO   SEP-11-2017
        Boolean isAdmin = isAdministrator;
        //CSM-12509 END JEROME TO   SEP-11-2017

        Set<Id> acctIds = new Set<Id>();
        Map<Id, Set<String>> casesPerAccountIdMap = new Map<Id, Set<String>>();
        Map<String, Boolean> caseIsClosedMap = new Map<String, Boolean>();
        Id modififcationRecordTypeId = [SELECT Id, DeveloperName 
                                        FROM RecordType 
                                        WHERE SObjectType = 'Case' 
                                        AND DeveloperName =:CXE_Constants.CASE_RECORD_TYPE_MODIFICATION_OF_ELECTRIC_SERVICE 
                                        AND IsActive = true].Id;
        for(Account acct : accountList) {
            hasChangeInName(acct, oldMap.get(acct.Id));
            if(!isAdmin && !String.isBlank(acct.V10_Customer_No__c) && 
                hasChangeInName(acct, oldMap.get(acct.Id)) && (oldMap.get(acct.Id).Energy_Sales__c == acct.Energy_Sales__c) && 
                (oldMap.get(acct.Id).Distribution_Charge__c == acct.Distribution_Charge__c) && 
                (oldMap.get(acct.Id).Bill_Amount__c == acct.Bill_Amount__c)) {
                acctIds.add(acct.Id);
            }
        }

        if (!acctIds.isEmpty()) {
            for(Case caseRecord : [SELECT CaseNumber, AccountId, IsClosed
                                    FROM Case 
                                    WHERE AccountId IN: acctIds 
                                    AND RecordTypeId =:modififcationRecordTypeId
                                    AND CXE_Service__c IN (SELECT Id FROM Agreement__c WHERE Account__c IN: acctIds)                                       
                                    ORDER BY CreatedDate DESC]) {
                if(casesPerAccountIdMap.containsKey(caseRecord.AccountId)) {
                    Set<String> caseNumbers = casesPerAccountIdMap.get(caseRecord.AccountId);
                    caseNumbers.add(caseRecord.CaseNumber);
                    casesPerAccountIdMap.put(caseRecord.AccountId, caseNumbers);
                } else {
                    casesPerAccountIdMap.put(caseRecord.AccountId, new Set<String>{caseRecord.CaseNumber});
                }
                caseIsClosedMap.put(caseRecord.CaseNumber, caseRecord.IsClosed);
            }

            for(Account acct : accountList) {
                if(!casesPerAccountIdMap.containsKey(acct.Id)) {
                    acct.addError(CXE_Constants.ACCOUNT_ERROR_NO_CASE_MODIFICATION_EXIST);
                } else if (casesPerAccountIdMap.containsKey(acct.Id)) {
                    for (String caseNumber : casesPerAccountIdMap.get(acct.Id)) {
                        if (!caseIsClosedMap.get(caseNumber)) {
                            acct.addError(String.format(CXE_Constants.ACCOUNT_ERROR_PENDING_CASE_MODIFICATION_EXIST, new List<String> {caseNumber} ));
                            break;
                        }
                    }
                }
            }
        }
    }

    /* 
     * Description: Check if has Change in Name
     * Parameters: List<Account> 
     * Returns: N/A
     * Author: Jerome To
     * Date Created: MAY-31-17
    */  
    private Boolean hasChangeInName(Account newAccount, Account oldAccount) { 
        if(newAccount.RecordTypeId == accountRecordTypes.get(CXE_Constants.ACCOUNT_RECORD_TYPE_CXE_INDIVIDUAL_ACCOUNT))  {
            return ((oldAccount.FirstName != newAccount.FirstName) || 
                    (oldAccount.MiddleName != newAccount.MiddleName) || 
                    (oldAccount.LastName != newAccount.LastName) || 
                    (oldAccount.Salutation != newAccount.Salutation) || 
                    (oldAccount.Suffix != newAccount.Suffix) );
        } else if (newAccount.RecordTypeId == accountRecordTypes.get(CXE_Constants.ACCOUNT_RECORD_TYPE_CXE_BUSINESS_ACCOUNT))  {
            return (oldAccount.Name != newAccount.Name) || (oldAccount.Doing_Business_As__c != newAccount.Doing_Business_As__c);
        }
        return false;
    }  
    /* 
     * Description: Populate Custom Field from value coming from Standard field
     * Parameters: Account New records
     * Returns: N/A
     * Author: Rhyan Cruz (Accenture)
     * Date Created: Aug-24-17
    */
     private void PopulateField(List<Account> accountList) {
        for(Account acct : accountList) {
            if ((acct.PersonMobilePhone != null) && (acct.Mobile_1__pc== null)){
                acct.Mobile_1__pc = acct.PersonMobilePhone;
            }            
        }  
    }  
    
    
    // START R2C CSM-13259 Shayne 10/26/2017  
    public void checkLevelHierarchyConglomerate(List<Account> newLists){
        List<String> parentIdList = new List<String>();
        Map<String, Integer> parentLevelMap = new Map<String, Integer>();
        for (Account a : newLists) {
            if(a.Conglomerate__c && a.ParentId != null){  //R2C CSM-14281 Shayne 11/07/2017  
                parentIdList.add(a.ParentId);
            }            
        }
        if(!parentIdList.isEmpty()){
            parentLevelMap = currentLevel(parentIdList);
             for (Account a : newLists) {
                if(parentLevelMap.get(a.ParentId) >= 4) {
                	a.addError(Label.CONGLOMERATE_SALESFORCE_ERROR);
                }
             }
        }
    }
    
    private Map<String, Integer> currentLevel( List<String> currentParent){
        Map<String, Integer> parentLevelMap = new Map<String, Integer>();
        Map<String, String> congloAccountMap = new Map<String, String>();
        String content = '';
        List<Account> congloAccountList = [Select Id, ParentId from Account where Conglomerate__c = true];
        for(Account a : congloAccountList){
            congloAccountMap.put(a.Id, a.ParentId);
        }
        for (String parentIDKey: currentParent) {
        	integer level = 1;
       		String currParent = parentIDKey;
            String parent_id = '';
            boolean hasParent = true;
            while(hasParent){
                parentLevelMap.put(parentIDKey,level);
                parent_id = congloAccountMap.get(currParent);
                if(parent_id == null) hasParent = false;
                currParent = parent_id;
                level++;
            }
        }
       /* while(level<5){
            List<String> newParent = new List<String>();
            for (String currParent: currentParent) {
                parent_id = congloAccountMap.get(currParent);
                if(parent_id == null) parentLevelMap.put(currParent,level);
                else newParent.add(parent_id);
            }
            currentParent = newParent;            
            level++;
        }*/
        return parentLevelMap;
    }
    // END R2C CSM-13259 Shayne 10/26/2017
    
}