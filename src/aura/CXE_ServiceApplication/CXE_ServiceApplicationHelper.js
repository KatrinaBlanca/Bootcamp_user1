({
	showHideComponent: function(cmp, cmpTargetAuraId) {
        var cmpTarget = cmp.find(cmpTargetAuraId);
        $A.util.toggleClass(cmpTarget, 'slds-hide');        
    },
    
    toggleCollapse : function(component, event, secId) {
        var acc = component.find(secId);
        $A.util.toggleClass(acc, "show");
        $A.util.toggleClass(acc, "hide");
    },

    displayToastErrorComponentUnavailable : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"title": "Oops!",
                              "message": "This feature is not yet available.",
                              "type": "error",
                              "duration" : 8000
        });
        toastEvent.fire();
    }
})