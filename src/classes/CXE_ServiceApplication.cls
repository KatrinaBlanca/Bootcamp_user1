//CSM-12533 Start Jerome To - change to without Sharing
public without sharing class CXE_ServiceApplication {
    public CXE_ServiceApplication() {
        
    }
    //START JEROME TO   MAY-29-17
    static final Set<String> contractModifications;
    static{
        contractModifications = new Set<String>();
        for (Contract_Modification__mdt cm: [SELECT MasterLabel FROM Contract_Modification__mdt ORDER BY MasterLabel ASC]) { //Add sorting for masterlabel CSM-14265 jfernandez 11072017
            contractModifications.add(cm.MasterLabel);
        }
    }
    static final Map<String, Case_Status_Setting__mdt> statusJourneyMap;
    static{
        statusJourneyMap = new Map<String, Case_Status_Setting__mdt>();
        for (Case_Status_Setting__mdt setting : [SELECT MasterLabel, Service_Application_Journey__c, Service_Application_Journey_Remarks__c
                                                 FROM Case_Status_Setting__mdt
                                                 WHERE Service_Application_Journey__c != '']) {         
                statusJourneyMap.put(setting.MasterLabel, setting);
        }
    }


    //END JEROME TO   MAY-29-17

    @AuraEnabled
    public static List<String> getServiceModifications(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Case.CXE_Service_Request_s__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            if(!contractModifications.isEmpty() && !contractModifications.contains(f.getLabel())) {
                options.add(f.getLabel());
            }            
        }    
        return options;    
    }

    @AuraEnabled
    public static List<String> getContractModifications(){
        List<String> options = new List<String>();
        for (String strVal : contractModifications) {
            options.add(strVal);
        }
        return options;
    }
    
    //Start CSM-14342 Mike Verdad 11/08/2017
     @AuraEnabled
    public static List<String> getServiceModificationsContractor(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Case.CXE_Service_Request_s__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            if(!contractModifications.isEmpty() && !contractModifications.contains(f.getValue())) {

                if(f.getValue() == System.Label.Additional_Load){
                    options.add(System.Label.Request_for_additional_electrical_load);   
                }
                
                if(f.getValue() == System.Label.Reduction_in_Load){
                    options.add(System.Label.Request_to_downgrade_electrical_load);   
                }
                
                if(f.getValue() == System.Label.Relocation){
                    options.add(System.Label.Relocate_the_meter);   
                }
                
                if(f.getValue() == System.Label.Remodel){
                    options.add(System.Label.Remodel_the_meter);   
                }

                //options.add(f.getLabel());

            }            
        }    
        
        
        
        
        return options;    
    }

    @AuraEnabled
    public static List<String> getContractModificationsContractor(){
        List<String> options = new List<String>();
        for (String strVal : contractModifications) {

            if(strVal == System.Label.Change_in_Contract_Name){
   				 options.add(System.Label.Change_the_name_on_my_bill);   
            }
            
            if(strVal == System.Label.Transfer_of_Service){
   				options.add(System.Label.Update_contract_information);   
            }
            
           // options.add(strVal);
        }
        return options;
    }
    //End CSM-14342 Mike Verdad 11/08/2017

 //   @AuraEnabled
 //   public static CXE_CaseResponseWrapper submitSAForModification(Case caseApplication, String referenceNumber){
 //     try {
 //         List<CXE_CaseResponseWrapper> responseList = new List<CXE_CaseResponseWrapper>();
 //         Set<Id> newCaseIds = new Set<Id>();
 //         List<Agreement__c> serviceList = [SELECT Id FROM Agreement__c WHERE SIN__c =:referenceNumber];

 //         if(serviceList.isEmpty()) {
 //             CXE_CaseResponseWrapper response = new CXE_CaseResponseWrapper();
    //          response.hasError=true;
    //          response.errorMessage = CXE_Constants.WEB_TO_CASE_ERROR_NO_SERVICE_RECORD_FOUND;
    //          response.errorMessages = new List<String> {CXE_Constants.WEB_TO_CASE_ERROR_NO_SERVICE_RECORD_FOUND};
    //          responseList.add(response);
 //         } else {
 //             caseApplication.CXE_Service__c = serviceList.get(0).Id;
 //         }

 //         caseApplication.RecordTypeId = [SELECT Id 
    //                                      FROM RecordType 
    //                                      WHERE SObjectType = 'Case' 
    //                                      AND DeveloperName =:CXE_Constants.CASE_RECORD_TYPE_MODIFICATION_OF_ELECTRIC_SERVICE 
    //                                      AND IsActive = true].Id;

 //         caseApplication.CXE_Service__r = null;
 //         caseApplication.Origin = CXE_Constants.RECORD_TYPE_NAME_OFFICE_WEB;
            

    //      // Specify DML options to ensure the assignment rules are executed
    //      Database.DMLOptions dmlOpts = new Database.DMLOptions();
    //      dmlOpts.assignmentRuleHeader.useDefaultRule = true;
    //      caseApplication.setOptions(dmlOpts);
            
    //      List<Database.SaveResult> srList = Database.Insert(new List<Case> {caseApplication}, false);

    //      for (Database.SaveResult sr : srList) {
    //          if (sr.isSuccess()) {
    //              CXE_CaseResponseWrapper response = new CXE_CaseResponseWrapper();
    //              response.hasError=false;
    //              response.caseRecordId=sr.getId();
    //              responseList.add(response);
    //              newCaseIds.add(sr.getId());
    //          } else {
    //              String errors = '';             
    //              List<String> errorList = new List<String>();
    //              errorList.add(CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING1);
    //              for(Database.Error err : sr.getErrors()) {
    //                  //errors += err.getStatusCode() + ': ' + err.getMessage();
    //                  errorList.add(err.getMessage());
    //                  //errors += CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING2 + err.getFields();
    //              }
    //              errors += String.join(errorList, '\n\n');
    //              CXE_CaseResponseWrapper response = new CXE_CaseResponseWrapper();
    //              response.hasError=true;
    //              response.errorMessage = errors;
    //              response.errorMessages = errorList;
    //              responseList.add(response);
    //          }
    //      }

    //      if(!newCaseIds.isEmpty()) {
    //          Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, CaseNumber FROM Case WHERE Id=:newCaseIds]);
    //          for(CXE_CaseResponseWrapper response : responseList) {
    //              if(!response.hasError) {
    //                  response.caseNumber = caseMap.get(response.caseRecordId).CaseNumber;
    //              }
    //          }
    //      }

    //      return responseList.get(0);

    //  } catch(Exception e) {
    //      CXE_CaseResponseWrapper response = new CXE_CaseResponseWrapper();
    //      response.hasError = true;
    //      response.errorMessage = e.getMessage();
    //      response.errorMessages = new List<String> {e.getMessage()};
    //      return response;
    //  }
    //}



    @AuraEnabled
    public static Case initNewCase(){
        //return new Case();
        Case caseRec = (Case)Case.sObjectType.newSObject(null, true);
        caseRec.CXE_Request_Date__c = null;
        return caseRec;
    }
    
    @AuraEnabled
    public static Case newPortalCase(){
        User user = [SELECT Contact.Email, Contact.FirstName, Contact.LastName, Contact.MiddleName
                            , Contact.MobilePhone, Contact.Birthdate, Contact.Phone
                        FROM User WHERE Id=: UserInfo.getUserId()];
        Case caseRecord = new Case();

        caseRecord.CXE_Web_First_Name__c = user.Contact.FirstName;
        caseRecord.CXE_Web_Middle_Name__c = user.Contact.MiddleName;
        caseRecord.CXE_Web_Last_Name__c = user.Contact.LastName;
        caseRecord.CXE_Web_Primary_Email__c = user.Contact.Email;
        caseRecord.CXE_Web_Primary_Mobile__c = user.Contact.MobilePhone;
        caseRecord.CXE_Web_Primary_Phone__c = user.Contact.Phone;
        caseRecord.CXE_Web_Date_of_Birth__c = user.Contact.Birthdate;

        return caseRecord;
    }

    //START CSM-11286 RReyes AUG-17-17
    @AuraEnabled
    public static String getPersona(){
        User user = [SELECT Contact.Account.IsPersonAccount
                        FROM User WHERE Id=: UserInfo.getUserId()];
        String persona = '';
        
        if(user.Contact.Account.IsPersonAccount){
            persona = 'Ind';
        }else{
            persona = 'Biz';
        }
        return persona;
    }
    //END CSM-11286 RReyes AUG-17-17

    @AuraEnabled
    public static CXE_CaseResponseWrapper submitServiceApplication(String jsonCaseApplication, String serviceApplicationType){
        System.debug('here1' + jsonCaseApplication);
        Case caseVal = (Case)JSON.deserialize(jsonCaseApplication, Case.class);
        CXE_CaseResponseWrapper wrap = submitServiceApplication(caseVal, serviceApplicationType);
        return wrap;
    }

    @AuraEnabled
    public static CXE_CaseResponseWrapper submitServiceApplication(Case caseApplication, String serviceApplicationType){
        try {
            // START CSM-14414 Jerome To [R2C Regression] Portal user is allowed to generate a case on a service not related to his Account or Portal User
            Boolean isLoggedInPortalUser = isLoggedInPortalUser();
            // END CSM-14414 Jerome To [R2C Regression] Portal user is allowed to generate a case on a service not related to his Account or Portal User

            List<CXE_CaseResponseWrapper> responseList = new List<CXE_CaseResponseWrapper>();
            Set<Id> newCaseIds = new Set<Id>();
            String strSIN = caseApplication.Account_No__c;

            Map<String, Id> caseRecordTypes = new Map<String, Id>();
            for(RecordType recType : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Case' AND IsActive = true]){
                caseRecordTypes.put(recType.DeveloperName, recType.Id);
            }

            if (caseRecordTypes.containsKey(serviceApplicationType)) {
                caseApplication.RecordTypeId = caseRecordTypes.get(serviceApplicationType);
            }
            
            // clean data
            caseApplication.Account_No__c = null;           

            if(caseApplication.Relationship__c == '--- None ---') {
                caseApplication.Relationship__c = null;
            }
            if(caseApplication.Service_Address_Province__c == '--- None ---') {
                caseApplication.Service_Address_Province__c = null;
            }

            if(caseApplication.Service_Address_City_Municiple__c == '--- None ---') {
                caseApplication.Service_Address_City_Municiple__c = null;
            }
            if(caseApplication.Billing_Address_Province__c == '--- None ---') {
                caseApplication.Billing_Address_Province__c = null;
            }

            if(caseApplication.Billing_Address_City_Municipal__c == '--- None ---') {
                caseApplication.Billing_Address_City_Municipal__c = null;
            }

            if(caseApplication.Same_As_Service_Address__c) {
                caseApplication.Address_2__c = caseApplication.Address_1__c;
                caseApplication.Billing_Address_City_Municipal__c = caseApplication.Service_Address_City_Municiple__c;
                caseApplication.Billing_Address_Province__c = caseApplication.Service_Address_Province__c;
            }
            //caseApplication.CXE_Service__r = null;
            caseApplication.Origin = CXE_Constants.RECORD_TYPE_NAME_OFFICE_WEB;

            if(caseApplication.RecordTypeId == caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_NEW_SERVICE_APPLICATION)) {
                caseApplication.Initial_Responsible_Office__c = getInitialResponsibleOffice(caseApplication);
            } else { 
                // START CSM-14414 Jerome To [R2C Regression] Portal user is allowed to generate a case on a service not related to his Account or Portal User
                List<Agreement__c> serviceList = [SELECT Id FROM Agreement__c WHERE SIN__c =:strSIN AND SIN__c != ''];
                if(isLoggedInPortalUser && !serviceList.isEmpty() && !isServiceRelatedToPortalUser(strSIN) && serviceApplicationType != CXE_Constants.CASE_RECORD_TYPE_RECONTRACT_OF_ELECTRIC_SERVICE) { // CSM-14675 Mike Verdad [R2C Regression] 11/27/2017
                    return serviceNotFound();
                } else {                    
                    // START CSM-14400 Jerome To [R2C Regression] Unable to create a Recontracting case for SINs that are not present in Salesforce
                    if(serviceList.isEmpty() && serviceApplicationType != CXE_Constants.CASE_RECORD_TYPE_RECONTRACT_OF_ELECTRIC_SERVICE) {
                        return serviceNotFound();
                    } else {

                        // START CSM-14646 Jerome To 11/23/2017 [R2C SQT] Service record existing in Salesforce for terminated service are being linked to Case if a customer files for Recontract via web2case
                        //if(serviceList.isEmpty() && serviceApplicationType == CXE_Constants.CASE_RECORD_TYPE_RECONTRACT_OF_ELECTRIC_SERVICE) {
                        //    caseApplication.CXE_Previous_SIN__c = strSIN;
                        //}else {
                        //    caseApplication.CXE_Service__c = serviceList.get(0).Id;
                        //}

                        if(serviceApplicationType == CXE_Constants.CASE_RECORD_TYPE_RECONTRACT_OF_ELECTRIC_SERVICE) {
                            caseApplication.CXE_Previous_SIN__c = strSIN;
                            caseApplication.CXE_Service__c = null;
                        }else {
                            caseApplication.CXE_Service__c = serviceList.get(0).Id;
                        }
                        // END CSM-14646 Jerome To 11/23/2017 [R2C SQT] Service record existing in Salesforce for terminated service are being linked to Case if a customer files for Recontract via web2case
                    }
                    // END CSM-14400 Jerome To [R2C Regression] Unable to create a Recontracting case for SINs that are not present in Salesforce
                }
                // END CSM-14414 Jerome To [R2C Regression] Portal user is allowed to generate a case on a service not related to his Account or Portal User                
            }

            // START CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
            Id contactId = CXE_CP_PortalUtility.getCurrentUserContacId();
            if(contactId != null){
                caseApplication.ContactId = contactId;
            }
            // END CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab

            // Specify DML options to ensure the assignment rules are executed
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.useDefaultRule = true;
            caseApplication.setOptions(dmlOpts);
            
            List<Database.SaveResult> srList = Database.Insert(new List<Case> {caseApplication}, false);

            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    CXE_CaseResponseWrapper response = new CXE_CaseResponseWrapper();
                    response.hasError=false;
                    response.caseRecordId=sr.getId();
                    responseList.add(response);
                    newCaseIds.add(sr.getId());
                } else {
                    String errors = '';             
                    List<String> errorList = new List<String>();
                    errorList.add(CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING1);
                    for(Database.Error err : sr.getErrors()) {
                        //errors += err.getStatusCode() + ': ' + err.getMessage();
                        errorList.add(err.getMessage());
                        //errors += CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING2 + err.getFields();
                    }
                    errors += String.join(errorList, '\n\n');
                    ErrorHandlerException.recordException(null, true, 'CXE_ServiceApplication', 'submitServiceApplication', errors);
                    CXE_CaseResponseWrapper response = new CXE_CaseResponseWrapper();
                    response.hasError=true;
                    response.errorMessage = errors;
                    response.errorMessages = errorList;
                    responseList.add(response);
                }
            }

            if(!newCaseIds.isEmpty()) {
                Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, CaseNumber, Preferred_Mode_of_Notification__c, Account.Name FROM Case WHERE Id=:newCaseIds]);
