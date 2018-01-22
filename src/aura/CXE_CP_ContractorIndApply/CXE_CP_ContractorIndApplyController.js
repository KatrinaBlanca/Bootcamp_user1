({
    
    doInit : function(component, event, helper){
        helper.initializeCase(component, event, helper);    
    },

    onClickTab : function(component, event, helper) {
        helper.displayTab(component, event, helper);
    },

    getSubmittedCase: function(component, event, helper) {
        var eventValue= event.getParam("submittedCase");
        component.set("v.caseRecord", eventValue);
    },

    read: function(cmp, evt, h){
        var files = Array.from(document.getElementById('file-upload').files);
        cmp.set("v.files", files.map(function(e){return e.name;}));
        console.log("FILES", files)
    },

    onClickNext : function(component, event, helper) {

        var isResidential = component.get("v.isResidential");
        //Start CSM-XXXX Ed Eisma 11/09/2017
        var stepNumber = component.get("v.stepNumber");
        var activeTabNumber = component.get("v.activeTabNumber");
        if(stepNumber == 3){
            component.set("v.showRequired", false);
        }
		//End CSM-XXXX Ed Eisma 11/09/2017

        if(isResidential == true && activeTabNumber == 3){
            var ind_homeowneship = component.find("ind_homeowneship").get("v.value"); 
                component.set("v.caseRecord.Home_Ownership__c", ind_homeowneship); 
          
         }else{
          component.set("v.caseRecord.Home_Ownership__c", null);  
        }
        var contractor= "Contractor";
        component.set("v.caseRecord.Relationship__c", contractor);
        helper.displayTabByButton(component, event, helper);
    },

    getControllingPicklistService : function(cmp, event) {        
        cmp.set("v.caseRecord.Service_Address_Province__c", event.getParam("serviceProvince"));
        console.log('A1: '+cmp.get("v.caseRecord.Service_Address_Province__c"));
    },

    getDependentPicklistService : function(cmp, event) {
        cmp.set("v.caseRecord.Service_Address_City_Municiple__c", event.getParam("serviceCity"));
        console.log('A2: '+cmp.get("v.caseRecord.Service_Address_City_Municiple__c"));
    },

    getControllingPicklistBusiness : function(component, event) {
		component.set("v.billingAddProvince", event.getParam("businessProvince"));        
        component.set("v.caseRecord.Billing_Address_Province__c", event.getParam("businessProvince"));
        console.log('B1: '+component.get("v.caseRecord.Billing_Address_Province__c"));
    },

    getDependentPicklistBusiness : function(component, event) {
        component.set("v.billingAddCity", event.getParam("businessCity"));
        component.set("v.caseRecord.Billing_Address_City_Municipal__c", event.getParam("businessCity"));
        console.log('B2: '+component.get("v.caseRecord.Billing_Address_City_Municipal__c"));
    },

    onClickSameAsServiceYes : function(component, event) {        
        var selected = true;
        var serviceAddress = component.find("newContractorServiceAddress").get("v.value"); 
        var serviceProvince = component.get("v.billingAddProvince");
        var serviceCity = component.get("v.billingAddCity");
        
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

    onClickAMC : function(component, event, helper) {
        var hasAMC = component.find("amcModify").getElement().checked;
        if(hasAMC) {
            helper.showCmp(component, "amcNotifModify");
        } else {
            helper.hideCmp(component, "amcNotifModify");
        }
        component.set("v.caseRecord.AMC_Service_Tag__c", hasAMC);
    },

    onSelectNotification : function(component, event, helper) {
        //var isSMS = component.find("smsModify").getElement().checked;
        var isEmail = component.find("emailModify").getElement().checked;
        //var isBoth = component.find("noneModify").getElement().checked;
        //var preferredMode = ( isSMS ? "SMS" : ( isEmail ? "Email" : ( isBoth ? "None" : "" ) ) );
        
        var preferredMode = isEmail ? "Email" : "None";
        //alert('preferredMode: '+preferredMode);
        //component.set("v.caseVar.Automatically_receive_SMS__c", (isSMS || isBoth ));
        //component.set("v.caseVar.Automatically_receive_an_e_mail__c", (isEmail || isBoth));      
        component.set("v.caseRecord.Preferred_Mode_of_Notification__c", preferredMode);
    },

    onClickPaperless : function(component, event, helper) {
        var isPaperless = component.find("paperlessTag").getElement().checked;
        component.set("v.caseRecord.CXE_Enroll_to_Paperless_Billing__c", isPaperless);
    },
    
    onClickAPA : function(component, event, helper) {
        var isAPA = component.find("apaRadio").getElement().checked;
        component.set("v.caseRecord.CXE_Interested_in_Other_Payment_Methods__c", isPaperless);
    },

    onSubmit : function(component, event, helper) {

        //component.find("termsACBtn").set("v.disabled", true);
        helper.submitStartService(component, event, helper);
    },

   
    
    enableSubmitBtn : function(component, event, helper) {   
        
        var yes =document.getElementById("agreeCheckbox").checked;     
       
        if(yes == true){  
             
            component.find("termsACButton").set("v.disabled", false);             
        } else {  
             
            component.find("termsACButton").set("v.disabled", true);             
        }
    },

    onClickHasAppliedForSomeone : function(component, event) {        
        var selected = component.find("hasAppliedForSomeone").getElement().checked;
        console.log(">>>>>>>>>>>>>" + selected);
        component.set("v.caseRecord.Has_Applied_for_Someone__c", selected);
        component.set("v.isApplyingForSomeone", selected);
        if(selected == false){
            component.set("v.caseRecord.Authorized_Representative_First_Name__c", '');
            component.set("v.caseRecord.Authorized_Representative_Middle_Name__c", '');
            component.set("v.caseRecord.Authorized_Representative_Last_Name__c", '');
            component.set("v.caseRecord.Authorized_Representative_Email__c", '');
            component.set("v.caseRecord.Authorized_Rep_Primary_Contact_Number__c", '');
            component.set("v.caseRecord.Relationship__c", '--- None ---');
        }
    },

    upload_file_change: function(c, e, h){
        c.set("v.invalid_file", e.getParam("invalid"));
    },
    
    upload_progress_change: function(c, e, h){
        c.set("v.upload_progress", e.getParam("progress"));

        if(e.getParam("complete")){
            c.find("termsACBtn").set("v.disabled", false);
            // h.displayTab3(c, e, h);
            h.displaySpecific(c, e, h, "5");
        }
    },

   onChangeResidential : function(component, event, helper){
        component.set("v.isResidential", true);
        component.set("v.isBusiness", false);
        component.set("v.caseRecord.Application_for_Residential_Customer__c", true);
        component.set("v.caseRecord.Application_for_Residential_Service__c", true);
       
        // Start CSM-14751 Mike Verdad 12/04/2017
        component.set("v.caseRecord.Application_for_Business_Customer__c", false);
        component.set("v.caseRecord.Application_for_Business_Service__c", false);
        // End CSM-14751 Mike Verdad 12/04/2017
       
        helper.onChangeResidentialHelper(component, event, helper);    
    },
    
    
    onChangeBusiness : function(component, event, helper){
        component.set("v.isResidential", false);
        component.set("v.isBusiness", true);
        component.set("v.caseRecord.Application_for_Business_Customer__c", true);
        component.set("v.caseRecord.Application_for_Business_Service__c", true);
        
        // Start CSM-14751 Mike Verdad 12/04/2017
        component.set("v.caseRecord.Application_for_Residential_Customer__c", false);
        component.set("v.caseRecord.Application_for_Residential_Service__c", false);
        // End CSM-14751 Mike Verdad 12/04/2017
        
        helper.onChangeBusinessHelper(component, event, helper);    
    },
    
    hideLandNumError : function(component, event, helper) {
        helper.helperHideLandNumError(component, event, helper);
    },
    
    onClickBackToHome : function(component, event, helper) {
		helper.goToHomePage(component, event, helper);
	},
    
    getControllingPicklistBusiness1 : function(cmp, event) { 
        var provincePicklistValue = component.get("v.provincePicklistValue");
        cmp.set("v.caseRecord.Billing_Address_Province__c", provincePicklistValue);

        console.log('getControllingPicklistBusiness: ' + cmp.get("v.caseRecord.Billing_Address_Province__c"));
    },

    getDependentPicklistBusiness2 : function(cmp, event) {
        cmp.set("v.caseRecord.Billing_Address_City_Municipal__c", event.getParam("businessCityContractor"));
        cmp.set("v.dependentPicklistValue", event.getParam("businessCityContractor"));
        console.log('getControllingPicklistBusiness'+ cmp.get("v.caseRecord.Billing_Address_City_Municipal__c"));
    },
    
     onSelectChange : function(component, event, helper) {
		helper.onSelectChangeHelper(component, event, helper);
	},
 
   
})