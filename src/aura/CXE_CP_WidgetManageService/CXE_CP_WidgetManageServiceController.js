({
	manageServiceLink : function(component, event, helper) {
		//START R2C CSM-14581 Shayne 12/06/2017 modal for conglo user
		if(component.get("v.isConglomerate")){
			var message= $A.get("$Label.c.CONGLOMERATE_ERROR_PAGE");
			component.set('v.congloMessage', message);
			component.set('v.isCongloModal', true);
		}else{
			var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/manageservice';
            window.location.assign(pageUrl);
        }
        //END R2C CSM-14581 Shayne 12/06/2017
	}
})