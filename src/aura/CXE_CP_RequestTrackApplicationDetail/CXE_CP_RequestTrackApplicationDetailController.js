({
    // getCaseHistory : function(component, event, helper) {
    // 	helper.getTransactionDetails(component, event, helper);
    // }
    //START Breadcrumb-task GSerrano SEPT-25-17
    redirectToHome : function (component, event, helper){
        helper.goToHome(component, event, helper);
    },
    redirectToRequests : function (component, event, helper){
        helper.goToRequests(component, event, helper);
    }
    //END Breadcrumb-task GSerrano SEPT-25-17
})