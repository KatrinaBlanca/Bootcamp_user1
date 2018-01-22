({
	initializeCase : function(component, event, helper) {
        var initAction = component.get("c.initNewCase");
        initAction.setCallback(self, function(a) {
            component.set("v.caseRecord", a.getReturnValue());
        });
        $A.enqueueAction(initAction);
    }
})