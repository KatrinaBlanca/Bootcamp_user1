({
    //Tab 1
    onServiceRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseVar.CXE_Service_Request_s__c", selected);
        console.log(component.get("v.caseVar.CXE_Service_Request_s__c"));
    },

    onSelectRequestType : function(component, event, helper) {
        var isServiceMod = component.find("isServiceModification").getElement().checked;
        component.set("v.changeService", isServiceMod);
        component.set("v.showRequestOptions", true);
    },
    
    //Tab 2
    onClickAMC : function(component, event, helper) {
        var hasAMC = component.find("amc").getElement().checked;
        console.log('hasAMC: '+hasAMC);
        
        if(hasAMC) {
            var cmpTarget = component.find("amcNotif");
            $A.util.removeClass(cmpTarget, 'slds-hide');
            $A.util.addClass(cmpTarget, 'slds-show');
        } else {
            var cmpTarget = component.find("amcNotif");
            $A.util.addClass(cmpTarget, 'slds-hide');
            $A.util.removeClass(cmpTarget, 'slds-show');
        }
        component.set("v.caseVar.AMC_Service_Tag__c", hasAMC);
        //alert(hasAMC);

    },
    onSelectNotification : function(component, event, helper) {
        var isSMS = component.find("sms").getElement().checked;
        var isEmail = component.find("email").getElement().checked;
        var isBoth = component.find("both").getElement().checked;
        
        var preferredMode = ( isSMS ? "SMS" : ( isEmail ? "Email" : ( isBoth ? "SMS & Email" : "" ) ) );
        component.set("v.caseVar.Automatically_receive_SMS__c", (isSMS || isBoth ));
        component.set("v.caseVar.Automatically_receive_an_e_mail__c", (isEmail || isBoth));     
        component.set("v.caseVar.Preferred_Mode_of_Notification__c", preferredMode);
        
        console.log('preferred mode: '+preferredMode);
        //alert(preferredMode);
    },
    
    //Tab 3
    enableSubmitBtn1 : function(component, event, helper) {    
        var yes =document.getElementById("agreeChkbx1").checked; 
        if(yes == true){           
            component.find("termsACBtn1").set("v.disabled", false);    
        } else {        
            component.find("termsACBtn1").set("v.disabled", true);  
        } 
    },
    enableSubmitBtn2 : function(component, event, helper) {    
        var yes =document.getElementById("agreeChkbx2").checked; 
        if(yes == true){           
            component.find("termsACBtn2").set("v.disabled", false);    
        } else {        
            component.find("termsACBtn2").set("v.disabled", true);  
        } 
    },
    /*
    enableSubmitBtnChangeService : function(component, event, helper) {    
        var yes =document.getElementById("checkbox-1").checked; 
        if(yes == true){           
            component.find("termsACBtn1").set("v.disabled", false);    
        } else {        
            component.find("termsACBtn1").set("v.disabled", true);  
        } 
    },
    enableSubmitBtnChangeContract : function(component, event, helper) {    
        var yes =document.getElementById("checkbox-2").checked; 
        if(yes == true){           
            component.find("termsACBtn2").set("v.disabled", false);    
        } else {        
            component.find("termsACBtn2").set("v.disabled", true);  
        } 
    },
    */
    submitTab : function(component, event, helper) {
        component.find("termsACBtn1").set("v.disabled", true);
        component.find("termsACBtn2").set("v.disabled", true);
        helper.submitModification(component, event, helper);
    },
    
    //Calling method from Helper - Navigation thru Tab
	onClickTab : function(component, event, helper) {
        helper.displayTab(component, event, helper);
    },
    
    //Calling method from Helper - Navigation thru Button
    onClickBtnTab1ChangeService : function(component, event, helper) {   
        var hasError = helper.validateTab1(component, event, helper);
        var tabName = "2";
        if(!hasError) {
            component.set("v.activeTabNumber", tabName);
            component.set("v.tabToShow", tabName);
            helper.displayTabFromButtonChangeService(component, event, helper);
        }
    },
    
    onClickBtnTab1ChangeContract : function(component, event, helper) {   
        var hasError = helper.validateTab1(component, event, helper);
        var tabName = "2";
        if(!hasError) {
            component.set("v.activeTabNumber", tabName);
            component.set("v.tabToShow", tabName);
            helper.displayTabFromButtonChangeContract(component, event, helper);
        }
    },
    
    onClickBtnTab2ChangeService : function(component, event, helper) {   
        //var hasError = helper.validateTab2(component, event, helper);
        var hasError = false;
        var tabName = "3";
        if(!hasError) {
            component.set("v.activeTabNumber", tabName);
            component.set("v.tabToShow", tabName);
            helper.displayTabFromButtonChangeService(component, event, helper);
        }
    },
    
    onClickBtnTab2ChangeContract : function(component, event, helper) {   
        //var hasError = helper.validateTab2(component, event, helper);
        var hasError = false;
        var tabName = "3";
        if(!hasError) {
            component.set("v.activeTabNumber", tabName);
            component.set("v.tabToShow", tabName);
            helper.displayTabFromButtonChangeContract(component, event, helper);
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
    }
})