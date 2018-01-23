({
	 doInit : function(component, event, helper) {
        helper.getAccountIdofCurrentUser(component, event);
        helper.hideInfoIncompleteNotif(component, event, helper); //R2C CSM-14832 Shayne 12/07/2017
    },
    
     redirectToBills : function (component, event, helper){
        helper.goToBills(component, event, helper);
    },

    redirectToProfile : function (component, event, helper){
        helper.goToProfile(component, event, helper);
    },

    redirectToMyAccounts : function (component, event, helper){
        helper.goToMyAccounts(component, event, helper);
    },
    
    redirectToStartService : function (component, event, helper){
        helper.goToStartService(component, event, helper);
    },
    
    //START R2C CSM-14832 Shayne 12/07/2017
     hideCmp : function (component, event, helper){
        var auraId = component.find('incProfNotif');
        $A.util.addClass(auraId, 'slds-hide');
    },
    //END R2C CSM-14832 Shayne 12/07/2017
})