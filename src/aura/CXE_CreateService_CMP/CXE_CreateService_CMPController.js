({
    /* Description: Get contract values and add validation
     * Parameters: None
     * Author: Rom Edison Reyes
     * Date Created: MAR-18-17
     */
    validateContract : function(component, event, helper) {    
        console.log("Get Contract");
        component.get("v.recordId");
        var action = component.get("c.getContract");
            //Set parameters
            action.setParams({"contractId":  component.get("v.recordId")});
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                var contractRec = response.getReturnValue();
                console.log('STATE: '+ response.getState());
                console.log('contractRec: ' + JSON.stringify(contractRec));
                if(state == 'SUCCESS'){
                    //START CSM-12111 RReyes JUL-30-17 - add validation on case status, record type
                    var errMsg = helper.validateCase(contractRec);
                    console.log('errMsg: ' + errMsg);
                    if(errMsg != '' && errMsg != null){
                        //Display validation toast
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": "Oops!",
                                              "message": errMsg,
                                              "type": "info"
                        });
                        toastEvent.fire();
                    }else{
                        console.log('returnvalue: success');
                        component.set("v.accountId", contractRec.AccountId);
                        component.set("v.contractRecord", contractRec);
                        
                        //BEGIN Michael Lasala MAR-28-17 CSM-2012
                        //Validate if Contract has a related Case
                        if(contractRec.hasOwnProperty('Case__c')){
                            //BEGIN Michael Lasala MAR-22-17 (CSM-1880)
                            if(contractRec.Case__r.Multimetering__c == true){
                                
                                //Display account lookup input
                                component.set("v.isAccountInput", false);
                            
                            } else {

                                //Display account disabled input
                                component.set("v.isAccountInput", true);
                            }
                            console.log('*: '+component.get("v.isAccountInput"));
                            //END Michael Lasala MAR-22-17 (CSM-1880)
                            helper.validateRequiredCaseFields(component, event, helper, contractRec); //BEGIN/END RREYES MAR-23-17 (CSM-1926)
                        } else {
                            //Display info toast
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({"title": "Oops!",
                                                  "message": "No Case related to Contract.",
                                                  "type": "info"
                            });
                            toastEvent.fire();
                        }
                        //END Michael Lasala MAR-28-17
                    }
                    //END CSM-12111 RReyes JUL-30-17 - add validation on case status, record type
                }
            });
            $A.enqueueAction(action);
    },
    
    /* Description: Close Service modal
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-08-17
     */
    closeServiceModal : function(component, event, helper) {
        //Hide Account lookup
        // document.getElementById("accountInputSection").style.display = 'none';

        //Hide Account outputText
        // document.getElementById("accountOutputSection").style.display = 'none';

        component.set("v.psicError", null);
        helper.clearError(component, helper, "Rate__c");
        helper.clearError(component, helper, "billingClass");
        helper.clearError(component, helper, "Segment__c");
        helper.clearError(component, helper, "serviceWireTLN");
        helper.clearError(component, helper, "Service_Wire_Phase__c");
        helper.clearError(component, helper, "serviceWirePoleNumber");
        helper.clearError(component, helper, "Service_Wire_Type__c");
        helper.clearError(component, helper, "Service_Supply_Voltage__c");
        helper.clearError(component, helper, "serviceWireLength");
        helper.clearError(component, helper, "Service_Supply_Type__c");
        helper.clearError(component, helper, "Service_Wire_Size__c");
        helper.clearError(component, helper, "Service_Wire_Material__c");
        helper.clearError(component, helper, "appliedLoad");
        helper.clearError(component, helper, "Phase__c");
        helper.clearError(component, helper, "serviceWireMaxCap");
        helper.clearError(component, helper, "demandFactor");
        helper.clearError(component, helper, "loadFactor");
        helper.clearError(component, helper, "contractedCapacity");
        // Start CSM-12178 Von Pernicia JUL-03-17
        //helper.clearError(component, helper, "CXE_Discount_Program__c"); // CSM-6395 JEROME TO   MAY-30-17
        // End CSM-12178 Von Pernicia JUL-03-17

        helper.closeModalHelper(component, 'serviceDiv');
        helper.closeModalHelper(component, 'backGroundSectionId');
    }, 

    /* Description: Filter Billing Class picklist values based on Rate value
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-09-17
     */
    filterBillingClass : function(component, event, helper) {
        helper.filterBillingClassHelper(component, event, helper);
    }, 

    /* Description: Save Service record
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-08-17
     */
    insertService : function(component, event, helper) {
        
        //Disable save button
        helper.toggleElement(component, helper, 'insertService', true);

        //Validate required fields
        if(helper.validateService(component, helper)){
            component.set("v.service.Case__c", component.get("v.caseId"));
            component.set("v.service.Contract__c", component.get("v.recordId"));

            //Check Account value for single/multimeter
            if(!$A.util.isEmpty(component.get("v.accountId"))){
                component.set("v.service.Account__c", component.get("v.accountId"));
                console.log('prepop: '+component.get("v.service.Account__c"));
            } else {
                console.log('manual: '+component.get("v.service.Account__c"));
            }

            var serviceRecord = component.get("v.service");

            component.set("v.service.Account__c", component.get("v.accountId"));
            //component.set("v.contract.Case__c", component.get("v.recordId"));
    		component.set("v.service.Account__r", null);
            component.set("v.service.Connection__r", null);
            component.set("v.service.PSIC__r", null);
            component.set("v.service.RES__r", null);
            
            //Delete attributes to avoid invalid sobject error
            delete serviceRecord.Account__r;
            delete serviceRecord.Connection__r;
            delete serviceRecord.PSIC__r;
            delete serviceRecord.RES__r;

            console.log('serviceRecord: '+JSON.stringify(serviceRecord));

            var action = component.get("c.saveService");

            //Set parameters
            action.setParams({"service": component.get("v.service")});

            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state == "SUCCESS"){
                    console.log('saveService: '+JSON.stringify(response.getReturnValue()));

                    if(response.getReturnValue() == 'Success'){
                        //Display toast on successful create of Service
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": "Success!",
                                              "message": "Service has been created.",
                                              "type": "success"
                        });
                    } else {
                        //Display toast if error occurred
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": "Error!",
                                              "message": response.getReturnValue(),
                                              "type": "error"
                        });
                    }
                } else {
                    var errors = response.getError();
                    if(errors){
                        if(errors[0] && 
                           errors[0].message){
                            
                            console.log('saveService error: '+state+' '+errors[0].message);
                        }
                    } else {
                        console.log('saveService unknown error');
                    }

                    //Display toast if error occurred
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Error!",
                                          "message": "Error creating Service.",
                                          "type": "error"
                    });             
                }
                toastEvent.fire();
            });
            $A.enqueueAction(action);

            helper.closeModalHelper(component, 'serviceDiv');
            helper.closeModalHelper(component, 'backGroundSectionId');

            //Refresh detail page to reflect Address on related list
            $A.get('e.force:refreshView').fire();

            //Enable save button
            helper.toggleElement(component, helper, 'insertService', false);

        } else {
            //Display toast if error occurred
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({"title": "Error!",
                                  "message": 'Review the errors on this page.',
                                  "type": "error"
            });
            toastEvent.fire();

            //Enable save button
            helper.toggleElement(component, helper, 'insertService', false);
        }
    },
    
    /* Description: On Change Service Supply Voltage
     * Parameters: None
     * Author: Von Pernicia
     * Date Created: MAR-16-17
     */
    onSelectChange: function(component, event, helper) {
        
        helper.setVoltage(component, event, helper);
        
    }
})