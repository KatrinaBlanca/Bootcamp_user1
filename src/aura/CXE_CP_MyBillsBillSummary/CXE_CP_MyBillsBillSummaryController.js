({
	setTab : function(component, event, helper) {
		//get data-aura-id of event Source
        var auraId = event.currentTarget.dataset.auraId;
		
        //set clicked tab to active
        var setActiveTab = event.currentTarget.parentNode;
        
        //get current active tabs
        var currentActive = document.getElementsByClassName('slds-is-active');
        
        //set value of tabToShow attrib to id of event Source
        //this will show the contents of the tab (rendered component)
        component.set("v.tabToShow", auraId);
        
        //remove active class to tabs
        $A.util.removeClass(currentActive[0], 'slds-is-active');
        
        //add active class to currently selected tab
        $A.util.addClass(setActiveTab, 'slds-is-active');
        
    },
    EventFire : function(component, event, helper) {
        var eventValue= event.getParam("attributeValue");
      // alert('eventValue: '+eventValue); // CSM-13020 Melvin Corbes 10-02-17
        if(eventValue){
            component.set("v.mainComponent", false);
            component.set("v.paperlessCmp", true);
        }
    },
    //CSM-12823 Start Emandolado 9/20/2017
    doInit: function(component, event, helper) {
        helper.initializeCheckConglomerate(component, event); //START/END R2C CSM-13274 Shayne 10-12-17
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    },
    
    eventFireLoader: function(component, event, helper) {
      
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
        
    },
    //CSM-12823 End Emandolado 9/20/2017
    EventFireToConsumption  : function(component, event, helper) {
        var eventValue= event.getParam("sinAttribute");
        var paperlessPage = component.find("consumptionReport");
        var mainPage = component.find("mainContent");
        
        /*
        //alert(eventValue); //CSM-12545 Emandolado 9/14/2017
        $A.util.removeClass(paperlessPage, "slds-show");
        $A.util.addClass(paperlessPage, "slds-show");
        $A.util.toggleClass(mainPage, "slds-hide");
        $A.util.removeClass(mainPage, "slds-show");
        component.set("v.sinPass" , eventValue);
        document.body.scrollTop = 0;
        document.documentElement.scrollTop = 0;
        */
    }
    
    //START Breadcrumb-task IPenaflor SEPT-25-17
    , redirectToHome : function (component, event, helper){
        helper.goToHome(component, event, helper);
    },
    eventFireTabs : function (component, event, helper){
        alert('here');
    },
    redirectToMyBills : function (component, event, helper){
        helper.goToMyBills(component, event, helper);
    },
    //END Breadcrumb-task IPenaflor SEPT-25-17
    
    advancePaymentDetails : function (component, event, helper){
        //helper.goToMyBills(component, event, helper);
    },
    
    //START CSM-12680 Fernandez 9/25/2017
    EventFireTotalAmount : function(component, event, helper) {
        var eventValue1= event.getParam("totalAmountToPay");
        var eventValueNavigate= event.getParam("tabToNavigate");
        var subTotal = event.getParam("subTotalMap");
        component.set('v.subTotalMap' , subTotal);
        
        if(eventValueNavigate == "tab3"){
            component.set('v.tabToShow' ,'billSummaryTab3');
            document.body.scrollTop = 0;
            document.documentElement.scrollTop = 0;
            
            //get current active tabs
            var currentActive = document.getElementsByClassName('slds-is-active');
            var setActiveTab = document.getElementById("billSummaryTab3");
            //remove active class to tabs
            $A.util.removeClass(currentActive[0], 'slds-is-active');
            //add active class to currently selected tab
            setActiveTab.parentElement.className += " slds-is-active";
            var convenienceFee = event.getParam("convenienceFee");
            component.set("v.convenienceFee", convenienceFee);
            var totalAmountForSettlement = event.getParam("totalAmountForSettlement");
            component.set("v.totalAmountForSettlement", totalAmountForSettlement);
            var paymentTokenId = event.getParam("paymentTokenId");
            component.set("v.paymentTokenId", paymentTokenId);
            var ccCardName = event.getParam("ccCardName");
            component.set("v.ccCardName", ccCardName);
            var ccBillingAddress = event.getParam("ccBillingAddress");
            component.set("v.ccBillingAddress", ccBillingAddress);
            var subTotalMap = event.getParam("subTotalMap");
            component.set("v.subTotalMap", subTotalMap);
            var overpaymentList = event.getParam("overpaymentList");
            component.set("v.overpaymentList", overpaymentList);
            var paymentOptionCode = event.getParam("paymentOptionCode");
            component.set("v.paymentOptionCode", paymentOptionCode);
            
            console.log('paymentOptionCode parent >>> ' +  paymentOptionCode);
            console.log('paymentOptionCode parent get <<< ' +  component.get("v.paymentOptionCode"));
            console.log('overpaymentList111: ' + JSON.stringify(overpaymentList));
        }
        else if(eventValueNavigate == "tab2"){
            component.set('v.tabToShow' ,'billSummaryTab2');
            document.body.scrollTop = 0;
            document.documentElement.scrollTop = 0;
            component.set("v.totalAmountToPay", eventValue1);
            //get current active tabs
            var currentActive = document.getElementsByClassName('slds-is-active');
            var setActiveTab = document.getElementById("billSummaryTab2");
            //remove active class to tabs
            $A.util.removeClass(currentActive[0], 'slds-is-active');
            //add active class to currently selected tab
            setActiveTab.parentElement.className += " slds-is-active";
            var subTotalMap = event.getParam("subTotalMap");
            component.set("v.subTotalMap", subTotalMap);
            console.log('subtotalMap000: ' + JSON.stringify(subTotalMap));
            //START CSM-14422 RReyes NOV-16-17
            var filteredBillSum = event.getParam("filteredBillingSummary");
            component.set("v.filteredBillingSummary", filteredBillSum);
            console.log('filteredBillingSummary tab2: ' + JSON.stringify(filteredBillSum));
            //END CSM-14422 RReyes NOV-16-17
        }  else if(eventValueNavigate == "tab4"){
            //var componentReference= event.getParam("referenceNumber");
           // component.set('v.tabToShow' ,'billSummaryTab4');
           // component.set('v.paymentReferenceNumber',componentReference);
            //document.body.scrollTop = 0;
//            document.documentElement.scrollTop = 0;
        }
            else{
                component.set("v.totalAmountToPay", eventValue1);
                var eventValue2= event.getParam("filteredBillingSummary");
                component.set("v.filteredBillingSummary", eventValue2);
            }
        
        
    },
    //END CSM-12680 Fernandez 9/25/2017
    
    //Von
    advancePaymentDetails : function(component, event, helper) {
        var payinadvanceDetails = event.getParam("returnDetails");
        var state = event.getParams('advanceState');
        
        component.set('v.external_ID' , payinadvanceDetails.external_Id);
        component.set('v.account_number' , payinadvanceDetails.account_number);
        component.set('v.advanceState' , state);
        component.set('v.isAdvancePayment' , true);
        component.set("v.paymentReference" , payinadvanceDetails.paymentReferences);
        component.set("v.paymentReferenceNumber" , payinadvanceDetails.paymentReferenceNumber);
        component.set('v.totalAmountToPay', payinadvanceDetails.totalPaidAmount);
        helper.groupBills(component, payinadvanceDetails.billList);
        
        console.log('payinadvanceDetails>>>' + JSON.stringify(payinadvanceDetails));
        
          component.set('v.tabToShow' ,'billSummaryTab2');
            document.body.scrollTop = 0;
            document.documentElement.scrollTop = 0;
            
            //get current active tabs
            var currentActive = document.getElementsByClassName('slds-is-active');
            var setActiveTab = document.getElementById("billSummaryTab2");
            //remove active class to tabs
            $A.util.removeClass(currentActive[0], 'slds-is-active');
            //add active class to currently selected tab
            setActiveTab.parentElement.className += " slds-is-active";
    },
    
    EventFireCreditCard : function(component, event, helper) {
        //alert('CREDIT CARD DETAILS');
        var eventCardNumber = event.getParam("ccCardNumber");
        component.set("v.ccCardNumber", eventCardNumber);
        /*
        var eventMonth = event.getParam("ccMonth");
        var eventYear = event.getParam("ccYear");
        var eventSecCode = event.getParam("ccSecCode");
        
        component.set("v.ccCardNumber", eventCardNumber);
        component.set("v.ccMonth", eventMonth);
        component.set("v.ccYear", eventYear);
        component.set("v.ccSecCode", eventSecCode);
        */
    }
    
    //START CSM-14070 GGrandea 10.24.2017
    , handleSpinner : function (component, event, helper){
        console.log('>>>>>>>>>>>>>>>>>> handleSpinner');
        helper.toggle_appSpinner(component, event, helper);
    }
    //END CSM-14070
    
})