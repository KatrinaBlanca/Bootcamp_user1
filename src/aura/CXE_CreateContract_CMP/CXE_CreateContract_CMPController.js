({
    /* Description: Validate if Case has Account, and related account has billing address
     * Parameters: None
     * Author: Rom Edison Reyes
     * Date Created: MAR-16-17
     */
    validateAccountOnCase : function(component, event, helper) {    
        //displayContractModal
        console.log("Validate Account On Case");
        component.get("v.recordId");
        
        var action = component.get("c.getCase");
	        //Set parameters
	        action.setParams({"caseId":  component.get("v.recordId")});
			
	        action.setCallback(this, function(response) {
	            var state = response.getState();
                var caseRec = response.getReturnValue();
                console.log('STATE: '+ response.getState());
                console.log('caseRec: ' + caseRec);
	            if(state == 'SUCCESS'){
                        console.log('returnvalue: success');
                    
                   if(caseRec.AccountId == null){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({"title": "Error!",
                                                  "message": "You cannot create a contract if case has no account.",
                                                  "type": "info"     //CSM-1945
                            });
                            toastEvent.fire();
                   }
                   //START CSM-11942 AUG-26-17 GGrandea
                   else if(caseRec.Legacy_Account_Number__c != null){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({"title": "Error!",
                                                  "message": "You cannot create a contract if you are reusing an existing contract.",
                                                  "type": "info"     //CSM-1945
                            });
                            toastEvent.fire();
                   }
                   //END CSM-11942 AUG-26-17 GGrandea
                   else{
                            if(caseRec.Multimetering__c == false){
                                
                                //Display account disabled input (CSM-1880)
                                component.set("v.isAccountInput", true);

                                //single meter
                                component.set("v.accountId", caseRec.AccountId);
                                //START CSM-12318 RReyes AUG-23-17 - remove checking of address on account
                                //START CSM-7191 RReyes JUN-28-17
                                helper.validateCaseBillAdd(component, event, helper, caseRec);
                                /*var servReqs = '';
                                if(caseRec.CXE_Service_Request_s__c != null 
                                   && caseRec.CXE_Service_Request_s__c != ''){
                                   servReqs =  caseRec.CXE_Service_Request_s__c;
                                }
                                console.log('Service Requests: ' + caseRec.CXE_Service_Request_s__c);
                                console.log('Record Type: ' + caseRec.RecordType.DeveloperName);
                                console.log('servReqs: ' + servReqs);
                                //START CSM-XXXX RReyes JUL-13-17 - changed includes to indexOf to address IE11 issue
                                if(caseRec.RecordType.DeveloperName == 'CXE_Modification_of_Electric_Service'
                                  && servReqs.indexOf("Transfer of Service") >= 0){
                                 //END CSM-XXXX RReyes JUL-13-17 - changed includes to indexOf to address IE11 issue
                                    console.log('run address validation for modify.');
                                    helper.validateCaseBillAdd(component, event, helper, caseRec, true);
                                }else{
                                	helper.validateAccountBillAdd(component, event, helper, caseRec);
                                }
                                //END CSM-7191 RReyes JUN-28-17*/
                                //END CSM-12318 RReyes AUG-23-17 - remove checking of address on account
                            }else if(caseRec.Multimetering__c == true){
                                
                                //Display account lookup input (CSM-1880)
                                component.set("v.isAccountInput", false);

                                //multimeter
                                //START CSM-12318 RReyes AUG-23-17 - remove isModify parameter
                                //START CSM-7191 RReyes JUN-28-17 - added isModify parameter
                                helper.validateCaseBillAdd(component, event, helper, caseRec);
                                //END CSM-7191 RReyes JUN-28-17 - added isModify parameter
                                //END CSM-12318 RReyes AUG-23-17 - remove isModify parameter
                            }
                            
                        }
                        
		            }
	        });
	        $A.enqueueAction(action);
    },
    
	/* Description: Close Contract modal
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
    closeContractModal : function(component, event, helper) {
    	//Hide Account lookup
		// document.getElementById("accountInputSection").style.display = 'none';
        //Hide Account outputText
		// document.getElementById("accountOutputSection").style.display = 'none';

        helper.clearError(component, helper, "Type__c");
        helper.clearError(component, helper, "Method_of_Payment__c");

        helper.closeModalHelper(component, 'contractDiv');
        helper.closeModalHelper(component, 'backGroundSectionId');
    }, 

    /* Description: Save Contract record
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
    insertContract : function(component, event, helper) {

    	//Disable save button
        helper.toggleElement(component, helper, 'insertContract', true);

    	//Validate required fields
    	if(helper.validateContract(component, helper)){

			//Check Account value for single/multimeter
			if(!$A.util.isEmpty(component.get("v.accountId"))){
				component.set("v.contract.AccountId", component.get("v.accountId"));
				console.log('prepop: '+component.get("v.contract.Account"));
			} else {
				console.log('manual: '+component.get("v.contract.Account"));
			}

    		var contractRecord = component.get("v.contract");

    		contractRecord.Case__c = component.get("v.recordId");
    		
    		//Delete attributes to avoid invalid sobject error
    		//START CSM-2165 RReyes - 05/22/17 - workaround incase summer 17 don't fix the error
            //delete contractRecord.Account;
    		//delete contractRecord.Account_Rep__r;
    		component.set("v.contract.Case__c", component.get("v.recordId"));
    		component.set("v.contract.Account", null);
            component.set("v.contract.Account_Rep__r", null);
            //END CSM-2165 RReyes - 05/22/17 - workaround incase summer 17 don't fix the error
    		// delete contractRecord.Pricebook2;

    		console.log('contractRecord: '+JSON.stringify(contractRecord));

	        var action = component.get("c.saveContract");

	        //Set parameters
	        action.setParams({"contractRecord": component.get("v.contract")});

	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            if(state == "SUCCESS"){
	                console.log('insertContract: '+JSON.stringify(response.getReturnValue()));

	                if(response.getReturnValue() == 'Success'){
		                //Display toast on successful create of Contract
		                var toastEvent = $A.get("e.force:showToast");
		                toastEvent.setParams({"title": "Success!",
		                                      "message": "Contract has been created.",
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
	                        
	                        console.log('insertContract error: '+state+' '+errors[0].message);
	                    }
	                } else {
	                    console.log('insertContract unknown error');
	                }

	                //Display toast if error occurred
		            var toastEvent = $A.get("e.force:showToast");
		            toastEvent.setParams({"title": "Error!",
		                                  "message": "Error creating Contract.",
		                                  "type": "error"
		            });	            
	            }
	            toastEvent.fire();

	            //Enable save button
            	helper.toggleElement(component, helper, 'insertContract', false);
	        });
	        $A.enqueueAction(action);

	        helper.closeModalHelper(component, 'contractDiv');
        	helper.closeModalHelper(component, 'backGroundSectionId');

        	//Refresh detail page to reflect Address on related list
            $A.get('e.force:refreshView').fire();
       	} else {
       		//Display toast if error occurred
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({"title": "Error!",
                                  "message": 'Review the errors on this page.',
                                  "type": "error"
            });
            toastEvent.fire();

            //Enable save button
        	helper.toggleElement(component, helper, 'insertContract', false);
       	}
    }
})