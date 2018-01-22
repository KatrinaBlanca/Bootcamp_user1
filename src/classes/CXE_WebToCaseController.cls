/* 
 * Description: Controller for CXE_ServiceAppResidential, CXE_ServiceAppBusiness, CXE_ModifyServiceAppIndividual, CXE_ModifyServiceAppBusiness for VF Pages
 * Author: Jerome To
 * Date Created: MAY-28-17
*/
public with sharing class CXE_WebToCaseController {
    //
    public CXE_WebToCaseController() {
        caseRecord = new Case();
        caseRecord.Origin = CXE_Constants.CASE_ORIGIN_WEB;
        customerAddressRecord = new Address__c();
        businessAddressRecord = new Address__c();
        contractModificationList = getContractModificationMDT();
    }

    public Case caseRecord {get; set;}
    public String caseNumber {get; set;}
    public Address__c customerAddressRecord {get; set;}
    public Address__c businessAddressRecord {get; set;}

    public Boolean smsCb {get;set;}
    public Boolean emailCb {get;set;}

    public String amcSelect {get;set;}
    public String hasAppliedForSomeone {get;set;}

    public String sameAsServiceAddressSelect {get;set;}
    private Set<String> contractModificationList {get;set;}
    public String contractModificationSelect {get;set;}
    public String serviceModificationSelect {get;set;}
    public String modeOfNotificationSelect {get;set;}
    public Boolean hasAgreedToTermsAndConditions {get;set;}


    /* Description: get AMC Options
     * Parameters: none
     * Returns: List<SelectOption>
     * Author: Jerome To - CSM-153
     */
    public List<SelectOption> getAMCOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }

    /* Description: get Same for Billing Text
     * Parameters: none
     * Returns: List<SelectOption>
     * Author: Jerome To - CSM-153
     */
    public List<SelectOption> getSameForBilling() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(CXE_Constants.WEB_TO_CASE_SAME_AS_BILLING, CXE_Constants.WEB_TO_CASE_SAME_AS_BILLING)); 
        options.add(new SelectOption(CXE_Constants.WEB_TO_CASE_NOT_SAME_AS_BILLING, CXE_Constants.WEB_TO_CASE_NOT_SAME_AS_BILLING)); 
        return options; 
    }

    /* Description: get Relationship picklist
     * Parameters: none
     * Returns: List<SelectOption>
     * Author: Jerome To - CSM-153
     */
    public List<SelectOption> getRelationships() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Case.Relationship__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(new SelectOption(f.getLabel(),f.getValue()));
        }
        return options;  
    }

    /* Description: get Salutations picklist
     * Parameters: none
     * Returns: List<SelectOption>
     * Author: Jerome To - CSM-153
     */
    public List<SelectOption> getSalutations() {
        Set<String> availableSalutations = new Set<String> {'Mr.', 'Ms.', 'Mrs.'};
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Case.Salutation__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            if(availableSalutations.contains(f.getLabel())) {
                options.add(new SelectOption(f.getLabel(),f.getValue()));
            }
        }
        return options;        
    }

    /* Description: get Home Ownership picklist
     * Parameters: none
     * Returns: List<SelectOption>
     * Author: Jerome To - CSM-153
     */
    public List<SelectOption> getHomeOwnership() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Case.Home_Ownership__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(new SelectOption(f.getLabel(),f.getValue()));
        }
        return options;        
    }

    /* Description: Submit Business SA
     * Parameters: none
     * Returns: PageReference
     * Author: Jerome To - CSM-153
     */
    public PageReference submitBusiness() {
        if(isVerified()) {
            caseRecord.Tax_Identification_No__c = '000000000000';
            caseRecord.Application_for_Business_Service__c = true;
            caseRecord.Application_for_Business_Customer__c = true;
            //CSM Rhyan Cruz Via Email is set to default
            emailCb = true;
            smsCb = false;
            caseRecord.Automatically_receive_SMS__c = smsCb;
            caseRecord.Automatically_receive_an_e_mail__c = emailCb;
            caseRecord.Preferred_Mode_of_Notification__c = (smsCb && emailCb?'SMS & Email': (smsCb?'SMS':(emailCb?'Email':'')));
            // Specify DML options to ensure the assignment rules are executed
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.useDefaultRule = true;
            caseRecord.setOptions(dmlOpts);

            List<Database.SaveResult> srList = Database.insert(new List<Case> {caseRecord}, false);

            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, CaseNumber FROM Case WHERE Id=:sr.getId()]);                
                    Pagereference pageRef = Page.CXE_ServiceAppBusinessThankYou;
                    pageref.getParameters().put('casenumber',caseMap.get(sr.getId()).CaseNumber);
                    return pageRef;
                }
                else {
                    String errors = '';             
                    List<String> errorList = new List<String>();
                    errorList.add(CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING1);
                    for(Database.Error err : sr.getErrors()) {
                        //errors += err.getStatusCode() + ': ' + err.getMessage();
                        errorList.add(err.getMessage());
                        //errors += CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING2 + err.getFields();
                    }
                    errors += String.join(errorList, '<br/>');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, errors));
                    return null;
                }
            }
            return null;
        } else {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, CXE_Constants.WEB_TO_CASE_CAPTCHA_ERROR);
            ApexPages.addMessage(errorMsg);
            return null;
        }
    }

    /* Description: Submit Residential SA
     * Parameters: none
     * Returns: PageReference
     * Author: Jerome To - CSM-153
     */
    public PageReference submitResidential() {
        if(isVerified()) {
            caseRecord.Application_for_Residential_Service__c = true;
            caseRecord.Application_for_Residential_Customer__c = true;
            //CSM Rhyan Cruz Via Email is set to default
            emailCb = true;
            smsCb = false;
            caseRecord.Automatically_receive_SMS__c = smsCb;
            caseRecord.Automatically_receive_an_e_mail__c = emailCb;
            caseRecord.Preferred_Mode_of_Notification__c = (smsCb && emailCb?'SMS & Email': (smsCb?'SMS':(emailCb?'Email':'')));
            getInitialResponsibleOffice();
            if(sameAsServiceAddressSelect != null) {
                caseRecord.Same_As_Service_Address__c = (!sameAsServiceAddressSelect.equals(CXE_Constants.WEB_TO_CASE_NOT_SAME_AS_BILLING));
                // START CSM-2025         Jerome To       MAR-28-17
                if(caseRecord.Same_As_Service_Address__c) {
                    caseRecord.Address_2__c = caseRecord.Address_1__c;
                    caseRecord.Billing_Address_City_Municipal__c = caseRecord.Service_Address_City_Municiple__c;
                    caseRecord.Billing_Address_Province__c = caseRecord.Service_Address_Province__c;
                }
                // END CSM-2025         Jerome To       MAR-28-17              
            }
            if(amcSelect != null) {
                //caseRecord.AMC_Service_Requested__c = (amcSelect=='Yes');
                caseRecord.AMC_Service_Tag__c = (amcSelect=='Yes');
                
            }
            if(hasAppliedForSomeone != null) {
                caseRecord.Has_Applied_for_Someone__c = (hasAppliedForSomeone=='Yes');
            }

            if(!caseRecord.Has_Applied_for_Someone__c) {
                caseRecord.Authorized_Representative_First_Name__c = '';
                caseRecord.Authorized_Representative_Middle_Name__c = '';
                caseRecord.Authorized_Representative_Last_Name__c = '';
                caseRecord.Authorized_Rep_Primary_Contact_Number__c = '';
                caseRecord.Authorized_Representative_Email__c = '';
                caseRecord.Relationship__c = '';
            }
                       
            // Specify DML options to ensure the assignment rules are executed
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.useDefaultRule = true;
            caseRecord.setOptions(dmlOpts);

            List<Database.SaveResult> srList = Database.insert(new List<Case> {caseRecord}, false);

            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    upload(); // upload file and attach to case
                    Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, CaseNumber FROM Case WHERE Id=:sr.getId()]);                
                    Pagereference pageRef = Page.CXE_ServiceAppResidentialThankYou;
                    pageref.getParameters().put('casenumber',caseMap.get(sr.getId()).CaseNumber);
                    return pageRef;
                }
                else {
                    String errors = '';             
                    List<String> errorList = new List<String>();
                    errorList.add(CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING1);
                    for(Database.Error err : sr.getErrors()) {
                        //errors += err.getStatusCode() + ': ' + err.getMessage();
                        errorList.add(err.getMessage());
                        //errors += CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING2 + err.getFields();
                    }
                    errors += String.join(errorList, '<br/>');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, errors));
                    return null;
                }
            }
            return null;
        } else {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, CXE_Constants.WEB_TO_CASE_CAPTCHA_ERROR);
            ApexPages.addMessage(errorMsg);
            return null;
        }
    }


    public Attachment attachment {
        get {
            if (attachment == null)
            attachment = new Attachment();
            return attachment;
        }
        set;
    }

    /* Description: File Upload / Attachment
     * Parameters: none
     * Returns: PageReference
     * Author: Jerome To - CSM-153
     */
    public void upload() {
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = caseRecord.Id;
        attachment.IsPrivate = false;
        try {
            System.debug('>>>>>>>>>>>>>>> attaching file :' + attachment);
            insert attachment;
        } catch (DMLException e) {
            System.debug('>>>>>>>>>>>>>>> error attaching file:' + e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
        } finally {
            attachment = new Attachment(); 
        }
    }
    
    private static String baseUrl = Label.CXE_reCaptcha_Base_Url;
    
    private static String secret = Label.CXE_reCaptcha_Secret_Key;
    
    public String sitekey {
        get { return Label.CXE_reCaptcha_Site_Key; }
    }
    public String response  { 
        get { return ApexPages.currentPage().getParameters().get('g-recaptcha-response'); }
    }
    
    // this method is called when the button is clicked    
    private Boolean isVerified () {

        String responseBody = makeRequest(baseUrl,
                'secret=' + secret +
                '&response='+ response
        );
        String success = getValueFromJson(responseBody, 'success');
        return success.equalsIgnoreCase('true');        
    }
    
    /**
     * Make request to verify captcha
     * @return      response message from google
     */
    private static String makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        
        try {
            Http http = new Http();
            response = http.send(req);
            return response.getBody();
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return '{"success":false}';
    }   
    
    /**
     * to get value of the given json string
     * @params      
     *  - strJson       json string given
     *  - field         json key to get the value from
     * @return          string value
     */
    public static string getValueFromJson ( String strJson, String field ){
        JSONParser parser = JSON.createParser(strJson);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                if(parser.getText() == field){
                    // Get the value.
                    parser.nextToken();
                    return parser.getText();
                }
            }
        }
        return null;
    }

    /* Description: Gets IRO
     * Parameters: none
     * Returns: void
     * Author: Jerome To - CSM-153
     */
    @TestVisible private void getInitialResponsibleOffice() {
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
                    String responsibleOfficeString = '';

                    for(String s: responsibleOfficeList){
                        responsibleOfficeString += s+',';
                    }
                    
                    responsibleOfficeString = responsibleOfficeString.subString(0, responsibleOfficeString.length() - 1);
                    caseRecord.Initial_Responsible_Office__c = responsibleOfficeString;
                }
            }
        }
    }

    /* Description: Submit Modify Business SA
     * Parameters: none
     * Returns: PageReference
     * Author: Jerome To - CSM-3801
     */
    public PageReference submitModifyBusiness() {
        if(isVerified()) {
            caseRecord.Tax_Identification_No__c = '000000000000';
            caseRecord.Application_for_Business_Service__c = true;
            caseRecord.Application_for_Business_Customer__c = true;
            caseRecord.Automatically_receive_SMS__c = smsCb;
            caseRecord.Automatically_receive_an_e_mail__c = emailCb;
            caseRecord.Preferred_Mode_of_Notification__c = (smsCb && emailCb?'SMS & Email': (smsCb?'SMS':(emailCb?'Email':'')));
            // Specify DML options to ensure the assignment rules are executed
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.useDefaultRule = true;
            caseRecord.setOptions(dmlOpts);

            List<Database.SaveResult> srList = Database.insert(new List<Case> {caseRecord}, false);

            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, CaseNumber FROM Case WHERE Id=:sr.getId()]);                
                    Pagereference pageRef = Page.CXE_ServiceAppBusinessThankYou;
                    pageref.getParameters().put('casenumber',caseMap.get(sr.getId()).CaseNumber);
                    return pageRef;
                }
                else {
                    String errors = '';             
                    List<String> errorList = new List<String>();
                    errorList.add(CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING1);
                    for(Database.Error err : sr.getErrors()) {
                        //errors += err.getStatusCode() + ': ' + err.getMessage();
                        errorList.add(err.getMessage());
                        //errors += CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING2 + err.getFields();
                    }
                    errors += String.join(errorList, '<br/>');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, errors));
                    return null;
                }
            }
            return null;
        } else {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, CXE_Constants.WEB_TO_CASE_CAPTCHA_ERROR);
            ApexPages.addMessage(errorMsg);
            return null;
        }
    }

    /* Description: Submit modify Residential SA
     * Parameters: none
     * Returns: PageReference
     * Author: Jerome To - CSM-3801
     */
    public PageReference submitModifyResidential() {
        Id modifyServiceAppRecTypeId = [SELECT Id FROM recordtype WHERE sObjectType='Case' AND Recordtype.Developername='CXE_Modification_of_Electric_Service'].Id;
        List<String> serviceRequestList = new List<String>();
        if(isVerified()) {
            caseRecord.RecordTypeId = modifyServiceAppRecTypeId;
            caseRecord.Application_for_Residential_Service__c = true;
            caseRecord.Application_for_Residential_Customer__c = true;

            if(modeOfNotificationSelect != null) {
                smsCb = (modeOfNotificationSelect == 'Both'  || modeOfNotificationSelect == 'SMS');
                emailCb = (modeOfNotificationSelect == 'Both' || modeOfNotificationSelect == 'Email');
            }

            caseRecord.Automatically_receive_SMS__c = smsCb;
            caseRecord.Automatically_receive_an_e_mail__c = emailCb;
            caseRecord.Preferred_Mode_of_Notification__c = (smsCb && emailCb?'SMS & Email': (smsCb?'SMS':(emailCb?'Email':'None')));
            
            if(amcSelect != null) {
                caseRecord.AMC_Service_Tag__c = (amcSelect=='Yes');                
            }

            if(serviceModificationSelect != null) {
                serviceRequestList.add(serviceModificationSelect);
            }

            if(contractModificationSelect != null) {
                serviceRequestList.add(contractModificationSelect);             
            }

            caseRecord.CXE_Service_Request_s__c = String.join(serviceRequestList, ';');

            // Specify DML options to ensure the assignment rules are executed
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.useDefaultRule = true;
            caseRecord.setOptions(dmlOpts);

            List<Database.SaveResult> srList = Database.insert(new List<Case> {caseRecord}, false);

            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    upload(); // upload file and attach to case
                    Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, CaseNumber FROM Case WHERE Id=:sr.getId()]);                
                    Pagereference pageRef = Page.CXE_ServiceAppResidentialThankYou;
                    pageref.getParameters().put('casenumber',caseMap.get(sr.getId()).CaseNumber);
                    return pageRef;
                }
                else {
                    String errors = '';             
                    List<String> errorList = new List<String>();
                    errorList.add(CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING1);
                    for(Database.Error err : sr.getErrors()) {
                        //errors += err.getStatusCode() + ': ' + err.getMessage();
                        errorList.add(err.getMessage());
                        //errors += CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING2 + err.getFields();
                    }
                    errors += String.join(errorList, '<br/>');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, errors));
                    return null;
                }
            }
            return null;
        } else {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, CXE_Constants.WEB_TO_CASE_CAPTCHA_ERROR);
            ApexPages.addMessage(errorMsg);
            return null;
        }
    }

    /* Description: gets metadata list of Contract Modification
     * Parameters: none
     * Returns: Set<String>
     * Author: Jerome To - CSM-3801
     */
    private Set<String> getContractModificationMDT() {
        Set<String> values = new Set<String>();
        for (Contract_Modification__mdt cm: [SELECT MasterLabel FROM Contract_Modification__mdt]) {
            values.add(cm.MasterLabel);
        }
        return values;        
    }

    /* Description: gets Service Modification
     * Parameters: none
     * Returns: List<SelectOption>
     * Author: Jerome To - CSM-3801
     */
    public List<SelectOption> getServiceModification() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Case.CXE_Service_Request_s__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            if(!contractModificationList.isEmpty()) {
                if(!contractModificationList.contains(f.getLabel())) {
                    options.add(new SelectOption(f.getLabel(),f.getValue()));
                }
            }            
        }
        return options;         
    }

    /* Description: gets Contract Modification
     * Parameters: none
     * Returns: List<SelectOption>
     * Author: Jerome To - CSM-3801
     */
    public List<SelectOption> getContractModification() {
        List<SelectOption> options = new List<SelectOption>();
        for (String strVal : contractModificationList) {
            options.add(new SelectOption(strVal,strVal));
        }
        return options;         
    }

    /* Description: gets Preferred mode of notification
     * Parameters: none
     * Returns: List<SelectOption>
     * Author: Jerome To - CSM-3801
     */
    public List<SelectOption> getPreferredModeOfNotification() {
        List<SelectOption> options = new List<SelectOption>();
        Set<String> preferredModeOfNotificationList = new Set<String> {'SMS', 'Email', 'Both'};
        for (String strVal : preferredModeOfNotificationList) {
            options.add(new SelectOption(strVal,strVal));
        }
        return options;         
    }

}