({
	submitTab : function(component, event, helper) {
		//need validation
		//submitForm
        console.log(' >>>>>>>>>>>>>>>>>>>>>>>>>>> submitTab3: ');
		
        helper.submitModification(component, event, helper);
	},
    
    enableSubmitBtn : function(component, event, helper) {
        
        var yes =document.getElementById("checkbox-2").checked; 
        
        if(yes == true){           
            component.find("termsACBtn").set("v.disabled", false);           
        } else {        
            component.find("termsACBtn").set("v.disabled", true);    
        } 
        
    }
})