({
    redirectFAQ : function(component, event, helper) {
        component.set("v.popUpModalChild", 'unsubFail6month');
        var strWindowFeatures = "height=570,width=520";
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/topiccatalog';
        window.open(pageUrl, 'mywindow' , strWindowFeatures);
    },
    
    closeModalProceed : function(component, event, helper) {
        document.getElementById("mov-proceed-modal-prompt").style.display = "none";
    },
    
    doInit : function(component, event, helper) {
        var action = component.get("c.loadAccounts");
        action.setCallback(this,function(response){    
            var state = response.getState();
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){  
                console.log(response.getReturnValue());
                var returnVal = response.getReturnValue().listofContract;
                var returnReason = response.getReturnValue().listofReason;
                var AccountList = [];
                if(returnVal.length > 1){
                    AccountList.push({ class: "optionClass", label: "Select Account Number", value: "none", selected: "true" })                    
                    for(var i = 0; i < returnVal.length ; i++){
                        var CurrentValue = returnVal[i];
                        AccountList.push({ class: "optionClass", label: CurrentValue.V10_Account_No__c, value: CurrentValue.V10_Account_No__c});
                    }       
                }else if(returnVal.length == 0){
                    AccountList.push({ class: "optionClass", label: "No Account Available", value: "none", selected: "true" })  
                }
                    else{
                        for(var i = 0; i < returnVal.length ; i++){     
                            var CurrentValue = returnVal[i];
                            AccountList.push({ class: "optionClass", label: CurrentValue.V10_Account_No__c, value: CurrentValue.V10_Account_No__c, selected: "true"});               
                        }      
                    }
                
                var reasonList = [];
                reasonList.push({ class: "optionClass", label: 'Please specify', value: 'none'});
                for(var i = 0; i<returnReason.length; i++){
                    var currentValue = returnReason[i];
                    reasonList.push({ class: "optionClass", label: currentValue, value: currentValue});
                }
                component.find("myAccountData").set("v.options", AccountList);
                component.find("reasonList").set("v.options", reasonList);
                
            }else{
                //alert('yow');
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
    },
    reasonChange: function(component, event, helper) {
        if(event.getSource().get("v.value") == ''){
            
        }else{
            
        }
    },
    //Start CSM-12559 Emandoaldo 9/14/2017
    	
    GoBack : function(component, event, helper) {
        
        //START CSM-13656 JRances - Reset errors when Back button is Clicked
        var action = component.get("c.loadAccounts");
        action.setCallback(this,function(response){    
            var state = response.getState();
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){  
                console.log(response.getReturnValue());
                var returnVal = response.getReturnValue().listofContract;
                var returnReason = response.getReturnValue().listofReason;
                var AccountList = [];
                if(returnVal.length > 1){
                    AccountList.push({ class: "optionClass", label: "Select Account Number", value: "none", selected: "true" })                    
                    for(var i = 0; i < returnVal.length ; i++){
                        var CurrentValue = returnVal[i];
                        AccountList.push({ class: "optionClass", label: CurrentValue.V10_Account_No__c, value: CurrentValue.V10_Account_No__c});
                    }       
                }else if(returnVal.length == 0){
                    AccountList.push({ class: "optionClass", label: "No Account Available", value: "none", selected: "true" })  
                }
                    else{
                        for(var i = 0; i < returnVal.length ; i++){     
                            var CurrentValue = returnVal[i];
                            AccountList.push({ class: "optionClass", label: CurrentValue.V10_Account_No__c, value: CurrentValue.V10_Account_No__c, selected: "true"});               
                        }      
                    }
                
                var reasonList = [];
                reasonList.push({ class: "optionClass", label: 'Please specify', value: 'none'});
                for(var i = 0; i<returnReason.length; i++){
                    var currentValue = returnReason[i];
                    reasonList.push({ class: "optionClass", label: currentValue, value: currentValue});
                }
                
                component.find("myAccountData").set("v.options", AccountList);
                var selected = component.find("myAccountData");
                selected.set("v.errors", null);
                //START CSM-13673 JRances - Inline Text Not Appearing in Paperless Billing Subscribe and Cancellation Pages
                document.getElementById('checkIfAccountIsSelected2').classList.add("slds-hide");
                //END CSM-13673
                                
                component.find("reasonList").set("v.options", reasonList);
                var selectedReason = component.find("reasonList");                
                selectedReason.set("v.errors", null);
                
                document.getElementById('selectReason').classList.add("slds-hide");  
                component.set("v.otherReason" , false);           
                				                
            }else{
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
        
        var setEvent = component.getEvent("setAttribute");
        setEvent.setParams({"attributeValue":'Fire'});
        setEvent.fire()
        //END CSM-13656 JRances
    },
    //End CSM-12559 Emandoaldo 9/14/2017
    
    changeReason: function(component, event, helper) {
        
        //START - CSM-13010 JRances - Update behavior 
        var selectedReason = component.find("reasonList").get("v.value");
        var DRPDWN_RSN_PLEASE_SPECIFY = 'none';
        var DRPDWN_RSN_OTHERS_SPECIFY = 'Others (please specify)';
        
        if (selectedReason == DRPDWN_RSN_PLEASE_SPECIFY){
            component.set("v.otherReason" , false);
            
            var selected = component.find("reasonList");
            var elem = document.getElementById("selectReason");
            elem.style.color = "#C23934";
            elem.style.fontSize = "13.5px";
            document.getElementById('selectReason').classList.remove("slds-hide");
            selected.set("v.errors", [{message:null}]);
            
        } else if (selectedReason != DRPDWN_RSN_PLEASE_SPECIFY){
            document.getElementById('selectReason').classList.add("slds-hide");
            var selected = component.find("reasonList");
            selected.set("v.errors", null);
            
            if(selectedReason == DRPDWN_RSN_OTHERS_SPECIFY){
                component.set("v.otherReason" , true);
            } else {
                component.set("v.otherReason" , false);
            }      
        } else {
            selected.set("v.errors", null);
            component.set("v.otherReason" , false);
        }
        //END - CSM-13010 JRances 
        /*
        if(selectedReason == 'Others (please specify)'){
            component.set("v.otherReason" , true);
        }else{
            component.set("v.otherReason" , false);
        }
        console.log(selectedReason);
        */
    },
    
    accountChange  : function(component, event, helper) {
        var selectedData = component.get("v.accountPass");
        component.find('myAccountData').set('v.value' , selectedData);
    },
    //START Breadcrumb-task GSerrano SEPT-25-17
    redirectToMyAccounts : function (component, event, helper){
        helper.goToMyAccounts(component, event, helper);
    },
    redirectToHome : function (component, event, helper){
        helper.goToHome(component, event, helper);
    },
    redirectToListAccounts : function (component, event, helper){
        helper.goToListAccounts(component, event, helper);
    },
    //END Breadcrumb-task GSerrano SEPT-25-17
    
    
    //START CSM-13772 JRances -  Submit button is enabled even if text field for "Others" is blank
    Validate : function(component, event, helper) {
        var isValidMyAccount;
        var isValidReason;
        var reason;
        var myAccount = component.find("myAccountData").get("v.value");
        var selectedReason = component.find("reasonList").get("v.value");
        var selectedRSN = component.find("reasonList");
        selectedRSN.set("v.errors", null);
        var selectedACT = component.find("myAccountData");
        selectedACT.set("v.errors", null);
        
        //Check if there's an account selected
        //START CSM-13673 JRances - Inline Text Not Appearing in Paperless Billing Subscribe and Cancellation Pages
        if(myAccount == 'none'){
            var selected = component.find("myAccountData");            
            selected.set("v.errors", [{message:null}]);
            var elem = document.getElementById("checkIfAccountIsSelected2");
            elem.style.color = "#C23934";
            document.getElementById('checkIfAccountIsSelected2').classList.remove("slds-hide");
            isValidMyAccount = false;
        } else {
            document.getElementById('checkIfAccountIsSelected2').classList.add("slds-hide");
            isValidMyAccount = true;
        }
        //END CSM-13673 JRances
        
        //Check if there is a reason selected
        //START - CSM-13010 JRances - Update behavior        
        if(selectedReason == 'none'){
            var selected = component.find("reasonList");
            var elem = document.getElementById("selectReason");
            elem.style.color = "#C23934";
            elem.style.fontSize = "13.5px";
            document.getElementById('selectReason').classList.remove("slds-hide");
            selected.set("v.errors", [{message:null}]);
            isValidReason = false;
            
        } else {
            document.getElementById('selectReason').classList.add("slds-hide");
            
            if(selectedReason =='Others (please specify)'){            
                var selected = component.find("reasonText");
                var otherReasonselected = component.find("reasonText").get('v.value');
                if(otherReasonselected==''){
                    selected.set("v.errors", [{message:null}]);
                    var elem = document.getElementById("otherReasonNoInput");
                    elem.style.color = "#C23934";
                    elem.style.fontSize = "13.5px";
                    document.getElementById('otherReasonNoInput').classList.remove("slds-hide");
                    isValidReason = false;
                } else {
                    selected.set("v.errors", null);
                    document.getElementById('otherReasonNoInput').classList.add("slds-hide");
                    isValidReason = true;
                }
            } else {
                isValidReason = true;
            }
            reason = component.find("reasonList").get("v.value");
            console.log('custReason: >>>>>>>>>' + reason);
            console.log('myAccount: >>>>>>>>>>' + myAccount);
        }
        console.log('isValidMyAccount: >>>>>>>'+isValidMyAccount);
        console.log('isValidReason: >>>>>>>'+isValidReason);
        //END - CSM-13010 JRances
		
        if(isValidMyAccount && isValidReason){
            var isOther = false;
            if(selectedReason == 'Others (please specify)'){
                var otherReason = component.find('reasonText').get('v.value');
                reason = otherReason;
                isOther = true;
            }
            
            var action = component.get("c.insertCase");
            action.setParams({"account":myAccount,'reason':reason,'isOther': isOther});
            action.setCallback(this,function(response){    
                var state = response.getState();
                if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){  
                    console.log(response.getReturnValue());
                    if(response.getReturnValue().ReturnMe == "paperless lockin"){
                        console.log("paperless lockin");
                        var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                                         ];
                        var lockinDate = new Date(response.getReturnValue().lockIn);
                        //Start CSM-12560 Emandolado 9/14/2017
                        //var lockinDay =  lockinDate.getDay() + 1;
                        //var tomorrowDay = new Date(lockinDate);
                        //tomorrowDay.setDate(tomorrowDay.getDate()+1);
                        
                        //var message = lockinDay + " " + monthNames[lockinDate.getMonth()]  +" "+ lockinDate.getFullYear();                       
                        var message = lockinDate.getDate() + " " + monthNames[lockinDate.getMonth()]  +" "+ lockinDate.getFullYear();
                        //End CSM-12560 Emandolado 9/14/2017
                        console.log("message:" + message);
                        component.set('v.datePass' , message);
                        document.getElementById("mov-proceed-modal-prompt").style.display = "block";
                    }else{
                        console.log("not paperless lockin");
                        var NextPage = component.find("mainPage");
                        var PrevPage = component.find("SuccessPage");
                        $A.util.addClass(NextPage, "slds-hide");
                        $A.util.removeClass(NextPage, "slds-show");
                        $A.util.addClass(PrevPage, "slds-show");
                        $A.util.removeClass(PrevPage, "slds-hide");
                        component.set("v.reference" , response.getReturnValue().ReturnMe);
                    }
                }else{
                    //alert('yow');
                    console.log("Failed With state: " + state);
                    console.log("Returned:");
                    // console.log(response.getReturnValue());
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action); 
        }
    }
    //END CSM-13772 JRances
})