({
/**
* Initial Method called to get the product details
**/    
	doInit : function(component, event, helper) {
		var productId = component.get("v.productId");
        var eavParam = component.get("v.eavParam");
        var action = component.get("c.getCommercialProductOverview");
        action.setParams({
            "productId": productId,
            "eavParam": eavParam
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.commProdWrap", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
/**
* Method to capture and pass the product that is selected
**/    
    updateSelectedProduct : function(component, event, helper) {
        var value = event.getSource().get("v.value");
        var productId = component.get("v.productId");
        var oldProductId = component.get("v.oldProductId");
        var updateProduct = component.getEvent("Lightning_UpdateSelectedProduct");
        if(value == true){
            updateProduct.setParams({ "ProductSelectOptions": productId }).fire();
        }else{
            updateProduct.setParams({ "ProductSelectOptions": oldProductId }).fire();
        }
    },
})