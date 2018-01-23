({
    
    notifSetCancel : function(component, event, helper) {
        
        helper.notifSetCancelHelper(component, event, helper);
        
    },
     
    onClickUpdateNotif : function(component, event, helper) {
        helper.onClickUpdateNotifHelper(component, event, helper);
    },
    
    doInit : function(component, event, helper){
        helper.onInit(component);
    }
})