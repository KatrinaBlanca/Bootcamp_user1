/* 
 * Description: Handles the logic for Case Trigger
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-10-17
 */ 
 
public without sharing class CaseTriggerHandler implements TriggerInterface
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


    static Boolean isAdministrator = CXE_Utility.isAdmin();
    
    public static Boolean isRetrieveService = false; //Start/End CSM-11428 Von Pernicia JUL-12-17
    public static Boolean isIns = false; // Start/End CSM-12149 & CSM-12144 Von Pernicia AUG-01-17
    public static Boolean isCreateNewAcct = false; //STRAT END CSM-12250 Zhu Wenjun AUG-11-17
    public static Boolean isClickUpdateBD = false; //STRAT END CSM-12246 Zhu Wenjun AUG-11-17
    public static Boolean isClickOutstandingAmount = false; //STRAT END CSM-12256 Von Pernicia AUG-16-17
    public static Boolean isAdmin = CXE_Utility.isAdmin(); //START/END CSM-12370 RReyes SEP-04-17 - get isAdmin
    public static Boolean isRecurssion = false; //START/END CSM-14114 Von Pernicia Nov-07-17
    
    // Apply the criteria only to certain record types
    public Id commRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_CUSTOMER_COMMUNITY).getRecordTypeId();
    public Id adminRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APP_ADMIN).getRecordTypeId();
    public Id custRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_CUSTOMER_COMMUNITY_RT).getRecordTypeId();
    public Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();
    public Id emailRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SCS_EMAIL_CASE).getRecordTypeId();
    public Id socialRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SCS_SOCIAL_MEDIA_CASE).getRecordTypeId();
    public Id newServRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
    //START RReyes MAY-26-17 CSM-3838
    public Id modifyRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_MODIFICATION_OF_ELECTRIC_APPLICATION).getRecordTypeId();
    public Id terminateRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_TERMINATION_OF_ELECTRIC_SERVICE).getRecordTypeId();
    public Id recontractRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_RECONTRACT_OF_ELECTRIC_SERVICE).getRecordTypeId();
    //END RReyes MAY-26-17 CSM-3838
    
    //START CSM-XXXX RReyes JUL-21-17 - set email for notif
    public Id portalRegRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_PORTAL_REGISTRATION_SIN_ENROLLMENT).getRecordTypeId();
    //END CSM-XXXX RReyes JUL-21-17 - set email for notif   
    
    // start VON-TBD
    public Id paperlessRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_PAPERLESS_BILLING).getRecordTypeId();
    // end VON-TBD
    
    //START JEROME TO   MAY-29-17
    static final Map<String, Id> caseRecordTypes;
    static {
        caseRecordTypes = new Map<String, Id>();
        for(RecordType recType : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Case' AND IsActive = true]){
            caseRecordTypes.put(recType.DeveloperName, recType.Id);
        }
    }
    //END JEROME TO   MAY-29-17

    //start CSM- MFernandez 10-25-17 - set recordtype for APA
    public Id apaEnrollmentRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_APA).getRecordTypeId();
    //end CSM- MFernandez 10-25-17 - set recordtype for APA
    
    //Checks to see if the trigger has been disabled either by custom setting or by running code
    public Boolean IsDisabled() {
        //BEGIN FEB-03-17 Michael Lasala
        //Added trigger control from heirarchy custom setting
        TriggerControl__c caseControl = TriggerControl__c.getInstance();
        return caseControl.Case__c;
        //END FEB-03-17 Michael Lasala
    }

    public void BeforeInsert(List<SObject> newList) 
    {
        List<Case> newLists = (List<Case>)newList;
        validatePrevSIN(newLists); //START/END CSM-12224 Von Pernicia AUG-07-17
        checkModifyServiceDuplicate(newLists); // JEROME TO MAY-29-17 CSM-6151
        validateIfAccountHasCustomerNumber(newLists, null, false); //START/END CSM-7272 RReyes JUL-06-17
        //updatePSICResidential(newLists, null); // Jerome To MAR-27-17 CSM - 2022
        //populateLoadAndDemandFactor(newLists); // Jerome To MAR-27-17 CSM - 2001 //START/END CSM-7171 Commented by RReyes JUN-23-17 - moved the method call after autopopulation
        //populateContractedCapacity(newLists); // Jerome To MAR-27-17 CSM - 2001 //START/END CSM-7162 Commented by RReyes JUN-23-17 - moved the method call after autopopulation
        //validateRequiredFields(newList); //START/END: CSM-1089 - Rom Edison Reyes 03/03/17
        
        //START RReyes MAY-26-17 CSM-3838
        if(validateIfMappingIsNeeded(newList, null,true)){
            populateCaseFieldsFromService(newList);
        }
        //END RReyes MAY-26-17 CSM-3838
        populateLoadAndDemandFactor(newLists, null, false);//START/END CSM-7171 RReyes JUN-23-17 - moved the method call after autopopulation
        populateContractedCapacity(newLists, null);//START/END CSM-7162 RReyes JUN-23-17 - moved the method call after autopopulation
        UpdateDepositAmount(newLists, null, false);
    
        //Begin CSM-973: Von Pernicia Feb-24-17
        picklistTransformation(null, null, newLists, false);
        //End CSM-973: Von Pernicia Feb-24-17

        //Michael Lasala MAR-21-17 (CSM-161)
        populateCaseResponsibleOffice(newList);

        //Michael Lasala MAR-23-17 (CSM-1921/1974/1975)
        populateCaseAccountContactDetails(newList);
        validateRulesForAMCTagging(newList, null); // CSM-3779 Jerome To  JUN-02-17
        //START CSM-6704 RReyes JUN-14-17
        mapStatusPath(newLists, null, false);
        mapReceivedAndClosedDate(newLists, null, false);
        //END CSM-6704 RReyes JUN-14-17
        //START CSM-12277 RReyes AUG-17-17
        calculateRequiredBD(newLists, null, false);
        //END CSM-12277 RReyes AUG-17-17
        checkBirthdayIfBlank(newLists, false, null); //START/END CSM-12249 Von Pernicia AUG-10-17

        isIns = true; // Start/End CSM-12149 & CSM-12144 Von Pernicia AUG-01-17
        populateBusinessEmailForNotif(newLists); //START/END CSM-XXXX RReyes JUL-21-17 - R2B set email recipient for notif
        updateAPAAgentBasedOnContract(newLists, null, false); //START/END CSM-14973 RReyes DEC-27-17
        
    }

    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap)
    {
        
        Map<id, Case> newMaps = (Map<id, Case>)newMap;
        Map<id, Case> oldMaps = (Map<id, Case>)oldMap;

        System.debug('Previous:' + oldMaps.get(newMaps.values().get(0).Id).Status);
        System.debug('Current:' + newMaps.values().get(0).Status);

        validateCaseUpdateForNonSysAd(newMaps.values(), oldMaps);//START/END CSM-11457 RReyes JUL-17-17 - transfer CXE_Allow_System_Admins_Only case validation rule in trigger
        validateIfAccountHasCustomerNumber(newMaps.values(), oldMaps, true); //START/END CSM-7272 RReyes JUL-06-17
        validationOnAwaitingCustomerCompliance(newMaps.values(), oldMaps); // JEROME TO CSM-6448,CSM-6147 JUN-05-17
        //updatePSICResidential(newMaps.values(), null); // Jerome To MAR-27-17 CSM - 2022
        //populateLoadAndDemandFactor(newMaps.values()); // Jerome To MAR-27-17 CSM - 2001 //START/END CSM-7171 Commented by RReyes JUN-23-17 - moved the method call after autopopulation
        //populateContractedCapacity(newMaps.values()); // Jerome To MAR-27-17 CSM - 2001 //START/END CSM-7162 Commented by RReyes JUN-23-17 - moved the method call after autopopulation
        //ValidateCaseStatusChanges(newMaps, oldMaps);
        //validateRequiredFields(newMaps.values()); //START/END: CSM-1089 - Rom Edison Reyes 03/03/17
 
        //updateToApplicationEvaluated(newMaps.values()); // Jerome To MAR-18-17 CSM - 1878 //START/END CSM-7065 CommentedOut by RReyes - moved method call below to allow population of fields before checking for app evaluated
        validateCaseStatuses(newMaps.values(), oldMaps); // Jerome To MAR-14-17 CSM-1340 , Jerome To JUL-04-17 CSM-7230
        validateChangeInRequiredBD(newMaps.values(), oldMaps);//START/END CSM-12277 RReyes AUG-17-17 - validation on BD change
        //START RReyes MAY-26-17 CSM-3838
        if(validateIfMappingIsNeeded(newMaps.values(), oldMaps, false)){

            populateCaseFieldsFromService(newMaps.values());
            //JEROME TO JUN-01-17 (CSM-3803, CSM-3755)
            populateCaseResponsibleOffice(newMaps.values());
        }
        //END RReyes MAY-26-17 CSM-3838
        populateLoadAndDemandFactor(newMaps.values(), oldMaps, true);//START/END CSM-7171 RReyes JUN-23-17 - moved the method call after autopopulation     
        populateContractedCapacity(newMaps.values(), oldMaps); //START/END CSM-7162 RReyes JUN-23-17 - moved the method call after autopopulation
        flagAsRequiredToClickRetrieveButton(newMaps.values(), oldMaps); // JEROME TO JUN-21-2017 CSM-7104
        //START CSM-12251 AUG-11-17 Commentedby RReyes 
        //validateClickRetrieveOutstandingAmount(newMaps.values(), oldMaps); //START/END CSM-12223 RReyes AUG-08-17
        //validateClickUpdateBillDeposit(newMaps.values(), oldMaps); //START/END CSM-12217 RReyes AUG-08-17
        //END CSM-12251 AUG-11-17 Commentedby RReyes 
        //START CSM-7151 RReyes JUL-12-17 - remove deposit schedule if Serv. Rate Type is changed, and is not RS or GSA
        removeBillDepositScheduleIfRateTypeIsChanged(newMaps.values(), oldMaps);
        //END CSM-7151 RReyes JUL-12-17 - remove deposit schedule if Serv. Rate Type is changed, and is not RS or GSA
        UpdateDepositAmount(newMaps.values(), oldMaps, true);

        //Begin CSM-973: Von Pernicia Feb-24-17
        picklistTransformation(newMaps, oldMaps, null, true);
        //End CSM-973: Von Pernicia Feb-24-17
        
        //Michael Lasala MAR-12-17
        // Start CSM-2139 Von Pernicia May-05-2017: Commented out to populate RO w/o IRO for Web2Case
        //validateResponsibleOffice(oldMaps, newMaps);
        // End CSM-2139 Von Pernicia May-05-2017: Commented out to populate RO w/o IRO for Web2Case
        //START CSM-7140 RReyes JUN-22-17 Populate fields from Account and Contact records for Recontracting Cases
        updateAccountContactFieldsOnCaseForRecontract(newMaps.values(), oldMaps); 
        //END CSM-7140 RReyes JUN-22-17 Populate fields from Account and Contact records for Recontracting Cases
        updateAccountFieldsOnChangeOfAccount(newMaps.values(), oldMaps); //START/END CSM-7189 RReyes JUN-28-17
        validateRulesForAMCTagging(newMaps.values(), oldMaps); // CSM-3779 Jerome To  JUN-02-17
        //START CSM-12277 RReyes AUG-17-17
        calculateRequiredBD(newMaps.values(), oldMaps, true);
        //END CSM-12277 RReyes AUG-17-17
        updateToApplicationEvaluated(newMaps.values()); //START/END CSM-7065 CommentedOut by RReyes - moved method call to allow population of fields before checking for app evaluated
        //START CSM-6704 RReyes JUN-14-17
        mapStatusPath(newMaps.values(), oldMaps, true); 
        mapReceivedAndClosedDate(newMaps.values(), oldMaps, true);
        //END CSM-6704 RReyes JUN-14-17
        
        // Start Von Pernicia MAY-30-2017 CSM-3861
        validateServiceRequest(newMaps, oldMaps);
        // End Von Pernicia MAY-30-2017 CSM-3861 
        setPBFlagtoFalse(newMaps.values());//START/END CSM-7335 RReyes JUL-11-17 - set isUpdatedFromPB? to false

        checkBirthdayIfBlank(newMaps.values(), true, oldMaps); //START/END CSM-12249 Von Pernicia AUG-10-17

        isChangeinRate(newMaps.values()); //START/END CSM-12252 on Pernicia AUG-12-17
        //START CSM-12279 RReyes AUG-18-17
        flipToApplicationApprovedMSA(newMaps.values());
        //END CSM-12279 RReyes AUG-18-17
        validateReuseOfContractField(newMaps.values(), oldMaps); //CSM-11942
        updateAPAAgentBasedOnContract(newMaps.values(), oldMaps, true); //START/END CSM-14973 RReyes DEC-27-17
    }

    public void BeforeDelete(Map<Id, SObject> oldMap){}

    public void AfterInsert(Map<Id, SObject> newMap){
    
        Map<id, Case> newMaps = (Map<id, Case>)newMap;

        caseTransition(newMaps, null, false);
        CaseAssignment(newMaps);

        //Start CSM-7223: Von Pernicia JUL-03-17
        createCaseRequirement(newMaps.values(), false);
        //End CSM-7223: Von Pernicia JUL-03-17
        
        updateContractBillPrintMode(newMaps.values(), null); //CSM-12543

        //START RReyes SEP-02-17 CSM-12370- check if case is required to automatically create Service Address
        checkAutoCreateServiceAddress(newMaps.values(), null, false);
        //END RReyes SEP-02-17 CSM-12370- check if case is required to automatically create Service Address

        runPaperlessBillemailBatchJob(newMaps.values(), null); //CSM-13657
    
    // START R2C CSM-14084 Shayne 10/27/2017 Apex Sharing
        shareCaseConglomerate(newMaps.values(), null);
    // END R2C CSM-14084 Shayne 10/27/2017
        //START CSM-13194 RReyes - NOV-06-17
        updatePendingAPAOnContract(newMaps.values());
        //END CSM-13194 RReyes - NOV-06-17
        
        //START R2C CSM-13199 JFernandez 11/2/2017
        getServiceIdForAPAEnrollment(newMaps.values(), null, false);
        //END R2C CSM-13199 JFernandez 11/2/2017

        //START CSM-14606 RReyes NOV-27-17
        updateContractOnAPAStatusChange(newMaps, null, false);
        //END CSM-14606 RReyes NOV-27-17

        //Start of CSM-14836 Von Pernicia 12-13-2017
        portalRegSendEmailNotification(newMaps.values());
        //End of CSM-14836 Von Pernicia 12-13-2017
    }

    public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap){
        
        Map<id, Case> newMaps = (Map<id, Case>)newMap;
        Map<id, Case> oldMaps = (Map<id, Case>)oldMap;

        // Start CSM-11476 Von Pernicia JUL-19-17 
        //createServiceAddressFromService(newMaps.values());//START/END Commented out by RReyes SEP-02-17 CSM-12370 
        // End CSM-11476 Von Pernicia JUL-19-17 

        caseTransition(newMaps, oldMaps, true);
        
        //START R2C CSM-14114 Von Pernicia 11/6/2017
        createPaperlessBillingCase(newMaps.values(), oldMaps);
        //END R2C CSM-14114 Von Pernicia 11/6/2017
        
        //submitApprovalProcess(newMaps, oldMaps);
        //Rhyan Cruz CSM 6123
        populateAccountDOBCustType(newMaps.values(), oldMaps); //CSM-14238
        
        //Start CSM-7223: Von Pernicia JUL-03-17
        createCaseRequirement(newMaps.values(), true);
        //End CSM-7223: Von Pernicia JUL-03-17
        relateAccountToAddress(newMaps.values(), oldMaps); //START/END CSM-7270 RReyes - relate account to service and billing addresses of case

        updateContractBillPrintMode(newMaps.values(), oldMaps); //CSM-12543

        //START RReyes SEP-02-17 CSM-12370- check if case is required to automatically create Service Address
        checkAutoCreateServiceAddress(newMaps.values(), oldMaps, true);
        //END RReyes SEP-02-17 CSM-12370- check if case is required to automatically create Service Address

        runPaperlessBillemailBatchJob(newMaps.values(), oldMaps); //CSM-13657
        
        // START R2C CSM-14084 Shayne 10/27/2017 Apex Sharing
        shareCaseConglomerate(newMaps.values(), oldMaps);
        // END R2C CSM-14084 Shayne 10/27/2017
        //START CSM-13194 RReyes NOV-06-17
        //START CSM-14606 RReyes NOV-27-17
        updateContractOnAPAStatusChange(newMaps, oldMaps, true);
        //END CSM-14606 RReyes NOV-27-17
        //END CSM-13194 RReyes NOV-06-17
        
        //START R2C CSM-13199 JFernandez 11/2/2017
        getServiceIdForAPAEnrollment(newMaps.values(), oldMaps, true);
        //END R2C CSM-13199 JFernandez 11/2/2017
    }

    public void AfterDelete(Map<Id, SObject> oldMap){}

    public void AfterUndelete(Map<Id, SObject> oldMap){}
    
/* 
 * Description: Trigger from Click
 * Parameters: Case Mapping 
 * Returns: Return type
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-10-17
  
    public void caseTransition(Map<Id, Case> newCaseMappings, Map<Id, Case> oldCaseMappings, Boolean isUpdate)
    { 
        List<Case_State_Transition_Setting__mdt> allSettings = CaseStateTransitionHelper.getAllsettings();
        List<Case_State_Transition__c> dataToBeInserted = new List<Case_State_Transition__c>();
        System.debug('============= newCaseMappings.size() : ' + newCaseMappings.size());
        for(case c :newCaseMappings.values())
        {
            // Record type should be on of the following
            // Customer Community, Service Application (Admin), Customer Community Record Type, Service Application, New Service Application
            //if(c.RecordTypeId == commRecTypeId || c.RecordTypeId == adminRecTypeId || c.RecordTypeId == custRecTypeId || c.RecordTypeId == servRecTypeId || c.RecordTypeId == newServRecTypeId) {  //Rhyan Cruz 08192017 Remove condition to check rec types                    
        // START Rhyan cruz CSM-12374 08/31/2017 Modified exempted rec types 
            if(c.RecordTypeId != emailRecTypeId && c.RecordTypeId != socialRecTypeId) {
            // END Rhyan cruz CSM-12374 08/31/2017 Modified exempted rec types 
        string toState = c.status;
                string fromState = '';
            
                if (trigger.isUpdate){
                    fromState = oldCaseMappings.get(c.id).status;
                    
                }
                System.debug('============= CaseStateTransitionHelper.processedCaseId : ' + CaseStateTransitionHelper.processedCaseId);
                System.debug('============= c.id : ' + c.id);
                if (toState != fromState && CaseStateTransitionHelper.processedCaseId <> c.id){
                    System.debug('============= fromState : ' + fromState);
                    System.debug('============= toState : ' + toState);
                    Case_State_Transition__c caseTran = CaseStateTransitionHelper.AddTransition(c.id,fromState,toState,allSettings);
                    dataToBeInserted.add(caseTran);
                    CaseStateTransitionHelper.processedCaseId = c.id;
                }
            }// START/END Rhyan cruz CSM-12374 08/31/2017 Modified exempted rec types 
            //} //Rhyan Cruz 08192017 Remove condition to check rec types
        }
    
        if(dataToBeInserted.size() > 0) 
        {
            List <Case_State_Transition__c> dataToBeUpdated = new List <Case_State_Transition__c>();
            for(Case_State_Transition__c rec : dataToBeInserted)
            {
                if (rec.Mediator_Reference_Trans_ID__c != null)
                {
                    Case_State_Transition__c relatedRec = CaseStateTransitionHelper.getRcordByName(rec.Mediator_Reference_Trans_ID__c);
                    if (relatedRec != null)
                    {
                        relatedRec.Mediator_Used__c = true;
                        dataToBeUpdated.add(relatedRec);
                    }
                }
            }
            insert dataToBeInserted;
            if(dataToBeUpdated.size() > 0) 
            {
                update dataToBeUpdated;
            }
        }
        
        // Start CSM-11476 Von Pernicia JUL-19-17 
        //START CSM-7230 code review items
        //This is to avoid duplicate dml call
       //if (!Test.isRunningTest())
        //{
         //   TriggerDispatcher.isRecursion = false;
        //}
        //END CSM-7230
        // Start CSM-11476 Von Pernicia JUL-19-17 
    } */
    /* 
* Description: Trigger from Click
* Parameters: Case Mapping 
* Returns: Return type
* Author: Von Pernicia (Accenture)
* Date Created: FEB-10-17
*               JUL-5-17  CSM-7230     method/code optimization; remove SOQL within for-loop
*/  
    public void caseTransition(Map<Id, Case> newCaseMappings, Map<Id, Case> oldMap, Boolean isUpdate)
    { 
        List<Case_State_Transition_Setting__mdt> allSettings = CaseStateTransitionHelper.getAllsettings();
        List<Case_State_Transition__c> dataToBeInserted = new List<Case_State_Transition__c>();
        
        Map<Id, Case> filteredCases = new Map<Id, Case>();
        Set<String> fromStates = new Set<String>();
        
        for(Case c :newCaseMappings.values())
        {
            //START CSM-14296 11.07.2017
            if( (c.RecordTypeId == newServRecTypeId || c.RecordTypeId == modifyRecTypeId 
                    || c.RecordTypeId == terminateRecTypeId || c.RecordTypeId == recontractRecTypeId)
                        && !CaseStateTransitionHelper.processedCaseIds.contains(c.Id) ){ 
            //END CSM-14296 11.07.2017

                   //filter records if onCreate or onUpdate (with Status change)
                   if ( !isUpdate || c.Status!=oldMap.get(c.id).Status ){ 
                       /*Case_State_Transition__c caseTran = CaseStateTransitionHelper.AddTransition(c.id, oldMap.get(c.id).status, 
c.status, allSettings);
dataToBeInserted.add(caseTran);*/
                       filteredCases.put(c.Id, c);
                       if(isUpdate){
                           fromStates.add(oldMap.get(c.id).Status);
                       }
                   }
               }
        }
        
        if(!filteredCases.isEmpty()){
            Case_State_Transition__c caseTran;
            Map<String, Case_State_Transition__c> caseIdToStatusCstMap = 
                CaseStateTransitionHelper.getPreviousFromDates(filteredCases.keySet(), fromStates);
            Map<String, Case_State_Transition__c> caseIdToStatusPreviousCstMap = 
                CaseStateTransitionHelper.getPrevMediators(filteredCases.keySet(), fromStates);
            Date dateToday = Date.Today();
            for(Case c : filteredCases.values()){
                if(isUpdate && caseIdToStatusCstMap.containsKey(c.Id+oldMap.get(c.id).Status)){
                    caseTran = CaseStateTransitionHelper.AddTransition(
                        c.id, 
                        oldMap.get(c.id).Status, 
                        c.Status, 
                        caseIdToStatusCstMap.get(c.Id+oldMap.get(c.id).Status).To_Date_Stamp__c,
                        caseIdToStatusPreviousCstMap.get(c.Id+oldMap.get(c.id).Status), 
                        allSettings
                    );
                }else{
                    caseTran = CaseStateTransitionHelper.AddTransition(
                        c.id, 
                        CXE_Constants.CASESTATETRANSITIONHELPER_CREATE, 
                        c.Status, 
                        dateToday, 
                        null, 
                        allSettings
                    );
                }
                dataToBeInserted.add(caseTran);
                CaseStateTransitionHelper.processedCaseIds.add(c.Id); //CSM-14296 11.07.2017
            }
            
            if(dataToBeInserted.size() > 0) 
            {
                List <Case_State_Transition__c> dataToBeUpdated = new List <Case_State_Transition__c>();
                
                //START CSM-7230 GGrandea JUL-5-17      method/code optimization; remove SOQL within for-loop
                Set<String> mediatorRefTrans = new Set<String>();
                for(Case_State_Transition__c rec : dataToBeInserted){
                    if (rec.Mediator_Reference_Trans_ID__c != null){
                        mediatorRefTrans.add(rec.Mediator_Reference_Trans_ID__c);
                    }
                }
                if(mediatorRefTrans.size()>0){
                    for(Case_State_Transition__c caseTr : CaseStateTransitionHelper.getCaseTransitionsByName(mediatorRefTrans)){
                        caseTr.Mediator_Used__c = TRUE;
                        dataToBeUpdated.add(caseTr);
                    }
                }
                //END CSM-7230 
                
                insert dataToBeInserted;
                if(dataToBeUpdated.size() > 0) 
                {
                    update dataToBeUpdated;
                }
            }
        }
        
        
        //START CSM-7230 code review items
        //This is to avoid duplicate dml call
        /*if (!Test.isRunningTest())
        {
            TriggerDispatcher.isRecursion = false;
        }*/
        //END CSM-7230
    }

/* 
 * Description: Trigger from Click
 * Parameters: Case Mapping 
 * Returns: Return type
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-10-17
*/     
    public void updateDepositAmount(List<Case> newCaseList, Map<ID, Case> oldCaseList, Boolean isUpdate)
    {
        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String profileName = profile[0].Name;
        
        // bring all schedules
        List<Schedule__c> allSchedules = [select id, Name , Non_Residential_Rate__c , Residential_Rate__c, Schedule_Selector__c  
                                            from Schedule__c ];
        
        for (Case c : newCaseList)
        {
            /* Old condition from click
            // Customer Community, Service Application (Admin), Customer Community Record Type, Service Application
            if(c.RecordTypeId == commRecTypeId || c.RecordTypeId == adminRecTypeId || c.RecordTypeId == custRecTypeId || c.RecordTypeId == servRecTypeId)
            */
            // check record type for before operation
            // Record type should be on of the following
            // Check if the record type is New Service Application, Modification of Electic Service and Recontract of Electric Service
            //Start CSM-7151 Von Pernicia: Added Recontract of Electic Service condition
            //if(c.RecordTypeId == newServRecTypeId || c.RecordTypeId == modifyRecTypeId)  //Start/End CSM-3768/CSM-3769 Von Pernicia: Added Modification of Electic Service condition
            if(c.RecordTypeId == newServRecTypeId || c.RecordTypeId == modifyRecTypeId || c.RecordTypeId == recontractRecTypeId) 
            //End CSM-7151 Von Pernicia: Added Recontract of Electic Service condition
            {
                // Start CSM-12246 Von Pernicia
                // Start CSM-12256 Von Pernicia: Added isRetrieveService, isClickOutstandingAmount
                if (isUpdate)
                {
                    System.debug('=================== update');
                    ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(c,allSchedules, oldCaseList.get(c.id), isUpdate, profileName, isClickUpdateBD, isRetrieveService, isClickOutstandingAmount);  
                    System.debug('Update Sched Deposit Step 1');
                }
                else
                {
                    System.debug('=================== insert');
                    ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(c,allSchedules, null, isUpdate, profileName, isClickUpdateBD, isRetrieveService, isClickOutstandingAmount);   
                    System.debug('Update Sched Deposit Step 2');
                }
                // End CSM-12256 Von Pernicia: Added isRetrieveService, isClickOutstandingAmount
                // End CSM-12246 Von Pernicia
                
            }
        }
        System.debug('=================== end case');
    }   
 
