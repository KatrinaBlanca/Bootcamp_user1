({
	getHistory : function(component, event, helper) {
		var appHistoryCmp = component.find("appHistory");
		appHistoryCmp.submit(component.get("v.lastname"), component.get("v.referenceNumber"));
	},

    toggleCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.toggleClass(cmpTarget, 'slds-hide');
        $A.util.toggleClass(cmpTarget, 'slds-show');
    }
})