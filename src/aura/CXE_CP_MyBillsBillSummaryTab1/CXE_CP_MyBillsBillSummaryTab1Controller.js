({
    doInit : function(component, event, helper) {
        helper.show_spinner(component); //CSM-14404
        helper.setPicklistOptions(component, event);
        helper.initTooltips(component, event); //CSM-14404
        helper.initializeBillingDetails(component, event); //START/END CSM-10913 RReyes JUL-24-17
    },
    
    //start CSM-14689 @gibs
    showBillTooltip : function(component, event, helper) {
        document.getElementsByClassName('CXE_myBillsTableWidthFix')[0].style.overflowY= 'visible';
    },
    
    hideBillTooltip : function(component, event, helper) {
        document.getElementsByClassName('CXE_myBillsTableWidthFix')[0].removeAttribute('style');
    },
    //end CSM-14689 @gibs

    accountPicklistChanged : function(component, event, helper) {
        helper.show_spinner(component); //CSM-14070 GGrandea 10.24.2017
        helper.modifySinPicklist(component, event);
    },

    sinPicklistChanged : function(component, event, helper) {
        helper.show_spinner(component); //CSM-14070 GGrandea 10.24.2017
        helper.modifyAccountPicklist(component, event);
    },
    
    showModal : function(component, event, helper) {
        component.set("v.modalPopUp", event.currentTarget.dataset.desc); 
    },
    //START CSM-10913 RReyes JUL-24-17  
    updateMarkAll : function (component, event, helper){
        helper.updateAllSelected(component, event);
    },
    
    updateSelectedAccounts : function (component, event, helper){
        helper.updateAccountSelection(component, event, helper);
    },
    
    updateSelectedServices : function (component, event, helper){
        helper.updateServiceSelection(component, event, helper);
    },
    
    applyFilter : function (component, event, helper){
        helper.show_spinner(component); //CSM-14070 GGrandea 10.24.2017
        //START CSM-14070 GGrandea 10.24.2017
        //helper.filterData(component, event, helper);
        setTimeout(function(){
            $A.getCallback(function(){
                helper.filterData(component, event, helper);      
            })();
        }, 250);
        //END CSM-14070 GGrandea 10.24.2017
    },

    applySort : function (component, event, helper){
        var id = event.target.id;
        console.log('sort by: ' + id);
        if(id == 'acctNum'){
            helper.sortByAccount(component, event);
        }else if(id == 'serviceNum'){
            helper.sortByServiceNumber(component, event);
        }else if(id == 'billedAmount'){
            helper.sortByBilledAmount(component, event);
        }else if(id == 'currentAmountDue'){
            helper.sortByCurrentAmountDue(component, event);
        }else if(id == 'billDueDate'){
            helper.sortByDueDate(component, event);
        }else if(id == 'endOfBillingPeriod'){
            helper.sortByEndOfBillingPeriod(component, event);
        }
    },

    updateTotal : function (component, event, helper){
        var subTotalMap = component.get("v.subTotalMap");
        helper.computeTotal(component, subTotalMap);
    },
    //END CSM-10913 RReyes JUL-24-17

    redirectToManageService : function (component, event, helper){
        //START R2C CSM-14581 Shayne 12/06/2017 modal for conglo user
        if(component.get('v.isConglomerate')){
            var message= $A.get("$Label.c.CONGLOMERATE_ERROR_PAGE");
            component.set('v.congloMessage', message);
            component.set('v.isCongloModal', true);
        }
        else{
            helper.goToManageService(component, event, helper);
        }
         //END R2C CSM-14581 Shayne 12/06/2017
    },

    viewconsumption  : function (component, event, helper){
        
        var currentClicked = event.getSource().get("v.label");
        if(currentClicked == "View Consumption Report"){
                    var viewBill = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/consumptionreport?'
                             +'acctNo=' + event.getSource().get("v.class");
            window.location.assign(viewBill);
        }
    },

    viewBillDetail  : function (component, event, helper){
        //START CSM-11039 RReyes AUG-17-17 - added document id in parameter
        var acctno = event.currentTarget.dataset.acctno;
        var sin = event.currentTarget.dataset.sin;
        var billdt = event.currentTarget.dataset.billdt;
        var invdt = event.currentTarget.dataset.invdt;
        var docuId = event.currentTarget.dataset.docuid;
        var billid = event.currentTarget.dataset.billid; // CSM-12973 Mike Verdad 09/29/2017
        
        
        var viewBill = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/viewbills?'
                             +'sinNo=' +    sin 
                             +'&acctNo=' +  acctno
                             +'&bpBillDt=' +    billdt
                             +'&bpinvoiceDate=' + invdt
                             +'&bpBillId=' + billid // CSM-12973 Mike Verdad 09/29/2017
                             +'&fromBillSumm=1'
                            /*  +'&docId=' + docuId */;
        window.location.assign(viewBill);
        //START CSM-11039 RReyes AUG-17-17 - added document id in parameter
    }
    //START CSM-12645 RReyes SEP-27-17
    ,disablePayNow : function (component, event, helper){
        console.log('disablePayNow');
        component.set("v.isSubtotalSelected", true);
    },

    enablePayNow : function (component, event, helper){
        console.log('enablePayNow');
        var subTotalMap = component.get("v.subTotalMap");
        console.log('enablePayNow: subTotalMap OK' );
        helper.validateSubtotalChange(component, event, helper, subTotalMap);
        console.log('enablePayNow: validateSubtotalChange OK');
        helper.computeTotal(component, subTotalMap);
        console.log('enablePayNow: computeTotal OK');
        component.set("v.isSubtotalSelected", false);
    }
    //END CSM-12645 RReyes SEP-27-17
    //START CSM-12629 RReyes OCT-01-17
    ,checkOverdue : function (component, event, helper){
        var myPromptType = helper.checkOverduePrompt(component, event, helper);
        console.log('myPromptType: ' + myPromptType);
        console.log('CheckThis' + JSON.stringify(component.get('v.subTotalMap')));
        //helper.checkOverduePrompt(component, event, helper);
        if(myPromptType != ''){
            component.set("v.modalPopUp", myPromptType);
        }else{
            helper.proceedPay(component, event, helper);
        }
    }
    ,setPromptTypeToBlank : function(component, event, helper) {
        var prompt = event.getParam("promptType");
        console.log('prompt: ' + prompt);
        component.set("v.modalPopUp", '');
        if(prompt == 'proceed'){
            helper.proceedPay(component, event, helper);
        }
    }
    //END CSM-12629 RReyes OCT-01-17
})