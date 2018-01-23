/* 
 * Description: Handles the logic for Field Order Trigger
 * Author: Von Pernicia (Accenture)
 * Date Created: MAR-18-17
 */ 
public without sharing class FieldOrderTriggerHandler implements TriggerInterface {//START/END CSM-6869 RReyes JUN-08-17 - updated to without sharing
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
    //CSM-12509 END JEROME TO   SEP-11-2017


    //START CSM-6869 RReyes JUN-08-17
    public Id modifyRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_MODIFICATION_OF_ELECTRIC_APPLICATION).getRecordTypeId();
    public Id terminateRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_TERMINATION_OF_ELECTRIC_SERVICE).getRecordTypeId();
    public Id recontractRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_RECONTRACT_OF_ELECTRIC_SERVICE).getRecordTypeId();
    
    public Id surveyFORecTypeId = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_SURVEY_FO).getRecordTypeId();
    public Id inspectionFORecTypeId = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_INSPECTION_FO).getRecordTypeId();
    public Id reinspectionFORecTypeId = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_RE_INSPECTION_FO).getRecordTypeId();
    public Id metersocketFORecTypeId = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_MeterSocket_FO).getRecordTypeId();
    //END CSM-6869 RReyes JUN-08-17
    
    //Checks to see if the trigger has been disabled either by custom setting or by running code
    public Boolean IsDisabled() {
        //Added trigger control from heirarchy custom setting
        TriggerControl__c triggerControl = TriggerControl__c.getInstance();
        return triggerControl.Field_Order__c;
    }

    public void BeforeInsert(List<SObject> newList) {
        
        List<Field_Order__c> newLists = (List<Field_Order__c>)newList;
        
        //START CSM-6869 RReyes JUN-08-17
        autopopulateFieldOrder(newLists);
        //END CSM-6869 RReyes JUN-08-17

        //START CSM-7240 Von Pernicia JUL-04-17
        picklistTransformation(null, null, newLists, false);
        //END CSM-7240 Von Pernicia JUL-04-17
    } 
    
    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        
        Map<id, Field_Order__c> newMaps = (Map<id, Field_Order__c>)newMap;
        Map<id, Field_Order__c> oldMaps = (Map<id, Field_Order__c>)oldMap;
        
        picklistTransformation(newMaps, oldMaps, null, true);
    }
    
    public void BeforeDelete(Map<Id, SObject> oldMap){}

    public void AfterInsert(Map<Id, SObject> newMap){}

    public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        Map<id, Field_Order__c> newMaps = (Map<id, Field_Order__c>)newMap;
        Map<id, Field_Order__c> oldMaps = (Map<id, Field_Order__c>)oldMap;
        updateSAwithResolutionRemark( newMaps.values(), oldMaps);
    }
    
    public void AfterDelete(Map<Id, SObject> oldMap){}

    public void AfterUndelete(Map<Id, SObject> oldMap){}   
    
/* 
 * Description: Transformation Picklist Code and Description
 * Parameters: Case Mapping 
 * Returns: N/A
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-24-17
*/  
    public void picklistTransformation(Map<Id, Field_Order__c> newFieldOrderMappings, Map<Id, Field_Order__c> oldFieldOrderMappings, List<Field_Order__c> newFieldOrderList, Boolean isUpdate)
    {   
        List<List<String>> arrayList = CXE_Constants.FIELDORDER_PICKLIST_ARRAY;

        //CSM-12509 START JEROME TO   SEP-11-2017
        //Map<String, String> mapPicklistCode = CXE_Utility.picklistTransformationCode(arrayList);
        //Map<String, String> mapPicklistDesc = CXE_Utility.picklistTransformationDesc(arrayList);

        Map<String, String> mapPicklistCode = picklistCodeMapping;
        Map<String, String> mapPicklistDesc = picklistDescMapping;
        //CSM-12509 END JEROME TO   SEP-11-2017
        
        CXE_Utility utilClass = new CXE_Utility();
        
        if (!isUpdate)
        {
            utilClass.picklistTransformationInsert(newFieldOrderList, arrayList, mapPicklistCode, mapPicklistDesc);
        }
        else
        {   
            utilClass.picklistTransformationUpdate(newFieldOrderMappings, oldFieldOrderMappings, arrayList, mapPicklistCode, mapPicklistDesc);
        }
    }

