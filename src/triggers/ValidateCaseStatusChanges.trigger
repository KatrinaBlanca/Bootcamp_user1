trigger ValidateCaseStatusChanges on Case (before update) {
    /*
    List<Banned_Case_State_Transition__mdt> allCaseStatusSettings = [select from_state__c,to_state__C
                                                                from Banned_Case_State_Transition__mdt ];
    
    // Apply the criteria only to certain record types
    Id commRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Community').getRecordTypeId();
    Id adminRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Service Application (Admin)').getRecordTypeId();
    Id custRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Community Record Type').getRecordTypeId();
    Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Service Application').getRecordTypeId();
    
    for(case c :trigger.new){
        if(c.RecordTypeId == commRecTypeId || c.RecordTypeId == adminRecTypeId || c.RecordTypeId == custRecTypeId || c.RecordTypeId == servRecTypeId) {
            string toState = c.status;
            string fromState = trigger.oldmap.get(c.id).status;
            
            for(Banned_Case_State_Transition__mdt setting :allCaseStatusSettings){
                if (setting.From_state__c == fromState &&
                    setting.To_State__c == toState){
                        
                        String placeholder = 'You can not change service application from {0} status to {1} status';
                        List<String> fillers = new String[]{fromState,toState};
                        c.addError(String.format(placeholder, fillers));
                        break;
                    }
            }
        }
    }
    */
}