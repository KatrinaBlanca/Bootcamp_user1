({
	redirect : function(component, event, helper) {
		var isBackToMobile = component.get("v.isBackToMobile");
        var openApp = component.get("v.openApp");
        console.log('isBackToMobile2 ', isBackToMobile);
        var createEvent = component.getEvent("CXE_CP_LandingModalEvent");
        createEvent.setParams({"isShowModal" : false});
        createEvent.fire();
        
        //window.location = 'intent://landing-page#Intent;package=google-app-package;scheme=mymeralcoapp;end;';
        //window.location = 'mymeralcoapp://landing-page';
        if(openApp == true) window.location.href = 'mymeralcoapp://landing-page';
  }
})