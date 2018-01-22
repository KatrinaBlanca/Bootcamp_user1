({
	/* Description: Get Case
     * Parameters: None
     * Author: Rom Edison Reyes
     * Date Created: AUG-10-17
     */
    getCase : function(component, event, helper) {
        	var action = component.get("c.getCaseDetails");
            action.setParams({"caseId":  component.get("v.recordId")});
            
            action.setCallback(this, function(response){
                var state = response.getState();
                var caseRec = response.getReturnValue();
                console.log('>>caseRec:' + JSON.stringify(caseRec));
                if(state == 'SUCCESS'){
                    component.set("v.caseRecord", caseRec);
                    if(caseRec.CXE_isClickBillDepositButton__c
                       && (caseRec.RecordType.DeveloperName == 'New_Service_Application' 
                           || caseRec.RecordType.DeveloperName == 'CXE_Modification_of_Electric_Service' 
                           || caseRec.RecordType.DeveloperName == 'CXE_Recontract_of_Electric_Service')){
                        component.set("v.updateBillDeposit", true);
                    }else{
                         component.set("v.updateBillDeposit", false);
                    }
                    
                    if(!caseRec.CXE_isRequireArrears__c
                       && (caseRec.RecordType.DeveloperName == 'CXE_Termination_of_Electric_Service' 
                           || caseRec.RecordType.DeveloperName == 'CXE_Modification_of_Electric_Service' 
                           || caseRec.RecordType.DeveloperName == 'CXE_Recontract_of_Electric_Service')){
                        component.set("v.retrieveAmount", true);
                    }else{
                        component.set("v.retrieveAmount", false);
                    }
                }
                console.log('>> update BD?: ' + component.get("v.updateBillDeposit"));
                console.log('>> retrieve?: ' + component.get("v.retrieveAmount"));
            });
            $A.enqueueAction(action);
    }
})