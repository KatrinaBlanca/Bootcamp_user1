({
    showToast : function(component, type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },
    
    getFieldOrderRecords : function(component, helper) {
        var action = component.get("c.getFieldOrders");        
        
        action.setCallback(this, function(response){
            var res = response.getReturnValue();
            
            if(res.status == 'SUCCESS'){
                component.set("v.fieldOrderList", res.fieldOrderList);
                component.set("v.fieldOrderPrint", []);
                
                console.log("res.fieldOrderList : ", res.fieldOrderList)
                
                var filterValue = helper.setDefaultFilter(component, res.fieldOrderList);
                component.set("v.filterValue", filterValue);        
            } else {
                console.log("res.message : ", res.message);
            }
        })
        
        $A.enqueueAction(action);
    },
    
    filterListHelper : function(fieldOrderList, filterBy, filterValue){
        var fieldOrderTemp;
        var filteredFieldOrderList = [];
        
        console.log("filterValue", filterValue);
        
        for(var counter in fieldOrderList){
            fieldOrderTemp = fieldOrderList[counter];
            console.log("fieldOrderTemp.scheduleDate", fieldOrderTemp.scheduleDate);
            if(filterBy == "ScheduleDate"){
                if(fieldOrderTemp.scheduleDate == filterValue){
                    filteredFieldOrderList.push(fieldOrderTemp);
                }
            }
        }
        
        return filteredFieldOrderList;
    },
    
    setPritnData : function(text){
        
    },
    
    setDefaultFilter : function(component, dataList){
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth()+1;
        var yyyy = today.getFullYear();
        
        if(dd<10) {
            dd = '0'+dd
        } 
        
        if(mm<10) {
            mm = '0'+mm
        } 
        
        today = yyyy + '-' + mm + '-' + dd;
        
        var filteredList = [];
        for(var i in dataList){
            if(dataList[i].createdDate.toString() === today.toString()){
                filteredList.push(dataList[i]);
            }
        }
        
        component.set("v.filteredfieldOrderList", filteredList);
        console.log(filteredList);
        var filterValue = ({
            dateType : "Created Date",
            fromDate : today,
            toDate : today,
            status : "None",
            recordType : "None"
        });
        
        return filterValue;
    },
    
    open_data_uri_window : function(url) {
    alert(url);    
    var html = '<html>' + '<style>html, body { padding: 0; margin: 0; } iframe { width: 100%; height: 100%; border: 0;}  </style>' + '<body>' + '<iframe src="' + url + '"></iframe>' + '</body></html>';
    var a = window.open();
    a.document.write(html);
  }
})