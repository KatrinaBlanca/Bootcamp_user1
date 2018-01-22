trigger ProductTrigger on Product2 (after insert)
{
    UpdatePrdComValHandler updprd = new UpdatePrdComValHandler();
    updprd.Updateprdcomval(Trigger.new);   
}