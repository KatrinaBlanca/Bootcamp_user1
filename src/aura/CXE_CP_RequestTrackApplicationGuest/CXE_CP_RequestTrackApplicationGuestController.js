({
	onSubmit : function(component, event, helper) {
		helper.getHistory(component, event, helper)
	},

	checkCaseHistory : function(component, event, helper) {
		var eventValue = event.getParam("hasCaseHistory");
		// component.set("v.hasCaseHistory", eventValue);
		if(eventValue) {
			helper.toggleCmp(component, "submitForm");
			helper.toggleCmp(component, "CXE_CP_RequestTrackApplicationDetail");
		}
	}
})