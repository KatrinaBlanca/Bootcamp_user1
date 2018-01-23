({
    getAccountsForCancellation : function(component,event, helper) {
        console.log('>>> doInit');
        
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //get whole URL of the page
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var acctNo;
        
        for (var i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
            if(sParameterName[0]=='accts'){
                acctNo = sParameterName[1];
            }
        }
        console.log('>> accts: ' + acctNo);

        var action = component.get("c.getAccounts");
        action.setParams({"isEnroll": false});
        action.setCallback(this,function(response){          
            var state = response.getState();
            var res = response.getReturnValue();

            console.log('>> acctsForUnenrollment: ' + JSON.stringify(res));
            if(state === "SUCCESS"){
                var acctsForUnenrollment = res.validAccts;
                
                if(acctsForUnenrollment != null && acctsForUnenrollment.length > 0){
                    component.set("v.acctOptions", acctsForUnenrollment);

                    if(acctNo != null && acctNo!='' && acctsForUnenrollment.indexOf(acctNo) >-1){
                        console.log('acctNo is not null: ' + acctNo);
                        if(acctsForUnenrollment.length == 1){
                            component.set("v.selectedAcct", acctsForUnenrollment[0]);
                        }
                        else{
                            component.set("v.selectedAcct", acctNo);
                        }
                    }
                    console.log('selected: ' + component.get("v.selectedAcct"));
                }
            }
        });  
        $A.enqueueAction(action);
    },

    validateRequiredFields : function(component, event, helper) {
        console.log('validateFields');
        var acctSelected = component.get("v.selectedAcct")
        var reasonSelected = component.get("v.selectedReason");
        var defaultReason = $A.get("$Label.c.RFC_PLEASE_SPECIFY");
        var defaultAcct = 'Select Account Number';
        var hasError = false;
        console.log('acctSelected:' + acctSelected);
        console.log('reasonSelected:' + reasonSelected);
        //START CSM-13219 RReyes OCT-12-17
        if(acctSelected == defaultAcct || acctSelected == null || acctSelected == '') {
            component.set("v.noAcctErrorMsg", $A.get("$Label.c.APA_CANCEL_NO_ACCOUNT"));
            hasError = true;
        } else {
            component.set("v.noAcctErrorMsg", '');
        }
        //END CSM-13219 RReyes OCT-12-17
        //START CSM-13224 RReyes OCT-12-17
        if(reasonSelected == defaultReason || reasonSelected == null || reasonSelected == '') {
            component.set("v.noReasonErrorMsg", $A.get("$Label.c.APA_CANCEL_NO_REASON"));
            hasError = true;
        } else {
            component.set("v.noReasonErrorMsg", '');
        }
        //END CSM-13224 RReyes OCT-12-17
        if(!hasError){
            this.showAPACancelPrompt(component, event, helper);
        }   
    },

    goToMyAccounts : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/myaccounts';
        window.location.assign(pageUrl);
    },

    showAPACancelPrompt : function (component, event, helper){
        component.set("v.popUpModal", 'proceed');
    },

    createCase : function (component, event, helper){
        var action = component.get("c.createAPACase");
        //START CSM-13109 RReyes OCT-27-17 - added fileCount
        action.setParams({"contractAcctNum": component.get("v.selectedAcct"),
                          "isAPAEnroll" : false,
                          "reasonForCancel": component.get("v.selectedReason"),
                          "apaScheme": '',
                          "apaAgent": '',
                          "fileCount": 0});
        //END CSM-13109 RReyes OCT-27-17 - added fileCount
        action.setCallback(this,function(response){          
            var state = response.getState();
            var caseNumber = response.getReturnValue();
            console.log('>>>caseNumber: ' + caseNumber);
            if(state === "SUCCESS"){
                if(caseNumber != null && caseNumber != ''){
                    console.log('SUCCESS!: ' + caseNumber);
                    component.set("v.caseNum", caseNumber);
                }else{
                    console.log('caseNumber failed!');
                }
            }
        });  
        $A.enqueueAction(action);
    },
    
    //START R2C CSM-14749 Shayne 12/01/2017
    initializeCheckConglomerate : function(component, event) {
        console.log('initializeCheckConglomerate');
       var action = component.get("c.retrieveCheckConglomerate");
        action.setCallback(this,function(response){             
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('initializeCheckConglomerate state' + state +' and result '+result);
            if(state === "SUCCESS"){
                 var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                + location.pathname.split('/')[1] + '/' 
                + location.pathname.split('/')[2] + '/congloaccerror';
               if(result === true) window.location.assign(pageUrl);
               else component.set('v.isLoaded',true); //R2C CSM-14773 Shayne 12/05/2017
            }
        });  
        $A.enqueueAction(action);
    }
    //END R2C CSM-14749 Shayne 12/01/2017
})