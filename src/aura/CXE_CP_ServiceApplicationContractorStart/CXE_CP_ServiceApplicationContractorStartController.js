({
    
    doInit : function(component, event, helper){
        helper.initializeCase(component, event, helper);    
    },
    
    setTab1 : function(component, event, helper) {
        var SELECTED_TAB = 1;
        helper.tabManager(component, event, helper, SELECTED_TAB);
    },
    setTab2 : function(component, event, helper) {
        var SELECTED_TAB = 2;
        helper.tabManager(component, event, helper, SELECTED_TAB);
    },
    setTab3 : function(component, event, helper) {
        var SELECTED_TAB = 3;
        helper.tabManager(component, event, helper, SELECTED_TAB);
    },
    setTab4 : function(component, event, helper) {
        var SELECTED_TAB = 4;
        helper.tabManager(component, event, helper, SELECTED_TAB);
    },

    changeTab: function(component, event, helper){
        console.log('>>>>>>>>>>>>>>>>>>> changeTab ');
        var tabAv = component.get("v.tabNumAvailable");
        var eventParam= event.getParam("param1");
   
        if(tabAv<eventParam){
            component.set("v.tabNumAvailable", eventParam);
        }
        helper.changeActiveTab(component, eventParam);
    },

    changeTabUsingButton: function(component, event, helper) {
        var eventValue= event.getParam("param1");
        component.set("v.activeTabNumber", eventValue);
        component.set("v.tabToShow", eventValue);
        
        helper.displayTabFromButton(component, event, helper);
    },

    onClickTab : function(component, event, helper) {
        helper.displayTab(component, event, helper);
    },

    getSubmittedCase: function(component, event, helper) {
        var eventValue= event.getParam("submittedCase");
        component.set("v.caseVar", eventValue);
    },

    read: function(cmp, evt, h){
        var files = Array.from(document.getElementById('file-upload').files);
        cmp.set("v.files", files.map(function(e){return e.name;}));
        console.log("FILES", files)
    },

    onClickNext : function(component, event, helper) {   
        helper.displayTabByButton(component, event, helper);
    },

    getControllingPicklistService : function(cmp, event) {        
        cmp.set("v.caseVar.Service_Address_Province__c", event.getParam("controllingPicklist"));
        console.log(cmp.get("v.caseVar.Service_Address_Province__c"));
    },

    getDependentPicklistService : function(cmp, event) {
        cmp.set("v.caseVar.Service_Address_City_Municiple__c", event.getParam("dependentPicklist"));
        console.log(cmp.get("v.caseVar.Service_Address_City_Municiple__c"));
    },

    getControllingPicklistBusiness : function(cmp, event) {        
        cmp.set("v.caseVar.Billing_Address_Province__c", event.getParam("businessProvince"));
        console.log(cmp.get("v.caseVar.Billing_Address_Province__c"));
    },

    getDependentPicklistBusiness : function(cmp, event) {
        cmp.set("v.caseVar.Billing_Address_City_Municipal__c", event.getParam("businessCity"));
        console.log(cmp.get("v.caseVar.Billing_Address_City_Municipal__c"));
    },

    onClickSameAsService : function(component, event) {        
        var selected = component.find("isSameAsService").getElement().checked;
        component.set("v.caseVar.Same_As_Service_Address__c", selected);
        component.set("v.isSame", selected);
    },

    onClickAMC : function(component, event, helper) {
        var hasAMC = component.find("amcModify").getElement().checked;
        if(hasAMC) {
            helper.showCmp(component, "amcNotifModify");
        } else {
            helper.hideCmp(component, "amcNotifModify");
        }
        component.set("v.caseVar.AMC_Service_Tag__c", hasAMC);
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
        component.set("v.caseVar.Preferred_Mode_of_Notification__c", preferredMode);
    },

    onClickPaperless : function(component, event, helper) {
        var isPaperless = component.find("paperlessTag").getElement().checked;
        component.set("v.caseVar.CXE_Enroll_to_Paperless_Billing__c", isPaperless);
    },
    
    onClickAPA : function(component, event, helper) {
        var isAPA = component.find("apaRadio").getElement().checked;
        component.set("v.caseVar.CXE_Interested_in_Other_Payment_Methods__c", isPaperless);
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
        component.set("v.caseVar.Has_Applied_for_Someone__c", selected);
        component.set("v.isApplyingForSomeone", selected);
        if(selected == false){
            component.set("v.caseVar.Authorized_Representative_First_Name__c", '');
            component.set("v.caseVar.Authorized_Representative_Middle_Name__c", '');
            component.set("v.caseVar.Authorized_Representative_Last_Name__c", '');
            component.set("v.caseVar.Authorized_Representative_Email__c", '');
            component.set("v.caseVar.Authorized_Rep_Primary_Contact_Number__c", '');
            component.set("v.caseVar.Relationship__c", '--- None ---');
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
       
        helper.onChangeResidentialHelper(component, event, helper);    
    },
    
    
    onChangeBusiness : function(component, event, helper){
        component.set("v.isResidential", false);
        component.set("v.isBusiness", true);
        component.set("v.caseRecord.Application_for_Business_Customer__c", true);
        component.set("v.caseRecord.Application_for_Business_Service__c", true);
    
        helper.onChangeBusinessHelper(component, event, helper);    
    },
    
    hideLandNumError : function(component, event, helper) {
        helper.helperHideLandNumError(component, event, helper);
    },

})