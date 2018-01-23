trigger AccountTrigger on Account (after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
	if(Trigger.isAfter && Trigger.isUpdate)
	{	
		AccountTriggerClass ATC=new AccountTriggerClass();
		atc.accountAcceptance(trigger.new);
	}
	
	TriggerDispatcher.Run(new AccountTriggerHandler());
}