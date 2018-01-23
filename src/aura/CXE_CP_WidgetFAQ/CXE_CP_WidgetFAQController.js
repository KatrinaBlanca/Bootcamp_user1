({
    /* START -   CSM-13885 11/16/17 JANAH INTAL
	 OpenMiniAddsOnlineBillingFAQs  : function (component, event, helper){
        
        var action = component.get("c.MiniAddsOnlineBillingFAQs");
        action.setCallback(this, function(response){
           
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    }
    */

    myAction : function(component, event, helper) {
		
	},
    
    openFAQs : function(component, event, helper) {
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/topiccatalog';
        window.location.assign(pageUrl);
    }
    /** END  -   CSM-13885 11/16/17 JANAH INTAL **/
})