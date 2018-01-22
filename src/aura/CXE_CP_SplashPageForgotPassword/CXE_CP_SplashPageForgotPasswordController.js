({
    forgotPassword : function(component, event, helper) {
	    helper.sendPasswordReset(component, event, helper);
    },
    
    forgotPasswordCancel : function(component, event, helper) {
	    helper.cancelPasswordReset(component, event, helper);
    },
    
    //[20170915 - Joebhelle Rances]
    //Adding code for Enter function - send email
    //CSM 12590 - forgot password
    pressEnter : function(component, event, helper) {
        if (event.keyCode === 13) {
            console.log('Enter key is pressed.');
            helper.sendPasswordReset(component, event, helper);
        }
    }
    //End CSM 12590
})