({
    //START CSM-14050 GGrandea 10.23.2017
    doInit : function(component, event, helper) {
        helper.termsAndConditionsLinkHelper(component, event, helper);
    },
    //END CSM-14050

    onClickRegister : function(component, event, helper) {
        helper.submit(component, event, helper);
    },

    onClickNewOrExisting : function(component, event, helper) {
        var selected = component.find("cmp_newService").getElement().checked;
        component.set("v.isNew", selected);
        
        var elements = component.find("signupToggleBox").getElement().childNodes;
        console.log("elements.length: " + elements.length);
        for (var i=0; i<elements.length; i++) {
            console.log(elements[i].outerHTML);
            var inputDateCmp = document.getElementsByClassName("mov-input_date");
            console.log(inputDateCmp.length);
        }
	},
	
     setPlaceholder : function(component, event, helper) {
        var dtPlchldr=component.find('inputDate');
        dtPlchldr.set('v.placeholder','Bill Date');
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
    },
    
    termsAndConditionsLink: function (component, event, helper) {
        helper.termsAndConditionsLinkHelper(component, event, helper);  
    },
    
    //----Mike Verdad 8/22/2017 - For Terms and conditions ----//
    changeboxChange : function(component, event, helper) {
       helper.changeboxChangeHelper(component, event, helper);
    },
    
    showTerms : function(component, event, helper) {       
        helper.showTermsHelper(component, event, helper);
    }, 
    
    EventFire : function (component, event, helper){
        helper.EventFireHelper(component, event, helper);
    }   
    //-- end of Mike Verdad 8/22/2017 - For Terms and conditions -- //
    
})