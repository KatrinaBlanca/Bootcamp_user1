/* 
 * Description: Handles the logic for Contract Trigger
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-27-17
 */ 
public with sharing class ContractTriggerHandler implements TriggerInterface  {

    //CSM-12509 START JEROME TO   SEP-11-2017
    static final Map<String, String> picklistCodeMapping;
    static final Map<String, String> picklistDescMapping;
    static{        
        picklistDescMapping = new Map<String, String>();
        picklistCodeMapping = new Map<String, String>();
        List<List<String>> arrayList = CXE_Constants.CONTRACT_PICKLIST_ARRAY; // CSM-13776 Lisen - Fix Issue during Contract Status Update
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

    //Checks to see if the trigger has been disabled either by custom setting or by running code
    public Boolean IsDisabled() {
        //Added trigger control from heirarchy custom setting
        TriggerControl__c caseControl = TriggerControl__c.getInstance();
        return caseControl.Contract__c;
    }

    public void BeforeInsert(List<SObject> newList) 
    {
        //Begin CSM-973: Von Pernicia Feb-24-17
        List<Contract> newLists = (List<Contract>)newList;
        picklistTransformation(null, null, newLists, false);
        //End CSM-973: Von Pernicia Feb-24-17
    } 
    
    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) 
    {
        //Begin CSM-973: Von Pernicia Feb-24-17
        Map<id, Contract> newMaps = (Map<id, Contract>)newMap;
        Map<id, Contract> oldMaps = (Map<id, Contract>)oldMap;
        
        picklistTransformation(newMaps, oldMaps, null, true);
        //End CSM-973: Von Pernicia Feb-24-17

        //START CSM-14606 RReyes NOV-27-17
        updateAPAFields(newMaps, oldMaps);
        //END CSM-14606 RReyes NOV-27-17
    }
    
    public void BeforeDelete(Map<Id, SObject> oldMap){}

    public void AfterInsert(Map<Id, SObject> newMap){
        Map<id, Contract> newMaps = (Map<id, Contract>)newMap;
        //createBillingAddress(newMaps);
        //START CSM-12279 RReyes AUG-18-17
        Set<Id> caseIds = new Set<Id>();   
        for(Contract contRec: newMaps.values()){
            if(contRec.Case__c != null){
                caseIds.add(contRec.Case__c);
            }
        }

        if(!caseIds.isEmpty()){
            updateCaseToAppApprovedMSA(caseIds);
        }
        //END CSM-12279 RReyes AUG-18-17
    }

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
    public void picklistTransformation(Map<Id, Contract> newContractMappings, Map<Id, Contract> oldContractMappings, List<Contract> newContractList, Boolean isUpdate)
    {   
        List<List<String>> arrayList = CXE_Constants.CONTRACT_PICKLIST_ARRAY;
        
        //CSM-12509 START JEROME TO   SEP-11-2017
        //Map<String, String> mapPicklistCode = CXE_Utility.picklistTransformationCode(arrayList);
        //Map<String, String> mapPicklistDesc = CXE_Utility.picklistTransformationDesc(arrayList);

        Map<String, String> mapPicklistCode = picklistCodeMapping;
        Map<String, String> mapPicklistDesc = picklistDescMapping;
        //CSM-12509 END JEROME TO   SEP-11-2017
        
        Map<Id, String> mapUserCode = new Map<Id, String>();
        Map<String, Id> mapUserId = new Map<String, Id>();
        
        CXE_Utility utilClass = new CXE_Utility();
        
        for (User u: [Select id, EmployeeNumber from User where isActive=true])
        {
            mapUserCode.put(u.Id, u.EmployeeNumber);
            mapUserId.put(u.EmployeeNumber, u.Id);
        }
        
        if (!isUpdate)
        {
            utilClass.picklistTransformationInsert(newContractList, arrayList, mapPicklistCode, mapPicklistDesc);
            
            for (Contract c: newContractList)
            { 
                // Start: Populate Account Rep Code or Account Rep lookup
                if (c.Account_Rep__c != null)
                {
                    c.Code_Account_Rep__c = mapUserCode.get(c.Account_Rep__c);
                }
                
                if (c.Code_Account_Rep__c != null)
                {
                    c.Account_Rep__c = mapUserId.get(c.Code_Account_Rep__c);
                }
                // End: Populate Account Rep Code or Account Rep lookup
            }
        }
        else
        {   
            utilClass.picklistTransformationUpdate(newContractMappings, oldContractMappings, arrayList, mapPicklistCode, mapPicklistDesc);
            
            for (Contract c: newContractMappings.values())
            {
                // Start: Populate Account Rep Code or Account Rep lookup
                if (c.Code_Account_Rep__c != oldContractMappings.get(c.id).Code_Account_Rep__c)
                {
                    c.Account_Rep__c = mapUserId.get(c.Code_Account_Rep__c);
                }
                
                if (c.Account_Rep__c != oldContractMappings.get(c.id).Account_Rep__c)
                {
                    c.Code_Account_Rep__c = mapUserCode.get(c.Account_Rep__c);
                }
                // End: Populate Account Rep Code or Account Rep lookup
            }
        }
    }  
//End CSM-973: Von Pernicia Feb-24-17

//START CSM-12279 RReyes AUG-18-17
/* 
 * Description: Update MSA case to app approved if conditions are met
 * Parameters: Case Ids of new contracts
 * Returns: N/A
 * Author: Rom Edison Reyes (Accenture)
 * Date Created: AUG-18-17
*/  
@future
public static void updateCaseToAppApprovedMSA(Set<Id> caseIds){
    if(!caseIds.isEmpty()){
        List<Case> lstCases = [SELECT Id, 
                                        RecordTypeId,
                                        Status,
                                        CXE_isRequireArrears__c,
                                        Arrears_Tag__c,
                                        CXE_isClickBillDepositButton__c,
                                        CXE_Pending_Requirement_count__c,
                                        CXE_Service_Request_s__c,
                                        Last_Name_Business_Name__c,
                                        First_Name__c,
                                        Middle_Name__c,
                                        Last_Name__c,
                                        CXE_Change_in_Name_Approved__c,
                                        CXE_Service_Wire_Phase__c,
                                        CXE_Service_Wire_Voltage__c,
                                        Pole_Code__c,
                                        Service_Wire_Type__c,
                                        Wire_Size__c,
                                        Material__c,
                                        Metering_Scheme__c,
                                        TLN__c,
                                        Service_Wire_Length__c,
                                        Service_Rate_Type__c,
                                        Billing_Class__c,
                                        Phase__c,
                                        Voltage__c,
                                        Mode_of_Retrieval__c,
                                        Applied_Load__c,
                                        Demand_Factor__c,
                                        Load_Factor__c,
                                        Contracted_Capacity__c,
                                        PSIC__c //START/END CSM-12370 RReyes SEP-05-17 - removed CXE_Change_in_Service_Rate__c in query
                            FROM Case 
                            WHERE Id IN: caseIds];
        if(lstCases != null){
            Id modifyRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_MODIFICATION_OF_ELECTRIC_APPLICATION).getRecordTypeId();
            List<Case> lstCasesToUpdate = new List<Case>();
            String serviceRequests = '';
            Boolean isValidToFlip;

            //START iteration to check valid cases for flipping
            for(Case caseRec : lstCases){
                if(caseRec.RecordTypeId == modifyRecTypeId 
                  && caseRec.CXE_isRequireArrears__c && !caseRec.Arrears_Tag__c && !caseRec.CXE_isClickBillDepositButton__c
                  && (caseRec.Status == CXE_Constants.CASE_STATUS_SERVICE_ENTR_STILL_OK 
                    || caseRec.Status == CXE_Constants.INSPECTION_FO_RESOLVED_APPROVED
                    || caseRec.Status == CXE_Constants.CASE_AMC_SERVICE_COMPLETED)
                  && caseRec.CXE_Pending_Requirement_count__c == 0)
                {
                    isValidToFlip = true;
                    serviceRequests = caseRec.CXE_Service_Request_s__c != null ? String.valueOf(caseRec.CXE_Service_Request_s__c) : '';

                    //Transfer of Service
                    //START CSM-12370 RReyes SEP-05-17 - rollback criteria in requiring contract if Change in Rate
                    if(!serviceRequests.contains(CXE_Constants.SERVICE_REQ_TRANSFER)){
                        isValidToFlip = false;
                    }
                    //END CSM-12370 RReyes SEP-05-17 - rollback criteria in requiring contract if Change in Rate

                    //Change in Contract Name
                    if(serviceRequests.contains(CXE_Constants.SERVICE_REQ_CHANGE_IN_NAME) && isValidToFlip
                      && !((String.isNotBlank(caseRec.Last_Name_Business_Name__c)
                        ||(String.isNotBlank(caseRec.First_Name__c)
                          && String.isNotBlank(caseRec.Last_Name__c)))
                      && caseRec.CXE_Change_in_Name_Approved__c)){
                      isValidToFlip = false;
                    }

                    //Relocation
                    if(serviceRequests.contains(CXE_Constants.SERVICE_REQ_RELOCATION) && isValidToFlip
                      && !(String.isNotBlank(caseRec.CXE_Service_Wire_Phase__c) && String.isNotBlank(caseRec.CXE_Service_Wire_Voltage__c)
                        && String.isNotBlank(caseRec.Pole_Code__c) && String.isNotBlank(caseRec.Service_Wire_Type__c)
                        && String.isNotBlank(caseRec.Wire_Size__c) && String.isNotBlank(caseRec.Material__c)
                        && String.isNotBlank(caseRec.Metering_Scheme__c)
                        && (String.isNotBlank(caseRec.TLN__c) && caseRec.TLN__c != '0')
                        && (caseRec.Service_Wire_Length__c != null && caseRec.Service_Wire_Length__c != 0)
                      )){
                        isValidToFlip = false;
                    }

                    //Remodel
                    if(serviceRequests.contains(CXE_Constants.SERVICE_REQ_REMODEL) && isValidToFlip
                      && !(String.isNotBlank(caseRec.Service_Rate_Type__c) && String.isNotBlank(caseRec.Billing_Class__c)
                        && String.isNotBlank(caseRec.Phase__c) && String.isNotBlank(caseRec.Voltage__c)
                        && String.isNotBlank(caseRec.CXE_Service_Wire_Phase__c) && String.isNotBlank(caseRec.CXE_Service_Wire_Voltage__c)
                        && String.isNotBlank(caseRec.Pole_Code__c) && String.isNotBlank(caseRec.Service_Wire_Type__c)
                        && String.isNotBlank(caseRec.Wire_Size__c) && String.isNotBlank(caseRec.Material__c)
                        && String.isNotBlank(caseRec.Metering_Scheme__c) && String.isNotBlank(caseRec.Mode_of_Retrieval__c)
                        && (String.isNotBlank(caseRec.TLN__c) && caseRec.TLN__c != '0')
                        && (caseRec.Service_Wire_Length__c != null && caseRec.Service_Wire_Length__c != 0)
                        && (caseRec.Applied_Load__c != null && caseRec.Applied_Load__c != 0)
                      )){
                        isValidToFlip = false;
                    }

                    //Additional Load/Reduction in Load
                    if((serviceRequests.contains(CXE_Constants.SERVICE_REQ_ADDITIONAL_LOAD) || serviceRequests.contains(CXE_Constants.SERVICE_REQ_REDUCTION_LOAD))
                      && isValidToFlip
                      && !(String.isNotBlank(caseRec.Service_Rate_Type__c) && String.isNotBlank(caseRec.Billing_Class__c)
                        && (caseRec.Applied_Load__c != null && caseRec.Applied_Load__c != 0)
                        && (caseRec.Demand_Factor__c != null && caseRec.Demand_Factor__c != 0)
                        && (caseRec.Load_Factor__c != null && caseRec.Load_Factor__c != 0)
                        && (caseRec.Contracted_Capacity__c != null && caseRec.Contracted_Capacity__c != 0)
                        && caseRec.PSIC__c != null
                      )){
                        isValidToFlip = false;
                    }

                    if(isValidToFlip){
                        caseRec.Status = CXE_Constants.CASE_APPLICATION_APPROVED;
                        caseRec.CXE_StatusPath__c = 'Complete';
                        lstCasesToUpdate.add(caseRec);
                    }
                }
            }
            //END iteration to check valid cases for flipping
            if(!lstCasesToUpdate.isEmpty()){
                try{
                    update lstCasesToUpdate;
                }catch(Exception e){
                    ErrorHandlerException.recordException(lstCasesToUpdate[0].Id, true, 'ContractTriggerHandler', 'updateCaseToAppApprovedMSA', e.getMessage());
                }
            }
        }
    }
}
//END CSM-12279 RReyes AUG-18-17

