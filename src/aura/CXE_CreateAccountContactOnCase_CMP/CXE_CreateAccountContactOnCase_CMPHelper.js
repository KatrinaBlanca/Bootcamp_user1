({
	//BEGIN Account methods ----------------------------------------------------
	getCase: function(component, event, helper) {
        var action = component.get("c.getCaseDetails");
        console.log(component.get("v.myCaseId"));
        action.setParams({
            caseId : component.get("v.recordId")
            //caseId : component.get("v.myCaseId")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var currentCase = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.caseRecord", currentCase);

                //BEGIN Michael Lasala FEB-17-17 Added validation for checkboxes below
                if(!currentCase.Application_for_Business_Customer__c && 
                   !currentCase.Application_for_Residential_Customer__c){

                    //Display error toast
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Oops!",
                        "message": "Please select either Application for Individual or Business Customer.",
                        "type": "info"
                    });
                    toastEvent.fire();
                    console.log('TOAST: Please select either Application for Individual or Business Customer.');
                    //CSM-1925
                    component.find("createAccount").set("v.disabled", false);

                }   //BEGIN Michael Lasala MAR-30-17 CSM-2055
                else if($A.util.isEmpty(currentCase.Customer_Type__c) && 
                        $A.util.isUndefinedOrNull(currentCase.Customer_Type__c)){

                    //Display error toast
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Oops!",
                        "message": "Please select a Customer Type.",
                        "type": "info"
                    });
                    toastEvent.fire();
					console.log('TOAST: Please select a Customer Type.');
                    component.find("createAccount").set("v.disabled", false);

                //END Michael Lasala MAR-30-17
                } else {
                    if(currentCase.Application_for_Business_Customer__c){
                        component.set("v.isBusiness", true);
                    }else if(currentCase.Application_for_Residential_Customer__c){
                        component.set("v.isBusiness", false);
                    }
                    console.log('isBusiness:' + component.get("v.isBusiness", false));
                    console.log('Case Account:' + currentCase.AccountId);
                    if(currentCase.AccountId != null){
                        helper.showError(component, event);
                    }else{
                        console.log('show');

                        helper.searchAddress(component, event, helper);
                        // helper.searchRelatedAccounts(component, event, helper);
                    }
                }
                //END Michael Lasala FEB-17-17 Added validation for checkboxes below
            }
        });
        $A.enqueueAction(action);  
    },
    
    /* Description: Retrieve Address/es related to Case (CSM-222)
     * Parameters: Case Id
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     * Updated       -  MAR-10-17   -   Jerome To   -   updated code to Filter Billing and Service Address Types
     */
    searchAddress : function(component, event, helper) {
        var action = component.get("c.retrieveRelatedCaseAddressTypes");
        var hasService = false;
        var hasBilling = false;

        action.setParams({"caseId": component.get("v.recordId")});
    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('searchAddress: '+response.getReturnValue());                
                var relatedAddresses = response.getReturnValue();
                console.log('>>>>> JSON ' + JSON.stringify(relatedAddresses));
                console.log('>>>>> length ' + relatedAddresses.length);
                if(relatedAddresses.length < 1) {
                    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": "Oops!",
                                              "message": 'Please create Customer Address.',
                                              "type": "info"
                        });
                        toastEvent.fire();
                    console.log('TOAST: Please create Customer Address.');
                    //CSM-1925
                    component.find("createAccount").set("v.disabled", false);

                } else {
                    helper.searchRelatedAccounts(component, event, helper);
                }
            } else {
                console.log('init error: '+state);
            }
        });
        $A.enqueueAction(action);
    },

    searchRelatedAccounts: function(component, event, helper){
        console.log('search account called');
        var action = component.get("c.getRelatedAccounts");
        var caseParam = component.get("v.caseRecord");
        console.log('CaseParam: ' + caseParam);
        action.setParams({
            caseRec : component.get("v.caseRecord")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var myAccounts = response.getReturnValue();
            console.log('myAccounts' + JSON.stringify(myAccounts));
            console.log('return size:' + myAccounts.length);
            if (state === "SUCCESS") {
                component.set("v.accountList", myAccounts);
                console.log('My AccountList:' + component.get("v.accountList"));
            }
            
            if(myAccounts.length > 0){
                var acctId = myAccounts[0].Id;
                component.set("v.selectedAcctId", acctId);
                console.log('acctId: ' + acctId);
                helper.showModal(component);
                console.log('MODAL: Show account choices.');
            } else{
                console.log('Trying to create new account...');
                helper.createAccount(component, event, helper);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    createAccount: function(component, event, helper){
        console.log('create account called');
        var action = component.get("c.createAccount");
        var caseParam = component.get("v.caseRecord");
        console.log('CaseParam: ' + caseParam);
        action.setParams({
            caseRec : component.get("v.caseRecord")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var myAccount = response.getReturnValue();
            console.log('myAccount' + myAccount);
            if (state === "SUCCESS") {
                component.set("v.createdAccount", myAccount);
                console.log('My Account:' + component.get("v.createdAccount"));
            } 
            console.log('account ID:' + myAccount.Id);
            //Start CSM-12129/CSM-12514 Von Pernicia AUG-02-17
            if (state === "SUCCESS") {
                component.set("v.createdAccount", myAccount);
                console.log('My Account:' + component.get("v.createdAccount"));
            } 
            console.log('account ID:' + myAccount.Id);
            if(myAccount == 'Success'){
                console.log('call toast');
                $A.get('e.force:refreshView').fire();
                helper.showAccountCreatedToast(component, event);
            } else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": myAccount,
                    "type": "error"
                });
                toastEvent.fire();
            }
			//End CSM-12129/CSM-12514 Von Pernicia AUG-02-17

            //CSM-1925
            component.find("createAccount").set("v.disabled", false);
        });
        $A.enqueueAction(action);
    },
    
    showModal : function(component) {
        console.log('defaultAcctId: ' + component.get("v.selectedAcctId"));
        console.log('Show Modal');
        // document.getElementById("backDrop").style.display = "block";
        document.getElementById("backGroundSectionId").style.display = "block";
        document.getElementById("modalPopUp").style.display = "block"; 
        console.log('MODAL SHOWN');
    },
    
    hideModal : function(component, event, helper) {
        console.log('Hide Modal');
        // document.getElementById("backDrop").style.display = "none";
        document.getElementById("backGroundSectionId").style.display = "none";
        document.getElementById("modalPopUp").style.display = "none"; 
        console.log('MODAL HIDDEN');
    },
    
    showAccountCreatedToast : function(component, event) {
        console.log('account created toast event');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Account was created for this Case.",
            "type": "success"
        });
        toastEvent.fire();
        console.log('TOAST: Account was created for this Case.');
    },
    
    showAccountRelatedToast : function(component, event) {
        console.log('account related toast event');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Account was related to this Case.",
            "type": "success"
        });
        toastEvent.fire();
        console.log('TOAST: Account was related for this case.');
    },
    
    showError : function(component, event) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Oops!",
            "message": "Case already has an existing related account.",
            "type": "info"
        });
        toastEvent.fire();
		console.log('TOAST: Case already has an existing related account.');
        //CSM-1925
        component.find("createAccount").set("v.disabled", false);
    },
    
    getSelectedAccount : function(component, event, helper) {
        var elem = event.target;
    	var selAcctId = elem.value;
        console.log('Account ID: ' + selAcctId);
        component.set("v.selectedAcctId", selAcctId);
    },
    
    saveSelectedAccount : function(component, event, helper) {
		console.log('save selected account called');
        var action = component.get("c.relateExistingAccount");
        console.log('CASE ID: ' + component.get("v.myCaseId"));
        console.log('ACCT ID: ' + component.get("v.selectedAcctId"));
        action.setParams({
            caseId : component.get("v.recordId"),
            acctId : component.get("v.selectedAcctId")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('UPDATE SUCCESS!');
                helper.hideModal(component, event, helper);
                helper.showAccountRelatedToast(component, event);
                $A.get('e.force:refreshView').fire();
            } 
        });
        $A.enqueueAction(action);    
        //START CSM-7272 RReyes - re-enable create account button after reusing account
        component.find("createAccount").set("v.disabled", false);
        //END CSM-7272 RReyes - re-enable create account button after reusing account
    },

    
    //END Account methods ------------------------------------------------------

    //BEGIN Contact Methods ----------------------------------------------------
    /* Description: Retrieve Case details to validate whether creation of Contact is valid
     * Parameters: Case Id
     * Author: Michael Lasala
     * Date Created: FEB-14-17
     */
    retrieveCase : function(component, event, helper) {
        console.log('recordId: '+component.get("v.recordId"));

        var action = component.get("c.validateCase");
        
        action.setParams({"caseId": component.get("v.recordId")});
    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
            	var errorMessage = response.getReturnValue();
                console.log('errorMessage: '+errorMessage);

		        if(errorMessage != ''){
		            
		            //Display toast on validation
		            var toastEvent = $A.get("e.force:showToast");
		            toastEvent.setParams({"title": "Oops!",
		                                  "message": errorMessage,
		                                  "type": "info"
		            });
		            toastEvent.fire();
                    console.log('TOAST: ' + errorMessage);
                    //CSM-1925
                    component.find("createContactButton").set("v.disabled", false);

		        } else {

		        	//Valid, proceed to next step
		        	helper.checkExistingContacts(component, event, helper);
		        }
            } else {
                console.log('init error: '+state);
            }
        });
        $A.enqueueAction(action);
    },

	/* Description: Display list of existing Contacts with similar Case details or auto create Contact
     * Parameters: Case Id
     * Author: Michael Lasala
     * Date Created: FEB-08-17
     */
    checkExistingContacts : function(component, event, helper) {
            var action = component.get("c.searchContacts");

            action.setParams({"caseId": component.get("v.recordId")});

            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state == "SUCCESS"){
                    console.log('Contact List: '+response.getReturnValue().length+', '+JSON.stringify(response.getReturnValue()));
                    
                    if(response.getReturnValue().length>0){

                        //Set list of Contacts to table
                        component.set("v.contactList", response.getReturnValue());

                        //Display modal
                        document.getElementById("backGroundSectionId").style.display = "block";
                        document.getElementById("contactListDiv").style.display = "block";

                    } else {
                        
                        //Display toast on create of Contact
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": "Success!",
                                              "message": "Contact has been created.",
                                              "type": "success"
                        });
                        toastEvent.fire();
                        console.log('TOAST: Contact has been created.');
                    }
                    
                    //CSM-1925
                    component.find("createContactButton").set("v.disabled", false);

                } else {
                    console.log('checkExistingContacts error: '+state);
                }
            });
            $A.enqueueAction(action);

            //Refresh detail page to reflect created Contact
            $A.get('e.force:refreshView').fire();
        }
	}
    //END Contact Methods ------------------------------------------------------
})