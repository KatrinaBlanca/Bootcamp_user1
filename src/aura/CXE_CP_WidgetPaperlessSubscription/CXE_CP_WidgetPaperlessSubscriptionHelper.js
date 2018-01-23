({
	 goToAutopayenroll : function(component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/paperlessbilling';
        window.location.assign(pageUrl);
    }
})