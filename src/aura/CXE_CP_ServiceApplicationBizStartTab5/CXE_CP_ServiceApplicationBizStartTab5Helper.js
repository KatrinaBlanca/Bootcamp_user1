({
	goToHomePage : function(component, event, helper) {
        var pageUrl = window.location.href;
		var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": pageUrl
        });
        urlEvent.fire();	
	}
})