({
	/* Description: Show Modal
     * Parameters: Element Id
     * Author: Michael Lasala
     * Date Created: MAR-14-17
     */
    openModalHelper : function(component, elementId) {
        var modal = component.find(elementId); 
        $A.util.addClass(modal, 'slds-backdrop--open');
        $A.util.removeClass(modal, 'slds-fade-in-hide');
    },

    /* Description: Hide Modal
     * Parameters: Element Id
     * Author: Michael Lasala
     * Date Created: MAR-14-17
     */
    closeModalHelper : function(component, elementId) {
        var modal = component.find(elementId); 
        $A.util.addClass(modal, 'slds-fade-in-hide'); 
        $A.util.removeClass(modal, 'slds-backdrop--open'); 
    }, 

    /* Description: Simulate bill deposit
     * Parameters: Case Id
     * Author: Michael Lasala
     * Date Created: MAR-13-17
     */
    simulateBillDepositController : function(component, event, helper) {

        var action = component.get("c.simulateBillDeposit");

        action.setParams({"caseId": component.get("v.recordId")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var simulateStatus = response.getReturnValue()
                console.log('simulateBillDepositController: '+JSON.stringify(simulateStatus));
                
                //Iterate over map
                for(var key in simulateStatus){
                    if(simulateStatus.hasOwnProperty(key)){
                        // console.log('key: '+key);
                            
                        //Display success toast
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": key+"!",
                                              "message": simulateStatus[key],
                                              "type": key
                        });
                        toastEvent.fire();
                    }
                }
            } else {
                console.log('simulateBillDepositController error: '+state);
                console.log('simulateBillDepositController '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);

        //Refresh detail page to reflect updated deposit amount
        $A.get('e.force:refreshView').fire();
    }, 

    /* Description: Validate bill deposit
     * Parameters: Case Id
     * Author: Michael Lasala
     * Date Created: MAR-15-17
     */
    validateBillDepositController : function(component, event, helper, isEstimate) {

        var action = component.get("c.validateBillDeposit");

        action.setParams({"caseId": component.get("v.recordId")});


        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var simulateStatus = response.getReturnValue();
                console.log('validateBillDepositController: '+JSON.stringify(simulateStatus));

                var isValid = true;

                //Iterate over map
                for(var key in simulateStatus){
                    if(simulateStatus.hasOwnProperty(key)){
                        // console.log('key: '+key);
                        
                        isValid = false;

                        //Display error toast
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": key+"!",
                                              "message": simulateStatus[key],
                                              "type": key
                        });
                        toastEvent.fire();

                    }
                }
                console.log("isValid:" + isValid);
                if(isValid == true){
                    
                    if(isEstimate == true){
                        //Display modal
                        helper.openModalHelper(component, 'manualSimulationDiv');
                        helper.openModalHelper(component, 'backGroundSectionId');

                        //Populate picklist values 
                        helper.setPicklistValues(component, event, helper);
                    
                    } else {

                        //Update amount
                        helper.simulateBillDepositController(component, event, helper);
                    }
                }

            } else {
                console.log('validateBillDepositController error: '+state);
                console.log('validateBillDepositController '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }, 

    /* Description: Invoke simulation
     * Parameters: Case Id
                   Onload/Update boolean
                   localFranchiseTax value
                   lifelineDiscount value
                   lifelineSubsidy value
                   scSubsidy value
                   energyTax value
                   zeroRated value
                   specialDiscount value
                   scid value
                   schd value
     * Author: Michael Lasala
     * Date Created: MAR-14-17
     */
    manualSimulationHelper: function(component, event, helper, isUpdate) {

        var action = component.get("c.calculateBillDeposit");

        //Identify whether method was called onload
        if(isUpdate == true){

            //Get user defined values
            action.setParams({"caseId": component.get("v.recordId"), 
                              "isUpdate": isUpdate,
                              "localFranchiseTax": helper.getValue(component, event, helper, "localFranchiseTax"),
                              "lifelineDiscount": helper.getValue(component, event, helper, "lifelineDiscount"),
                              "lifelineSubsidy": helper.getValue(component, event, helper, "lifelineSubsidy"),
                              "scSubsidy": helper.getValue(component, event, helper, "scSubsidy"),
                              "energyTax": helper.getValue(component, event, helper, "energyTax"),
                              "zeroRated": helper.getValue(component, event, helper, "zeroRated")});
                              // "specialDiscount": helper.getValue(component, event, helper, "specialDiscount"),
                              // "scid": helper.getValue(component, event, helper, "scid"),
                              // "schd": helper.getValue(component, event, helper, "schd")});
        } else {

            //Set values to null (onload)
            action.setParams({"caseId": component.get("v.recordId"), 
                              "isUpdate": isUpdate,
                              "localFranchiseTax": '',
                              "lifelineDiscount": '',
                              "lifelineSubsidy": '',
                              "scSubsidy": '',
                              "energyTax": '',
                              "zeroRated": ''});
                              // "specialDiscount": '',
                              // "scid": '',
                              // "schd": ''});
        }

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var billDeposit = response.getReturnValue();
                console.log('manualSimulationHelper: '+JSON.stringify(billDeposit));
                
                component.set("v.variable", billDeposit);
                helper.setValue(component, event, helper, "rateType", billDeposit.rate);
                //Set default picklist values onload
                if(isUpdate == false){

                    helper.setValue(component, event, helper, "localFranchiseTax", billDeposit.isLocalFranchiseTax);
                    helper.setValue(component, event, helper, "lifelineDiscount", billDeposit.isLifelineDiscount);
                    helper.setValue(component, event, helper, "lifelineSubsidy", billDeposit.isLifeLineSubsidy);
                    helper.setValue(component, event, helper, "scSubsidy", billDeposit.isSCSubsidy);
                    helper.setValue(component, event, helper, "energyTax", billDeposit.isEnergyTax);
                    helper.setValue(component, event, helper, "zeroRated", billDeposit.isZeroRated);
                    // helper.setValue(component, event, helper, "specialDiscount", billDeposit.isSpecialDiscount);
                    // helper.setValue(component, event, helper, "scid", billDeposit.isSCID);
                    // helper.setValue(component, event, helper, "scid", billDeposit.isSCHD);

                    for(var i=1; i<=3; i++){
                        var energyTax = component.find("energyTax"+i).get("v.value");
                        helper.setValue(component, event, helper, "kWhBracket"+i, energyTax);
                    }
                }
            } else {
                console.log('manualSimulationHelper error: '+state);
                console.log('manualSimulationHelper '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);

        //Display manual simulation modal
        helper.openModalHelper(component, 'manualSimulationDiv');
        helper.openModalHelper(component, 'backGroundSectionId');
    }, 

    /* Description: Set picklist values for picklist fields
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-14-17
     */
    setPicklistValues : function(component, event, helper) {
        console.log("setPicklistValues");
        var opts=[];

        //Push values as select options
        opts.push({"class": "optionClass", label: 'Yes', value: 'Yes'});
        opts.push({"class": "optionClass", label: 'No', value: 'No'});

        //Push values to component
        component.find("localFranchiseTax").set("v.options", opts);
        component.find("localFranchiseTax").set("v.options", opts);
        component.find("lifelineDiscount").set("v.options", opts);
        component.find("lifelineSubsidy").set("v.options", opts);
        component.find("scSubsidy").set("v.options", opts);
        component.find("energyTax").set("v.options", opts);
        component.find("zeroRated").set("v.options", opts);
        // component.find("specialDiscount").set("v.options", opts);
        // component.find("scid").set("v.options", opts);
        // component.find("schd").set("v.options", opts);

        //Invoke simulation
        helper.manualSimulationHelper(component, event, helper, false);
    }, 

    /* Description: Set component value
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-15-17
     */
    setValue : function(component, event, helper, elementId, value) {
        component.find(elementId).set("v.value", value);
    }, 

    /* Description: Get component value
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-16-17
     */
    getValue : function(component, event, helper, elementId) {
        return component.find(elementId).get("v.value");
    }, 

    /* Description: Extract error message
     * Parameters: Error
     * Author: Michael Lasala
     * Date Created: MAR-15-17
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

    /* Description: Estimate
     * Author:Jerome To
     * Date Created: MAY-19-17
     */
    estimateBillDeposit: function(component, event, helper) {
        var action = component.get("c.reCalculateBillDeposit");
        component.set("v.variable.rate",component.find("rateType").get("v.value"));
        action.setParams({"billDepositJSON": JSON.stringify(component.get("v.variable"))});        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var billDeposit = response.getReturnValue();
                console.log('estimateBillDeposit: '+JSON.stringify(billDeposit));
                
                component.set("v.variable", billDeposit);
                // $A.get('e.force:refreshView').fire();
            } else {
                console.log('estimateBillDeposit error: '+state);
                console.log('estimateBillDeposit '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);

        helper.openModalHelper(component, 'manualSimulationDiv');
        helper.openModalHelper(component, 'backGroundSectionId');
    },    

    getRateType : function (component, event, helper) {
        var action = component.get("c.getServiceRateTypes");
        var inputsel = component.find("rateType");
        var opts=[];
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){                
                for(var i=0;i< a.getReturnValue().length;i++){
                    opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
                }
                inputsel.set("v.options", opts);
            }  
        });
        $A.enqueueAction(action); 
    }
})