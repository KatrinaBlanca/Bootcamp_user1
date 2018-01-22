({
    resetFilterValueObject : function() {
        var filterValue = ({
            dateType : "Created Date",
            fromDate : '',
            toDate : '',
            status : "None",
            recordType : "None"
        })
        
        return filterValue;
    },
    
    filterFieldOrderList : function(component, helper){        
        var isValid = true;
        var fieldOrderTemp;
        var filteredFieldOrderList = [];
        var filterValue = component.get("v.filterValue");
        var fieldOrderList = component.get("v.fieldOrderList");               
        
        if((filterValue.fromDate == null || filterValue.fromDate == "") && (filterValue.toDate == null || filterValue.toDate == "") && filterValue.status == "None" && filterValue.recordType == "None"){
            filteredFieldOrderList = fieldOrderList;
        } else {
            for(var counter in fieldOrderList){
                isValid = true;
                fieldOrderTemp = fieldOrderList[counter];
                
                if(filterValue.fromDate != null && filterValue.fromDate != ""){
                    if(filterValue.toDate != null && filterValue.toDate != ""){
                        if(filterValue.dateType == "Created Date" 
                           && (fieldOrderTemp.createdDate < filterValue.fromDate || fieldOrderTemp.createdDate > filterValue.toDate)){
                            isValid = false;
                        } else if(filterValue.dateType == "Scheduled Date" 
                                  && (fieldOrderTemp.scheduleDate < filterValue.fromDate || fieldOrderTemp.scheduleDate > filterValue.toDate)){
                            isValid = false;
                        }
                    } else {
                        if(filterValue.dateType == "Created Date" 
                           && fieldOrderTemp.createdDate < filterValue.fromDate ){
                            isValid = false;
                        } else if(filterValue.dateType == "Scheduled Date" 
                                  && fieldOrderTemp.scheduleDate < filterValue.fromDate){
                            isValid = false;
                        }
                    }
                } else if(filterValue.toDate != null && filterValue.toDate != ""){
                    if(filterValue.dateType == "Created Date" 
                       && fieldOrderTemp.createdDate > filterValue.toDate){
                        isValid = false;
                    } else if(filterValue.dateType == "Scheduled Date" 
                              && fieldOrderTemp.scheduleDate > filterValue.toDate){
                        isValid = false;
                    }
                }
				
                if(isValid && filterValue.status != "None" && filterValue.status.toUpperCase() != fieldOrderTemp.status.toUpperCase()){
					isValid = false;
                }
                
                if(isValid && filterValue.recordType != "None" && filterValue.recordType.toUpperCase() != fieldOrderTemp.recordTypeName.toUpperCase()){
                    isValid = false;
                }               
                
                if(isValid){
                    filteredFieldOrderList.push(fieldOrderTemp);
                }
            } 
        }
        
        console.log("filterValue : ", filterValue)
        console.log("filteredFieldOrderList : ", filteredFieldOrderList)
        
        helper.fireEvent(component, filteredFieldOrderList)
    },
    
    fireEvent : function(component, fieldOrderList){
        var eventHandler = component.getEvent("filterEventHandler");
        
        eventHandler.setParams({
            fieldOrderList : fieldOrderList
        })
        
        eventHandler.fire();
    }
})