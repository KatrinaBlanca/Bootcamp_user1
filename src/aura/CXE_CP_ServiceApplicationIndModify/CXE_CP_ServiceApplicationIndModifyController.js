({
    // setTab : function(component, event, helper) {
    //  //get data-aura-id of event Source
 //        var auraId = event.currentTarget.dataset.auraId;
        
 //        //set clicked tab to active
 //        var setActiveTab = event.currentTarget.parentNode;
        
 //        //get current active tabs
 //        var currentActive = document.getElementsByClassName('active');
        
 //        //set value of tabToShow attrib to id of event Source
 //        //this will show the contents of the tab (rendered component)
 //        component.set("v.tabToShow", auraId);
        
 //        //remove active class to tabs
 //        $A.util.removeClass(currentActive[0], 'active');
        
 //        //add active class to currently selected tab
 //        $A.util.addClass(setActiveTab, 'active');

    // },
    doInit : function(component, event, helper){
        helper.initializeCase(component, event, helper);    
        helper.getServiceModificationOptions(component, event, helper);
        helper.getContractModificationOptions(component, event, helper);
        helper.getRelationshipToCustomer(component, event, helper);
    },
    
    changeTabUsingButton: function(component, event, helper) {
        var eventValue= event.getParam("param1");
        if(component.get("v.activeTabNumber") != eventValue) {
            component.set("v.activeTabNumber", eventValue);
            component.set("v.tabToShow", eventValue);
            helper.displayTabFromButton(component, event, helper);
        }
    },

    getSubmittedCase: function(component, event, helper) {
        var eventValue= event.getParam("submittedCase");
        component.set("v.caseRecord", eventValue);
    },

    onClickTab : function(component, event, helper) {
        helper.displayTab(component, event, helper);
    },

    read: function(cmp, evt, h){
        var files = Array.from(document.getElementById('file-upload-modify').files);
        cmp.set("v.files", files.map(function(e){return e.name;}));
        // console.log("FILES", files)
    },

    onClickNextTab1 : function(component, event, helper) {   
        var hasError = helper.validateTab1(component, event, helper);
        var tabName = "2";
        if(!hasError) {
            component.set("v.activeTabNumber", tabName);
            component.set("v.tabToShow", tabName);
            helper.displayTabFromButton(component, event, helper);
        }
    },

    onClickNextTab2 : function(component, event, helper) {   
        var hasError = helper.validateTab2(component, event, helper);
        var tabName = "3";
        if(!hasError) {
            component.set("v.activeTabNumber", tabName);
            component.set("v.tabToShow", tabName);
            helper.displayTabFromButton(component, event, helper);
        }
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
        component.set("v.caseRecord.CXE_Service_Request_s__c", selected);
    },

    onContractRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseRecord.CXE_Service_Request_s__c", selected);
    },

    onChangeRelationToOwner : function(component, event, helper) {
        var selected = component.find("selectedRelationToOwner").get("v.value");
        component.set("v.caseRecord.Relationship__c", selected);
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
        var isSMS = component.find("smsModify").getElement().checked;
        var isEmail = component.find("emailModify").getElement().checked;
        var isBoth = component.find("bothModify").getElement().checked;
        var preferredMode = ( isSMS ? "SMS" : ( isEmail ? "Email" : ( isBoth ? "SMS & Email" : "" ) ) );
        component.set("v.caseRecord.Automatically_receive_SMS__c", (isSMS || isBoth ));
        component.set("v.caseRecord.Automatically_receive_an_e_mail__c", (isEmail || isBoth));      
        component.set("v.caseRecord.Preferred_Mode_of_Notification__c", preferredMode);
    },

    onClickNextTab3 : function(component, event, helper) {   
        var tabName = "4";
        component.set("v.activeTabNumber", tabName);
        component.set("v.tabToShow", tabName);
        helper.displayTabFromButton(component, event, helper);
    },

    onSubmit : function(component, event, helper) {        
        component.find("modifySubmitBtn").set("v.disabled", true);
        helper.submitModify(component, event, helper);
    },

    onCheck: function(component, event, helper) {
        var cmpBtn = component.find("modifySubmitBtn");
        cmpBtn.set("v.disabled",!event.getSource().get("v.value"));
    },

    upload_file_change: function(c, e, h){
        c.set("v.invalid_file", e.getParam("invalid"));
    },
    
    upload_progress_change: function(c, e, h){
        c.set("v.upload_progress", e.getParam("progress"));

        if(e.getParam("complete")){
            c.find("modifySubmitBtn").set("v.disabled", false);
            // h.displayTab3(c, e, h);
            h.displaySpecific(c, e, h, "5");
        }
    },
    //START Breadcrumb-task Rabayon SEPT-25-17
    redirectToHome : function (component, event, helper){
        helper.goToHome(component, event, helper);
    },
    redirectToRequests : function (component, event, helper){
        helper.goToRequests(component, event, helper);
    }
    //END Breadcrumb-task Rabayon SEPT-25-17
	
})