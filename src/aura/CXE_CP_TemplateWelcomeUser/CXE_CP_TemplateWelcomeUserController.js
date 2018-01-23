({
    doInit : function(component, event, helper) {
        helper.getLoginHistory(component, event, helper);
        helper.getProfilePic(component, event, helper);
    }
    
    /* logout : function(component, event, helper) {
        window.location.replace("/customers/secur/logout.jsp");
    } */
})