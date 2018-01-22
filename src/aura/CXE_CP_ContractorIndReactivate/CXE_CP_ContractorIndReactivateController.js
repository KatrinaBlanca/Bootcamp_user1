({
    doInit : function(component, event, helper){
        helper.initializeCase(component, event, helper);    
        helper.getServiceModificationOptions(component, event, helper);
        helper.getContractModificationOptions(component, event, helper);
        helper.getRelationshipToCustomer(component, event, helper);
        
        console.log("sample"+component.get('v.caseRecs'));
    },
    
    onClickServiceMod : function(component, event, helper) {
        var selected = component.find("isServiceMod").getElement().checked;        
        component.set("v.caseRecs.CXE_Service_Request_s__c", null);
        component.set("v.caseRecs.CXE_Authorized_Rep_Designation__c", null);
        component.set("v.isServiceMod", selected);
        component.set("v.isShow", true);
    },

    onServiceRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseRecs.CXE_Service_Request_s__c", selected);
    },

    onContractRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseRecs.CXE_Service_Request_s__c", selected);
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
                component.set("v.caseRecs.Relationship__c", contractor);
                
                
                if(stepNumber < activeTabNumber2){
                   component.set("v.isDisabledReactTab3", false);
                   component.set("v.stepNumber", 2);
                }
                
            	helper.displayTabFromButton(component, event, helper);
        	}
    },
    
    onClickNextTab2 : function(component, event, helper) { 
      
        var selectedService = component.get("v.appForResAndBusReact")
        var tabName = 3;
        
        var activeTabNumber = component.get("v.activeTabNumber");
        var activeTabNumber2 = parseInt(activeTabNumber) + 1;
        var stepNumber = component.get("v.stepNumber");
        
        if(selectedService == false){
           
            var hasError = helper.validateTab2Residential(component, event, helper); 
            
        }
        
        else{ 
           
            var hasError = helper.validateTab2Business(component, event, helper);
        }

        	if(!hasError) {
               
            	component.set("v.showRequired", false);
                component.set("v.activeTabNumber", tabName);
            	//component.set("v.stepNumber", tabName);
            	//
            	if(stepNumber < activeTabNumber2){
                   component.set("v.isDisabledReactTab4", false);
                   component.set("v.stepNumber", 3);
                }
                
            	helper.displayTabFromButton(component, event, helper);
        
        }
    },
    
    onClickNextTab3 : function(component, event, helper) { 
        var tabName = 4;
        var isSame = component.get("v.isSame"); 
        var activeTabNumber = component.get("v.activeTabNumber");
        var activeTabNumber2 = parseInt(activeTabNumber) + 1;
        var stepNumber = component.get("v.stepNumber");
        var provincePicklistValue = component.get("v.provincePicklistValue");
        var dependentPicklistValue = component.get("v.dependentPicklistValue");
        
        console.log('provincePicklistValue: '+provincePicklistValue);
        
        component.set("v.isNextClicked",true);
		
        if(isSame == false){
            var hasError = helper.validateTab3(component, event, helper);
           
            if($A.util.isEmpty(provincePicklistValue) || provincePicklistValue == "Select One"){
                hasError = true;  
            }

            if($A.util.isEmpty(dependentPicklistValue) || dependentPicklistValue == "Select One"){
                hasError = true;
                
            }
            if(!hasError) {
                component.set("v.activeTabNumber", tabName);
				component.set("v.caseRecs.Billing_Address_Province__c", provincePicklistValue); // CSM-14706 Mike Verdad 12/04/2017
                if(stepNumber < activeTabNumber2){
                   component.set("v.stepNumber", 4);
                }
                helper.displayTabFromButton(component, event, helper);   
            }
            
            
        }else{
            
            component.set("v.activeTabNumber", tabName);
            component.set("v.stepNumber", tabName);
            helper.displayTabFromButton(component, event, helper);
            
        }
  
    },
    
     onClickNextTab4 : function(component, event, helper) {   
       
        component.find("reactSubmitBtn").set("v.disabled", true);
        helper.submitRecontract(component, event, helper);
       
    },
    
    
    onSelectNotification : function(component, event, helper) {
        
        var isEmail = component.find("emailModify_t2React").getElement().checked;
        var preferredMode = isEmail ? "Email" : "None";
            
        component.set("v.caseRecs.Preferred_Mode_of_Notification__c", preferredMode);
    },
    
    onCheck: function(component, event, helper) {
        var cmpBtn = component.find("reactSubmitBtn");
        cmpBtn.set("v.disabled",!event.getSource().get("v.value"));
    },
    
    onClickBackToHome : function(component, event, helper) {
		helper.goToHomePage(component, event, helper);
	},

    onChangeRelationToOwner : function(component, event, helper) {
        var selected = component.find("selectedRelationToOwner").get("v.value");
        component.set("v.caseRecs.Relationship__c", selected);
      
    },
    /*
    onChangeResidential : function(component, event, helper){
        component.set("v.isCheckedResidential", true);
        var onChangeResidential = component.get("v.isCheckedResidential");      
        
        component.set("v.caseRecs.Application_for_Residential_Customer__c", true);
        component.set("v.caseRecs.Application_for_Residential_Service__c", true);
       
        helper.onChangeResidentialHelper(component, event, helper);    
    },
    */
    
    onChangeResidential : function(component, event, helper){
        component.set("v.isCheckedResidential", true);
        component.set("v.isResidential", true);
        component.set("v.isBusiness", false);
        component.set("v.caseRecord.Application_for_Residential_Customer__c", true);
        component.set("v.caseRecord.Application_for_Residential_Service__c", true);
        
        component.set("v.caseRecord.Application_for_Business_Customer__c", false);
        component.set("v.caseRecord.Application_for_Business_Service__c", false);
       
        helper.onChangeResidentialHelper(component, event, helper);    
    },
    
    /*
    onChangeBusiness : function(component, event, helper){
        component.set("v.isCheckedResidential", false);
        
        var onChangeBusiness = component.get("v.isCheckedResidential"); 
        
        component.set("v.caseRecs.Application_for_Business_Customer__c", true);
        component.set("v.caseRecs.Application_for_Business_Service__c", true);
    
        helper.onChangeBusinessHelper(component, event, helper);    
    },
    */
    onChangeBusiness : function(component, event, helper){
        component.set("v.isCheckedResidential", false);
        component.set("v.isResidential", false);
        component.set("v.isBusiness", true);
        component.set("v.caseRecord.Application_for_Business_Customer__c", true);
        component.set("v.caseRecord.Application_for_Business_Service__c", true);
        
        component.set("v.caseRecord.Application_for_Residential_Customer__c", false);
        component.set("v.caseRecord.Application_for_Residential_Service__c", false);
    
        helper.onChangeBusinessHelper(component, event, helper);    
    },
    
    onClickSameAsServiceYes : function(component, event) {        
        var selected = true
        var serviceAddress = component.find("ContractorServiceAddress").get("v.value"); 
        var serviceProvince = component.get("v.billingAddProvinceReact");
        var serviceCity = component.get("v.billingAddCityReact");
        
        component.set("v.caseRecord.Same_As_Service_Address__c", selected);
        component.set("v.isSame", selected);
        
        component.set("v.caseRecord.Address_2__c", serviceAddress);
        component.set("v.caseRecord.Billing_Address_Province__c", serviceProvince);
        component.set("v.caseRecord.Billing_Address_City_Municipal__c", serviceCity);
        
    },
    
    onClickSameAsServiceNo : function(component, event) {        
        var selected = false;
        component.set("v.caseRecord.Same_As_Service_Address__c", selected);
        component.set("v.isSame", selected);
        
        component.set("v.caseRecord.Address_2__c", null);
        component.set("v.caseRecord.Billing_Address_Province__c", null);
        component.set("v.caseRecord.Billing_Address_City_Municipal__c", null);
    },
    
    getControllingPicklistService : function(cmp, event) {        
        cmp.set("v.caseRecs.Service_Address_Province__c", event.getParam("controllingPicklist"));
        console.log('getControllingPicklistService: '+ cmp.get("v.caseRecs.Service_Address_Province__c"));
    },

    getDependentPicklistService : function(cmp, event) {
        cmp.set("v.caseRecs.Service_Address_City_Municiple__c", event.getParam("dependentPicklist"));
        console.log('getDependentPicklistService: '+ cmp.get("v.caseRecs.Service_Address_City_Municiple__c"));
    },

    getControllingPicklistBusiness1 : function(cmp, event) { 
       // cmp.set("v.billingAddProvince", event.getParam("businessProvince"));  // CSM-14706 Mike Verdad 12/04/2017      
        cmp.set("v.caseRecs.Billing_Address_Province__c", event.getParam("businessProvinceContractor"));
        console.log('B1: '+component.get("v.caseRecord.Billing_Address_Province__c"));
    },

    getDependentPicklistBusiness2 : function(cmp, event) {
        cmp.set("v.caseRecs.Billing_Address_City_Municipal__c", event.getParam("businessCityContractor"));
        cmp.set("v.dependentPicklistValue", event.getParam("businessCityContractor"));
        console.log('getControllingPicklistBusiness'+ cmp.get("v.caseRecs.Billing_Address_City_Municipal__c"));
    },
    
    onClickTab : function(component, event, helper) {
        component.set("v.isNextClicked",false);
        helper.displayTab(component, event, helper);
    },
    
   	passEventmessagetoParent : function(component, event, helper){
        console.log('IN PARENT'); 
    },
  
 })