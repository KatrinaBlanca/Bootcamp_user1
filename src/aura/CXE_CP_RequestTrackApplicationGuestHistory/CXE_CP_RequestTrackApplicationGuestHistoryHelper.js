({
	getTransactionDetails : function(component, event, helper) {
		var params = event.getParam('arguments');
		if(params) {
			
			var lastname = params.lastname;
			var referenceNumber = params.referenceNumber;
			
			helper.toggleSpinner(component, event, helper);
	        var action = component.get("c.trackApplication");
	        action.setParams({
	            "referenceNumber": referenceNumber,
	            "lastName": lastname
	        });
	        action.setCallback(this, function(a) {
	            var state = a.getState();
	            helper.toggleSpinner(component, event, helper);
	            if(state == "SUCCESS"){
	                var response = a.getReturnValue();
	                if (!response.hasError) {
	                    component.set("v.caseHistoryList", response.caseStatusHistoryList);
	                    component.set("v.caseNumber", response.caseNumber);
	                    component.set("v.caseRecord", response.caseRecord);
	                    component.set("v.isTerminate", response.isTerminate);
	                    if(response.statusJourney) {
	                        $A.util.addClass(component.find(response.statusJourney), 'slds-is-active');
	                    } 
	                    helper.pushCaseHistoryEvent(component, true);
	                } else {
	                	helper.pushCaseHistoryEvent(component, false);
	                    var toastEvent = $A.get("e.force:showToast");
	                    //START CSM-14924 12/20/2017 JRances - [R3A SQT] Error message upon clicking Search button in the 'Track Request' page
	                    //toastEvent.setParams({"title": "Oops!",
	                    toastEvent.setParams({"title": "",
	                    //END CSM-14924
	                                          "message": response.errorMessage,
	                                          "type": "Error",
                        						"duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
	                                         });
	                    toastEvent.fire();
	                }
	            } else {
	            	helper.pushCaseHistoryEvent(component, false);
	                // console.log('>>>>>>>>>>>>>>>>>> Error.' + a.getReturnValue());

	                var errors = response.getError();
	                if (errors) {
	                    if (errors[0] && errors[0].message) {
	                        var toastEvent = $A.get("e.force:showToast");
			                toastEvent.setParams({"title": "Oops!",
			                                      "message": errors[0].message,
			                                      "type": "Error",
                        							"duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
			                                     });
			                toastEvent.fire();
	                    }
	                } else {
	                    var toastEvent = $A.get("e.force:showToast");
			            toastEvent.setParams({"title": "Oops!",
			            					  "message": "Unknown error",
			            					  "type": "Error",
                        						"duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
			                                 });
			            toastEvent.fire();
	                }
	                
	            }
	        });
	        $A.enqueueAction(action);			
		}
	},

	toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    },


    pushCaseHistoryEvent : function (component, hasCaseHistory) {
		var setEvent = component.getEvent("hasCaseHistoryEvt");
		setEvent.setParams({
			"hasCaseHistory" : hasCaseHistory
		});
		setEvent.fire();
	}
})