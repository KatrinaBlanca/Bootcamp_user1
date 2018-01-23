/* 
 * Description: Handles the logic for Agreement__c Trigger
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-27-17
 */ 
public with sharing class AgreementTriggerHandler implements TriggerInterface 
{
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
    //Checks to see if the trigger has been disabled either by custom setting or by running code
    public Boolean IsDisabled() {
        //Added trigger control from heirarchy custom setting
        TriggerControl__c caseControl = TriggerControl__c.getInstance();
        return caseControl.Agreement__c;
    }

    public void BeforeInsert(List<SObject> newList) {
        //Begin CSM-973: Von Pernicia Feb-24-17
        List<Agreement__c> newLists = (List<Agreement__c>)newList;
        picklistTransformation(null, null, newLists, false);        
        //End CSM-973: Von Pernicia Feb-24-17
        // Start CSM-1057, CSM-1068 - Jerome To - Mar-02-2017
        runContractProcesses(newList, false);
        // End CSM-1057, CSM-1068 - Jerome To
        // Start CSM-1051 - Jerome To - Mar-02-2017
        updateServiceParentTag(newList);
        // End CSM-1051 - Jerome To

        UpdateDepositAmount(newLists, null, false);
        //START CSM-11886 RReyes - AUG-15-17
        updateSocioEconomicProfile(newLists, null, false);
        //END CSM-11886 RReyes - AUG-15-17
    } 
    
    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        //Begin CSM-973: Von Pernicia Feb-24-17
        Map<id, Agreement__c> newMaps = (Map<id, Agreement__c>)newMap;
        Map<id, Agreement__c> oldMaps = (Map<id, Agreement__c>)oldMap;
        
        picklistTransformation(newMaps, oldMaps, null, true);
        //End CSM-973: Von Pernicia Feb-24-17
        // Start CSM-1057, CSM-1068 - Jerome To - Mar-02-2017
        runContractProcesses(newMap.values(), true);
        // End CSM-1057, CSM-1068- Jerome To

        UpdateDepositAmount(newMaps.values(), oldMaps, true);
        //START CSM-11886 RReyes - AUG-15-17
        updateSocioEconomicProfile(newMaps.values(), oldMaps, true);
        //END CSM-11886 RReyes - AUG-15-17
    }
    
    public void BeforeDelete(Map<Id, SObject> oldMap){}

    public void AfterInsert(Map<Id, SObject> newMap){
        Map<id, Agreement__c> newMaps = (Map<id, Agreement__c>)newMap;
        updateModificationCaseBaseonParentService(newMaps.values()); //START/END CSM-7292 RReyes JUL-07-17
        //createServiceAddress(newMaps);
    }

    public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) 
    {
        Map<id, Agreement__c> newMaps = (Map<id, Agreement__c>)newMap;
        //corbes melvin 7-24-2011
        Map<id, Agreement__c> oldAgrMap = (Map<id, Agreement__c>)oldMap;
        
        updateCaseBaseonParentService(newMaps.values());
        
        autoEnrollNewlyEnergizedSIN(newMaps.values(), oldAgrMap);
        
        //Mike Verdad 08/09/2017
        //updateServiceEnrollments(newMaps.values());// commented out by Melvin Corbes
        
        //Corbes Melvin Aug-30-2017
         setServiceTerminatedToTrue(newMaps.values(), oldAgrMap);
       
       /*  Update failed. First exception on row 0 with id a120l0000000smTAAQ; first error: 
        *  CANNOT_EXECUTE_FLOW_TRIGGER, The record couldn’t be saved because it failed to trigger a flow. 
        *  A flow trigger failed to execute the flow with version ID 3010l0000008u0D.
        *  Flow error messages: <b>An unhandled fault has occurred in this flow</b>
        *  <br>An unhandled fault has occurred while processing the flow. 
        *  Please contact your system administrator for more information. Contact your administrator for help.: []
        */ 
        
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
//Begin CSM-973: Von Pernicia Feb-24-17
    public void picklistTransformation(Map<Id, Agreement__c> newAgreementMappings, Map<Id, Agreement__c> oldAgreementMappings, List<Agreement__c> newAgreementList, Boolean isUpdate)
    {   
        List<List<String>> arrayList = CXE_Constants.AGREEMENT_PICKLIST_ARRAY;
        
        Map<String, String> mapPicklistCode = CXE_Utility.picklistTransformationCode(arrayList);
        Map<String, String> mapPicklistDesc = CXE_Utility.picklistTransformationDesc(arrayList);
        
        Map<Integer, String> mapBillingClassDesc = new Map<Integer, String>();
        Map<String, Integer> mapBillingClassCode = new Map<String, Integer>();
        
        Map<String, Id> mapPSICid = new Map<String, Id>();
        Map<Id, String> mapPSICCode = new Map<Id, String>();
        
        CXE_Utility utilClass = new CXE_Utility();
        
        for (PSIC__c psic: [Select Id, PSIC_Code__c
        			from PSIC__c])
        {
        	mapPSICid.put(psic.PSIC_Code__c, psic.Id);
        	mapPSICCode.put(psic.Id, psic.PSIC_Code__c);
        }
        
        for (Reference__c r: [Select Name_Code__c, Name from Reference__c where Field__c='Billing Class'])
        {
            mapBillingClassDesc.put(Integer.valueOf(r.Name_Code__c), r.Name);
            mapBillingClassCode.put(r.Name, Integer.valueOf(r.Name_Code__c));
        }
        
        if (!isUpdate)
        {
            utilClass.picklistTransformationInsert(newAgreementList, arrayList, mapPicklistCode, mapPicklistDesc);
            
            for (Agreement__c c: newAgreementList)
            { 
            	// Start: Populate PSIC Code or PSIC lookup
            	if (c.PSIC__c != null)
	        	{
	        		c.Code_PSIC__c = mapPSICCode.get(c.PSIC__c);
	        	}
	        	
	        	if (c.Code_PSIC__c != null)
	        	{
	        		c.PSIC__c = mapPSICid.get(c.Code_PSIC__c);
	        	}
	        	// End: Populate PSIC Code or PSIC lookup
	        	
	        	// Start: Populate Billing Class Code or Billing Class Picklist
	        	if (c.Billing_Class__c != null)
	        	{
	        		c.Code_Billing_Class__c = mapBillingClassCode.get(c.Billing_Class__c);
	        	}
	        	
	        	if (c.Code_Billing_Class__c != null)
	        	{
	        		c.Billing_Class__c = mapBillingClassDesc.get(Integer.valueOf(c.Code_Billing_Class__c));
	        	}
	        	// End: Populate Billing Class Code or Billing Class Picklist
            }
            
        }
        else
        {   
            utilClass.picklistTransformationUpdate(newAgreementMappings, oldAgreementMappings, arrayList, mapPicklistCode, mapPicklistDesc);
            
            for (Agreement__c c: newAgreementMappings.values())
            {
            	// Start: Populate PSIC Code or PSIC lookup
            	if (c.Code_PSIC__c != oldAgreementMappings.get(c.id).Code_PSIC__c)
	        	{
	        		c.PSIC__c = mapPSICid.get(c.Code_PSIC__c);
	        	}
	        	
	        	if (c.PSIC__c != oldAgreementMappings.get(c.id).PSIC__c)
	        	{
	        		c.Code_PSIC__c = mapPSICCode.get(c.PSIC__c);
	        	}
	        	// End: Populate PSIC Code or PSIC lookup
	        	
	        	// Start: Populate Billing Class Code or Billing Class Picklist
	        	if (c.Code_Billing_Class__c != oldAgreementMappings.get(c.id).Code_Billing_Class__c)
	        	{
	        		c.Billing_Class__c = mapBillingClassDesc.get(Integer.valueOf(c.Code_Billing_Class__c));
	        	}
	        	
	        	if (c.Billing_Class__c != oldAgreementMappings.get(c.id).Billing_Class__c)
	        	{
	        		c.Code_Billing_Class__c = mapBillingClassCode.get(c.Billing_Class__c);
	        	}
	        	// End: Populate Billing Class Code or Billing Class Picklist
            }
        }
    }  
//End CSM-973: Von Pernicia Feb-24-17
    
    /* 
    * Description:  Updates Parent checkbox to true 
    *               if it is the first Service record 
    *               created for that particular case
    * Author: Jerome To (Accenture)
    * Date Created: Mar-02-2017
    * Start CSM-1051
    */ 
    public void updateServiceParentTag(List<SObject> newList){
        List<Agreement__c> newLists = (List<Agreement__c>)newList;
        Set<Id> caseIdsToBeChecked = new Set<Id>();
        Set<Id> caseIds = new Set<Id>();
        // Get All Case Ids to be checked
        for(Agreement__c serviceRec : newLists)  {
            if(serviceRec.Case__c != null) {
                caseIds.add(serviceRec.Case__c);
            }
        }
        
        if(!caseIds.isEmpty()) {
            for(Agreement__c serviceRec : [SELECT Case__c 
                                           FROM Agreement__c 
                                           WHERE Case__c=:caseIds 
                                           AND Parent_Tag__c = true]) {
                if(caseIds.contains(serviceRec.Case__c)){
                    caseIds.remove(serviceRec.Case__c);
                }
            }
            
            for(Agreement__c serviceRec : newLists) {
                if(caseIds.contains(serviceRec.Case__c)){
                    serviceRec.Parent_Tag__c = true;
                    caseIds.remove(serviceRec.Case__c);
                }
            }
        }
        
    }
    // End CSM-1051 - Jerome To
    
    
    /* 
    * Description:  Populates Case Lookup Field based on related Contract               -   Mar-02-2017 -   CSM-1057
    *               Validates each Service if the related Contract has related Address  -   Mar-03-2017 -   CSM-1068
    * Author: Jerome To (Accenture)
    * 
    */
    private void runContractProcesses(List<SObject> newList, Boolean isUpdate) {
        
        List<Agreement__c> newLists = (List<Agreement__c>)newList;
        Set<Id> contractIds = new Set<Id>();
        Set<Id> validContractIds = new Set<Id>();

        //Start CSM-3782 Von Pernicia JUN-24-17
        Id modifyRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_MODIFICATION_OF_ELECTRIC_APPLICATION).getRecordTypeId();
        Boolean isModifofService = false;
        Id caseId;
        //End CSM-3782 Von Pernicia JUN-24-17
        
        for(Agreement__c serviceRec : newLists)  {
            if(serviceRec.Contract__c != null) {
                contractIds.add(serviceRec.Contract__c);
            }

            //Start CSM-3782 Von Pernicia: Check if service case has value upon insert JUN-24-17
            if(serviceRec.Case__c != null) {
                caseId = serviceRec.Case__c;
            }
            //End CSM-3782 Von Pernicia: Check if service case has value upon insert JUN-24-17
        }
        
        //Start CSM-3782 Von Pernicia: Check if Case is for Modification of Service JUN-24-17
        for (Case c: [SELECT    RecordTypeId
                      FROM      CASE 
                      WHERE     Id =: caseId AND RecordTypeId =: modifyRecTypeId])
        {
            isModifofService = true;
        }
        //End CSM-3782 Von Pernicia: Check if Case is for Modification of Service JUN-24-17
        if(!contractIds.isEmpty()) { 
            // get contract ids that have address/es
            if(!newLists.isEmpty() && !contractIds.isEmpty()) {
                for(Address__c addressRec : [SELECT Contract__c FROM Address__c WHERE Contract__c=:contractIds]) {
                    validContractIds.add(addressRec.Contract__c);
                }
            }

            //START CSM-11942 GGrandea AUG-28-2017
            Map<Id, Id> contractIdCaseIdMap = new Map<Id, Id>();
            for(Case csRec : [SELECT Id, Contract__c FROM Case 
                                        WHERE Contract__c in: contractIds
                                         AND Status NOT IN (:CXE_Constants.CASE_APPLICATION_CLOSED, :CXE_Constants.CASE_APPLICATION_CANCELLED) ]){
                contractIdCaseIdMap.put(csRec.Contract__c, csRec.Id);
            }
            //END CSM-11942 GGrandea AUG-28-2017
            
            //Michael Lasala MAR-09-17 Added Case__r.Multimetering__c (CSM-1294)
            Map<Id, Contract> contractMap = new Map<Id, Contract>([SELECT Case__c,AccountId, Case__r.Multimetering__c FROM Contract WHERE Id=:contractIds]);
            
            for(Agreement__c serviceRec : newLists)  {
                // check if the contract has atleast one related address
                // if it has no address, add error to that record
                if(serviceRec.Contract__c != null && !validContractIds.contains(serviceRec.Contract__c)) {
                    serviceRec.addError(CXE_Constants.CREATE_SERVICE_ERROR_MESSAGE_CONTRACT_WITHOUT_ADDRESS);
                    continue;
                }
                
                // auto populate Case and Account Lookups based on the related Contract
                if(!contractMap.isEmpty()) {
                    if(serviceRec.Contract__c != null && contractMap.containsKey(serviceRec.Contract__c)) {

                        //Start CSM-3782/CSM-7239 Von Pernicia: Check if Case is for Modification of Service JUN-24-17
                        if (!isModifofService) 
                        {
	                        //START CSM-11942 GGrandea AUG-28-2017
	                        if(contractIdCaseIdMap.containsKey(serviceRec.Contract__c)){
	                            serviceRec.Case__c = contractIdCaseIdMap.get(serviceRec.Contract__c);
	                        }else{
	                            serviceRec.Case__c = contractMap.get(serviceRec.Contract__c).Case__c;
	                        }
	                        //END CSM-11942 GGrandea AUG-28-2017
                        
                        
	                        //Michael Lasala MAR-09-17 Added condition for multimeter to prevent auto assignment of 
	                        //                         Contract__c.Account__c to Service__c.Account__c for child Accounts (CSM-1294)
	                        if (!isUpdate && !contractMap.get(serviceRec.Contract__c).Case__r.Multimetering__c)
	                        {
	                        	serviceRec.Account__c = contractMap.get(serviceRec.Contract__c).AccountId;
	                        }
                        }
                        //End CSM-3782/CSM-7239 Von Pernicia: Check if Case is for Modification of Service JUN-24-17
                    }  
                }                
            }
        }
    }
