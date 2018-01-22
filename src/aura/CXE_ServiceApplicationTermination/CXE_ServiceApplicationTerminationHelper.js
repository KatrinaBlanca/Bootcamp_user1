({
    submitTermination : function(component, event, helper) {
        helper.toggleSpinner(component, event, helper);        
        var action = component.get("c.submitServiceApplication");
        action.setParams({
            "caseApplication": component.get("v.caseApplication"),
            "serviceApplicationType": "CXE_Termination_of_Electric_Service"
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            helper.toggleSpinner(component, event, helper);
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
                // console.log('>>>>>>>>>>>>>>>>>> Error.' + JSON.stringify(response));
                if (!response.hasError) {
                    component.set("v.caseNumber", response.caseNumber);
                    component.set("v.notificationChannels", response.notificationChannels);
                    component.set("v.hasSubmitted", true);
                    // helper.makeFieldsReadOnly(component, event, helper);
                    component.set("v.caseId", response.caseRecordId);
                    helper.attachFile(component, event, helper);
                    helper.showTab3(component, event, helper);

                    // component.set("v.recordId", response.caseRecordId);
                    // helper.prepareFileUpload(component, event, helper);


                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Please validate your application.",
                                          "message": response.errorMessage,
                                          "type": "error",
                                          "duration": 6000
                                         });
                    toastEvent.fire();
                }
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

    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    },

    ///

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
    // Returns true if has error
    validateFieldList: function(component, event, helper, list) {
        var ctr = 0;
        if(list) {
            var i = 0;
            for (i = 0; i < list.length; i++) {            
                if(helper.validateRequiredField(component.find(list[i]),  (list[i] == 'terminationSIN') ? "SIN" : "" )) {
                    ctr++;
                }
            }
        }
        return (ctr < 1);
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

    validateTabOne: function(component, event, helper) {
        var list;        
        list = ["terminationSIN",
                "terminationRepFirstname", 
                "terminationRepLastname", 
                "terminationRepEmailAddress",
                "terminationRepMobileNumber"];
       return helper.validateFieldList(component, event, helper, list);
         
    },
    

    selectTab1: function(component, event, helper) {
        var isSuccess = false;
        var activeTab = component.get("v.activeTab");
        if(activeTab == "One") {
            isSuccess = true;
        } else {
            isSuccess = helper.validateActiveTab(component, event, helper);
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
        // $('#termination-tab-scoped-1__item').parent().addClass('slds-is-active');
        // $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
        // $('#termination-tab-scoped-1').removeClass('slds-hide').addClass('slds-show');
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
        // $('#termination-tab-scoped-2__item').parent().addClass('slds-is-active');
        // $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
        // $('#termination-tab-scoped-2').removeClass('slds-hide').addClass('slds-show');
    },

    selectTab3: function(component, event, helper) {
        var isSuccess = component.get("v.hasSubmitted");
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
        // $('#termination-tab-scoped-5__item').parent().addClass('slds-is-active');
        // $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
        // $('#termination-tab-scoped-5').removeClass('slds-hide').addClass('slds-show');
    },

    makeFieldsReadOnly: function(component, event, helper) {
        var list;
        var persona = component.get("v.persona");
        if(persona == "Business") {
            list = ["terminationSIN", 
                    "terminationRepFirstname", 
                    "terminationRepLastname", 
                    "terminationRepEmailAddress",
                    "terminationRepMobileNumber",
                    "terminationRepMiddlename",
                    "terminationDesignation",
                    "termsAndConditions",
                    "submitBtn"];
        } else {
            list = ["terminationSIN", 
                    "terminationRepFirstname", 
                    "terminationRepLastname", 
                    "terminationRepEmailAddress",
                    "terminationRepMobileNumber",
                    "terminationRepMiddlename",
                    "termsAndConditions",
                    "terminationRelationToCustomerReadOnly",
                    "submitBtn"];
        }
        helper.disableFields(component, event, helper, list);
    },

    disableFields: function(component, event, helper, list) {
        if(list) {
            var i = 0;
            for (i = 0; i < list.length; i++) {            
                var cmpTarget = component.find(list[i]);
                cmpTarget.set("v.disabled", true);
            }
        }
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
        console.log("component.getGlobalId():" + component.getGlobalId());
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
        console.log("component.getGlobalId():" + component.getGlobalId());
        var tab = component.find(tabName);
        console.log("tabName:" + tabName);        
        $A.util.removeClass(tab, 'slds-is-active');
        var tabContent = component.find("content" + tabName);
        console.log("tabContent" + tabContent);
        $A.util.removeClass(tabContent, 'slds-show');        
        $A.util.addClass(tabContent, 'slds-hide');        
    }

    // file uploader
    // prepareFileUpload : function(component, event, helper) {
    //     //Send LC Host as parameter to VF page so VF page can send message to LC; make it all dynamic
    //     component.set('v.lcHost', window.location.hostname);
    //     var frameSrc = '/apex/CXE_UploadFile?id=' + component.get('v.recordId') + '&lcHost=' + component.get('v.lcHost');
    //     console.log('frameSrc:' , frameSrc);
    //     component.set('v.frameSrc', frameSrc);
    //     //Add message listener
    //     window.addEventListener("message", function(event) {

    //         console.log('event.data:', event.data);

    //         // Handle the message
    //         if(event.data.state == 'LOADED'){
    //             //Set vfHost which will be used later to send message
    //             component.set('v.vfHost', event.data.vfHost);                
    //         }

    //         if(event.data.state == 'uploadFileSelected'){
    //             component.find('uploadFileButton').set('v.disabled', false);
    //         }

    //         if(event.data.state == 'fileUploadprocessed'){

    //             var uiMessage = component.find('uiMessage');

    //             //Disable Upload button until file is selected again

    //             component.find('uploadFileButton').set('v.disabled', true);

    //             $A.createComponents([
    //                     ["markup://ui:message",{
    //                         "body" : event.data.message,
    //                         "severity" : event.data.messageType,
    //                     }]
    //                 ],
    //                 function(components, status, errorMessage){
    //                     if (status === "SUCCESS") {
    //                         var message = components[0];
    //                         // set the body of the ui:message to be the ui:outputText
    //                         component.find('uiMessage').set("v.body", message);
    //                     }
    //                     else if (status === "INCOMPLETE") {
    //                         console.log("No response from server or client is offline.")
    //                         // Show offline error
    //                     }
    //                     else if (status === "ERROR") {
    //                         console.log("Error: " + errorMessage);
    //                         // Show error message
    //                     }
    //                 }
    //             );
    //         }
    //     }, false);
    // },

    // sendMessage: function(component, helper, message){
    //     //Send message to VF
    //     message.origin = window.location.hostname;
    //     var vfWindow = component.find("vfFrame").getElement().contentWindow;
    //     console.log('message.origin:' + message.origin);
    //     console.log('vfHost:' + component.get("v.vfHost"));
    //     vfWindow.postMessage(message, component.get("v.vfHost"));
    // },

    // upload: function(component, event, helper) {
    //     //Clear UI message before trying for file upload again
    //     // component.find('uiMessage').set("v.body",[]);

    //     //Prepare message in the format required in VF page
    //     var message = {
    //         "uploadFile" : true
    //     } ;
    //     //Send message to VF
    //     helper.sendMessage(component, helper, message);
    // }    

    
})