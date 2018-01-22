({
	/*OpenMiniAddsBillDashNoti  : function (component, event, helper){
        
        var action = component.get("c.MiniAddsBillDashNoti");
        action.setCallback(this, function(response){
           
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    }*/
    
    openProfile : function(component, event, helper) {
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/profile?notif=true';

        window.location.assign(pageUrl);
    }
    
})