trigger CaseAssignment on Case (after insert) {
    
    //Variable decleration
    List<Case> caseList = new List<Case>();
    User integrationUserObj = new User();
   

    // Apply the criteria only to certain record types 
    Id emailRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('SCS Email Case').getRecordTypeId();
    Id socialRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('SCS Social Media Case').getRecordTypeId();
    //system.assertequals(1,2);
    if(Trigger.isAfter && Trigger.isInsert){
        //Fetching the integration user details
        integrationUserObj = [SELECT Id, Name FROM User where Name = 'SCC Admin' LIMIT 1];
           
        for (Case caseObj : Trigger.new) {
            if (caseObj.RecordTypeId == emailRecTypeId || caseObj.RecordTypeId == socialRecTypeId) {
                if (caseObj.OwnerId  == integrationUserObj.Id) {
                    caseList.add(new Case(id = caseObj.id));
                }
            }
        }
        if (caseList.size() > 0) {
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            Database.update(caseList, dmo);
        }
    }
    
}