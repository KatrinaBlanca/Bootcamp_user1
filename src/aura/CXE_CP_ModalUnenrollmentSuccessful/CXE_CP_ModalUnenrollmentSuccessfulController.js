({
	navToHome : function (component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/dashboard"
        });
        urlEvent.fire();
    }
})