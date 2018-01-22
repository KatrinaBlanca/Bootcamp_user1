({
	//START R2C CSM-13274 Shayne 10/16/2017
     doInit: function(component, event, helper) {
         var message= $A.get("$Label.c.CONGLOMERATE_ERROR_PAGE");
         component.set('v.message', message);
     }
    //START R2C CSM-13274 Shayne 10/16/2017
})