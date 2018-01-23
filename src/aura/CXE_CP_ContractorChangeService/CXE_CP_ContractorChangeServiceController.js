({
    doInit : function(component, event, helper){
        helper.initializeCase(component, event, helper);    
        helper.getServiceModificationOptions(component, event, helper);
        helper.getContractModificationOptions(component, event, helper);
        helper.getRelationshipToCustomer(component, event, helper);
        
        console.log("sample"+component.get('v.caseRecord'));
    },
    
    onClickServiceMod : function(component, event, helper) {
        var selected = component.find("isServiceMod").getElement().checked;        
        component.set("v.caseRecord.CXE_Service_Request_s__c", null);
        component.set("v.caseRecord.CXE_Authorized_Rep_Designation__c", null);
        component.set("v.isServiceMod", selected);
        component.set("v.isShow", true);
    },

    onServiceRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        
        //var ReqForAddLoad = $A.get("$Label.c.ReqForAddLoad");
        
        if(selected == $A.get("$Label.c.Request_for_additional_electrical_load")){
            selected = $A.get("$Label.c.Additional_Load");   
        }
        
        if(selected == $A.get("$Label.c.Request_to_downgrade_electrical_load")){
             selected = $A.get("$Label.c.Reduction_in_Load");   
        }
        
        if(selected == $A.get("$Label.c.Relocate_the_meter")){
           selected = $A.get("$Label.c.Relocation");   
        }
        
        if(selected == $A.get("$Label.c.Remodel_the_meter")){
            selected = $A.get("$Label.c.Remodel");   
        }
        
        component.set("v.caseRecord.CXE_Service_Request_s__c", selected);
    },

    onContractRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        
        if(selected == $A.get("$Label.c.Change_the_name_on_my_bill")){
            selected = $A.get("$Label.c.Change_in_Contract_Name");   
        }
        
        if(selected == $A.get("$Label.c.Update_contract_information")){
            selected = $A.get("$Label.c.Transfer_of_Service");   
        }
        
        component.set("v.caseRecord.CXE_Service_Request_s__c", selected);
    },
    
    
    onClickNextTab1 : function(component, event, helper) {   
        var hasError = helper.validateTab1(component, event, helper);
        var tabName = 2;
        var contractor= "Contractor";
        
        var activeTabNumber = component.get("v.activeTabNumber");
        var activeTabNumber2 = parseInt(activeTabNumber) + 1;
        var stepNumber = component.get("v.stepNumber");
        
        	if(!hasError) {
            	component.set("v.activeTabNumber", tabName);
            	//component.set("v.stepNumber", tabName);
                component.set("v.caseRecord.Relationship__c", contractor);
                
                if(stepNumber < activeTabNumber2){
                   component.set("v.isDisabledModTab3", false);
                   component.set("v.stepNumber", 2);
                }
                
            	helper.displayTabFromButton(component, event, helper);
        
        	}
    },
    
    onClickNextTab2 : function(component, event, helper) {   
        var hasError = helper.validateTab2(component, event, helper);
        var tabName = 3;
        
        var activeTabNumber = component.get("v.activeTabNumber");
        var activeTabNumber2 = parseInt(activeTabNumber) + 1;
        var stepNumber = component.get("v.stepNumber");
        
        	if(!hasError) {
                component.set("v.showRequired", false);
            	component.set("v.activeTabNumber", tabName);
            	component.set("v.stepNumber", tabName);
            	helper.displayTabFromButton(component, event, helper);
        
        }
    },
    onClickNextTab3 : function(component, event, helper) {   
       
        component.find("modifySubmitBtn").set("v.disabled", true);
        helper.submitModify(component, event, helper);
       
    },
    
    
    onSelectNotification : function(component, event, helper) {
        
        var isEmail = component.find("emailModify_t2").getElement().checked;
        var preferredMode = isEmail ? "Email" : "None";
            
        component.set("v.caseRecord.Preferred_Mode_of_Notification__c", preferredMode);
    },
    
    onCheck: function(component, event, helper) {
        var cmpBtn = component.find("modifySubmitBtn");
        cmpBtn.set("v.disabled",!event.getSource().get("v.value"));
    },
    
    onClickBackToHome : function(component, event, helper) {
		helper.goToHomePage(component, event, helper);
	},

    onChangeRelationToOwner : function(component, event, helper) {
        var selected = component.find("selectedRelationToOwner").get("v.value");
        component.set("v.caseRecord.Relationship__c", selected);
      
    },
    
    onClickTab : function(component, event, helper) {
        helper.displayTab(component, event, helper);
    },
  
    
})