({
    /**
* Method to get the opportunity address
**/    
    getAddress : function(cmp, opptyId) {
        var action = cmp.get("c.getOpptyName");
        action.setParams({
            'opptyId' :opptyId 
        }); 
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                cmp.set("v.oppty", a.getReturnValue());
                var opportunity = cmp.get( "v.oppty");
                if( opportunity!= 'undefined' || opportunity!= '')
                {
                    var opptyId = cmp.get("v.opptyid");
                    var AccountId = cmp.get("v.oppty.AccountId");
                    var city=cmp.get("v.oppty.Account.BillingCity");
                    var street=cmp.get("v.oppty.Account.BillingStreet");
                    var PostalCode=cmp.get("v.oppty.Account.BillingPostalCode");
                    var isGas= cmp.get("v.gcheck");
                    var isElectricity= cmp.get("v.echeck");
                    this.getConnections(cmp,opptyId,AccountId,city,street,PostalCode,isGas,isElectricity);
                    this.getConnectionDetailsfunction(cmp,opptyId);
                }
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });
        $A.enqueueAction(action);
    },
    /**
* Method to get connections based on the filter criteria
**/    
    getConnections : function(cmp,opptyId,AccountId,city,street,PostalCode,isGas,isElectricity) {
        var action = cmp.get("c.connectionSearch");
        action.setParams({
            'opptyId':opptyId,
            'AccountId' :AccountId,
            'city' :city,
            'street' :street,
            'PostalCode' :PostalCode,
            'isGas' :isGas,
            'isElectricity' :isElectricity
        }); 
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                cmp.set("v.connection", a.getReturnValue());
                
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });
        $A.enqueueAction(action);
    },
    /**
* Method to get the connection details
**/     
    getConnectionDetailsfunction: function(cmp,opptyId){	
        var action = cmp.get("c.commodityProducts"); 
        var wrappers = cmp.get('v.connection');
        if(wrappers.length >0){
            var ids=new Array();
            for (var idx=0; idx<wrappers.length; idx++) {
                if (wrappers[idx].selected) {
                    ids.push(wrappers[idx].connection.Id);
                }
            }
            action.setParams({
                "connectionIds": ids,
                "opptyId": opptyId
            });
        }else{
            var ids=new Array();
            action.setParams({
                "connectionIds": ids,
                'opptyId' :opptyId 
            });            
        }
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                cmp.set("v.connectionWrapper1", a.getReturnValue());
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError(a.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
    },
    /**
* Method to open/close(toggle) the modal
**/ 
    toggleClass: function(cmp,componentId,className) {
        var modal = cmp.find(componentId);
        $A.util.addClass(modal, className+'open');
    },
    /**
* Method to redirect to detail page
**/ 
    redirectToDetailPage : function(cmp,event){
        var opptyId = cmp.get("v.opptyid");
        var device = $A.get("$Browser.formFactor");
        var action = cmp.get("c.checkuser");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (cmp.isValid() && state === "SUCCESS")
            {
                cmp.set("v.usertype", a.getReturnValue());
                var usert = cmp.get("v.usertype");
                if(usert)
                {
                    if(device === "DESKTOP"){
                        var retUrl = window.location.protocol+ "//" + window.location.host + "/" + "partners" + "/" +opptyId;
                        window.open(retUrl,"_top");
                    }else if(device === "PHONE" || device === "TABLET"){
                        if (sforce.one) {
                            sforce.one.navigateToSObject(opptyId);
                        }
                    }
                }
                else
                {
                    if(device === "DESKTOP"){
                        var retUrl = window.location.protocol+ "//" + window.location.host + "/" +opptyId;
                        window.open(retUrl,"_top");
                    }else if(device === "PHONE" || device === "TABLET"){
                        if (sforce.one) {
                            sforce.one.navigateToSObject(opptyId);
                        }
                    }
                }
            }
            else{
                console.log("Failed with state: " + state);
            }		
        })
        $A.enqueueAction(action);
    },
})