({
	//START R2C CSM-13274 Shayne 10/17/2017
     doInit: function(component, event, helper) {
         console.log('init config');
        helper.initializeCheckConglomerate(component, event);
     }
    //END R2C CSM-13274 Shayne 10/17/2017
})