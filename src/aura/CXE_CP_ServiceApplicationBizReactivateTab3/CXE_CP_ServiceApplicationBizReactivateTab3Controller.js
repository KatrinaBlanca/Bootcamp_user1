({
    enableSubmitBtn : function(component, event, helper) {
        
        var yes =document.getElementById("agreeChkbx").checked; 
        
        if(yes == true){
            
            component.find("termsACBtn").set("v.disabled", false); 
            
        } else {
            
            component.find("termsACBtn").set("v.disabled", true); 
            
        }
    },

    onSubmit : function(component, event, helper) {
        helper.submitRecontract(component, event, helper);
    }
})