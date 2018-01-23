({
    doInit: function(component, event, helper) {
    // var caseRec = component.get("v.caseApplication",true);
    },
    selectIndividual : function(component, event, helper) {
        helper.toggleCollapse(component,event,'individualOptions');
    }, 
    selectBusiness : function(component, event, helper) {
        helper.toggleCollapse(component,event,'businessOptions');
    },
    selectContractor : function(component, event, helper) {
        helper.toggleCollapse(component,event,'contractorOptions');
    },
	// showComponent: function(cmp, event, helper) {  
     //var cmpTarget = cmp.find(event.getParam("showCmpTarget"));
     //helper.showHideComponent(cmp, cmpTarget);
     //    },
     //    hideComponent: function(cmp, event, helper) { 
     //var cmpTarget = cmp.find(event.getParam("hideCmpTarget"));
     //helper.showHideComponent(cmp, cmpTarget);
     //    },
     //    getCaseApplicationInput : function(cmp, event) {
     //var resultValue = event.getParam("caseApplicationEvt");
     //cmp.set("v.caseApplication", resultValue);
     //    },
     //    getCaseNumber : function(component, event, helper) {
     //var resultValue = event.getParam("caseNumber");
     //component.set("v.caseNumber", resultValue);
 //    },
    modifyIndividual : function(component, event, helper) {
        component.set("v.persona", "Individual");
        helper.showHideComponent(component, "CXE_ServiceApplicationOption");
        helper.showHideComponent(component, "CXE_ServiceApplicationModification");
    },
    modifyBusiness : function(component, event, helper) {
        component.set("v.persona", "Business");
        helper.showHideComponent(component, "CXE_ServiceApplicationOption");
        helper.showHideComponent(component, "CXE_ServiceApplicationModification");
    },
    modifyContractor : function(component, event, helper) {
        helper.displayToastErrorComponentUnavailable(component, event, helper);
        // component.set("v.persona", "Contractor");
        // helper.showHideComponent(component, "CXE_ServiceApplicationOption");
        // helper.showHideComponent(component, "CXE_ServiceApplicationModification");
    },
    
    terminateIndividual : function(component, event, helper) {
        component.set("v.persona", "Individual");
        helper.showHideComponent(component, "CXE_ServiceApplicationOption");
        helper.showHideComponent(component, "CXE_ServiceApplicationTermination");
    },
    terminateBusiness : function(component, event, helper) {
        component.set("v.persona", "Business");
        helper.showHideComponent(component, "CXE_ServiceApplicationOption");
        helper.showHideComponent(component, "CXE_ServiceApplicationTermination");
    },
    terminateContractor : function(component, event, helper) {
        helper.displayToastErrorComponentUnavailable(component, event, helper);
        // component.set("v.persona", "Contractor");
        // helper.showHideComponent(component, "CXE_ServiceApplicationOption");
        // helper.showHideComponent(component, "CXE_ServiceApplicationTermination");
    },

    recontractIndividual : function(component, event, helper) {
        component.set("v.persona", "Individual");
        helper.showHideComponent(component, "CXE_ServiceApplicationOption");
        helper.showHideComponent(component, "CXE_ServiceApplicationRecontract");
    },
    recontractBusiness : function(component, event, helper) {
        component.set("v.persona", "Business");
        helper.showHideComponent(component, "CXE_ServiceApplicationOption");
        helper.showHideComponent(component, "CXE_ServiceApplicationRecontract");
    },
    recontractContractor : function(component, event, helper) {
        helper.displayToastErrorComponentUnavailable(component, event, helper);
        // component.set("v.persona", "Contractor");
        // helper.showHideComponent(component, "CXE_ServiceApplicationOption");
        // helper.showHideComponent(component, "CXE_ServiceApplicationRecontract");
    },

    newIndividual : function(component, event, helper) {
        helper.displayToastErrorComponentUnavailable(component, event, helper);
    },
    
    newBusiness : function(component, event, helper) {
        component.set("v.persona", "Business");
        helper.showHideComponent(component, "CXE_ServiceApplicationOption");
        helper.showHideComponent(component, "CXE_ServiceApplicationNew");
    },

    newContractor : function(component, event, helper) {
        helper.displayToastErrorComponentUnavailable(component, event, helper);
    }
})