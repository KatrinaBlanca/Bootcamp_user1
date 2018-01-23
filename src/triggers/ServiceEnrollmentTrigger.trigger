trigger ServiceEnrollmentTrigger on CXE_Service_Enrollment__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
    TriggerDispatcher.Run(new CXE_CP_ServiceEnrollmentTriggerHandler());

}