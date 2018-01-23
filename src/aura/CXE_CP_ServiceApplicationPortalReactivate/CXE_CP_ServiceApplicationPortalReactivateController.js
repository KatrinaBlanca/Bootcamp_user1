({
    initCase : function(component) {
        var self = this;

        var initAction = component.get("c.newPortalCase");
        initAction.setCallback(self, function(a) {
            component.set("v.caseVar", a.getReturnValue());
            
        });
        $A.enqueueAction(initAction);
    }
})