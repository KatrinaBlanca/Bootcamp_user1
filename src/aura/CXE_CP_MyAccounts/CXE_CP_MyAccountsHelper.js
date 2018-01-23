({
    SELECT_ALL: "--Select All--",
    
    setPicklistOptions : function(component, event) {
        
        var action = component.get("c.retrievePortalData");
        action.setCallback(this,function(response){          
            var state = response.getState();
            var retVal = response.getReturnValue();
            
            //FOR ACCOUNT LIST PART DROPDOWN
            if(retVal.ContractCount > 1){
                var accountList = [this.SELECT_ALL];
            }else{
                var accountList = [];
            }
            if(retVal.ServicesCount > 1){
                var sinList = [this.SELECT_ALL];
            }else{
                var sinList =[];
            }
            
            if(component.isValid() && (state === "SUCCESS") && retVal != null){
                
                for(var i = 0; i < retVal.ContractCount ; i++){
                    accountList.push(retVal.UserContracts[i].V10_Account_No__c);
                }                
                component.set("v.accts" , accountList);
                
                for(var i = 0 ; i < retVal.ServiceCount ; i++){
                    if(retVal.UserEnrollments[i].CXE_Alias__c){
                        sinList.push(retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c + ' - ' + retVal.UserEnrollments[i].CXE_Alias__c);
                    }else{
                        sinList.push(retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c);
                    }
                }
                component.set("v.sins", sinList);
                
            }else{
                
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(retVal);
            }
        });  
        $A.enqueueAction(action);
        
    },
    
    modifySinPicklist : function (component, event){
        
        var action = component.get("c.retrievePortalData");
        action.setCallback(this,function(response){          
            var state = response.getState();
            var retVal = response.getReturnValue();
            
            var accSelected = component.find("accountSelected").get("v.value");
            console.log('Selected Account: ' + accSelected);
            
            var sinSelected = component.find("sinPopulated").get("v.value");
            console.log('Selected SIN: ' + sinSelected);
            
            var sinList = [];
            
            if(component.isValid() && (state === "SUCCESS") && retVal != null){
                
                for(var i = 0 ; i < retVal.ServiceCount ; i++){
                    if(accSelected != "--Select All--"){
                        if(retVal.UserEnrollments[i].CXE_ServiceId__r.Payor__r.V10_Account_No__c == accSelected){
                            if(retVal.UserEnrollments[i].CXE_Alias__c){
                                sinList.push(retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c 
                                             + ' - ' + retVal.UserEnrollments[i].CXE_Alias__c);
                            }else{
                                sinList.push(retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c);
                            }
                        }
                    }else{
                        if(retVal.UserEnrollments[i].CXE_Alias__c){
                            sinList.push(retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c 
                                         + ' - ' + retVal.UserEnrollments[i].CXE_Alias__c);
                        }else{
                            sinList.push(retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c);
                        }
                        console.log(retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c);
                    }
                }
                if(sinList.length> 1){
                    sinList.unshift("--Select All--");
                }
                component.set("v.sins", sinList);
            }else{
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(retVal);
            }
        });  
        $A.enqueueAction(action); 
    },
    
    modifyAccountPicklist : function (component, event, helper){
        
        var action = component.get("c.retrievePortalData");
        action.setCallback(this,function(response){          
            var state = response.getState();
            
            var retVal = response.getReturnValue();
            
            var sinSelected = component.find("sinPopulated").get("v.value");
            console.log('Selected SIN: ' + sinSelected);
            
            var sinList = [];
            
            if(component.isValid() && (state === "SUCCESS") && retVal != null){
                for(var i = 0 ; i < retVal.ServiceCount ; i++){
                    if(sinSelected != "--Select All--"){
                        if(sinSelected.indexOf(retVal.UserServices[i].SIN__c)!==-1){
                            console.log(retVal.UserServices[i].Payor__r.V10_Account_No__c);
                            var CurrentValue = retVal.UserServices[i].Payor__r.V10_Account_No__c;
                            sinList.unshift({ class: "optionClass", label: "--Select All--", value: "--Select All--", selected: "false"});
                            sinList.push({ class: "optionClass", label: CurrentValue, value: CurrentValue, selected: "true"});
                        }else{
                            var CurrentValue = retVal.UserServices[i].Payor__r.V10_Account_No__c;
                            sinList.push({ class: "optionClass", label: CurrentValue, value: CurrentValue});
                        }
                    }else{
                        var CurrentValue = retVal.UserServices[i].Payor__r.V10_Account_No__c;
                        sinList.push({ class: "optionClass", label: CurrentValue, value: CurrentValue, selected: "true"});
                        console.log(retVal.UserServices[i].Payor__r.V10_Account_No__c);
                    }
                }
                component.find("accountSelected").set("v.options", sinList);
            }else{
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(retVal);
            }
        });   
        $A.enqueueAction(action); 
    },
    
    SearchHelper : function (component, event, helper){
        
        var AccSelected = component.find("accountSelected").get("v.value");
        var SinSelected = component.find("sinPopulated").get("v.value");
        console.log("ACC>>>>"+AccSelected);
        console.log("Sin>>>>"+SinSelected)
        var action = component.get("c.ListofServices");
        var SinSelected = component.find("sinPopulated").get("v.value");
        if(SinSelected == "--Select All--"){
            SinSelected = "none";
        }
        var AccountSelected = component.find("accountSelected").get("v.value");
        if(AccountSelected == "--Select All--"){
            AccountSelected = "none";
        }
        console.log(SinSelected + "???>>>>>" + AccountSelected);
        action.setParams({"SINNumber":SinSelected , "AccountNumber":AccountSelected});
        action.setCallback(this,function(response){    
            var state = response.getState();
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                console.log(response.getReturnValue());
                component.set("v.Services", response.getReturnValue());
            }else{
                
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
    },
    
    loadReactivateForm : function (component, event, helper) {
        var selectedSin = component.find("sinPopulated").get("v.value");
        var checkboxes = component.find("DependentCheckbox");
            var selectedCheckbox = [];
        var selectedSin =[] //CSM-12494 Emandolado 9/12/2017
        if(checkboxes.length == undefined){
            selectedCheckbox.push(component.get("v.sinCheckHolder"));
        }else{
            for (var i = 0; i < checkboxes.length; i++){
                if(checkboxes[i].get("v.value") == true){
                    selectedCheckbox.push(checkboxes[i].get("v.name"));
                    selectedSin.push(checkboxes[i].get("v.labelClass"));//CSM-12494 Emandolado 9/12/2017
                }
            }
        }
        
        component.set("v.selectedSin", selectedCheckbox[0]);
        component.set("v.selectedSinAlias",selectedSin[0])//CSM-12494 Emandolado 9/12/2017
        console.log(selectedCheckbox);
        
        if(selectedCheckbox.length == 1){
            component.set("v.selectedSin", selectedCheckbox[0]);
            //START CSM-14489 11.24.2017
            //helper.getDetails(component, event, helper, "Recontract","Terminated","Cannot reactivate the selected service.");  
            helper.getDetails(component, event, helper, "Recontract","Terminated","Your service is currently active.");  
            //END CSM-14489 11.24.2017
        }else if(selectedCheckbox.length < 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                //CORBES 11/23
                //"title": "Error",
                "type": "Error",
                //"message": "Please Select an SIN", //CSM-14489 11.16.2017 correct message
                "message": "Please select a Service ID Number.", //CSM-14489
                "duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
            });
            toastEvent.fire();   
        }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    //CORBES 11/23
                    //"title": "Error",
                    "type": "Error",
                    //START CSM-15117 RReyes JAN-12-18 - moved message to custom label to avoid special chars
                    "message": $A.get("$Label.c.PROMPT_MULTI_SIN"), //CSM-14489 11.24.2017 //"You can only select 1 SIN",
                    //END CSM-15117 RReyes JAN-12-18 - moved message to custom label to avoid special chars
                    "duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
                });
                toastEvent.fire();   
            }
        
        // component.set("v.selectedSin", selectedSin);
        //helper.getDetails(component, event, helper, "Recontract","Terminated","Cannot reactivate the selected service.");        
        //helper.getDetails(component, event, helper, "Recontract");        
    },
    
    loadTerminateForm : function (component, event, helper) {
        /* var selectedSin = component.find("sinPopulated").get("v.value");
        alert(selectedSin);
        component.set("v.selectedSin", selectedSin); */
        var selectedSin = component.find("sinPopulated").get("v.value");
        var checkboxes = component.find("DependentCheckbox");
        var selectedCheckbox = [];
        var selectedSin =[] //CSM-12494 Emandolado 9/12/2017
        if(checkboxes.length == undefined){
            selectedCheckbox.push(component.get("v.sinCheckHolder"));
        }else{
            for (var i = 0; i < checkboxes.length; i++){
                if(checkboxes[i].get("v.value") == true){
                    selectedCheckbox.push(checkboxes[i].get("v.name"));
                    selectedSin.push(checkboxes[i].get("v.labelClass"));//CSM-12494 Emandolado 9/12/2017
                }
            }
        }
        
        component.set("v.selectedSin", selectedCheckbox[0]);
        component.set("v.selectedSinAlias",selectedSin[0])//CSM-12494 Emandolado 9/12/2017
        
        if(selectedCheckbox.length == 1){            
            //START CSM-14489 11.24.2017
            //helper.getDetails(component, event, helper, "Terminate","Active","Cannot terminate the selected service."); 
            helper.getDetails(component, event, helper, "Terminate","Active"
                ,"Your service has been terminated. Please call us at our 24/7 hotline at 16211 or business hotline at 16210 for assistance.");
            //END CSM-14489 11.24.2017
        }
        else if(selectedCheckbox.length < 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                //CORBES 11/23
                //"title": "Error",
                "type": "Error",
                //"message": "Please Select an SIN", //CSM-14489 11.16.2017 correct message
                "message": "Please select a Service ID Number.", //CSM-14489
                "duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
            });
            toastEvent.fire();   
        }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    //CORBES 11/23
                    //"title": "Error",
                    "type": "Error",
                    //START CSM-15117 RReyes JAN-12-18 - moved message to custom label to avoid special chars
                    "message": $A.get("$Label.c.PROMPT_MULTI_SIN"), //CSM-14489 11.24.2017 //"You can only select 1 SIN",
                    //END CSM-15117 RReyes JAN-12-18 - moved message to custom label to avoid special chars
                    "duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
                });
                toastEvent.fire();   
            }
        //helper.getDetails(component, event, helper, "Recontract");        
    },
    
    loadChangeServiceForm : function (component, event, helper) {
        var selectedSin = component.find("sinPopulated").get("v.value");
        var checkboxes = component.find("DependentCheckbox");
        var selectedCheckbox = [];
        var selectedSin =[] //CSM-12494 Emandolado 9/12/2017
        if(checkboxes.length == undefined){
            selectedCheckbox.push(component.get("v.sinCheckHolder"));
        }else{
            for (var i = 0; i < checkboxes.length; i++){
                if(checkboxes[i].get("v.value") == true){
                    selectedCheckbox.push(checkboxes[i].get("v.name"));
                    selectedSin.push(checkboxes[i].get("v.labelClass"));//CSM-12494 Emandolado 9/12/2017
                }
            }
        }
        
        component.set("v.selectedSin", selectedCheckbox[0]);
        component.set("v.selectedSinAlias",selectedSin[0])//CSM-12494 Emandolado 9/12/2017
        if(selectedCheckbox.length == 1){
            helper.getDetails(component, event, helper, "ChangeService","Active","Cannot proceed with change service.");  
        }else if(selectedCheckbox.length < 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                //CORBES 11/23
                //"title": "Error",
                "type": "Error",
                //"message": "Please Select an SIN", //CSM-14489 11.16.2017 correct message
                "message": "Please select a Service ID Number.", //CSM-14489
                "duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
            });
            toastEvent.fire();   
        }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    //CORBES 11/23
                    //"title": "Error",
                    "type": "Error",
                    //START CSM-15117 RReyes JAN-12-18 - moved message to custom label to avoid special chars
                    "message": $A.get("$Label.c.PROMPT_MULTI_SIN"), //CSM-14489 11.24.2017 //"You can only select 1 SIN",
                    //END CSM-15117 RReyes JAN-12-18 - moved message to custom label to avoid special chars
                    "duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
                });
                toastEvent.fire();   
            }
        //helper.getDetails(component, event, helper, "Recontract");        
    },
    
    searched: function(component,event,helper){
        var MainPage = component.find('TableHolder');
        $A.util.removeClass(MainPage, 'Hideme');
        
        var AccSelected = component.find("accountSelected").get("v.value");
        var SinSelected = component.find("sinPopulated").get("v.value");
        console.log("ACC>>>>"+AccSelected);
        console.log("Sin>>>>"+SinSelected)
        var action = component.get("c.ListofServices");
        var SinSelected = component.find("sinPopulated").get("v.value");
        if(SinSelected == "--Select All--"){
            SinSelected = "none";
        }
        var AccountSelected = component.find("accountSelected").get("v.value");
        if(AccountSelected == "--Select All--"){
            AccountSelected = "none";
        }
        console.log(SinSelected + "???>>>>>" + AccountSelected);
        action.setParams({"SINNumber":SinSelected , "AccountNumber":AccountSelected});
        action.setCallback(this,function(response){    
            var state = response.getState();
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                console.log("This is the list of wrapper: " + JSON.stringify(response.getReturnValue()));
              
                component.set("v.wrapperServiceList", response.getReturnValue());
            }else{
                
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
    },
    
    loadChangeContractForm : function (component, event, helper) {
        var selectedSin = component.find("sinPopulated").get("v.value");
        var checkboxes = component.find("DependentCheckbox");
        
        var selectedCheckbox = [];
        var selectedSin =[] //CSM-12494 Emandolado 9/12/2017
        if(checkboxes.length == undefined){
            selectedCheckbox.push(component.get("v.sinCheckHolder"));
        }else{
            for (var i = 0; i < checkboxes.length; i++){
                if(checkboxes[i].get("v.value") == true){
                    selectedCheckbox.push(checkboxes[i].get("v.name"));
                    selectedSin.push(checkboxes[i].get("v.labelClass"));//CSM-12494 Emandolado 9/12/2017
                }
            }
        }
        
        component.set("v.selectedSin", selectedCheckbox[0]);
        component.set("v.selectedSinAlias",selectedSin[0])//CSM-12494 Emandolado 9/12/2017
        if(selectedCheckbox.length == 1){
            helper.getDetails(component, event, helper, "ChangeContract","Active","Cannot proceed with change service."); 
        }else if(selectedCheckbox.length < 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                //CORBES 11/23
                //"title": "Error",
                "type": "Error",
                //"message": "Please Select an SIN", //CSM-14489 11.16.2017 correct message
                "message": "Please select a Service ID Number.", //CSM-14489
                "duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
            });
            toastEvent.fire();   
        }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    //CORBES 11/23
                    //"title": "Error",
                    "type": "Error",
                    //START CSM-15117 RReyes JAN-12-18 - moved message to custom label to avoid special chars
                    "message": $A.get("$Label.c.PROMPT_MULTI_SIN"), //CSM-14489 11.24.2017 //"You can only select 1 SIN",
                    //END CSM-15117 RReyes JAN-12-18 - moved message to custom label to avoid special chars
                    "duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
                });
                toastEvent.fire();   
            }
        //helper.getDetails(component, event, helper, "Recontract");        
    },
    
    toggleCmp : function(component, secId) {
        var acc = component.find(secId);
        $A.util.toggleClass(acc, "slds-show");
        $A.util.toggleClass(acc, "slds-hide");
    },
    
    getDetails : function(component, event, helper, form, requiredStatus, errorMsg) {  
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
        
        var action = component.get("c.getCaseVariable");
        action.setParams({ 
            "serviceId": component.get("v.selectedSin"),
            "requiredStatus": requiredStatus
        });
        action.setCallback(this,function(response){    
            var state = response.getState();
            if(state == "SUCCESS"){
                var response = response.getReturnValue();
                if (!response.hasError) {
                    
                    var saType = (response.caseRecord.Application_for_Residential_Customer__c ? "Ind" : "Biz") + form;
                    component.set("v.caseVar", response.caseRecord);
                    component.set("v.SAType", saType);
                    helper.toggleCmp(component, "mainCmp");
                    if(form=="Recontract"){
                        helper.toggleCmp(component, "ReactivateForm");
                    }else if(form=="Terminate"){
                        helper.toggleCmp(component, "TerminateForm");
                    }else if(form=="ChangeService"){
                        helper.toggleCmp(component, "ModifyChangeServiceForm");
                    }else if(form=="ChangeContract"){
                        helper.toggleCmp(component, "ModifyChangeContractForm");
                    }
                    document.body.scrollTop = 0;
                    document.documentElement.scrollTop = 0;
                    
                } else {
                    
                    var cmpTarget = component.find("appSpinner");
                    $A.util.toggleClass(cmpTarget, 'slds-hide');
                    
                    var toastEvent = $A.get("e.force:showToast");
                    /*toastEvent.setParams({"title": "Please validate your application.",
                                          "message": response.errorMessage,
                                          "type": "error",
                                          "duration": 6000
                                         });*/
                    //START CSM-14489 11.24.2017
                    /*var message = "This service is still active.";

                    if(form=="Terminate"){
                        message = "This service is already terminated.";
                    }*/
                    //END CSM-14489 11.24.2017

					//CSM-14489 Corbes Melvin 11.20.2017
                    toastEvent.setParams({ //"title": errorMsg,
                                          "message": errorMsg, //"Please select a Service ID Number.", //CSM-14489 11.24.2017
                                          "type": "error",   //"error",
                                          "duration": 6000
                                         });
                    toastEvent.fire();
                    //end of  CSM-14489 Corbes Melvin 11.20.2017
                }
            } else {
                var cmpTarget = component.find("appSpinner");
                $A.util.toggleClass(cmpTarget, 'slds-hide');
                
                console.log('>>>>>>>>>>>>>>>>>> Error.' + a.getReturnValue());
                //CSM-14489 Corbes Melvin 11.20.2017
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({ //"title":"Error",  //"Please validate your application.",
                                      "message": a.getReturnValue(), //"Please select a Service ID Number.", //CSM-14489 11.24.2017
                                      "type": "error",
                                      "duration": 6000
                                     });
                toastEvent.fire();
                //end of  CSM-14489 Corbes Melvin 11.20.2017
            }
        });
        $A.enqueueAction(action); 
    },
    
    //Start CSM-12548 Mike Verdad 09/25/2017
    EventFirePaperlessBillingHelper : function (component, event, helper){
        
        component.set("v.WithSin", "noSin");
        var eventValue= event.getParam("attributeValue");
        var MainPage = component.find('MainForm');
        var ResultPage = component.find('result');
        var PaperlessPage = component.find('PaperlessBilling');
        var MainPageNav = component.find('MainFormNav');
        
        $A.util.removeClass(MainPage, 'slds-hide');
        $A.util.addClass(MainPage, 'slds-show');
        $A.util.removeClass(MainPageNav, 'slds-hide');
        $A.util.addClass(MainPageNav, 'slds-show');
        $A.util.removeClass(ResultPage, 'slds-show');
        $A.util.addClass(ResultPage, 'slds-hide');
        $A.util.removeClass(PaperlessPage, 'slds-show');
        $A.util.addClass(PaperlessPage, 'slds-hide');
 
        var setEvent = component.getEvent("setAttribute");
        setEvent.setParams({"attributeValue":'None'});
        setEvent.fire()
    },
    //End CSM-12548 Mike Verdad 09/25/2017
	
    //START Breadcrumb-task IPenaflor SEPT-25-17
     goToHome : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/dashboard';
        window.location.assign(pageUrl);
    },
    
    goToMyAccounts : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/myaccounts';
        window.location.assign(pageUrl);
    },
    checkCaseStatus : function (component, event, helper,AccountId){
       console.log('Data');
        
		 var action = component.get("c.hasOpenCaseStatusforPaperlessBillingSubscription");
         action.setParams({"AccountId" :AccountId});
         action.setCallback(this,function(response){          
            var state = response.getState();
            console.log(state);
            console.log(response.getReturnValue());
            component.set("v.hasOpenCase", response.getReturnValue());
        });
        $A.enqueueAction(action); 
     },
    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
    goToAutopayenroll : function(component, event, helper){
        var currentID = component.get("v.currentId");
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/autopayenroll?accts='+currentID;
        window.location.assign(pageUrl);
    },
     goToautopayunsub : function(component, event, helper){
         var currentID = component.get("v.currentId");
         var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/autopayunsub?accts='+currentID;
        window.location.assign(pageUrl);
    } 
    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17 

})