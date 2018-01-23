({
	getSalutations : function (component, event, helper) {
        var action = component.get("c.getSalutations");
        var inputsel = component.find("salutations");
        var opts=[];
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){                
                for(var i=0;i< a.getReturnValue().length;i++){
                    opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
                }
                inputsel.set("v.options", opts);
            }  
        });
        $A.enqueueAction(action); 
    },
    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');          
	}
})