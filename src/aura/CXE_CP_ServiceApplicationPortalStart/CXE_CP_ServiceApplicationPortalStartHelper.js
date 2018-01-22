({
	// START CSM-14333 Jerome To 11/21/2017 As a customer, I should be able to go back to the previous pages I navigated through the clickable breadcrumbs displayed on the left portion of the screen below the tabs.
    toggleBreadCrumbsDisplay : function(component, event, helper){
        var sURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sURL.split("&");
        var sParamNameAndValue, sParameterName, i, sParameterValue;

        for (i = 0; i < sURLVariables.length; i++) {   
            sParamNameAndValue = sURLVariables[i].split("=");
            sParameterName = sParamNameAndValue[0];
            if(sParameterName === "previousPage") {
                sParameterValue = sParamNameAndValue[1];
            }
        }

        if(sParameterValue) {
        	component.set("v.prevPage",sParameterValue);
        }        
    }
    // END CSM-14333 Jerome To 11/21/2017 As a customer, I should be able to go back to the previous pages I navigated through the clickable breadcrumbs displayed on the left portion of the screen below the tabs.
})