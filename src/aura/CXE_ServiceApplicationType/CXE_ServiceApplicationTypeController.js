({    
        
	onSelect : function(component, event, helper) {
        var caseRec = component.get("v.caseApplication");
		var selected = event.getSource().get("v.text");        
        
        if(selected == "Residential") {
            caseRec.Application_for_Residential_Service__c = true;
            caseRec.Application_for_Business_Service__c = false;
        } else {
            caseRec.Application_for_Business_Service__c = true;
            caseRec.Application_for_Residential_Service__c = false;
        }
        
        component.set("v.caseApplication", caseRec);
	},
    
    proceed : function(component, event, helper) {
		var caseRec = component.get("v.caseApplication");
        
        
        
        var evt = $A.get("e.c:CaseComponent");
        evt.setParams({ "caseApplicationEvt": caseRec});
        evt.fire();
        
        var cmpHide = "CXE_ServiceApplicationType";
        var evtHide = $A.get("e.c:HideTargetComponentEvent");
        evtHide.setParams({ "hideCmpTarget": cmpHide});
        evtHide.fire();
        
        
        var cmpShow = "";
        if(caseRec.Application_for_Residential_Service__c) {
            cmpShow = "CXE_ServiceApplicationResidential";
        } else {
            cmpShow = "CXE_ServiceApplicationBusiness";
        }
        var evtShow = $A.get("e.c:ShowTargetComponentEvent");
        evtShow.setParams({ "showCmpTarget": cmpShow});
        evtShow.fire();
        
        //helper.showHideComponent(component, hideCmpN,showCmp);       
	}
})