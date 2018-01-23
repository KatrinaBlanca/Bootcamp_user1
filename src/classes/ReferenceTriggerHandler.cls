/* 
 * Description: Handles the logic for Reference Trigger
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-28-17
 */ 
public with sharing class ReferenceTriggerHandler implements TriggerInterface 
{  
    //Checks to see if the trigger has been disabled either by custom setting or by running code
    public Boolean IsDisabled() {
        //Added trigger control from heirarchy custom setting
        TriggerControl__c caseControl = TriggerControl__c.getInstance();
        return caseControl.Reference__c;
    }

    public void BeforeInsert(List<SObject> newList) 
    {
        //Begin CSM-973: Von Pernicia Feb-28-17
        List<Reference__c> newLists = (List<Reference__c>)newList;
        getParentID(newLists);
        //End CSM-973: Von Pernicia Feb-28-17
    } 
    
    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) 
    {
        //Begin CSM-973: Von Pernicia Feb-28-17
        Map<id, Reference__c> newMaps = (Map<id, Reference__c>)newMap;
        
        getParentID(newMaps.values());
        //End CSM-973: Von Pernicia Feb-28-17
    }
    
    public void BeforeDelete(Map<Id, SObject> oldMap){}

    public void AfterInsert(Map<Id, SObject> newMap){}

    public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {}
    
    public void AfterDelete(Map<Id, SObject> oldMap){}

    public void AfterUndelete(Map<Id, SObject> oldMap){} 
    
/* 
 * Description: Transformation to Populate Parent lookup and Block base on ParentCode
 * Parameters: Case Mapping 
 * Returns: N/A
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-24-17
*/  
//Begin CSM-973: Von Pernicia Feb-28-17
    public void getParentID(List<Reference__c> newReferenceList)
    {   
        
        //if (!isUpdate)
        //{
            getParentIDBlock(newReferenceList);
        //}
        //else
        //{
        //    getParentIDBlock(newReferenceMappings.values());
        //}
    }  
    
    public void getParentIDBlock(List<Reference__c> newReferenceList)
    {
    	Map<String, Id> addressIdMapping = new Map<String, Id>();
	    Map<Id, String> addressCodeMapping = new Map<Id, String>();
	    
	    Map<Id, String> addressIdBlockMapping = new Map<Id, String>();
	    Map<String, String> addressCodeBlockMapping = new Map<String, String>();
    	
    	String fieldValue;    	
    	String typeValue;
    	List<String> nameCode = new List<String>(); // Start/End CSM-2048: Von Pernicia MAR-29-17
    	List<String> nameId = new List<String>(); // Start/End CSM-2048: Von Pernicia MAR-29-17
    	
    	for (Reference__c r: newReferenceList)
        {
        	fieldValue = r.field__c;
        	typeValue = r.Type__c;
        	// Start/End CSM-2048: Von Pernicia MAR-29-17
        	if (r.Parent_Code__c <> null)
        	{
        		nameCode.add(r.Parent_Code__c);
        	}
        	else
        	{
        		nameId.add(r.Parent__c);
        	}
        	// Start/End CSM-2048: Von Pernicia MAR-29-17
        }
    	//system.assertequals(nameId, null); system.assertequals(1, 2);
    	if (typeValue == 'Geo' && fieldValue <> 'Province')
    	{
	    	String queryString = 'Select'; 
	               queryString += ' Id,';
	               queryString += ' Name_Code__c,';
				   queryString += ' Parent__c, ';
	               queryString += ' Parent_Code__c,';
	               queryString += ' Block__c ';
	               queryString += ' from Reference__c';
	    	
	    	// Start CSM-2048: Added additional Criteria Namecode and ID Von Pernicia MAR-29-17
	    	if (fieldValue == 'Street')
	    	{ 
	    		queryString += ' where Field__c = \'Subdivision\' and (Name_Code__c in: nameCode or Id in: nameId)'; 
	    	}
	    	if (fieldValue == 'Subdivision')
	    	{ 
	    		queryString += ' where Field__c = \'Barangay\' and (Name_Code__c in: nameCode or Id in: nameId)'; 
	    	}
	    	if (fieldValue == 'Barangay')
	    	{ 
	    		queryString += ' where Field__c = \'City\' and (Name_Code__c in: nameCode or Id in: nameId)'; 
	    	}
	    	if (fieldValue == 'City')
	    	{ 
	    		queryString += ' where Field__c = \'Province\' and (Name_Code__c in: nameCode or Id in: nameId)'; 
	    	}
	    	// End CSM-2048: Added additional Criteria Namecode and ID Von Pernicia MAR-29-17

	    	for (Reference__c r: Database.query(queryString))
	        {
	            addressIdMapping.put(r.Name_Code__c, r.Id);
	            addressCodeMapping.put(r.Id, r.Name_Code__c);
	            
	            addressIdBlockMapping.put(r.Id, r.Block__c);
	            addressCodeBlockMapping.put(r.Name_Code__c, r.Block__c);
	        }
	    	
	        for (Reference__c r: newReferenceList)
	        {
	            if (r.Field__c == CXE_Constants.ADDRESS_PROVINCE)
	            {
	                r.Block__c = r.Name;
	            }
	            
	            // Populate Parent field base on Parent Code
	            if (r.Parent__c ==  null)
	            {
	                if (r.Field__c != CXE_Constants.ADDRESS_PROVINCE)
	                {
	                    r.Block__c = addressCodeBlockMapping.get(r.Parent_Code__c);
	                }
	                r.Parent__c = addressIdMapping.get(r.Parent_Code__c);
	            }
	            // Populate Parent Code field base on Parent
	            if (r.Parent_Code__c ==  null)
	            {
	                if (r.Field__c != CXE_Constants.ADDRESS_PROVINCE)
	                {
	                    r.Block__c = addressIdBlockMapping.get(r.Parent__c);
	                }
	                r.Parent_Code__c = addressCodeMapping.get(r.Parent__c);
	            }
	        }
	    }
    }
//End CSM-973: Von Pernicia Feb-28-17
}