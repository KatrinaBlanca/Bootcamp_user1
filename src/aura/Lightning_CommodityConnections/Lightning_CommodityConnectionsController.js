({
/**
* Method to apply the filter criteria based on which the products would be displayed
**/    
    filter : function(component, event, helper) {
        var eavField = component.find("eav");
        var eav = component.get("v.eav");
        var callFilter = false;
        if(eav){
            eav = eav.toString();
            eav = eav.replace(/,/g , "");
            var reg = /^\d+$/;
            if(reg.test(eav)){
                callFilter = true;
                component.set("v.eav",eav);
            }else{
                eavField.set("v.errors", [{message:"Enter valid EAV amount."}]);
            }
        }else{
            eav = null;
            callFilter = true;
        }
        if (callFilter){
            eavField.set("v.errors", null);
            var OpptyId = component.get("v.OpptyId");
            var connection = component.get("v.connection");
            var filter = component.get("v.filter");
            var filterFee = component.get("v.filterFee");
            var filterBrand = component.get("v.filterBrand");
            var eav = eav;
            var action = component.get("c.filterChange");
            action.setParams({
                'opptyId':OpptyId,
                'connectionId':connection.Id,
                'filter':filter,
                'filterFee':filterFee,
                'filterBrand':filterBrand,
                'eav':eav
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    component.set("v.displayError", false);
                    var str = JSON.stringify(response.getReturnValue()); 
                    var resp = response.getReturnValue();
                    component.set("v.ProductSelectOptions", resp.ProductSelectOptions);
                    component.set("v.ProdId", resp.ProductId);
                    helper.createCommercialOverview(component, resp.eav, resp.ProductId, 'filter');
                    var sendConn = component.getEvent("Lightning_connectionSave");
                    sendConn.setParams({ "currentConnection": response.getReturnValue() }).fire();
                }else if (state === "ERROR") {
                    var container = component.find("container");
                    $A.createComponents([
                        ["ui:message",{
                            "title" : "Error",
                            "severity" : "error"
                        }],
                        ["ui:outputText",{
                            "value" : " There are no Products available for this filter."
                        }]
                    ],
                                        function(components, status){
                                            if (status === "SUCCESS") {
                                                var message = components[0];
                                                var outputText = components[1];
                                                message.set("v.body", outputText);
                                                container.set("v.body", [message]);
                                            }
                                        }
                                       );                    
                    component.set("v.ProductSelectOptions", []);
                    component.set("v.displayError", true);
                }
            });
            $A.enqueueAction(action);
        }
        helper.showcontent2(component);  
    },
    
/**  
* Intial Method to get the default filter criteria based on which the products would be displayed
**/
    doInit: function(component, event, helper) {
        var connection = component.get("v.connectionWrapper");
        component.set("v.flag1", "false");
        component.set("v.flag2", "false");
        component.set("v.flag3", "false");        
        component.set("v.connection", connection.connection);
        component.set("v.filter", connection.filter);
        component.set("v.filterFee", connection.filterFee);
        component.set("v.filterBrand", connection.filterBrand);
        component.set("v.eav", connection.eav);
        component.set("v.ProdId", connection.ProductId);
        component.set("v.ProductSelectOptions", connection.ProductSelectOptions);
        component.set("v.connectionId", connection.connectionId);
        component.set("v.oLI", connection.oLI);
        var sendConn = component.getEvent("Lightning_connectionSave");
        sendConn.setParams({ "currentConnection": connection }).fire();
        component.set("v.connUtilityTitle", connection.connection.Name);
        component.set("v.connUtilityName", connection.connection.Utility_type__c);
    },
/**
* Method for product change updation
**/    
    ProductChange: function(component, event, helper) {
        var selectedProductId = event.target.value;
        component.set("v.currentSelectedProductId",selectedProductId);
        //component.set("v.ProdId",selectedProductId);
        helper.sendUpdatedConnection(component, event, 'ProductChange');
    },
/**
* Method to get the product details for default product that is selected
**/    
    updateCommercialProductOverviewOnLoad : function(component, event, helper) {
        var eav = component.get("v.eav");
        var ProdId = component.get("v.ProdId");
        component.set("v.currentSelectedProductId", ProdId);
        helper.createCommercialOverview(component, eav, ProdId, 'OnLoad');
    },
/**
* Method to get the product details for the product that is selected manually
**/ 
    updateCommercialProductOverviewOnButtonClick : function(component, event, helper) {
        var selectedProductId = event.target.id;
        var eav = component.get("v.eav");
        helper.createCommercialOverview(component, eav, selectedProductId, 'OnButtonClick'); 
        component.set("v.flag3", "true");
        helper.showcontent3(component);  
    },
/**
* Method updating the connection
**/ 
    sendConnection : function(component, event, helper) {
        helper.sendUpdatedConnection(component, event, 'sendConnection');
    },
    
/**
* Method for capturing the year change
**/     
    yearChange : function(component, event, helper) {
        target = event.target.value; // this is a DOM element
        component.set("v.filter", event.target.value);        
    },
/**
* Method for capturing the Fee Type change
**/
    feeTypeChange : function(component, event, helper) {
        target = event.target.value; // this is a DOM element
        component.set("v.filterFee", event.target.value);        
    },
/**
* Method for capturing the brand change
**/    
    brandChange : function(component, event, helper) {
        target = event.target.value; // this is a DOM element
        component.set("v.filterBrand", event.target.value);        
    },
/**
* Method for capturing the product selection
**/     
    updateSelectedProduct : function(component, event, helper) {
        var updatedProductList = event.getParam("ProductSelectOptions");
        var productOptions = component.get("v.ProductSelectOptions");
        for(i = 0; i < productOptions.length; i++){
            if(productOptions[i].text == updatedProductList){
                productOptions[i].value = 'checked';
            }else{
                productOptions[i].value = '';
            }
        }
        component.set("v.ProductSelectOptions",productOptions);
        helper.sendUpdatedConnection(component, event, 'updateSelectedProduct');
    },
/**
* Method for showing the content of Product Filtering
**/    
    show1 : function(component, event, helper) {
      helper.showcontent1(component);  
    },
/**
* Method for showing the content of Product Selection
**/ 
    show2 : function(component, event, helper) {
      helper.showcontent2(component);  
    },
/**
* Method for showing the content of Product Details
**/
    show3 : function(component, event, helper) {
      helper.showcontent3(component);   
    },
/**
* Method for showing the content on click of the arrow beside the header
**/    
	opencontent : function(component, event, helper) {
	var con = component.find("contentbody");
    $A.util.toggleClass(con, "slds-hide");	
    var arrowup = component.find("arrowup");
    $A.util.toggleClass(arrowup, "slds-hide");	
    var arrowdown = component.find("arrowdown");
    $A.util.toggleClass(arrowdown, "slds-hide");	
	}    
})