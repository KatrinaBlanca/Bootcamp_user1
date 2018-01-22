({
    submitTab : function(component, event, helper) {

        console.log(' >>>>>>>>>>>>>>>>>>>>>>>>>>> submitTab2: ');

        //PLACE VALIDATION HERE


        //var servReq = component.get("v.caseRecord.CXE_Service_Request_s__c");
        var servReq = true;
        if(servReq){ //if no errors
            var setEvent = component.getEvent("callTabEvent");
            setEvent.setParams({"param1":3});
            setEvent.fire();
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({"title": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Please check your input.",
                                  "message": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Please select a service modification.",
                                  "type": "error",
                                  "duration" : 6000
                                 });
            toastEvent.fire();
        }
    },

    getControllingPicklistService : function(cmp, event) {        
        console.log("controllingPicklist Service>> " + event.getParam("controllingPicklist"));
        cmp.set("v.caseVar.Service_Address_Province__c", event.getParam("controllingPicklist"));
    },

    getDependentPicklistService : function(cmp, event) {
        console.log("dependentPicklist Service>> " + event.getParam("dependentPicklist"));
        cmp.set("v.caseVar.Service_Address_City_Municiple__c", event.getParam("dependentPicklist"));
    },

    getControllingPicklistBusiness : function(cmp, event) {        
        console.log("controllingPicklist Business>> " + event.getParam("businessProvince"));
        cmp.set("v.caseVar.Billing_Address_Province__c", event.getParam("businessProvince"));
    },

    getDependentPicklistBusiness : function(cmp, event) {
        console.log("dependentPicklist Business>> " + event.getParam("businessCity"));
        cmp.set("v.caseVar.Billing_Address_City_Municipal__c", event.getParam("businessCity"));
    },

    onClickNext : function(component, event, helper) {   
        helper.displayTab3(component, event, helper);
    },
    onClickSameAsService : function(component, event) {        
        var selected = component.find("isSameAsService").getElement().checked;
        component.set("v.caseVar.Same_As_Service_Address__c", selected);
        component.set("v.isSame", selected);
    }

    
      
})