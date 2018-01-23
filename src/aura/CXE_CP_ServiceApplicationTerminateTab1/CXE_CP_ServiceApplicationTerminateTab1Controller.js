({
    submitFormOnTab1 : function(component, event, helper) {
        //nothing to validate
        helper.submitTermination(component, event, helper);
    },
        
    goToMyAccounts : function (component, event, helper){
        var home = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/myaccounts';
        window.location.assign(home);     
    }
})