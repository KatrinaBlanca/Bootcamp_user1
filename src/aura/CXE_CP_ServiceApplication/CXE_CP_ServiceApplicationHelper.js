({
	showStartAService : function(component, event, helper){
        helper.showCmp(component, helper, "CXE_CP_ServiceApplicationGuestStart");
    },

    showModifyService : function(component, event, helper){
        helper.showCmp(component, helper, "CXE_CP_ServiceApplicationIndModify");
    },

    showReactivateService : function(component, event, helper){
        helper.showCmp(component, helper, "CXE_CP_ServiceApplicationReactivate");
    },
    
    showStopService : function(component, event, helper){
        helper.showCmp(component, helper, "CXE_CP_ServiceApplicationTerminate");
    },

    showCmp : function(component, helper, auraId){
        helper.toggleCmp(component, "serviceApp");
        helper.toggleCmp(component, auraId);
    },

    toggleCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.toggleClass(cmpTarget, "slds-hide");
        $A.util.toggleClass(cmpTarget, "slds-show");
    },

    initializeCase : function(component, event, helper) {
        var initAction = component.get("c.initNewCase");
        initAction.setCallback(self, function(a) {
            component.set("v.caseRecord", a.getReturnValue());
            console.log(a.getReturnValue());
        });
        $A.enqueueAction(initAction);
    },

    goToRegistration : function (component, event, helper){
        //Rj ---> updated code to this for Redirecting if Guest click Start/Reactivate
        
        var userSelect = event.getSource().getLocalId();
        if(userSelect == 'guestReac'){
            var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/registration' + '?page=reactivateservice';
            window.location.assign(pageUrl);
            
        } else{
            
            var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/registration' + '?page=startservice';
            window.location.assign(pageUrl);
        }
        
		/*
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                            + location.pathname.split('/')[1] + '/' 
                            + location.pathname.split('/')[2] + '/registration';
        
        window.location.assign(pageUrl);  
        */
    },

    setApplicationToBiz : function(component, event, helper) {
        component.set("v.caseRecord.Application_for_Business_Customer__c", true);
        component.set("v.caseRecord.Application_for_Business_Service__c", true);
    },

    setApplicationToIndividual : function(component, event, helper) {
        component.set("v.caseRecord.Application_for_Residential_Customer__c", true);
        component.set("v.caseRecord.Application_for_Residential_Service__c", true);
    },

    showStartAServiceContractor : function(component, event, helper){
        helper.showCmp(component, helper, "CXE_CP_ContractorIndApply");
    },
    
    showModifyServiceContractor : function(component, event, helper){
        helper.showCmp(component, helper, "CXE_CP_ContractorChangeService");
    },
    
    showReactivateServiceContractor : function(component, event, helper){
        helper.showCmp(component, helper, "CXE_CP_ContractorIndReactivate");
    },
    
    showStopServiceContractor : function(component, event, helper){
        helper.showCmp(component, helper, "CXE_CP_ContractorStopService");
    }

    
    // START CSM-14333 Jerome To 11/21/2017 As a customer, I should be able to go back to the previous pages I navigated through the clickable breadcrumbs displayed on the left portion of the screen below the tabs.
    ,togglePersonaAccordion : function(component, event, helper){
        var sURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sURL.split("&");
        var sParamNameAndValue, sParameterName, i, sParameterValue;

        for (i = 0; i < sURLVariables.length; i++) {   
            sParamNameAndValue = sURLVariables[i].split("=");
            sParameterName = sParamNameAndValue[0];
            if(sParameterName === "persona") {
                sParameterValue = sParamNameAndValue[1];
            }
        }

        if(sParameterValue) {
            var auraId = sParameterValue + 'Accordion';
            var accordToggle = component.find(auraId).getElement();
            accordToggle.classList.toggle("active");
            var panel = accordToggle.nextElementSibling;
            if (panel.style.maxHeight){
                panel.style.maxHeight = null;
            } else {
                panel.style.maxHeight = panel.scrollHeight + "px";
            }
        }        
    }
    // END CSM-14333 Jerome To 11/21/2017 As a customer, I should be able to go back to the previous pages I navigated through the clickable breadcrumbs displayed on the left portion of the screen below the tabs.
})