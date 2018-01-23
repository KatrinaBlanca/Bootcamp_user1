({
/**
* Method to get the questions and options for EAV
**/    
    
    doInit : function(component, event, helper) {
        var oppId = component.get("v.OppId");
        var action = component.get("c.getQA");
        action.setParams({
            "OpportunityId": oppId
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert('hi'+response.getState());
            if(component.isValid() && state === "SUCCESS") {               
                component.set("v.QAWrap", response.getReturnValue());
                //alert(JSON.stringify(response.getReturnValue()));
            }
            else if (state === "ERROR") {
                
                var errors = response.getError();
                alert('hello '+errors[0].message);  
                
            }
        });
        $A.enqueueAction(action);           
        
    },
/**
* Method to calculate totals based on selected options in EAV
**/    
    generateEAV : function(component, event, helper) {
        var currParams = component.get("v.eavQA");
        if(currParams === undefined || currParams.length == 0){
            alert("Please select at least one value in order to estimate EAV");
        }else{
            var currList = component.get('v.currList');
            var str = JSON.stringify(currParams);
            var currLstStr = JSON.stringify(currList);
            
            var action = component.get("c.genEAV");
            action.setParams({
                "qaStr": str,
                "currLstStr": currLstStr
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    var sendConn = component.getEvent("Lightning_EstimateEAVEvent");
                    sendConn.setParams({ "updatedConnections": response.getReturnValue() }).fire();
                    var toggleModal = component.getEvent("Lightning_EAVToggle");
                    toggleModal.fire();
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    alert('Hello ' +errors[0].message); 
                }
            });
            $A.enqueueAction(action);
        }
        /*for (var i = 0; i < container.elements.length; i++ ) {
            if (container.elements[i].type == 'radio') {
                alert(form.elements[i].value);
            }
        }*/
        
        /*var EAVmodal = component.find("EvtModal");
        alert('abc'+EAVmodal);
		$A.util.toggleClass(EAVmodal, "slds-hide");*/
    },
/**
* Method to set the EAV Params
**/     
    setEAVParam : function(component, event, helper) {
        var currParams = component.get("v.eavQA");
        var currVar = new Object();
        //var temp = component.get("v.currVar");
        //var currVar = temp;
        //alert(currParams);
        var selectedQuestion = event.target.name;
        var selectedAnswer = event.target.value;
        //alert(selectedQuestion);
        //alert(selectedAnswer);
        currVar.question = selectedQuestion;
        currVar.answer = selectedAnswer;
        //alert(currVar);
        //alert(JSON.stringify(currVar));
        currParams.push(currVar);
        //alert(currParams);
        //alert(JSON.stringify(currParams));
        var hashObject = new Object();
        for (var i = currParams.length - 1; i >= 0; i--) {
            var currentItem = currParams[i].question;
            //console.log('currentItem'+currentItem);
            if (hashObject[currentItem] == true) {
                currParams.splice(i, 1);
            }
            hashObject[currentItem] = true;
        }
        //alert(currParams);
        //alert(JSON.stringify(currParams));
        component.set("v.eavQA",currParams);
    },    
})