({
    doInit : function(component, event, helper) {
        console.log('here');
        
        var action = component.get("c.loadAccounts");
        action.setCallback(this,function(response){    
            var state = response.getState();
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){  
                console.log(response.getReturnValue());
                var returnVal = response.getReturnValue();
                var AccountList = [];
                if(returnVal.length > 1){
                    AccountList.push({ class: "optionClass", label: "--Select All--", value: "None", selected: "true" })                    
                    for(var i = 0; i < returnVal.length ; i++){
                        var CurrentValue = returnVal[i];
                        AccountList.push({ class: "optionClass", label: CurrentValue.V10_Account_No__c, value: CurrentValue.V10_Account_No__c});
                    }       
                }else if(returnVal.length == 0){
                    AccountList.push({ class: "optionClass", label: "No Accounts Available" , value: "None"});
                }
                    else{
                        for(var i = 0; i < returnVal.length ; i++){     
                            var CurrentValue = returnVal[i];
                            AccountList.push({ class: "optionClass", label: CurrentValue.V10_Account_No__c, value: CurrentValue.V10_Account_No__c, selected: "true"});               
                        }      
                        
                    }
                
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
    checkboxChange: function(component, event, helper) {
        
    },
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
                selectbox.set("v.errors", [{message:"Select an Account"}]);
                document.body.scrollTop = 0;
                document.documentElement.scrollTop = 0;
            }
        }else{
            document.getElementById("mov-proceed-modal").style.display = "block";
        }
    }
})