({
	//START R2C CSM-13274 Shayne 10/17/2017 
    initializeCheckConglomerate : function(component, event) {
        console.log('initializeCheckConglomerate');
       var action = component.get("c.checkIfConglomerateAccount");
        
        action.setCallback(this,function(response){             
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('initializeCheckConglomerate state ' + state +' and result '+result);
            if(state === "SUCCESS"){
                var page_name = (result === true) ? 'conglodashboard' : 'dashboard';
                console.log('page_name '+page_name);
                component.set('v.page',page_name);
                 var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                + location.pathname.split('/')[1] + '/' 
                + location.pathname.split('/')[2] + '/'+page_name;
          
              // window.location.assign(pageUrl);
            }
        });  
        $A.enqueueAction(action);
       
    }
    //END R2C CSM-13274 Shayne 10/17/2017 
})