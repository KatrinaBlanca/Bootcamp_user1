trigger ReferenceTrigger on Reference__c (after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
    TriggerDispatcher.Run(new ReferenceTriggerHandler());
}