/* 
 * Description: Trigger from Click
 * Parameters: Case Mapping 
 * Returns: Return type
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-10-17
*/     
public void caseAssignment(Map<Id, Case> newCaseMappings)    {   
    //Variable decleration
    List<Case> caseList = new List<Case>();
    User integrationUserObj = new User();

    // Apply the criteria only to certain record types 
    Id emailRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('SCS Email Case').getRecordTypeId();
    Id socialRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('SCS Social Media Case').getRecordTypeId();
    
    //if(Trigger.isAfter && Trigger.isInsert) {
    //Fetching the integration user details
    integrationUserObj = [SELECT Id, Name FROM User where Name =: CXE_Constants.SF_USER_SCC_ADMIN LIMIT 1];
       
    for (Case caseObj : newCaseMappings.values()) 
    {
        if (caseObj.RecordTypeId == emailRecTypeId || caseObj.RecordTypeId == socialRecTypeId) {
            if (caseObj.OwnerId  == integrationUserObj.Id) {
                caseList.add(new Case(id = caseObj.id));
            }
        }
    }
    if (caseList.size() > 0) {
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;
        Database.update(caseList, dmo);
    }
    //}
}
/* 
 * Description: Trigger from Click
 * Parameters: Case Mapping 
 * Returns: Return type
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-10-17
*/    
 /*   public void validateCaseStatusChanges(Map<Id, Case> newCaseMappings, Map<Id, Case> oldCaseMappings)
    {
        List<Banned_Case_State_Transition__mdt> allCaseStatusSettings = [select from_state__c,to_state__C
                                                                from Banned_Case_State_Transition__mdt ];
        
        for(case c :newCaseMappings.values())
        {
            // Record type should be on of the following
            // Customer Community, Service Application (Admin), Customer Community Record Type, Service Application
            if(c.RecordTypeId == commRecTypeId || c.RecordTypeId == adminRecTypeId || c.RecordTypeId == custRecTypeId || c.RecordTypeId == servRecTypeId) {
                string toState = c.status;
                string fromState = oldCaseMappings.get(c.id).status;
                
                for(Banned_Case_State_Transition__mdt setting :allCaseStatusSettings){
                    if (setting.From_state__c == fromState &&
                        setting.To_State__c == toState){
                            
                            String placeholder = 'You can not change service application from {0} status to {1} status';
                            List<String> fillers = new String[]{fromState,toState};
                            c.addError(String.format(placeholder, fillers));
                            break;
                        }
                }
            }
        }
        
    }
*/
/* 
 * Description: Transformation Picklist Code and Description
 * Parameters: Case Mapping 
 * Returns: N/A
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-24-17
*/  
//Begin CSM-973: Von Pernicia Feb-24-17
    public void picklistTransformation (Map<Id, Case> newCaseMappings, Map<Id, Case> oldCaseMappings, List<Case> newCaseList, Boolean isUpdate)
    {   
         
        List<List<String>> arrayList = CXE_Constants.CASE_PICKLIST_ARRAY;
        
        //CSM-12509 START JEROME TO   SEP-11-2017
        //Map<String, String> mapPicklistCode = CXE_Utility.picklistTransformationCode(arrayList);
        //Map<String, String> mapPicklistDesc = CXE_Utility.picklistTransformationDesc(arrayList);

        Map<String, String> mapPicklistCode = picklistCodeMapping;
        Map<String, String> mapPicklistDesc = picklistDescMapping;
        //CSM-12509 END JEROME TO   SEP-11-2017

        Map<String, Id> mapPSICid = new Map<String, Id>();
        Map<Id, String> mapPSICCode = new Map<Id, String>();
        
        Map<Integer, String> mapBillingClassDesc = new Map<Integer, String>();
        Map<String, Integer> mapBillingClassCode = new Map<String, Integer>();
        
        CXE_Utility utilClass = new CXE_Utility();
        
        for (PSIC__c psic: [Select Id, PSIC_Code__c
                    from PSIC__c])
        {
            mapPSICid.put(psic.PSIC_Code__c, psic.Id);
            mapPSICCode.put(psic.Id, psic.PSIC_Code__c);
        }
        
        for (Reference__c r: [Select Name_Code__c, Name from Reference__c where Field__c=: CXE_Constants.BILLING_CLASS])
        {
            mapBillingClassDesc.put(Integer.valueOf(r.Name_Code__c), r.Name);
            mapBillingClassCode.put(r.Name, Integer.valueOf(r.Name_Code__c));
        }
        
        if (!isUpdate)
        {
            utilClass.picklistTransformationInsert(newCaseList, arrayList, mapPicklistCode, mapPicklistDesc);
            
            for (Case c: newCaseList)
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
            utilClass.picklistTransformationUpdate(newCaseMappings, oldCaseMappings, arrayList, mapPicklistCode, mapPicklistDesc);
            
            
            for (Case c: newCaseMappings.values())
            {
                // Start: Populate PSIC Code or PSIC lookup
                if (c.Code_PSIC__c != oldCaseMappings.get(c.id).Code_PSIC__c)
                {
                    c.PSIC__c = mapPSICid.get(c.Code_PSIC__c);
                }
                
                if (c.PSIC__c != oldCaseMappings.get(c.id).PSIC__c)
                {
                    c.Code_PSIC__c = mapPSICCode.get(c.PSIC__c);
                }
                // End: Populate PSIC Code or PSIC lookup
                
                // Start: Populate Billing Class Code or Billing Class Picklist
                if (c.Code_Billing_Class__c != oldCaseMappings.get(c.id).Code_Billing_Class__c)
                {
                    c.Billing_Class__c = mapBillingClassDesc.get(Integer.valueOf(c.Code_Billing_Class__c));
                }
                
                if (c.Billing_Class__c != oldCaseMappings.get(c.id).Billing_Class__c)
                {
                    c.Code_Billing_Class__c = mapBillingClassCode.get(c.Billing_Class__c);
                }
                // End: Populate Billing Class Code or Billing Class Picklist
            }
        }
    }  
//End CSM-973: Von Pernicia Feb-24-17


