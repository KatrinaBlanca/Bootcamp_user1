/* 
 * Description: Handles the logic for Connection Trigger
 * Author: Von Pernicia (Accenture)
 * Date Created: MAR-04-17
 */ 
public with sharing class ConnectionTriggerHandler implements TriggerInterface {
    //Checks to see if the trigger has been disabled either by custom setting or by running code
    public Boolean IsDisabled() {
        //Added trigger control from heirarchy custom setting
        TriggerControl__c triggerControl = TriggerControl__c.getInstance();
        return triggerControl.Connection__c;
    }

    public void BeforeInsert(List<SObject> newList) {
        //Begin CSM-973: Von Pernicia Feb-24-17
        List<Connection__c> newLists = (List<Connection__c>)newList;
        picklistTransformation(null, null, newLists, false);        
        //End CSM-973: Von Pernicia Feb-24-17
    } 
    
    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        //Begin CSM-973: Von Pernicia Feb-24-17
        Map<id, Connection__c> newMaps = (Map<id, Connection__c>)newMap;
        Map<id, Connection__c> oldMaps = (Map<id, Connection__c>)oldMap;
        
        picklistTransformation(newMaps, oldMaps, null, true);
        //End CSM-973: Von Pernicia Feb-24-17
    }
    
    public void BeforeDelete(Map<Id, SObject> oldMap){}

    public void AfterInsert(Map<Id, SObject> newMap)
    {
        Map<id, Connection__c> newMaps = (Map<id, Connection__c>)newMap;
        
        updateActualEnergizationDate(newMaps.values());
    }

    public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) 
    {
        Map<id, Connection__c> newMaps = (Map<id, Connection__c>)newMap;
        Map<id, Connection__c> oldMaps = (Map<id, Connection__c>)oldMap;

        updateActualEnergizationDate(newMaps.values());
    }
    
    public void AfterDelete(Map<Id, SObject> oldMap){}

    public void AfterUndelete(Map<Id, SObject> oldMap){}
    
    /* 
 * Description: Transformation Picklist Code and Description
 * Parameters: Connection Mapping 
 * Returns: N/A
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-24-17
*/  
//Begin CSM-973: Von Pernicia Feb-24-17
    public void picklistTransformation(Map<Id, Connection__c> newConnectiontMappings, Map<Id, Connection__c> oldConnectionMappings, List<Connection__c> newConnectionList, Boolean isUpdate)
    {   
        List<List<String>> arrayList = CXE_Constants.CONNECTION_PICKLIST_ARRAY;
        Map<String, String> mapPicklistCode = CXE_Utility.picklistTransformationCode(arrayList);
        Map<String, String> mapPicklistDesc = CXE_Utility.picklistTransformationDesc(arrayList);
        
        CXE_Utility utilClass = new CXE_Utility();
        
        if (!isUpdate)
        {
            utilClass.picklistTransformationInsert(newConnectionList, arrayList, mapPicklistCode, mapPicklistDesc);
        }
        else
        {   
            utilClass.picklistTransformationUpdate(newConnectiontMappings, oldConnectionMappings, arrayList, mapPicklistCode, mapPicklistDesc);
        }
    }  
//End CSM-973: Von Pernicia Feb-24-17
    
     /* 
     * Description: Update Actual Energization Date
     * Parameters: Connection Mapping 
     * Returns: N/A
     * Author: Von Pernicia (Accenture)
     * Date Created: AUG-09-17
    */  
    //Start CSM-12239: Von Pernicia Feb-24-17
    public void updateActualEnergizationDate(List<Connection__c> connectionList)
    { 
        Id modifyRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_MODIFICATION_OF_ELECTRIC_APPLICATION).getRecordTypeId();
        Map<Id, Connection__c> servconMap = new Map<Id, Connection__c>();
        Map<Id, Connection__c> caseMap = new Map<Id, Connection__c>();
        List<Case> caseRecords = new List<Case>();
        List<Id> caseIds = new List<Id>();

        for (Connection__c con: connectionList)
        {
            servconMap.put(con.Service__c, con);
        }
      
        if (!servconMap.keySet().isEmpty())
        {
            for (Agreement__c a: [SELECT    Case__c,
                                            Id
                                  FROM      Agreement__c
                                  WHERE     Id IN: servconMap.keySet()])
            {
                caseMap.put(a.Case__c, servconMap.get(a.Id));
                //caseIds.add(a.Case__c);
            }

            for (Case c: [SELECT    Actual_Energization_Date__c,
                                    Id,
                                    CXE_Service__c,
                                    RecordTypeId
                          FROM      Case
                          WHERE     (CXE_Service__c IN: servconMap.keySet() OR Id IN: caseMap.keySet())
                          AND       (Status =: CXE_Constants.CASE_APPLICATION_PENDING_ENERGIZED OR Status =: CXE_Constants.CASE_APPLICATION_ENERGIZED)
                          AND       RecordTypeId =: modifyRecTypeId
                          AND       CXE_Service__c <> NULL])
            {
                // For Service Request = Remodel or Relocation
                if (servconMap.containsKey(c.CXE_Service__c))
                {
                    c.Actual_Energization_Date__c = servconMap.get(c.CXE_Service__c).Installation_Date__c;
                    caseRecords.add(c);
                }

                // For Service Request = Transfer or Change in Rate
                if (caseMap.containsKey(c.Id))
                {
                    c.Actual_Energization_Date__c = caseMap.get(c.Id).Installation_Date__c;
                    caseRecords.add(c);
                }
            }

            if (!caseRecords.isEmpty())
            {
                update caseRecords;
            }
        }
    }
    //End CSM-12239: Von Pernicia Feb-24-17
}