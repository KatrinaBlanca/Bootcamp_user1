({
	onClickBtn : function(component, event, helper) {
        helper.displayTab3(component, event, helper); 
	},

	onClickSameAsService : function(component, event) {        
        var selected = component.find("isSameAsService").getElement().checked;
        component.set("v.caseRecord.Same_As_Service_Address__c", selected);
        component.set("v.isSame", selected);
    },

	getControllingPicklistService : function(cmp, event) {        
        console.log("controllingPicklist Service>> " + event.getParam("controllingPicklist"));
        cmp.set("v.caseApplication.Service_Address_Province__c", event.getParam("controllingPicklist"));
    },

    getDependentPicklistService : function(cmp, event) {
        console.log("dependentPicklist Service>> " + event.getParam("dependentPicklist"));
        cmp.set("v.caseApplication.Service_Address_City_Municiple__c", event.getParam("dependentPicklist"));
    },

    getControllingPicklistBusiness : function(cmp, event) {        
        console.log("controllingPicklist Business>> " + event.getParam("businessProvince"));
        cmp.set("v.caseApplication.Billing_Address_Province__c", event.getParam("businessProvince"));
    },

    getDependentPicklistBusiness : function(cmp, event) {
        console.log("dependentPicklist Business>> " + event.getParam("businessCity"));
        cmp.set("v.caseApplication.Billing_Address_City_Municipal__c", event.getParam("businessCity"));
    }


})