trigger CaseTransitionTrigger on Case (after insert, after update) {
    /*List<Case_State_Transition_Setting__mdt> allSettings = CaseStateTransitionHelper.getAllsettings();
    List<Case_State_Transition__c> dataToBeInserted = new List<Case_State_Transition__c>();
    
    // Apply the criteria only to certain record types
    Id commRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Community').getRecordTypeId();
    Id adminRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Service Application (Admin)').getRecordTypeId();
    Id custRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Community Record Type').getRecordTypeId();
    Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Service Application').getRecordTypeId();
     
    for(case c :trigger.new){
         if(c.RecordTypeId == commRecTypeId || c.RecordTypeId == adminRecTypeId || c.RecordTypeId == custRecTypeId || c.RecordTypeId == servRecTypeId) {
            string toState = c.status;
            string fromState = '';
            
            if (trigger.isUpdate){
                fromState = trigger.oldmap.get(c.id).status;
                
            }
            if (toState != fromState && CaseStateTransitionHelper.processedCaseId <> c.id){
                Case_State_Transition__c caseTran = CaseStateTransitionHelper.AddTransition(c.id,fromState,toState,allSettings);
                dataToBeInserted.add(caseTran);
                CaseStateTransitionHelper.processedCaseId = c.id;
            }
         }
    }
    
    if(dataToBeInserted.size() > 0) {
        List <Case_State_Transition__c> dataToBeUpdated = new List <Case_State_Transition__c>();
        for(Case_State_Transition__c rec : dataToBeInserted)
        {
            if (rec.Mediator_Reference_Trans_ID__c != null){
                Case_State_Transition__c relatedRec = CaseStateTransitionHelper.getRcordByName(rec.Mediator_Reference_Trans_ID__c);
                if (relatedRec != null){
                    relatedRec.Mediator_Used__c = true;
                    dataToBeUpdated.add(relatedRec);
                }
            }
        }
        insert dataToBeInserted;
        if(dataToBeUpdated.size() > 0) {
            update dataToBeUpdated;
        }
     }
     */
}