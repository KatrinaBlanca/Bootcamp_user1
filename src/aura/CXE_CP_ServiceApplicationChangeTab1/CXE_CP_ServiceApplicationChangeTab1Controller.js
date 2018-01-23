({
	submitTab : function(component, event, helper) {

        console.log(' >>>>>>>>>>>>>>>>>>>>>>>>>>> submitTab1: ');
		//need validation
		var servReq = component.get("v.caseRecord.CXE_Service_Request_s__c");
        if(servReq){
            var setEvent = component.getEvent("callTabEvent");
            setEvent.setParams({"param1":2});
            setEvent.fire();
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({"title": "Please check your input.",
                                  "message": "Please select a service modification.",
                                  "type": "error",
                                  "duration" : 6000
                                 });
            toastEvent.fire();
        }
	},
    
    onServiceRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseRecord.CXE_Service_Request_s__c", selected);
        console.log(component.get("v.caseRecord.CXE_Service_Request_s__c"));
    },

    onSelectRequestType : function(component, event, helper) {
        var isServiceMod = component.find("isServiceModification").getElement().checked;
        // if(isServiceMod) {
        //     helper.showCmp(component, "amcNotif");
        // } else {
        //     helper.hideCmp(component, "amcNotif");
        // }
        component.set("v.changeService", isServiceMod);
        component.set("v.showRequestOptions", true);
    }
})