({
    doInit : function(component, event, helper){
        helper.initializeCase(component, event, helper);    
        helper.getServiceModificationOptions(component, event, helper);
        helper.getContractModificationOptions(component, event, helper);
        helper.getRelationshipToCustomer(component, event, helper);
        
        console.log("sample"+component.get('v.caseRecsStop'));
    },
    
    onClickServiceMod : function(component, event, helper) {
        var selected = component.find("isServiceMod").getElement().checked;        
        component.set("v.caseRecsStop.CXE_Service_Request_s__c", null);
        component.set("v.caseRecsStop.CXE_Authorized_Rep_Designation__c", null);
        component.set("v.isServiceMod", selected);
        component.set("v.isShow", true);
    },

    onServiceRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseRecsStop.CXE_Service_Request_s__c", selected);
    },

    onContractRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseRecsStop.CXE_Service_Request_s__c", selected);
    },
    
    onClickNextTab1 : function(component, event, helper) {   
        var hasError = helper.validateTab1(component, event, helper);
       
        var tabName = 2;
        
        var contractor= "Contractor";
        
        	if(!hasError) {
                component.set("v.showRequired", false);
            	component.set("v.activeTabNumber", tabName);
            	component.set("v.stepNumberStop", tabName);
                component.set("v.caseRecsStop.Relationship__c", contractor);
            	helper.displayTabFromButton(component, event, helper);
        	}
    },
    
        
    onClickNextTab2 : function(component, event, helper) {   
        component.find("stopSubmitBtn").set("v.disabled", true);
        helper.submitTermination(component, event, helper);
        component.set("v.booleanDisableProgressBarButton", true);
    },
    
    
    onSelectNotification : function(component, event, helper) {
        
        var isEmail = component.find("emailModify_t2Stop").getElement().checked;
        var preferredMode = isEmail ? "Email" : "None";
            
        component.set("v.caseRecsStop.Preferred_Mode_of_Notification__c", preferredMode);
    },
    
    onCheck: function(component, event, helper) {
        var cmpBtn = component.find("stopSubmitBtn");
        cmpBtn.set("v.disabled",!event.getSource().get("v.value"));
    },
    
    onClickBackToHome : function(component, event, helper) {
		helper.goToHomePage(component, event, helper);
	},

    onChangeRelationToOwner : function(component, event, helper) {
        var selected = component.find("selectedRelationToOwner").get("v.value");
        component.set("v.caseRecsStop.Relationship__c", selected);
      
    },
    
    onChangeResidential : function(component, event, helper){
        component.set("v.caseRecord.Application_for_Residential_Customer__c", true);
        component.set("v.caseRecord.Application_for_Residential_Service__c", true);
       
        helper.onChangeResidentialHelper(component, event, helper);    
    },
    
    
    onChangeBusiness : function(component, event, helper){
        component.set("v.caseRecord.Application_for_Business_Customer__c", true);
        component.set("v.caseRecord.Application_for_Business_Service__c", true);
    
        helper.onChangeBusinessHelper(component, event, helper);    
    },
    
    onClickSameAsService : function(component, event) {        
        var selected = component.find("isSameAsService").getElement().checked;
        component.set("v.caseRecsStop.Same_As_Service_Address__c", selected);
        component.set("v.isSame", selected);
    },
    
   
    onClickBackToMainTab : function(component, event, helper) {   
        var hasError = helper.validateTab1(component, event, helper);
       
        var tabName = 1;
        
        var contractor= "Contractor";
        
        	if(!hasError) {
                
            	component.set("v.activeTabNumber", tabName);
            	component.set("v.stepNumberStop", tabName);
                component.set("v.caseRecsStop.Relationship__c", contractor);
            	helper.displayTabFromButton(component, event, helper);
        	}
    },
    
    onClickTab : function(component, event, helper){
        helper.displayTab(component, event, helper);
    },
    
})