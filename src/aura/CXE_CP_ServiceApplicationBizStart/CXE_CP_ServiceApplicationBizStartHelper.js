({
    tabManager : function(component, event, helper, selectedTab) { 
        var SELECTED_TAB = selectedTab;
        var currentTab = component.get("v.currentTab");
        var tabNumLock = component.get("v.tabNumLock");
        var tabNumAvailable = component.get("v.tabNumAvailable");

        if( (tabNumAvailable>=SELECTED_TAB || currentTab>SELECTED_TAB) && currentTab!=tabNumLock){
            helper.changeActiveTab(component, SELECTED_TAB);
        }
        else if(currentTab<SELECTED_TAB){
            helper.checkLockTab(component, event, helper, "cmpTab"+currentTab);
        }
    },

    changeActiveTab : function(component, selectedTab) { 
        // console.log('>>>>>>>>>>>>>>>>>>>> selectedTab: '+selectedTab);
        // console.log('>>>>>>>>>>>>>>>>>>>> component.get("v.tabNumAvailable"): '+component.get("v.tabNumAvailable"));
        if(component.get("v.tabNumAvailable")>=selectedTab){  
            component.set("v.tabToShow", "serviceAppBizStartTab"+selectedTab);
            component.set("v.currentTab", selectedTab);
            var setActiveTab = document.getElementById("tab"+selectedTab);
            var currentActive = document.getElementsByClassName('slds-is-active');
            $A.util.removeClass(currentActive[0], 'slds-is-active');
            $A.util.addClass(setActiveTab, 'slds-is-active');     
        } 
    },

    checkLockTab : function(component, event, helper, compName) {       
        var tabNumLock = component.get("v.tabNumLock");
        var tabNumAvailable = component.get("v.tabNumAvailable");
        // console.log('>>>>>>>>>>>>>>>>>>>> tabNumAvailable: '+tabNumAvailable);
        // console.log('>>>>>>>>>>>>>>>>>>>> compName: '+compName);
        if(tabNumAvailable<tabNumLock){
            var childCmp = component.find(compName);
            childCmp.submitTab(component, event, helper);
        }
    },

    initializeCase : function(component, event, helper) {
        var initAction = component.get("c.initNewCase");
        initAction.setCallback(self, function(a) {
            component.set("v.caseVar", a.getReturnValue());
        });
        $A.enqueueAction(initAction);
    },

    // display : function(component, event, helper, className) {
    //     //get data-aura-id of event Source
    //     var auraId = event.currentTarget.dataset.auraId;
        
    //     //set clicked tab to active
    //     var setActiveTab = event.currentTarget.parentNode;
    //     // alert(setActiveTab);
    //     var activeTabNumber = component.get("v.activeTabNumber");
    //     var className = className + activeTabNumber;

    //     //get current active tabs
    //     var currentActive = document.getElementsByClassName(className);
    //     //set value of tabToShow attrib to id of event Source
    //     //this will show the contents of the tab (rendered component)
    //     component.set("v.tabToShow", auraId);
    //     //remove active class to tabs
    //     $A.util.removeClass(currentActive[0], "slds-is-active");
        
    //     //add active class to currently selected tab
    //     $A.util.addClass(setActiveTab, "slds-is-active");

    //     helper.toggleTab(component, activeTabNumber);
    //     helper.toggleTab(component, auraId);
    // },

    displaySpecific : function(component, event, helper, target) {
        var className = "start-tab-";
        // var deactivateTab = (component.get("v.activeTabNumber") != component.get("v.tabToShow")) ? activeTab - 1 : activeTab;
        
        var activateClassName = className + target;
        
        //get current active tabs
        var currentActive = document.getElementsByClassName(className + component.get("v.activeTabNumber"));
        
        // alert
        var setActiveTab = document.getElementsByClassName(activateClassName);
        //set value of tabToShow attrib to id of event Source
        //this will show the contents of the tab (rendered component)
        
        //remove active class to tabs
        $A.util.removeClass(currentActive[0], "slds-is-active");
        
        //add active class to currently selected tab
        $A.util.addClass(setActiveTab[0], "slds-is-active");
        helper.hideTab(component, component.get("v.activeTabNumber"));
        helper.showTab(component, target);
        component.set("v.activeTabNumber", target);
        component.set("v.tabToShow", target);        
    },

    displayTab : function(component, event, helper) {        
        var activeTabNumber = component.get("v.activeTabNumber");
        var hasError = false;
        var clickedTab = event.currentTarget.dataset.auraId;

        var tabDisplay = activeTabNumber;

        if(component.get("v.hasSubmitted")){
            return;
        }

        if(activeTabNumber == '1') {
            hasError = helper.validateTab1(component, event, helper);
            if(!hasError) {
                tabDisplay = clickedTab;
            }
        } else {
            tabDisplay = clickedTab;
        }

        helper.displaySpecific(component, event, helper, tabDisplay);
             
    },

    displayTabByButton : function(component, event, helper) {        
        var activeTabNumber = component.get("v.activeTabNumber");
        var hasError = false;

        var tabDisplay = activeTabNumber;

        if(component.get("v.hasSubmitted")){
            return;
        }

        if(activeTabNumber == '1') {
            hasError = helper.validateTab1(component, event, helper);
            if(!hasError) {
                tabDisplay = +activeTabNumber + 1;
            }
        } else {
            tabDisplay = +activeTabNumber + 1;
        }

        helper.displaySpecific(component, event, helper, tabDisplay);
    },

    showTab : function(component, auraId) {
        var cmpTarget = "cmpTabDiv" + auraId;
        $A.util.addClass(component.find(cmpTarget), "slds-show");
        $A.util.removeClass(component.find(cmpTarget), "slds-hide");
    },

    hideTab : function(component, auraId) {
        var cmpTarget = "cmpTabDiv" + auraId;
        $A.util.removeClass(component.find(cmpTarget), "slds-show");
        $A.util.addClass(component.find(cmpTarget), "slds-hide");
    },

    validateTab1 : function(component, event, helper) {

        var list;
        // var isOnBehalfOf = component.get("v.isApplyingOnBehalfOf");
        // component.set("v.caseRecord.Has_Applied_for_Someone__c", isOnBehalfOf);
        var persona = component.get("v.persona");
        //START RReyes - set list for Ind
        if(persona === "Biz") {
            list = ["biz_company", "biz_landline", "biz_fname", "biz_lname", "biz_pEmail", "biz_mobile", "biz_desig"];
        }
        else if(persona === "Ind") {
            var hasRep = component.get("v.isApplyingForSomeone");
            if(hasRep){
                list = ["ind_fname", "ind_lname", "ind_pEmail", "ind_mobile", "ind_landline", "ind_bday", "ind_repfname", "ind_replname", "ind_repEmail", "ind_repmobile", "ind_relationship"];
            }else{
                list = ["ind_fname", "ind_lname", "ind_pEmail", "ind_mobile", "ind_landline", "ind_bday"];
            }
        }
        //END RReyes - set list for Ind
        var hasError = this.hasErrorOnFieldList(component, helper, list);
        return hasError;
    },

    hasErrorOnFieldList: function(component, helper, list) {
        var ctr = 0;

        if(list) {
            var i = 0;
            for (i = 0; i < list.length; i++) {                
                if(this.isFieldUndefined(component.find(list[i])) ) {
                    ctr++;
                    continue;
                }
                if(this.hasInvalidFormat(component.find(list[i]), list[i])) {
                    ctr++;
                }
            }
        }

        

        return (ctr > 0);
    },

    isFieldUndefined : function(cmpTarget) {
        if($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value"))){            
            cmpTarget.set("v.errors", [{message:"Please indicate your  " + cmpTarget.get("v.label") + "."}]);
            return true;        
        } else {
            cmpTarget.set("v.errors",null);
            return false;
        }
    },    

    hasInvalidEmailFormat : function (cmpTarget) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var errorMessage = "Please enter a valid email address.";
        if(!cmpTarget.get("v.value").match(regExpEmailformat)){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },

    hasInvalidMobileFormat : function (cmpTarget) {
        var regexMobileFormat = /(\+639)[0-9]{9}/;
        var errorMessage = "Please input your mobile number in the format +639XXXXXXXXX.";
        if(!cmpTarget.get("v.value").match(regexMobileFormat)){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },
    // Start CSM-14247 Mike Verdad 11/06/2017
    hasInvalidLandlineFormat : function (cmpTarget) {
        // var regexLandlineFormat = /(\+632)[0-9]{7}/;
        // var errorMessage = "Please input your landline in the format +632XXXXXXX.";
        var regexLandlineFormat = /(\+63)[0-9]?[0-9]{8}/;
        var errorMessage = "Phone should start with +63 then followed by 1 to 2-digit area code and 7-digit number.";
        var isUndefined = ($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value")));
        if(!isUndefined && !cmpTarget.get("v.value").match(regexLandlineFormat)){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },
    // End CSM-14247 Mike Verdad 11/06/2017

   hasInvalidFormat : function (cmpTarget, auraId) {
        var isInvalid = false;
        if(auraId === "biz_pEmail" || auraId === "ind_pEmail" || auraId === "ind_repEmail"){
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
        }
        
        if(auraId === "biz_mobile" || auraId === "ind_mobile" || auraId === "ind_repmobile"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }

        if(auraId === "biz_landline" || auraId === "ind_landline"){
            isInvalid = this.hasInvalidLandlineFormat(cmpTarget);
        }

        if(auraId === "ind_bday"){
            isInvalid = this.hasInvalidBirthday(cmpTarget);
        }
        return isInvalid;
    },

    hasInvalidBirthday : function (cmpTarget) {
        var errorMessage = "You cannot select a future date as your Birthday.";
        var isUndefined = ($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value")));

        if(!isUndefined){
            var today = new Date();
            var bday = new Date(cmpTarget.get("v.value"));
            
            if(bday > today){
                cmpTarget.set("v.errors", [{message:errorMessage}]);
                return true;
            }else{
                return false;
            } 
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },

    showCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.removeClass(cmpTarget, 'slds-hide');
        $A.util.addClass(cmpTarget, 'slds-show');
    },

    hideCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.addClass(cmpTarget, 'slds-hide');
        $A.util.removeClass(cmpTarget, 'slds-show');
    },

    submitStartService : function(component, event, helper) {
        var arg = {
            fname: component.get("v.caseVar.CXE_Web_First_Name__c")
            , mname: component.get("v.caseVar.CXE_Web_Middle_Name__c")
            , lname: component.get("v.caseVar.CXE_Web_Last_Name__c")
            , email: component.get("v.caseVar.CXE_Web_Primary_Email__c")
            , mobile: component.get("v.caseVar.CXE_Web_Primary_Mobile__c")
            , phone: component.get("v.caseVar.CXE_Web_Primary_Phone__c")
            , birthday: component.get("v.caseVar.CXE_Web_Date_of_Birth__c")
        }
        console.log(arg);
        
        helper.toggleSpinner(component, event, helper);
        if(component.get("v.persona") == "Biz") {
            component.set("v.caseVar.Tax_Identification_No__c", "000000000000");
            component.set("v.caseVar.Application_for_Business_Service__c", true);
            component.set("v.caseVar.Application_for_Business_Customer__c", true);
            //START CSM-12544 RReyes SEP-15-17
            var bizEmail = component.get("v.caseVar.CXE_Web_Business_Primary_Email__c");
            component.set("v.caseVar.Business_Email__c", bizEmail);
            console.log('>>bizEmail: ' + bizEmail);
            //END CSM-12544 RReyes SEP-15-17
        }
        else{ 
            var isPaperless = component.find("paperlessTag").getElement().checked;
            component.set("v.caseVar.CXE_Enroll_to_Paperless_Billing__c", isPaperless);
            component.set("v.caseVar.Application_for_Residential_Service__c", true);
            component.set("v.caseVar.Application_for_Residential_Customer__c", true);
            //START RReyes - AUG-15
            component.set("v.caseVar.First_Name__c", arg.fname);
            component.set("v.caseVar.Middle_Name__c", arg.mname);
            component.set("v.caseVar.Last_Name__c", arg.lname);
            component.set("v.caseVar.Email_Address__c", arg.email);
            component.set("v.caseVar.Mobile_No__c", arg.mobile);
            component.set("v.caseVar.Telephone_No__c", arg.phone);
            component.set("v.caseVar.Date_of_Birth__c", arg.birthday);
            //END RReyes - AUG-15
            component.set("v.caseVar.Individual_Email__c", arg.email);//START/END CSM-12544
            console.log('>> indEmail: ' + component.get("v.caseVar.Individual_Email__c"));
        }


        component.set("v.caseVar.Application_Type_Subtype__c", "New Electric Service");
        var caseRec = component.get("v.caseVar");
        var action = component.get("c.submitServiceApplication");

        action.setParams({
            "jsonCaseApplication": JSON.stringify(caseRec),
            "serviceApplicationType": "New_Service_Application"
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            // helper.toggleSpinner(component, event, helper);
            
            if(state == "SUCCESS"){
                var response = a.getReturnValue();

                console.log("RESPONSE", response);

                if (!response.hasError) {
                    component.set("v.caseVar.CaseNumber", response.caseNumber);
                    component.set("v.hasSubmitted", true);
                    component.set("v.caseId", response.caseRecordId);
                    component.find("fileUploadCmp1").uploadFile(response.caseRecordId);
                    // helper.attachFile(component, event, helper);
                    // helper.displaySpecific(component, event, helper, "5");
                } 
                else {
                    helper.toggleSpinner(component, event, helper);
                    component.find("termsACBtn").set("v.disabled", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Please validate your application."
                        , "message": response.errorMessage
                        , "type": "error"
                        , "duration" : 6000
                    });
                    toastEvent.fire();
                }
            } 
            else {
                helper.toggleSpinner(component, event, helper);
                component.find("termsACBtn").set("v.disabled", false);
                
                var errors = a.getError();

                console.error(errors);
                
                if (!!errors[0] && errors[0].message) {

                    console.log("Error message: " + errors[0].message);

                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Please validate your application."
                        , "message": errors[0].message
                        , "type": "error"
                        , "duration" : 6000
                    });

                    toastEvent.fire();
                }               
            }
        });
        $A.enqueueAction(action);
    },
    
    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
        $A.util.toggleClass(component.find("progress_bar"), 'slds-hide');
    },

    toggleCollapse : function(component, event, secId) {
        var acc = component.find(secId);
        $A.util.toggleClass(acc, "show");
        $A.util.toggleClass(acc, "hide");
    }

    

})