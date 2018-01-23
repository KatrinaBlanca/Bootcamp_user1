({
	hideModal : function(component, event, helper) {
		component.set("v.popUpModalChild", null);
		//START CSM-13209 RReyes OCT-05-17
		var srcPg = component.get("v.sourcePage");
		if(srcPg == 'autopayunsub'){
			component.set("v.isClickProceed", true);
		}
		//END CSM-13209 RReyes OCT-05-17

		//START CSM-13094 RReyes OCT-09-17
		if(srcPg == 'autopayenroll'){
			component.set("v.isClickProceed", true);
		}
		//END CSM-13094 RReyes OCT-09-17
	}
})