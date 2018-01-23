({
	initializeConglomerateDetails : function(component, event) {
        var account_id =  component.get("v.AccountId");
        console.log('initializeConglomerateDetails '+account_id);
        var action = component.get("c.retrieveConglomerateDetails");
        action.setParams({"account_id":account_id});
        action.setCallback(this,function(response){ 
            var setEvent = component.getEvent("setLoader");
            setEvent.setParams({"loader":'success'});
            setEvent.fire();
            
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('initializeConglomerateDetails state' + state +' and result '+result); //CSM-CSM-14396 Shayne 11-10-2017
            
            //START CSM-14726 Shayne 11/28/2017 Added error message
            var message= $A.get("$Label.c.CONGLOMERATE_PROCESSING_MESSAGE");
            if(state === "SUCCESS"){
                console.log('>>>>>>> '+result.totalRecord);
                console.log('>>>>>>> '+result.accountName);
                if(result.totalRecord === undefined){ 
        			component.set('v.ongoingProcessMessage', message);
                }
                component.set('v.conglomerateRecords', result.conglomerateRecords);
                component.set('v.AccountName', result.accountName);
                component.set('v.TotalNumberOfServices', result.totalServices);
                component.set('v.TotalRecord', result.totalRecord);
               // component.set('v.AccountId', result);
            }else{
                component.set('v.ongoingProcessMessage', message);
            }
            //END CSM-14726 Shayne 11/28/2017

        });  
        $A.enqueueAction(action); 
    },
})