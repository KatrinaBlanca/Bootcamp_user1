({
	//START Breadcrumb-task IPenaflor SEPT-25-17
    goToHome : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/dashboard';
        window.location.assign(pageUrl);
    },
    url_param: function(){
        return window.location.search.substring(1).split('&').map(function(e){
            return e.split('=');
        }).reduce(function(cur, nex){
            cur[nex[0]] = decodeURIComponent(nex[1]);
            return cur;
        }, {})
    },
    
    goToMyBills : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/mybills';
        window.location.assign(pageUrl);
    },
    //END Breadcrumb-task IPenaflor SEPT-25-17
    
    groupBills : function(component,result) {
        
        var myObjectMap = [];
        
        // Loop through results; remember, this is a list of sObjects
        for(var i=0; i<result.length; i++) {                
            // Get the record
            var myRecord = result[i];
            
            if(myRecord.payStatus != 'Cancelled'){ //CSM-14404
                // Pull out the field that's going to be my key
                var myKey = myRecord.acctNum; //CSM-14404
                // Keep track of whether our key already exists in myObjectMap
                var found = false;
                // Loop through our map and see if an entry for our key exists
                for(var x=0; x<myObjectMap.length; x++) {
                    // Look to see if our object has a "key" value
                    // and whether that key is equal to the key we want
                    // to use to group everything
                    if("key" in myObjectMap[x] && myObjectMap[x]["key"] == myKey) {
                        
                        myObjectMap[x]["listBills"].push(myRecord); //CSM-14404
                        // We found our key and pushed the record into its
                        // list, no need to continue
                        found = true;
                        break;
                    }
                }
                // Need to make sure this record found a home; if it didn't
                // then we need to initialize it in our "map"
                if(!found){
                    var temp = { "key": myKey, "listBills": [myRecord] }; //CSM-14404
                    myObjectMap.push(temp);
                }
            }
        }
         component.set("v.filteredBillingSummary",myObjectMap);
         console.log('myObjectMap>>>>>>' + myObjectMap);
    },
    
    initializeCheckConglomerate : function(component, event) {
        console.log('initializeCheckConglomerate');
        var action = component.get("c.retrieveCheckConglomerate");
        
        action.setCallback(this,function(response){             
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('initializeCheckConglomerate state' + state +' and result '+result);
            if(state === "SUCCESS"){
                component.set('v.isConglomerate', result);
            }
        });  
        $A.enqueueAction(action); 
    }
    
    //START CSM-14070 GGrandea 10.24.2017
    , toggle_appSpinner : function (component, event, helper){
        console.log('>>>>>>>>>>>>>>>>>> toggle_appSpinner');
        var spHide =  event.getParam("hideSpinner");
        var cmpTarget = component.find("appSpinner");
        if(spHide){
            $A.util.addClass(cmpTarget, 'slds-hide');
        }else{
            $A.util.removeClass(cmpTarget, 'slds-hide');
        }        
    }
    //END CSM-14070
})