({

    submitRecontract : function(component, event, helper) {
        helper.toggleSpinner(component, event, helper);
        
        var action = component.get("c.submitServiceApplication");
        action.setParams({
            "caseApplication": component.get("v.caseApplication"),
            "serviceApplicationType": "CXE_Recontract_of_Electric_Service"
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            helper.toggleSpinner(component, event, helper);
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
                if (!response.hasError) {
                    component.set("v.caseNumber", response.caseNumber);
                    component.set("v.hasSubmitted", true);
                    component.set("v.caseId", response.caseRecordId);
                    helper.attachFile(component, event, helper);
                    helper.showTab5(component, event, helper);
                    
                    // helper.attachFile(component, event, helper);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Please validate your application.",
                                          "message": response.errorMessage,
                                          "type": "error",
                                          "duration" : 6000
                                         });
                    toastEvent.fire();
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Please validate your application.",
                                      "message": a.getReturnValue(),
                                      "type": "error",
                                      "duration" : 6000
                                     });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    },

    toggleCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    },

    validateRequiredField : function(cmpTarget, cmpLabel) {
        if($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value"))){
            if(cmpLabel) {
                cmpTarget.set("v.errors", [{message:"Please enter " + cmpLabel}]);
            }else {
                cmpTarget.set("v.errors", [{message:"Please enter " + cmpTarget.get("v.label") + "."}]);
            }
            return true;
        }         
        else {
            cmpTarget.set("v.errors",null);
            return false;
        }
    },

    validateTabOne: function(component, event, helper) {
        var persona = component.get("v.persona");
        var list;
        var ctr = 0;
        var i = 0;
        if(persona == "Business"){
            list = ["recontractSIN", "businessName", "businessLandline", "businessFirstname", "businessLastname", "businessEmailAddress", "businessMobileNumber", "designation"];               
        } else {
            // console.log("onBehalf:" + component.get("v.onBehalf"));
            if(component.get("v.onBehalf")) {
                list = ["recontractSIN", "firstname", "lastname", "emailAddress", "repFirstname", "repLastname", "repEmailAddress", "repMobileNumber"];
            } else {
                list = ["recontractSIN", "firstname", "lastname", "emailAddress"];
            } 
        }
        for (i = 0; i < list.length; i++) {
            if(helper.validateRequiredField(component.find(list[i]), (list[i] == 'recontractSIN') ? "SIN" : "" )) {
                ctr++;
            }
        }
        return (ctr < 1);
    },

    selectTab1: function(component, event, helper) {
        var isSuccess = false;
        if(component.get("v.activeTab") != "One") {
            isSuccess = helper.validateActiveTab(component, event, helper);
        } else {
            isSuccess = true;
        }
        if(isSuccess) {
            helper.showTab1(component, event, helper);
        }
    },

    showTab1: function(component, event, helper) {
         helper.hideTab(component, event, helper, component.get("v.activeTab"));
        component.set("v.activeTab", "One");
        helper.showTab(component, event, helper, component.get("v.activeTab"));   
        // component.set("v.activeTab", "One");
        // $('.slds-tabs_scoped__item').removeClass('slds-is-active');
        // $('#recontract-tab-scoped-1__item').parent().addClass('slds-is-active');
        // $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
        // $('#recontract-tab-scoped-1').removeClass('slds-hide').addClass('slds-show');
    },

    selectTab2: function(component, event, helper) {
        var isSuccess = false;
        isSuccess = helper.validateActiveTab(component, event, helper);
        if(isSuccess) {
            helper.showTab2(component, event, helper);
        }
    },

    showTab2: function(component, event, helper) { 
        helper.hideTab(component, event, helper, component.get("v.activeTab"));
        component.set("v.activeTab", "Two");
        helper.showTab(component, event, helper, component.get("v.activeTab"));       
        // component.set("v.activeTab", "Two");
        // $('.slds-tabs_scoped__item').removeClass('slds-is-active');
        // $('#recontract-tab-scoped-2__item').parent().addClass('slds-is-active');
        // $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
        // $('#recontract-tab-scoped-2').removeClass('slds-hide').addClass('slds-show');
    },

    selectTab3: function(component, event, helper) {
        var isSuccess = false;
        isSuccess = helper.validateActiveTab(component, event, helper);
        if(isSuccess) {
            helper.showTab3(component, event, helper);
        }
    },

    showTab3: function(component, event, helper) {
        helper.hideTab(component, event, helper, component.get("v.activeTab"));
        component.set("v.activeTab", "Three");
        helper.showTab(component, event, helper, component.get("v.activeTab"));
        // component.set("v.activeTab", "Three");
        // $('.slds-tabs_scoped__item').removeClass('slds-is-active');
        // $('#recontract-tab-scoped-3__item').parent().addClass('slds-is-active');
        // $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
        // $('#recontract-tab-scoped-3').removeClass('slds-hide').addClass('slds-show');
    },


    selectTab4: function(component, event, helper) {
        var isSuccess = false;
        isSuccess = helper.validateActiveTab(component, event, helper);
        if(isSuccess) {
            helper.showTab4(component, event, helper);
        }
    },

    showTab4: function(component, event, helper) {
        helper.hideTab(component, event, helper, component.get("v.activeTab"));
        component.set("v.activeTab", "Four");
        helper.showTab(component, event, helper, component.get("v.activeTab"));
        // component.set("v.activeTab", "Four");
        // $('.slds-tabs_scoped__item').removeClass('slds-is-active');
        // $('#recontract-tab-scoped-4__item').parent().addClass('slds-is-active');
        // $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
        // $('#recontract-tab-scoped-4').removeClass('slds-hide').addClass('slds-show');
    },

    showTab5: function(component, event, helper) {
        helper.hideTab(component, event, helper, component.get("v.activeTab"));
        component.set("v.activeTab", "Five");
        helper.showTab(component, event, helper, component.get("v.activeTab"));
        // component.set("v.activeTab", "Five");
        // $('.slds-tabs_scoped__item').removeClass('slds-is-active');
        // $('#recontract-tab-scoped-5__item').parent().addClass('slds-is-active');
        // $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
        // $('#recontract-tab-scoped-5').removeClass('slds-hide').addClass('slds-show');
    },

    validateActiveTab: function(component, event, helper) {
        var activeTab = component.get("v.activeTab");
        var hasSubmitted = component.get("v.hasSubmitted");

        if(hasSubmitted) {
            return false;
        }

        if(activeTab == "One"){
            return helper.validateTabOne(component, event, helper);
        }
        return true;
    },

    backToSelection :function (component, event, helper) {
        helper.toggleSpinner(component, event, helper);    
        $A.get('e.force:refreshView').fire();
    },

    getRelationshipToCustomer : function(component, event, helper) {
        var action = component.get("c.getRelationToCustomer");
        action.setParams({
            "persona": component.get("v.persona")
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
                console.log("getRelationshipToCustomer >>>>>" + response);
                component.set("v.relationToCustomerPicklist", response); 
                console.log("v.relationToCustomerPicklist >>>>>" + component.get("v.relationToCustomerPicklist"));             
            } else {
                console.log('>>>>>>>>>>>>>>>>>> Error.' + a.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Please validate your application.",
                                      "message": a.getReturnValue(),
                                      "type": "error",
                                      "duration": 6000
                                     });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    attachFile : function(component, event, helper) {
        var childCmp = component.find("fileUploadCmp")
        childCmp.uploadFile();
    },

    showTab : function(component, event, helper, tabName) {
        console.log("showTab");
        // console.log("component.getGlobalId():" + component.getGlobalId());
        var tab = component.find(tabName);
        $A.util.addClass(tab, 'slds-is-active'); 
        console.log("tabName:" + tabName);        
        var tabContent = component.find("content" + tabName); 
        console.log("tabContent:" + tabContent);             
        $A.util.removeClass(tabContent, 'slds-hide');
        $A.util.addClass(tabContent, 'slds-show');        
    },

    hideTab : function(component, event, helper, tabName) {
        console.log("hideTab");
        // console.log("component.getGlobalId():" + component.getGlobalId());
        var tab = component.find(tabName);
        console.log("tabName:" + tabName);        
        $A.util.removeClass(tab, 'slds-is-active');
        var tabContent = component.find("content" + tabName);
        console.log("tabContent" + tabContent);
        $A.util.removeClass(tabContent, 'slds-show');        
        $A.util.addClass(tabContent, 'slds-hide');        
    },

    removeFieldValuesOnTab1: function(component, event, helper) {    
        var persona = component.get("v.persona");  
        var list;     
        var i = 0;   
        if(persona == "Individual") {
            list = ["repFirstname", 
                    "repMiddlename",
                    "repLastname", 
                    "repEmailAddress", 
                    "repMobileNumber",
                    "selectedRelationToOwner"];
        } 

        for (i = 0; i < list.length; i++) {            
            component.find(list[i]).set("v.value", null);
        }
    }
    

})