({	
/**
* Method to get the opportunity id and calls a helper method
**/
    doInit: function(cmp, event, helper) {
        // Set the attribute value. 
        var opptyId = cmp.get("v.opptyid");
        console.log("Opportunity :",opptyId);
        helper.getAddress(cmp, opptyId);
        
    },
/**
* Method to open the EAV popup
**/    
    openModal : function(component, event, helper){ 
        component.set("v.modal", component.find("EvtModal")); 
        component.get("v.modal").open();
    },
/**
* Method to close the EAV popup
**/     
    closeModal : function(component, event, helper){
        component.get("v.modal").closed();
    },
/**
* Method to search based on filter criteria
**/       
    connsearch: function(cmp, event, helper) 
    {	
        var opptyId = cmp.get("v.opptyid");
        var AccountId = cmp.get("v.oppty.AccountId");
        var city=cmp.get("v.oppty.Account.BillingCity");
        var street=cmp.get("v.oppty.Account.BillingStreet");
        var PostalCode=cmp.get("v.oppty.Account.BillingPostalCode");
        var isGas= cmp.get("v.gcheck"); 
        var isElectricity= cmp.get("v.echeck");
        helper.getConnections(cmp,opptyId,AccountId,city,street,PostalCode,isGas,isElectricity);
        cmp.set("v.tabselection", cmp.find("selectiontabs")); 
        cmp.get("v.tabselection").selection();
    },
    prodSearch: function(cmp, event, helper) {
        // Set the attribute value. 
        // You could also fire an event here instead.
        var opptyId = cmp.get("v.opptyid");
        helper.getConnectionDetailsfunction(cmp,opptyId);
    },
    onFilterChange: function(cmp, event, helper) {
        var connWrapper = cmp.get("v.connectionWrapper1");
        var str = JSON.stringify(connWrapper);
        var opptyId = cmp.get("v.opptyid");
        var action = cmp.get("c.filterChange");
        action.setParams({
            'opptyId':opptyId,
            'WrapStr' :str
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                cmp.set("v.connectionWrapper1", a.getReturnValue());
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });
        $A.enqueueAction(action);        
    },
    prodFilter: function(cmp, event, helper) {
        var connWrapper = cmp.get("v.connectionWrapper1");
        var str = JSON.stringify(connWrapper);
    },
    saveCommodity: function(cmp, event, helper) {
        var opptyId = cmp.get("v.opptyid");
        var connWrapper = cmp.get("v.saveList");
        var connLst = cmp.get("v.connectionWrapper1");
        var connIds = [];
        for(var i = connLst.length - 1; i >= 0; i--){
            connIds.push(connLst[i].connection.Id);
        }
        for (var i = connWrapper.length - 1; i >= 0; i--) {
            var currentItem = connWrapper[i].connection.Id;
            if(connIds.indexOf(currentItem) > -1){
            }else{
                connWrapper.splice(i, 1);
            }
        }
        var str = JSON.stringify(connWrapper);
        var action = cmp.get("c.saveConn");
        action.setParams({
            'wrapStr':str,
            'opptyId':opptyId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                helper.redirectToDetailPage(cmp);
            }else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
    },
    fireEvent: function(cmp, event, helper){
        var saveList = cmp.get("v.saveList");
        saveList.push(event.getParam("currentConnection"));
        var hashObject = new Object();
        for (var i = saveList.length - 1; i >= 0; i--) {
            var currentItem = saveList[i].connection.Id;
            if (hashObject[currentItem] == true) {
                saveList.splice(i, 1);
            }
            hashObject[currentItem] = true;
        }
        cmp.set("v.saveList",saveList);
    },
    setEAV: function(cmp, event, helper){
        cmp.set("v.connectionWrapper1",event.getParam("updatedConnections"));
    },
    gasCheck: function(cmp, event, helper){
        cmp.set("v.gcheck",true);
        cmp.set("v.echeck",false);
    },
    electricityCheck: function(cmp, event, helper){
        cmp.set("v.echeck",true);
        cmp.set("v.gcheck",false);
    },
    gaselectCheck: function(cmp, event, helper){
        cmp.set("v.gcheck",true);
        cmp.set("v.echeck",true);
    },
    cancel: function(cmp, event, helper){
        helper.redirectToDetailPage(cmp);
    },
})