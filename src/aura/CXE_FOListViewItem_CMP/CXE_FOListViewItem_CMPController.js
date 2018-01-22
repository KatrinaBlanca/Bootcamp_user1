({
	setIsCheck : function(component, event, helper) {
        var fieldOrder = component.get("v.fieldOrder");
        
        fieldOrder.isCheck = event.target.checked;
        
        var forPrint = component.get("v.fieldOrderPrint");
        
        if(event.target.checked){
            forPrint.push(fieldOrder);
        }else{
            for(var x in forPrint){
                if(forPrint[x].fieldOrderId == fieldOrder.fieldOrderId){
                    forPrint.splice(x, 1);
                }
            }
        }
        
        component.set("v.fieldOrderPrint", forPrint);
        component.set("v.fieldOrder", fieldOrder);
        console.log("fieldOrder : ", fieldOrder);
        helper.fireEvent(component);
    }
})