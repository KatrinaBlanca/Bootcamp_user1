({
    //IPenaflor 10/18/2017 CSM-13887
	goToConsumption : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/consumptionreport';
        window.location.assign(pageUrl);
    }
})