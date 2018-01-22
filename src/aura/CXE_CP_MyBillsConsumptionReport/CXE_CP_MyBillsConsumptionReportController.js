({
    doInit : function(component, event, helper) {
        var action = component.get("c.getData");
        action.setCallback(this,function(response){          
            var state = response.getState();
            console.log("state: "+ state);
            console.log("response.getReturnValue(): "+ response.getReturnValue());
            //FOR ACCOUNT LIST PART DROPDOWN
            
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                console.log("response.getReturnValue().UserType: "+ response.getReturnValue().UserType);
                if(response.getReturnValue().UserType){
                    component.set("v.UserType" , "Personal");
                }else{
                    component.set("v.UserType" , "Business");
                }
                // console.log(response.getReturnValue().accountAddData);
                // console.log('FirstHere');
                
                //FOR GETTING THE ACCOUNTS OF USER
                var AccountList = [];
                if(response.getReturnValue().ContractCount > 1){
                    console.log("response.getReturnValue().ContractCount: "+ response.getReturnValue().ContractCount);
                    //var AccountList = [];
                    AccountList.push({ class: "optionClass", label: "Select Account Number", value: "--Select All--", selected: "true" })
                    for(var i = 0; i < response.getReturnValue().ContractCount ; i++){
                        var CurrentValue = response.getReturnValue().UserContracts[i].V10_Account_No__c;
                        AccountList.push({ class: "optionClass", label: CurrentValue, value: CurrentValue});
                        component.find("accountSelected").set("v.options", AccountList);
                    }         
                }else if(response.getReturnValue().ContractCount == 0){
                    AccountList.push({ class: "optionClass", label: 'No Records To Show', value: 'No Records To Show'});
                    component.find("accountSelected").set("v.options", AccountList);
                }
                    else{
                        //var AccountList = [];
                        for(var i = 0; i < response.getReturnValue().ContractCount ; i++){
                            var CurrentValue = response.getReturnValue().UserContracts[i].V10_Account_No__c;
                            AccountList.push({ class: "optionClass", label: CurrentValue, value: CurrentValue});
                            component.find("accountSelected").set("v.options", AccountList);
                        }         
                    }
                console.log("response.getReturnValue().UserEnrollments: "+ response.getReturnValue().UserEnrollments);
                var ServiceEnrollments = response.getReturnValue().UserEnrollments;
                // console.log('this');
                // console.log(ServiceEnrollments);
                var SinList = [];
                if(response.getReturnValue().ServicesCount > 1){
                    //var SinList = [];
                    SinList.push({ class: "optionClass", label: "Select Service ID Number", value: "--Select All--", selected: "true" });
                    for(var i = 0 ; i < response.getReturnValue().ServicesCount ; i++){
                        for(var a = 0 ; a < response.getReturnValue().ServiceCount ; a++){
                            if(response.getReturnValue().UserEnrollments[a].CXE_ServiceId__c == response.getReturnValue().UserServices[i].Id){
                                var CurrentValue = response.getReturnValue().UserServices[i].SIN__c;
                                var CurrentAlias = response.getReturnValue().UserEnrollments[a].CXE_Alias__c;
                                //Start CSM-12852 Emandolado 9/27/2017
                                if(CurrentAlias){
                                    SinList.push({ class: "optionClass", label: CurrentValue + " - " + CurrentAlias, value: CurrentValue});
                                }else{
                                    SinList.push({ class: "optionClass", label: CurrentValue, value: CurrentValue});
                                }
                                //End CSM-12852 Emandolado 9/27/2017
                                //SinList.push({ class: "optionClass", label: CurrentValue + " - " + CurrentAlias, value: CurrentValue});
                                component.find("sinPopulated").set("v.options", SinList);
                            }
                        }
                    }
                }else if(response.getReturnValue().ServicesCount == 0){
                    // SinList.push({ class: "optionClass", label: "No Records To Show", value: "No Records To Show"});
                    //Start CSM-12852 Emandolado 9/27/2017
                    if(CurrentAlias){
                        SinList.push({ class: "optionClass", label: CurrentValue + " - " + CurrentAlias, value: CurrentValue});
                    }else{
                        SinList.push({ class: "optionClass", label: CurrentValue, value: CurrentValue});
                    }
                    //End CSM-12852 Emandolado 9/27/2017
                    component.find("sinPopulated").set("v.options", SinList);
                }
                    else{
                        //var SinList =[];
                        for(var i = 0 ; i < response.getReturnValue().ServicesCount ; i++){
                            for(var a = 0 ; a < response.getReturnValue().ServiceCount ; a++){
                                if(response.getReturnValue().UserEnrollments[a].CXE_ServiceId__c == response.getReturnValue().UserServices[i].Id){
                                    var CurrentValue = response.getReturnValue().UserServices[i].SIN__c;
                                    var CurrentAlias = response.getReturnValue().UserEnrollments[a].CXE_Alias__c;
                                    // SinList.push({ class: "optionClass", label: CurrentValue + " - " + CurrentAlias, value: CurrentValue ,selected:"true"});
                                    //Start CSM-12852 Emandolado 9/27/2017
                                    if(CurrentAlias){
                                        SinList.push({ class: "optionClass", label: CurrentValue + " - " + CurrentAlias, value: CurrentValue});
                                    }else{
                                        SinList.push({ class: "optionClass", label: CurrentValue, value: CurrentValue});
                                    }
                                    //End CSM-12852 Emandolado 9/27/2017
                                    component.find("sinPopulated").set("v.options", SinList);
                                    helper.loadTable(component,response.getReturnValue().UserServices[i].SIN__c); //CSM-12446 Emandolado 9/5/2017
                                }
                            }
                        }
                    }
                
                component.set("v.UserDataHolder", response.getReturnValue());
                // console.log(response.getReturnValue().UserEnrollments);
                component.set("v.Enrollments", response.getReturnValue().UserEnrollments);
                //  component.set("v.accts" , AccountList);
                //component.set("v.sins", SinList);
                // console.log(response.getReturnValue());
                var AccSelected = component.find("accountSelected").get("v.value");
                var SinSelected = component.find("sinPopulated").get("v.value");
                // console.log("ACC>>>>"+AccSelected);
                // console.log("Sin>>>>"+SinSelected)
                
                
                var sPageURL = decodeURIComponent(window.location.search.substring(1)); //get whole URL of the page
                var sParameterName;
                sParameterName = sPageURL.split('=');
                var selectedParam = sParameterName[1];
                if(selectedParam != undefined && response.getReturnValue().ServicesCount!=1){ //CSM-12838 GGrandea 09.21.2017
                    component.find('sinPopulated').set('v.value',selectedParam);
                    var UserData = component.get("v.UserDataHolder");
                    var selectedValue = selectedParam;
                    console.log('Selected Account: ' + selectedParam);
                    var listOfServiceAgreements = UserData.UserServices;
                    
                    for(var i = 0 ; i < UserData.ServiceCount ; i++){
                        
                        if(listOfServiceAgreements[i].SIN__c == selectedValue){
                            console.log(UserData.UserServices[i].Payor__r.V10_Account_No__c);
                            var CurrentValue = UserData.UserServices[i].Payor__r.V10_Account_No__c;
                            component.find('accountSelected').set('v.value',CurrentValue);
                            helper.loadTable(component,selectedValue);
                        }
                    }
                }
            }else{
                
                //alert('yow');
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });  
        $A.enqueueAction(action); 
        
        
    },
    //FOR CONTROLLING PICKLIST
    handleAccountChange : function (component, event, helper){         
        var selectedValue = component.find("accountSelected").get("v.value");
        console.log(component.get("v.UserDataHolder"));
        console.log('Selected Account: ' + selectedValue);     
        var SinList = [];
        var accountId = selectedValue;
        //var listOfServiceAgreements =  component.get("v.UserDataHolder"); 
        var UserData = component.get("v.UserDataHolder");
        console.log('hereFINAL');
        console.log(UserData);
        var sinSelected;
        for(var i = 0 ; i < UserData.ServicesCount ; i++){
            console.log('UserData.UserServices[i].Payor__r.V10_Account_No__c : '+ UserData.UserServices[i].Payor__r.V10_Account_No__c);
            console.log('im here 1');
            if(accountId != "--Select All--"){
                if(UserData.UserServices[i].Payor__r.V10_Account_No__c == selectedValue){
                    
                    for(var a = 0 ; a < UserData.ServiceCount ; a++){
                        if(UserData.UserEnrollments[a].CXE_ServiceId__c == UserData.UserServices[i].Id){
                            //console.log('im here 3');
                            //console.log(UserData.UserServices[i].Payor__r.V10_Account_No__c);
                            var CurrentValue = UserData.UserServices[i].SIN__c;
                            var CurrentAlias = UserData.UserEnrollments[a].CXE_Alias__c;
                            //console.log(UserData.UserServices[i].SIN__c);
                            //SinList.push({ class: "optionClass", label: CurrentValue + " - " + CurrentAlias, value: CurrentValue});
                            //Start CSM-12852 Emandolado 9/27/2017
                            if(CurrentAlias){
                                SinList.push({ class: "optionClass", label: CurrentValue + " - " + CurrentAlias, value: CurrentValue});
                            }else{
                                SinList.push({ class: "optionClass", label: CurrentValue, value: CurrentValue});
                            }
                            //End CSM-12852 Emandolado 9/27/2017
                            sinSelected = CurrentValue;
                            //console.log(UserData.UserServices[i].Payor__c); 
                            //console.log('finish');
                            //console.log(SinList);
                        }
                    }
                }
            }else{
                for(var a = 0 ; a < UserData.ServiceCount ; a++){
                    if(UserData.UserEnrollments[a].CXE_ServiceId__c == UserData.UserServices[i].Id){
                        var CurrentValue = UserData.UserServices[i].SIN__c;
                        var CurrentAlias = UserData.UserEnrollments[a].CXE_Alias__c;
                        //SinList.push({ class: "optionClass", label: CurrentValue + " - " + CurrentAlias, value: CurrentValue});
                        //Start CSM-12852 Emandolado 9/27/2017
                        if(CurrentAlias){
                            SinList.push({ class: "optionClass", label: CurrentValue + " - " + CurrentAlias, value: CurrentValue});
                        }else{
                            SinList.push({ class: "optionClass", label: CurrentValue, value: CurrentValue});
                        }
                        //End CSM-12852 Emandolado 9/27/2017
                        console.log('finish');
                    }
                }
            }
            
        }
        if(SinList.length> 1){
            SinList.unshift({ class: "optionClass", label: "Select Service ID Number", value: "--Select All--", selected: "true" })
        }if(SinList.length == 1){
            helper.loadTable(component,sinSelected);
        }
        //console.log('here>>');
        //console.log(SinList);
        
        component.find("sinPopulated").set("v.options", SinList);  
        
    },
    
    handleSinChange : function (component, event, helper){
        
        var UserData = component.get("v.UserDataHolder");
        var selectedValue = component.find("sinPopulated").get("v.value");
        console.log('Selected Account: ' + selectedValue);
        var SinList = [];
        var accountId = selectedValue;
        var listOfServiceAgreements = UserData.UserServices; 
        for(var i = 0 ; i < UserData.ServiceCount ; i++){
            if(listOfServiceAgreements[i].SIN__c == selectedValue){
                console.log(UserData.UserServices[i].Payor__r.V10_Account_No__c);
                var CurrentValue = UserData.UserServices[i].Payor__r.V10_Account_No__c;
                component.find('accountSelected').set('v.value',CurrentValue);
                helper.loadTable(component,selectedValue);
            }
        }
        
        
    },
    itemsChange  : function(component, event, helper) {
        
        var nweSIN = component.get("v.sinPass");
        component.find('sinPopulated').set('v.value',nweSIN);
        
        var UserData = component.get("v.UserDataHolder");
        var selectedValue = nweSIN;
        console.log('Selected Account: ' + selectedValue);
        
        var accountId = selectedValue;
        for(var i = 0 ; i < UserData.ServiceCount ; i++){
            if(listOfServiceAgreements[i].SIN__c == selectedValue){
                console.log(UserData.UserServices[i].Payor__r.V10_Account_No__c);
                var CurrentValue = UserData.UserServices[i].Payor__r.V10_Account_No__c;
                component.find('accountSelected').set('v.value',CurrentValue);
                helper.loadTable(component,selectedValue);
            }
        }
        
    },
    initChart : function(component, event, helper) {
        console.log('loaded');   
    },
    
    
    //Start CSM-12826 Mike Verdad 09/22/17
    redirectToMybills : function (component, event, helper){
        helper.goToMybills(component, event, helper);
    },
    //End CSM-12826 Mike Verdad 09/22/17
    
    //START Breadcrumb-task IPenaflor SEPT-25-17
    redirectToHome : function (component, event, helper){
        helper.goToHome(component, event, helper);
    }
    //END Breadcrumb-task IPenaflor SEPT-25-17
})