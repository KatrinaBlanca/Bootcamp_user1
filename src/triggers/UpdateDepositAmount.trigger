trigger UpdateDepositAmount on Case (before insert, before update) {
    
    /*// bring all schedules
    List<Schedule__c> allSchedules =   [select id, Name , Non_Residential_Rate__c , Residential_Rate__c, Schedule_Selector__c  
                                                                from Schedule__c ];
 
    // Apply the criteria only to certain record types

    Id commRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Community').getRecordTypeId();
    Id adminRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Service Application (Admin)').getRecordTypeId();
    Id custRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Community Record Type').getRecordTypeId();
    Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Service Application').getRecordTypeId();
    
    for (Case c : trigger.new){
        // check record type for before operation
        if(c.RecordTypeId == commRecTypeId || c.RecordTypeId == adminRecTypeId || c.RecordTypeId == custRecTypeId || c.RecordTypeId == servRecTypeId) {
            ScheduleCollectionUtils.UpdateCaseWithScheduleDepositInfo(c,allSchedules);
        }
    }*/
}