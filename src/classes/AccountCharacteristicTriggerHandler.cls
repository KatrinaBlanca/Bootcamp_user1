/* 
 * Description: Handles the logic for Account_Characteristic__c Trigger
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-27-17
 */ 
public with sharing class AccountCharacteristicTriggerHandler {//implements TriggerInterface  {
    //Checks to see if the trigger has been disabled either by custom setting or by running code
    /*public Boolean IsDisabled() {
        //Added trigger control from heirarchy custom setting
        TriggerControl__c caseControl = TriggerControl__c.getInstance();
        return caseControl.Account_Characteristic__c;
    }

    public void BeforeInsert(List<SObject> newList) 
    {
        //Begin CSM-973: Von Pernicia Feb-24-17
        //List<Account_Characteristic__c> newLists = (List<Account_Characteristic__c>)newList;
        //picklistTransformation(null, null, newLists, false);
        //End CSM-973: Von Pernicia Feb-24-17
    } 
    
    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) 
    {
        //Begin CSM-973: Von Pernicia Feb-24-17
        //Map<id, Account_Characteristic__c> newMaps = (Map<id, Account_Characteristic__c>)newMap;
        //Map<id, Account_Characteristic__c> oldMaps = (Map<id, Account_Characteristic__c>)oldMap;
        
        //picklistTransformation(newMaps, oldMaps, null, true);
        //End CSM-973: Von Pernicia Feb-24-17
    }
    
    public void BeforeDelete(Map<Id, SObject> oldMap){}

    public void AfterInsert(Map<Id, SObject> newMap){}

    public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {}
    
    public void AfterDelete(Map<Id, SObject> oldMap){}

    public void AfterUndelete(Map<Id, SObject> oldMap){}   
    */
/* 
 * Description: Transformation Picklist Code and Description
 * Parameters: Case Mapping 
 * Returns: N/A
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-24-17
*/  
//Begin CSM-973: Von Pernicia Feb-24-17
    /*public void picklistTransformation(Map<Id, Account_Characteristic__c> newCaseMappings, Map<Id, Account_Characteristic__c> oldCaseMappings, List<Account_Characteristic__c> newCaseList, Boolean isUpdate)
    {   
        Map<String, String> mapPicklistCode = CXE_Utility.picklistTransformationCode();
        Map<String, String> mapPicklistDesc = CXE_Utility.picklistTransformationDesc();
        List<List<String>> arrayList = CXE_Constants.ACCOUNTCHAR_PICKLIST_ARRAY;
        CXE_Utility utilClass = new CXE_Utility();
        
        if (!isUpdate)
        {
            utilClass.picklistTransformationInsert(newCaseList, arrayList, mapPicklistCode, mapPicklistDesc);
        }
        else
        {   
            utilClass.picklistTransformationUpdate(newCaseMappings, oldCaseMappings, arrayList, mapPicklistCode, mapPicklistDesc);
        }
    } */ 
//End CSM-973: Von Pernicia Feb-24-17
}