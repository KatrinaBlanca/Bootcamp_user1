({
	hideModal : function(component, event, helper) {
        component.set("v.getValue", false);
    },

    hide : function(component, event, helper) {
        component.set("v.hasClickOnOtherTab", false);
    },
    
    // START CSM-14554 Jerome To 11/20/2017 Prompt that the user can edit the profile information but it doesn’t tell where the user can edit it.
    discardChange : function(component, event, helper) {
        
        //START CSM-14556 R2B Retrofit
        var pageUrl = window.location.protocol + "//" + window.location.hostname + "/"
        + window.location.pathname.split("/")[1] + "/"
        + window.location.pathname.split("/")[2] + "/profile";
        window.history.pushState("", "", pageUrl);
        window.location.assign(pageUrl);
        //END CSM-14556 R2B Retrofit
        //
         /*
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/profile"
        });
        urlEvent.fire();
       
        var sURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sURL.split("&");
        var sParamNameAndValue, sParameterName, i, sParameterValue;

        for (i = 0; i < sURLVariables.length; i++) {    
            sParamNameAndValue = sURLVariables[i].split("=");
            sParameterName = sParamNameAndValue[0];
            if(sParameterName === "getInfo") {
                sParameterValue = sParamNameAndValue[1];
            }
        }

            */
        
    }
    // END CSM-14554 Jerome To 11/20/2017 Prompt that the user can edit the profile information but it doesn’t tell where the user can edit it.
})