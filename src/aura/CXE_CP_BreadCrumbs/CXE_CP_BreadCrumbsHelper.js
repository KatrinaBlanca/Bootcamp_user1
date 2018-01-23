({
	initiateBreadcrumbs : function(component, event, helper) {

		var sURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sURL.split("&");
        var sParamNameAndValue, sParameterName, i, sParameterValue;
        var sourcePages = component.get("v.sourcePages");
        var currentPage = window.location.pathname.split("/")[3];

        for (i = 0; i < sURLVariables.length; i++) {    
            sParamNameAndValue = sURLVariables[i].split("=");
            sParameterName = sParamNameAndValue[0];
            if(sParameterName === "bCrumbs") {
                sParameterValue = sParamNameAndValue[1];
            }
        }

        if(sParameterValue || sourcePages) {
        	var action = component.get("c.getBreadCrumbs");
        	action.setParams({
	            "breadCrumbStringList": sParameterValue,
	            "sourcePages": sourcePages
	        });  
	        action.setCallback(this, function(a){
	        	var rtnValue = a.getReturnValue();
	        	console.log("rtnValue");

	        	console.log(rtnValue);
	            if (rtnValue !== null) {
	                component.set("v.breadCrumbs",rtnValue);
	            }
	        });
	        $A.enqueueAction(action);
        }        
	},

	goToPage : function(component, event, helper) {
		var targetPage = event.target.id;
		console.log("targetPage" + targetPage);
		var pageUrl = window.location.protocol + "//" + window.location.hostname + "/"
				       + window.location.pathname.split("/")[1] + "/"
				       + window.location.pathname.split("/")[2] + "/"
				       + ((targetPage)? targetPage : window.location.pathname.split("/")[3]);
		window.location.assign(pageUrl);
	}

})