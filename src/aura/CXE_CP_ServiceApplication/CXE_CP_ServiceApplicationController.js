({
    doInit : function(component, event, helper){
        helper.initializeCase(component, event, helper);    
    },

    toggleSwitch : function(component, event, helper){
        //get data-aura-id of event Source
        var auraId = event.currentTarget.dataset.auraId;
		
        //find the element with data-aura-id
        var accordToggle = component.find(auraId).getElement();
       
        accordToggle.classList.toggle("active");
        var panel = accordToggle.nextElementSibling;
        if (panel.style.maxHeight){
            panel.style.maxHeight = null;
        } else {
            panel.style.maxHeight = panel.scrollHeight + "px";
        }        
    },

    onClickStopServiceIndividual : function(component, event, helper){
        // component.set();
        component.set("v.persona", "Individual");
        helper.setApplicationToIndividual(component, event, helper);
        helper.showStopService(component, event, helper);
    },

    onClickReactivateIndividual : function(component, event, helper){
        component.set("v.SAType", "IndRecontract");
        helper.setApplicationToIndividual(component, event, helper);
        helper.showReactivateService(component, event, helper);
        // helper.goToRegistration(component, event, helper);
    },

    onClickReactivateBiz : function(component, event, helper){
        // component.set();
        component.set("v.SAType", "BizRecontract");
        helper.setApplicationToBiz(component, event, helper);
        helper.showReactivateService(component, event, helper);
    },
    onClickStopServiceBiz : function(component, event, helper){
        // component.set();
        component.set("v.persona", "Biz");
        helper.setApplicationToBiz(component, event, helper);
        helper.showStopService(component, event, helper);
    },
    onClickModifyIndividual : function(component, event, helper){
        component.set("v.persona", "Individual");
        helper.setApplicationToIndividual(component, event, helper);
        helper.showModifyService(component, event, helper);
    },

    onClickModifyBiz : function(component, event, helper){
        component.set("v.persona", "Biz");
        helper.setApplicationToBiz(component, event, helper);
        helper.showModifyService(component, event, helper);
    },

    onClickStartBiz : function(component, event, helper){
        component.set("v.persona", "Biz");
        helper.setApplicationToBiz(component, event, helper);
        helper.showStartAService(component, event, helper);
    },
    
    redirectToRegistration : function(component, event, helper){
        helper.goToRegistration(component, event, helper);
    },

    onClickStartContractor : function(component, event, helper){
        component.set("v.persona", "Contractor");
        //helper.setApplicationToBiz(component, event, helper);
        helper.showStartAServiceContractor(component, event, helper);
    },
    
	 onClickModifyContractor : function(component, event, helper){
        component.set("v.persona", "Contractor");
        //helper.setApplicationToBiz(component, event, helper);
        helper.showModifyServiceContractor(component, event, helper);
    },
    
     onClickReactivateContractor : function(component, event, helper){
        component.set("v.persona", "Contractor");
        //helper.setApplicationToBiz(component, event, helper);
        helper.showReactivateServiceContractor(component, event, helper);
    },
    
    
    onClickStopServiceContractor : function(component, event, helper){
        // component.set();
        component.set("v.persona", "Contractor");
        //helper.setApplicationToIndividual(component, event, helper);
        helper.showStopServiceContractor(component, event, helper);
    },
    // START CSM-14333 Jerome To 11/21/2017 As a customer, I should be able to go back to the previous pages I navigated through the clickable breadcrumbs displayed on the left portion of the screen below the tabs.
    doneRendering : function(component, event, helper){
        if(!component.get("v.isDoneRendering")){
            component.set("v.isDoneRendering", true);
        }
    },
    
    handleValueChange : function (component, event, helper) {
        if(component.get("v.isDoneRendering")){
            console.log("old value: " + event.getParam("oldValue"));
            console.log("current value: " + event.getParam("value"));
            helper.togglePersonaAccordion(component, event, helper);        
        }
    }
    // END CSM-14333 Jerome To 11/21/2017 As a customer, I should be able to go back to the previous pages I navigated through the clickable breadcrumbs displayed on the left portion of the screen below the tabs.
})