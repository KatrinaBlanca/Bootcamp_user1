({
    privacyPolicyHelper : function(component, event, helper) {
        
        var action = component.get("c.getHiearchySettings");
        action.setCallback(this, function(response) {
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){  
                
                window.open(
                    response.getReturnValue(),
                    '_blank' // <- This is what makes it open in a new window.
                ); 
            }            
        });
        
        $A.enqueueAction(action);   
        
    },    
    url_param: function(){
        return window.location.search.substring(1).split('&').map(function(e){
            return e.split('=');
        }).reduce(function(cur, nex){
            cur[nex[0]] = decodeURIComponent(nex[1]);
            return cur;
        }, {})
    },
    groupBills : function(component,result) {
        
        var myObjectMap = [];
        
        // Loop through results; remember, this is a list of sObjects
        for(var i=0; i<result.length; i++) {                
            // Get the record
            var myRecord = result[i];
            
            if(myRecord.bill_status_filter != 'Cancelled'){
                // Pull out the field that's going to be my key
                var myKey = myRecord.account_number;
                // Keep track of whether our key already exists in myObjectMap
                var found = false;
                // Loop through our map and see if an entry for our key exists
                for(var x=0; x<myObjectMap.length; x++) {
                    // Look to see if our object has a "key" value
                    // and whether that key is equal to the key we want
                    // to use to group everything
                    if("key" in myObjectMap[x] && myObjectMap[x]["key"] == myKey) {
                        
                        myObjectMap[x]["list"].push(myRecord);
                        // We found our key and pushed the record into its
                        // list, no need to continue
                        found = true;
                        break;
                    }
                }
                // Need to make sure this record found a home; if it didn't
                // then we need to initialize it in our "map"
                if(!found){
                    var temp = { "key": myKey, "list": [myRecord] };
                    myObjectMap.push(temp);
                }
            }
        }
         component.set("v.billListRaw",myObjectMap);
         console.log('finalreturn' + myObjectMap);
    },
    
    resetValidation : function(component, event, helper) {
        var errorAccount = component.find("accountError");
        var errorContact = component.find("contactError");
        var errorAmount = component.find("amountError");
        $A.util.removeClass(errorAccount, "slds-hide");
        $A.util.addClass(errorAccount, "slds-hide");
        $A.util.removeClass(errorContact, "slds-hide");
        $A.util.addClass(errorContact, "slds-hide");
        $A.util.removeClass(errorAmount, "slds-hide");
        $A.util.addClass(errorAmount, "slds-hide");
        component.find('serviceText').set('v.errors' , null); 
        component.find('accountText').set('v.errors' ,null);   
        component.find('invoiceText').set('v.errors' , null); 
        component.find('amountText').set('v.errors' , null);
        component.find('emailText').set('v.errors' , null);
        component.find('mobileNum').set('v.errors' , null);
    }
    
})