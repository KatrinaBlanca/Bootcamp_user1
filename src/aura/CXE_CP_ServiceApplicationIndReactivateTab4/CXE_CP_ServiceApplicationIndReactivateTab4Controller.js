({
    // initCase : function(component) {
    //     var self = this;

    //     var initAction = component.get("c.initNewCase");
    //     initAction.setCallback(self, function(a) {
    //         component.set("v.caseRecord", a.getReturnValue());
    //     });
    //     $A.enqueueAction(initAction);
    // },
    
    onSubmit : function(component, event, helper) {
        helper.submitRecontract(component, event, helper);
    },

    enableSubmitBtn : function(component, event, helper) {
        
        var yes =document.getElementById("agreeChkbx").checked; 
        
        if(yes == true){           
            component.find("termsACBtn").set("v.disabled", false);           
        } else {        
            component.find("termsACBtn").set("v.disabled", true);    
        }
    }   
    
})