trigger VIPContactTrigger on VIP_Contact__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) 
{
    TriggerDispatcher.Run(new VIPContactTriggerHandler());
}