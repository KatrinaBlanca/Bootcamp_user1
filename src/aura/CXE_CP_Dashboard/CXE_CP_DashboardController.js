({
     
    doInit : function(component, event, helper) {
        var action = component.get("c.LoginDetails");
        
        var isMobile = navigator.userAgent.match(/Android/i) ||
            		   navigator.userAgent.match(/iPhone/i) ||
            		   navigator.userAgent.match(/iPad/i);
        
        if(isMobile != null && location.href.search('RemoteAccessAuthorizationPage') <= 0) {
            var auraId = component.find('mobilePrompt');
			$A.util.removeClass(auraId, 'slds-hide');
			$A.util.addClass(auraId, 'slds-show');
        }
        
        action.setCallback(this,function(response){          
            var state = response.getState();
            var Total = 0;
            var dates;
            var d;
            var dueMonth;
            
            //START CSM-13810 JRances - Account Number and Total Amount Due is not displayed in the Home Page, Restructing Display
            
            if(response.getReturnValue() == null){
                var firstMonth = response.getReturnValue().UnpaidUserBills[0].due_date;
                var firstMonthDate = new Date(firstMonth);
                var firstMonthValue = firstMonthDate.getMonth() + 1;
            }                 
            
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                 console.log('conglomerate '+response.getReturnValue().isConglomerate);
                component.set("v.isConglomerate" , response.getReturnValue().isConglomerate);
           		
                //START CSM-13810 JRances - Checking return values
                component.set("v.LastLogin" , response.getReturnValue().LastLoginDate);
                component.set("v.FirstName" , response.getReturnValue().FirstName);
                
                    //START CSM-13775 - Common due date of the unpaid bills doesn't display on the Due Date section of the Home Page 
                    console.log('Return Value: >>>>> '+response.getReturnValue());
                    console.log('Unpaid Bill Count: >>>>> '+response.getReturnValue().UnpaidBillCount);
                    console.log('Contract Count: >>>>> '+response.getReturnValue().ContractCount);
                    console.log('Service Enrollment Count: >>>>> '+response.getReturnValue().ServiceCount);
                    console.log('Due Date From Apex: >>>>> '+response.getReturnValue().setPortalBillDueDate);
                	//END CSM-13775 
                //END CSM-13810 JRances
                
                //START JAgapito CSM-13809 Oct.10,2017
                /*	Compares if service count is 0 then it will display a notice that
                 * 	there is no enrolled services under meralco online account
                 * 	strange is that if i place the code in line 40 onwards
                 *	the code does not behave as intended.
                 * */
                if (response.getReturnValue().ServiceCount == 0) {
                    var auraId = component.find('cService');
                    console.log ('flag');
                    $A.util.removeClass(auraId, 'slds-hide');
                    $A.util.addClass(auraId,'slds-show');
                }
                //END JAgapito Oct.10,2017
                
                //START - Displaying Account Number on Dashboard
                if (response.getReturnValue().ContractCount==1){
                    component.set("v.AccountNumber" , response.getReturnValue().UserContracts[0].V10_Account_No__c);
                    console.log('Account Number: >>>>> '+ component.get("v.AccountNumber"));
                } else {   
                    var cmpTarget = component.find('accountHide');   
                    console.log('Account Number: >>>>> No Contract Found, No Account Number');
                    //START - CSM-13038 JRances - Hide Wordings "Meralco Account Number" if portal has 2 or more Accounts
 					$A.util.addClass(cmpTarget, 'slds-hide');
                    //END - CSM-13038 JRances                  
                }
                //END
                
                //START - Displaying Total Outstanding Balance on Dashboard
                if (response.getReturnValue().UnpaidBillCount == 0){
                    Total = 0.00;
                } else {
                    for (var i = 0; i < response.getReturnValue().UnpaidUserBills.length ; i++){
                        if (response.getReturnValue().UnpaidUserBills[i].pending_amount != null){
                            Total += parseFloat(response.getReturnValue().UnpaidUserBills[i].pending_amount); 
                            //Total += parseInt(response.getReturnValue().UnpaidUserBills[i].total_amount.trim());
                        }
                    }
                }
                
                if(response.getReturnValue().ContractCount==1){
                    component.set("v.TotalOutstandingBalance", Total);
                    console.log('Outstanding Balance: >>>>> '+ component.get("v.TotalOutstandingBalance"));
                    
                } else if(response.getReturnValue().ContractCount > 1){    
					component.set("v.TotalOutstandingBalance", Total);  
                    console.log('Outstanding Balance: >>>>> '+ component.get("v.TotalOutstandingBalance"));                    
                }                
                //END - Displaying Total Outstanding Balance on Dashboard               
                
                //START CSM-13775 JRances - Displaying Due Date on Dashboard
                if(response.getReturnValue().UnpaidUserBills.length != 0){
                    component.set("v.DueDate", response.getReturnValue().setPortalBillDueDate); 
                } else {
                    component.set("v.DueDate", '');  
                }
                //END CSM-13775 JRances

                var autoEnroll = response.getReturnValue().autoEnroll;
                // Start R2C CSM-15041 Von Pernicia: Added Service Count
                if(autoEnroll == true && response.getReturnValue().ServiceCount > 1) {
                // End R2C CSM-15041 Von Pernicia: Added Service Count
                    var auraId = component.find('mulSINNotif');
                    $A.util.removeClass(auraId, 'slds-hide');
        			$A.util.addClass(auraId, 'slds-show');
                } 
                helper.hideInfoIncompleteNotif(component);
                
                //END CSM-13810 JRances
                
            }else{
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
   
        });  
        $A.enqueueAction(action); 
    },
 
    hideCmp : function (component, event, helper){
        var auraId = component.find('incProfNotif');
        $A.util.addClass(auraId, 'slds-hide');
    },
    
    redirectToPaymentHistory : function (component, event, helper){
         var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/paymenthistory';
        window.location.assign(pageUrl);     
    },
    
    redirectToBills : function (component, event, helper){
        helper.goToBills(component, event, helper);
    },

    redirectToPaperlessBilling : function (component, event, helper){
        var conglomerate = component.get('v.isConglomerate');
        if(conglomerate == false) helper.goToPaperlessBilling(component, event, helper);
    },

    redirectToProfile : function (component, event, helper){
        helper.goToProfile(component, event, helper);
    },

    redirectToMyAccounts : function (component, event, helper){
        helper.goToMyAccounts(component, event, helper);
    },
    
    redirectToStartService : function (component, event, helper){
        helper.goToStartService(component, event, helper);
    },

    //START CSM-14628 RReyes NOV-23-17
    redirectToAPAEnroll : function (component, event, helper){
        helper.goToAPAEnroll(component, event, helper);
    },
    //END CSM-14628 RReyes NOV-23-17

    hideMultipleSINCmp : function (component, event, helper){
        
        var action = component.get("c.UpdateAutoEnrollment");
        
        action.setCallback(this,function(response){          
            var state = response.getState();
            var Total = 0;
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue() != null){
                console.log('>>>> ' + response.getReturnValue())
                // var mmm = response.getReturnValue().CXE_Auto_Enrolled_Services__c;
                //alert('updated: ' + mmm);
                var auraId = component.find('mulSINNotif');
                $A.util.removeClass(auraId, 'slds-show');
                $A.util.addClass(auraId, 'slds-hide');
                
            }else{
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });  
        $A.enqueueAction(action);

    },
    
   
    linkFeedback : function (component, event, helper){
        helper.linkFeedbackHelper(component, event, helper);
    },
    
    dropNav : function (component, event, helper){
        var i = component.get("v.dropdownNavi");
        //alert(i);
        if (i == '' || i == false) {
            document.getElementsByClassName('mov-dashboard_dropdown-content')[0].style.maxHeight = 'inherit';
            component.set("v.dropdownNavi", true);
        }
        
        else {
            document.getElementsByClassName('mov-dashboard_dropdown-content')[0].style.maxHeight = '1px';
            component.set("v.dropdownNavi", false);
        }
     	
    },
    
    hideModalHandler : function (component, event, helper) {
        console.log('IN Main');
        var isShowModal = event.getParam("isShowModal");
        console.log('IN Main ', isShowModal);
        if(isShowModal == false) {
            console.log('IN Main if');
            var auraId = component.find('mobilePrompt');
			$A.util.removeClass(auraId, 'slds-show');
			$A.util.addClass(auraId, 'slds-hide');
        }
    }

    // START CSM-14554 Jerome To 11/20/2017 Prompt that the user can edit the profile information but it doesn’t tell where the user can edit it.
    ,onClickMyProfile : function (component, event, helper){
        helper.goToMyProfile(component, event, helper);
    },
    // END CSM-14554 Jerome To 11/20/2017 Prompt that the user can edit the profile information but it doesn’t tell where the user can edit it.
    //START R2C CSM-14812 Shayne 12/06/2017 
     redirectToAPA : function (component, event, helper){
        helper.goToAPASubscription(component, event, helper);
    },
	//END R2C CSM-14812 Shayne 12/06/2017 
})