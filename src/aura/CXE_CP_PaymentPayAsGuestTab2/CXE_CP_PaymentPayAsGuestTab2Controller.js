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
        component.set("v.tabToShow", auraId);
    },
    EventFireTotalAmount : function(component, event, helper) {
        var eventValue1= event.getParam("totalAmountToPay");
        var eventValueNavigate= event.getParam("tabToNavigate");
 
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
            
        }  else if(eventValueNavigate == "tab4"){
            var componentReference= event.getParam("referenceNumber");
            component.set('v.tabToShow' ,'billSummaryTab4');
            component.set('v.paymentReferenceNumber',componentReference);
            document.body.scrollTop = 0;
            document.documentElement.scrollTop = 0;
        }
            else{
                component.set("v.totalAmountToPay", eventValue1);
                var eventValue2= event.getParam("filteredBillingSummary");
                component.set("v.filteredBillingSummary", eventValue2);
            }
        
    },
})