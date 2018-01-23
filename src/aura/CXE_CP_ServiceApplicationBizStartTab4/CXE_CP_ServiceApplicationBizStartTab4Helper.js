({
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
        }
        else{ 
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
                    component.upload(response.caseRecordId);
                    component.set("v.caseVar.CaseNumber", response.caseNumber);
                    component.set("v.hasSubmitted", true);
                    helper.pushEvent(component, "5");
                    helper.pushSubmittedCaseEvent(component, component.get("v.caseVar"));
                } 
                else {

                    helper.pushEvent(component, "4");
                    helper.toggleSpinner(component, event, helper);
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
                helper.pushEvent(component, "4");
                helper.toggleSpinner(component, event, helper);
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
    },

    pushEvent : function (component, tabName) {
        var setEvent = component.getEvent("callTabEvent");
        setEvent.setParams({
            "param1" : tabName
        });
        setEvent.fire();
    },

    pushSubmittedCaseEvent : function (component, caseRec) {
        var setEvent = component.getEvent("submittedCaseEvt");
        setEvent.setParams({
            "submittedCase" : caseRec
        });
        setEvent.fire();
    }
})