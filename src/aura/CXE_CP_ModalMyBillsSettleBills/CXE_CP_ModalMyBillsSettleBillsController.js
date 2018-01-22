({
    hideModal : function(component, event, helper) {
        //START CSM-12629 RReyes OCT-01-17
        var sourcePg = component.get("v.sourcePage");
        if(sourcePg == 'mybills'){
            var setEvent = component.getEvent("setTotalAmount");
            setEvent.setParams({"promptType":'back'});
            setEvent.fire();
            console.log('>>> cancel mybills');
        }else{
            var setEvent = component.getEvent("closeModal");
            setEvent.setParams({"attributeValue":'fire'});
            setEvent.fire(); 
        }
        //END CSM-12629 RReyes OCT-01-17
    },
    proceedModal: function(component, event, helper) {
        //START CSM-12629 RReyes OCT-01-
        var sourcePg = component.get("v.sourcePage");17
        var totAmt = component.get("v.totalAmount");
        var filteredBillSum = component.get("v.filteredBillingSummary");
        var subTotal = component.get("v.subTotalMap");
        
        if(sourcePg == 'mybills'){
            var setEvent = component.getEvent("setTotalAmount");
            setEvent.setParams({"promptType":'proceed'});
            setEvent.setParams({"totalAmountToPay":totAmt});
            setEvent.setParams({"filteredBillingSummary":filteredBillSum});
            setEvent.setParams({"subTotalMap": subTotal});
            setEvent.fire();
            console.log('>>> proceed mybills');
            
        }else{
            var setEvent = component.getEvent("setTotalAmount");
            setEvent.setParams({"tabToNavigate":"tab2"});
            setEvent.fire();
        }
        //END CSM-12629 RReyes OCT-01-17
    }
})