({	
	doInit : function(component, event, helper) {
		helper.initializeCheckConglomerate(component, event, helper); //R2C CSM-14749 Shayne 12/01/2017
		helper.getAccountsForCancellation(component, event, helper);
	},

	accountPicklistChanged : function(component, event, helper) {
		var acctSelected = component.find("accountSelected").get("v.value");
		var defaultReason = $A.get("$Label.c.RFC_PLEASE_SPECIFY");
		component.set("v.selectedAcct", acctSelected);
		component.set("v.selectedReason", defaultReason);
		//START CSM-13219 RReyes OCT-12-17
        var defaultAcct = 'Select Account Number';
        if(acctSelected != null && acctSelected != '' && acctSelected != defaultAcct) {
            component.set("v.noAcctErrorMsg", '');
        }
        //END CSM-13219 RReyes OCT-12-17
	},

	reasonPicklistChanged : function(component, event, helper) {
		var reasonSelected = component.find("reasonForCancelSelected").get("v.value");
		component.set("v.selectedReason", reasonSelected);

		//START CSM-13224 RReyes OCT-12-17
        var defaultReason = $A.get("$Label.c.RFC_PLEASE_SPECIFY");
        if(reasonSelected != null && reasonSelected != '' && reasonSelected != defaultReason) {
            component.set("v.noReasonErrorMsg", '');
        }
        //END CSM-13224 RReyes OCT-12-17
	},

	validateFields : function(component, event, helper) {
		helper.validateRequiredFields(component, event, helper);
	},

	goToMyAccts : function(component, event, helper) {
		helper.goToMyAccounts(component, event, helper);
	},

	proceedChange : function(component, event, helper) {
		var old = event.getParam("oldValue");
		var current = event.getParam("value");
		console.log("old value: " + old);
		console.log("current value: " + current);
		if(old == false && current == true){
			component.set("v.isProceedClicked", false);
			helper.createCase(component, event, helper);
			//spinner (loading)
			var cmpTarget = component.find("appSpinner");
        	$A.util.toggleClass(cmpTarget, 'slds-hide');
		}
	},

	eventFireLoader: function(component, event, helper) {
		//spinner (loading)
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    }
})