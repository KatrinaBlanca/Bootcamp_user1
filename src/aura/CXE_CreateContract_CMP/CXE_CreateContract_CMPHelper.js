({
    /* Description: Validate if Case has billing address
     * Parameters: None
     * Author: Rom Edison Reyes
     * Date Created: MAR-17-17
     */
    //START CSM-12318 RReyes AUG-23-17 - removed isModify parameter
    //START CSM-7191 RReyes JUN-28-17 - added isModify parameter
    validateCaseBillAdd : function(component, event, helper, caseRec) {    
    //END CSM-7191 RReyes JUN-28-17 - added isModify parameter
    //END CSM-12318 RReyes AUG-23-17 - removed isModify parameter
        //displayContractModal
        console.log("Validate Billing Addresses of Case");
        var action = component.get("c.validateIfCaseHasBillingAddress");
          //Set parameters
          action.setParams({"caseId":  component.get("v.recordId")});
      
          action.setCallback(this, function(response) {
              var state = response.getState();
                var isValid = response.getReturnValue();

                console.log('isValid: ' + isValid);
              if(state == 'SUCCESS'){
                            console.log('isAccountInput: '+component.get("v.isAccountInput"));
                        console.log('returnvalue: success');
                        if(isValid){
                          //START CSM-12318 RReyes AUG-23-17 - removed validation on Account
                            //START CSM-7191 RReyes JUN-28-17 - added isModify parameter
                            //if(isModify){
                            //    helper.validateAccountBillAdd(component, event, helper, caseRec);
                            //}else{
                            helper.validateContracts(component, event, helper, caseRec);   
                            //}
                            //END CSM-7191 RReyes JUN-28-17 - added isModify parameter
                          //END CSM-12318 RReyes AUG-23-17 - removed validation on Account
                        }else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({"title": "Error!",
                                                  "message": "A billing address is required on the case before creating a contract.",
                                                  "type": "info"     //CSM-1945
                            });
                            toastEvent.fire();
                        }
                }
          });
          $A.enqueueAction(action);
    },
    
     /* Description: Validate if Case has Account, and related account has billing address
     * Parameters: None
     * Author: Rom Edison Reyes
     * Date Created: MAR-16-17
     */
    validateAccountBillAdd : function(component, event, helper, caseRec) {    
        //displayContractModal
        console.log("Validate Billing Addresses of Account");
        var action = component.get("c.validateIfAccountHasBillingAddress");
          //Set parameters
          action.setParams({"acctId":  component.get("v.accountId")});
      
          action.setCallback(this, function(response) {
              var state = response.getState();
                var isValid = response.getReturnValue();

                console.log('isValid: ' + isValid);
              if(state == 'SUCCESS'){
                        console.log('returnvalue: success');
                            console.log('isAccountInput: '+component.get("v.isAccountInput"));
                        if(isValid){
                          helper.validateContracts(component, event, helper, caseRec);

                        }else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({"title": "Error!",
                                                  "message": "A billing address is required on the case's account before creating a contract.",
                                                  "type": "info"     //CSM-1945
                            });
                            toastEvent.fire();
                        }
                }
          });
          $A.enqueueAction(action);
    },
    
  /* Description: Display Contract modal
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
     displayContractModal : function(component, event, helper) {
      //Clear field values
    component.set("v.contract.AccountId", null);
    // component.set("v.contract.V10_Account_No__c", null);
    // component.set("v.contract.Recipient_Name__c", null);
    // component.set("v.contract.Statement_Production_Trigger_Type__c", null);
    component.set("v.contract.Account_Rep__c", null);
    component.set("v.contract.Care_Of__c", null);
    component.set("v.contract.Description", null);
    component.set("v.contract.Type__c", null);
    component.set("v.contract.Method_of_Payment__c", null);
    // component.set("v.contract.Pricebook2Id", null);

    //Clear lookup values
        //Validate whether account disabled or lookup is displayed (CSM-1880)
        if(component.get("v.isAccountInput") == false){
            // component.find("accountInput").get("v.body")[0].set("v.values", "");
        }
    component.find("accountRep").get("v.body")[0].set("v.values", "");
    // component.find("priceBook").get("v.body")[0].set("v.values", "");

    //Populate picklist values
        helper.setPicklistValues(component, event, helper);
  },
    
  /* Description: Show Modal
     * Parameters: Element Id
     * Author: Michael Lasala
     * Date Created: MAR-10-17
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
     * Date Created: MAR-10-17
     */
    closeModalHelper : function(component, elementId) {
        //Hide modal
        var modal = component.find(elementId); 
        $A.util.addClass(modal, 'slds-fade-in-hide'); 
        $A.util.removeClass(modal, 'slds-backdrop--open'); 
    },

    /* Description: Get Case details
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
  setCase : function(component, event, helper) {
    var action = component.get("c.getCase");

        action.setParams({"caseId": component.get("v.recordId")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var caseRecord = response.getReturnValue();
                console.log('setCase: '+JSON.stringify(caseRecord));

                //Set case id
                component.set("v.caseId", caseRecord.Id);
                console.log('caseId: '+component.get("v.caseId"));
                
                //Set case number
                component.find("case").set("v.value", caseRecord.CaseNumber);

                //Validate if case has an account
                if(!$A.util.isEmpty(caseRecord.AccountId) && 
                   !$A.util.isUndefinedOrNull(caseRecord.AccountId)){

                    //Show/hide input and output Account field based on caseRecord.Multimetering
                    if(caseRecord.Multimetering__c == true){
                        
                        //Display Account lookup
                        //component.set("v.isMultimeter", true);
                        // document.getElementById("accountInputSection").style.display = 'block';
                        //Display account lookup input (CSM-1880)
                        component.set("v.isAccountInput", false);
                        console.log('Multimeter: Display set to block!');
                        // Start CSM-1294: Von Pernicia 3/15/17
                        //Pre-populate values from Contract
                        component.set("v.contract.AccountId", caseRecord.AccountId);
                        
                        //Populate Account lookup if not null
                        if(caseRecord.AccountId != '' &&
                           caseRecord.AccountId != null){
        
                           helper.setAccount(component, event, helper);
                        }
                        // End CSM-1294: Von Pernicia 3/15/17
                    } else {

                        //Display account disabled input (CSM-1880)
                        component.set("v.isAccountInput", true);
                        //Display Account outputText
                        // document.getElementById("accountOutputSection").style.display = 'block';
            console.log('Single-meter: Display set to block!');
                        //Assign Account id to attribute
                        component.set("v.accountId", caseRecord.AccountId);

                        //Set Account name text
                        component.find("accountOutput").set("v.value", caseRecord.Account.Name);

                    }
                    console.log('isAccountInput: '+component.get("v.isAccountInput"));

                    //Set Owner name
                    helper.setOwner(component, event, helper);

                    //Display contract modal
                    helper.openModalHelper(component, 'contractDiv');
                    helper.openModalHelper(component, 'backGroundSectionId');
                    
                } else {

                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Oops!",
                                          "message": 'Account has not been created.',
                                          "type": "info"
                    });
                    toastEvent.fire();

                    //Hide Account lookup
                    // document.getElementById("accountInputSection").style.display = 'none';
                    //Hide Account outputText
                    // document.getElementById("accountOutputSection").style.display = 'none';
                    //Display disabled account input (CSM-1880)
                    // component.set("v.isAccountInput", true);

                    helper.closeModalHelper(component, 'contractDiv');
                    helper.closeModalHelper(component, 'backGroundSectionId');
                }
            } else {
                console.log('setCase error: '+state);
                console.log('setCase '+helper.extractError(response.getError()));
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

        action.setParams({"accountId": component.get("v.contract.AccountId")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('setAccount: '+component.get("v.contract.AccountId")+', '+JSON.stringify(response.getReturnValue()));

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
  // End CSM-1294: Von Pernicia 3/15/17
    
  /* Description: Get User details
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
  setOwner : function(component, event, helper) {
    var action = component.get("c.getUser");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('setUser: '+JSON.stringify(response.getReturnValue()));
          
          //Set owner name
          component.find("owner").set("v.value", response.getReturnValue());

            } else {
                console.log('setUser error: '+state);
                console.log('setUser '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);
  }, 

  /* Description: Validate Contract fields
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
    validateContract : function(component, helper){
        var isValid = false;

        var isAccountValid;

        if($A.util.isEmpty(component.get("v.accountId"))){

            var accountValue = component.get("v.contract.AccountId");

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
        
        //Validate required fields
        var isStatusValid = helper.validateField(component, helper, component.get("v.contract.Status"), 'Status', 'a Status');
        var isTypeValid = helper.validateField(component, helper, component.get("v.contract.Type__c"), 'Type__c', 'a Type');
        var isPaymentMethodValid = helper.validateField(component, helper, component.get("v.contract.Method_of_Payment__c"), 'Method_of_Payment__c', 'a Method of Payment');
        
        if(isAccountValid && 
           isStatusValid && 
           isTypeValid && 
           isPaymentMethodValid){

            isValid = true;

        } else {
            
            //Enable save button
            helper.toggleElement(component, helper, 'insertContract', false);
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
        // console.log('validateField : '+fieldValue);
        if(($A.util.isEmpty(fieldValue) && 
            $A.util.isUndefinedOrNull(fieldValue)) || 
           fieldValue == '--None--'){

            //Set error
            component.find(elementId).set("v.errors", [{message: "You must enter "+errorMessage+"."}]);
            return false;

        } else {

            //Clear error
            component.find(elementId).set("v.errors", null);
            return true;
        }
    }, 

  /* Description: Set picklist values for picklist fields
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-08-17
     */
    setPicklistValues : function(component, event, helper) {
        var action = component.get("c.getContractPicklistValues");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                // console.log('setPicklistValues: '+JSON.stringify(response.getReturnValue()));
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
                        //Set default status value
                        component.set("v.contract.Status", "Draft");
                    }
                }
            } else {
                console.log('setPicklistValues error: '+state);
                console.log('setPicklistValues '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);


        //Get Case details
        helper.setCase(component, event, helper);
    }, 

  /* Description: Extract error message
     * Parameters: Error
     * Author: Michael Lasala
     * Date Created: MAR-10-17
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
  
    /* Description: Extract error message
     * Parameters: Error
     * Author: Jerome To
     * Date Created: MAR-32-17 // CSM-1926
     */
  validateContracts : function(component, event, helper, caseRec) {  
        var action = component.get("c.isValidToCreateContract");    
        console.log('Case Status: ' + caseRec.Status);
        action.setParams({"caseId": caseRec.Id,
                          "caseStatus" : caseRec.Status,
                          "isMultiMeter": caseRec.Multimetering__c});

        action.setCallback(this, function(response) {
            var state = response.getState();
            var errorMsg = response.getReturnValue(); //START/END RReyes CSM-2163 - 05/18 - LockerService Issue
            console.log('inside function ' + state);
            console.log('inside function ' + errorMsg);
            if(state == "SUCCESS"){ 
                console.log('rom: error message: ' + errorMsg);
                if(errorMsg != ''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Error!",
                                          "message": errorMsg,
                                          "type": "info"     //CSM-1926
                                         });
                    toastEvent.fire();
                }else{
                    console.log('Display Contract Modal');
                   helper.displayContractModal(component, event, helper);
                } 
            }
        });
        $A.enqueueAction(action);
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