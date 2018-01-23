({
    
    onSubmit : function(component, event, helper) {
    	// var childCmp = component.find("termsAndConditions");
    	// alert(childCmp);
    	// childCmp.isValidFileSize();
    	// var isValid = component.get("v.isValidFileSize");
    	// if(isValid) {
    		helper.submitTerminate(component, event, helper);
    	// }
    },

    onCheck: function(component, event, helper) {
        var cmpBtn = component.find("terminateSubmitBtn");
        cmpBtn.set("v.disabled",!event.getSource().get("v.value"));
    }

})