//START CSM-6869 RReyes JUN-08-17   
/* 
 * Description: Autopopulate field order fields based on Case
 * Parameters: List<Field_Order__c>
 * Returns: N/A
 * Author: Rom Edison Reyes (Accenture)
 * Date Created: JUN-08-17
*/  
    public void autopopulateFieldOrder(List<Field_Order__c> newFieldOrderList)
    {
        Set<String> caseIds = new Set<String>();
        Map<Id, Case> caseMap = new Map<Id, Case>();
        Case c = new Case();

        for(Field_Order__c fo : newFieldOrderList){
            if(fo.Case__c != null){
                caseIds.add(fo.Case__c);
            }
        }

        if(!caseIds.isEmpty()){
            caseMap = new Map<Id, Case>([SELECT Id,
                                            RecordTypeId,
                                            CXE_Termination_Date_of_SIN__c,
                                            Authorized_Representative_Last_Name__c,
                                            Authorized_Representative_First_Name__c,
                                            Authorized_Representative_Middle_Name__c,
                                            Relationship__c,
                                            Authorized_Rep_Primary_Contact_Number__c,
                                            Authorized_Representative_Email__c,
                                            Phase__c,
                                            Voltage__c,
                                            Service_Supply_Type__c,
                                            Metering_Scheme__c,
                                            Mode_of_Retrieval__c,
                                            CXE_Service_Wire_Phase__c,
                                            CXE_Service_Wire_Voltage__c,
                                            Service_Wire_Type__c,
                                            TLN__c,
                                            Pole_Code__c,
                                            Service_Wire_Length__c,
                                            Wire_Size__c,
                                            Material__c
                                        FROM Case 
                                        WHERE Id IN: caseIds]);
        }

        if(!caseMap.isEmpty()){
            for(Field_Order__c fo : newFieldOrderList){
                if(fo.Case__c != null){
                    if(caseMap.containsKey(fo.Case__c)){
                        c = caseMap.get(fo.Case__c);
                        
                        //Applicable to All FO Types and Modification, Recontract or Termination Case AND Survey FO
                        if(c.RecordTypeId == modifyRecTypeId || c.RecordTypeId == recontractRecTypeId
                            || (c.RecordTypeId == terminateRecTypeId && fo.RecordTypeId == surveyFORecTypeId)){
                            
                            fo.CXE_Rep_Last_Name__c = c.Authorized_Representative_Last_Name__c;
                            fo.CXE_Rep_First_Name__c = c.Authorized_Representative_First_Name__c;
                            fo.CXE_Rep_Middle_Name__c = c.Authorized_Representative_Middle_Name__c;
                            fo.CXE_Relationship_to_the_Customer__c = c.Relationship__c;
                            fo.CXE_Rep_Primary_Contact_Number__c = c.Authorized_Rep_Primary_Contact_Number__c;
                            fo.CXE_Rep_Email__c = c.Authorized_Representative_Email__c;
                        }
                        
                        //Applicable to Recontract Case and All FO types only
                        if(c.RecordTypeId == recontractRecTypeId){
                            fo.CXE_SIN_Termination_Date__c = c.CXE_Termination_Date_of_SIN__c;
                        }
                        
                        //Applicable to Inspection/Reinspection FO, AND Modification/Recontract Case only
                        if((c.RecordTypeId == modifyRecTypeId || c.RecordTypeId == recontractRecTypeId) 
                            && (fo.RecordTypeId == inspectionFORecTypeId || fo.RecordTypeId == reinspectionFORecTypeId))
                            {
                                fo.CXE_Service_Supply_Phase__c = c.Phase__c;
                                fo.CXE_Service_Supply_Voltage__c = c.Voltage__c;
                                fo.CXE_Service_Supply_Type__c = c.Service_Supply_Type__c;
                                fo.Metering_Scheme__c = c.Metering_Scheme__c;
                                fo.Mode_of_Retrieval__c = c.Mode_of_Retrieval__c;
                                fo.CXE_Service_Wire_Phase__c = c.CXE_Service_Wire_Phase__c;
                                fo.CXE_Service_Wire_Voltage__c = c.CXE_Service_Wire_Voltage__c;
                                fo.Service_Wire_Type__c = c.Service_Wire_Type__c;
                                fo.TLN__c = c.TLN__c;
                                fo.Pole_Code__c = c.Pole_Code__c;
                                fo.Service_Wire_Length__c = c.Service_Wire_Length__c;
                                fo.Service_Wire_Size__c = c.Wire_Size__c;
                                fo.Material__c = c.Material__c;
                            }
                    }
                }
            }
        }
        
    }
//END CSM-6869 RReyes JUN-08-17


//START CSM-7154 GGrandea JUN-27-17   
/* 
 * Description: Update SA with Re/Inspection Resolution Remark 
 * Parameters: List<Field_Order__c> newFieldOrderList, Map<Id, Field_Order__c> oldMap
 * Returns: N/A
 * Author: GGrandea (Accenture)
 * Date Created: JUN-27-17
*/  
    public void updateSAwithResolutionRemark(List<Field_Order__c> newFieldOrderList, Map<Id, Field_Order__c> oldMap){
        Set<String> caseIds = new Set<String>();
        Map<Id, Case> caseMap = new Map<Id, Case>();
        List<Case> caseToUpdate = new List<Case>();

        for(Field_Order__c fo : newFieldOrderList){
            if( fo.Case__c != null && fo.Resolution_Remarks__c!=null 
                && String.isBlank(oldMap.get(fo.Id).Resolution_Remarks__c)
                && ( fo.RecordTypeId == inspectionFORecTypeId || fo.RecordTypeId == reinspectionFORecTypeId ) ){
                    
                    caseIds.add(fo.Case__c);
            }
        }

        if(caseIds.size()>0){
            for(Case c : [SELECT Id, Re_Inspection_FO_Resolution_Remarks__c FROM Case WHERE Id IN :caseIds]){
                caseMap.put(c.Id, c);
            }
            
            if(!caseMap.isEmpty()){
                for(Field_Order__c fo : newFieldOrderList){
                    if(caseMap.containsKey(fo.Case__c)){
                        caseMap.get(fo.Case__c).Re_Inspection_FO_Resolution_Remarks__c = fo.Resolution_Remarks__c;
                        caseToUpdate.add(caseMap.get(fo.Case__c));
                    }
                }

                if(caseToUpdate.size()>0){
                    try {
                        update caseToUpdate;
                    } catch (Exception error){ 
                        ErrorHandlerException.recordException(null, true, 'FieldOrderTriggerHandler', 'updateSAwithResolutionRemark', error.getMessage());
                    }
                }
            }
        }

    }
//END CSM-7154 GGrandea JUN-27-17  

}