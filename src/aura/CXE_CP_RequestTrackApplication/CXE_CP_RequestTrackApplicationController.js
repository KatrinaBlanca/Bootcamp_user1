({
    doInit : function(component, event, helper) {
        helper.getCaseList(component, event, helper);
    },
    
    onClickCaseNumber : function(component, event, helper) {
        helper.getCaseHistory(component, event, helper);
    },
    //START Breadcrumb-task GSerrano SEPT-25-17
    redirectToHome : function (component, event, helper){
        helper.goToHome(component, event, helper);
    },
    redirectToRequests : function (component, event, helper){
        helper.goToRequests(component, event, helper);
    }
    // START CSM-13944 JRances / UAT, 'Request for a New Service' link in the Requests page is not working.
    , redirectToStartServiceForm : function (component, event, helper) {
        helper.goToStartServiceForm(component, event, helper);
    },
    // END CSM-13944 JRances
    
    //END Breadcrumb-task GSerrano SEPT-25-17
    //START CSM-14015 GGrandea 10.20.2017
    redirectToPBPage : function(component, event, helper) {
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
            + location.pathname.split('/')[1] + '/'
            + location.pathname.split('/')[2] + '/paperlessbilling';
        window.location.assign(pageUrl);
    } 
    //END CSM-14015 GGrandea 10.20.2017
})