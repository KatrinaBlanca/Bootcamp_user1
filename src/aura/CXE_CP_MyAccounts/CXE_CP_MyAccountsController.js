({
    doInit : function(component, event, helper) {
        var action = component.get("c.getBills");
        action.setCallback(this,function(response){          
            var state = response.getState();
            
            //FOR ACCOUNT LIST PART DROPDOWN
            console.log(response.getReturnValue());
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                if(response.getReturnValue().UserType){
                    component.set("v.UserType" , "Personal");
                }else{
                    component.set("v.UserType" , "Business");
                }
                // console.log(response.getReturnValue().accountAddData);
                // console.log('FirstHere');
                
                //START R2C CSM-13274 Shayne
                console.log('conglomerate '+response.getReturnValue().isConglomerate);
                component.set("v.isConglomerate", response.getReturnValue().isConglomerate);
                //END R2C CSM-13274 Shayne
                
                //FOR GETTING THE ACCOUNTS OF USER
                if(response.getReturnValue().ContractCount > 1){
                    var AccountList = [];
                    AccountList.push({ class: "optionClass", label: "Select Account Number", value: "--Select All--", selected: "true" }); //START/END CSM-15117 error in UAT
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
                        var AccountList = [];
                        for(var i = 0; i < response.getReturnValue().ContractCount ; i++){
                            var CurrentValue = response.getReturnValue().UserContracts[i].V10_Account_No__c;
                            AccountList.push({ class: "optionClass", label: CurrentValue, value: CurrentValue});
                            component.find("accountSelected").set("v.options", AccountList);
                        }         
                    }
                var ServiceEnrollments = response.getReturnValue().UserEnrollments;
                // console.log('this');
                // console.log(ServiceEnrollments);
                // START R2C CSM-14375 Shayne 11-09-2017
                if(response.getReturnValue().ServicesCount > 0) component.set('v.sinCount',response.getReturnValue().ServicesCount);
                // END R2C CSM-14375 Shayne 11-09-2017
                if(response.getReturnValue().ServicesCount > 1){
                    var SinList = [];
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
                                component.find("sinPopulated").set("v.options", SinList);
                            }
                        }
                    }
                }else if(response.getReturnValue().ServicesCount == 0){
                    SinList.push({ class: "optionClass", label: "No Records To Show", value: "No Records To Show"});
                    component.find("sinPopulated").set("v.options", SinList);
                }
                    else{
                        var SinList =[];
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
                                    component.find("sinPopulated").set("v.options", SinList);
                                }
                            }
                        }
                    }
                
                component.set("v.UserDataHolder", response.getReturnValue());
                // console.log(response.getReturnValue().UserEnrollments);
                component.set("v.Enrollments", response.getReturnValue().UserEnrollments);
                component.set("v.accts" , AccountList);
                component.set("v.sins", SinList);
                
                //Start CSM-13719  Melvin Corbes Oct. 10, 2017 
                //component.set("v.caseBPOpenMap", response.getReturnValue().acctNoHasOpenPBCaseMap);//CSM-13893 Melvin Corbes Oct. 13, 2017 
                //End CSM-13719  Melvin Corbes Oct. 10, 2017 
                
                // console.log(response.getReturnValue());
                var AccSelected = component.find("accountSelected").get("v.value");
                var SinSelected = component.find("sinPopulated").get("v.value");
                // console.log("ACC>>>>"+AccSelected);
                // console.log("Sin>>>>"+SinSelected)
                
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
        console.log(UserData.ServicesCount);
        for(var i = 0 ; i < UserData.ServicesCount ; i++){
            console.log('UserData.UserServices[i].Payor__r.V10_Account_No__c : '+ UserData.UserServices[i].Payor__r.V10_Account_No__c);
            console.log('im here 1');
            console.log('im here 2');
            if(accountId != "--Select All--"){
                if(UserData.UserServices[i].Payor__r.V10_Account_No__c == selectedValue){
                    for(var a = 0 ; a < UserData.ServiceCount ; a++){
                        if(UserData.UserEnrollments[a].CXE_ServiceId__c == UserData.UserServices[i].Id){
                            console.log('im here 3');
                            console.log(UserData.UserServices[i].Payor__r.V10_Account_No__c);
                            var CurrentValue = UserData.UserServices[i].SIN__c;
                            var CurrentAlias = UserData.UserEnrollments[a].CXE_Alias__c;
                            console.log(UserData.UserServices[i].SIN__c);
                            
                             //Start CSM-12852 Corbes 10/4/2017
                                if(CurrentAlias){
                                    SinList.push({ class: "optionClass", label: CurrentValue + " - " + CurrentAlias, value: CurrentValue});
                                }else{
                                    SinList.push({ class: "optionClass", label: CurrentValue, value: CurrentValue});
                                }
                             //End CSM-12852 Corbes 10/4/2017
                            
                            console.log(UserData.UserServices[i].Payor__c); 
                            console.log('finish');
                            console.log(SinList);
                        }
                    }
                }
            }else{
                for(var a = 0 ; a < UserData.ServiceCount ; a++){
                    if(UserData.UserEnrollments[a].CXE_ServiceId__c == UserData.UserServices[i].Id){
                        var CurrentValue = UserData.UserServices[i].SIN__c;
                        var CurrentAlias = UserData.UserEnrollments[a].CXE_Alias__c;
                        
                        //Start CSM-12852 Corbes 10/4/2017
                        if(CurrentAlias){
                            SinList.push({ class: "optionClass", label: CurrentValue + " - " + CurrentAlias, value: CurrentValue});
                        }else{
                            SinList.push({ class: "optionClass", label: CurrentValue, value: CurrentValue});
                        }
                        //End CSM-12852 Corbes 10/4/2017
                            
                        
                        console.log('finish');
                    }
                }
            }
            
        }
        if(SinList.length> 1){
            SinList.unshift({ class: "optionClass", label: "Select Service ID Number", value: "--Select All--", selected: "true" })
        }
        console.log(SinList);
        component.find("sinPopulated").set("v.options", SinList);  
    },
    
    EventFire : function (component, event){
        component.set("v.WithSin", "noSin");
        var eventValue= event.getParam("attributeValue");
        
        var MainPage = component.find('MainForm');
        var ResultPage = component.find('result');
        
        //$A.util.removeClass(MainPage, 'Hideme');
        //$A.util.addClass(ResultPage, 'Hideme');
        
        //Start CSM-12559 Emandoaldo 9/14/2017
        var PaperlessPage = component.find('unsubPaperlessBilling');
        var MainPageNav = component.find('MainFormNav');
        $A.util.removeClass(MainPage, 'slds-hide');
        $A.util.addClass(MainPage, 'slds-show');
        $A.util.removeClass(MainPageNav, 'slds-hide');
        $A.util.addClass(MainPageNav, 'slds-show');
        $A.util.removeClass(ResultPage, 'slds-show');
        $A.util.addClass(ResultPage, 'slds-hide');
        $A.util.removeClass(PaperlessPage, 'slds-show');
        $A.util.addClass(PaperlessPage, 'slds-hide');
        //End CSM-12559 Emandolado 9/14/2017
        
        
        var setEvent = component.getEvent("setAttribute");
        setEvent.setParams({"attributeValue":'None'});
        setEvent.fire()
    },
    
    
    editAlias : function (component, event, helper){
        var currentalias = event.getSource().get("v.label");
        var currentId =event.getSource().get("v.buttonTitle");
        component.set("v.isOpen", true);
        component.set("v.currentAura",currentalias);
        component.set("v.currentId",currentId);
    },
    closeModel : function (component, event, helper){
        component.set("v.isOpen", false);     
    },
    saveAura : function (component, event, helper){
        var currentId = component.get("v.currentId");
        var newAura = component.find('input_aura').get("v.value");
        var action = component.get("c.changeAura");
        action.setParams({"SINId":currentId,"NewAura":newAura});
        action.setCallback(this,function(response){    
            var state = response.getState();
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){   
                helper.searched(component, event, helper);
                if(response.getReturnValue() == "Save Successfully"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success",
                        "type": "Success",
                        "message": "Record is updated"
                    });
                    toastEvent.fire();   
                }
            }else{
                //alert('yow');
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
        
        
        
        
        component.set("v.isOpen", false);
    },
    SearchAccount : function (component, event, helper){
        var SelectedAccount = event.getSource().get("v.label");  
        var action = component.get("c.SelectedData");
        action.setParams({"accountSelected":SelectedAccount,"sinSelected":''});
        action.setCallback(this,function(response){    
            var state = response.getState();
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                console.log(response.getReturnValue());
                
                component.set("v.dataReceived", response.getReturnValue());
                var MainPage = component.find('MainForm');
                //$A.util.addClass(MainPage, 'Hideme');
                var ResultPage = component.find('result');
                // $A.util.removeClass(ResultPage, 'Hideme');
                
                //Start CSM-12559 Emandoaldo 9/14/2017
                $A.util.addClass(MainPage, 'slds-hide');
                $A.util.removeClass(MainPage, 'slds-show');
                $A.util.addClass(ResultPage, 'slds-show');
                $A.util.removeClass(ResultPage, 'slds-hide');
                //End CSM-12559 Emandoaldo 9/14/2017
                document.body.scrollTop = 0;
                document.documentElement.scrollTop = 0;
            }else{
                //alert('yow');
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
        
    },
    SearchSin : function (component, event, helper){
        
        var SelectedAccount = event.getSource().get("v.label");  
        var action = component.get("c.SelectedData");
        action.setParams({"accountSelected":'',"sinSelected":SelectedAccount});
        action.setCallback(this,function(response){    
            var state = response.getState();
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                console.log(response.getReturnValue());
                
                component.set("v.dataReceived", response.getReturnValue());
                component.set("v.WithSin", "WithSin");
                var MainPage = component.find('MainForm');
                //$A.util.addClass(MainPage, 'Hideme');
                var ResultPage = component.find('result');
                //$A.util.removeClass(ResultPage, 'Hideme');
                
                //Start CSM-12559 Emandoaldo 9/14/2017
                $A.util.addClass(MainPage, 'slds-hide');
                $A.util.removeClass(MainPage, 'slds-show');
                $A.util.addClass(ResultPage, 'slds-show');
                $A.util.removeClass(ResultPage, 'slds-hide');
                //Start CSM-12559 Emandoaldo 9/14/2017
                document.body.scrollTop = 0;
                document.documentElement.scrollTop = 0;
            }else{
                //alert('yow');
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
    },
    
    
    Validate : function (component, event, helper){
        
        helper.searched(component, event, helper);
    },
    
    sinCheckChange : function (component, event, helper){
        var SelectedCheckbox = event.getSource().get("v.name");
        component.set("v.sinCheckHolder", SelectedCheckbox);
        
    },
    CheckboxChange  : function (component, event, helper){
        // START R2C CSM-13274 Shayne 10/12/2017
        var conglomerate = component.get("v.isConglomerate");
        console.log('conglomerate '+conglomerate);
        // END R2C CSM-13274 Shayne 10/12/2017
        var btn = component.find("unsubscirbeBTN").set("v.disabled",true);
        var btn = component.find("subscribeBTN").set("v.disabled",true);
        var Checker = component.get("v.CheckValidation");
        var accountData = component.get("v.UserDataHolder").accountAddData;
        var SelectedCheckbox = event.getSource().get("v.name");
        component.set("v.acctCheckHolder", SelectedCheckbox);
        var checkboxes = component.find("DependentCheckbox");
        var Incheckboxes = component.find("InDependentCheckbox");
        var checker = false;
        var selectedCheckboxValue = event.getSource().get("v.value");
        /*CSM-13893 Melvin Corbes Oct. 13, 2017 
         * 
        //Start CSM-13719  Melvin Corbes Oct. 10, 2017   
       
        var caseBPOpenMap = component.get("v.caseBPOpenMap");
        
        var caseOpenStatusMap = new Map();  
        for (var prop in caseBPOpenMap) {
            caseOpenStatusMap.set(prop,caseBPOpenMap[prop]);  
            console.log('[key]'+ prop +'[value]'+ caseBPOpenMap[prop]);
        }
        
        //End CSM-13719  Melvin Corbes Oct. 10, 2017 
        */ //CSM-13893 Melvin Corbes Oct. 13, 2017   
        console.log(accountData.length);
        console.log('selectedCheckBox>>>>>'+SelectedCheckbox);
        
        //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
        var isEnable = event.getSource().get("v.value");
        var valApaE = event.getSource().get("v.text");
        var valApaC = event.getSource().get("v.labelClass");
        
        if(isEnable == true && valApaE == true){ // R2C CSM-14581 Shayne 12/06/2017 - Removed conglomerate condition
            component.set("v.isApaEnroll",false);
            component.set("v.currentId",SelectedCheckbox);
            component.set("v.EnrollCursor", "cursor: pointer;");
        }
        else{
            component.set("v.isApaEnroll",true);
            component.set("v.EnrollCursor","cursor: default;"); 

        }
        
        if(isEnable == true && valApaC == true){ // R2C CSM-14581 Shayne 12/06/2017 - Removed conglomerate condition
            component.set("v.isApaCancel",false);
            component.set("v.currentId",SelectedCheckbox);
            component.set("v.CancelCursor", "cursor: pointer;");
        }
        else{
            component.set("v.isApaCancel",true);
            component.set("v.CancelCursor","cursor: default;");           
          
        }
        //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
        
        //Start Emandolado 9/25/2017 CSM-12941
        for(var i = 0 ; i < accountData.length ; i++){
            if(SelectedCheckbox == accountData[i].AccountId){
            /* Start of CSM-13893  Melvin Corbes OCt.13,2017
            //Start CSM-13719  Melvin Corbes Oct. 10, 2017            
             var hasOpenCase = caseOpenStatusMap.get(accountData[i].AccountId);
             console.log('HasOpenCase?: value is:'+ hasOpenCase);
             console.log('BPM: value is:'+ accountData[i].PrintMode);
            //End CSM-13719  Melvin Corbes Oct. 10, 2017
             */ //End of CSM-13893 Melvin Corbes OCt.13,2017  
                if(accountData[i].PrintMode == "BILPRNT003" && selectedCheckboxValue){ // R2C CSM-14581 Shayne 12/06/2017 - Removed conglomerate condition
                    var btn = component.find("unsubscirbeBTN").set("v.disabled",false);
                }
                //START CSM-12855 GGrandea 09.20.2017
                //if(accountData[i].PrintMode == "BILPRNT002" && accountData[i].Type == "Payor"){
               // if(accountData[i].PrintMode == "BILPRNT002" && selectedCheckboxValue && hasOpenCase == false ){ //CSM-13893 Melvin Corbes Oct. 13, 2017
               if(accountData[i].PrintMode == "BILPRNT002" && selectedCheckboxValue){  // R2C CSM-14581 Shayne 12/06/2017 - Removed conglomerate condition
                    var btn = component.find("subscribeBTN").set("v.disabled",false);
                    //START CSM-12870 GGrandea 09.21.2017
                    if(accountData[i].Type == "Payor"){
                        component.find('paperlessBillSubCmp').set("v.accountSelected", true);
                    }else{
                        component.find('paperlessBillSubCmp').set("v.accountPass", "None");
                    }
                    //END CSM-12870 GGrandea 09.21.2017
                }
                //END CSM-12855 GGrandea 09.20.2017
            }
        }
        if(checkboxes.length == undefined){
            checkboxes.set('v.value' , selectedCheckboxValue);
            
        }else{
            if(event.getSource().get("v.value")){
                
                for (var i = 0; i < checkboxes.length; i++){
                    checkboxes[i].set("v.value",false);
                }
                
                for (var a = 0; a < Incheckboxes.length; a++){
                    if(Incheckboxes[a].get("v.name") != SelectedCheckbox){
                        Incheckboxes[a].set("v.value",false);
                    }
                }
                
                
                for (var i = 0; i < checkboxes.length; i++){
                    if(checkboxes[i].get("v.class") == SelectedCheckbox){
                        checkboxes[i].set("v.value",true);
                    }
                }
                
            }else{
                for (var i = 0; i < checkboxes.length; i++){
                    checkboxes[i].set("v.value",false);
                }
                
                for (var a = 0; a < Incheckboxes.length; a++){
                    if(Incheckboxes[a].get("v.name") != SelectedCheckbox){
                        Incheckboxes[a].set("v.value",false);
                    }
                }
            }
        }
        //End Emandolado 9/25/2017 CSM-12941
        

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
    
    onClickReactiveService : function (component, event, helper) {        
        helper.loadReactivateForm(component, event, helper);        
    },
    
    onClickTerminateService : function (component, event, helper) {        
        helper.loadTerminateForm(component, event, helper);        
    },
    
    onClickChangeService : function (component, event, helper) { 
        helper.loadChangeServiceForm(component, event, helper);        
    },
    
    onClickChangeContract : function (component, event, helper) {        
        helper.loadChangeContractForm(component, event, helper);        
    },
    onClickUnSubPaperlessBilling : function (component, event, helper) { 
     //START R2C CSM-14581 Shayne 12/06/2017 modal for conglo user
         if(component.get("v.isConglomerate")){
            var message= $A.get("$Label.c.CONGLOMERATE_ERROR_PAGE");
            component.set('v.congloMessage', message);
            component.set('v.isCongloModal', true);
        }else{

        /* var checkboxes = component.find("InDependentCheckbox");
        var selectedCheckbox = [];
        var istrue = false;
        
        if(checkboxes.length == undefined){
            selectedCheckbox.push(component.get("v.acctCheckHolder"));
            istrue = true;
        }else{
            for (var i = 0; i < checkboxes.length; i++){
                if(checkboxes[i].get("v.value") == true){
                    selectedCheckbox.push(checkboxes[i].get("v.name")); 
                    istrue = true;
                }
            }
        }
        
        if(istrue){
            var action = component.get("c.unenroll");
            action.setParams({"accId":selectedCheckbox[0]});
            action.setCallback(this,function(response){    
                var state = response.getState();
                if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){ 
                    console.log(response.getReturnValue());
                    if(response.getReturnValue()[0].Bill_Print_Mode__c == "Paperless"){
                        var paperlessPage = component.find("unsubPaperlessBilling");
                        var mainPage = component.find("MainForm");
                        var mainPageNav = component.find("MainFormNav");
                        $A.util.toggleClass(paperlessPage, "slds-show");
                        $A.util.toggleClass(mainPage, "slds-hide");
                        $A.util.toggleClass(mainPageNav, "slds-hide");
                        document.body.scrollTop = 0;
                        document.documentElement.scrollTop = 0;
                    }else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error",
                            "type": "Error",
                            "message": "This account is not registered to paperless billing"
                        });
                        toastEvent.fire();   
                    }
                }else{
                    //alert('yow');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "type": "Error",
                        "message": "This account is not registered to paperless billing"
                    });
                    toastEvent.fire();   
                }
            });
            $A.enqueueAction(action); 
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error",
                "type": "Error",
                "message": "Please Select an account"
            });
            toastEvent.fire();   
        } */
        
        var paperlessPage = component.find("unsubPaperlessBilling");
        var mainPage = component.find("MainForm");
        var mainPageNav = component.find("MainFormNav");
        // $A.util.toggleClass(paperlessPage, "slds-show");
        //$A.util.toggleClass(mainPage, "slds-hide");
        //$A.util.toggleClass(mainPageNav, "slds-hide");
        
        //Start CSM-12559 Emandolado 9/14/2017
        $A.util.addClass(paperlessPage, "slds-show");
        $A.util.removeClass(paperlessPage, "slds-hide");
        $A.util.addClass(mainPage, "slds-hide");
        $A.util.removeClass(mainPage, "slds-show");
        $A.util.addClass(mainPageNav, "slds-hide");
        $A.util.removeClass(mainPageNav, "slds-show");
        //End CSM-12559 Emandolado 9/14/2017
        document.body.scrollTop = 0;
        document.documentElement.scrollTop = 0;
        } //END R2C CSM-14581 Shayne 12/06/2017 modal for conglo user
    },
    
    onClickPaperlessBilling : function (component, event, helper) { 
        //START R2C CSM-14581 Shayne 12/06/2017 modal for conglo user
        if(component.get("v.isConglomerate")){
            var message= $A.get("$Label.c.CONGLOMERATE_ERROR_PAGE");
            component.set('v.congloMessage', message);
            component.set('v.isCongloModal', true);
        }else{

        /* var checkboxes = component.find("InDependentCheckbox");
        var selectedCheckbox = [];
        var istrue = false;
        //ert(checkboxes.length); 
        console.log(component.get("v.acctCheckHolder"));
        console.log(checkboxes.length);
        if(checkboxes.length == undefined){
            selectedCheckbox.push(component.get("v.acctCheckHolder"));
            istrue = true;
        }else{
            for (var i = 0; i < checkboxes.length; i++){
                if(checkboxes[i].get("v.value") == true){
                    selectedCheckbox.push(checkboxes[i].get("v.name")); 
                    istrue = true;
                }
            }
        }
        console.log('HERE>>>>>>>>>>>>>>>>>>>>>>>>');
        console.log(selectedCheckbox);
        //alert(selectedCheckbox[0]);
        if(istrue){
            var action = component.get("c.enrollPaperless");
            action.setParams({"accId":selectedCheckbox[0]});
            action.setCallback(this,function(response){    
                var state = response.getState();
                if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){  
                    var returnval = (response.getReturnValue());
                    if(returnval.acctType =="Payor" && returnval.acctEnrollee.Payor__r.Bill_Print_Mode__c == "Paperplus"){
                        var paperlessPage = component.find("PaperlessBilling");
                        var mainPage = component.find("MainForm");
                        var mainPageNav = component.find("MainFormNav");
                        $A.util.toggleClass(paperlessPage, "slds-show");
                        $A.util.toggleClass(mainPage, "slds-hide");
                        $A.util.toggleClass(mainPageNav, "slds-hide");
                        document.body.scrollTop = 0;
                        document.documentElement.scrollTop = 0;
                    }else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error",
                            "type": "Error",
                            "message": "This account is already registered or this account is not a payor"
                        });
                        toastEvent.fire();   
                    }
                    console.log(returnval.acctEnrollee.Payor__r.Bill_Print_Mode__c);
                    console.log(response.getReturnValue());
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error",
                            "type": "Error",
                            "message": "This account is already registered or this account is not a payor"
                        });
                        toastEvent.fire();
                }
            });
            $A.enqueueAction(action); 
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error",
                "type": "Error",
                "message": "Please Select an account"
            });
            toastEvent.fire();   
        }
    */
        
        var paperlessPage = component.find("PaperlessBilling");
        var mainPage = component.find("MainForm");
        var mainPageNav = component.find("MainFormNav");
        //$A.util.toggleClass(paperlessPage, "slds-show");
        //$A.util.toggleClass(mainPage, "slds-hide");
        //$A.util.toggleClass(mainPageNav, "slds-hide");
        
        //Start CSM-12559 Emandolado 9/14/2017
        $A.util.addClass(paperlessPage, "slds-show");
        $A.util.removeClass(paperlessPage, "slds-hide");
        $A.util.addClass(mainPage, "slds-hide");
        $A.util.removeClass(mainPage, "slds-show");
        $A.util.addClass(mainPageNav, "slds-hide");
        $A.util.removeClass(mainPageNav, "slds-show");
        //End CSM-12559 Emandolado 9/14/2017
        document.body.scrollTop = 0;
        document.documentElement.scrollTop = 0;
        }
        //END R2C CSM-14581 Shayne 12/06/2017 modal for conglo user
    },
    // START CSM-14333 Jerome To 11/22/2017 As a customer, I should be able to go back to the previous pages I navigated through the clickable breadcrumbs displayed on the left portion of the screen below the tabs.
    goToElecService : function (component, event, helper) {
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/startservice?previousPage=accounts';
        window.location.assign(pageUrl);     
    },
    // END CSM-14333 Jerome To 11/22/2017 As a customer, I should be able to go back to the previous pages I navigated through the clickable breadcrumbs displayed on the left portion of the screen below the tabs.
    //Start CSM-12548 Mike 09/25/2017
    EventFirePaperlessBilling : function (component, event, helper){
        helper.EventFirePaperlessBillingHelper(component, event, helper);
    }
    //End CSM-12548 Mike 09/25/2017
    
    
    //START Breadcrumb-task IPenaflor SEPT-25-17
    , redirectToHome : function (component, event, helper){
        helper.goToHome(component, event, helper);
    },
    
    redirectToMyAccounts : function (component, event, helper){
        helper.goToMyAccounts(component, event, helper);
    },
    //END Breadcrumb-task IPenaflor SEPT-25-17
    
    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
    redirectToEnrollAutoPayment: function (component, event, helper){
        //START R2C CSM-14581 Shayne 12/06/2017 modal for conglo user
        if(component.get("v.isConglomerate")){
            var message= $A.get("$Label.c.CONGLOMERATE_ERROR_PAGE");
            component.set('v.congloMessage', message);
            component.set('v.isCongloModal', true);
        }
        else{
            helper.goToAutopayenroll(component, event, helper);
        }        
        //END R2C CSM-14581 Shayne 12/06/2017 modal for conglo user
    },
    redirectToCancelAutoPayment: function (component, event, helper){
         //START R2C CSM-14581 Shayne 12/06/2017 modal for conglo user
        if(component.get("v.isConglomerate")){
            var message= $A.get("$Label.c.CONGLOMERATE_ERROR_PAGE");
            component.set('v.congloMessage', message);
            component.set('v.isCongloModal', true);
        }
        else{
            helper.goToautopayunsub(component, event, helper);
        }        
        //END R2C CSM-14581 Shayne 12/06/2017 modal for conglo user
    }
    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
    
})