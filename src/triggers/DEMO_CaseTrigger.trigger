trigger DEMO_CaseTrigger on Case (after insert) {
/*
    private static final Id AGILEPOINT_TEST_RECORD_TYPE_ID = [
        select Id
        from RecordType
        where DeveloperName = 'AgilePoint_Test'
        and sObjectType = 'Case'
        limit 1
    ][0].Id;    
    
    for (Case c: Trigger.new) {
        if (c.RecordTypeId == AGILEPOINT_TEST_RECORD_TYPE_ID) {
            AgilePointGateway.createProcessInstanceForCase(c.Id, AgilePointGateway.TEST_PROCESS_ID);
        }
    }
    */
}