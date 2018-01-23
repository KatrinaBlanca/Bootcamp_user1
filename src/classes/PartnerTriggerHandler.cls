public with sharing class PartnerTriggerHandler implements TriggerInterface
{
    //Checks to see if the trigger has been disabled either by custom setting or by running code
    public Boolean IsDisabled() {
        //Added trigger control from heirarchy custom setting
        TriggerControl__c contactRoleControl = TriggerControl__c.getInstance();
        return contactRoleControl.Partner__c;
    }

    public void BeforeInsert(List<SObject> newList){}
    
    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {}
    
    public void BeforeDelete(Map<Id, SObject> oldMap) {}
    
    public void AfterInsert(Map<Id, SObject> newMap)
    {
        Map<Id, Partner__c> newMaps = (Map<Id, Partner__c>)newMap;
        createPartnerRecord(newMaps);
    }
    
    public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap){}
    
    public void AfterDelete(Map<Id, SObject> oldMap)
    {
        Map<Id, Partner__c> oldMaps = (Map<Id, Partner__c>)oldMap;
        deletePartnerRecord(oldMaps);
    }

    public void AfterUndelete(Map<Id, SObject> oldMap){}
    
/* 
 * Description: To create CXE partner record to the selected partner Account 
 * Parameters: Partner Mapping 
 * Returns: Return type
 * Author: Von Pernicia
 * Date Created: FEB-15-17
*/  
    public void createPartnerRecord(Map<Id, Partner__c> newMaps)
    {   
        List<Id> partnerIdList = new List<Id>();
        
        for (Partner__c pr: newMaps.values())
        {   
            partnerIdList.add(pr.Id);
        }
        
        if (!System.isFuture() && !System.isBatch())
        {
            createPartnerRecord(partnerIdList);
        }
    }
    
    @future
    public static void createPartnerRecord(List<Id> newLists)
    {
        Map<String, String> partnerRoleMapping = new Map<String, String>();
        List<Partner__c> partnerRoleList = new List<Partner__c>();
        
        // Get the Partner Role and Reverse Role
        for (PartnerRole pr: [Select ReverseRole, MasterLabel From PartnerRole])
        {
            partnerRoleMapping.put(pr.MasterLabel, pr.ReverseRole);
        }
        
        // Create CXE partner record to the selected partner Account  
        for (Partner__c pr: [Select Id, Account_Name__c, Partners__c, Role__c, Name from Partner__c where Id =: newLists])
        {
            Partner__c createPartnerRole = new Partner__c(
            
                Partners__c = pr.Account_Name__c,
                Account_Name__c = pr.Partners__c,
                Role__c = partnerRoleMapping.get(pr.Role__c),
                Master__c = pr.Name
            );
            
            partnerRoleList.add(createPartnerRole);
        }
        
        insert partnerRoleList;
    }

/* 
 * Description: This will delete the partner record to the related Partner Account 
 * Parameters: Partner Mapping 
 * Returns: Return type
 * Author: Von Pernicia
 * Date Created: FEB-15-17
*/      
    public static void deletePartnerRecord(Map<Id, Partner__c> oldMaps)
    {
        List<String> masterList = new List<String>();
        List<Partner__c> deletePartnerList = new List<Partner__c>();
        
        for (Partner__c pr: oldMaps.values())
        {
            if (pr.Master__c <> null)
            {
                masterList.add(pr.Master__c);
            }
            masterList.add(pr.Name);
        }
        
        // Delete CXE partner record to the selected partner Account  
        for (Partner__c pr: [Select id, Role__c from Partner__c where Name =: masterList or Master__c =: masterList])
        {   
            deletePartnerList.add(pr);
        }
        
        delete deletePartnerList;
    }
}