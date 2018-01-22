({
/*
    initCase : function(component) {
        var self = this;

        var initAction = component.get("c.initNewCase");
        initAction.setCallback(self, function(a) {
            component.set("v.caseVar", a.getReturnValue());
        });
        $A.enqueueAction(initAction);
    },
*/
    initCase : function(component) {
        var self = this;

        var initAction = component.get("c.newPortalCase");
        initAction.setCallback(self, function(a) {
            component.set("v.caseVar", a.getReturnValue());
            
        });
        $A.enqueueAction(initAction);

        var personaAction = component.get("c.getPersona");
        personaAction.setCallback(self, function(a) {
            component.set("v.persona", a.getReturnValue());
            
        });
        $A.enqueueAction(personaAction);
    }

    // START CSM-14333 Jerome To 11/21/2017 As a customer, I should be able to go back to the previous pages I navigated through the clickable breadcrumbs displayed on the left portion of the screen below the tabs.
    ,doneRendering : function(component, event, helper){
        if(!component.get("v.isDoneRendering")){
            component.set("v.isDoneRendering", true);
        }
    },
    
    handleValueChange : function (component, event, helper) {
        if(component.get("v.isDoneRendering")){
            helper.toggleBreadCrumbsDisplay(component, event, helper);        
        }
    }
    // END CSM-14333 Jerome To 11/21/2017 As a customer, I should be able to go back to the previous pages I navigated through the clickable breadcrumbs displayed on the left portion of the screen below the tabs.

})