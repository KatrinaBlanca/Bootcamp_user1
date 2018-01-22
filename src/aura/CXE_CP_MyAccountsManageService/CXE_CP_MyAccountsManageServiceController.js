({
   	onClickSubmit : function(component, event, helper) {
        helper.submit(component, event, helper);
    },
    
    onClickNewOrExisting : function(component, event, helper) {
        var selected = component.find("cmp_newService").getElement().checked;
        component.set("v.isNew", selected); 
    },
    
    onBlurFieldValidation : function(component, event, helper) {
        var targetAuraId = event.getSource().getLocalId();
        if(targetAuraId === "cmp_servIdNum") {
            if(helper.hasErrorOnFieldList(component, [targetAuraId]) < 1) {
                helper.validateSIN(component, event, helper);
            }
        } else {
            helper.hasErrorOnFieldList(component, [targetAuraId]);
        }
    },

    validate  : function(component, event, helper) {
        var inp = event.getSource().get("v.value");
        if(isNaN(inp)) {            
            event.getSource().set("v.value", inp.substring(0, inp.length - 1));
        }
    }
    
    //START Breadcrumb-task IPenaflor SEPT-25-17
    , redirectToHome : function (component, event, helper){
        helper.goToHome(component, event, helper);
    },
    
    redirectToMyAccounts : function (component, event, helper){
        helper.goToMyAccounts(component, event, helper);
    },

    
    //END Breadcrumb-task IPenaflor SEPT-25-17
    
    //START CSM-13787 JRances - Add placeholder
    removePlaceholder : function(component, event, helper) {
        var transactionDate = component.get("v.transactionDate");

        var cmpTarget = component.find("signupToggleBox");
        if(transactionDate) {
            $A.util.removeClass(cmpTarget, "CXE_placeHolderFix");
            // document.getElementById('signupToggleBox').classList.remove("CXE_placeHolderFix");
        } else {
            $A.util.addClass(cmpTarget, "CXE_placeHolderFix");
            // document.getElementById('signupToggleBox').classList.add("CXE_placeHolderFix");
        }
    },
    //END CSM-13787 JRances
    
    //START R2C CSM-13274 Shayne 10/12/2017
     doInit: function(component, event, helper) {
        helper.initializeCheckConglomerate(component, event);
     }
})