//START CSM-14606 RReyes NOV-27-17
public void updateAPAFields(Map<Id, Contract> newContracts, Map<Id, Contract> oldContracts){
    for(Contract contr: newContracts.values()){
        Contract oldContract = oldContracts.get(contr.Id);
        //START CSM-14973 RReyes DEC-27-17 - changed from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
        if(contr.CXE_Pending_APA_Enrollment__c && (contr.CXE_Pending_APA_Enrollment__c != oldContract.CXE_Pending_APA_Enrollment__c)){
            if(contr.CXE_Enrolled_to_APA_formula__c && !(contr.CXE_Pending_APA_Cancellation__c 
                            && contr.CXE_Reason_for_Cancellation_APA__c == Label.RFC_CHANGE_IN_NUMBER)){
                contr.CXE_Pending_APA_Enrollment__c = false;
            }
        }

        if(contr.CXE_Pending_APA_Cancellation__c && (contr.CXE_Pending_APA_Cancellation__c != oldContract.CXE_Pending_APA_Cancellation__c)){
            if(!contr.CXE_Enrolled_to_APA_formula__c){
                contr.CXE_Pending_APA_Cancellation__c = false;
            }
        }
        //END CSM-14973 RReyes DEC-27-17 - changed from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
    }

}
//END CSM-14606 RReyes NOV-27-17
}