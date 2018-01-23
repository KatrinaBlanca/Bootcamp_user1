({
	doInit : function(component, event, helper) {
        var action = component.get("c.UpdateAutoEnrollment");  
      
        action.setCallback(this, function(response) {
			
            console.log(response.getReturnValue().Email2);
		      
            component.set("v.userEmail", response.getReturnValue().Email);
           
            component.set("v.MobilePhone", response.getReturnValue().MobilePhone);
            component.set("v.LastName", response.getReturnValue().LastName);
            component.set("v.FirstName", response.getReturnValue().FirstName);
            component.set("v.MiddleName", response.getReturnValue().MiddleName);
            component.set("v.Phone", response.getReturnValue().Phone);
            component.set("v.Suffix", response.getReturnValue().Suffix);
            
           
           	component.set("v.Birthdate", response.getReturnValue().Birthdate);
            component.set("v.Mobile1", response.getReturnValue().Mobile1);
             component.set("v.Mobile2", response.getReturnValue().Mobile2);
             component.set("v.FName", response.getReturnValue().FName);
            //alert("Bday: " + response.getReturnValue().Birthdate);

            component.set("v.contactDetails", response.getReturnValue());
 
        });
        $A.enqueueAction(action);
    },
    doInit2 : function(component, event, helper){
        helper.onInit(component);
    }
})