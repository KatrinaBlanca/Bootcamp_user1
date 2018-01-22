({

    changePassword : function(component, event, helper) {
        // START CSM-14047 Lisen 20171022
        helper.clearErrorMessageCurrentPassHelper(component, event, helper);
        helper.clearErrorMessageNewPassHelper(component, event, helper);
        helper.clearErrorMessageCfmNewPassHelper(component, event, helper);
        // END CSM-14047 Lisen 20171022

        var isValid = helper.ToggleSubmitPassword(component, event, helper);
        if(isValid==true){
            helper.validateMatchHelper(component, event, helper);
        }
    },
  
    validateInput : function(component, event, helper) {
        helper.clearErrorMessageNewPassHelper(component, event, helper); // CSM-14047 LISEN 20171021
        helper.validateInputHelper(component, event, helper);
    },
    
    
    backToHome : function(component, event, helper) {
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/dashboard';
        window.location.assign(pageUrl);
        
    },
    
    clearErrorMessageCurrentPass : function(component, event, helper) {
        helper.clearErrorMessageCurrentPassHelper(component, event, helper);
    },
    
    clearErrorMessageNewPass : function(component, event, helper) {
        helper.clearErrorMessageNewPassHelper(component, event, helper);
    },
    
    clearErrorMessageCfmNewPass : function(component, event, helper) {
        helper.clearErrorMessageCfmNewPassHelper(component, event, helper);
    },
    
})