System.debug(' >>>caseMap: ' +caseMap);
                for(CXE_CaseResponseWrapper response : responseList) {
                    if(!response.hasError) {
                        response.caseNumber = caseMap.get(response.caseRecordId).CaseNumber;
                        //START     CSM-12473 GGrandea 09.07.2017
                        if(caseMap.get(response.caseRecordId).Preferred_Mode_of_Notification__c!=null){
                            response.notificationChannels = caseMap.get(response.caseRecordId).Preferred_Mode_of_Notification__c;
                        }
                        
                        response.caseRecord = caseMap.get(response.caseRecordId);
                        //response.notificationChannels = caseMap.get(response.caseRecordId).Preferred_Mode_of_Notification__c;
                        //END       CSM-12473 GGrandea 09.07.2017
                    }
                }
            }

            return responseList.get(0);

        } catch(Exception e) {
            ErrorHandlerException.recordException(null, true, 'CXE_ServiceApplication', 'submitServiceApplication', e.getMessage());
            CXE_CaseResponseWrapper response = new CXE_CaseResponseWrapper();
            response.hasError = true;
            response.errorMessage = e.getMessage() ;
            response.errorMessages = new List<String> {e.getMessage()};
            return response;
        }
    }

    static CXE_CaseResponseWrapper serviceNotFound() {
        CXE_CaseResponseWrapper response = new CXE_CaseResponseWrapper();
        response.hasError=true;
        response.errorMessage = CXE_Constants.WEB_TO_CASE_ERROR_NO_SERVICE_RECORD_FOUND;
        response.errorMessages = new List<String> {CXE_Constants.WEB_TO_CASE_ERROR_NO_SERVICE_RECORD_FOUND};
        return response;
    }

    @AuraEnabled
    public static CXE_CaseResponseWrapper trackApplication(String referenceNumber, String lastName){

        // START CSM-14178 Jerome To added Service_Address_from_Web__c
        List<Case> caseApplications = [SELECT Id, Status, CaseNumber, CreatedDate, RecordTypeId,
                                              RecordType.Name, CXE_Service_Address_R2__c, Application_for_Residential_Service__c,
                                              Application_for_Residential_Customer__c, First_Name__c, Last_Name__c,
                                              Application_Type_Subtype__c, Service_Address_from_Web__c   // CSM-14009 LISEN 20171021 : fix to show Request Type for Paperless Billing
                                       FROM Case 
                                       WHERE CaseNumber =:referenceNumber
                                       AND Last_Name__c =:lastName];
        // END CSM-14178 Jerome To added Service_Address_from_Web__c

        CXE_CaseResponseWrapper response = new CXE_CaseResponseWrapper();

        if(caseApplications.isEmpty()) {    
            response.hasError=true;
            response.errorMessage = 'No record found.';
            response.errorMessages = new List<String>{ 'No record found.' };
        } else {
                    
            List<CXE_CaseHistoryWrapper> caseStatusHistoryList = CXE_Utility.getCaseStatusHistory(caseApplications.get(0), statusJourneyMap);
            // START CSM-7248   Jerome To   JUL-04-2017
            List<RecordType> caseTerminateRecordType = [SELECT Id 
                                                        FROM RecordType 
                                                        WHERE SObjectType = 'Case' 
                                                        AND IsActive = true 
                                                        AND DeveloperName =: CXE_Constants.CASE_RECORD_TYPE_TERMINATION_OF_ELECTRIC_SERVICE];
            // END CSM-7248     Jerome To   JUL-04-2017
            
            CXE_CaseHistoryWrapper initialCh = new CXE_CaseHistoryWrapper();
            initialCh.CaseId = caseApplications.get(0).Id;
            initialCh.CreatedDate = caseApplications.get(0).CreatedDate;
            //START CSM-14139 JRances / UAT, Paperless Billing status in Request tab should be Open/Rejected/Successful not "Application Received"
            initialCh.NewValue = (caseApplications.get(0).RecordType.Name == 'Paperless Billing' ? ( caseStatusHistoryList.isEmpty() ? caseApplications.get(0).Status : CXE_Constants.CASE_STATUS_OPEN ) : CXE_Constants.CASE_APPLICATION_RECEIVED); 
            //initialCh.NewValue = CXE_Constants.CASE_APPLICATION_RECEIVED;
            //END CSM-14139 JRances
            caseStatusHistoryList.add(initialCh);
            
            if(caseStatusHistoryList.isEmpty()) {
                response.hasError=true;
                response.errorMessage = 'No Case History record found.';
                response.errorMessages = new List<String>{ 'No Case History record found.' };
            } else {
                response.hasError = false;
                response.caseRecordId = caseApplications.get(0).Id;
                response.caseNumber = caseApplications.get(0).CaseNumber;
                response.isTerminate = (!caseTerminateRecordType.isEmpty() && caseApplications.get(0).RecordTypeId == caseTerminateRecordType.get(0).Id); // CSM-7248   Jerome To   JUL-04-2017
                response.caseStatusHistoryList = caseStatusHistoryList;
                System.debug('caseStatusHistoryList >>> ' + response.caseStatusHistoryList);
                if(statusJourneyMap.containsKey(caseApplications.get(0).Status)) {
                    // Start    CSM-7294    Jerome To       07/10/2017
                    String statusJourney = statusJourneyMap.get(caseApplications.get(0).Status).Service_Application_Journey__c;
                    List<String> journeys = statusJourney.split(',');
                    response.statusJourney = (journeys.size() == 1) ? journeys.get(0) : (response.isTerminate ? journeys.get(1) : journeys.get(0));
                    // End  CSM-7294    Jerome To       07/10/2017
                }   
                response.caseRecord = caseApplications.get(0);
            }        
        }
        return response;  
    }

    /* Description: get Relationship picklist
     * Parameters: none
     * Returns: List<SelectOption>
     * Author: Jerome To 
     */
    @AuraEnabled
    public static List<String> getRelationToCustomer(String persona){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Case.Relationship__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add('--- None ---');
        for (Schema.PicklistEntry f: ple) {
            if(persona == CXE_Constants.WEB_TO_CASE_PERSONA_CONTRACTOR && f.getLabel() == CXE_Constants.WEB_TO_CASE_PERSONA_CONTRACTOR) {
                options.add(f.getLabel());              
            } else if(persona != CXE_Constants.WEB_TO_CASE_PERSONA_CONTRACTOR && f.getLabel() != CXE_Constants.WEB_TO_CASE_PERSONA_CONTRACTOR) {
                options.add(f.getLabel());
            }           
        }
        return options;
    }

    /* Description: Gets IRO
     * Parameters: none
     * Returns: void
     * Author: Jerome To
     */
    static String getInitialResponsibleOffice(Case caseRecord) {
        String responsibleOfficeString = '';
        if(String.isNotBlank(caseRecord.Service_Address_City_Municiple__c)) {
            List<Reference__c> ref = [SELECT Id FROM Reference__c 
                                     WHERE Name =:caseRecord.Service_Address_City_Municiple__c 
                                     AND Field__c =:CXE_Constants.REFERENCE_FIELD_CITY];

            if(!ref.isEmpty()) {
                Set<String> responsibleOfficeList = new Set<String>();
                Set<Id> officeIds = new Set<Id>();

                //Michael Lasala MAR-28-17 CSM-2035: Changed recordtype filter to HMB
                for( Office_Jurisdiction__c oj : [SELECT  Id, Office__r.Name, Office__r.RecordType.Name, 
                                                          Street_Name__c, City__c, Office__c
                                                  FROM    Office_Jurisdiction__c 
                                                  WHERE   City__c =:ref.get(0).Id
                                                  AND     Office__r.RecordType.Name =:CXE_Constants.RECORD_TYPE_NAME_OFFICE_HMB]) {
                    
                    if(!officeIds.contains(oj.Office__c)){
                        responsibleOfficeList.add(oj.Office__r.Name);
                        //Add office id to filter out unique offices
                        officeIds.add(oj.Office__c);
                    }
                }

                if(!responsibleOfficeList.isEmpty()) {                    
                    responsibleOfficeString = String.join(new List<String>(responsibleOfficeList) , ',');                    
                }
            }
        }
        return responsibleOfficeString;
    }

    // START CSM-14414 Jerome To [R2C Regression] Portal user is allowed to generate a case on a service not related to his Account or Portal User
    /* 
     * Description: get services of current portal user
     * Parameters: n/a
     * Returns: Set<String>
     * Author: Jerome To (Accenture)
     * Date Created: NOV-13-2017
    */  
    private static Set<String> getRelatedServices() {
        Set<String> serviceNumbers = new Set<String>();
        for(CXE_Service_Enrollment__c enrolment : [SELECT CXE_ServiceId__r.SIN__c FROM CXE_Service_Enrollment__c WHERE CXE_UserId__c =:UserInfo.getUserId()]) {
            serviceNumbers.add(enrolment.CXE_ServiceId__r.SIN__c);
        }
        return serviceNumbers;
    }

    private static Boolean isServiceRelatedToPortalUser(String sin) {
        return [SELECT Count() FROM CXE_Service_Enrollment__c WHERE CXE_UserId__c =:UserInfo.getUserId() AND CXE_ServiceId__r.SIN__c =:sin] > 0;
    }

    private static Boolean isPortalUser() {
        return [SELECT Count() FROM User WHERE Id =:UserInfo.getUserId() AND (Profile.Name=:CXE_Constants.PORTAL_COMMUNITY_PROFILE OR Profile.Name=:CXE_Constants.PORTAL_COMMUNITY_PROFILE OR Profile.Name=:CXE_Constants.PORTAL_COMMUNITY_PROFILE_CONGLOMERATE)] > 0;
    }

    private static Boolean isLoggedInPortalUser() {
        return [SELECT Count() FROM User WHERE Id =:UserInfo.getUserId() AND (Profile.Name=:CXE_Constants.PORTAL_COMMUNITY_PROFILE OR Profile.Name=:CXE_Constants.PORTAL_COMMUNITY_PROFILE_CONGLOMERATE)] > 0;
    }
    // END CSM-14414 Jerome To [R2C Regression] Portal user is allowed to generate a case on a service not related to his Account or Portal User

        
}