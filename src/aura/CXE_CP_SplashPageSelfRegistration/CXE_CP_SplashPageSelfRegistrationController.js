({
    doInit : function(component, event, helper) {
        helper.privacyPolicyHelper(component, event, helper);
    },

        
    onClickRegister : function(component, event, helper) {
        helper.submit(component, event, helper);
    },

    onClickNewOrExisting : function(component, event, helper) {

        // console.log("*****: " + new Date());

        var currentDate = new Date();
        // var month = currentDate.getMonth() - 1;
        // var months = currentDate.getMonth() - 2;
        console.log(currentDate.setMonth(currentDate.getMonth() - 1));  
        console.log(currentDate.setMonth(currentDate.getMonth() - 2));  
        // console.log(month);
        // console.log(months);
        // console.log("previous month: " + currentDate.setMonth(currentDate.getMonth() - 1));
        // console.log("2 months ago: " + currentDate.setMonth(currentDate.getMonth() - 2));

        var selected = component.find("cmp_newService").getElement().checked;
        component.set("v.isNew", selected);
        
        var elements = component.find("signupToggleBox").getElement().childNodes;
        console.log("elements.length: " + elements.length);
        for (var i=0; i<elements.length; i++) {
            // console.log(elements[i].outerHTML);
            var inputDateCmp = document.getElementsByClassName("mov-input_date");
            // console.log(inputDateCmp.length);
        }
    },
    
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
	
    privacyPolicy: function (component, event, helper) {
        helper.privacyPolicyHelper(component, event, helper);  
    },
    
    //----Mike Verdad 8/22/2017 - For Terms and conditions ----//
   
    //START CSM-13026 JRances - Change implementation to show Terms and Conditions Modal
    changeboxChange : function(component, event, helper) {
        var checkBox = component.find("cmp_termsAndConditions").get("v.value");
        component.set("v.checkBox", checkBox);
        //helper.changeboxChangeHelper(component, event, helper);
    },

    showTerms : function(component, event, helper) {       
        var setEvent = component.getEvent("setTerms");
        var currentCheckbox=component.find('cmp_termsAndConditions').get('v.value');
        setEvent.setParams({"checkBox":currentCheckbox});
        setEvent.fire();
        //helper.showTermsHelper(component, event, helper);
    }, 
    //END CSM-13026 JRances
    
    EventFire : function (component, event, helper){
        helper.EventFireHelper(component, event, helper);
    }
      

    
    
})