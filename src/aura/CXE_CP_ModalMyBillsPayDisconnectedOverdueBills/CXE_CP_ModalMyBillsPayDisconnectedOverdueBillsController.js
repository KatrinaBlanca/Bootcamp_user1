({
	//START CSM-12629 RReyes OCT-01-17
	hideModal : function(component, event, helper) {
        var sourcePg = component.get("v.sourcePage");
        console.log('hide: sourcePg: ' + sourcePg);
        if(sourcePg == 'mybills'){
            console.log('>>> cancel mybills');
            var setEvent = component.getEvent("setTotalAmount");
            console.log('>>> setEvent: ' + setEvent);
            setEvent.setParams({"promptType":'back'});
            setEvent.fire();
            //console.log('>>> cancel mybills');
        }
    },
    proceedModal: function(component, event, helper) {
        var sourcePg = component.get("v.sourcePage");
        var totAmt = component.get("v.totalAmount");
        var filteredBillSum = component.get("v.filteredBillingSummary");
        var subTotal = component.get("v.subTotalMap");
        console.log('proceed: sourcePg: ' + sourcePg);
        if(sourcePg == 'mybills'){
            console.log('>>> proceed mybills');
            var setEvent = component.getEvent("setTotalAmount");
            setEvent.setParams({"promptType":'proceed'});
            setEvent.setParams({"totalAmountToPay":totAmt});
            setEvent.setParams({"filteredBillingSummary":filteredBillSum});
            setEvent.setParams({"subTotalMap": subTotal});
            setEvent.fire();
            //console.log('>>> proceed mybills');
        }
    }
    //END CSM-12629 RReyes OCT-01-17
})