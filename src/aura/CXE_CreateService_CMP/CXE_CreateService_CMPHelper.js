({
    /* Description: CSM-12111 Validate if a service can be created based on the case status, record type and multimetering
     * Parameters: caseRecord
     * Author: Rom Edison Reyes
     * Date Created: JUL-30-17
     */
    validateCase : function(contractRec) {    
        var errorMessage = '';
        
        if(contractRec.Case__r.RecordType.DeveloperName == 'New_Service_Application'){
            if(contractRec.Case__r.Multimetering__c){
                if(contractRec.Case__r.Status != 'Inspection FO Resolved - Approved' 
                && contractRec.Case__r.Status != 'AMC Service Availed' 
                && contractRec.Case__r.Status != 'AMC Service Completed' 
                && contractRec.Case__r.Status != 'Contract Finalized'
                && contractRec.Case__r.Status != 'Application Ready for Connection' 
                && contractRec.Case__r.Status != 'Pending Energization'){
                        errorMessage = "You are not allowed to create a service with this case's status.";
                }
            }else{
                 if(contractRec.Case__r.Status != 'Inspection FO Resolved - Approved' 
                    && contractRec.Case__r.Status != 'AMC Service Availed' 
                    && contractRec.Case__r.Status != 'AMC Service Completed'){
                        errorMessage = "You are not allowed to create a service with this case's status.";
                }
            }
        }else if(contractRec.Case__r.RecordType.DeveloperName == 'CXE_Recontract_of_Electric_Service'){
            if(contractRec.Case__r.Status != 'Inspection FO Resolved - Approved' && contractRec.Case__r.Status != 'AMC Service Availed' 
                && contractRec.Case__r.Status != 'AMC Service Completed' && contractRec.Case__r.Status != 'Service Entrance Still OK' ){
                errorMessage = "You are not allowed to create a service with this case's status.";
            }
        }else{
            errorMessage = "You are not allowed to create a service with this case's record type.";
        }
        return errorMessage;
    },

    /* Description: Validate if a service can be created for the contract
     * Parameters: None
     * Author: Rom Edison Reyes
     * Date Created: MAR-22-17
     */
    validateServices : function(component, event, helper, contractRec) {    
        console.log("Validate if a service can be created on the contract");
        var action = component.get("c.isValidToCreateService");
            //Set parameters
            action.setParams({"contractId": component.get("v.recordId"),
                          "caseStatus" : contractRec.Case__r.Status,
                          "isMultiMeter": contractRec.Case__r.Multimetering__c,
                          "v10AccNum": contractRec.V10_Account_No__c});
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                var errMsg = response.getReturnValue();

                console.log('errMsg: ' + errMsg);
                if(state == 'SUCCESS'){
                        console.log('returnvalue: success');
                        if(errMsg == ''){
                            //helper.validateRequiredCaseFields(component, event, helper);
                            helper.displayServiceModal(component, event, helper);
                        }else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({"title": "Error!",
                                                  "message": errMsg,
                                                  "type": "info"
                            });
                            toastEvent.fire();
                        }
                    }
            });
            $A.enqueueAction(action);
    },
    
    /* Description: Validate if contract's related case has required values filled in.
     * Parameters: None
     * Author: Rom Edison Reyes
     * Date Created: MAR-18-17
     */
    validateRequiredCaseFields : function(component, event, helper, contractRec) {    
        console.log("Validate if all required fields on contract's case has value.");
        var action = component.get("c.validateRequiredCaseValues");
            //Set parameters
            action.setParams({"contractRec":  component.get("v.contractRecord")});
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                var errMsg = response.getReturnValue();

                console.log('errMsg: ' + errMsg);
                if(state == 'SUCCESS'){
                        console.log('returnvalue: success');
                        if(errMsg == ''){
                             helper.validateContractBillingAdd(component, event, helper, contractRec);
                        }else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({"title": "Error!",
                                                  "message": errMsg,
                                                  "type": "error",
                                                  "mode":"sticky"
                            });
                            toastEvent.fire();
                        }
                    }
            });
            $A.enqueueAction(action);
    },
    
    /* Description: Validate if contract has billing address
     * Parameters: None
     * Author: Rom Edison Reyes
     * Date Created: MAR-16-17
     */
    validateContractBillingAdd : function(component, event, helper, contractRec) {    
        console.log("Validate Billing Addresses of Contract");
        var action = component.get("c.validateIfContractHasBillingAddress");
            //Set parameters
            action.setParams({"contractId":  component.get("v.recordId")});
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                var isValid = response.getReturnValue();

                console.log('isValid: ' + isValid);
                if(state == 'SUCCESS'){
                        console.log('returnvalue: success');
                        if(isValid){
                            //START CSM-12318 RReyes AUG-23-17 - changed from validateAccountServiceAdd to validateCaseServiceAdd
                             helper.validateCaseServiceAdd(component, event, helper, contractRec);
                            //END CSM-12318 RReyes AUG-23-17 - changed from validateAccountServiceAdd to validateCaseServiceAdd
                        }else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({"title": "Error!",
                                                  "message": "A billing address is required on the contract before creating a service.",
                                                  "type": "error"
                            });
                            toastEvent.fire();
                        }
                    }
            });
            $A.enqueueAction(action);
    },
     /* Description: Validate if related account of contract has service address
     * Parameters: None
     * Author: Rom Edison Reyes
     * Date Created: MAR-16-17
     */
    validateAccountServiceAdd : function(component, event, helper, contractRec) {    
        console.log("Validate Service Addresses of Contract.Account");
        var action = component.get("c.validateIfAccountHasServiceAddress");
            //Set parameters
            action.setParams({"acctId":  component.get("v.accountId")});
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                var isValid = response.getReturnValue();

                console.log('isValid: ' + isValid);
                if(state == 'SUCCESS'){
                        console.log('returnvalue: success');
                        if(isValid){
                            //helper.displayServiceModal(component, event, helper);
                            helper.validateServices(component, event, helper, contractRec);
                        }else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({"title": "Error!",
                                                  "message": "A service address is required on the contract's account before creating a service.",
                                                  "type": "error"
                            });
                            toastEvent.fire();
                        }
                    }
            });
            $A.enqueueAction(action);
    },

    //START CSM-12318 RReyes AUG-23-17 - check if case has a related service address
    /* Description: Validate if related case of contract has service address
     * Parameters: None
     * Author: Rom Edison Reyes
     * Date Created: AUG-23-17
     */
    validateCaseServiceAdd : function(component, event, helper, contractRec) {    
        console.log("Validate Service Addresses of Contract.Case");
        var action = component.get("c.validateIfCaseHasServiceAddress");
            //Set parameters
            action.setParams({"caseId":  contractRec.Case__c });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                var isValid = response.getReturnValue();

                console.log('isValid: ' + isValid);
                if(state == 'SUCCESS'){
                        console.log('returnvalue: success');
                        if(isValid){
                            helper.validateServices(component, event, helper, contractRec);
                        }else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({"title": "Error!",
                                                  "message": "A service address is required on the contract's case before creating a service.",
                                                  "type": "error"
                            });
                            toastEvent.fire();
                        }
                    }
            });
            $A.enqueueAction(action);
    },
    //END CSM-12318 RReyes AUG-23-17 - check if case has a related service address

    /* Description: Display Service modal
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-08-17
     */
     displayServiceModal : function(component, event, helper) {
        //Clear field values
        component.set("v.service.SIN__c", null);
        component.set("v.service.Connection__c", null);
        component.set("v.service.Active_Agreement__c", true);
        component.set("v.service.Service_Status__c", null);
        component.set("v.service.PSIC__c", null);
        component.set("v.service.Account__c", null);
        component.set("v.service.Agreement_Start_Date__c", null);
        component.set("v.service.V10_Account_No__c", null);
        component.set("v.service.Agreement_End_Date__c", null);
        component.set("v.service.V10_Payor_Account__c", null);
        component.set("v.service.Rate__c", null);
        component.set("v.service.V10_Business_Unit__c", null);
        component.set("v.service.Billing_Class__c", null);
        component.set("v.service.Service_Description__c", null);
        component.set("v.service.Segment__c", null);
        component.set("v.service.RES__c", null);
        component.set("v.service.ILP__c", false);
        component.set("v.service.Deposit_Amount__c", null);
        component.set("v.service.Premises_Type__c", null);
        component.set("v.service.Premises__c", null);
        component.set("v.service.Premise_Direction__c", null);
        component.set("v.service.Service_Supply__c", "");
        component.set("v.service.Service_Wire_Maximum_Capacity__c", null);
        component.set("v.service.Service_Supply_Phase__c", null);
        component.set("v.service.Service_Wire_TLN__c", null);
        component.set("v.service.Service_Wire_Phase__c", null);
        component.set("v.service.Service_Wire_Pole_Number__c", null);
        component.set("v.service.Service_Wire_Voltage__c", null);
        component.set("v.service.Service_Wire_Type__c", null);
        component.set("v.service.Service_Supply_Voltage__c", null);
        component.set("v.service.Service_Wire_Length__c", null);
        component.set("v.service.Service_Supply_Type__c", null);
        component.set("v.service.Service_Wire_Size__c", null);
        component.set("v.service.Service_Wire_Material__c", null);
        component.set("v.service.Applied_Load__c", null);
        component.set("v.service.Phase__c", null);
        component.set("v.service.Demand_Factor__c", null);
        component.set("v.service.GMBD_kW__c", null);
        component.set("v.service.Load_Factor__c", null);
        //component.set("v.service.Program__c", null); // Start/End CSM-12178 Von Pernicia JUL-03-17
        component.set("v.service.Contracted_Capacity__c", null);
        component.set("v.service.Voltage_Level__c", null);
        component.set("v.service.Integ_V10_Create_Status__c", null);
        component.set("v.service.Integ_V10_Create_Status_Datetime__c", null);
        component.set("v.service.Integ_V10_Create_Status_Description__c", null);
        // Start CSM-12178 Von Pernicia JUL-03-17
        //component.set("v.service.CXE_Discount_Program__c", null); // CSM-6359 Jerome To 05/30/17
        //End CSM-12178 Von Pernicia JUL-03-17

        //Clear lookup values
        component.find("connection").get("v.body")[0].set("v.values", "");

        //Validate whether account disabled or lookup is displayed (CSM-1880)
        if(component.get("v.isAccountInput") == false){
          component.find("accountInput").get("v.body")[0].set("v.values", "");
        }
        component.find("psic").get("v.body")[0].set("v.values", "");
        component.find("res").get("v.body")[0].set("v.values", "");
        
        //Get picklist values
        helper.setPicklistValues(component, event, helper);

        helper.openModalHelper(component, 'serviceDiv');
        helper.openModalHelper(component, 'backGroundSectionId');
    },

    
    /* Description: Show Modal
     * Parameters: Element Id
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
    openModalHelper : function(component, elementId) {
        //Show modal
        var modal = component.find(elementId); 
        $A.util.addClass(modal, 'slds-backdrop--open');
        $A.util.removeClass(modal, 'slds-fade-in-hide');
    },

    /* Description: Hide Modal
     * Parameters: Element Id
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
    closeModalHelper : function(component, elementId) {
        //Hide modal
        var modal = component.find(elementId); 
        $A.util.addClass(modal, 'slds-fade-in-hide'); 
        $A.util.removeClass(modal, 'slds-backdrop--open'); 
    },

    /* Description: Get Contract and Case details
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-08-17
     */
    setContractandCase : function(component, event, helper) {
        var action = component.get("c.getContract");

        action.setParams({"contractId": component.get("v.recordId")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var contract = response.getReturnValue();
                console.log('setCase: '+JSON.stringify(contract));

                //Set case id
                component.set("v.caseId", contract.Case__c);
                console.log('caseId: '+component.get("v.caseId"));
                
                //Set case number and contract number
                component.find("case").set("v.value", contract.Case__r.CaseNumber);
                component.find("contract").set("v.value", contract.ContractNumber);

                //Pre-populate values from case
                component.set("v.service.PSIC__c", contract.Case__r.PSIC__c);

                //Populate PSIC lookup if not null
                if(!$A.util.isEmpty(contract.Case__r.PSIC__c) &&
                   !$A.util.isUndefinedOrNull(contract.Case__r.PSIC__c) &&
                   contract.Case__r.PSIC__c != '' &&
                   contract.Case__r.PSIC__c != null){

                    helper.setPSIC(component, event, helper);
                }
                
                // Start CSM-1294: Von Pernicia 3/15/17
                //Pre-populate values from Contract
                component.set("v.service.Account__c", contract.AccountId);
                
                //Populate Account lookup if not null
                if(!$A.util.isEmpty(contract.AccountId) &&
                   !$A.util.isUndefinedOrNull(contract.AccountId) &&
                   contract.AccountId != '' &&
                   contract.AccountId != null){

                    helper.setAccount(component, event, helper);
                }
                // End CSM-1294: Von Pernicia 3/15/17
                
                component.set("v.service.Rate__c", contract.Case__r.Service_Rate_Type__c);

                //Set dependent picklist based on billing class
                helper.filterBillingClassHelper(component, event, helper);

                component.set("v.service.Billing_Class__c", contract.Case__r.Billing_Class__c);
                component.set("v.service.Service_Wire_Pole_Number__c", contract.Case__r.Pole_Code__c);
                component.set("v.service.Service_Wire_Type__c", contract.Case__r.Service_Wire_Type__c);
                component.set("v.service.Service_Wire_Length__c", contract.Case__r.Service_Wire_Length__c);
                component.set("v.service.Service_Supply_Type__c", contract.Case__r.Service_Supply_Type__c);
                component.set("v.service.Service_Wire_Size__c", contract.Case__r.Wire_Size__c);
                component.set("v.service.Service_Wire_Material__c", contract.Case__r.Material__c);
                component.set("v.service.Applied_Load__c", contract.Case__r.Applied_Load__c);
                component.set("v.service.Phase__c", contract.Case__r.Phase__c);
                component.set("v.service.Demand_Factor__c", contract.Case__r.Demand_Factor__c);
                component.set("v.service.Load_Factor__c", contract.Case__r.Load_Factor__c);
                component.set("v.service.Contracted_Capacity__c", contract.Case__r.Contracted_Capacity__c);
                
                //Start CSM-1911: Von Pernicia 3/16/17
                component.set("v.service.Service_Wire_TLN__c", contract.Case__r.TLN__c);
                component.set("v.service.Segment__c", contract.Case__r.Business_Segment__c);
                //End CSM-1911: Von Pernicia 3/16/17
                
                //Start CSM-1906: Von Pernicia 3/16/17
                component.set("v.service.Service_Supply_Voltage__c", contract.Case__r.Voltage__c);
                //component.set("v.service.Voltage_Level__c", contract.Case__r.Voltage__c);
                helper.setVoltage(component, event, helper);
                //End CSM-1906: Von Pernicia 3/16/17
                
                //Start CSM-1468: Von Pernicia 3/16/17
                component.set("v.service.Deposit_Amount__c", contract.Case__r.Deposit_Amount__c);
                //End CSM-1468: Von Pernicia 3/16/17
                
                // Start CSM-12178 Von Pernicia JUL-03-17
                //Start CSM-6359: Jerome To 05/30/17
                //component.set("v.service.CXE_Discount_Program__c", contract.Case__r.CXE_Discount_Programs__c);
                //Start CSM-6359: Jerome To 05/30/17
                // End CSM-12178 Von Pernicia JUL-03-17

                //Show/hide input and output Account field based on Case.Multimetering
                if(contract.Case__r.Multimetering__c == true){

                    //Display Account lookup
                    // document.getElementById("accountInputSection").style.display = 'block';
                } else {

                    //Display Account outputText
                    // document.getElementById("accountOutputSection").style.display = 'block';

                    //Assign Account id to attribute
                    component.set("v.accountId", contract.AccountId);

                    //Set Account name text
                    component.find("accountOutput").set("v.value", contract.Account.Name);
                }
                //START CSM-7145/CSM-7170 RReyes JUN-28-17
                component.set("v.service.Service_Supply_Phase__c", contract.Case__r.Phase__c);
                component.set("v.service.Service_Wire_Phase__c", contract.Case__r.CXE_Service_Wire_Phase__c);
                component.set("v.service.Service_Wire_Voltage__c", contract.Case__r.CXE_Service_Wire_Voltage__c);
                //END CSM-7145/CSM-7170 RReyes JUN-28-17
            } else {
                console.log('setCase error: '+state);
                console.log('setCase '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }, 

    /* Description: Get PSIC lookup
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
    setPSIC : function(component, event, helper) {
        var action = component.get("c.getPSIC");

        action.setParams({"psicId": component.get("v.service.PSIC__c")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('setPSIC: '+component.get("v.service.PSIC__c")+', '+JSON.stringify(response.getReturnValue()));

                var values = [{
                    type: 'Custom',
                    id: response.getReturnValue().Id,
                    label: response.getReturnValue().Name,
                    icon : {
                        url:'/img/icon/t4v35/standard/custom8_120.png',
                        backgroundColor:'50ceb9',
                        alt:'PSIC'
                    }
                }];

                component.find("psic").get("v.body")[0].set("v.values", values); 
            } else {
                console.log('setPSIC error: '+state);
                console.log('setPSIC '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
     /* Description: Get Account lookup
     * Parameters: None
     * Author: Von Pernicia
     * Date Created: MAR-15-17
     */
    // Start CSM-1294: Von Pernicia 3/15/17
    setAccount : function(component, event, helper) {
        var action = component.get("c.getAccount");

        action.setParams({"accountId": component.get("v.service.Account__c")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('setAccount: '+component.get("v.service.Account__c")+', '+JSON.stringify(response.getReturnValue()));

                var values = [{
                    type: 'Custom',
                    id: response.getReturnValue().Id,
                    label: response.getReturnValue().Name,
                    icon : { 
                        url:'/img/icon/t4v35/standard/account_120.png',
                        backgroundColor:'50ceb9',
                        alt:'accountInput'
                    }
                }];

                //Validate whether account disabled or lookup is displayed (CSM-1880)
                if(component.get("v.isAccountInput") == false){
                    component.find("accountInput").get("v.body")[0].set("v.values", values); 
                }
            } else {
                console.log('setAccount error: '+state);
                console.log('setAccount '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    /* Description: Get Voltage Code Value
     * Parameters: None
     * Author: Von Pernicia
     * Date Created: MAR-16-17
     */
    // Start CSM-1906: Von Pernicia 3/16/17
    setVoltage : function(component, event, helper) {
        var action = component.get("c.getVoltage");

        action.setParams({"serviceSupplyVoltage": component.get("v.service.Service_Supply_Voltage__c")});
        
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if(state == "SUCCESS"){
                var reference = response.getReturnValue();
                //console.log('setReference: '+JSON.stringify(reference));
                component.set("v.service.Voltage_Level__c", reference.Name);
                component.set("v.service.Code_Voltage_Level__c", reference.Name_Code__c);
            } else {
                console.log('setCase error: '+state);
                console.log('setCase '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    // End CSM-1906: Von Pernicia 3/16/17
    
    /* Description: Set picklist values for default fields
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-08-17
     */
    setPicklistValues : function(component, event, helper) {
        var action = component.get("c.getServicePicklistValues");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('setPicklistValues: '+JSON.stringify(response.getReturnValue()));
                var picklistValues = response.getReturnValue();

                //Iterate over each field
                for(var key in picklistValues){
                    
                    //Flush array for each field                    
                    var opts=[];

                    if(picklistValues.hasOwnProperty(key)){
                        // console.log('key: '+key);

                        //Iterate over picklist values for each field
                        for(var i=0; i<picklistValues[key].length; i++){
                            // console.log('i: '+picklistValues[key][i]);
                            
                            //Push values as select options
                            opts.push({"class": "optionClass", label: picklistValues[key][i], value: picklistValues[key][i]});
                        }

                        //Push values to component
                        component.find(key).set("v.options", opts);

                        //BEGIN MICHAEL LASALA MAR-27-17 CSM-2006
                        if(key == 'Service_Status__c'){
                            component.find("Service_Status__c").set("v.value", "Pending");
                        }
                        //END MICHAEL LASALA MAR-27-17
                    }
                }
            } else {
                console.log('setPicklistValues error: '+state);
                console.log('setPicklistValues '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);

        ///Get Contract and Case details
        helper.setContractandCase(component, event, helper);
    }, 

    /* Description: Filter Billing Class picklist values based on Rate value
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-09-17
     */
    filterBillingClassHelper : function(component, event, helper) {
        var rateValue = component.get("v.service.Rate__c");
        console.log('rate: '+rateValue);

        var opts=[];

        //Enable field
        helper.toggleElement(component, helper, 'billingClass', false);

        //Set default value
        opts.push({"class": "optionClass", label: '--None--', value: '--None--'});

        //Replicate dependent picklist values
        if(rateValue == 'General Service A (GSA)'){
            opts.push({"class": "optionClass", label: 'General Service A (GSA)', value: 'General Service A (GSA)'});
        } else if(rateValue == 'General Service B (GSB)'){
            opts.push({"class": "optionClass", label: 'GS-B Industrial Service (IS)', value: 'GS-B Industrial Service (IS)'});
            opts.push({"class": "optionClass", label: 'GS-B Non-industrial Service (NIS)', value: 'GS-B Non-industrial Service (NIS)'});
        } else if(rateValue == 'General Power (GP)'){
            opts.push({"class": "optionClass", label: 'Non-Industrial Service(NIS)', value: 'Non-Industrial Service(NIS)'});
            opts.push({"class": "optionClass", label: 'Industrial Service (IS)', value: 'Industrial Service (IS)'});
        } else if(rateValue == 'Residential Service (RS)'){
            opts.push({"class": "optionClass", label: 'Residential Service(RS)', value: 'Residential Service(RS)'});
        } else if(rateValue == 'Government Hospitals, Metered Streetlights & Charitable Institutions (GHMSCI)'){
            opts.push({"class": "optionClass", label: 'Government Hospitals, Metered Streetlights & Charitable Institutions (GHMSCI)', value: 'Government Hospitals, Metered Streetlights & Charitable Institutions (GHMSCI)'});
        } else {

            //Disable field if dependent picklist is null
            helper.toggleElement(component, helper, 'billingClass', true);

        }

        //Set picklist values
        component.find("billingClass").set("v.options", opts);
    }, 

    /* Description: Validate service fields
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-09-17
     */
    validateService : function(component, helper){
        var isValid = false;

        var isAccountValid;

        if($A.util.isEmpty(component.get("v.accountId"))){

            var accountValue = component.get("v.service.Account__c");

            //Validate Account lookup for multimeter
            if($A.util.isEmpty(accountValue) || 
               $A.util.isUndefinedOrNull(accountValue) || 
               accountValue == '' || 
               accountValue == null || 
               accountValue == 'MALFORMED_ID'){

                component.set("v.accountError", "You must select an Account");
                isAccountValid = false;
            } else {
                component.set("v.accountError", null);
                isAccountValid = true;
            }
        } else {
            isAccountValid = true;
        }

        var psicValue = component.get("v.service.PSIC__c");
        var isPSICValid;
        
        //Valdiate PSIC lookup
        if($A.util.isEmpty(psicValue) || 
           $A.util.isUndefinedOrNull(psicValue) || 
           psicValue == '' || 
           psicValue == null || 
           psicValue == 'MALFORMED_ID'){

            component.set("v.psicError", "You must select a PSIC");
            isPSICValid = false;
        } else {
            component.set("v.psicError", null);
            isPSICValid = true;
        }
        
        //Validate required fields
        var isRateValid = helper.validateField(component, helper, component.get("v.service.Rate__c"), 'Rate__c', 'a Rate');
        var isBillingClassValid = helper.validateField(component, helper, component.get("v.service.Billing_Class__c"), 'billingClass', 'a Billing Class');
        var isSegmentValid = helper.validateField(component, helper, component.get("v.service.Segment__c"), 'Segment__c', 'a Segment');
        var isWireTLNValid = helper.validateField(component, helper, component.get("v.service.Service_Wire_TLN__c"), 'serviceWireTLN', 'a Service Wire TLN');
        
        if(isWireTLNValid){
            //isWireTLNValid = helper.validateNumber(component, helper, component.get("v.service.Service_Wire_TLN__c"), 'serviceWireTLN', 1);
        }
        
        var isWirePhaseValid = helper.validateField(component, helper, component.get("v.service.Service_Wire_Phase__c"), 'Service_Wire_Phase__c', 'a Service Wire Phase');
        var isWirePoleValid = helper.validateField(component, helper, component.get("v.service.Service_Wire_Pole_Number__c"), 'serviceWirePoleNumber', 'a Service Wire Pole Number');
        var isWireTypeValid = helper.validateField(component, helper, component.get("v.service.Service_Wire_Type__c"), 'Service_Wire_Type__c', 'a Service Wire Type');
        var isSupplyVoltageValid = helper.validateField(component, helper, component.get("v.service.Service_Supply_Voltage__c"), 'Service_Supply_Voltage__c', 'a Service Supply Voltage');
        var isWireLengthValid = helper.validateField(component, helper, component.get("v.service.Service_Wire_Length__c"), 'serviceWireLength', 'a Service Wire Length');
        
        if(isWireLengthValid){
            isWireLengthValid = helper.validateNumber(component, helper, component.get("v.service.Service_Wire_Length__c"), 'serviceWireLength', 2);
        }
        
        var isSupplyTypeValid = helper.validateField(component, helper, component.get("v.service.Service_Supply_Type__c"), 'Service_Supply_Type__c', 'a Service Supply Type');
        var isWireSizeValid = helper.validateField(component, helper, component.get("v.service.Service_Wire_Size__c"), 'Service_Wire_Size__c', 'a Service Wire Size');
        var isWireMaterialValid = helper.validateField(component, helper, component.get("v.service.Service_Wire_Material__c"), 'Service_Wire_Material__c', 'a Service Wire Material');
        var isAppliedLoadValid = helper.validateField(component, helper, component.get("v.service.Applied_Load__c"), 'appliedLoad', 'an Applied Load');
        
        if(isAppliedLoadValid){
            isAppliedLoadValid = helper.validateNumber(component, helper, component.get("v.service.Applied_Load__c"), 'appliedLoad', 15);
        }
        
        //Michael Lasala MAR-12-17 Added for CSM-1820
        var isPhaseValid = helper.validateField(component, helper, component.get("v.service.Phase__c"), 'Phase__c', 'a Phase');
        
        // var isVoltageValid = helper.validateField(component, helper, component.get("v.service.Voltage_Level__c"), 'Voltage_Level__c', 'a Voltage Level');

        //Validate number fields
        var isWireMaxCapValid = helper.validateNumber(component, helper, component.get("v.service.Service_Wire_Maximum_Capacity__c"), 'serviceWireMaxCap', 15);
        var isDemandFactorValid = helper.validateNumber(component, helper, component.get("v.service.Demand_Factor__c"), 'demandFactor', 10);
        // var isGMBDValid = helper.validateNumber(component, helper, component.get("v.service.GMBD_kW__c"), 'gmbd', 15);
        var isLoadFactorValid = helper.validateNumber(component, helper, component.get("v.service.Load_Factor__c"), 'loadFactor', 1);
        var isContractedCapacityValid = helper.validateNumber(component, helper, component.get("v.service.Contracted_Capacity__c"), 'contractedCapacity', 15);
        

        if(isAccountValid && 
           isPSICValid && 
           isRateValid && 
           isBillingClassValid && 
           isSegmentValid && 
           isWireTLNValid && 
           isWirePhaseValid &&
           isWirePoleValid && 
           isWireTypeValid && 
           isSupplyVoltageValid && 
           isWireLengthValid && 
           isSupplyTypeValid && 
           isWireSizeValid && 
           isWireMaterialValid && 
           isAppliedLoadValid && 
           isPhaseValid &&  //Michael Lasala MAR-12-17 Added for CSM-1820
           // isVoltageValid && 
           isWireMaxCapValid && 
           isDemandFactorValid && 
           // isGMBDValid && 
           isLoadFactorValid && 
           isContractedCapacityValid){

            isValid = true;

        } else {

            //Enable save button
            helper.toggleElement(component, helper, 'insertService', false);
        }
        console.log('validateFields isValid: '+isValid);
        return isValid;
    }, 

    /* Description: Validate each field
     * Parameters: Field value, Field id, Error message
     * Author: Michael Lasala
     * Date Created: MAR-08-17
     */
    validateField : function(component, helper, fieldValue, elementId, errorMessage){
        console.log('validateField : '+fieldValue);
        if(($A.util.isEmpty(fieldValue) && 
            $A.util.isUndefinedOrNull(fieldValue)) || 
           fieldValue == '--None--' || 
           fieldValue == ''){

            //Set error
            component.find(elementId).set("v.errors", [{message: "You must enter "+errorMessage+"."}]);
            return false;

        } else {

            //Clear error
            component.find(elementId).set("v.errors", null);
            return true;
        }
    }, 

    /* Description: Validate number fields
     * Parameters: Field value, Field id, Error message
     * Author: Michael Lasala
     * Date Created: MAR-09-17
     */
    validateNumber : function(component, helper, fieldValue, elementId, maxLength){
        console.log('validateNumber : '+fieldValue);
        if(!$A.util.isEmpty(fieldValue) && 
           !$A.util.isUndefinedOrNull(fieldValue) && 
           parseInt(fieldValue).toString().length > maxLength){

            //Set error
            component.find(elementId).set("v.errors", [{message: "You must enter less than "+(maxLength+1)+" characters."}]);
            return false;

        } else {

            //Clear error
            component.find(elementId).set("v.errors", null);
            return true;
        }
    }, 

    /* Description: Extract error message
     * Parameters: Error
     * Author: Michael Lasala
     * Date Created: MAR-08-17
     */
    extractError : function(error) {
        var errorMessage = error;
        if(error){
            if(error[0] && 
               error[0].message){
                
                console.log('error: '+error[0].message);
            }
        } else {
            console.log('unknown error');
        }
    }, 

    /* Description: Enable/disable an element
     * Parameters: Element Id, Boolean
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
    toggleElement : function(component, helper, elementId, state) {
        component.find(elementId).set("v.disabled", state);
    }, 

    /* Description: Clear error messages
     * Parameters: Element Id
     * Author: Michael Lasala
     * Date Created: APR-08-17
     */
    clearError : function(component, helper, elementId) {
        component.find(elementId).set("v.errors", null);
    }
})