/* 
 * Description: Requires Cases with Application Validated status to have Service Address
 * Parameters:  
 * Returns: N/A
 * Author: Jerome To
 * Date Created: MAR-11-17  
 * MAR-14-17 - Jerome To    - CSM-1340
 *              For single-meter applications:
 *              > Service Address should be required before flipping the Case status to Application Validated
 *              > Billing Address should be required before flipping the Case status to Application Evaluated
* JUL-04-17   Jerome To    - CSM-7230
*              - Added oldMap param, filter if status is changed
*/
    private void validateCaseStatuses(List<Case> caseList, Map<Id, Case> oldMap) {
    Set<Id> caseIds = new Set<Id>();
    Set<Id> casesWithServiceAddress = new Set<Id>();    
    Set<Id> casesWithBusinessAddress = new Set<Id>();

    for(Case caseRecord : caseList) {
    //START RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application
    //START RReyes CSM-7139 JUN-22-17 - added validation for recontract cases as well
            if(!caseRecord.Multimetering__c && 
               caseRecord.Status != oldMap.get(caseRecord.Id).Status &&
               (caseRecord.Status == CXE_Constants.CASE_STATUS_APPLICATION_VALIDATED 
                                            || caseRecord.Status == CXE_Constants.CASE_APPLICATION_EVALUATED) 
                                            && (caseRecord.RecordTypeId == newServRecTypeId || caseRecord.RecordTypeId == recontractRecTypeId)) { 
            caseIds.add(caseRecord.Id);
        } 
    //END RReyes CSM-7139 JUN-22-17 - added validation for recontract cases as well
    //END RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application   
    }

    if(!caseIds.isEmpty()) {
        for(Address__c serviceAddress : [SELECT Id, Case__c , Type__c
                                         FROM Address__c 
                                         WHERE Case__c =:caseIds 
                                         AND (Type__c = :CXE_Constants.ADDRESS_TYPE_SERVICE
                                              OR Type__c = :CXE_Constants.ADDRESS_TYPE_BILLING)]) {
            if(serviceAddress.Type__c == CXE_Constants.ADDRESS_TYPE_SERVICE) {
                casesWithServiceAddress.add(serviceAddress.Case__c);
            } else if(serviceAddress.Type__c == CXE_Constants.ADDRESS_TYPE_BILLING){
                casesWithBusinessAddress.add(serviceAddress.Case__c);
            }            
        }

        for(Case caseRec : caseList) {
    //START RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application
    //START RReyes CSM-7139 JUN-22-17 - added validation for recontract cases as well
            if(!caseRec.Multimetering__c && (caseRec.RecordTypeId == newServRecTypeId || caseRec.RecordTypeId == recontractRecTypeId)) {
    //END RReyes CSM-7139 JUN-22-17 - added validation for recontract cases as well
    //END RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application
                //BEGIN Michael Lasala MAR-23-17
                //Validate billing address as well on application validated
                if(caseRec.Status == CXE_Constants.CASE_STATUS_APPLICATION_VALIDATED
                    && (!casesWithServiceAddress.contains(caseRec.Id) || 
                        !casesWithBusinessAddress.contains(caseRec.Id))) {
                    caseRec.addError(CXE_Constants.UPDATE_CASE_STATUS_ERROR_MESSAGE_APPLICATION_VALIDATED);
                }
                //if(caseRec.Status == CXE_Constants.CASE_APPLICATION_EVALUATED
                //    && !casesWithBusinessAddress.contains(caseRec.Id)) {
                //    caseRec.addError(CXE_Constants.UPDATE_CASE_STATUS_ERROR_MESSAGE_APPLICATION_EVALUATED);
                //}
                //END Michael Lasala MAR-23-17
            }                    
        }
    }
} 

   
    /* Description: Validate responsible office based on initial responsible office
     * Parameters: Map<Id, Case> old values, Map<Id, Case> new values
     * Returns: Void
     * Author: Michael Lasala
     * Date Created: MAR-13-17
     */
    // Start CSM-2139 Von Pernicia May-05-2017: Commented out to populate RO w/o IRO for Web2Case
    /*public void validateResponsibleOffice(Map<Id, Case> oldMap, Map<Id, Case> newMap){
        
        Map<Id, Id> caseResponsibleOfficeMap = new Map<Id, Id>();
        
        for(Id i: newMap.keySet()){
            
            //Only process if prior value is null
            if(String.isBlank(oldMap.get(i).Responsible_Office_Lookup__c) && 
               !String.isBlank(newMap.get(i).Responsible_Office_Lookup__c)){
                
                //Validate if initial responsible office is not null
                if(!String.isBlank(oldMap.get(i).Initial_Responsible_Office__c)){

                    //Create map for identifying office name
                    caseResponsibleOfficeMap.put(i, newMap.get(i).Responsible_Office_Lookup__c);
                } else {

                    //Only validate for web2case because walkin is auto populated
                    if(newMap.get(i).Origin == CXE_Constants.RECORD_TYPE_NAME_OFFICE_WEB){
                        //Display error
                        newMap.get(i).Responsible_Office_Lookup__c.addError(CXE_Constants.CASE_ERROR_MESSAGE_NO_INITIAL_RESPONSIBLE_OFFICE);
                    }
                }
            }
        }
        
        if(!caseResponsibleOfficeMap.values().isEmpty()){
            
            //Retrieve office
            Map<Id, Office__c> officeMap = new Map<Id, Office__c>([SELECT Name FROM Office__c WHERE Id IN: caseResponsibleOfficeMap.values()]);
            System.debug('$$$: '+officeMap);
            
            if(!officeMap.keySet().isEmpty()){
                
                for(Case c: newMap.values()){
                    
                    //Validate if initial responsible office contains selected office name
                    if(!c.Initial_Responsible_Office__c.contains(officeMap.get(caseResponsibleOfficeMap.get(c.Id)).Name)){
                        
                        //Display error
                        c.Responsible_Office_Lookup__c.addError(CXE_Constants.CASE_ERROR_MESSAGE_INVALID_RESPONSIBLE_OFFICE);
                    }
                }
            }
        }
    }
    */
    // End CSM-2139 Von Pernicia May-05-2017: Commented out to populate RO w/o IRO for Web2Case
 /* 
 * Description: Approval Process
 * Parameters: N/A
 * Returns: List of User
 * Author: Jerson Poblete (Accenture)
 * Date Created: MAR-10-17
*/ 
    //get the list of approvers
 /*   public static List<User> getglsApproverUserId()
    {
        list<UserRole> ur1 = new List<UserRole>();
        list<UserRole> ur = new List<UserRole>();
        Id roleId;
        Id userId = UserInfo.getUserId();
        Map<String, String> roleApproverMap = new Map<String, String>();
        roleId = [select UserRoleId from User where Id = :userId].UserRoleId;
        
        //Id g4Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR].Id;
        Id g4Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G4].Id;
        Id g5Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G5].Id;
        //check if the profile is meralco g4
        if(UserInfo.getProfileId() == g4Id)
        { 
            ur = [select Id, ParentRoleId, Name from UserRole WHERE Id = :roleId];
        }
        //check if the profile is meralgo g5
        else if(UserInfo.getProfileId() == g5Id)
        { 
            ur1 = [select Id, ParentRoleId, Name from UserRole WHERE Id = :roleId];
            ur = [select Id, ParentRoleId, Name from UserRole WHERE Id = :ur1[0].ParentRoleId];
        }
    
        for(UserRole rs :ur) 
        {
            if(rs.parentroleid != null){
             roleApproverMap.put(string.valueof(rs.Id),string.valueof(rs.ParentRoleId));
            }
        }
        system.debug('roleApproverMap>>>>>>>>' + roleApproverMap);
        List<User> userIdList = [Select Id, Name From User where UserRoleId IN :roleApproverMap.values()];
        system.debug('userId List' + userIdList);
        return userIdList;
    }
    public static void submitApprovalProcess(Map<Id, Case> caseMap , Map<Id, Case> oldCaseMap)
    {   
        List<User> approverList = getglsApproverUserId();
        system.debug('getglsApproverUserId>>>>' + approverList);
        for(Case ur : caseMap.values()) 
            {   
                Case oldCase = oldCaseMap.values();
                if(ur.In_Approval__c != oldCase.In_Approval__c && ur.In_Approval__c ){
                    if(!approverList.isEmpty()){
                        Id approver = approverList[0].id;
                        approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setComments('Submitting request for approval');
                        req1.setObjectId(ur.Id);           
                        req1.setNextApproverIds(new Id[] {approver});
                        approval.ProcessResult result = Approval.process(req1);
                        Approval.unlock(ur.Id);
                    }
                }
            }
    }
*/
    /* Description: Automatically flip case status to Application Evaluated if the 
     *              previous status is Pre-survey FO Resolved-Feasible 
     *              and all of the required fields are populated.
     * Parameters: List<Case> newList, Map<Id, Case> old values
     * Returns: Void
     * Author: Jerome To
     * Date Created: MAR-18-17 CSM - 1878
     *               MAR-22-17 CSM - 1963 - Added condition for Applied Load that requires Bill Deposit Schedule
     */
    public void updateToApplicationEvaluated(List<Case> newList){
        for(Case caseRec : newList) {
    //START/END RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application
    //START CSM-12251 RReyes AUG-11-17 - Added CXE_isClickBillDepositButton__c in the criteria
            if(caseRec.RecordTypeId == newServRecTypeId && caseRec.Status == CXE_Constants.CASE_PRE_SURVEY_FO_FEASIBLE && caseRec.PSIC__c != null 
               && caseRec.Responsible_Office_Lookup__c != null && String.isNotBlank(caseRec.Billing_Class__c)
               && String.isNotBlank(caseRec.Customer_Type__c) && String.isNotBlank(String.valueOf(caseRec.Applied_Load__c))
               && String.isNotBlank(caseRec.Phase__c) && String.isNotBlank(caseRec.Voltage__c)
               && String.isNotBlank(caseRec.Application_Type_Subtype__c) && String.isNotBlank(String.valueOf(caseRec.Demand_Factor__c))
               && String.isNotBlank(String.valueOf(caseRec.Load_Factor__c)) && String.isNotBlank(String.valueOf(caseRec.Contracted_Capacity__c))
               && String.isNotBlank(caseRec.Service_Supply_Type__c) && String.isNotBlank(caseRec.Project_Type__c)
               && String.isNotBlank(caseRec.Service_Rate_Type__c) && String.isNotBlank(String.valueOf(caseRec.Deposit_Amount__c))
               && ((caseRec.Applied_Load__c <= 5 && caseRec.Bill_Deposit_Schedule__c != null) || 
                     (caseRec.Applied_Load__c > 5)) && !caseRec.CXE_isClickBillDepositButton__c) {
                caseRec.Status = CXE_Constants.CASE_APPLICATION_EVALUATED;
                caseRec.Application_Evaluated_Date__c = Date.today();
                caseRec.CXE_StatusPath__c = 'Inspect'; //START/END CSM-6704 RReyes JUN-20-17 
            }
        }
    //END CSM-12251 RReyes AUG-11-17 - Added CXE_isClickBillDepositButton__c in the criteria
    }

    /* Description: Populate Case Responsible Office on create for CBZ and Biz users (CSM-161)
     * Parameters: List<Case>
     * Returns: Void
     * Author: Michael Lasala
     * Date Created: MAR-21-17
     * Updated: JUN-01-17       JEROME TO       Added recordType to filter (CSM-3803, CSM-3755)
     */
    public void populateCaseResponsibleOffice(List<Case> caseList){

        //Retrieve user details
        List<User> userList = [SELECT Id, 
                                      Office__c, 
                                      UserRole.Name
                               FROM   User 
                               WHERE  Id =: UserInfo.getUserId()
                               AND    UserRoleId != null LIMIT 1];

        if(!userList.isEmpty()){
            Set<Id> recordTypeIds = new Set<Id>{ caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_MODIFICATION_OF_ELECTRIC_SERVICE),
                                                 caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_TERMINATION_OF_ELECTRIC_SERVICE),
                                                 caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_RECONTRACT_OF_ELECTRIC_SERVICE),
                                                 caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_NEW_SERVICE_APPLICATION) };
            User currentUser = userList.get(0);

            //Identify whether current user is under cbg or biz
            if(currentUser.UserRole.Name.contains(CXE_Constants.ROLE_PREFIX_CBG) || 
               currentUser.UserRole.Name.contains(CXE_Constants.ROLE_PREFIX_BIZ)){

                //Get current user's office
                   // CSM-7230 - Code Review Comments for CaseTrigger Jerome To JUL-05-17 - Added Business_Unit__c
                   List<Office__c> officeList = [SELECT Id, Name, Business_Unit__c FROM Office__c WHERE Name =: currentUser.Office__c LIMIT 1];

                if(!officeList.isEmpty()){

                    for(Case c: caseList){
            //START RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application
            if(recordTypeIds.contains(c.RecordTypeId)){
                //Define field values
                c.Initial_Responsible_Office__c = officeList.get(0).Name;
                c.Responsible_Office_Lookup__c = officeList.get(0).Id;
            }
            //END RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application
                    }
                }
            }
        }
    }

    /* Description: Populate Case fields when reusing existing Account and Contact (CSM-1921/1974/1975)
     * Parameters: List<Case>
     * Returns: Void
     * Author: Michael Lasala
     * Date Created: MAR-23-17
     */
    public void populateCaseAccountContactDetails(List<Case> caseList){
        
        Set<Id> accountIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
    //START RReyes CSM-2768 05-24-17 - moved variable declaration
    Map<Id, Account> accountMap = new Map<Id, Account>();
    Map<Id, Contact> contactMap = new Map<Id, Contact>();
    //END RReyes CSM-2768 05-24-17 - moved variable declaration
        
    //START RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application
    //START RReyes CSM-7140 JUN-22-17 - added filtering of recordType to recontract as well
        for(Case c: caseList){
            if(c.RecordTypeId == newServRecTypeId || c.RecordTypeId == recontractRecTypeId){
                if(!String.isBlank(c.AccountId)){
                    accountIds.add(c.AccountId);
                }

                if(!String.isBlank(c.ContactId)){
                    contactIds.add(c.ContactId);
                }
            }
        }
    //END RReyes CSM-7140 JUN-22-17 - added filtering of recordType to recontract as well
    //END RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application
        
    //START RReyes CSM-2768 05-24-17 - added filtering if accountId or contractId is not empty
        //Retrieve Account details related to Case
    if(!accountIds.isEmpty()){
        accountMap = new Map<Id, Account>([SELECT Id, 
                                                   Name, 
                                                   Doing_Business_As__c, 
                                                   Tax_Identification_No__c, 
                                                   Customer_Type__c, 
                                                   Conglomerate__c, 
                                                   Phone, 
                                                   Salutation, 
                                                   FirstName, 
                                                   MiddleName, 
                                                   LastName, 
                                                   PersonMobilePhone, 
                                                   PersonEmail, 
                                                   PersonBirthdate, 
                                                   isPersonAccount
                                                   //START CSM-11451 RReyes - JUL-17-17
                                                   ,PersonHomePhone,
                                                   Mobile_1__pc
                                                   //END CSM-11451 RReyes - JUL-17-17
                                            FROM   Account 
                                            WHERE  Id IN: accountIds]);
    }
        //Retrieve Contact details related to Case
    if(!contactIds.isEmpty()){
        contactMap = new Map<Id, Contact>([SELECT Id, 
                                                   Name, 
                                                   Salutation, 
                                                   FirstName, 
                                                   MiddleName, 
                                                   LastName, 
                                                   Phone, 
                                                   MobilePhone, 
                                                   Email, 
                                                   Birthdate
                                            FROM   Contact 
                                            WHERE  Id IN: contactIds]);
    }
    //END RReyes CSM-2768 05-24-17 - added filtering if accountId or contractId is not empty
        
        for(Case c: caseList){
        //START RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application 
        //START RReyes CSM-7140 JUN-22-17 - added filtering of recordType to recontract as well
        if(c.RecordTypeId == newServRecTypeId || c.RecordTypeId == recontractRecTypeId){
            if(!String.isBlank(c.AccountId) && 
               !accountMap.values().isEmpty()){

                Account acc = accountMap.get(c.AccountId);
                    
                //Populate Case fields based on Account details
                if(!String.isBlank(acc.Customer_Type__c)){
                    c.Customer_Type__c = acc.Customer_Type__c;
                }
                if(!String.isBlank(acc.Tax_Identification_No__c)){
                    c.Tax_Identification_No__c = acc.Tax_Identification_No__c;
                }

                if(acc.isPersonAccount){    //For individual accounts
                        
                    if(!String.isBlank(acc.Name)){
                        c.Full_Name__c = acc.Name;
                    }
                    if(!String.isBlank(acc.Salutation)){
                        c.Salutation__c = acc.Salutation;
                    }
                    if(!String.isBlank(acc.FirstName)){
                        c.First_Name__c = acc.FirstName;
                    }
                    if(!String.isBlank(acc.MiddleName)){
                        c.Middle_Name__c = acc.MiddleName;
                    }
                    if(!String.isBlank(acc.LastName)){
                        c.Last_Name__c = acc.LastName;
                    }
                    //START CSM-12155 Von Pernicia AUG-22-17
                    if (!isRetrieveService)
                    {
                        //START CSM-11451 RReyes - JUL-17-17 - changed from Phone > PersonHomePhone, PersonMobilePhone > Mobile_1__pc
                        if(!String.isBlank(acc.PersonHomePhone)){
                            c.Telephone_No__c = acc.PersonHomePhone;
                        }
                        if(!String.isBlank(acc.Mobile_1__pc)){
                            c.Mobile_No__c = acc.Mobile_1__pc;  
                        }
                        //END CSM-11451 RReyes - JUL-17-17 - changed from Phone > PersonHomePhone, PersonMobilePhone > Mobile_1__pc
                        if(!String.isBlank(acc.PersonEmail)){
                            c.Email_Address__c = acc.PersonEmail;
                        }
                    }
                    //END CSM-12155 Von Pernicia AUG-22-17
                    if(acc.PersonBirthdate != null){
                        c.Date_of_Birth__c = acc.PersonBirthdate;
                    }
                } else {    //For business accounts

                    if(!String.isBlank(acc.Name)){
                        c.Last_Name_Business_Name__c = acc.Name;
                    }
                    if(!String.isBlank(acc.Doing_Business_As__c)){
                        c.Doing_Business_As__c = acc.Doing_Business_As__c;
                    }
                    c.Conglomerate_Tag__c = acc.Conglomerate__c;
                }
            }

            if(!String.isBlank(c.ContactId) && 
               !contactMap.values().isEmpty()){

                Contact con = contactMap.get(c.ContactId);
                    
                //Populate Case fields based on Contact details
                if(!String.isBlank(con.Name)){
                    c.Full_Name__c = con.Name;
                }
                if(!String.isBlank(con.Salutation)){
                    c.Salutation__c = con.Salutation;
                }
                if(!String.isBlank(con.FirstName)){
                    c.First_Name__c = con.FirstName;
                }
                if(!String.isBlank(con.MiddleName)){
                    c.Middle_Name__c = con.MiddleName;
                }
                if(!String.isBlank(con.LastName)){
                    c.Last_Name__c = con.LastName;
                }
                //START CSM-12155 Von Pernicia AUG-22-17
                if (!isRetrieveService)
                {
                    if(!String.isBlank(con.Phone)){
                        c.Telephone_No__c = con.Phone;
                    }
                    if(!String.isBlank(con.MobilePhone)){
                        c.Mobile_No__c = con.MobilePhone;
                    }
                    if(!String.isBlank(con.Email)){
                        c.Email_Address__c = con.Email;
                    }
                }
                //END CSM-12155 Von Pernicia AUG-22-17
                if(con.Birthdate != null){
                    c.Date_of_Birth__c = con.Birthdate;
                }
            }
        }
        //END RReyes CSM-7140 JUN-22-17 - added filtering of recordType to recontract as well
        //END RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application   
        }
    }

    /* Description: Populate Load and Demand factor if PSIC is not NULL
     * Parameters: List<Case>
     * Returns: Void
     * Author: Jerome To - CSM-2001
     * Date Created: MAR-27-17
     */
    //START CSM-7171 RReyes JUN-23-17 - added filtering of recordType to recontract and modify as well 
    private void populateLoadAndDemandFactor(List<Case> caseList, Map<Id, Case> oldCaseMap, Boolean isUpdate){
        Set<Id> psicIds = new Set<Id>();
        String serviceRequests = '';
        
        //Start CSM-11428 Von Pernicia JUL-12-17
        if (!isRetrieveService)
        {
            for(Case caseRecord : caseList){
                 if(caseRecord.CXE_Service_Request_s__c != null){
                    serviceRequests = String.valueOf(caseRecord.CXE_Service_Request_s__c);
                }else{
                    serviceRequests = '';   
                }
                //START RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application  
                if(caseRecord.RecordTypeId == newServRecTypeId || caseRecord.RecordTypeId == recontractRecTypeId 
                || (caseRecord.RecordTypeId == modifyRecTypeId && (serviceRequests.contains(CXE_Constants.SERVICE_REQ_ADDITIONAL_LOAD) || serviceRequests.contains(CXE_Constants.SERVICE_REQ_REDUCTION_LOAD)))){
                    if(caseRecord.PSIC__c != null) {
                        if(isUpdate){
                            if(oldCaseMap.containsKey(caseRecord.Id)){
                                if(caseRecord.PSIC__c != oldCaseMap.get(caseRecord.Id).PSIC__c){
                                    psicIds.add(caseRecord.PSIC__c);
                                }
                            }
                        }else{
                            psicIds.add(caseRecord.PSIC__c);
                        }
                    } else {
                        caseRecord.Load_Factor__c = null;
                        caseRecord.Demand_Factor__c = null;
                    }
                }
                //END RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application  
            }

            if(!psicIds.isEmpty()) {
                Map<Id, PSIC__c> psicMap = new Map<Id, PSIC__c>([SELECT Demand_Factor__c, Load_Factor__c FROM PSIC__c WHERE Id IN:psicIds]);
                for(Case caseRecord : caseList) {
                    if(caseRecord.PSIC__c != null && psicMap.containsKey(caseRecord.PSIC__c)) {
                        PSIC__c psicRecord = psicMap.get(caseRecord.PSIC__c);
                        //if (caseRecord.Load_Factor__c == null) {
                            caseRecord.Load_Factor__c = psicRecord.Load_Factor__c;
                        //}
                        //if (caseRecord.Demand_Factor__c == null){    
                            caseRecord.Demand_Factor__c = psicRecord.Demand_Factor__c;
                        //}    
                    }
                }
            }
        }
        //End CSM-11428 Von Pernicia JUL-12-17
    }
    //END CSM-7171 RReyes JUN-23-17 - added filtering of recordType to recontract and modify as well 

    /* Description: Populate Contracted Capacity
     * Parameters: List<Case>
     * Returns: Void
     * Author: Jerome To - CSM-2001
     * Date Created: MAR-27-17
*               JUL-05-17 JEROME TO CSM-7230 Added checking if PSIC has changed
     */
    //START CSM-7162 RReyes JUN-23-17 - added filtering of recordType to recontract and modify as well  
    private void populateContractedCapacity(List<Case> caseList, Map<Id, Case> oldMap){
        String serviceRequests = '';
        
        //Start CSM-11428 Von Pernicia JUL-15-17
        if (!isRetrieveService)
        {
            for(Case caseRecord : caseList) {
                if(caseRecord.CXE_Service_Request_s__c != null){
                    serviceRequests = String.valueOf(caseRecord.CXE_Service_Request_s__c);
                }else{
                    serviceRequests = '';   
                }
                //START RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application  
                if(caseRecord.RecordTypeId == newServRecTypeId 
                || caseRecord.RecordTypeId == recontractRecTypeId 
                || (caseRecord.RecordTypeId == modifyRecTypeId && (serviceRequests.contains(CXE_Constants.SERVICE_REQ_ADDITIONAL_LOAD) || serviceRequests.contains(CXE_Constants.SERVICE_REQ_REDUCTION_LOAD)))){
                    // START CSM-7230 Jerome to Added checking if PSIC has changes JUL-05-17 | RReyes JUL-06-17 - added checking if Applied Load is Changed
                    if((caseRecord.PSIC__c != null && (oldMap == null || caseRecord.PSIC__c !=  oldMap.get(caseRecord.Id).PSIC__c))
                        || (caseRecord.Applied_Load__c != null && (oldMap == null || caseRecord.Applied_Load__c !=  oldMap.get(caseRecord.Id).Applied_Load__c))
                    // Start CSM-12216 Von Pernicia AUG-07-17
                        || (caseRecord.Demand_Factor__c != null && (oldMap == null || caseRecord.Demand_Factor__c !=  oldMap.get(caseRecord.Id).Demand_Factor__c))) { 
                    // End CSM-12216 Von Pernicia AUG-07-17
                    // END CSM-7230 Jerome to Added checking if PSIC has changes JUL-05-17 | RReyes JUL-06-17 - added checking if Applied Load is Changed
                        if(caseRecord.Applied_Load__c != null && caseRecord.Demand_Factor__c != null) {
                            caseRecord.Contracted_Capacity__c = caseRecord.Applied_Load__c * caseRecord.Demand_Factor__c;
                            //START CSM-11925 RReyes JUL-23-17 - round off contracted capacity to 3 decimal places
                            if(caseRecord.Contracted_Capacity__c != null){
                                caseRecord.Contracted_Capacity__c = caseRecord.Contracted_Capacity__c.setScale(3);
                            }
                            //END CSM-11925 RReyes JUL-23-17 - round off contracted capacity to 3 decimal places
                        } else {
                            caseRecord.Contracted_Capacity__c = null;
                        }
                    }
                }
                //END RReyes CSM-2768 05-24-17 - added filtering of recordType to new Service Application  
            }
        }
        //End CSM-11428 Von Pernicia JUL-15-17
    }
    //END CSM-7162 RReyes JUN-23-17 - added filtering of recordType to recontract and modify as well

    //START RReyes MAY-26-17 CSM-3838 - modification of service autopopulation
    /* Description: Check if mapping of case is needed for modification of service
     * Parameters: List<Case>, Map<Id,Case>, Boolean
     * Returns: Boolean
     * Author: Rom Edison Reyes - CSM-3838
     * Date Created: MAY-26-17
     */
    private Boolean validateIfMappingIsNeeded(List<Case> newList, Map<Id, Case> oldMap, Boolean isInsert){
        for(Case caseRecord : newList) {
            if(caseRecord.RecordTypeId == modifyRecTypeId || caseRecord.RecordTypeId == terminateRecTypeId || caseRecord.RecordTypeId == recontractRecTypeId){
                if(isInsert){
                    return true;
                }else{
                    if(caseRecord.CXE_Service__c != null){
                        if(oldMap.containsKey(caseRecord.Id)){
                            if(oldMap.get(caseRecord.Id).CXE_Service__c != caseRecord.CXE_Service__c){
                                return true;
                            }
                        }
                    }
                }   
            }
        }
        return false;
    }
    //END RReyes MAY-26-17 CSM-3838 - modification of service autopopulation  
    
    //START RReyes MAY-26-17 CSM-3838 - modification of service autopopulation
    /* Description: Populate case fields based on selected service
     * Parameters: List<Case>
     * Returns: void
     * Author: Rom Edison Reyes - CSM-3838
     * Date Created: MAY-26-17
     */
    private void populateCaseFieldsFromService(List<Case> caseList){

        // Start CSM-12180 Von Pernicia AUG-03-17
        Map<String, String> mapStreetNameId = new Map<String, String>(); 
        Map<String, Office_Jurisdiction__c> mapOfficeJur = new Map<String, Office_Jurisdiction__c>();
        Map<Id, Office_Jurisdiction__c> mapServOfficeJur = new Map<Id, Office_Jurisdiction__c>();
        // End CSM-12180 Von Pernicia AUG-03-17
        Set<Id> serviceIds = new Set<Id>();
        Map<Id, Agreement__c> serviceMap = new Map<ID, Agreement__c>();
        Agreement__c s = new Agreement__c();
        Map<String, String> serviceToAddressMap = new Map<String, String>(); //START/END CSM-6752 RReyes JUN-07-17
        Map<String, String> serviceToLandmarkMap = new Map<String, String>(); //START/END CSM-6977 RReyes JUN-13-17
        
        for(Case caseRecord : caseList) {
            if(caseRecord.RecordTypeId == modifyRecTypeId || caseRecord.RecordTypeId == terminateRecTypeId || caseRecord.RecordTypeId == recontractRecTypeId){
                if(caseRecord.CXE_Service__c != null){
                    serviceIds.add(caseRecord.CXE_Service__c);
                }
            }
        }
        
        if(!serviceIds.isEmpty()){
            isRetrieveService = true; //START/END CSM-12249 Von Pernicia AUG-10-17
            serviceMap = new Map<Id, Agreement__c>([SELECT Id,
                                                            Service_Description__c,
                                                            Applied_Load__c,
                                                            Phase__c,
                                                            PSIC__c,
                                                            Demand_Factor__c,
                                                            Load_Factor__c,
                                                            Contracted_Capacity__c,
                                                            Billing_Class__c,
                                                            Service_Supply_Phase__c,
                                                            Service_Supply_Voltage__c,
                                                            Service_Supply_Type__c,
                                                            Service_Wire_Phase__c,
                                                            Service_Wire_Voltage__c,
                                                            Service_Wire_Type__c,
                                                            Service_Wire_TLN__c,
                                                            Service_Wire_Pole_Number__c,
                                                            Service_Wire_Length__c,
                                                            Service_Wire_Size__c,
                                                            Service_Wire_Material__c,
                                                            Deposit_Amount__c,
                                                            CXE_Discount_Program__c,
                                                            //START CSM-6968 RReyes - JUN-09-17
                                                            Segment__c,
                                                            Rate__c,
                                                            Deposit_Schedule__c,
                                                            Rate_Program__c,
                                                            SIN__c,
                                                            //END CSM-6968 RReyes - JUN-09-17
                                                            Code_Service_Rate_Type__c, // Start/End CSM-12252 Von Pernicia
                                                            Case__r.Target_Energization_Date__c,
                                                            Case__r.Application_for_Residential_Customer__c,
                                                            Case__r.Application_for_Residential_Service__c,
                                                            Case__r.CXE_Same_Customer__c,
                                                            Case__r.AccountId,
                                                            Case__r.Last_Name_Business_Name__c,
                                                            Case__r.Doing_Business_As__c,
                                                            Case__r.ContactId,
                                                            Case__r.Salutation__c,
                                                            Case__r.First_Name__c,
                                                            Case__r.Middle_Name__c,
                                                            Case__r.Last_Name__c,
                                                            Case__r.Date_of_Birth__c,
                                                            Case__r.GSL4_Target_Date__c,
                                                            Case__r.Application_for_Business_Customer__c,
                                                            Case__r.Application_for_Business_Service__c,
                                                            Case__r.Telephone_No__c,
                                                            Case__r.Mobile_No__c,
                                                            Case__r.Email_Address__c,
                                                            Case__r.Preferred_Mode_of_Notification__c,
                                                            Case__r.Customer_Type__c,
                                                            Case__r.Home_Ownership__c,
                                                            Case__r.Conglomerate_Tag__c,
                                                            Case__r.Tax_Identification_No__c,
                                                            Case__r.Authorized_Representative_Last_Name__c,
                                                            Case__r.Authorized_Representative_First_Name__c,
                                                            Case__r.Authorized_Representative_Middle_Name__c,
                                                            Case__r.Relationship__c,
                                                            Case__r.Authorized_Rep_Primary_Contact_Number__c,
                                                            Case__r.Authorized_Representative_Email__c,
                                                            Case__r.Service_Description__c,
                                                            Case__r.Business_Segment__c,
                                                            Case__r.Applied_Load__c,
                                                            Case__r.Phase__c,
                                                            Case__r.Voltage__c,
                                                            Case__r.PSIC__c,
                                                            Case__r.Demand_Factor__c,
                                                            Case__r.Load_Factor__c,
                                                            Case__r.Contracted_Capacity__c,
                                                            Case__r.Service_Rate_Type__c,
                                                            Case__r.Billing_Class__c,
                                                            Case__r.Bill_Deposit_Schedule__c,
                                                            Case__r.Deposit_Amount__c,
                                                            Case__r.Arrears_Tag__c,
                                                            Case__r.CXE_Total_Outstanding_Amount__c,
                                                            Case__r.CXE_Discount_Programs__c,
                                                            Case__r.CXE_Rate_Programs__c,
                                                            Case__r.Energization_FO_No__c,
                                                            Case__r.CXE_Connection_FO_Status__c,
                                                            Case__r.Actual_Energization_Date__c,
                                                            Case__r.Energization_FO_Executing_Office__c,
                                                            Case__r.GSL4__c,
                                                            Case__r.Final_TPA__c,
                                                            Case__r.Final_TCP_del__c,
                                                            Case__r.Final_GSL4__c,
                                                            Case__r.Override_Auto_Deposit_Amount__c,
                                                            Case__r.Reason_for_Manual_Deposit_Input__c,
                                                            Case__r.CXE_Request_GSL4_TargetDate_Modification__c ,
                                                            Case__r.Reason_for_GSL4_Target_Date_Modification__c,
                                                            Case__r.Priority,
                                                            Case__r.Subject,
                                                            Case__r.Description,
                                                            Case__r.CXE_Termination_Date_of_SIN__c,
                                                            Case__r.CXE_Service_Address__c,
                                                            Case__r.Service_Address_Landmarks_Directions__c,
                                                            Case__r.CXE_Contractor_Name__c,
                                                            Case__r.CXE_Interested_in_Other_Payment_Methods__c,
                                                            Case__r.CXE_Enroll_to_Paperless_Billing__c,
                                                            Case__r.CXE_Enroll_to_Paperless_Billing_Status__c,
                                                            Case__r.AMC_Service_Tag__c,
                                                            Case__r.Accredited_Meralco_Contractor__c,
                                                            Case__r.AMC_Service_Package__c,
                                                            Case__r.CXE_Same_Connection_Details__c,
                                                            Case__r.Metering_Scheme__c,
                                                            Case__r.Mode_of_Retrieval__c,
                                                            Case__r.Meter_Socket_Delivery_Tag__c,
                                                            Case__r.Delivery_Address__c,
                                                            Case__r.Bill_Deposit_Status__c,
                                                            Case__r.CXE_Bill_Deposit_Status_Date__c,
                                                            Case__r.CXE_Request_for_Lifting_of_Arrears_Tag__c,
                                                            Case__r.CXE_Reason_for_Lifting_of_Arrears_Tag__c,
                                                            Case__r.CXE_Request_for_Application_Cancellation__c,
                                                            Case__r.CXE_Reason_for_Cancellation__c,
                                                            Case__r.SuppliedEmail,
                                                            Case__r.CXE_Same_Contracted_Service_Details__c,
                                                            Case__r.Un_Satisfaction_Reason__c,
                                                            Case__r.CXE_Termination_Remarks__c,
                                                            Case__r.CXE_Retirement_FO_Number__c,
                                                            Case__r.CXE_Retirement_FO_Remarks__c,
                                                            Case__r.CXE_Actual_Retirement_Date__c,
                                                            Case__r.CXE_Retirement_FO_Executing_Office__c,
                                                            Case__r.Re_Inspection_FO_Resolution_Remarks__c,
                                                            Case__r.With_Existing_Record_in_Meralco__c,
                                                            Account__r.Conglomerate__c,
                                                            Account__r.Doing_Business_As__c,
                                                            Account__r.Email__c,
                                                            Account__r.Salutation,
                                                            Account__r.FirstName,
                                                            Account__r.LastName,
                                                            Account__r.MiddleName,
                                                            Account__r.Mobile_Phone__c,
                                                            Account__r.Name,
                                                            Account__r.PersonBirthdate,
                                                            Account__r.PersonEmail,
                                                            Account__r.PersonMobilePhone,
                                                            Account__r.Phone,
                                                            Account__r.Tax_Identification_No__c,
                                                            Account__r.RecordType.DeveloperName
                                                            ,Account__r.Customer_Type__c //Start/End CSM-12498 9/10/17: Von Pernicia
                                                            //START CSM-11451 RReyes JUL-17-17
                                                            ,Account__r.PersonHomePhone,
                                                            Account__r.Mobile_1__pc
                                                            //END CSM-11451 RReyes JUL-17-17
                                                            //START RReyes - MAY-28-17 CSM - 3755
                                                            ,Case__r.Initial_Responsible_Office__c,
                                                            Case__r.Responsible_Office_Lookup__c,
                                                            //END RReyes - MAY-28-17 CSM - 3755
                                                            // Start CSM-7334 Von Pernicia Change from Service_Termination_Date__c to Agreement_End_Date__c
                                                            // START     JEROME TO     JUN-01-17       CSM-3799
                                                            Agreement_End_Date__c
                                                            // END     JEROME TO     JUN-01-17       CSM-3799
                                                            // End CSM-7334 Von Pernicia Change from Service_Termination_Date__c to Agreement_End_Date__c
                                                            
                                                    FROM Agreement__c 
                                                    WHERE Id IN: serviceIds]);
                                                    
                                                    
                //START CSM-6752 RReyes JUN-07-17
                String servId, barangay, city, province, streetName, streetNo, subdivision, unitNo, addConcat;
                List<Address__c> lstAdd = [SELECT Id, 
                                            Service__c, 
                                            Address_Province__r.Name,  
                                            Address_City_Municipality__r.Name,
                                            Address_Barangay__r.Name, 
                                            Address_Street_Name__r.Name, 
                                            Address_Subdivision__r.Name, 
                                            Address_Unit_No__c, 
                                            Address_Street_No__c,
                                            Landmarks_Directions__c //START/END RReyes CSM-6977 JUN-13-17
                                            FROM Address__c 
                                            WHERE Service__c IN:serviceIds AND Type__c = 'Service'];
                
                for(Address__c address : lstAdd){
                    servId = address.Service__c;
                    if(!serviceToAddressMap.containsKey(servId)){
                        barangay = address.Address_Barangay__r.Name != null ? address.Address_Barangay__r.Name : '';
                        city = address.Address_City_Municipality__r.Name != null ? address.Address_City_Municipality__r.Name : '';
                        province = address.Address_Province__r.Name != null ? address.Address_Province__r.Name : '';
                        streetName = address.Address_Street_Name__r.Name != null ? address.Address_Street_Name__r.Name : '';
                        streetNo = address.Address_Street_No__c != null ? address.Address_Street_No__c : '';
                        subdivision = address.Address_Subdivision__r.Name != null ? address.Address_Subdivision__r.Name : '';
                        unitNo = address.Address_Unit_No__c != null ? address.Address_Unit_No__c : '';
                        addConcat = unitNo + ' ' + streetNo + ' ' + streetName + ' ' +  subdivision + ' ' + barangay + ' ' + city + ' ' + province; //START/END RReyes CSM-6977
                        serviceToAddressMap.put(servId, addConcat);
                        serviceToLandmarkMap.put(servId, address.Landmarks_Directions__c); //START/END CSM-6977 RReyes JUN-13-17
                        mapStreetNameId.put(servId, address.Address_Street_Name__c); // Start/End CSM-12180 Von Pernicia AUG-03-17
                    }
                }
                
                //END CSM-6752 RReyes JUN-07-17
                // Start CSM-12180 Von Pernicia AUG-03-17
                if(!serviceToAddressMap.isEmpty()){

                    for (Office_Jurisdiction__c oj: [SELECT     Office__c,
                                                                Office__r.Name,
                                                                Street_Name__c
                                                     FROM       Office_Jurisdiction__c
                                                     WHERE      Street_Name__c IN: mapStreetNameId.values()])
                    {
                        mapOfficeJur.put(oj.Street_Name__c, oj);
                    }

                    for (String serviceId: mapStreetNameId.keySet())
                    {
                        String streetNameId = mapStreetNameId.get(serviceId);
                        if (!mapOfficeJur.isEmpty())
                        {
                            mapServOfficeJur.put(serviceId, mapOfficeJur.get(streetNameId));
                        }
                    }
                }
                // End CSM-12180 Von Pernicia AUG-03-17
        }
        
        for(Case caseRec : caseList){
            if(caseRec.RecordTypeId == modifyRecTypeId || caseRec.RecordTypeId == terminateRecTypeId || caseRec.RecordTypeId == recontractRecTypeId){
                if(caseRec.CXE_Service__c != null){
                    if(serviceMap.containsKey(caseRec.CXE_Service__c)){
                        s = serviceMap.get(caseRec.CXE_Service__c);
                        if(s != null){
                            //START - Applicable to modify, recontract and terminate
                            //START CSM-6752 RReyes JUN-07-17 - get address from service's related address
                            if(serviceToAddressMap.containsKey(s.Id)){
                                caseRec.CXE_Service_Address_R2__c = serviceToAddressMap.get(s.Id);
                                caseRec.CXE_Service_Address__c = serviceToAddressMap.get(s.Id);//START/END CSM-7209 RReyes - JUN-29-17 - add mapping for FO Service Address
                            }
                            //END CSM-6752 RReyes JUN-07-17 - get address from service's related address
                            //START CSM-6977 RReyes JUN-13-17
                            if(serviceToLandmarkMap.containsKey(s.Id)){
                                caseRec.Billing_Address_Landmarks_Directions__c = serviceToLandmarkMap.get(s.Id);
                                caseRec.Service_Address_Landmarks_Directions__c = serviceToLandmarkMap.get(s.Id);
                            }
                            //END CSM-6977 RReyes JUN-13-17
                            caseRec.CXE_Previous_SIN__c = s.SIN__c; //START/END CSM-6968 RReyes - JUN-09-17
                            
                            // Start CSM-12180 Von Pernicia AUG-03-17
                            if (mapServOfficeJur.containsKey(s.Id))
                            {
                                caseRec.Initial_Responsible_Office__c = mapServOfficeJur.get(s.Id).Office__r.Name;
                                caseRec.Responsible_Office_Lookup__c = mapServOfficeJur.get(s.Id).Office__c;
                            }
                            // End CSM-12180 Von Pernicia AUG-03-17

                            if(s.Case__c != null){
                                //caseRec.CXE_Service_Address_R2__c = s.Case__r.CXE_Service_Address__c; //START/END CSM-6752 Commented-out by RReyes JUN-07-17 
                                //caseRec.Billing_Address_Landmarks_Directions__c = s.Case__r.Service_Address_Landmarks_Directions__c;//START/END CSM-6977 CommentedOut by RReyes JUN-13-17
                                //START CSM-6988 Commented out by RReyes - remove fields being mapped from case
                                /*caseRec.ContactId = s.Case__r.ContactId;
                                caseRec.Preferred_Mode_of_Notification__c = s.Case__r.Preferred_Mode_of_Notification__c;
                                caseRec.Arrears_Tag__c = s.Case__r.Arrears_Tag__c;
                                //caseRec.CXE_Total_Outstanding_Amount__c = s.Case__r.CXE_Total_Outstanding_Amount__c;
                                caseRec.Priority = s.Case__r.Priority;
                                caseRec.Subject = s.Case__r.Subject;
                                caseRec.Description = s.Case__r.Description;
                                caseRec.SuppliedEmail = s.Case__r.SuppliedEmail;
                                //caseRec.CXE_Request_for_Application_Cancellation__c =  s.Case__r.CXE_Request_for_Application_Cancellation__c;
                                //caseRec.CXE_Reason_for_Cancellation__c =  s.Case__r.CXE_Reason_for_Cancellation__c;
                                caseRec.CXE_Connection_FO_Status__c = s.Case__r.CXE_Connection_FO_Status__c;
                                caseRec.CXE_Existing_Bill_Deposit_Amount__c = s.Case__r.Deposit_Amount__c; // Start/End Von Pernicia MAY-30-2017
                                caseRec.Deposit_Amount__c = s.Case__r.Deposit_Amount__c;
                                
                                caseRec.GSL4_Target_Date__c = s.Case__r.GSL4_Target_Date__c;
                                caseRec.Application_for_Business_Customer__c = s.Case__r.Application_for_Business_Customer__c;
                                //caseRec.Business_Segment__c = s.Case__r.Business_Segment__c; //START/END CSM-6968 RReyes - JUN-09-17
                                */ //END CSM-6988 Commented out by RReyes - remove fields being mapped from case
                                //Start CSM-12180 Von Pernicia AUG-03-17: Comment out
                                //caseRec.Initial_Responsible_Office__c = s.Case__r.Initial_Responsible_Office__c;
                                //caseRec.Responsible_Office_Lookup__c = s.Case__r.Responsible_Office_Lookup__c;
                                //End CSM-12180 Von Pernicia AUG-03-17: Comment out

                                //Start CSM-7193 Von Pernicia JUN-29-17 
                                caseRec.Metering_Scheme__c = s.Case__r.Metering_Scheme__c;
                                caseRec.Mode_of_Retrieval__c = s.Case__r.Mode_of_Retrieval__c;
                                //End CSM-7193 Von Pernicia JUN-29-17

                            }
                            //END - Applicable to modify, recontract and terminate
                            
                            if(s.Account__c != null){
                                caseRec.AccountId = s.Account__r.Id;
                                /*
                                Start CSM-12248 Von Pernicia
                                caseRec.Last_Name_Business_Name__c = s.Account__r.Name;
                                caseRec.Doing_Business_As__c = s.Account__r.Doing_Business_As__c;
                                caseRec.Salutation__c = s.Account__r.Salutation;
                                caseRec.First_Name__c = s.Account__r.FirstName;
                                caseRec.Middle_Name__c = s.Account__r.MiddleName;
                                caseRec.Last_Name__c = s.Account__r.LastName;
                                caseRec.Date_of_Birth__c = s.Account__r.PersonBirthDate;
                                //caseRec.Telephone_No__c = s.Account__r.Phone; //START/END CSM-11451 Commented Out by RReyes JUL-17-17
                                End CSM-12248 Von Pernicia
                                */
                                
                                if(s.Account__r.RecordType.DeveloperName == 'CXE_Business_Account'){
                                    //START CSM-12155 RReyes AUG-31-17 - undo comment out
                                    //START CSM-11451 RReyes JUL-17-17
                                    caseRec.Telephone_No__c = s.Account__r.Phone; 
                                    //END CSM-11451 RReyes JUL-17-17
                                    caseRec.Mobile_No__c = s.Account__r.Mobile_Phone__c;
                                    //CSM-12155 Start Von Pernicia AUG-03-17
                                    //END CSM-12155 RReyes AUG-31-17 - undo comment out
                                    caseRec.Email_Address__c = s.Account__r.Email__c;
                                    //START CSM-7189 RReyes JUN-28-17
                                    //Start CSM-12269  Von Pernicia AUG-17-17
                                    caseRec.Application_for_Business_Customer__c = true;
                                    //caseRec.Application_for_Business_Service__c = true;
                                    caseRec.Application_for_Residential_Customer__c = false;
                                    //caseRec.Application_for_Residential_Service__c = false;
                                    //Start CSM-12269  Von Pernicia AUG-17-17
                                    //END CSM-7189 RReyes JUN-28-17

                                    //Start CSM-12248 Von Pernicia
                                    caseRec.Last_Name_Business_Name__c = s.Account__r.Name;
                                    caseRec.Doing_Business_As__c = s.Account__r.Doing_Business_As__c;
                                    //End CSM-12248 Von Pernicia
                                }else if(s.Account__r.RecordType.DeveloperName == 'CXE_Individual_Account'){
                                    //START CSM-12155 RReyes AUG-31-17 - undo comment out
                                    //START CSM-11451 RReyes JUL-17-17
                                    caseRec.Telephone_No__c = s.Account__r.PersonHomePhone;
                                    caseRec.Mobile_No__c = s.Account__r.Mobile_1__pc;
                                    //END CSM-11451 RReyes JUL-17-17
                                    //END CSM-12155 RReyes AUG-31-17 - undo comment out
                                    caseRec.Email_Address__c = s.Account__r.PersonEmail;
                                    //START CSM-7189 RReyes JUN-28-17
                                    //Start CSM-12269  Von Pernicia AUG-17-17
                                    caseRec.Application_for_Business_Customer__c = false;
                                    //caseRec.Application_for_Business_Service__c = false;
                                    caseRec.Application_for_Residential_Customer__c = true;
                                    //caseRec.Application_for_Residential_Service__c = true;
                                    //Start CSM-12269  Von Pernicia AUG-17-17
                                    //END CSM-7189 RReyes JUN-28-17

                                    //Start CSM-12248 Von Pernicia
                                    caseRec.Salutation__c = s.Account__r.Salutation;
                                    caseRec.First_Name__c = s.Account__r.FirstName;
                                    caseRec.Middle_Name__c = s.Account__r.MiddleName;
                                    caseRec.Last_Name__c = s.Account__r.LastName;
                                    caseRec.Date_of_Birth__c = s.Account__r.PersonBirthDate;
                                    //End CSM-12248 Von Pernicia
                                }
                            }
                            
                            //Start CSM-12269  Von Pernicia AUG-17-17
                            if (s.Rate__c == CXE_Constants.SERVICE_RATE_TYPE_RES)
                            {
                                caseRec.Application_for_Business_Service__c = false;
                                caseRec.Application_for_Residential_Service__c = true;
                            }
                            else
                            {
                                caseRec.Application_for_Business_Service__c = true;
                                caseRec.Application_for_Residential_Service__c = false;
                            }
                            //End CSM-12269  Von Pernicia AUG-17-17

                            //START - Applicable to modify and recontract only
                            if(caseRec.RecordTypeId == modifyRecTypeId || caseRec.RecordTypeId == recontractRecTypeId){
                                caseRec.Service_Description__c = s.Service_Description__c;
                                caseRec.Applied_Load__c = s.Applied_Load__c;
                                caseRec.Demand_Factor__c = s.Demand_Factor__c;
                                caseRec.Load_Factor__c = s.Load_Factor__c;
                                caseRec.Contracted_Capacity__c = s.Contracted_Capacity__c;
                                //START CSM-11925 RReyes JUL-23-17 - round off contracted capacity to 3 decimal places
                                if(caseRec.Contracted_Capacity__c != null){
                                    caseRec.Contracted_Capacity__c = caseRec.Contracted_Capacity__c.setScale(3);
                                }
                                //END CSM-11925 RReyes JUL-23-17 - round off contracted capacity to 3 decimal places
                                caseRec.TLN__c = s.Service_Wire_TLN__c;
                                caseRec.Pole_Code__c = s.Service_Wire_Pole_Number__c; // Renamed
                                caseRec.Service_Wire_Length__c = s.Service_Wire_Length__c;
                            
                                caseRec.Phase__c = s.Phase__c;
                                caseRec.PSIC__c = s.PSIC__c;
                                caseRec.Billing_Class__c = s.Billing_Class__c;
                                // Start CSM-12265 Von Pernicia
                                //caseRec.CXE_Service_Supply_Phase__c = s.Service_Supply_Phase__c;
                                caseRec.Phase__c = s.Service_Supply_Phase__c;
                                // End CSM-12265 Von Pernicia
                                caseRec.Voltage__c = s.Service_Supply_Voltage__c; // Renamed
                                caseRec.Service_Supply_Type__c = s.Service_Supply_Type__c;
                                caseRec.CXE_Service_Wire_Phase__c = s.Service_Wire_Phase__c;
                                caseRec.CXE_Service_Wire_Voltage__c = s.Service_Wire_Voltage__c;
                                caseRec.Service_Wire_Type__c = s.Service_Wire_Type__c;
                                caseRec.Wire_Size__c = s.Service_Wire_Size__c;
                                caseRec.Material__c = s.Service_Wire_Material__c; // Renamed
                                caseRec.CXE_Discount_Programs__c = s.CXE_Discount_Program__c;
                                //START CSM-6968 RReyes - JUN-09-17
                                caseRec.Business_Segment__c = s.Segment__c;
                                caseRec.Service_Rate_Type__c = s.Rate__c;
                                caseRec.CXE_Orig_Code_Service_Rate_Type__c = s.Code_Service_Rate_Type__c; // Start/End CSM-12252 Von Pernicia
                                caseRec.Bill_Deposit_Schedule__c = s.Deposit_Schedule__c;
                                caseRec.CXE_Rate_Programs__c = s.Rate_Program__c;
                                //END CSM-6968 RReyes - JUN-09-17
                                caseRec.CXE_Existing_Bill_Deposit_Amount__c = s.Deposit_Amount__c; //START/END CSM-6984 RReyes - get existing bill deposit amount from service 
                                //START CSM-6988 Commented out by RReyes - remove fields being mapped from case
                                /*
                                if(s.Case__c != null){
                                    caseRec.CXE_Contractor_Name__c = s.Case__r.CXE_Contractor_Name__c;
                                    caseRec.Application_for_Residential_Customer__c = s.Case__r.Application_for_Residential_Customer__c;
                                    caseRec.Application_for_Residential_Service__c = s.Case__r.Application_for_Residential_Service__c;
                                    //caseRec.CXE_Same_Customer__c = s.Case__r.CXE_Same_Customer__c;
                                    caseRec.Application_for_Business_Service__c = s.Case__r.Application_for_Business_Service__c;
                                    caseRec.Customer_Type__c = s.Case__r.Customer_Type__c;
                                    caseRec.Home_Ownership__c = s.Case__r.Home_Ownership__c;
                                    caseRec.Conglomerate_Tag__c = s.Case__r.Conglomerate_Tag__c;
                                    caseRec.Tax_Identification_No__c = s.Case__r.Tax_Identification_No__c;
                                    //caseRec.CXE_Interested_in_Other_Payment_Methods__c = s.Case__r.CXE_Interested_in_Other_Payment_Methods__c;
                                    //caseRec.CXE_Enroll_to_Paperless_Billing__c = s.Case__r.CXE_Enroll_to_Paperless_Billing__c;
                                    //caseRec.CXE_Enroll_to_Paperless_Billing_Status__c = s.Case__r.CXE_Enroll_to_Paperless_Billing_Status__c;
                                    //caseRec.CXE_Same_Contracted_Service_Details__c = s.Case__r.CXE_Same_Contracted_Service_Details__c;
                                    
                                    //caseRec.Voltage__c = s.Case__r.Voltage__c;
                                    //START CSM-6968 RReyes - JUN-09-17
                                    //caseRec.Service_Rate_Type__c = s.Case__r.Service_Rate_Type__c;
                                    //caseRec.Bill_Deposit_Schedule__c = s.Case__r.Bill_Deposit_Schedule__c;
                                    //caseRec.CXE_Rate_Programs__c = s.Case__r.CXE_Rate_Programs__c;
                                    //END CSM-6968 RReyes - JUN-09-17
                                    caseRec.AMC_Service_Tag__c =  s.Case__r.AMC_Service_Tag__c;
                                    caseRec.Accredited_Meralco_Contractor__c =  s.Case__r.Accredited_Meralco_Contractor__c;
                                    caseRec.AMC_Service_Package__c =  s.Case__r.AMC_Service_Package__c;
                                    caseRec.CXE_Same_Connection_Details__c =  s.Case__r.CXE_Same_Connection_Details__c;
                                    caseRec.Metering_Scheme__c =  s.Case__r.Metering_Scheme__c;
                                    caseRec.Mode_of_Retrieval__c =  s.Case__r.Mode_of_Retrieval__c;
                                    
                                    caseRec.Meter_Socket_Delivery_Tag__c =  s.Case__r.Meter_Socket_Delivery_Tag__c;
                                    caseRec.Delivery_Address__c =  s.Case__r.Delivery_Address__c;
                                    caseRec.Bill_Deposit_Status__c =  s.Case__r.Bill_Deposit_Status__c;
                                    caseRec.CXE_Bill_Deposit_Status_Date__c =  s.Case__r.CXE_Bill_Deposit_Status_Date__c;
                                    caseRec.Energization_FO_No__c = s.Case__r.Energization_FO_No__c;
                                    
                                    caseRec.Actual_Energization_Date__c = s.Case__r.Actual_Energization_Date__c;
                                    caseRec.Energization_FO_Executing_Office__c = s.Case__r.Energization_FO_Executing_Office__c;
                                    caseRec.GSL4__c = s.Case__r.GSL4__c;
                                    caseRec.Final_TPA__c = s.Case__r.Final_TPA__c;
                                    caseRec.Final_TCP_del__c = s.Case__r.Final_TCP_del__c;
                                    caseRec.Final_GSL4__c = s.Case__r.Final_GSL4__c;
                                    //caseRec.Override_Auto_Deposit_Amount__c = s.Case__r.Override_Auto_Deposit_Amount__c;
                                    //caseRec.Reason_for_Manual_Deposit_Input__c = s.Case__r.Reason_for_Manual_Deposit_Input__c;
                                    //caseRec.CXE_Request_for_Lifting_of_Arrears_Tag__c =  s.Case__r.CXE_Request_for_Lifting_of_Arrears_Tag__c;
                                    //caseRec.CXE_Reason_for_Lifting_of_Arrears_Tag__c =  s.Case__r.CXE_Reason_for_Lifting_of_Arrears_Tag__c;
                                    //caseRec.CXE_Request_GSL4_TargetDate_Modification__c  = s.Case__r.CXE_Request_GSL4_TargetDate_Modification__c ;
                                    //caseRec.Reason_for_GSL4_Target_Date_Modification__c = s.Case__r.Reason_for_GSL4_Target_Date_Modification__c;                                    
                                }
                                */ 
                                //END CSM-6988 Commented out by RReyes - remove fields being mapped from case
                                
                                if(s.Account__c != null){
                                    caseRec.Conglomerate_Tag__c = s.Account__r.Conglomerate__c;
                                    caseRec.Tax_Identification_No__c = s.Account__r.Tax_Identification_No__c;
                                    caseRec.Customer_Type__c = s.Account__r.Customer_Type__c; //Start/End CSM-12498 9/10/17: Von Pernicia
                                }
                            }
                            //END - Applicable to modify and recontract only
                            
                            //START CSM-6988 Commented out by RReyes - remove fields being mapped from case
                            /*
                            //START - Applicable to modify and terminate only
                            if(caseRec.RecordTypeId == modifyRecTypeId || caseRec.RecordTypeId == terminateRecTypeId){
                                if(s.Case__c != null){
                                    //caseRec.Deposit_Amount__c = s.Deposit_Amount__c;
                                    caseRec.Re_Inspection_FO_Resolution_Remarks__c = s.Case__r.Re_Inspection_FO_Resolution_Remarks__c;
                                    caseRec.With_Existing_Record_in_Meralco__c = s.Case__r.With_Existing_Record_in_Meralco__c;
                                }
                            }//END - Applicable to modify and terminate only
                            */
                            //END CSM-6988 Commented out by RReyes - remove fields being mapped from case
                            
                            //START - Applicable to individual record types only
                            if(caseRec.RecordTypeId == recontractRecTypeId){
                                // Start CSM-7334 Von Pernicia Change from Service_Termination_Date__c to Agreement_End_Date__c
                                // START     JEROME TO     JUN-01-17       CSM-3799
                                caseRec.CXE_Termination_Date_of_SIN__c = s.Agreement_End_Date__c;
                                // END     JEROME TO     JUN-01-17       CSM-3799
                                // End CSM-7334 Von Pernicia Change from Service_Termination_Date__c to Agreement_End_Date__c
                                //if(s.Case__c != null){
                                //    caseRec.CXE_Termination_Date_of_SIN__c = s.Case__r.CXE_Termination_Date_of_SIN__c;
                                //}
                            }
                            //START CSM-6988 Commented out by RReyes - remove fields being mapped from case
                            /*else if(caseRec.RecordTypeId == terminateRecTypeId){
                                if(s.Case__c != null){
                                    //caseRec.Un_Satisfaction_Reason__c = s.Case__r.Un_Satisfaction_Reason__c;
                                    //caseRec.CXE_Termination_Remarks__c = s.Case__r.CXE_Termination_Remarks__c;
                                    //caseRec.CXE_Retirement_FO_Number__c = s.Case__r.CXE_Retirement_FO_Number__c;
                                    //caseRec.CXE_Connection_FO_Status__c = s.Case__r.CXE_Connection_FO_Status__c;
                                    //caseRec.CXE_Retirement_FO_Remarks__c = s.Case__r.CXE_Retirement_FO_Remarks__c;
                                    //caseRec.CXE_Actual_Retirement_Date__c = s.Case__r.CXE_Actual_Retirement_Date__c;
                                    //caseRec.CXE_Retirement_FO_Executing_Office__c = s.Case__r.CXE_Retirement_FO_Executing_Office__c;
                                }
                            }//END - Applicable to terminate only
                            //START CSM-6464 RReyes - JUN-06-17 - target energization date should be for modify only
                            else if(caseRec.RecordTypeId == modifyRecTypeId){
                                if(s.Case__c != null){
                                    caseRec.Target_Energization_Date__c = s.Case__r.Target_Energization_Date__c;
                                }
                            }
                            */
                            //END CSM-6988 Commented out by RReyes - remove fields being mapped from case
                            //END CSM-6464 RReyes - JUN-06-17 - target energization date should be for modify only
                        }
                    }
                }
            }
        }
    }
    //END RReyes MAY-26-17 CSM-3838 - modification of service autopopulation  
    
    //START RReyes SEP-02-17 CSM-12370- CommentedOut by RReyes
    //START RReyes MAY-26-17 CSM-11476 - modification of service Create Service Address
    /* Description: Cread Service Address based on selected service
     * Parameters: List<Case>
     * Returns: void
     * Author: Von Pernicia
     * Date Created: JUL-19-17
     */
     /*
    private void createServiceAddressFromService(List<Case> caseList){
        Set<Id> serviceIds = new Set<Id>();
        Set<Id> serviceToCaseSet = new Set<Id>();
        String servId;
        Map<String, String> serviceToAddressMap = new Map<String, String>(); //START/END CSM-6752 RReyes JUN-07-17
        Map<String, String> serviceToLandmarkMap = new Map<String, String>(); //START/END CSM-6977 RReyes JUN-13-17
        Map<String, String> serviceToProvinceMap = new Map<String, String>(); 
        Map<String, String> serviceToCityMap = new Map<String, String>(); 
        Map<String, String> serviceToBarangayMap = new Map<String, String>();
        Map<String, String> serviceToSubdMap = new Map<String, String>(); 
        Map<String, String> serviceToStreetMap = new Map<String, String>(); 
        Map<String, String> serviceToPremiseTypeMap = new Map<String, String>();
        Map<String, String> serviceToUnitNoMap = new Map<String, String>();
        Map<String, String> serviceToStreetNoMap = new Map<String, String>();
        List<Address__c> serviceAddressList = new List<Address__c>();
        
        for(Case caseRecord : caseList) {
            if(caseRecord.RecordTypeId == modifyRecTypeId){
                if(caseRecord.CXE_Service__c != null){
                    serviceIds.add(caseRecord.CXE_Service__c);
                }
            }
        }

        if(!serviceIds.isEmpty())
        {        
            List<Address__c> lstAdd = [SELECT Id, 
                                        Service__c, 
                                        Address_Unit_No__c, 
                                        Address_Street_No__c,
                                        Address_Province__c,  
                                        Address_City_Municipality__c,
                                        Address_Barangay__c, 
                                        Address_Street_Name__c, 
                                        Address_Subdivision__c,
                                        Premise_Type__c,
                                        Landmarks_Directions__c
                                        FROM Address__c 
                                        WHERE Service__c IN:serviceIds AND Type__c =: CXE_Constants.ADDRESS_TYPE_SERVICE];
            
            for(Address__c address : lstAdd){
                servId = address.Service__c;
                if(!serviceToAddressMap.containsKey(servId)){
                    serviceToLandmarkMap.put(servId, address.Landmarks_Directions__c); //START/END CSM-6977 RReyes JUN-13-17
                    serviceToProvinceMap.put(servId, address.Address_Province__c); 
                    serviceToCityMap.put(servId, address.Address_City_Municipality__c); 
                    serviceToBarangayMap.put(servId, address.Address_Barangay__c); 
                    serviceToSubdMap.put(servId, address.Address_Subdivision__c); 
                    serviceToStreetMap.put(servId, address.Address_Street_Name__c); 
                    serviceToPremiseTypeMap.put(servId, address.Premise_Type__c); 
                    serviceToUnitNoMap.put(servId, address.Address_Unit_No__c); 
                    serviceToStreetNoMap.put(servId, address.Address_Street_No__c); 
                }
            }
                    
            for(Address__c address : [SELECT Case__c
                                      FROM   Address__c 
                                      WHERE  Case__c IN:caseList AND Type__c =: CXE_Constants.ADDRESS_TYPE_SERVICE])
            {
                serviceToCaseSet.add(address.Case__c);
            }

            for(Case caseRec : caseList){ 
                if(!serviceToCaseSet.contains(caseRec.Id)
                && caseRec.RecordTypeId == modifyRecTypeId 
                && caseRec.CXE_Service__c != null
                && (caseRec.CXE_Change_in_Service_Rate__c || caseRec.CXE_Service_Request_s__c.contains(CXE_Constants.SERVICE_REQ_TRANSFER)))
                {
                    
                    if (serviceToStreetNoMap.containsKey(caseRec.CXE_Service__c))
                    {                   
                        Address__c add = new Address__c(

                            Case__c = caseRec.Id, 
                            Address_Unit_No__c = serviceToUnitNoMap.get(caseRec.CXE_Service__c), 
                            Address_Street_No__c = serviceToStreetNoMap.get(caseRec.CXE_Service__c),
                            Address_Province__c = serviceToProvinceMap.get(caseRec.CXE_Service__c),  
                            Address_City_Municipality__c = serviceToCityMap.get(caseRec.CXE_Service__c),
                            Address_Barangay__c = serviceToBarangayMap.get(caseRec.CXE_Service__c), 
                            Address_Street_Name__c = serviceToStreetMap.get(caseRec.CXE_Service__c), 
                            Address_Subdivision__c = serviceToSubdMap.get(caseRec.CXE_Service__c),
                            Premise_Type__c = serviceToPremiseTypeMap.get(caseRec.CXE_Service__c),
                            Landmarks_Directions__c = serviceToLandmarkMap.get(caseRec.CXE_Service__c),
                            Type__c = CXE_Constants.ADDRESS_TYPE_SERVICE
                        );
                        serviceAddressList.add(add);
                    }
                    else
                    {
                        caseRec.addError(CXE_Constants.BILL_DEPOSIT_SIMULATOR_ADDRESS_REQUIRED_ERROR);
                    }
                }
            }
            
            if (serviceAddressList.size() > 0)
            {
                insert serviceAddressList;
            }
        }
    }
    //END Von Pernicia JUL-19-17 CSM-11476 - modification of service Create Service Address
    */
    //END RReyes SEP-02-17 CSM-12370- CommentedOut by RReyes

    /* Description: Populate PSIC, Service Rate Type and Billing Class to Residential PSIC
     * Parameters: List<Case>
     * Returns: Void
     * Author: Jerome To - CSM-2022
     * Date Created: MAR-27-17
     */
    //private void updatePSICResidential(List<Case> caseList, Map<Id, Case> oldMap){

    //    Set<Id> caseIds = new Set<Id>();

    //    if(oldMap == null){
    //        for(Case caseRec : caseList) {
    //            if(caseRec.Application_for_Residential_Service__c) {
    //                caseIds.add(caseRec.Id);
    //            }
    //        }
            
    //    } else {
    //        for(Case caseRec : caseList) {
    //            if(caseRec.Application_for_Residential_Service__c && 
    //                oldMap.get(caseRec.Id).Application_for_Residential_Service__c != caseRec.Application_for_Residential_Service__c) {
    //                caseIds.add(caseRec.Id);
    //            }
    //        }

    //    }

    //    if(!caseIds.isEmpty()){
    //        List<PSIC__c> psicRecords = [SELECT Id, Demand_Factor__c, Load_Factor__c 
    //                                     FROM PSIC__c 
    //                                     WHERE Name =:CXE_Constants.PSIC_NAME_RESIDENTIAL];
    //        if(!psicRecords.isEmpty()) {
    //            for(Case caseRec : caseList) {
    //                if(caseIds.contains(caseRec.Id)) {
    //                    caseRec.Billing_Class__c = CXE_Constants.CASE_BILLING_CLASS_RESIDENTIAL_SERVICE_RS;
    //                    caseRec.Service_Rate_Type__c = CXE_Constants.CASE_SERVICE_RATE_TYPE_RESIDENTIAL_SERVICE_RS;
    //                    caseRec.PSIC__c = psicRecords.get(0).Id;
    //                    caseRec.Demand_Factor__c = psicRecords.get(0).Demand_Factor__c;
    //                    caseRec.Load_Factor__c = psicRecords.get(0).Load_Factor__c;
    //                }
    //            }
    //        }
    //    }
    //}

    /* Description: CSM-6151 Check for Duplicate or Existing Modification. Record checking,  no pending Case Record can have the same SIN and Record Type
     * Parameters: List<Case>
     * Returns: Void
     * Author: Jerome To 
     * Date Created: MAR-27-17
     * Updated - Added New Service Record type - CSM-7226
     */
    private void checkModifyServiceDuplicate(List<Case> caseList){
        //Boolean isAdmin = CXE_Utility.isAdmin(); //START/END CSM-12370 RReyes SEP-04-17
        Set<Id> recordTypeIds = new Set<Id>{ caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_NEW_SERVICE_APPLICATION),
                                             caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_MODIFICATION_OF_ELECTRIC_SERVICE),
                                             caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_TERMINATION_OF_ELECTRIC_SERVICE),
                                             caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_RECONTRACT_OF_ELECTRIC_SERVICE) };

        Set<Id> serviceIds = new Set<Id>();
        Set<Id> serviceIdsWithPendingCase = new Set<Id>();
        Map<Id, Case> caseWithSameSIN = new Map<Id, Case>();

        for(Case caseRec : caseList) {
            if(recordTypeIds.contains(caseRec.RecordTypeId) && caseRec.CXE_Service__c != null && !isAdmin) {

                //if(caseRec.RecordTypeId == caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_NEW_SERVICE_APPLICATION) && caseRec.Status == CXE_Constants.CASE_APPLICATION_CLOSED) {
                //    continue;
                //}

                serviceIds.add(caseRec.CXE_Service__c);
            }
        }

        if(!serviceIds.isEmpty()) {
            caseWithSameSIN = new Map<Id, Case>([SELECT CXE_Service__c FROM Case WHERE CXE_Service__c IN:serviceIds AND RecordTypeId IN:recordTypeIds AND IsClosed != true]);

            if(!caseWithSameSIN.isEmpty()) {
                for(Case caseRec : caseWithSameSIN.values()) {
                    serviceIdsWithPendingCase.add(caseRec.CXE_Service__c);
                }
            }

            if(!serviceIdsWithPendingCase.isEmpty()) {
                for(Case caseRec : caseList) {
                    if(recordTypeIds.contains(caseRec.RecordTypeId) && !isAdmin && serviceIdsWithPendingCase.contains(caseRec.CXE_Service__c) && caseRec.CXE_Service__c != null) {
                        caseRec.addError(CXE_Constants.CASE_MODIFICATION_ERROR_DUPLICATE_OR_PENDING_CASE_EXIST);
                    }
                }
            }
        }
    }

    /* Description: Validate Case fields base on Service Request
     * Parameters: List<Case>
     * Returns: error message
     * Author: Von Pernicia - CSM-3861
     * Date Created: May-28-17
*               JUL-5-17  CSM-7230     method/code optimization
     */
    private void validateServiceRequest(Map<Id, Case> caseNewMap, Map<Id, Case> caseOldMap)
    {
        
        String errorMessage;
        Map<String, Schema.SObjectField> fieldsMap = Schema.SObjectType.Case.fields.getMap();
        Map<String, List<String>> marSerReqFields = new Map<String, List<String>>();
        Set<String> listChangeInName = new Set<String>();
        Set<String> listLoad = new Set<String>();
        Set<String> listRemodel = new Set<String>();
        Set<String> listRelocation = new Set<String>();
        Set<String> listAllFields = new Set<String>();

        //START CSM-7230    GGrandea JUL-3-2017
        List<Case> recordToProcess = new List<Case>();
        
        for(Case caseRecord : caseNewMap.values()){   
            // Execute the validation if the service prior value is the same as the new value
            if (caseRecord.CXE_Service__c == caseOldMap.get(caseRecord.Id).get('CXE_Service__c')
                &&  caseRecord.AccountId == caseOldMap.get(caseRecord.Id).get('AccountId')
                &&  caseRecord.RecordTypeId == modifyRecTypeId ){
                    
                    recordToProcess.add(caseRecord);
                }
        }
        
        if(recordToProcess.size()>0){
            
        // Retrieve API names to be validated base on Service Request from Custom Settings
        for (Service_Request_Fields__c srf: [SELECT  Name,
                                                     Request_Type__c
                                             FROM    Service_Request_Fields__c])

        {
            if (srf.Request_Type__c == CXE_Constants.SERV_REQ_CHANGE_IN_NAME)
            {
                listChangeInName.add(srf.Name);
            }

            if (srf.Request_Type__c == CXE_Constants.SERV_REQ_ADDITIONAL_REDUCTION_LOAD)
            {
                listLoad.add(srf.Name);
            }

            if (srf.Request_Type__c == CXE_Constants.SERV_REQ_REMODEL_RELOCATION)
            {
                listRelocation.add(srf.Name);
            }

            if (srf.Request_Type__c == CXE_Constants.SERV_REQ_REMODEL_RELOCATION || srf.Request_Type__c == CXE_Constants.SERV_REQ_REMODEL)
            {
                listRemodel.add(srf.Name);
            }

            listAllFields.add(srf.Name);

        }

            //Loop all Case fields and place in a Map <Name,Label>
            Map<String, String> fieldNameLabelMap = new Map<String, String>();
            for (Schema.SObjectField field : fieldsMap.values()) {
                fieldNameLabelMap.put(field.getDescribe().getName(), field.getDescribe().getLabel());
            }
            
            Set<String> fieldAPINametoExempt;
            
            // loop through all Modification Case record that had a change in Service value
            for (Case caseRecord : recordToProcess) {
                
                // Fields to be excluded in the validation
                fieldAPINametoExempt = new Set<String>();
                
                if (caseRecord.CXE_Service_Request_s__c.contains(CXE_Constants.SERVICE_REQ_CHANGE_IN_NAME)){
                    fieldAPINametoExempt.addAll(listChangeInName);
                }
                if (caseRecord.CXE_Service_Request_s__c.contains(CXE_Constants.SERVICE_REQ_ADDITIONAL_LOAD)
                    || caseRecord.CXE_Service_Request_s__c.contains(CXE_Constants.SERVICE_REQ_REDUCTION_LOAD) ){
                        fieldAPINametoExempt.addAll(listLoad);
                    }
                if (caseRecord.CXE_Service_Request_s__c.contains(CXE_Constants.SERVICE_REQ_REMODEL)){
                    fieldAPINametoExempt.addAll(listRemodel);
                }
                if (caseRecord.CXE_Service_Request_s__c.contains(CXE_Constants.SERVICE_REQ_RELOCATION)){
                    fieldAPINametoExempt.addAll(listRelocation);
                }
                if (caseRecord.CXE_Service_Request_s__c.contains(CXE_Constants.SERVICE_REQ_TRANSFER)){
                    fieldAPINametoExempt.addAll(listChangeInName);
                    fieldAPINametoExempt.addAll(listLoad);
                    fieldAPINametoExempt.addAll(listRemodel);
                    fieldAPINametoExempt.addAll(listRelocation);
                }
                
                //Loop all Case fields
                for (String fieldName : fieldNameLabelMap.keyset()) {
                    
                    // Validate all the fields from the listAllFields
                    if (listAllFields.contains(fieldName)) {
                        
                        // Exempt all the fields depend on fieldAPINametoExempt
                        if (caseNewMap.get(caseRecord.Id).get(fieldName) != caseOldMap.get(caseRecord.Id).get(fieldName)
                            &&  !fieldAPINametoExempt.contains(fieldName)) {
                                
                                if (errorMessage == null) {                                    
                                    errorMessage = fieldNameLabelMap.get(fieldName);
                                }
                                else {
                                    errorMessage += ', ' + fieldNameLabelMap.get(fieldName);
                                }                                
                        }
                    }
                }
                    
                if (errorMessage != null)
                {
                    caseRecord.addError(CXE_Constants.SERV_REQ_ERRORMSG + errorMessage);
                }
            }
        }   
    }


    /* Description: CSM-3779, CSM-6130, CSM-6494, CSM-6471, CSM-6483 Rules for AMC Tagging 
     * Parameters: List<Case>
     * Returns: Void
     * Author: Jerome To
     * Date Created: JUN-02-17
     */
    private void validateRulesForAMCTagging(List<Case> caseList, Map<Id, Case> oldMap){
        Map<String, Case_Status_Setting__mdt> mapCaseStatusSettings = getMapCaseStatusSettings();
        Set<Id> recordTypeIds = new Set<Id>{ caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_MODIFICATION_OF_ELECTRIC_SERVICE),
                                                 caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_TERMINATION_OF_ELECTRIC_SERVICE),
                                                 caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_RECONTRACT_OF_ELECTRIC_SERVICE),
                                                 caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_NEW_SERVICE_APPLICATION) };
        //if(!CXE_Utility.isAdmin() && !mapCaseStatusSettings.isEmpty()) { //START/END CSM-12370 RReyes SEP-04-17
        if(!isAdmin && !mapCaseStatusSettings.isEmpty()) { //START/END CSM-12370 RReyes SEP-04-17
            for(Case caseRecord : caseList) {
                if(recordTypeIds.contains(caseRecord.RecordTypeId)) {
                    String caseStatus = caseRecord.Status;
                    Id caseId = caseRecord.Id;
                    Boolean hasChangeInServicePackage = (oldMap != null && oldMap.get(caseId).AMC_Service_Package__c != caseRecord.AMC_Service_Package__c);

                    //  Require association of Accredited Meralco Contractor 
                    if( caseRecord.AMC_Service_Tag__c && mapCaseStatusSettings.containsKey(caseStatus) && mapCaseStatusSettings.get(caseStatus).Is_Required_for_AMC__c && 
                        caseRecord.Accredited_Meralco_Contractor__c == null) {
                        caseRecord.addError(String.format(CXE_Constants.AMC_RULE_ERROR3, new List<String> {caseStatus}));
                        continue;
                    }

                    if (hasChangeInServicePackage && mapCaseStatusSettings.containsKey(caseStatus) && caseRecord.Accredited_Meralco_Contractor__c != null && !String.isBlank(caseRecord.AMC_Service_Package__c)){
                        if(caseRecord.AMC_Service_Package__c == CXE_Constants.AMC_SERVICE_PACKAGE_TECHNICAL_BUNDLE && !mapCaseStatusSettings.get(caseStatus).Is_Valid_for_Technical_Bundle__c) {
                            caseRecord.addError(String.format(CXE_Constants.AMC_RULE_ERROR_INVALID_STATUS_FOR_AMC_SERVICE_PACKAGE, new List<String>{ caseStatus, CXE_Constants.AMC_SERVICE_PACKAGE_TECHNICAL_BUNDLE }));
                        } else if(caseRecord.AMC_Service_Package__c == CXE_Constants.AMC_SERVICE_PACKAGE_FULL_BUNDLE && !mapCaseStatusSettings.get(caseStatus).Is_Valid_for_Full_Bundle__c) {
                            caseRecord.addError(String.format(CXE_Constants.AMC_RULE_ERROR_INVALID_STATUS_FOR_AMC_SERVICE_PACKAGE, new List<String>{ caseStatus, CXE_Constants.AMC_SERVICE_PACKAGE_FULL_BUNDLE }) );
                        } else if(caseRecord.AMC_Service_Package__c == CXE_Constants.AMC_SERVICE_PACKAGE_DOCUMENTARY_BUNDLE && !mapCaseStatusSettings.get(caseStatus).Is_Valid_for_Document_Bundle__c) {
                            caseRecord.addError(String.format(CXE_Constants.AMC_RULE_ERROR_INVALID_STATUS_FOR_AMC_SERVICE_PACKAGE, new List<String>{ caseStatus, CXE_Constants.AMC_SERVICE_PACKAGE_DOCUMENTARY_BUNDLE }) );
                        } else if(caseRecord.AMC_Service_Package__c == CXE_Constants.AMC_SERVICE_PACKAGE_PROCESSING_BUNDLE && !mapCaseStatusSettings.get(caseStatus).Is_Valid_for_Processing_Bundle__c) {
                            caseRecord.addError(String.format(CXE_Constants.AMC_RULE_ERROR_INVALID_STATUS_FOR_AMC_SERVICE_PACKAGE, new List<String>{ caseStatus, CXE_Constants.AMC_SERVICE_PACKAGE_PROCESSING_BUNDLE }) );
                        }
                        continue;                        
                    }
                }                
            }
        }
    }

    /* Description: CSM-3779, CSM-6130, CSM-6494, CSM-6471, CSM-6483 Get Case Status Settings
     * Parameters: 
     * Returns: Void
     * Author: Jerome To
     * Date Created: JUN-02-17
     */
    private Map<String, Case_Status_Setting__mdt> getMapCaseStatusSettings() {
        Map<String, Case_Status_Setting__mdt> mapCaseStatusSettings = new Map<String, Case_Status_Setting__mdt>();
        for (Case_Status_Setting__mdt setting : [SELECT MasterLabel, Is_Required_for_AMC__c, Is_Valid_for_AMC_Service__c, Is_Valid_for_Document_Bundle__c,
                                                        Is_Valid_for_Full_Bundle__c, Is_Valid_for_Processing_Bundle__c, Is_Valid_for_Technical_Bundle__c
                                                 FROM Case_Status_Setting__mdt
                                                 WHERE Is_For_AMC_Tagging_Rules__c = true]) {
            mapCaseStatusSettings.put(setting.MasterLabel, setting);
        }
        return mapCaseStatusSettings;
    }


    /* Description: CSM-6448,CSM-6147,CSM-6494 Checking for Awaiting Customer Compliance
     * Parameters: 
     * Returns: Void
     * Author: Jerome To
     * Date Created: JUN-05-17
     */
    private void validationOnAwaitingCustomerCompliance(List<Case> newList, Map<Id, Case> oldMap) {
        //START CSM-12370 RReyes SEP-04-17
        //if (!CXE_Utility.isAdmin()) { 
        //    Boolean isAdmin = CXE_Utility.isAdmin();
        if (!isAdmin) { 
        //END CSM-12370 RReyes SEP-04-17
            String errorFields = ''; //to be deleted
            Set<String> caseStatusFilter = new Set<String> {
                                                            //CXE_Constants.CASE_STATUS_AWAITING_CUSTOMER_COMPLIANCE,
                                                            //CXE_Constants.CASE_STATUS_RE_INSPECTION_FO_GENERATED,
                                                            //CXE_Constants.CASE_STATUS_RE_INSPECTION_FO_SCHEDULED,
                                                            //CXE_Constants.CASE_STATUS_RE_INSPECTION_FO_RESOLVED_DISAPPROVED,
                                                            CXE_Constants.CASE_STATUS_RE_INSPECTION_FO_RESOLVED_APPROVED};  
            //START CSM-7335 RReyes JUL-11-17- added bill deposit status, bill deposit status date, re-inspection fo resolution remarks
            //START CSM-11924 RReyes JUL-23-17- added trigger_time_05__c, systemmodstamp, lastmodifieddate                                                      
            //START CSM-12213 Von Pernicia AUG-05-17- added isUpdatedFromPB__c
            //START CSM-12417 RReyes SEP-04-17 - added 'Re_inspection_FO_Findings__c', 'scc_status__c' and 'tpa__c'
            Set<String> fieldNameFilter = new Set<String> {'status',
                                                            're_inspection_fo_approved_date__c',
                                                            'number_of_pending_fo__c',
                                                            'bill_deposit_status__c',
                                                            'cxe_bill_deposit_status_date__c',
                                                            're_inspection_fo_resolution_remarks__c',
                                                            'integ_v10_outbound_message_send_date_2__c',
                                                            'code_status__c',
                                                            'trigger_time_05__c',
                                                            'systemmodstamp',
                                                            'lastmodifieddate',
                                                            'isupdatedfrompb__c',
                                                            're_inspection_fo_findings__c',
                                                            'scc_status__c',
                                                            'tpa__c'};
            //END CSM-12417 RReyes SEP-04-17 - added 'Re_inspection_FO_Findings__c', 'scc_status__c' and 'tpa__c'
            //END CSM-12213 Von Pernicia AUG-05-17- added isUpdatedFromPB__c                                               
            //END CSM-11924 RReyes JUL-23-17- added trigger_time_05__c, systemmodstamp, lastmodifieddate 
            //END CSM-7335 RReyes JUL-11-17 - added bill deposit status, bill deposit status date,  re-inspection fo resolution remarks  
            //Get all Case fields
            Map<String, Schema.SObjectField> caseFields = Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap();
            for(Case caseRec : newList) {
                //START CSM-7335 RReyes JUL-11-17 - added criteria isUpdatedFromPB?
                if(!caseRec.isUpdatedFromPB__c){
                    if(caseStatusFilter.contains(caseRec.Status)){
                        for(String s : caseFields.keySet()){
                            if(caseRec.get(s) != oldMap.get(caseRec.Id).get(s) && !fieldNameFilter.contains(s)) {
                                //caseRec.addError(s);
                                System.debug('>>rr changed field: ' + s); //START/END CSM-12417 RReyes SEP-05
                                caseRec.addError('>>rr: ' + s);
                                //caseRec.addError(CXE_Constants.CASE_ERROR_MESSAGE_ALLOW_SYSTEM_ADMIN_ONLY);
                            } 
                        }
                    }
                }
                //END CSM-7335 RReyes JUL-11-17 - added criteria isUpdatedFromPB?
            }
        }
    }
    
    /* Description: CSM-6704 - Status Path (Chevron)
     * Parameters: List<Case>, Map<Id,Case>, Boolean isUpdated
     * Returns: Void
     * Author: Rom Edison Reyes 
     * Date Created: JUN-14-17
     */
    private void mapStatusPath(List<Case> newList, Map<Id, Case> oldMap, Boolean isUpdate) {
        Boolean isMapNeeded;
        for(Case c : newList){
            //START CSM-12376 RReyes AUG-31-17 - added filtering for NSA,MSA,TSA and RSA only
            if(c.RecordTypeId == modifyRecTypeId || c.RecordTypeId == terminateRecTypeId || 
                c.RecordTypeId == recontractRecTypeId || c.RecordTypeId == newServRecTypeId){
                isMapNeeded = false;
                if(!isUpdate){
                    isMapNeeded = true;
                }else if(isUpdate && c.Status != oldMap.get(c.Id).Status){
                    isMapNeeded = true;
                }
                if(isMapNeeded){
                    if(CXE_Constants.CASE_STATUS_SET_APPLY.contains(c.Status)){
                        c.CXE_StatusPath__c = 'Apply';
                    }else if(CXE_Constants.CASE_STATUS_SET_COMPLETE.contains(c.Status)){
                        c.CXE_StatusPath__c = 'Complete';
                    }else if(CXE_Constants.CASE_STATUS_SET_ENERGIZE.contains(c.Status)){
                        c.CXE_StatusPath__c = 'Energize';
                    }else if(CXE_Constants.CASE_STATUS_SET_EVALUATE.contains(c.Status)){
                        c.CXE_StatusPath__c = 'Evaluate';
                    }else if(CXE_Constants.CASE_STATUS_SET_INSPECT.contains(c.Status)){
                        c.CXE_StatusPath__c = 'Inspect';
                    }else if(CXE_Constants.CASE_STATUS_SET_RETIRE.contains(c.Status)){
                        c.CXE_StatusPath__c = 'Retire';
                    }else if(c.Status == CXE_Constants.CASE_APPLICATION_CLOSED){
                        if(c.RecordTypeId == terminateRecTypeId){
                            c.CXE_StatusPath__c = 'Retire';
                        }else{
                            c.CXE_StatusPath__c = 'Energize';
                        }
                    }else{
                        c.CXE_StatusPath__c = '';
                    }
                }
            }//END CSM-12376 RReyes AUG-31-17 - added filtering for NSA,MSA,TSA and RSA only
        }
    }
    
    /* Description: CSM-6704 - Status Path (Chevron)
     * Parameters: List<Case>, Map<Id,Case>, Boolean isUpdated
     * Returns: Void
     * Author: Rom Edison Reyes 
     * Date Created: JUN-14-17
     */
    private void mapReceivedAndClosedDate(List<Case> newList, Map<Id, Case> oldMap, Boolean isUpdate) {
        for(Case c : newList){
            if(isUpdate){
                if(oldMap.containsKey(c.Id)){
                    if(c.Status != oldMap.get(c.Id).Status){
                        if(c.Status == CXE_Constants.CASE_APPLICATION_RECEIVED){
                            c.CXE_Application_Received_Date__c = Date.Today();
                        }
                        if (c.Status == CXE_Constants.CASE_APPLICATION_CLOSED){
                            c.CXE_Application_Closed_Date__c = Date.Today();
                        }
                    }
                }
            }else{
                c.CXE_Application_Received_Date__c = Date.Today();
            }
        }
    }

    /* Description:  CSM-7104 - Require the user to click custom button on retrieval of 
     *               terminated SIN details for recontract service application               
     * Parameters: List<Case>, Map<Id,Case>
     * Returns: Void
     * Author: Jerome To
     * Date Created: JUN-21-17
     */
    private void flagAsRequiredToClickRetrieveButton(List<Case> newList, Map<Id, Case> oldMap) {
        // Start CSM-12149 & CSM-12144 Von Pernicia AUG-01-17
        if (!isIns)
        {
            //Boolean isAdmin = CXE_Utility.isAdmin();//START/END CSM-12370 RReyes SEP-04-17
            for(Case caseRec : newList) {
                if(caseRec.RecordTypeId == caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_RECONTRACT_OF_ELECTRIC_SERVICE) &&
                   !String.isBlank(oldMap.get(caseRec.Id).CXE_Previous_SIN__c) && 
                   !String.isBlank(caseRec.CXE_Previous_SIN__c) && 
                    caseRec.CXE_Previous_SIN__c != oldMap.get(caseRec.Id).CXE_Previous_SIN__c) {
                    caseRec.CXE_Is_Required_to_Click_Retrieve_Button__c = true;
                    caseRec.CXE_isServiceRetrieved__c = false;
                } 
                else if (caseRec.RecordTypeId == caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_RECONTRACT_OF_ELECTRIC_SERVICE) &&
                    caseRec.CXE_isServiceRetrieved__c == false)
                {
                    // Start CSM-12223 Von Pernicia
                    //START CSM-12251 RReyes AUG-11-17
                    if (!isAdmin)
                    {
                        caseRec.addError(CXE_Constants.CASE_ERROR_RETRIEVED_SERVICE);
                    }
                    //END CSM-12251 RReyes AUG-11-17
                    // End CSM-12223 Von Pernicia
                }
            }
        }
        // End CSM-12149 & CSM-12144 Von Pernicia AUG-01-17
    }
    
    //START CSM-7140 RReyes JUN-22-17 Populate fields from Account and Contact records for Recontracting Cases updateAccountContactFieldsOnCaseForRecontract
    /* Description: CSM-7140 - Populate fields from Account and Contact records for Recontracting Cases
* Parameters: List<Case>, Map<Id, Case>
* Returns: Void
* Author: Rom Edison Reyes 
* Date Created: JUN-22-17
*/
    private void updateAccountContactFieldsOnCaseForRecontract(List<Case> newList, Map<Id, Case> oldMap) {
        List<Case> casesToUpdate = new List<Case>();
        for(Case c : newList){
            if(c.RecordTypeId == recontractRecTypeId && CXE_Constants.CASE_STATUS_FOR_ACCOUNT_CONTACT_UPDATE.contains(c.Status)){
                if(oldMap.containsKey(c.Id)){
                    if(c.AccountId != oldMap.get(c.Id).AccountId || c.ContactId != oldMap.get(c.Id).ContactId){
                        casesToUpdate.add(c);
                    }
                }
            }
        }
        
        if(!casesToUpdate.isEmpty()){
            populateCaseAccountContactDetails(casesToUpdate);
        }
    }
    //END CSM-7140 RReyes JUN-22-17 Populate fields from Account and Contact records for Recontracting Cases
    
    //START CSM-7189 RReyes JUN-28-17 Populate account fields when account is changed
    /* Description: CSM-7140 - Populate fields from Account and Contact records for Recontracting Cases
     * Parameters: List<Case>, Map<Id, Case>
     * Returns: Void
     * Author: Rom Edison Reyes 
     * Date Created: JUN-22-17
     */
    private void updateAccountFieldsOnChangeOfAccount(List<Case> newList, Map<Id, Case> oldMap) {
        List<Case> casesToUpdate = new List<Case>();
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Account> accountMap = new Map<Id, Account>();
        
        for(Case c : newList){
            if((c.RecordTypeId == modifyRecTypeId || c.RecordTypeId == terminateRecTypeId || c.RecordTypeId == recontractRecTypeId) 
                && CXE_Constants.CASE_STATUS_BEFORE_APPLICATION_EVALUATED.contains(c.Status)){
                if(oldMap.containsKey(c.Id)){
                    if(c.AccountId != oldMap.get(c.Id).AccountId){
                        if(c.AccountId != null){
                            accountIds.add(c.AccountId);
                            casesToUpdate.add(c);
                        }
                    }
                }
            }
        }
        
        if(!accountIds.isEmpty()){
            accountMap = new Map<Id, Account>([SELECT Id, 
                                                   Name, 
                                                   Doing_Business_As__c, 
                                                   Tax_Identification_No__c, 
                                                   Customer_Type__c, 
                                                   Conglomerate__c, 
                                                   Phone, 
                                                   Salutation, 
                                                   FirstName, 
                                                   MiddleName, 
                                                   LastName, 
                                                   PersonMobilePhone, 
                                                   PersonEmail, 
                                                   PersonBirthdate, 
                                                   isPersonAccount,
                                                   Mobile_Phone__c,
                                                   Email__c,
                                                   RecordType.DeveloperName
                                                   //START CSM-11451 RReyes JUL-17-17
                                                   ,PersonHomePhone,
                                                   Mobile_1__pc
                                                   //END CSM-11451 RReyes JUL-17-17
                                            FROM   Account 
                                            WHERE  Id IN: accountIds]);
        }
        
        if(!casesToUpdate.isEmpty()){
            for(Case c : casesToUpdate){
                if(!String.isBlank(c.AccountId) && !accountMap.values().isEmpty()){
                    Account acc = accountMap.get(c.AccountId);
                    
                    //Populate Case fields based on Account details
                    c.Customer_Type__c = acc.Customer_Type__c;
                    c.Tax_Identification_No__c = acc.Tax_Identification_No__c;

                    if(acc.RecordType.DeveloperName == 'CXE_Individual_Account'){    //For individual accounts
                        c.Full_Name__c = acc.Name;
                        c.Salutation__c = acc.Salutation;
                        c.First_Name__c = acc.FirstName;
                        c.Middle_Name__c = acc.MiddleName;
                        c.Last_Name__c = acc.LastName;
                        //START CSM-12155 Von Pernicia AUG-22-17
                        if (!isRetrieveService)
                        {
                            //START CSM-11451 RReyes JUL-17-17
                            c.Telephone_No__c = acc.PersonHomePhone;
                            c.Mobile_No__c = acc.Mobile_1__pc;
                            //END CSM-11451 RReyes JUL-17-17
                            c.Email_Address__c = acc.PersonEmail;
                        }
                        //END CSM-12155 Von Pernicia AUG-22-17
                        if(acc.PersonBirthdate != null){
                            c.Date_of_Birth__c = acc.PersonBirthdate;
                        }
                        //START CSM-12269 RReyes AUG-18-17 - remove auto-mapping
                        c.Application_for_Business_Customer__c = false;
                        //c.Application_for_Business_Service__c = false;
                        c.Application_for_Residential_Customer__c = true;
                        //c.Application_for_Residential_Service__c = true;
                        //END CSM-12269 RReyes AUG-18-17 - remove auto-mapping
                        
                        //Expected to have no values
                        c.Last_Name_Business_Name__c = '';
                        c.Doing_Business_As__c = '';
                            
                    }else if(acc.RecordType.DeveloperName == 'CXE_Business_Account'){    
                    //For business accounts
                        c.Last_Name_Business_Name__c = acc.Name;
                        c.Doing_Business_As__c = acc.Doing_Business_As__c;
                        c.Conglomerate_Tag__c = acc.Conglomerate__c;
                        //START CSM-12155 Von Pernicia AUG-22-17
                        if (!isRetrieveService)
                        {
                            c.Telephone_No__c = acc.Phone;
                            c.Mobile_No__c = acc.Mobile_Phone__c;
                            c.Email_Address__c = acc.Email__c;
                        }
                        //END CSM-12155 Von Pernicia AUG-22-17
                        //START CSM-12269 RReyes AUG-18-17 - remove auto-mapping
                        c.Application_for_Business_Customer__c = true;
                        //c.Application_for_Business_Service__c = true;
                        c.Application_for_Residential_Customer__c = false;
                        //c.Application_for_Residential_Service__c = false;
                        //END CSM-12269 RReyes AUG-18-17 - remove auto-mapping
                        
                        //Expected to have no values
                        //START CSM-7322 RReyes - do not override name for recontract
                        if(c.RecordTypeId != recontractRecTypeId){
                            c.Full_Name__c = '';
                            c.Salutation__c = acc.Salutation;
                            c.First_Name__c = acc.FirstName;
                            c.Middle_Name__c = acc.MiddleName;
                            c.Last_Name__c = acc.LastName;
                        }
                        //END CSM-7322 RReyes - do not override name for recontract
                    }
                }
            }      
        }
    }
    //END CSM-7189 RReyes JUN-28-17 Populate account fields when account is changed

    /* Description: CSM-7223: Creation of Requirement records
     * Parameters: List<Case>
     * Returns: N/A
     * Author: Von Pernica 
     * Date Created: JUL-03-17
     */
    private void createCaseRequirement(List<Case> newList, Boolean isUpdate) {

        List<Requirement__c> createRequirement = new List<Requirement__c>();
        Set<String> listExistingRequirement = new Set<String>();
        String serviceRequests = '';
        
        for (Requirement__c r: [SELECT  Case__c,
                                        Requirement_Type__c
                                FROM    Requirement__c
                                WHERE   Case__c in: newList])
        {
            listExistingRequirement.add(r.Case__c + r.Requirement_Type__c);
        }

        for (Case c: newList)
        {
            if (!isUpdate)
            {
                // Create Requirement for New Service Application
                if (c.RecordTypeId == newServRecTypeId)
                {
                    createRequirement.addAll(CXE_Utility.createRequirement(CXE_Constants.REQUIREMENT_FOR_NEW_SERVICE_APPLICATION, c.Id, listExistingRequirement));
                }

                // Create Requirement for Termination
                if (c.RecordTypeId == terminateRecTypeId)
                {
                    createRequirement.addAll(CXE_Utility.createRequirement(CXE_Constants.REQUIREMENT_FOR_TERMINATE, c.Id, listExistingRequirement));
                }

                // Create Requirement for Recontract
                if (c.RecordTypeId == recontractRecTypeId)
                {
                    createRequirement.addAll(CXE_Utility.createRequirement(CXE_Constants.REQUIREMENT_FOR_RECONTRACT, c.Id, listExistingRequirement));
                }
            }else
            {
                // Create Requirement for Modification
                if (c.RecordTypeId == modifyRecTypeId 
                && (c.Status == CXE_Constants.CASE_STATUS_APPLICATION_VALIDATED 
                ||  c.Status == CXE_Constants.CASE_APPLICATION_EVALUATED))
                {
                    serviceRequests = c.CXE_Service_Request_s__c != null ? c.CXE_Service_Request_s__c : '';
                    
                    // Combination for Change in Contract Name
                    if (serviceRequests.contains(CXE_Constants.SERVICE_REQ_CHANGE_IN_NAME))
                    {
                        createRequirement.addAll(CXE_Utility.createRequirement(CXE_Constants.REQUIREMENT_FOR_MODIFICATION_CONTRACT_NAME, c.Id, listExistingRequirement));
                        listExistingRequirement.addAll(CXE_Utility.createdRequirements(CXE_Constants.REQUIREMENT_FOR_MODIFICATION_CONTRACT_NAME, c.Id));
                    }
                    
                    // Combination for Additional/Reduction Load
                    if (serviceRequests.contains(CXE_Constants.SERVICE_REQ_ADDITIONAL_LOAD) 
                        || serviceRequests.contains(CXE_Constants.SERVICE_REQ_REDUCTION_LOAD))
                    {
                        createRequirement.addAll(CXE_Utility.createRequirement(CXE_Constants.REQUIREMENT_FOR_MODIFICATION_LOAD, c.Id, listExistingRequirement));
                        listExistingRequirement.addAll(CXE_Utility.createdRequirements(CXE_Constants.REQUIREMENT_FOR_MODIFICATION_LOAD, c.Id));
                    }
                    
                    // Combination for Remodel
                    if (serviceRequests.contains(CXE_Constants.SERVICE_REQ_REMODEL))
                    {
                        createRequirement.addAll(CXE_Utility.createRequirement(CXE_Constants.REQUIREMENT_FOR_MODIFICATION_REMODEL, c.Id, listExistingRequirement));
                        listExistingRequirement.addAll(CXE_Utility.createdRequirements(CXE_Constants.REQUIREMENT_FOR_MODIFICATION_REMODEL, c.Id));
                    }
                    
                    // Combination for Relocation
                    if (serviceRequests.contains(CXE_Constants.SERVICE_REQ_RELOCATION))
                    {
                        createRequirement.addAll(CXE_Utility.createRequirement(CXE_Constants.REQUIREMENT_FOR_MODIFICATION_RELOCATION, c.Id, listExistingRequirement));
                        listExistingRequirement.addAll(CXE_Utility.createdRequirements(CXE_Constants.REQUIREMENT_FOR_MODIFICATION_RELOCATION, c.Id));
                    }
                    
                    // Combination for Transfer of Service Contract
                    if (serviceRequests.contains(CXE_Constants.SERVICE_REQ_TRANSFER))
                    {
                        createRequirement.addAll(CXE_Utility.createRequirement(CXE_Constants.REQUIREMENT_FOR_MODIFICATION_TRANSFER, c.Id, listExistingRequirement));
                        listExistingRequirement.addAll(CXE_Utility.createdRequirements(CXE_Constants.REQUIREMENT_FOR_MODIFICATION_TRANSFER, c.Id));
                    }   
                }
            }
        }
        
        if(!createRequirement.isEmpty()){
            insert createRequirement;
        }
    }
    /* Description: CSM-7270 - Relate account to Service and Billing Address
     * Parameters: List<Case>, Map<Id,Case>, Boolean isUpdated
     * Returns: Void
     * Author: Rom Edison Reyes 
     * Date Created: JUL-05-17
     */
    private void relateAccountToAddress(List<Case> newList, Map<Id, Case> oldMap) {
        Set<Id> caseIds = new Set<Id>();
        List<Address__c> addressesToUpdate = new List<Address__c>();
        for(Case c : newList){
            if(c.RecordTypeId == recontractRecTypeId){
                if(oldMap.containsKey(c.Id)){
                    if(c.AccountId != oldMap.get(c.Id).AccountId){
                        caseIds.add(c.Id);
                    }
                }
            }
        }
        
        if(!caseIds.isEmpty()){
            for(Address__c addr: [SELECT Id, Type__c, Account__c, Case__c, Case__r.AccountId
                                    FROM Address__c
                                    WHERE Case__c in: caseIds 
                                    AND (Type__c = 'Billing' OR Type__c = 'Service')]){
                    addr.Account__c = addr.Case__r.AccountId;
                    addressesToUpdate.add(addr);
                }
        }
        
        if(!addressesToUpdate.isEmpty()){
            try{
                update addressesToUpdate;
            }catch(Exception e){
                ErrorHandlerException.recordException(addressesToUpdate[0].Id, true, 'CaseTriggerHandler', 'relateAccountToAddress', e.getMessage());
            }
        }
    }
        //START CSM-7272 RReyes JUL-06-17 Validate if Account has V10 Customer #
    /* Description: CSM-7140 - Validate if Account has V10 Customer #
     * Parameters: List<Case>, Map<Id, Case>
     * Returns: Void
     * Author: Rom Edison Reyes 
     * Date Created: JUN-22-17
     */
    private void validateIfAccountHasCustomerNumber(List<Case> newList, Map<Id, Case> oldMap, Boolean isUpdate) {
        List<Case> casesToUpdate = new List<Case>();
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Account> accountMap = new Map<Id, Account>();
        Set<Id> accountSet = new Set<Id>(); // Start CSM-12212 Von Pernicia AUG-05-17
        Map<Id, Set<Id>> mapAccountToCase = new Map<Id, Set<Id>>();//START CSM-12544 RReyes SEP-14-17

        for(Case c : newList){
            if(c.RecordTypeId == newServRecTypeId || c.RecordTypeId == modifyRecTypeId || c.RecordTypeId == terminateRecTypeId || c.RecordTypeId == recontractRecTypeId){
                if(isUpdate){
                    if(oldMap.containsKey(c.Id)){
                        if(c.AccountId != oldMap.get(c.Id).AccountId){
                            if(c.AccountId != null){
                                accountIds.add(c.AccountId);
                                casesToUpdate.add(c);
                            }
                        }
                    }
                }else{
                    if(c.AccountId != null){
                        accountIds.add(c.AccountId);
                        casesToUpdate.add(c);
                    }
                }
            }
        }
        
        if(!accountIds.isEmpty()){

            accountMap = new Map<Id, Account>([SELECT Id, 
                                                   V10_Customer_No__c
                                            FROM   Account 
                                            WHERE  Id IN: accountIds]);
            // Start CSM-12212 Von Pernicia AUG-05-17
            for (Case c: [SELECT    AccountId
                          FROM      Case
                          WHERE     AccountId IN: accountIds])
            {
                
                accountSet.add(c.AccountId);
                //START CSM-12544 RReyes SEP-14-17
                if(!mapAccountToCase.containsKey(c.AccountId)){
                    mapAccountToCase.put(c.AccountId, new Set<Id>{c.Id});
                }else{
                    mapAccountToCase.get(c.AccountId).add(c.Id);
                }
                //END CSM-12544 RReyes SEP-14-17
            }
            // End CSM-12212 Von Pernicia AUG-05-17
        }
        
        if(!casesToUpdate.isEmpty()){
            for(Case c : casesToUpdate){
                if(!String.isBlank(c.AccountId) && !accountMap.values().isEmpty()){
                    Account acc = accountMap.get(c.AccountId);
                    
                    //START CSM-12250 Zhu Wenjun AUG-11-17 : use static varible due to trigger fied multiple times by WF
                    if(!isCreateNewAcct)
                    {
                        if(acc.V10_Customer_No__c == null || acc.V10_Customer_No__c == '')
                        {
                            System.debug('>>rr: isUpdate: ' + isUpdate);
                            System.debug('>>rr: accountSet: ' + accountSet);
                            System.debug('>>rr: mapAccountToCase: ' + mapAccountToCase);
                            //START CSM-12544 RReyes SEP-14-17
                            // Start CSM-12212 Von Pernicia AUG-05-17
                            /*if (accountSet.contains(c.AccountId))
                            {
                                c.addError(CXE_Constants.CASE_ERROR_ACCOUNT_WITHOUT_V10_NUM);
                            }*/
                            // End CSM-12212 Von Pernicia AUG-05-17
                            if(mapAccountToCase.containsKey(c.AccountId)){
                                Set<Id> caseIds = mapAccountToCase.get(c.AccountId);
                                System.debug('>>rr: caseIds: ' + caseIds);
                                System.debug('>>rr: c.Id: ' + c.Id);
                                if(caseIds.size() > 1 || (caseIds.size() == 1 && !caseIds.contains(c.Id))){
                                    c.addError(CXE_Constants.CASE_ERROR_ACCOUNT_WITHOUT_V10_NUM);
                                }
                            }
                            //END CSM-12544 RReyes SEP-14-17
                        }
                    }
                    //END CSM-12250 Zhu Wenjun AUG-11-17
                }
            }      
        }
    }
    //END CSM-7189 RReyes JUN-28-17 Populate account fields when account is changed

    //START CSM-7335 RReyes JUL-11-17 - set isUpdatedFromPB? to false
    /* Description: CSM-7335 - Set isUpdatedFromPB? to false
     * Parameters: List<Case>
     * Returns: Void
     * Author: Rom Edison Reyes 
     * Date Created: JUL-11-17
     */
    private void setPBFlagtoFalse(List<Case> newList) {
        for(Case caseRec : newList){
            if(caseRec.isUpdatedFromPB__c){
                caseRec.isUpdatedFromPB__c = false;
            }
        }
    }
    //END CSM-7335 RReyes JUL-11-17 - set isUpdatedFromPB? to false

    //START CSM-7151 RReyes JUL-12-17 - remove deposit schedule if Serv. Rate Type is changed, and is not RS or GSA
    /* Description: CSM-7151 
     * Parameters: List<Case>, Map<Id, Case>
     * Returns: Void
     * Author: Rom Edison Reyes 
     * Date Created: JUL-12-17
     */
    private void removeBillDepositScheduleIfRateTypeIsChanged(List<Case> newList, Map<Id, Case> oldMap) {
        for(Case caseRec : newList){
            if(oldMap.containsKey(caseRec.Id)){
                if(caseRec.Service_Rate_Type__c != oldMap.get(caseRec.Id).Service_Rate_Type__c){
                    if(caseRec.Service_Rate_Type__c != CXE_Constants.SERVICE_RATE_TYPE_RES 
                        && caseRec.Service_Rate_Type__c != CXE_Constants.SERVICE_RATE_TYPE_GSA){
                        //set Deposit Schedule to null if Serv. Rate Type is changed, and is not RS or GSA
                        caseRec.Bill_Deposit_Schedule__c = null;
                    }
                }
            }
        }
    }
    //END CSM-7151 RReyes JUL-12-17 - remove deposit schedule if Serv. Rate Type is changed, and is not RS or GSA

    //START CSM-11457 RReyes JUL-17-17 - transfer CXE_Allow_System_Admins_Only case validation rule in trigger
    /* Description: CSM-11457 
     * Parameters: List<Case>, Map<Id, Case>
     * Returns: Void
     * Author: Rom Edison Reyes 
     * Date Created: JUL-17-17
     */
    private void validateCaseUpdateForNonSysAd(List<Case> newList, Map<Id, Case> oldMap) {
        Set<String> invalidStatus;
        //START CSM-11461 Rhyan Cruz JUL-19-17 - To validate if case update should be exempted
        Set<String> ExemptedStatus;
        boolean IsExempt;
        ExemptedStatus = CXE_Constants.VALID_CASE_STATUS_SUCCEEDING_MULTI;
        //START CSM-11461 Rhyan Cruz JUL-19-17 - To validate if case update should be exempted
        for(Case caseRec : newList){
            //if(!caseRec.isUpdatedFromPB__c && !CXE_Utility.isAdmin()){//START/END CSM-12370 RReyes SEP-04-17
            if(!caseRec.isUpdatedFromPB__c && !isAdmin){//START/END CSM-12370 RReyes SEP-04-17
                if(oldMap.containsKey(caseRec.Id)){
                    invalidStatus = new Set<String>();
                    if(caseRec.RecordTypeId == newServRecTypeId || caseRec.RecordTypeId == modifyRecTypeId 
                        || caseRec.RecordTypeId == recontractRecTypeId){
                        invalidStatus = CXE_Constants.CASE_STATUS_INVALID_TO_EDIT_NON_TERMINATION;
                        
                    }else if(caseRec.RecordTypeId == terminateRecTypeId){
                        invalidStatus = CXE_Constants.CASE_STATUS_INVALID_TO_EDIT_TERMINATION;
                    }

                    //START CSM-11461 Rhyan Cruz JUL-19-17 - To validate if case update should be exempted
                    IsExempt = false;
                    if (ExemptedStatus.contains(oldMap.get(caseRec.Id).Status)) {
                        //Status
                        if(caseRec.Status != oldMap.get(caseRec.Id).Status){
                            IsExempt = true;
                        }
                        //Reason for Cancellation
                        //if(caseRec.CXE_Reason_for_Cancellation__c != oldMap.get(caseRec.Id).CXE_Reason_for_Cancellation__c){
                        if(caseRec.CXE_Reason_for_Cancellation__c != null){
                            IsExempt = true;
                        }
                        //Request for Application Cancellation
                        if(caseRec.CXE_Request_for_Application_Cancellation__c != oldMap.get(caseRec.Id).CXE_Request_for_Application_Cancellation__c){
                            IsExempt = true;
                        }
                        //Application Cancellation Date
                        if(caseRec.CXE_Application_Cancellation_Date__c != oldMap.get(caseRec.Id).CXE_Application_Cancellation_Date__c){
                            IsExempt = true;
                        }

                        // Start CSM-11437 Von Pernicia JUL-21-17
                        //Start CSM-11924 
                        if(caseRec.CXE_Request_GSL4_TargetDate_Modification__c != oldMap.get(caseRec.Id).CXE_Request_GSL4_TargetDate_Modification__c){
                            IsExempt = true;
                        }

                        if(caseRec.Reason_for_GSL4_Target_Date_Modification__c != oldMap.get(caseRec.Id).Reason_for_GSL4_Target_Date_Modification__c){
                            IsExempt = true;
                        }

                        if(caseRec.New_GSL4_Target_Date__c != oldMap.get(caseRec.Id).New_GSL4_Target_Date__c){
                            IsExempt = true;
                        }

                        if(caseRec.GSL4_Check__c != oldMap.get(caseRec.Id).GSL4_Check__c){
                            IsExempt = true;
                        }

                        if(caseRec.GSL4_Target_Date__c != oldMap.get(caseRec.Id).GSL4_Target_Date__c){
                            IsExempt = true;
                        }

                        if(caseRec.CXE_G3_Approver__c != oldMap.get(caseRec.Id).CXE_G3_Approver__c){
                            IsExempt = true;
                        }

                        if(caseRec.CXE_G4_Approver__c != oldMap.get(caseRec.Id).CXE_G4_Approver__c){
                            IsExempt = true;
                        }
                        //end CSM-11924 
                        // End CSM-11437 Von Pernicia JUL-21-17
                    }    
                    //START CSM-11461 Rhyan Cruz JUL-19-17 - To validate if case update should be exempted
                    
                    if(invalidStatus.contains(oldMap.get(caseRec.Id).Status) && !IsExempt){
                        caseRec.addError(CXE_Constants.CASE_ERROR_MESSAGE_ALLOW_SYSTEM_ADMIN_ONLY);
                    }
                }
            }
        }
    }
    //END CSM-11457 RReyes JUL-17-17 - transfer CXE_Allow_System_Admins_Only case validation rule in trigger
    /* Description: Populate Account fields when reusing existing Account and Contact (CSM-6123)
* Parameters: List<Case>
* Returns: Void
* Author: Rhyan Cruz
* Date Created: Jun-24-17
*     Revisions:
*           11.06.2017     CSM-14238 GGrandea    adding oldCaseMap
*/
    public void populateAccountDOBCustType(List<Case> caseList, Map<Id, Case> oldCaseMap){ //CSM-14238
        
        Set<Id> accountIds = new Set<Id>();
        //START CSM-14238 GGrandea 11.06.2017
        //List<Account> accountList = new List<Account>();
        List<Case> newCaseList = new List<Case>();
        Map<Id, Account> mapAcctToUpd = new Map<Id, Account>();
        //END CSM-14238
    
        for(Case c: caseList){
            
            //START CSM-14238 GGrandea 11.06.2017
            /*if(!String.isBlank(c.AccountId)){
                accountIds.add(c.AccountId);
            }*/
            if(!String.isBlank(c.AccountId) && (c.RecordTypeId == newServRecTypeId || c.RecordTypeId == recontractRecTypeId)
                && (c.Customer_Type__c != oldCaseMap.get(c.Id).Customer_Type__c ||
                    c.Date_of_Birth__c != oldCaseMap.get(c.Id).Date_of_Birth__c ||
                    c.Tax_Identification_No__c != oldCaseMap.get(c.Id).Tax_Identification_No__c))
            {
                accountIds.add(c.AccountId);
                newCaseList.add(c);
            }
            //END CSM-14238
            
        }
    
        if(!newCaseList.isEmpty()) //CSM-14238
        {
        
            //Retrieve Account details related to Case
            Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, 
                                                                Customer_Type__c, 
                                                                PersonBirthdate,
                                                                Tax_Identification_No__c, 
                                                                isPersonAccount
                                                                FROM   Account 
                                                                WHERE  Id IN: accountIds]);
            
            if(!accountMap.values().isEmpty()) //CSM-14238
            { 
            
                for(Case c: newCaseList){
                    
                    /* //CSM-14238 disable code
                    if(!String.isBlank(c.AccountId) && 
                       !accountMap.values().isEmpty()){
                           
                           Account acc = accountMap.get(c.AccountId);
                           
                           //Populate Account fields based on Case details
                           if(String.isBlank(acc.Customer_Type__c) || acc.Customer_Type__c != c.Customer_Type__c){
                               acc.Customer_Type__c = c.Customer_Type__c;
                           }
                           
                           if(!String.isBlank(acc.Tax_Identification_No__c) || acc.Tax_Identification_No__c != c.Tax_Identification_No__c){
                               acc.Tax_Identification_No__c = c.Tax_Identification_No__c;
                           }
                           
                           if(acc.isPersonAccount){    //For individual accounts
                               
                               if(acc.PersonBirthdate == null || acc.PersonBirthdate != c.Date_of_Birth__c){
                                   acc.PersonBirthdate = c.Date_of_Birth__c;
                               }
                           }
                           
                           //add to list for update 
                           accountList.add(acc);   
                       } */ 
                    
                    //START CSM-14238 GGrandea 11.06.2017
                    Account acc = accountMap.get(c.AccountId);
                    Boolean hasUpdate = false;
    
                    if(String.isBlank(acc.Customer_Type__c) || (acc.Customer_Type__c != c.Customer_Type__c && String.isNotBlank(c.Customer_Type__c)))
                    {
                        acc.Customer_Type__c = c.Customer_Type__c;
                        hasUpdate = true;
                    }
    
                    if(String.isBlank(acc.Tax_Identification_No__c) || (acc.Tax_Identification_No__c != c.Tax_Identification_No__c && String.isNotBlank(c.Tax_Identification_No__c)))
                    {
                        acc.Tax_Identification_No__c = c.Tax_Identification_No__c;
                        hasUpdate = true;
                    }
    
                    if(acc.isPersonAccount 
                        && ( acc.PersonBirthdate == null || (acc.PersonBirthdate != c.Date_of_Birth__c && c.Date_of_Birth__c != null ) ) )
                    {
                        hasUpdate = true;   
                        acc.PersonBirthdate = c.Date_of_Birth__c;
                    }
                    
                    if(hasUpdate)
                        mapAcctToUpd.put(acc.Id, acc);  
                    //END CSM-14238
                    
                }
                
                //START CSM-14238
                /*if (accountList.size() > 0) {
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    dmo.assignmentRuleHeader.useDefaultRule = true;
                    Database.update(accountList, dmo);
                }*/
                update mapAcctToUpd.values(); 
                //END CSM-14238
            }
        }
    }
    
    //START CSM-XXXX RReyes JUL-21-17 - R2B set email recipient for notif
    //START CSM-12224 Von Pernicia AUG-07-17
    /* Description: Fire an error message if previous SIN has existing case 
     * Parameters: List<Case>
     * Returns: Void
     * Author: Von Pernicia 
     * Date Created: AUG-07-17
     */
    private void validatePrevSIN(List<Case> newList) {

        Map<String, Case> prevSIN = new Map<String, Case>();
        Map<String, String> serviceMap = new Map<String, String>();
        Map<String, String> caseMap = new Map<String, String>();
        

        for (Case c: newList)
        {
            if (c.Status <> CXE_Constants.CASE_APPLICATION_CANCELLED && c.RecordTypeId == recontractRecTypeId && String.isNotBlank(c.CXE_Previous_SIN__c))
            {

                prevSIN.put(c.CXE_Previous_SIN__c, c);
                
            }
        } 

        if(!prevSIN.isEmpty())
        {
            for (Case checkReconCase: [SELECT   Id,
                                                Status,
                                                CXE_Previous_SIN__c
                                       FROM     Case
                                       WHERE    CXE_Previous_SIN__c in: prevSIN.keySet() and RecordTypeId =: recontractRecTypeId])
            {
                if (prevSIN.get(checkReconCase.CXE_Previous_SIN__c).Id <> checkReconCase.Id)
                {
                    if (checkReconCase.Status == CXE_Constants.CASE_APPLICATION_CLOSED)
                    {
                        caseMap.put(checkReconCase.CXE_Previous_SIN__c, CXE_Constants.CASE_ERROR_SIN_ALREADY_RECONTRACTED); // Recontract where status is Application Closed
                    }
                    else if (checkReconCase.Status != CXE_Constants.CASE_APPLICATION_CANCELLED) // START/END CSM-12253 Von Pernicia
                    {
                        caseMap.put(checkReconCase.CXE_Previous_SIN__c, CXE_Constants.CASE_MODIFICATION_ERROR_DUPLICATE_OR_PENDING_CASE_EXIST); // Recontract where status is still intransit
                    }
                }
            }

            for (Agreement__c a: [SELECT    Service_Status__c,
                                            SIN__c
                                  FROM      Agreement__c
                                  WHERE     SIN__c in: prevSIN.keySet()])
            {
                serviceMap.put(a.SIN__c, a.Service_Status__c);
            }
            
            for (Case c: newList)
            {
                if (serviceMap.get(c.CXE_Previous_SIN__c) == CXE_Constants.SERVICE_STATUS_ACTIVE)
                {
                    c.adderror(CXE_Constants.CASE_ERROR_ONLY_TERMINATED);
                }

                if (caseMap.containsKey(c.CXE_Previous_SIN__c))
                { 
                    c.adderror(caseMap.get(c.CXE_Previous_SIN__c));
                }
            } 
        } 
    }
    //End CSM-12224 Von Pernicia AUG-07-17

    //START CSM-12251 RReyes AUG-11-17 - commentedOut by RReyes
    //START CSM-12223 RReyes AUG-08-17
    /* Description: Require clicking 'Retrieve Outstanding Amount' button before Application Evaluated 
     * Parameters: List<Case>
     * Returns: Void
     * Author: Rom Edison Reyes
     * Date Created: AUG-08-17
     */
     /*
    private void validateClickRetrieveOutstandingAmount(List<Case> newList, Map<Id, Case> oldMap) {
        Boolean isAdmin = isAdministrator;
        for (Case c: newList){
            if(!c.isUpdatedFromPB__c && !isAdmin){
                Case oldCase = oldMap.get(c.Id);
                if(!c.CXE_isRequireArrears__c && (c.RecordTypeId == modifyRecTypeId || c.RecordTypeId == terminateRecTypeId || c.RecordTypeId == recontractRecTypeId)
                    && (oldCase.Status == CXE_Constants.CASE_PRE_SURVEY_FO_FEASIBLE || oldCase.Status == CXE_Constants.CASE_PRE_SURVEY_FO_NOTREQUIRED)){
                    c.addError(CXE_Constants.CASE_ERROR_CLICK_RETRIEVE_BUTTON);
                }     
            }
        }
    }
    //END CSM-12223 RReyes AUG-08-17

    //START CSM-12217 RReyes AUG-08-17
    /* Description: Require to click 'Update Bill Deposit" button when applied load is greater that 5
     * Parameters: List<Case>
     * Returns: Void
     * Author: Rom Edison Reyes
     * Date Created: AUG-08-17
     */
     /*
    private void validateClickUpdateBillDeposit(List<Case> newList, Map<Id, Case> oldMap) {
        Boolean isAdmin = isAdministrator;
        for (Case c: newList){
            if(!c.isUpdatedFromPB__c && !isAdmin){
                Case oldCase = oldMap.get(c.Id);
                if(c.RecordTypeId == modifyRecTypeId || c.RecordTypeId == recontractRecTypeId || c.RecordTypeId == newServRecTypeId){
                    if(c.Applied_Load__c != null){
                        if(c.Applied_Load__c > 5 
                            && (c.Applied_Load__c != oldCase.Applied_Load__c
                            || c.Demand_Factor__c != oldCase.Demand_Factor__c 
                            || c.Load_Factor__c != oldCase.Load_Factor__c)
                            && c.Status != oldCase.Status && (c.Status == CXE_Constants.CASE_STATUS_SERVICE_ENTR_STILL_OK || c.Status == CXE_Constants.CASE_AMC_SERVICE_COMPLETED)){
                            c.addError(CXE_Constants.CASE_ERROR_SAVE_CONTRACTED_CAPACITY + c.Status);
                        }else if(c.CXE_isClickBillDepositButton__c 
                            && c.Applied_Load__c > 5 
                            && c.Applied_Load__c == oldCase.Applied_Load__c && c.Demand_Factor__c == oldCase.Demand_Factor__c && c.Load_Factor__c == oldCase.Load_Factor__c
                            && c.Status != oldCase.Status 
                            && (c.Status == CXE_Constants.CASE_STATUS_SERVICE_ENTR_STILL_OK || c.Status == CXE_Constants.CASE_AMC_SERVICE_COMPLETED)){
                            c.addError(CXE_Constants.CASE_ERROR_CLICK_UPDATE_BILL_DEPOSIT_WITH_STATUS + c.Status);
                        }
                    }
                }
            }
        }
    }
    //END CSM-12217 RReyes AUG-08-17
    */
    //END CSM-12251 RReyes AUG-11-17 - commentedOut by RReyes

    //START CSM-12249 Von Pernicia AUG-10-17
    /* Description: Require to Birthday if case is Individual
     * Parameters: List<Case>
     * Returns: Void
     * Author: Von Pernicia
     * Date Created: AUG-10-17
     */
    private void checkBirthdayIfBlank(List<Case> newList, Boolean isUpdate, Map<Id, Case> oldCaseMapping) 
    {
        //if (UserInfo.getUserId() == '005N0000003AsEZIA0')
        //{
            for (Case c: newList)
            {
                if (c.Date_of_Birth__c == null 
                && c.Application_for_Residential_Customer__c
                && !c.Application_for_Business_Customer__c)
                {
                    if (c.RecordTypeId == newServRecTypeId)
                    {
                        if (c.AccountId == null) 
                        {
                            c.addError(CXE_Constants.CASE_ERROR_REQUIRE_BIRTHDAY);
                        }
                    }

                    if (isUpdate && (c.RecordTypeId == modifyRecTypeId
                    || c.RecordTypeId == recontractRecTypeId) 
                    && !isRetrieveService)
                    {
                        if (c.CXE_Pending_Requirement_count__c == oldCaseMapping.get(c.Id).CXE_Pending_Requirement_count__c)
                        {
                            c.addError(CXE_Constants.CASE_ERROR_REQUIRE_BIRTHDAY);
                        }
                    }
                }
            }
        //}
    }
    //End CSM-12249 Von Pernicia AUG-10-17

    //START CSM-12252 on Pernicia AUG-10-17
    /* Description: Set change in rate check box if rate type in case and not equal to service
     * Parameters: List<Case>
     * Returns: Void
     * Author: Von Pernicia
     * Date Created: AUG-11-17
     */
    private void isChangeinRate(List<Case> newList) 
    {
        //List<Id> serviceIds = new List<Id>();
        //Map<Id, String> serviceMap = new Map<Id, String>();

        for (Case c: newList)
        {
            if (c.RecordTypeId == modifyRecTypeId || c.RecordTypeId == recontractRecTypeId)
            {
                if (c.CXE_Orig_Code_Service_Rate_Type__c <> c.Code_Service_Rate_Type__c)
                {
                    c.CXE_Change_in_Service_Rate__c = true;
                }
                else
                {
                    c.CXE_Change_in_Service_Rate__c = false;
                }
            }
        }
    }
    //End CSM-12252 Von Pernicia AUG-10-17

    //START CSM-12277 RReyes AUG-17-17
     /* Description: Transferred CXE_Reason_for_Manual_Deposit case validation rule to trigger
     * Reason for Manual Deposit should be populated when the Required Deposit Amount is manually changed
     * Parameters: List<Case>, Map<Id, Case>, Boolean
     * Returns: Void
     * Author: Rom Edison Reyes
     * Date Created: AUG-17-17
     */
    private void validateChangeInRequiredBD(List<Case> lstNewCase, Map<Id, Case> mapOldCase){
        for(Case caseRec : lstNewCase){
            Case oldCase =  mapOldCase.get(caseRec.Id);
            if(caseRec.CXE_Required_Deposit_Amount__c != oldCase.CXE_Required_Deposit_Amount__c
                && caseRec.Deposit_Amount__c == oldCase.Deposit_Amount__c
                && (caseRec.Reason_for_Manual_Deposit_Input__c == '' || caseRec.Reason_for_Manual_Deposit_Input__c == null)){
                caseRec.addError(CXE_Constants.CASE_ERROR_PROVIDE_REASON);
            }
        }
    }

    /* Description: Convert workflow of Required Bill Deposit Calculation to Trigger
     * Parameters: List<Case>, Map<Id, Case>, Boolean
     * Returns: Void
     * Author: Rom Edison Reyes
     * Date Created: AUG-17-17
     */
    private void calculateRequiredBD(List<Case> lstNewCase, Map<Id, Case> mapOldCase, Boolean isUpdate){
        List<Case> casesToUpdate = new List<Case>();
        Decimal adtlBD = 0, requiredBD = 0;
        Integer roundBD = 0;
        String serviceRequests = '';
        if(isUpdate){
            for(Case caseRec: lstNewCase){
                //START CSM-12374 RReyes AUG-31-17 - filter record types to MSA, TSA and RSA only
                if(caseRec.RecordTypeId == modifyRecTypeId 
                    || caseRec.RecordTypeId == terminateRecTypeId
                     || caseRec.RecordTypeId == recontractRecTypeId){
                    Case oldCase =  mapOldCase.get(caseRec.Id);
                    if(caseRec.Applied_Load__c != null){
                        if(caseRec.CXE_Service_Request_s__c != oldCase.CXE_Service_Request_s__c && caseRec.Applied_Load__c > 5){
                            caseRec.CXE_isClickBillDepositButton__c = true;
                        }
                    }
                    if(caseRec.CXE_Existing_Bill_Deposit_Amount__c != oldCase.CXE_Existing_Bill_Deposit_Amount__c ||
                        caseRec.CXE_Service_Request_s__c != oldCase.CXE_Service_Request_s__c ||
                        caseRec.Deposit_Amount__c != oldCase.Deposit_Amount__c){
                            casesToUpdate.add(caseRec);
                    }
                }
                //END CSM-12374 RReyes AUG-31-17 - filter record types to MSA, TSA and RSA only
            }
        }else{
            //START CSM-12374 RReyes AUG-31-17 - filter record types to MSA, TSA and RSA only
            for(Case caseRec: lstNewCase){
                if(caseRec.RecordTypeId == modifyRecTypeId 
                    || caseRec.RecordTypeId == terminateRecTypeId
                     || caseRec.RecordTypeId == recontractRecTypeId){
                    casesToUpdate.add(caseRec);
                }
            }
            //END CSM-12374 RReyes AUG-31-17 - filter record types to MSA, TSA and RSA only
        }

        //START CSM-12374 RReyes AUG-31-17 - filter record types to MSA, TSA and RSA only
        if(!casesToUpdate.isEmpty()){
            for(Case c : casesToUpdate){
                serviceRequests = '';
                adtlBD = 0;
                requiredBD = 0;

                if(c.CXE_Service_Request_s__c != null){
                    serviceRequests = String.valueOf(c.CXE_Service_Request_s__c);
                }
                
                if(c.CXE_Existing_Bill_Deposit_Amount__c != null && c.CXE_Existing_Bill_Deposit_Amount__c != 0 && c.Deposit_Amount__c != null){
                    adtlBD = ((c.Deposit_Amount__c - c.CXE_Existing_Bill_Deposit_Amount__c) / c.CXE_Existing_Bill_Deposit_Amount__c) * 100;
                }

                if(c.Deposit_Amount__c != null && c.CXE_Existing_Bill_Deposit_Amount__c != null){
                    if(c.RecordTypeId != modifyRecTypeId || c.CXE_Change_in_Service_Rate__c 
                    || serviceRequests.contains(CXE_Constants.SERVICE_REQ_TRANSFER)){
                        requiredBD = c.Deposit_Amount__c;
                    }else if(adtlBD > 10 && serviceRequests.contains(CXE_Constants.SERVICE_REQ_ADDITIONAL_LOAD)){
                        requiredBD = c.Deposit_Amount__c - c.CXE_Existing_Bill_Deposit_Amount__c;
                    }
                    //round off to nearest tenths
                    roundBD = Integer.valueOf(requiredBD);
                    requiredBD = (Math.mod(roundBD,10) == 0 ? roundBD : (Math.mod(roundBD,10) < 5 ? roundBD- Math.mod(roundBD,10): roundBD - Math.mod(roundBD,10) + 10));
                }
                
                //Start CSM-14274 Rhyan Cruz 11102017
                if(c.CXE_Existing_Bill_Deposit_Amount__c == null || c.CXE_Existing_Bill_Deposit_Amount__c == 0){
                    requiredBD = c.CXE_ComputedRequiredDeposit__c;
                }
                //End CSM-14274 Rhyan Cruz 11102017
                
                c.CXE_Required_Deposit_Amount__c = requiredBD;
            }
        }
        //END CSM-12374 RReyes AUG-31-17 - filter record types to MSA, TSA and RSA only
    }
    //END CSM-12277 RReyes AUG-17-17

    //START CSM-12279 RReyes AUG-18-17
    /* Description: Converted Flipping of MSA Application Approved from PB to Trigger
     * Parameters: List<Case>, Map<Id, Case>
     * Returns: Void
     * Author: Rom Edison Reyes
     * Date Created: AUG-17-17
     */
    private void flipToApplicationApprovedMSA(List<Case> lstNewCase){
        Set<Id> casesWithTransferOfService = new Set<Id>();
        List<Case> lstCasesWithTransferOfService = new List<Case>();
        List<Case> casesValidForFlipping= new List<Case>();
        String serviceRequests = '';
        Boolean isValidToFlip;

        //START iteration to check valid cases for flipping
        for(Case caseRec : lstNewCase) {
            if(caseRec.RecordTypeId == modifyRecTypeId 
              && caseRec.CXE_isRequireArrears__c && !caseRec.Arrears_Tag__c && !caseRec.CXE_isClickBillDepositButton__c
              && (caseRec.Status == CXE_Constants.CASE_STATUS_SERVICE_ENTR_STILL_OK 
                || caseRec.Status == CXE_Constants.INSPECTION_FO_RESOLVED_APPROVED
                || caseRec.Status == CXE_Constants.CASE_AMC_SERVICE_COMPLETED)
              && caseRec.CXE_Pending_Requirement_count__c == 0)
            {
                isValidToFlip = true;
                serviceRequests = caseRec.CXE_Service_Request_s__c != null ? String.valueOf(caseRec.CXE_Service_Request_s__c) : '';

                //Change in Contract Name
                if(serviceRequests.contains(CXE_Constants.SERVICE_REQ_CHANGE_IN_NAME)
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

                //Transfer of Service
                //START CSM-12370 RReyes SEP-05-17 - rollback criteria to require contract if case has change in rate
                if(serviceRequests.contains(CXE_Constants.SERVICE_REQ_TRANSFER) && isValidToFlip){
                    casesWithTransferOfService.add(caseRec.Id);
                    lstCasesWithTransferOfService.add(caseRec);
                }
                //END CSM-12370 RReyes AUG-31-17 - rollback criteria to require contract if case has change in rate

                if(isValidToFlip){
                  casesValidForFlipping.add(caseRec);
                }
            }
        }
        //END iteration to check valid cases for flipping


        if(!casesValidForFlipping.isEmpty()){
          //START flip status if service request does not contain Transfer of Service
          for(Case caseRec : casesValidForFlipping){
            if(casesWithTransferOfService.isEmpty() 
              || (!casesWithTransferOfService.isEmpty() 
                && !casesWithTransferOfService.contains(caseRec.Id))){
              caseRec.Status = CXE_Constants.CASE_APPLICATION_APPROVED;
              caseRec.CXE_StatusPath__c = 'Complete';
            }
          }
          //END flip status if service request does not contain Transfer of Service

          //START validate contract of cases with Transfer of Service
          if(!casesWithTransferOfService.isEmpty() && casesWithTransferOfService.size() > 0){
            Set<Id> casesWithContract = new Set<Id>();
            List<Contract> contractList = [SELECT Id, Case__c FROM Contract 
                                            WHERE Case__c 
                                            IN: casesWithTransferOfService];

            //START CSM-11942 GGrandea AUG-28-2017 - Adding Reuse of Contract on Case record
            if(contractList != null){
              for(Contract contr : contractList){
                casesWithContract.add(contr.Case__c);
              }
            }

            for(Case caseRec : lstCasesWithTransferOfService){
                if(casesWithContract.contains(caseRec.Id) || caseRec.Legacy_Account_Number__c!=null){
                    caseRec.Status = CXE_Constants.CASE_APPLICATION_APPROVED;
                    caseRec.CXE_StatusPath__c = 'Complete';
                }
            }
            //END CSM-11942 GGrandea AUG-28-2017
          }
          //END validate contract of cases with Transfer of Service
        }
    }
    //END CSM-12279 RReyes AUG-18-17

    //START RReyes SEP-02-17 CSM-12370- check if case is required to automatically create Service Address
    /* Description: Cread Service Address based on selected service
     * Parameters: List<Case>, Map<Id, Case>, Boolean
     * Returns: void
     * Author: Rom Edison Reyes
     * Date Created: SEP-02-17
     */
    private void checkAutoCreateServiceAddress(List<Case> lstNewCase, Map<Id, Case> mapOldCase, Boolean isUpdate){
        Map<String, String> mapCaseToService = new Map<String, String>();
        for(Case c : lstNewCase){
            if(c.RecordTypeId == modifyRecTypeId && c.CXE_Service__c != null){
                if(isUpdate){
                    Case oldCase = mapOldCase.get(c.Id);
                    if((c.CXE_Service_Request_s__c.contains(CXE_Constants.SERVICE_REQ_TRANSFER) 
                            && !oldCase.CXE_Service_Request_s__c.contains(CXE_Constants.SERVICE_REQ_TRANSFER)) || 
                            (c.CXE_Change_in_Service_Rate__c && !oldCase.CXE_Change_in_Service_Rate__c)
                    ){
                        mapCaseToService.put(c.Id, c.CXE_Service__c);
                    }
                }else{
                    if(c.CXE_Service_Request_s__c.contains(CXE_Constants.SERVICE_REQ_TRANSFER)){
                        mapCaseToService.put(c.Id, c.CXE_Service__c);
                    }
                }
            }
        }

        if(!mapCaseToService.isEmpty()){
            autoCreateServiceAddress(mapCaseToService);
        }
    }

    /* Description: Cread Service Address based on selected service
     * Parameters: Map<String, String>
     * Returns: void
     * Author: Rom Edison Reyes
     * Date Created: SEP-02-17
     */
     @future
    static void autoCreateServiceAddress(Map<String, String> mapCaseToService){
        List<String> serviceIds = new List<String>();
        Set<String> caseIds = new Set<String>();
        Set<Id> serviceToCaseSet = new Set<Id>();
        String servId;
        Map<String, String> serviceToAddressMap = new Map<String, String>();
        Map<String, String> serviceToLandmarkMap = new Map<String, String>();
        Map<String, String> serviceToProvinceMap = new Map<String, String>(); 
        Map<String, String> serviceToCityMap = new Map<String, String>(); 
        Map<String, String> serviceToBarangayMap = new Map<String, String>();
        Map<String, String> serviceToSubdMap = new Map<String, String>(); 
        Map<String, String> serviceToStreetMap = new Map<String, String>(); 
        Map<String, String> serviceToPremiseTypeMap = new Map<String, String>();
        Map<String, String> serviceToUnitNoMap = new Map<String, String>();
        Map<String, String> serviceToStreetNoMap = new Map<String, String>();
        List<Address__c> serviceAddressList = new List<Address__c>();

        serviceIds = mapCaseToService.values();
        caseIds = mapCaseToService.keySet();
        if(!serviceIds.isEmpty())
        {        
            List<Address__c> lstAdd = [SELECT Id, 
                                        Service__c, 
                                        Address_Unit_No__c, 
                                        Address_Street_No__c,
                                        Address_Province__c,  
                                        Address_City_Municipality__c,
                                        Address_Barangay__c, 
                                        Address_Street_Name__c, 
                                        Address_Subdivision__c,
                                        Premise_Type__c,
                                        Landmarks_Directions__c
                                        FROM Address__c 
                                        WHERE Service__c IN:serviceIds AND Type__c =: CXE_Constants.ADDRESS_TYPE_SERVICE];
            
            for(Address__c address : lstAdd){
                servId = address.Service__c;
                if(!serviceToAddressMap.containsKey(servId)){
                    serviceToLandmarkMap.put(servId, address.Landmarks_Directions__c);
                    serviceToProvinceMap.put(servId, address.Address_Province__c); 
                    serviceToCityMap.put(servId, address.Address_City_Municipality__c); 
                    serviceToBarangayMap.put(servId, address.Address_Barangay__c); 
                    serviceToSubdMap.put(servId, address.Address_Subdivision__c); 
                    serviceToStreetMap.put(servId, address.Address_Street_Name__c); 
                    serviceToPremiseTypeMap.put(servId, address.Premise_Type__c); 
                    serviceToUnitNoMap.put(servId, address.Address_Unit_No__c); 
                    serviceToStreetNoMap.put(servId, address.Address_Street_No__c); 
                }
            }
                    
            for(Address__c address : [SELECT Case__c
                                      FROM   Address__c 
                                      WHERE  Case__c IN:caseIds AND Type__c =: CXE_Constants.ADDRESS_TYPE_SERVICE])
            {
                serviceToCaseSet.add(address.Case__c);
            }

            for(String caseId : caseIds){ 
                if(!serviceToCaseSet.contains(caseId) && mapCaseToService.containsKey(caseId))
                {   
                    String caseServiceId = mapCaseToService.get(caseId);
                    if (serviceToStreetNoMap.containsKey(caseServiceId))
                    {                   
                        Address__c add = new Address__c(
                            Case__c = caseId, 
                            Address_Unit_No__c = serviceToUnitNoMap.get(caseServiceId), 
                            Address_Street_No__c = serviceToStreetNoMap.get(caseServiceId),
                            Address_Province__c = serviceToProvinceMap.get(caseServiceId),  
                            Address_City_Municipality__c = serviceToCityMap.get(caseServiceId),
                            Address_Barangay__c = serviceToBarangayMap.get(caseServiceId), 
                            Address_Street_Name__c = serviceToStreetMap.get(caseServiceId), 
                            Address_Subdivision__c = serviceToSubdMap.get(caseServiceId),
                            Premise_Type__c = serviceToPremiseTypeMap.get(caseServiceId),
                            Landmarks_Directions__c = serviceToLandmarkMap.get(caseServiceId),
                            Type__c = CXE_Constants.ADDRESS_TYPE_SERVICE
                        );
                        serviceAddressList.add(add);
                    }
                }
            }
            
            if (serviceAddressList.size() > 0)
            {
                try{
                    insert serviceAddressList;
                }catch(Exception e){
                    ErrorHandlerException.recordException(null, true, 'CaseTriggerHandler', 'autoCreateServiceAddress', e.getMessage());
                }
            }
        }
    }
    //END RReyes SEP-02-17 CSM-12370- check if case is required to automatically create Service Address
    /* Description: CSM-XXXX - R2B set email recipient for notif
* Parameters: List<Case>
* Returns: Void
* Author: Rom Edison Reyes 
* Date Created: JUL-21-17
*/
    private void populateBusinessEmailForNotif(List<Case> newList) {
        Set<Id> servIds = new Set<Id>();
        Map<Id, Agreement__c> serviceMap = new Map<Id, Agreement__c>();
        for(Case caseRec : newList){
            if(caseRec.RecordTypeId == portalRegRecTypeId){
                if(caseRec.CXE_Service__c != null){
                    servIds.add(caseRec.CXE_Service__c);
                }
            }
        }
        
        if(!servIds.isEmpty()){
            serviceMap = new Map<Id, Agreement__c>([SELECT Id,
                                                    Payor__r.Account.Owner.Email
                                                    FROM Agreement__c
                                                    WHERE Id in:servIds]);
        }
        
        for(Case caseRec : newList){
            if(caseRec.RecordTypeId == portalRegRecTypeId && caseRec.CXE_Service__c != null){
                if(!serviceMap.keySet().isEmpty()){
                    if(serviceMap.containsKey(caseRec.CXE_Service__c)){
                        Agreement__c ser = serviceMap.get(caseRec.CXE_Service__c); 
                        if(ser.Payor__r.Account.Owner.Email != null){
                            caseRec.Business_Email__c = ser.Payor__r.Account.Owner.Email;
                        }
                    }
                }
            }
        }
    }
    //END CSM-12217 RReyes AUG-08-17
    //END CSM-XXXX RReyes JUL-21-17 - R2B set email recipient for notif
    

    /* Description: CSM-XXXX - R2B set email recipient for notif
* Parameters: List<Case>
* Returns: Void
* Author: Von Pernicia 
* Date Created: JUL-28-17
* Revisions:
*       09.13.2017      GGrandea    CSM-12543       added oldMap variable
*/
    private void updateContractBillPrintMode(List<Case> newList, Map<id, Case> oldMap) {
        
        Set<Id> contractIds = new Set<Id>();
        Map<String, String> bpmMap = new Map<String, String>();
        Map<Id, String> bpReasonMap = new Map<Id, String>();
        
        if (!isRecurssion){ //CSM-14747 Mike Verdad 12/08/17
            
            for(Case caseRec: newList)
            {
                if(caseRec.RecordTypeId == paperlessRecTypeId && caseRec.Contract__c != null && caseRec.Status == 'Successful'
                   && (oldMap==null || oldMap.get(caseRec.Id).Status!=caseRec.Status ) ) //CSM-12543 modified condition
                {
                    //START CSM-12599 GGrandea 09.18.2017
                    contractIds.add(caseRec.Contract__c);
                    //bpmMap.put(caseRec.Contract__c, caseRec.CXE_Bill_Print_Mode__c);
                    if(caseRec.Application_Type_Subtype__c==CXE_Constants.CASE_PAPERLESSBILLING_TYPE_SUB){
                        bpmMap.put(caseRec.Contract__c, CXE_Constants.BPM_PAPERLESS);
                    }
                    if(caseRec.Application_Type_Subtype__c==CXE_Constants.CASE_PAPERLESSBILLING_TYPE_CANCEL){
                        bpmMap.put(caseRec.Contract__c, CXE_Constants.BPM_PAPERPLUS);
                        //START CSM-12954 GGrandea 09.26.2017
                        if(String.isEmpty(caseRec.CXE_Others_Cancellation_Reason__c)){
                            bpReasonMap.put(caseRec.Contract__c, caseRec.CXE_Paperless_BillingCancellationReason__c);
                        }
                        else{
                            bpReasonMap.put(caseRec.Contract__c, caseRec.CXE_Others_Cancellation_Reason__c);
                        }
                        //END CSM-12954 GGrandea 09.26.2017
                    }
                    //END CSM-12599 GGrandea 09.18.2017
                }
            }
            //START CSM-12476 RReyes SEP-14-17 - added condition to check contractIds if not null
            if(!contractIds.isEmpty()){
                //START CSM-12954 GGrandea 09.26.2017
                //relateServiceAddress(contractIds, bpmMap);
                CXE_CP_BillPrintModeIntegrationUtility.relateServiceAddress(contractIds, bpmMap, bpReasonMap);
                //END CSM-12954 GGrandea 09.26.2017
                isRecurssion = true;//CSM-14747 Mike Verdad 12/08/17
            }
            //END CSM-12476 RReyes SEP-14-17 - added condition to check contractIds if not null
        }//CSM-14747 Mike Verdad 12/08/17
    }
    
    //START CSM-12954 GGrandea 09.26.2017 disable code; transferred to CXE_CP_BillPrintModeIntegrationUtility
    /*@future(callout=true)
    public static void relateServiceAddress(Set<Id> contractIds, Map<String, String> bpmMap){
        
        //List<Contract> contractRecords = new List<Contract>();
        Map<String, Contract> contractMap = new Map<String, Contract>();
        Map<String, String> bpmContractMap = new Map<String, String>();
        
        if (contractIds != null)
        {
            for (Contract con: [SELECT  Bill_Print_Mode__c,
                                Contract_External_ID__c,
                                CXE_PaperlessBIllingCancelEffective__c,
                                CXE_PaperlessBIllingEnrollment_Effective__c,
                                CXE_Enrolled_to_Paperless_Billing__c,
                                Id
                                FROM    Contract
                                WHERE   Id in: contractIds])
            {
                contractMap.put(con.Contract_External_ID__c, con);
                bpmContractMap.put(con.Contract_External_ID__c, bpmMap.get(con.id));
            }
            
            if (!contractMap.keySet().isEmpty())
            {
                //Vincent MAndolado CXE_CP_V10IntergrationUtility
                CXE_CP_BillPrintModeIntegrationUtility.updateContract(contractMap, bpmContractMap);
                 
            }
        }
    }*/
    //END CSM-12954 GGrandea 09.26.2017
    
    /* Description: CSM-11942 - Reuse of Contract Functionality
    * Parameters: List<Case>, Map<id, Case>
    * Returns: Void
    * Author: Gavi Grandea 
    * Date Created: AUG-25-17
    */
    private void validateReuseOfContractField(List<Case> newList, Map<id, Case> oldMap) {
        List<Case> filteredList = new List<Case>();
        Set<Id> contractIds = new Set<Id>();
        Set<Id> caseIds = new Set<Id>();

        //filter cases that is reusing contracts
        for(Case caseRec : newList){
            if(caseRec.Legacy_Account_Number__c!=null && caseRec.Legacy_Account_Number__c!=oldMap.get(caseRec.Id).Legacy_Account_Number__c ){
                filteredList.add(caseRec);
                contractIds.add(caseRec.Legacy_Account_Number__c);
                caseIds.add(caseRec.Id);
            }
        }

        if(!filteredList.isEmpty()){
            Set<Id> contrIdsWithBillingAddress = new Set<Id>();
            Set<Id> caseIdsWithContractsCreatedAlready = new Set<Id>();
            Set<Id> contractsWithMultipleReuse = new Set<Id>();

            //query for Address records
            for(Address__c addr : [SELECT Id, Contract__c FROM Address__c WHERE Contract__c in: contractIds 
                                    AND Type__c =: CXE_Constants.ADDRESS_TYPE_BILLING]){
                contrIdsWithBillingAddress.add(addr.Contract__c);
            }

            for(Contract ctrct : [SELECT Id, Case__c FROM Contract WHERE Case__c in: caseIds]){
                caseIdsWithContractsCreatedAlready.add(ctrct.Case__c);
            }

            for(Case csRec : [SELECT Id, Contract__c FROM Case 
                                        WHERE Contract__c in: contractIds AND Id NOT in: caseIds
                                         AND Status NOT IN (:CXE_Constants.CASE_APPLICATION_CLOSED
                                                            , :CXE_Constants.CASE_APPLICATION_CANCELLED) ]){
                contractsWithMultipleReuse.add(csRec.Contract__c);
            }

            for(Case cRec : filteredList){
                if(!contrIdsWithBillingAddress.contains(cRec.Legacy_Account_Number__c)){
                    cRec.addError(CXE_Constants.CONTRACTREUSE_BILLING_ADDRESS_MISSING);
                }
                if(caseIdsWithContractsCreatedAlready.contains(cRec.Id)){
                    cRec.addError(CXE_Constants.CONTRACTREUSE_CASE_CONTRACT_ALREADY_CREATED);
                }
                if(contractsWithMultipleReuse.contains(cRec.Legacy_Account_Number__c)){
                    cRec.addError(CXE_Constants.CONTRACTREUSE_CONTRACT_ALREADY_BEING_REUSED);
                }
            }
        }

    }
    
    /* Description: CSM-13657 - Paperless Billing Email if Successful or Rejected
    * Parameters: List<Case> newList, Map<id, Case> oldMap
    * Returns: Void
    * Author: GGrandea (Accenture)
    * Date Created: OCT-10-17
    * Revisions:
    */
    public static Boolean flag = false;  //CSM-14366 Corbes Melvin 11.10.2017
    private void runPaperlessBillemailBatchJob(List<Case> newList, Map<id, Case> oldMap) {
        
        Set<Id> caseIds = new Set<Id>();
        
        for(Case caseRec: newList)
        {
            if(caseRec.RecordTypeId == paperlessRecTypeId 
                && caseRec.Contract__c != null 
                && (caseRec.Status == CXE_Constants.CASE_STATUS_SUCCESSFUL
                      || caseRec.Status == CXE_Constants.CASE_STATUS_REJECTED )
                && (oldMap==null || oldMap.get(caseRec.Id).Status!=caseRec.Status ) )
            {
                caseIds.add(caseRec.Id);
            }
        }

        if(!caseIds.isEmpty() && flag ==false ){ //CSM-14366 Corbes Melvin 11.10.2017
            
            CXE_CP_PaperlessBillingNotifBatch bt = new CXE_CP_PaperlessBillingNotifBatch(caseIds);
            Database.executeBatch(bt, 1);
            flag = true;   //CSM-14366 Corbes Melvin 11.10.2017
            
        }
    }
    
    // START R2C CSM-14084 Shayne 10/27/2017
     public void shareCaseConglomerate(List<Case> newCaseList, Map<Id, Case> oldMap){
         String account_id;
        try {
            Map<Id, Id> groupMap = new Map<Id, Id>();
            Map<Id, String> caseMap = new Map<Id, String>();
            Map<Id, Id> caseShareMap = new Map<Id, ID>();
            Map<Id, Account> accountMap = new Map<Id, Account>();
            Set<Id> accountIds = new Set<Id>();
            Map<Id, String> deleteMap = new Map<Id, String>();
            Set<Id> oldAccountIds = new Set<Id>();

            for(Case newCase : newCaseList){
                System.debug('shareCaseConglomerate '+newCase.ID + ' : '+newCase.AccountID);
                if(oldMap.isEmpty()){ //if on create
                    System.debug('newCase '+newCase.ID + ' : '+newCase.AccountID);
                    caseMap.put(newCase.Id, 'G'+newCase.AccountId);
                    accountIds.add(newCase.AccountId);
                }
                else{ // if update
                    if(oldMap.get(newCase.Id).OwnerId != newCase.OwnerId){    //share if record owner is changed
                        System.debug('newCase '+newCase.Id + ' : '+newCase.AccountID);
                        caseMap.put(newCase.Id, 'G'+newCase.AccountId);
                        accountIds.add(newCase.AccountId);
                    }
                    else if(oldMap.get(newCase.Id).AccountId != newCase.AccountId){    //only share if account is changed
                        System.debug('newCase '+newCase.Id + ' : '+newCase.AccountID+' : '+oldMap.get(newCase.Id).AccountId);
                        deleteMap.put(newCase.Id, 'G'+oldMap.get(newCase.Id).AccountId);
                        oldAccountIds.add(oldMap.get(newCase.Id).AccountId);
                        caseMap.put(newCase.Id, 'G'+newCase.AccountId);
                        accountIds.add(newCase.AccountId);
                    }
                }
            }
            System.debug('caseMap '+caseMap.size());
            System.debug('deleteMap '+deleteMap.size());
            
            if(!deleteMap.isEmpty()){
                groupMap = getGroupRecords(deleteMap);
                accountMap = getAccountRecords(oldAccountIds); 
               System.debug('DELETE groupMap '+groupMap.size()+' : accountMap '+accountMap.size());
                //set the caseid and userorgroupid
                for(ID caseID: deleteMap.keySet()){
                    account_id = (deleteMap.get(caseID)).substring(1);
                    if((groupMap.get(account_id) != null)
                       && ((accountMap.get(account_id)).conglomerate__c) 
                       && ((accountMap.get(account_id)).parentid != null) ){
                        caseShareMap.put(caseID, groupMap.get(account_id));
                        System.debug('DELETE caseShareMap '+caseID+':'+groupMap.get(account_id));
                    } 
                }
                deleteCaseShareRecord(caseShareMap);
            }
            groupMap = new Map<Id, Id>();
            accountMap = new Map<Id, Account>();
            caseShareMap = new Map<Id, ID>();
            if(!caseMap.isEmpty()){
                groupMap = getGroupRecords(caseMap);
                accountMap = getAccountRecords(accountIds);   
                System.debug('groupMap '+groupMap.size()+' : accountMap '+accountMap.size());            
                //set the caseid and userorgroupid
                for(ID caseID: CaseMap.keySet()){
                    account_id = (CaseMap.get(caseID)).substring(1);
                    if((groupMap.get(account_id) != null)
                       && ((accountMap.get(account_id)).conglomerate__c) 
                       && ((accountMap.get(account_id)).parentid != null) ){
                        caseShareMap.put(caseID, groupMap.get(account_id));
                        System.debug('caseShareMap '+caseID+':'+groupMap.get(account_id));
                    } 
                }
               insertCaseShareRecord(caseShareMap, newCaseList);
            }
        } catch (Exception error){ 
            System.debug('shareRecordConglomerate '+error.getMessage());
            ErrorHandlerException.recordException(null, true, 'CaseTriggerHandler', 'shareRecordConglomerate', error.getMessage());
        }
    }
    
    public  Map<Id, Id> getGroupRecords(Map<Id, String> recordMap){
        Map<Id, Id> groupMap = new Map<Id, Id>();
        for(Group grp : [Select id,developername from Group where developername IN :recordMap.values()]){
                   groupMap.put((grp.developername).substring(1), grp.id);
                   System.debug('getGroupRecords: groupMap '+(grp.developername).substring(1)+':'+grp.id);
                }
        return groupMap;
    }
    
    public Map<Id, Account> getAccountRecords(Set<Id> accountIds){
        Map<Id, Account> accountMap = new Map<Id, Account>();
        for(Account acct : [Select id,conglomerate__c, ParentId from Account where id IN :accountIds]){
             accountMap.put(acct.id, acct);
             System.debug('getAccountRecords: accountMap '+acct.id+' : '+acct.conglomerate__c+' : '+acct.ParentId);
         }
        return accountMap;
    }
    
    public void insertCaseShareRecord(Map<Id, Id> caseShareMap, List<Case> newCaseList){
        System.debug('insertCaseShareRecord '+caseShareMap.size());
        try{
        if(!caseShareMap.isEmpty()){
                    List<CaseShare> CaseShareList = new List<CaseShare>();
                    CaseShare newCaseShare;
                    for(Case newCase : newCaseList){
                        if(caseShareMap.containsKey(newCase.Id)){
                            //grant read acess
                            newCaseShare  = new CaseShare();
                            newCaseShare.CaseId = newCase.Id;
                            newCaseShare.CaseAccessLevel = CXE_Constants.SHARE_ACCESS_LEVEL_READ;
                            newCaseShare.UserOrGroupId = caseShareMap.get(newCase.Id);
                            newCaseShare.RowCause = Schema.CaseShare.RowCause.Manual;
                            CaseShareList.add(newCaseShare);
                            System.debug('newCaseShare caseID: '+newCase.Id);
                        }
                    }
                    if(!CaseShareList.isEmpty()){
                        insert CaseShareList;
                    }               
                }
        }catch (Exception error){ 
            System.debug('insertCaseShareRecord '+error.getMessage());
            ErrorHandlerException.recordException(null, true, 'CaseTriggerHandler', 'insertCaseShareRecord', error.getMessage());
        }
    }
    
    public void deleteCaseShareRecord(Map<Id, Id> caseShareMap){
        System.debug('deleteCaseShareRecord '+caseShareMap.size());
        try{
            String group_id ='';
            List<CaseShare> deleteRecords = new List<CaseShare>();
            List<CaseShare> caseShareDeleteRecord = [SELECT Id, CaseId, UserOrGroupId FROM CaseShare WHERE CaseId IN :caseShareMap.keySet() and UserOrGroupId IN :caseShareMap.values()]; 
            System.debug('caseShareDeleteRecord '+caseShareDeleteRecord.size());
            for(CaseShare cShare : caseShareDeleteRecord){
                group_id =  caseShareMap.get(cShare.caseId);
                if(group_id.equalsIgnoreCase(cShare.UserOrGroupId)){
                    deleteRecords.add(cShare);
                }
            }
           delete deleteRecords;
        }catch (Exception error){ 
            System.debug('deleteCaseShareRecord '+error.getMessage());
            ErrorHandlerException.recordException(null, true, 'CaseTriggerHandler', 'deleteCaseShareRecord', error.getMessage());
        }
    }
        
    // END R2C CSM-14084 Shayne 10/27/2017 Apex Sharing
    
    /* Description: CSM-13159 - Get ID for Service with APA Enrollment Record Type
    * Parameters: List<Case>, Map<id, Case>
    * Returns: Void
    * Author: John Mark Fernandez
    * Date Created: OCT-25-2017
    */
    public void getServiceIdForAPAEnrollment(List<Case> lstNewCase, Map<Id, Case> mapOldCase, Boolean isUpdate){
        Id currentUserId = UserInfo.getUserId();
        
        //Map<String, String> mapCaseToService = new Map<String, String>();
        Id emailTemplateId; //= [SELECT Id FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_SUCCESS_PB_SUB_IDV].id;
        List<Id> emailTemplateIds = new List<Id>();
        String emailTemplateString;
        List<String> listEmailTemplate = new List<String>();
        List<String> listCaseIds = new List<String>();
        
        for(Case c : lstNewCase){
            
            if(c.RecordTypeId == apaEnrollmentRecTypeId){
                if(isUpdate){
                    Case oldCase = mapOldCase.get(c.Id);
                    if(c.Application_Type_Subtype__c.contains(CXE_Constants.SERVICE_REQ_APA_ENROLLMENT)){
                        if(c.Status.contains(CXE_Constants.CASE_STATUS_SUCCESS) && (oldCase.Status.contains(CXE_Constants.CASE_STATUS_OPEN) || oldCase.Status.contains(CXE_Constants.CASE_STATUS_DOCUMENT_RECEIVED))){
                            listCaseIds.add(c.Id);
                        }else if(c.Status.contains(CXE_Constants.CASE_STATUS_FAILED) && (oldCase.Status.contains(CXE_Constants.CASE_STATUS_OPEN) || oldCase.Status.contains(CXE_Constants.CASE_STATUS_DOCUMENT_RECEIVED))){
                            listCaseIds.add(c.Id);
                        }
                    }else if(c.Application_Type_Subtype__c.contains(CXE_Constants.SERVICE_REQ_APA_CANCELLATION)){
                        if(c.Status.contains(CXE_Constants.CASE_STATUS_SUCCESS) && (oldCase.Status.contains(CXE_Constants.CASE_STATUS_OPEN) || oldCase.Status.contains(CXE_Constants.CASE_STATUS_DOCUMENT_RECEIVED))){
                            listCaseIds.add(c.Id);
                        }else if(c.Status.contains(CXE_Constants.CASE_STATUS_FAILED) && (oldCase.Status.contains(CXE_Constants.CASE_STATUS_OPEN) || oldCase.Status.contains(CXE_Constants.CASE_STATUS_DOCUMENT_RECEIVED))){
                            listCaseIds.add(c.Id);
                        }
                    }
                }else{
                    if(c.Application_Type_Subtype__c.contains(CXE_Constants.SERVICE_REQ_APA_ENROLLMENT) && (c.Status.contains(CXE_Constants.CASE_STATUS_OPEN) || c.Status.contains(CXE_Constants.CASE_STATUS_DOCUMENT_RECEIVED) )){
                        listCaseIds.add(c.Id);
                    } else if(c.Application_Type_Subtype__c.contains(CXE_Constants.SERVICE_REQ_APA_CANCELLATION) && (c.Status.contains(CXE_Constants.CASE_STATUS_OPEN) || c.Status.contains(CXE_Constants.CASE_STATUS_DOCUMENT_RECEIVED))){
                        listCaseIds.add(c.Id);
                    } 
                }
            }
        }
        system.debug('listCaseIds >>> ' + listCaseIds);
        if(!listCaseIds.isEmpty()){
            autoCreateEmailForAPAEnrollment(listCaseIds);
        }
        
        /*system.debug('getServiceIdForAPAEnrollment end ***');
        if(currentUserId == '0050l000000d9Ja'){
            system.assert(currentUserId != '0050l000000d9Ja', 'ENTER getServiceIdForAPAEnrollment');
        }
        system.debug('END');*/
    }
    
    @future
    static void autoCreateEmailForAPAEnrollment(List<String> listCaseIds){
        List<String> serviceIds = new List<String>();
        Set<String> caseIds = new Set<String>();
        String servId;

        //serviceIds = mapCaseToService.values();
        caseIds.addAll(listCaseIds);
        if(!caseIds.isEmpty()){
            
            try{
                Map<Id, Case> caseMap = new Map<Id, Case>();
                Set<Id> contractIds = new Set<Id>();
                Map<Id, Case> contractIdCaseMap = new Map<Id, Case>();
                String contactEmail; //START END JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez
                
                for(Case caseRecord : [SELECT Id, Contract__c, Status, Application_Type_Subtype__c, Contact.Email FROM Case WHERE Id IN : caseIds]){ //START END JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez Add Contact.Email in the query
                    caseMap.put(caseRecord.Id, caseRecord);
                    contractIds.add(caseRecord.Contract__c);
                    contractIdCaseMap.put(caseRecord.Contract__c, caseRecord);
                    contactEmail = caseRecord.Contact.Email; //START END JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez
                }
    
                List<CXE_Service_Enrollment__c> enrollmentList = [SELECT Id,
                                                                        CXE_UserId__c,
                                                                        CXE_ServiceId__r.Payor__c
                                                                     FROM CXE_Service_Enrollment__c 
                                                                    WHERE CXE_ServiceId__r.Payor__c in: contractIds
                                                                        AND CXE_IsActive__c = true 
                                                                        AND CXE_Type__c =: CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR]; //START END JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez return the query for type = payor
                                                                        ///*AND CXE_Type__c =: CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR*/]; //START END CSM-14914 JFernandez DEC-20-17
    
                if(!enrollmentList.isEmpty()){
                    Set<Id> portalUserIds = new Set<Id>();
                    Map<Id, Set<Id>> contractIdUserSetMap = new Map<Id, Set<Id>>();
    
                    Set<Id> tempSet;
                    for(CXE_Service_Enrollment__c enroll : enrollmentList){
                        if(enroll.CXE_UserId__c!=null){
                            portalUserIds.add(enroll.CXE_UserId__c);                        
                            if(contractIdUserSetMap.containsKey(enroll.CXE_ServiceId__r.Payor__c)){
                                tempSet = contractIdUserSetMap.get(enroll.CXE_ServiceId__r.Payor__c);
                            }else{
                                tempSet = new Set<Id>();
                            }
                            tempSet.add(enroll.CXE_UserId__c);
                            contractIdUserSetMap.put(enroll.CXE_ServiceId__r.Payor__c, tempSet);
                        }
                    }
                    
                    if(!portalUserIds.isEmpty()){
                        Map<Id, User> userMap = new Map<Id, User>([SELECT Id, 
                                                                            Email, 
                                                                            Contact.isPersonAccount
                                                                         FROM User
                                                                        WHERE Id in: portalUserIds]);
    
                        apaSendEmailNotification(userMap, contractIdUserSetMap, contractIdCaseMap, contactEmail); //START END JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez Add contactEmail
                    }
    
                }
    
                
            }catch(Exception ex){
                ErrorHandlerException.recordException(null, true, 'apaSendEmailNotification', 'execute', ex.getMessage()+ex.getStackTraceString());
            }
        }   
    }
    
    private static void apaSendEmailNotification(Map<Id, User> userMap, Map<Id, Set<Id>> contractIdUserSetMap, Map<Id, Case> contractIdCaseMap, String contactEmail){ //START END JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez Add contactEmail
        String currentUserId = UserInfo.getUserId();
        String currentUserEmail = UserInfo.getUserEmail();
        String currentUserProfile = UserInfo.getProfileId(); //START END JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez
        String[] currentUserAddresses = new String[]{currentUserEmail};
        Id orgWide = [SELECT Id from OrgWideEmailAddress WHERE  Address =: CXE_Constants.ORG_WIDE_EMAIL].Id;
        Id emailTemplateId;
        
        //START CSM-14914 JFernandez DEC-20-17
        Id apaEnrollmentRequestIDV;
        Id apaEnrollmentRequestBIZ;
        Id apaCancellationRequestIDV;
        Id apaCancellationRequestBIZ;
        Id apaSuccessCancellationRequestIDV;
        Id apaSuccessCancellationRequestBIZ;
        Id apaSuccessEnrollmentRequestIDV;
        Id apaSuccessEnrollmentRequestBIZ;
        Id apaFailedEnrollmentRequestIDV;
        Id apaFailedEnrollmentRequestBIZ;
        
        String apaEnrollmentRequestIDVSubject;
        String apaEnrollmentRequestBIZSubject;
        String apaCancellationRequestIDVSubject;
        String apaCancellationRequestBIZSubject;
        String apaSuccessCancellationRequestIDVSubject;
        String apaSuccessCancellationRequestBIZSubject;
        String apaSuccessEnrollmentRequestIDVSubject;
        String apaSuccessEnrollmentRequestBIZSubject;
        String apaFailedEnrollmentRequestIDVSubject;
        String apaFailedEnrollmentRequestBIZSubject;
        
        List<String> listEmailTemplate = new List<String>{CXE_Constants.EMAIL_TEMP_APA_ENROLLMENTREQUEST_IDV, 
													CXE_Constants.EMAIL_TEMP_APA_ENROLLMENTREQUEST_BIZ,
													CXE_Constants.EMAIL_TEMP_APA_CANCELLATIONREQUEST_IDV,
													CXE_Constants.EMAIL_TEMP_APA_CANCELLATIONREQUEST_BIZ,
													CXE_Constants.EMAIL_TEMP_SUCCESS_CANCELLATIONREQUEST_APA_IDV,
													CXE_Constants.EMAIL_TEMP_SUCCESS_CANCELLATIONREQUEST_APA_BIZ,
													CXE_Constants.EMAIL_TEMP_SUCCESS_ENROLLMENTREQUEST_APA_IDV,
													CXE_Constants.EMAIL_TEMP_SUCCESS_ENROLLMENTREQUEST_APA_BIZ,
													CXE_Constants.EMAIL_TEMP_FAILED_ENROLLMENTREQUEST_APA_IDV,
													CXE_Constants.EMAIL_TEMP_FAILED_ENROLLMENTREQUEST_APA_BIZ};
        
        for(EmailTemplate et : CXE_Utility.emailTemplateQuery(listEmailTemplate)){
                                    if(et.DeveloperName == CXE_Constants.EMAIL_TEMP_APA_ENROLLMENTREQUEST_IDV){
                                        apaEnrollmentRequestIDV = et.Id;
                                        apaEnrollmentRequestIDVSubject = et.Subject;
                                    }
                                    if(et.DeveloperName == CXE_Constants.EMAIL_TEMP_APA_ENROLLMENTREQUEST_BIZ){
                                        apaEnrollmentRequestBIZ = et.Id;
                                        apaEnrollmentRequestBIZSubject = et.Subject;
                                    }
                                    if(et.DeveloperName == CXE_Constants.EMAIL_TEMP_APA_CANCELLATIONREQUEST_IDV){
                                        apaCancellationRequestIDV = et.Id;
                                        apaCancellationRequestIDVSubject = et.Subject;
                                    }
                                    if(et.DeveloperName == CXE_Constants.EMAIL_TEMP_APA_CANCELLATIONREQUEST_BIZ){
                                        apaCancellationRequestBIZ = et.Id;
                                        apaCancellationRequestBIZSubject = et.Subject;
                                    }
                                    if(et.DeveloperName == CXE_Constants.EMAIL_TEMP_SUCCESS_CANCELLATIONREQUEST_APA_IDV){
                                        apaSuccessCancellationRequestIDV = et.Id;
                                        apaSuccessCancellationRequestIDVSubject = et.Subject;
                                    }
                                    if(et.DeveloperName == CXE_Constants.EMAIL_TEMP_SUCCESS_CANCELLATIONREQUEST_APA_BIZ){
                                        apaSuccessCancellationRequestBIZ = et.Id;
                                        apaSuccessCancellationRequestBIZSubject = et.Subject;
                                    }
                                    if(et.DeveloperName == CXE_Constants.EMAIL_TEMP_SUCCESS_ENROLLMENTREQUEST_APA_IDV){
                                        apaSuccessEnrollmentRequestIDV = et.Id;
                                        apaSuccessEnrollmentRequestIDVSubject = et.Subject;
                                    }
                                    if(et.DeveloperName == CXE_Constants.EMAIL_TEMP_SUCCESS_ENROLLMENTREQUEST_APA_BIZ){
                                        apaSuccessEnrollmentRequestBIZ = et.Id;
                                        apaSuccessEnrollmentRequestBIZSubject = et.Subject;
                                    }
                                    if(et.DeveloperName == CXE_Constants.EMAIL_TEMP_FAILED_ENROLLMENTREQUEST_APA_IDV){
                                        apaFailedEnrollmentRequestIDV = et.Id;
                                        apaFailedEnrollmentRequestIDVSubject = et.Subject;
                                    }
                                    if(et.DeveloperName == CXE_Constants.EMAIL_TEMP_FAILED_ENROLLMENTREQUEST_APA_BIZ){
                                        apaFailedEnrollmentRequestBIZ = et.Id;
                                        apaFailedEnrollmentRequestBIZSubject = et.Subject;
                                    }   
                                }
        //END CSM-14914 JFernandez DEC-20-17
        List<Messaging.SingleEmailMessage >  myEmails = new List<Messaging.SingleEmailMessage>();
        //User tempUser; //START END JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez Put the tempUser variable in the for loop
        //Case tempCase; //START END JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez Put the tempCase variable in the for loop
        Boolean isIndividual;
        List<Id> caseIdsToUpdateOwner = new List<Id>();
        List<Id> caseIdsToUpdateOwnerFailedCancellation = new List<Id>();
        String taskSubject;
        
        //START JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez
        String portalId = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE].Id;
        Id contactUserId;
        Set<String> contactEmailList = new Set<String>();
        
        for(User userLoop : [SELECT Id, Email FROM User WHERE Email =: contactEmail LIMIT 1]){
            contactUserId = userLoop.Id;
        }
        
        Boolean tempBoolForPortalInitiate = false;
        Boolean tempBoolForContactPersonInCase = false;
        Set<Id> userIdForSendingEmail = new Set<Id>();
        
        //END JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez
        
        for(Id contractId : contractIdCaseMap.keySet()){
            for(Id userId : contractIdUserSetMap.get(contractId)){
                User tempUser; //START END JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez
                Case tempCase; //START END JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez
                tempCase = contractIdCaseMap.get(contractId);
                tempUser = userMap.get(userId);
                isIndividual = tempUser.Contact.IsPersonAccount? TRUE : FALSE;
                String[] addresses = new String[]{tempUser.Email};
                String [] addresses1 = new String[]{contactEmail};
                    if(tempCase.Status == CXE_Constants.CASE_STATUS_OPEN || tempCase.Status == CXE_Constants.CASE_STATUS_DOCUMENT_RECEIVED){
                        if(tempCase.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_ENROLLMENT){
                            if(isIndividual){
                                emailTemplateId = apaEnrollmentRequestIDV;
                                taskSubject = apaEnrollmentRequestIDVSubject;
                            }else{
                                emailTemplateId = apaEnrollmentRequestBIZ;
                                taskSubject = apaEnrollmentRequestBIZSubject;
                            }
                        }else if(tempCase.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_CANCELLATION){
                            if(isIndividual){
                                emailTemplateId = apaCancellationRequestIDV;
                                taskSubject = apaCancellationRequestIDVSubject;
                            }else{
                                emailTemplateId = apaCancellationRequestBIZ;
                                taskSubject = apaCancellationRequestBIZSubject;
                            }
                        }
                    }else if(tempCase.Status == CXE_Constants.CASE_STATUS_SUCCESS){
                        if(tempCase.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_ENROLLMENT){
                            if(isIndividual){
                                emailTemplateId = apaSuccessEnrollmentRequestIDV;
                                taskSubject = apaSuccessEnrollmentRequestIDVSubject;
                            }else{
                                emailTemplateId = apaSuccessEnrollmentRequestBIZ;
                                taskSubject = apaSuccessEnrollmentRequestBIZSubject;
                            }
                        }else if(tempCase.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_CANCELLATION){
                            if(isIndividual){
                                emailTemplateId = apaSuccessCancellationRequestIDV;
                                taskSubject = apaSuccessCancellationRequestIDVSubject;
                            }else{
                                emailTemplateId = apaSuccessCancellationRequestBIZ;
                                taskSubject = apaSuccessCancellationRequestBIZSubject;
                            }
                        }
                    }else if(tempCase.Status == CXE_Constants.CASE_STATUS_FAILED){
                        if(tempCase.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_ENROLLMENT){
                            if(isIndividual){
                                emailTemplateId = apaFailedEnrollmentRequestIDV;
                                taskSubject = apaFailedEnrollmentRequestIDVSubject;
                            }else{
                                emailTemplateId = apaFailedEnrollmentRequestBIZ;
                                taskSubject = apaFailedEnrollmentRequestBIZSubject;
                            }
                        }//START CSM-14834 JFernandez DEC-13-17 Commented the assigning of emailtemplateId and taskSubject forAPA Cancellation Failed
                        /*else if(tempCase.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_CANCELLATION){
                            if(isIndividual){
                                emailTemplateId = apaFailedCancellationRequestIDV;
                                taskSubject = apaFailedCancellationRequestIDVSubject;
                            }else{
                                emailTemplateId = apaFailedCancellationRequestBIZ;
                                taskSubject = apaFailedCancellationRequestBIZSubject;
                            }
                        }*/ //END CSM-14834 JFernandez DEC-13-17
                    }
                
                system.debug('emailTemplateId >>> ' + emailTemplateId);
                if(emailTemplateId!=null){ //START END CSM-14834 JFernandez DEC-13-17 Add Validation for emailTemplate not equal to null
                    //START JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez
                    if(!userIdForSendingEmail.contains(tempUser.Id)){
                        //SENDING OF EMAIL FOR PAYOR PORTAL ACCOUNT
                        myEmails.add(CXE_Utility.emailNotif(addresses, false, tempUser.Id, contractIdCaseMap.get(contractId).Id, orgWide, emailTemplateId));
                        userIdForSendingEmail.add(tempUser.Id);
                    }
                    
                    //SENDING OF EMAIL FOR PORTAL ACCOUNT WHO INIATE THE REQUEST FOR APA ENROLLMENT OR CANCELLATIOn
                    if(!userIdForSendingEmail.contains(currentUserId) && !tempBoolForPortalInitiate && tempUser.Id != currentUserId && currentUserProfile == portalId && (tempCase.Status == CXE_Constants.CASE_STATUS_OPEN || tempCase.Status == CXE_Constants.CASE_STATUS_DOCUMENT_RECEIVED)){
                        system.debug('PORTAL INITIATE');
                        myEmails.add(CXE_Utility.emailNotif(currentUserAddresses, false, currentUserId, contractIdCaseMap.get(contractId).Id, orgWide, emailTemplateId));
                        tempBoolForPortalInitiate = true;
                    }
                    //SENDING OF EMAIL IN CRM FOR CASE CONTACT EMAIL
                    //START JAN-16-2018 CSM-15071, CSM-15151 John Mark Fernandez
                    else if(!userIdForSendingEmail.contains(contactUserId) && !tempBoolForContactPersonInCase && tempUser.Id != contactUserId && currentUserProfile != portalId && tempUser.Email != contactEmail){
                        system.debug('CRM FOR CASE CONTACT EMAIL');
                        myEmails.add(CXE_Utility.emailNotif(addresses1, false, contactUserId, contractIdCaseMap.get(contractId).Id, orgWide, emailTemplateId));
                        tempBoolForContactPersonInCase = true;
                    }
                    /*else if(!userIdForSendingEmail.contains(contactUserId) && !userIdForSendingEmail.contains(tempUser.Id) && !tempBoolForContactPersonInCase && tempUser.Id != currentUserId && currentUserProfile != portalId && tempUser.Email != contactEmail){
                        system.debug('CRM FOR CASE CONTACT EMAIL');
                        myEmails.add(CXE_Utility.emailNotif(addresses1, false, contactUserId, contractIdCaseMap.get(contractId).Id, orgWide, emailTemplateId));
                        tempBoolForContactPersonInCase = true;
                    }*/
                    //END JAN-16-2018 CSM-15071, CSM-15151 John Mark Fernandez
                    //END END JAN-10-2018 CSM-15071, CSM-15081 John Mark Fernandez
                    caseIdsToUpdateOwner.add(contractIdCaseMap.get(contractId).Id); //START CSM-14517 JFernandez DEC-5-17
                }else{ //START CSM-14834 JFernandez DEC-13-17 Add else condition
                    caseIdsToUpdateOwnerFailedCancellation.add(contractIdCaseMap.get(contractId).Id); //START CSM-14517 JFernandez DEC-5-17
                }
                
            }
        }
        
        if(!myEmails.isEmpty()){
            system.debug('MYEMAILS >>> ' + myEmails);
            Messaging.sendEmail(myEmails);
        }
        
        //START CSM-14517 JFernandez DEC-5-17 Transfer here the assigning of Case Owner from CXE_CP_AutoPaymentArrangement_CC
        List<Case> listCaseToUpdate = new List<Case>();
        List<Task> listTaskToCreate = new List<Task>();
        List<Group> paymentOpsQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName =:CXE_Constants.QUEUE_PAYMENT_OPERATIONS LIMIT 1];
        system.debug('paymentOpsQueue >>> ' + paymentOpsQueue);
        for(Case caseLoop : [SELECT Id, Account.OwnerId, AccountId, CXE_V10AccountNumber__c, ContactId, Contact.OwnerId, Account.IsPersonAccount FROM Case WHERE Id IN : caseIdsToUpdateOwner]){ ////START CSM-14807 JFernandez DEC-13-17 Add ContactId, Contact.OwnerId, Account.IsPersonAccount END
            system.debug('EACH CASE IN THE CASELOOP');
            Case caseRec = new Case();
            caseRec.Id = caseLoop.Id;
            if(!paymentOpsQueue.isEmpty()){
                system.debug('PAYMENT OPS QUEUE NOT EMPTY');
                caseRec.OwnerId = paymentOpsQueue[0].Id;
            }
            listCaseToUpdate.add(caseRec);
            
            //START CSM-14795 JFernandez DEC-13-17
            if(caseLoop.AccountId!=null){ //START END CSM-14807 JFernandez DEC-14-17 Add Validation for AccountId
                
                //START CSM-14914 JFernandez DEC-20-17
                listTaskToCreate.add(
                    CXE_Utility.taskCreation(
                        Date.today(),
                        CXE_Constants.PORTALUSER_NOTIF_EMAIL,
                        CXE_Constants.CASE_SERVICE_APPLICATION,
                        caseLoop.Account.OwnerId,
                        CXE_Constants.TASK_PRIORITY_NORMAL,
                        CXE_Constants.TASK_STATUS_COMPLETED,
                        caseLoop.AccountId,
                        taskSubject + caseLoop.CXE_V10AccountNumber__c,
                        caseLoop.ContactId
                    )
                );
                //END CSM-14914 JFernandez DEC-20-17
                
            } //START END CSM-14807 JFernandez DEC-13-17 Add closing tag for the if condition 
            //END CSM-14795 JFernandez DEC-13-17
        }
        //START CSM-14834 JFernandez DEC-13-17
        for(Case caseLoop : [SELECT Id, Account.OwnerId, AccountId, CXE_V10AccountNumber__c, ContactId, Contact.OwnerId, Account.IsPersonAccount FROM Case WHERE Id IN : caseIdsToUpdateOwnerFailedCancellation]){
        	Case caseRec = new Case();
            caseRec.Id = caseLoop.Id;
            if(!paymentOpsQueue.isEmpty()){
                system.debug('PAYMENT OPS QUEUE NOT EMPTY');
                caseRec.OwnerId = paymentOpsQueue[0].Id;
            }
            listCaseToUpdate.add(caseRec);
        }
        
        if(!listCaseToUpdate.isEmpty()){
            system.debug('listCaseToUpdate >>> ' + listCaseToUpdate);
            update listCaseToUpdate;
        }
        if(!listTaskToCreate.isEmpty()){
            system.debug('listTaskToCreate >>> ' + listTaskToCreate);
            insert listTaskToCreate;
        }
        //END CSM-14834 JFernandez DEC-13-17    
        
        //END CSM-14517
    }
    //END CSM-13159
    
    /* Description: CSM-14114 - Create Paperless Billing Case for NSA and Recontract
    * Parameters: List<Case>, Map<id, Case>
    * Returns: Void
    * Author: Von Pernicia 
    * Date Created: NOV-06-17
    */
    private void createPaperlessBillingCase(List<Case> newList, Map<id, Case> oldMap) {
    
    // Start R2C CSM-14349 Von Pernicia NOV-09-17
        Map<Id, Case> caseRecList = new Map<Id, Case>();
        Map<Id, Contract> contractIdMap = new Map<Id, Contract>();
        List<Case> createCase = new List<Case>();
        List<Id> contractIds = new List<Id>();
       
        //Check if is recurssion
        if (!isRecurssion)
        {
            //Check if case is created via portal
            for(Case caseRec : newList){
                
                if(caseRec.Origin == CXE_Constants.CASE_ORIGIN_WEB
                  && caseRec.status != oldMap.get(caseRec.Id).status && caseRec.status == CXE_Constants.CASE_APPLICATION_ENERGIZED
                  && (caseRec.RecordTypeId == newServRecTypeId || caseRec.RecordTypeId == recontractRecTypeId)){
                    caseRecList.put(caseRec.Id, caseRec);
                }
            }
    
            if (!caseRecList.isEmpty())
            {
                //Get Contract external number
                for (Contract con: [Select ID, Case__c, Contract_External_ID__c From Contract where Case__c in: caseRecList.keySet()])
                {
                    contractIdMap.put(con.Case__c, con);
                }
                
                //Create Paperless Billing Record
                for (Case cas: caseRecList.values())
                {//system.assertequals(cas.CXE_Enroll_to_Paperless_Billing__c, null);
                    if (cas.CXE_Enroll_to_Paperless_Billing__c)
                    {
                        Case casRec = new Case(
                            RecordTypeID = paperlessRecTypeId,
                            Origin = CXE_Constants.CASE_ORIGIN_WEB,
                            AccountId = caseRecList.get(cas.Id).AccountId,
                            Contract__c = contractIdMap.get(cas.Id).Id,
                            Account_Number__c = contractIdMap.get(cas.Id).Contract_External_ID__c,
                            Application_Type_Subtype__c = CXE_Constants.CASE_PAPERLESSBILLING_TYPE_SUB
                        );
                    
                        createCase.add(casRec);
                    }
                    else
                    {
                        contractIds.add(contractIdMap.get(cas.Id).ID);
                    }
                }
                
                if (!createCase.isEmpty())
                {
                    insert createCase;
                    isRecurssion = true;
                }

                if (!contractIds.isEmpty())
                {
                    updateToPaperplus(contractIds);
                }
            }
        }
    // End R2C CSM-14349 Von Pernicia NOV-09-17
    } 

    /* Description: CSM-14114 - Update to Paperplus for NSA and Recontract
    * Parameters: List<ContractId>
    * Returns: Void
    * Author: Von Pernicia 
    * Date Created: NOV-09-17
    * Defect: CSM-14349
    */
     @future(callout=true)
    static void updateToPaperplus(List<Id> contractIds){

        Map<String, Contract> contractMap = new Map<String, Contract>();
        Map<String, String> bpmContractMap = new Map<String, String>();

        for (Contract con: [Select ID, Case__c, Contract_External_ID__c From Contract where Id in: contractIds])
        {
            contractMap.put(con.Contract_External_ID__c, con);
            bpmContractMap.put(con.Contract_External_ID__c, CXE_Constants.BPM_PAPERPLUS);
        }

        if (!contractMap.isEmpty())
        {
            CXE_CP_BillPrintModeIntegrationUtility.updateContract(contractMap, bpmContractMap);
        }

    }


    //START CSM-13194 RReyes - NOV-06-17
    /* Description: CSM-13194
     * Parameters: List<Case>
     * Returns: Void
     * Author: Rom Edison Reyes 
     * Date Created: NOV-06-17
     */
    public void updatePendingAPAOnContract(List<Case> newList){
        Set<String> apaEnrollment = new Set<String>();
        Set<String> apaCancellation = new Set<String>();
        List<Contract> contractToUpdate = new List<Contract>();

        for(Case caseRec: newList){
            if(caseRec.RecordTypeId == apaEnrollmentRecTypeId 
                && caseRec.Status != CXE_Constants.CASE_STATUS_SUCCESS 
                && caseRec.Status != CXE_Constants.CASE_STATUS_FAILED){
                if(caseRec.Contract__c != null){
                    if(caseRec.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_ENROLLMENT){
                        apaEnrollment.add(caseRec.Contract__c);
                    }else if(caseRec.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_CANCELLATION){
                        apaCancellation.add(caseRec.Contract__c);
                    }
                }
            }
        }

        if(!apaEnrollment.isEmpty()){
            for(String contrId: apaEnrollment){
                Contract contr = new Contract();
                contr.Id = contrId;
                contr.CXE_Pending_APA_Enrollment__c = true;
                contractToUpdate.add(contr);
            }
        }

        if(!apaCancellation.isEmpty()){
            for(String contrId: apaCancellation){
                Contract contr = new Contract();
                contr.Id = contrId;
                contr.CXE_Pending_APA_Cancellation__c = true;
                contractToUpdate.add(contr);
            }
        }

        if(!contractToUpdate.isEmpty()){
            try{
                update contractToUpdate;
            }catch(Exception e){
                ErrorHandlerException.recordException(contractToUpdate[0].Id, true, 'CaseTriggerHandler', 'updatePendingAPAOnContract', e.getMessage());
            }
        }
    }

    /* Description: CSM-13194
     * Parameters: Map<Id, Case> newCase, Map<Id, Case> oldCase 
     * Returns: Void
     * Author: Rom Edison Reyes 
     * Date Created: NOV-06-17
     */
     //START CSM-14606 RReyes NOV-27-17
    public void updateContractOnAPAStatusChange(Map<Id, Case> newCases, Map<Id, Case> oldCases, Boolean isUpdate){
        List<Contract> contractToUpdate = new List<Contract>();
        for(Case caseRec: newCases.values()){
            if(caseRec.RecordTypeId == apaEnrollmentRecTypeId){
                Contract contr = new Contract();
                if(isUpdate){
                    Case oldCase = oldCases.get(caseRec.Id);
                    if(caseRec.Contract__c != null && caseRec.Status == CXE_Constants.CASE_STATUS_SUCCESS && oldCase.Status != CXE_Constants.CASE_STATUS_SUCCESS){
                        //START CSM-14973 RReyes DEC-27-17
                        if(caseRec.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_ENROLLMENT){
                            contr.Id = caseRec.Contract__c;
                            //START CSM-14606 RReyes NOV-27-17
                            //contr.CXE_Pay_Mthd_Effective_Date__c = caseRec.CXE_Pay_Mthd_Effective_Date__c;
                            //END CSM-14606 RReyes NOV-27-17
                            //contr.CXE_Enrolled_to_APA__c = true;
                            contr.CXE_Pending_APA_Enrollment__c = false;
                            //contr.CXE_APA_Agent__c = caseRec.CXE_APA_Agent__c; //START/END CSM-14777 RReyes DEC-05-17
                            contractToUpdate.add(contr);
                        }else if(caseRec.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_CANCELLATION){
                            contr.Id = caseRec.Contract__c;
                            //START CSM-14606 RReyes NOV-27-17
                            //contr.CXE_Pay_Mthd_Effective_Date__c = caseRec.CXE_Pay_Mthd_Effective_Date__c;
                            contr.CXE_Reason_for_Cancellation_APA__c = caseRec.CXE_Reason_for_Cancellation_APA__c;
                            //contr.CXE_APA_Enrollment_Effective_Date__c = null;
                            //END CSM-14606 RReyes NOV-27-17
                            //contr.CXE_Enrolled_to_APA__c = false;
                            contr.CXE_Pending_APA_Cancellation__c = false;
                            contractToUpdate.add(contr);
                        }
                        //END CSM-14973 RReyes DEC-27-17
                    }else if(caseRec.Contract__c != null && caseRec.Status == CXE_Constants.CASE_STATUS_FAILED && oldCase.Status != CXE_Constants.CASE_STATUS_FAILED){
                        if(caseRec.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_ENROLLMENT){
                            contr.Id = caseRec.Contract__c;
                            contr.CXE_Pending_APA_Enrollment__c = false;
                            contractToUpdate.add(contr);
                        }else if(caseRec.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_CANCELLATION){
                            contr.Id = caseRec.Contract__c;
                            contr.CXE_Pending_APA_Cancellation__c = false;
                            contractToUpdate.add(contr);
                        }
                    }
                }else{
                    if(caseRec.Contract__c != null){
                        if(caseRec.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_ENROLLMENT){
                            contr.Id = caseRec.Contract__c;
                            contr.CXE_Pending_APA_Enrollment__c = true;
                            contractToUpdate.add(contr);
                        }else if(caseRec.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_CANCELLATION){
                            contr.Id = caseRec.Contract__c;
                            contr.CXE_Reason_for_Cancellation_APA__c = caseRec.CXE_Reason_for_Cancellation_APA__c;
                            contr.CXE_Pending_APA_Cancellation__c = true;
                            contractToUpdate.add(contr);
                        }
                    }
                }
            }
        }

        if(!contractToUpdate.isEmpty()){
            try{
                update contractToUpdate;
            }catch(Exception e){
                ErrorHandlerException.recordException(contractToUpdate[0].Id, true, 'CaseTriggerHandler', 'updateContractonAPAStatusChange', e.getMessage());
            }
        }
    }
    //END CSM-14606 RReyes NOV-27-17
    //END CSM-13194 RReyes - NOV-06-17 
    
 	//Start of 	R2C CSM-14836 Von Pernicia 12-13-2017
    public void portalRegSendEmailNotification(List<Case> newCaseList){
        
        if (!newCaseList.isEmpty())
        {
            String taskSubject;
            Id emailTemplateId;

            Id emailTemplateIdforCaseCreate;
            
            List<Id> caseId = new List<Id>();
            String currentUserId = UserInfo.getUserId();
            //String currentUserEmail = UserInfo.getUserEmail();
            Map<Id, Id> mapAccountOwnerId = new Map<Id, Id>();
            List<Messaging.SingleEmailMessage> myEmails = new List<Messaging.SingleEmailMessage>();
            List<Task> listTaskToCreate = new List<task>();
            Id orgWide = [SELECT Id from OrgWideEmailAddress WHERE  Address =: CXE_Constants.ORG_WIDE_EMAIL].Id;

            // Get Email Template ID and Subject
            //EmailTemplate emailRegistration = [SELECT Id, Subject FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_BIZ_CUST_ENROLLMENT];
            //EmailTemplate emailAddtionalSin = [SELECT Id, Subject FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_BIZ_RM_ADD_SIN];
            //EmailTemplate emailCaseCreation = [SELECT Id, Subject FROM EmailTemplate WHERE developername =: CXE_Constants.EMAIL_TEMP_CASE_CREATION];

            // Assign Email Id
            Id emailTemplateIdRegistration;
            Id emailTemplateIdAddSin;
            Id emailTemplateIdCaseCreation;

            // Assign Email Subject
            String emailTemplateSubjectRegistration;
            String emailTemplateSubjectAddSin;
            String emailTemplateSubjectCaseCreation;

            for (EmailTemplate et: [SELECT Id, Subject, Developername
                                    FROM EmailTemplate 
                                    WHERE (developername =: CXE_Constants.EMAIL_TEMP_BIZ_CUST_ENROLLMENT
                                    OR developername =: CXE_Constants.EMAIL_TEMP_BIZ_RM_ADD_SIN
                                    OR developername =: CXE_Constants.EMAIL_TEMP_CASE_CREATION
                                    )])
            {
                if (et.Developername == CXE_Constants.EMAIL_TEMP_BIZ_CUST_ENROLLMENT)
                {
                    emailTemplateIdRegistration = et.Id;
                    emailTemplateSubjectRegistration = et.Subject;
                }
                else if (et.Developername == CXE_Constants.EMAIL_TEMP_BIZ_RM_ADD_SIN)
                {
                    emailTemplateIdAddSin = et.Id;
                    emailTemplateSubjectAddSin = et.Subject;
                }
                else if (et.Developername == CXE_Constants.EMAIL_TEMP_CASE_CREATION)
                {
                    emailTemplateIdCaseCreation = et.Id;
                    emailTemplateSubjectCaseCreation = et.Subject;
                }
            }
			
            String businessEmail; //START END CSM-15042 John Mark Fernandez JAN-11-2018
            for (Case c: [Select Account.OwnerId, Business_Email__c from Case Where RecordTypeId =: portalRegRecTypeId and Id in:newCaseList])// START/END CSM-15089 Rhyan Cruz 
            {
                mapAccountOwnerId.put(c.Id, c.Account.OwnerId);
                caseId.add(c.Id);
                businessEmail = c.Business_Email__c; //START END CSM-15042 John Mark Fernandez JAN-11-2018
            } 
			//START CSM-15042 John Mark Fernandez JAN-11-2018
            Id businessEmailUserId;
            for(User u: [SELECT Id, Email FROM User WHERE Email =: businessEmail]){
                businessEmailUserId = u.Id;
            }
            //END CSM-15042 John Mark Fernandez JAN-11-2018
            for (Case c: newCaseList){
                if(c.RecordTypeId == portalRegRecTypeId)
                {
                    String[] businessAddress = new String[]{c.Business_Email__c};
                    String[] primaryAddress = new String[]{c.Email_Address__c};
                        
                    if (c.CXE_isRegistrationCase__c || c.CreatedBy.UserType == 'STANDARD')
                    {
                        emailTemplateId = emailTemplateIdRegistration;
                        taskSubject = emailTemplateSubjectRegistration;
                        emailTemplateIdforCaseCreate = emailTemplateIdCaseCreation;
                        
                        // Task for Case Creation
			//START CSM-14795 JFernandez DEC-20-17
                        listTaskToCreate.add(
                            CXE_Utility.taskCreation(
                                Date.today(),
                                CXE_Constants.PORTALUSER_NOTIF_EMAIL,
                                CXE_Constants.CASE_SERVICE_APPLICATION,
                                mapAccountOwnerId .get(c.Id),
                                CXE_Constants.TASK_PRIORITY_NORMAL,
                                CXE_Constants.TASK_STATUS_COMPLETED,
                                c.AccountId,
                                emailTemplateSubjectCaseCreation,
                                c.ContactId
                            )
                        );
                        //END CSM-14795 JFernandez DEC-20-17
                        myEmails.add(CXE_Utility.emailNotif(primaryAddress, false, currentUserId, c.Id, orgWide, emailTemplateIdforCaseCreate));
                    }
                    else if (!c.CXE_isRegistrationCase__c && businessEmailUserId != null) //START END CSM-15042 John Mark Fernandez JAN-11-2018 Add businessEmailUserId != null
                    {
                        emailTemplateId = emailTemplateIdAddSin;
                        taskSubject = emailTemplateSubjectAddSin;
                        
                        myEmails.add(CXE_Utility.emailNotif(businessAddress, false, businessEmailUserId, c.Id, orgWide, emailTemplateId)); ////START END CSM-15042 John Mark Fernandez JAN-11-2018
                    }

                     if(emailTemplateId!=null){
                        //myEmails.add(CXE_Utility.emailNotif(businessAddress, false, currentUserId, c.Id, orgWide, emailTemplateId)); //START END CSM-15042 John Mark Fernandez JAN-11-2018 Commented put inside the if condition above
                        
                        // Task for Email Registration
                        //START CSM-14795 JFernandez DEC-20-17
                         listTaskToCreate.add(
                             CXE_Utility.taskCreation(
                                 Date.today(),
                                 CXE_Constants.PORTALUSER_NOTIF_EMAIL,
                                 CXE_Constants.CASE_SERVICE_APPLICATION,
                                 mapAccountOwnerId .get(c.Id),
                                 CXE_Constants.TASK_PRIORITY_NORMAL,
                                 CXE_Constants.TASK_STATUS_COMPLETED,
                                 c.AccountId,
                                 taskSubject,
                                 c.ContactId
                             )
                         );
                         //END CSM-14795 JFernandez DEC-20-17
                    } 
                }
            }   
            if(!myEmails.isEmpty()){
                Messaging.sendEmail(myEmails);
            }

            if (!listTaskToCreate.isEmpty())
            {
                insert listTaskToCreate;
            }

            if (!caseId.isEmpty())
            {
                autoCreateServiceAddress(caseId);
            }
        }
    }   
    
    @future
    static void autoCreateServiceAddress(List<Id> caseIds){

        if (!caseIds.isEmpty())
        {
            List<Case> lstCase = new List<Case>();
            Id userId = [Select Id from User where Name='Meralco'].Id;
            for (Case c: [Select Id, OwnerId from Case where id in: caseIds])
            {   
                c.OwnerId = userId;
                lstCase.add(c);
            }
            if (!lstCase.isEmpty())
            {
                update lstCase;
            }
        }
    }
     //End of R2C CSM-14836 Von Pernicia 12-13-2017

    
    /* Description: CSM-14973
     * Parameters: Map<Id, Case> newCase, Map<Id, Case> oldCase 
     * Returns: Void
     * Author: Rom Edison Reyes 
     * Date Created: DEC-26-17
     */
     //START CSM-14973 RReyes DEC-26-17 - APA Issue #1
    public void updateAPAAgentBasedOnContract(List<Case> newCases, Map<Id, Case> oldCases, Boolean isUpdate){
        List<Case> casesToUpdate = new List<Case>();
        Map<Id, Contract> contractMap = new Map<Id, Contract>();
        Set<String> contractIds = new Set<String>();
        for(Case caseRec: newCases){
            if(caseRec.RecordTypeId == apaEnrollmentRecTypeId && caseRec.Application_Type_Subtype__c == CXE_Constants.SERVICE_REQ_APA_CANCELLATION){
                if(caseRec.Contract__c != null){
                    if(isUpdate){
                        if(caseRec.Contract__c != oldCases.get(caseRec.Id).Contract__c){
                            casesToUpdate.add(caseRec);
                            contractIds.add(caseRec.Contract__c);
                        }
                    }else{
                       casesToUpdate.add(caseRec); 
                       contractIds.add(caseRec.Contract__c);
                    }
                }
            }
        }

        if(!contractIds.isEmpty()){
            contractMap = new Map<Id, Contract>([SELECT Id, CXE_APA_Agent__c From Contract WHERE Id IN:contractIds]);
        }

        if(!casesToUpdate.isEmpty() && contractMap != null){
            Contract contr = new Contract();
            for(Case cas : casesToUpdate){
                contr = contractMap.get(cas.Contract__c);
                cas.CXE_APA_Agent__c = contr.CXE_APA_Agent__c;
            }
        }
    }
    //END CSM-14973 RReyes DEC-26-17 - APA Issue #1

}