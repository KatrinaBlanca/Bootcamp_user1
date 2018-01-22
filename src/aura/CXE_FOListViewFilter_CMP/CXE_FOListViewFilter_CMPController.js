({
	doInit : function(component, event, helper) {
        var filterValue = helper.resetFilterValueObject();
        var statusFilterValueList = $A.get("$Label.c.FO_Status_Filter").trim().split(";");
        
        component.set("v.filterValue", filterValue);
        component.set("v.statusFilterValueList", statusFilterValueList);
	},
    
    setStatus : function(component, event, helper){
        var filterValue = component.get("v.filterValue");
        console.log("filterValue : ", filterValue);
        filterValue.status = event.target.value;
        
        component.set("v.filterValue", filterValue);
    },
    
    setRecordType : function(component, event, helper){
        var filterValue = component.get("v.filterValue");
        console.log("filterValue : ", filterValue);
        filterValue.recordType = event.target.value;
        
        component.set("v.filterValue", filterValue);
    },
    
    setDateType : function(component, event, helper){
        var filterValue = component.get("v.filterValue");
        console.log("filterValue : ", filterValue);
        filterValue.dateType = event.target.value;
        
        component.set("v.filterValue", filterValue);
    },
    
    applyFilter : function(component, event, helper){
        helper.filterFieldOrderList(component, helper)
    },
    
    resetFilter : function(component, event, helper){
        var filterValue = helper.resetFilterValueObject();
        component.set("v.filterValue", filterValue);
        helper.fireEvent(component, component.get("v.fieldOrderList"));
    }
})