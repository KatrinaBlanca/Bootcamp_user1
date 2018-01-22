({
/**
* Method to create the product details view for the selected product
**/    
    createCommercialOverview : function(component, eav, ProdId, Source) {
        var currentSelectedProductId = component.get("v.currentSelectedProductId");
        var productSelectOption = component.get("v.ProductSelectOptions");
        var isReadOnly = false;
        if(productSelectOption.length > 0){
            for(i = 0; i < productSelectOption.length; i++){
                if(productSelectOption[i].value == 'checked'){
                    if(productSelectOption[i].text == ProdId){
                        console.log('productSelectOption');
                        isReadOnly = true;
                    }
                }
            }            
        }else if(currentSelectedProductId == ProdId){
            console.log('Load');
            isReadOnly = true;
        }
        console.log('currentSelectedProductId'+currentSelectedProductId);
        console.log('ProdId'+ProdId);
        if(Source == 'OnButtonClick'){
            if(currentSelectedProductId == ProdId){
                console.log('OnButtonClick');
                isReadOnly = true;
            }else{
                isReadOnly = false;
            }
        }
        var container = component.find("container");
        $A.createComponent("c:Lightning_CommodityCommercialProducts",
                           {productId: ProdId,
                            eavParam: eav,
                            isReadOnly: isReadOnly,
                            oldProductId :currentSelectedProductId,
                            Lightning_UpdateSelectedProduct :component.getReference("c.updateSelectedProduct")
                           },
                           function(cmp) {
                               container.set("v.body", [cmp]);
                           });
    },
/**
* Method to get the products based on the filter criteria
**/     
    sendUpdatedConnection : function(component, event, source) {
        var eavField = component.find("eav");
        var eav = component.get("v.eav");
        var sendConnection = false;
        if(eav){
        	eav = eav.toString();
            eav = eav.replace(/,/g , "");
            var reg = /^\d+$/;
            if(reg.test(eav)){
                component.set("v.eav",eav);
                sendConnection = true;
            }else{
                eavField.set("v.errors", [{message:"Enter valid EAV amount."}]);
            }
        }else{
            eav = null;
            sendConnection = true;
        }
        if(sendConnection){
            eavField.set("v.errors", null);
            var retConn = component.get("v.connectionWrapper");
            retConn.connection = component.get("v.connection");
            retConn.filter = component.get("v.filter");
            retConn.filterFee = component.get("v.filterFee");
            retConn.filterBrand = component.get("v.filterBrand");
            retConn.eav = eav;
            retConn.ProductId = component.get("v.ProdId");
            retConn.ProductSelectOptions = component.get("v.ProductSelectOptions");
            retConn.connectionId = component.get("v.connectionId");
            retConn.oLI = component.get("v.oLI");
            var sendConn = component.getEvent("Lightning_connectionSave");
            if(source == 'ProductChange'){
                var selectedProductId = event.target.value;
                retConn.ProductId = selectedProductId;
            }else if(source == 'updateSelectedProduct'){
                var updatedProduct = event.getParam("ProductSelectOptions");
                retConn.ProductId = updatedProduct;
            }
            sendConn.setParams({ "currentConnection": retConn }).fire();
        }
    },
/**
* Method for showing the content of Product Filtering
**/
    showcontent1 : function(component) {
	var con1 = component.find("content1");
    $A.util.removeClass(con1, "slds-hide");	
    var con2 = component.find("content2");
    $A.util.addClass(con2, "slds-hide");
    var con3 = component.find("content3");
    $A.util.addClass(con3, "slds-hide"); 
    var contentli1 =component.find("contentli1");
	$A.util.addClass(contentli1, "slds-is-current"); 
    $A.util.removeClass(contentli1, "slds-is-incomplete");        
    var contentli2 =component.find("contentli2");
    $A.util.addClass(contentli2, "slds-is-incomplete"); 
    $A.util.removeClass(contentli2, "slds-is-current");
    var contentli3 =component.find("contentli3");
    $A.util.addClass(contentli3, "slds-is-incomplete"); 
    $A.util.removeClass(contentli3, "slds-is-current");        
	},
/**
* Method for showing the content of Product Selection
**/     
    showcontent2 : function(component) {
	var con1 = component.find("content1");
    $A.util.addClass(con1, "slds-hide");	
    var con2 = component.find("content2");
    $A.util.removeClass(con2, "slds-hide");        
    var con3 = component.find("content3");
    $A.util.addClass(con3, "slds-hide");
    var contentli1 =component.find("contentli1");
	$A.util.addClass(contentli1, "slds-is-incomplete"); 
    $A.util.removeClass(contentli1, "slds-is-current");        
    var contentli2 =component.find("contentli2");
    $A.util.addClass(contentli2, "slds-is-current"); 
    $A.util.removeClass(contentli2, "slds-is-incomplete");
    var contentli3 =component.find("contentli3");
    $A.util.addClass(contentli3, "slds-is-incomplete"); 
    $A.util.removeClass(contentli3, "slds-is-current");
	},
/**
* Method for showing the content of Product Details
**/    
    showcontent3 : function(component) {
	var con1 = component.find("content1");
    $A.util.addClass(con1, "slds-hide");	
    var con2 = component.find("content2");
    $A.util.addClass(con2, "slds-hide");
    var con3 = component.find("content3");
    $A.util.removeClass(con3, "slds-hide");
    var contentli1 =component.find("contentli1");
    $A.util.addClass(contentli1, "slds-is-incomplete"); 
    $A.util.removeClass(contentli1, "slds-is-current"); 
    var contentli2 =component.find("contentli2");
    $A.util.addClass(contentli2, "slds-is-incomplete"); 
    $A.util.removeClass(contentli2, "slds-is-current"); 
    var contentli3 =component.find("contentli3");
    $A.util.addClass(contentli3, "slds-is-current"); 
    $A.util.removeClass(contentli3, "slds-is-incomplete"); 
	},
})