({
	/*
    openPaperless : function(component, event, helper) {
        var setEvent = component.getEvent("setAttribute");
        setEvent.setParams({"attributeValue":'true'});
        setEvent.fire()
	}
    */

    viewBills : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/mybills'; //CSM-13906 Lisen 20171014 : change from view Paperless to viewBills
        window.location.assign(pageUrl);
    }

})