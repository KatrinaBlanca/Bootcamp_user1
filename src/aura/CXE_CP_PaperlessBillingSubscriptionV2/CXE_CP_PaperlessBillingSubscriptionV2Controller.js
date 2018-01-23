({
    doInit : function(component, event, helper) {
        console.log('here');
        helper.initializeCheckConglomerate(component, event); //START/END R2C CSM-13274 Shayne 10-13-17
        var action = component.get("c.loadAccounts");
        action.setCallback(this,function(response){    
            var state = response.getState();
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){  
                console.log(response.getReturnValue());
                var returnVal = response.getReturnValue();
                var AccountList = [];
                //START CSM-12870 GGrandea 09.21.2017
                //if(returnVal.length > 1){
                if(returnVal.length > 0){
                //END CSM-12870 GGrandea 09.21.2017

                    AccountList.push({ class: "optionClass", label: "Select Account Number", value: "None", selected: "true" })                    
                    for(var i = 0; i < returnVal.length ; i++){
                        var CurrentValue = returnVal[i];
                        AccountList.push({ class: "optionClass", label: CurrentValue.V10_Account_No__c, value: CurrentValue.V10_Account_No__c});
                    }       
                }else if(returnVal.length == 0){
                    AccountList.push({ class: "optionClass", label: "No Accounts Available" , value: "None"});
                }
                    //START CSM-12870 GGrandea 09.21.2017
                    /*else{
                        for(var i = 0; i < returnVal.length ; i++){     
                            var CurrentValue = returnVal[i];
                            AccountList.push({ class: "optionClass", label: CurrentValue.V10_Account_No__c, value: CurrentValue.V10_Account_No__c, selected: "true"});               
                        }      
                    }*/
                    //END CSM-12870 GGrandea 09.21.2017
                
                component.find("myAccountData").set("v.options", AccountList);
                
            }else{
                //alert('yow');
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
    },
    
    showTerms : function(component, event, helper) {
        component.set("v.isOpen", true);
        document.getElementById("mov-modal_lboxTerms").style.display = "block";
    }, 
    accountChange  : function(component, event, helper) {
        var selectedData = component.get("v.accountPass");
        component.find('myAccountData').set('v.value' , selectedData);
    },
    
    //START CSM-13672 JRances - Enable the 'Next' button in Paperless Billing page 
    /*
    checkboxChange: function(component, event, helper) {
        //START CSM-12870 GGrandea 09.21.2017
        var selectedAccountDropdown = component.find('myAccountData').get('v.value');
        if(selectedAccountDropdown!="None"){
            component.set("v.accountSelected", true);
        }else{
            component.set("v.accountSelected", false);
        }
        //END CSM-12870 GGrandea 09.21.2017
    },
    */
    //END CSM-13672 JRances
    
    closeModalProceed : function(component, event, helper) {
        document.getElementById("mov-proceed-modal").style.display = "none";
    },
    EventFire : function (component, event){
          var eventValue= event.getParam("attributeValue");
        component.set("v.changeBox", eventValue);
        var navigator= event.getParam("successValue");
        var reference= event.getParam("reference");
        if(navigator){
            
            var NextPage = component.find("PaperlessBillingSubscribe");
            var PrevPage = component.find("PaperlessBillingSuccess");
            component.set("v.reference" , reference);
            $A.util.addClass(NextPage, "slds-hide");
            $A.util.removeClass(NextPage, "slds-show");
            $A.util.addClass(PrevPage, "slds-show");
            $A.util.removeClass(PrevPage, "slds-hide");
        }else{
            var NextPage = component.find("PaperlessBillingSubscribe");
            var PrevPage = component.find("MainForm");
            $A.util.addClass(NextPage, "slds-hide");
            $A.util.removeClass(NextPage, "slds-show");
            $A.util.toggleClass(PrevPage, "slds-show");
            $A.util.toggleClass(PrevPage, "slds-hide");
        }

    },
    changeboxChange : function(component, event, helper) {
        var checkBox = component.find("termCheckMain").get("v.value");
        component.set("v.changeBox", checkBox);
    },
    redirectFAQ : function(component, event, helper) {
        var strWindowFeatures = "height=570,width=520";
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/topiccatalog';
        window.open(pageUrl, 'mywindow' , strWindowFeatures);
    },
    showConfirmReadTerms : function(component, event, helper) {
        var checkBox = component.find("termCheckMain").get("v.value");
        
        //START CSM-13673 JRances - Inline Text Not Appearing in Paperless Billing Subscribe and Cancellation Pages
        var myAccount = component.find("myAccountData").get("v.value");
        
        if(myAccount == 'None'){
            var selected = component.find("myAccountData");
            //selected.set("v.errors", [{message:"Select an Account"}]);
            //document.getElementById('selectProceed').classList.remove("slds-hide");
            var elem = document.getElementById("checkIfAccountIsSelected");
            elem.style.color = "#C23934";
            selected.set("v.errors", [{message:null}]);
            document.getElementById('checkIfAccountIsSelected').classList.remove("slds-hide");
        } else {            
            var selected = component.find("myAccountData");
            selected.set("v.errors", null);
            document.getElementById('checkIfAccountIsSelected').classList.add("slds-hide");
        }
        //END CSM-13673 JRances
        
        if(checkBox){
            //insert next page code here
            var selectedAccount = component.find('myAccountData').get('v.value');
            if(selectedAccount != "None"){
                var NextPage = component.find("PaperlessBillingSubscribe");
                var PrevPage = component.find("MainForm");
                $A.util.addClass(NextPage, "slds-show");
                $A.util.removeClass(NextPage, "slds-hide");
                $A.util.addClass(PrevPage, "slds-hide");
                $A.util.removeClass(PrevPage, "slds-show");
                document.body.scrollTop = 0;
                document.documentElement.scrollTop = 0;
                component.set('v.IdPass' , component.find("myAccountData").get("v.value"));
                var action = component.get("c.firstEmail");
                action.setParams({"accountid":component.find("myAccountData").get("v.value")});
                action.setCallback(this,function(response){          
                    var state = response.getState();
                    
                    //FOR ACCOUNT LIST PART DROPDOWN
                    
                    if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                        console.log('here');
                        console.log(response.getReturnValue());
                        //alert(response.getReturnValue().firstEmail); //CSM-12550 Emandolado 9/13/2017
                        component.set("v.firstEmail", response.getReturnValue().firstEmail);
                        component.set("v.secondEmail", response.getReturnValue().secondEmail);
                    }else{
                        
                        //alert('yow');
                        console.log("Failed With state: " + state);
                        console.log("Returned:");
                        console.log(response.getReturnValue());
                    }
                });  
                $A.enqueueAction(action); 
            }else{
                var selectbox = component.find('myAccountData');
                //selectbox.set("v.errors", [{message:""}]);
                document.getElementById('selectProceed').classList.remove("slds-hide");
                document.body.scrollTop = 0;
                document.documentElement.scrollTop = 0;
                
            }
        }else{
            document.getElementById("mov-proceed-modal").style.display = "block";
        }
    },
   
    //Start CSM-12548 Mike 09/25/2017
    goBack : function (component, event, helper){
        helper.goBackToAcctList(component, event, helper);
    },
    //End CSM-12548 Mike 09/25/2017
  
    // START Breadcrumb-task RBellalba SEPT-26-17
    redirectToHome : function (component, event, helper){
        helper.goToHome(component, event, helper);
    },
    
    redirectToAccount : function (component, event, helper){
        helper.goToAccount(component, event, helper);
    },
    // END Breadcrumb-task RBellalba SEPT-26-17
    
    //Start CSM-14653 Mike Verdad 11/23/2017
    redirectMERALCOSite : function (component, event, helper){
        helper.redirectMERALCOSiteHelper(component, event, helper);
    },
    //End CSM-14653 Mike Verdad 11/23/2017
    
    //Start of CSM-14772 Corbes Melvin 12/5/2017
    redirectMERALCOSitePaperLessBilling : function (component, event, helper){
       helper.redirectMERALCOSitePBHelper(component, event, helper);
    }
    //End of CSM-14772 Corbes Melvin 12/5/2017
    
})