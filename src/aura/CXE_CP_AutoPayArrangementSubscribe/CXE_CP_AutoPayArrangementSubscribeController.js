({
	doInit : function(component, event, helper) {
		helper.initializeCheckConglomerate(component, event, helper); //R2C CSM-14749 Shayne 12/01/2017
		helper.getAccountsForEnrollment(component, event, helper);
	},

	accountPicklistChanged : function(component, event, helper) {
		var acctSelected = component.find("accountSelected").get("v.value");
		component.set("v.selectedAcct", acctSelected);
		helper.validateSelectedAccount(component, event, helper, acctSelected);
		component.set("v.agentOptions", []);
		console.log('Account Selected: ' + component.get("v.selectedAcct"));
	},

	goToMyAccts : function(component, event, helper) {
		helper.goToMyAccounts(component, event, helper);
	},

	selectScheme : function(component, event, helper) {
		helper.setAPAAgents(component, event, helper);
	},

	selectAgent : function(component, event, helper) {
		helper.setSelectedAgent(component, event, helper);
	},

	validateDetails : function(component, event, helper) {
		helper.validateRequiredFields(component, event, helper);
        //helper.testAttachment(component, event, helper);
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

    //START CSM-13099 - RReyes OCT-11-17 download form
    ,downloadForm: function(component, event, helper) {
    	var clickedLink = event.target.id;
	    if(clickedLink == 'autoDebitBtn'){
			helper.downloadAutoDebitForm(component, event, helper);
		}else if(clickedLink == 'autoChargeBtn'){
			helper.downloadAutoChargeForm(component, event, helper);
		}
    }
    //END CSM-13099 - RReyes OCT-11-17 download form
    //START CSM-13114 RReyes OCT-13-17 - file uploader
    ,selectFile : function(component, event, helper) {
		helper.addFileToList(component, event, helper);        
	},

    deleteFile : function(component, event, helper) {
        helper.removeFileFromList(component, event, helper);
	}
	//END CSM-13114 RReyes OCT-13-17 - file uploader
})