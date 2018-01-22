({
    displayTab3 : function(component, event, helper) {        
        var tabName = "3";
        helper.pushEvent(component, tabName);
    },

    pushEvent : function (component, tabName) {
        var setEvent = component.getEvent("changeTabUsingButtonEvent");
        setEvent.setParams({
            "param1" : tabName
        });
        setEvent.fire();
    }
})