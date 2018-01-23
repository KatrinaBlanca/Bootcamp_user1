({
    //Start CSM-13084 of Rabayon 10/05/17
	 redirectToEnrollAutoPayment: function (component, event, helper){
	 	//START R2C CSM-14581 Shayne 12/06/2017 modal for conglo user
		if(component.get("v.isConglomerate")){
			var message= $A.get("$Label.c.CONGLOMERATE_ERROR_PAGE");
			component.set('v.congloMessage', message);
			component.set('v.isCongloModal', true);
		}
		else{
        	helper.goToAutopayenroll(component, event, helper);
    	}
    	//END R2C CSM-14581 Shayne 12/06/2017
    },
    //End CSM-13084 of Rabayon 10/05/17
})