/* 
 * Description: Update Agreement Deposit Amount
 * Parameters: Agreement Mapping 
 * Returns: Return type
 * Author: Von Pernicia (Accenture)
 * Date Created: MAR-30-17
*/  
    //Start CSM-2051: Von Pernicia MAR-30-17   
    public void updateDepositAmount(List<Agreement__c> newAgreementList, Map<ID, Agreement__c> oldAgreementList, Boolean isUpdate)
    {
        // bring all schedules
        Id newServRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        List<Id> caseIDList = new List<Id>();
        Map<Id, Case> caseMap = new Map<Id, Case>();

        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String profileName = profile[0].Name;

        List<Schedule__c> allSchedules = [select id, Name , Non_Residential_Rate__c , Residential_Rate__c, Schedule_Selector__c  
                                            from Schedule__c ];

        for (Agreement__c a : newAgreementList)
        {
            caseIDList.add(a.Case__c);
        }

        // Start CSM-12102 Von Pernicia JUL-29-17
        //Rhyan Cruz CSM-2772 Added Application_for_Business_Service__c in the query
        // Start CSM-11923 Von Pernicia JUL-22-17: Added RecordTypeId and CXE_Required_Deposit_Amount__c
        for (Case c: [Select Id, Application_for_Business_Customer__c, Application_for_Business_Service__c, Status, RecordTypeId, CXE_Required_Deposit_Amount__c, Override_Auto_Deposit_Amount__c  from Case where Id in: caseIDList])
        // End CSM-11923 Von Pernicia JUL-22-17: Added RecordTypeId and CXE_Required_Deposit_Amount__c
        // End CSM-12102 Von Pernicia JUL-29-17
        {
            caseMap.put(c.Id, c);
        }
        
        for (Agreement__c a : newAgreementList)
        {
            if (isUpdate)
            {
                ScheduleCollectionUtils.UpdateServiceWithScheduleDepositInfo(a,allSchedules, oldAgreementList.get(a.id), isUpdate, profileName, caseMap.get(a.Case__c));  
            }
            else
            {
                ScheduleCollectionUtils.UpdateServiceWithScheduleDepositInfo(a,allSchedules, null, isUpdate, profileName, caseMap.get(a.Case__c));   
            }
        }
    }
    //End CSM-2051: Von Pernicia MAR-30-17

    /* 
    * Description:  Update Case Actual Energization Date
    * Author: Von Pernicia (Accenture)
    * Date Created: Mar-30-2017
    * Defect: CSM-2044
    */ 
    public void updateCaseBaseonParentService(List<Agreement__c> newList)
    {
        //Start CSM-3782 Von Pernicia: Check if case is for New Service Application JUN-24-17
        Id newServRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        //START CSM-7292 RReyes JUL-07-17 - added recontract case
        Id recontractRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_RECONTRACT_OF_ELECTRIC_SERVICE).getRecordTypeId(); 
        //END CSM-7292 RReyes JUL-07-17 - added recontract case
        //End CSM-3782 Von Pernicia: Check if case is for New Service Application JUN-24-17
        Map<Id, Agreement__c> agreementMap = new Map<Id, Agreement__c>();
        List<Case> caseList = new List<Case>();

        for (Agreement__c a: newList)
        {
            if (a.Parent_Tag__c)
            {
                agreementMap.put(a.Case__c, a);
            }
        }

        //Start CSM-12496 Von Pernica SEP-09-17: Added App Closed and App Cancelled as a filter criteria and to Check Previous value for SIN and Start Date
        //START CSM-7292 RReyes JUL-07-17 - added recontract case
        //Start CSM-3782 Von Pernicia: Check if case is for New Service Application JUN-24-17
        for (Case c: [SELECT    Id, Actual_Energization_Date__c, RecordTypeId, SIN__c, CXE_New_SIN__c
                      FROM      Case 
                      WHERE     Id in: agreementMap.Keyset() 
                      AND       (RecordTypeId =: newServRecTypeId
                                OR RecordTypeId =: recontractRecTypeId)
                      AND       Status not in (: CXE_Constants.CASE_APPLICATION_CLOSED,
                                               : CXE_Constants.CASE_APPLICATION_CANCELLED)
                                ])

        //End CSM-3782 Von Pernicia: Check if case is for New Service Application JUN-24-17
        {
            /*
            Case cas = new Case(
                Id = c.Id,
                Actual_Energization_Date__c = agreementMap.get(c.Id).Agreement_Start_Date__c,
                SIN__c = agreementMap.get(c.Id).SIN__c
            );*/
            Boolean hasUpdate = false;

            if (c.Actual_Energization_Date__c != agreementMap.get(c.Id).Agreement_Start_Date__c)
            {
                hasUpdate = true;
            }

            if (c.SIN__c != agreementMap.get(c.Id).SIN__c && c.RecordTypeId == newServRecTypeId)
            {
                hasUpdate = true;
            }

            if (c.CXE_New_SIN__c != agreementMap.get(c.Id).SIN__c && (c.RecordTypeId == newServRecTypeId || c.RecordTypeId == recontractRecTypeId))
            {
                hasUpdate = true;
            }

            if (hasUpdate)
            {
                Case caseToUpdate = new Case();
                caseToUpdate.Id = c.Id;
                caseToUpdate.Actual_Energization_Date__c = agreementMap.get(c.Id).Agreement_Start_Date__c;
                if(c.RecordTypeId == newServRecTypeId){
                    caseToUpdate.SIN__c = agreementMap.get(c.Id).SIN__c;
                    caseToUpdate.CXE_New_SIN__c = agreementMap.get(c.Id).SIN__c;
                }else if(c.RecordTypeId == recontractRecTypeId){
                    caseToUpdate.CXE_New_SIN__c = agreementMap.get(c.Id).SIN__c;
                }

                caseList.add(caseToUpdate);
            }
        }
        //END CSM-7292 RReyes JUL-07-17 - added recontract case
        if(!caseList.isEmpty())
        {
            update caseList;
        } //End CSM-12496 Von Pernica SEP-09-17: Added App Closed and App Cancelled as a filter criteria and to Check Previous value for SIN and Start Date
    }
   
   
    /*  START CSM-10613
    * Description:  Auto Enroll the newly energized SIN as part of the already portal-enrolled services
    * Author: Melvin Corbes
    * Date Created: JUL-25-2017 
    * Defect: 
    */ 
    public void autoEnrollNewlyEnergizedSIN(List<Agreement__c> agrList, Map<Id, Agreement__c> oldMap) {
        try{
            Set<Id> contractIds = new Set<Id>();
            Map<Id, Set<Id>> userIdContractIdsMap;
            List<CXE_Service_Enrollment__c> enrollmentsToInsert = new  List<CXE_Service_Enrollment__c>();
            Set<Id> userIds;
           
            for(Agreement__c aggrmnt :agrList){
                if(aggrmnt.Service_Status__c ==CXE_Constants.SERVICE_STATUS_ACTIVE 
                        && oldMap.get(aggrmnt.Id).Service_Status__c != CXE_Constants.SERVICE_STATUS_ACTIVE 
                        && aggrmnt.Payor__c!=null){
                    
                            contractIds.add(aggrmnt.Payor__c);
                }            
            }

            if(!contractIds.isEmpty()){
                userIdContractIdsMap = new Map<Id, Set<Id>>();
                Set<Id> tempIds;
                List<CXE_Service_Enrollment__c> enrollments = [SELECT Id, CXE_UserId__c, CXE_Type__c, CXE_IsActive__c
                                                                        , CXE_ServiceId__r.Payor__c
                                                                FROM CXE_Service_Enrollment__c 
                                                                WHERE CXE_ServiceId__r.Payor__c =: contractIds
                                                                AND CXE_IsActive__c = true 
                                                                AND CXE_Type__c =: CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR];
                for(CXE_Service_Enrollment__c enrol: enrollments){
                    if(userIdContractIdsMap.containsKey(enrol.CXE_ServiceId__r.Payor__c)){
                        tempIds = userIdContractIdsMap.get(enrol.CXE_ServiceId__r.Payor__c);
                    }else{
                        tempIds = new Set<Id>();
                    }
                    tempIds.add(enrol.CXE_UserId__c);
                    userIdContractIdsMap.put(enrol.CXE_ServiceId__r.Payor__c, tempIds);
                }

                if(!userIdContractIdsMap.isEmpty()){
                    userIds = new Set<Id>();
                    for(Agreement__c agrm : agrList){
                        if(userIdContractIdsMap.containsKey(agrm.Payor__c)){
                            for(Id userId : userIdContractIdsMap.get(agrm.Payor__c)){
                                enrollmentsToInsert.add(
                                        new CXE_Service_Enrollment__c(CXE_UserId__c=userId,
                                                                        CXE_ServiceId__c=agrm.Id,
                                                                        CXE_IsActive__c=true,
                                                                        CXE_Type__c=CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR)
                                                            );
                                userIds.add(userId);
                            }
                        }
                    }
                }
            }

            if(!enrollmentsToInsert.isEmpty()){
                insert enrollmentsToInsert;
                List<User> userListToUpdate = new List<User>();
                User tempUser;
                for(Id userId : userIds){
                    tempUser = new User(Id=userId, CXE_Auto_Enrolled_Services__c=true);
                    userListToUpdate.add(tempUser);
                }
                update userListToUpdate;
            }
        }catch(Exception ex){
            ErrorHandlerException.recordException(null, true, 'AgreementTriggerHandler'
                                                    , 'autoEnrollNewlyEnergizedSIN', ex.getMessage());
        }

    }
    //END START CSM-10613
    
    /*Mike Verdad 08/09/2017
	 *This will deactivate all service enrollments once the related service status has been terminated.
	 */
    /*public void updateServiceEnrollments(List<Agreement__c> newList){
        
        Set<Id> serviceID = new Set<Id>();
        
        for (Agreement__c a: newList){
            
            if (a.Service_Status__c == 'Terminated'){
                serviceID.add(a.Id);
                
            }
        }  
        
        List<CXE_Service_Enrollment__c> relatedServiceEnrollments = [SELECT id, CXE_IsActive__c, CXE_ServiceId__c, CXE_Unenrollment_Date__c
                                                                     from CXE_Service_Enrollment__c 
                                                                     WHERE CXE_ServiceId__c IN:serviceID AND CXE_IsActive__c = true];
        
        for(CXE_Service_Enrollment__c servEn: relatedServiceEnrollments){
            
           
                servEn.CXE_IsActive__c = false;
                servEn.CXE_Unenrollment_Date__c = system.now();
            
        } 
        
        update relatedServiceEnrollments;
    }*/
    // End of Mike Verdad 08/09/2017
    /* Description:  Update New SIN on Case
    * Author: Rom Edison Reyes (Accenture)
    * Date Created: JUL-07-2017
    * Defect: CSM-7292
    */ 
    public void updateModificationCaseBaseonParentService(List<Agreement__c> newList)
    {
        Id modifyRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_MODIFICATION_OF_ELECTRIC_APPLICATION).getRecordTypeId();

        Map<Id, Agreement__c> agreementMap = new Map<Id, Agreement__c>();
        List<Case> caseList = new List<Case>();
        String serviceRequests = '';

        for (Agreement__c a: newList)
        {
            if (a.Parent_Tag__c)
            {
                agreementMap.put(a.Case__c, a);
            }
        }

        for (Case c: [SELECT    Id, Actual_Energization_Date__c, 
                                CXE_Service_Request_s__c, 
                                CXE_Change_in_Service_Rate__c
                      FROM      Case 
                      WHERE     Id in: agreementMap.Keyset() 
                      AND       RecordTypeId =: modifyRecTypeId])
        {
            serviceRequests = c.CXE_Service_Request_s__c != null ?  c.CXE_Service_Request_s__c : '';
            if(serviceRequests.contains(CXE_Constants.SERVICE_REQ_TRANSFER) || c.CXE_Change_in_Service_Rate__c)
            {
                Case caseToUpdate = new Case();
                caseToUpdate.Id = c.Id;
                //caseToUpdate.Actual_Energization_Date__c = agreementMap.get(c.Id).Agreement_Start_Date__c;
                caseToUpdate.CXE_New_SIN__c = agreementMap.get(c.Id).SIN__c;

                caseList.add(caseToUpdate); 
            }
        }
        if(!caseList.isEmpty()){
            update caseList;
        }
    }

    //START CSM-11886 RReyes AUG-15-17
    /* 
    * Description:  Socio-Economic Profile calculation
    * Author: Rom Edison Reyes (Accenture)
    * Date Created: AUG-15-2017
    */ 
    public void updateSocioEconomicProfile(List<Agreement__c> newList, Map<Id, Agreement__c> oldMap, Boolean isUpdate)
    {
        List<Agreement__c> serviceToUpdate = new List<Agreement__c>();
        Set<String> INVALID_RATE_TYPE = new Set<String>{'132TYSERRA', '120TYSERRA', '141TYSERRA'};

        //get services to be updated
        if(isUpdate){
            for(Agreement__c newServ : newList){
                Agreement__c oldServ = oldMap.get(newServ.Id);
                if((newServ.Contracted_Capacity__c  != oldServ.Contracted_Capacity__c 
                        && newServ.Code_Segment__c == 'BSEGTYP003')||
                    newServ.Code_Segment__c != oldServ.Code_Segment__c ||
                    newServ.Code_Rate__c  != oldServ.Code_Rate__c){
                    serviceToUpdate.add(newServ);
                }
            }
        }else{
              serviceToUpdate = newList; 
        }

        if(!serviceToUpdate.isEmpty()){
            for(Agreement__c s: serviceToUpdate){
                //Corporate Business Group (CBG)
                if(s.Code_Segment__c == 'BSEGTYP001' || s.Code_Segment__c == '1'){ // CSM-13931 LISEN 20171016 : to also handle 1 digit from DM issue
                    s.CXE_Socio_Economic_Profile__c = Label.SEP_CBG;
                }//Home and Micro Business (HMB) 
                 //AND Rate Type != Multiple Family Residential/Single Family Residential/Residential Service (RS)
                else if((s.Code_Segment__c == 'BSEGTYP002' || s.Code_Segment__c == '2') && !INVALID_RATE_TYPE.contains(s.Code_Rate__c)){ // CSM-13931 LISEN 20171016 : to also handle 1 digit from DM issue
                    s.CXE_Socio_Economic_Profile__c = Label.SEP_MICROBIZ;
                }//SME Business Group (SBG)
                else if((s.Code_Segment__c == 'BSEGTYP003' || s.Code_Segment__c == '3') && s.Contracted_Capacity__c != null){ // CSM-13931 LISEN 20171016 : to also handle 1 digit from DM issue
                     //if(s.Contracted_Capacity__c <= 40){
                     if(s.Contracted_Capacity__c < 40){ //CSM-13717 Corbes Melvin  10-05-2017
                        s.CXE_Socio_Economic_Profile__c = Label.SEP_BIZ_NON_GP;
                    }else{
                        s.CXE_Socio_Economic_Profile__c = Label.SEP_BIZ_GP;
                    }
                }else{
                    s.CXE_Socio_Economic_Profile__c = '';
                }
            }
        }
    }
    //END CSM-11886 RReyes AUG-15-17 - Socio-Economic Profile calculation

	/*Author: Melvin Corbes
	 * Date: Aug-30-2017   CSM-12194
	 * Description : set CXE_ServiceTerminated__c to true from CXE_Service_Enrollment__c
	 * if the previous status of service is active and new Status is Terminated
	 */ 
    public static void setServiceTerminatedToTrue(List<Agreement__c> agrList, Map<Id, Agreement__c> oldMap){
       
       
        Set<Id> servicesId = new Set<Id>();
        
        //Compare the values of new Map and Old Map
        for(Agreement__c aggrmnt :agrList){
            if(aggrmnt.Service_Status__c == CXE_Constants.SERVICE_STATUS_TERMINATED 
               && oldMap.get(aggrmnt.Id).Service_Status__c == CXE_Constants.SERVICE_STATUS_ACTIVE){
                  //get the agreement ID
                  servicesId.add(aggrmnt.Id);
               }                               
        }
        
        //Query the service Id in Service Enrollment
        if(!servicesId.isEmpty()){
            //get all the service enrollment record
         	List<CXE_Service_Enrollment__c> enrolledServices =[SELECT Id, CXE_ServiceTerminated__c,
                                                               CXE_Unenrollment_Date__c,CXE_IsActive__c
                                                               FROM CXE_Service_Enrollment__c
                                                               WHERE CXE_ServiceId__c IN:servicesId
                                                               AND CXE_ServiceTerminated__c = FALSE ]; 
            //holder for final data
            List<CXE_Service_Enrollment__c> updateServTermStat = new List<CXE_Service_Enrollment__c>();
            
            //Process if there are data in service enrollment
            if(!enrolledServices.isEmpty()){
                    for(CXE_Service_Enrollment__c enrlldServiceRec : enrolledServices){
                        enrlldServiceRec.CXE_ServiceTerminated__c =True;
                        updateServTermStat.add(enrlldServiceRec);
                } 
                
                //process if there data that needs to be updated
                if(!updateServTermStat.isEmpty()){
                    try{
                        update updateServTermStat; 
                        
                    }catch(DMLException ex){
                        
                          ErrorHandlerException.recordException(null, true, 'AgreementTriggerHandler'
                                                    , 'setCXE_ServiceTerminated', ex.getMessage());
                    }
                   
                } 
            }
              
        }// end of if
            
            
        
    }//end of method
    

}