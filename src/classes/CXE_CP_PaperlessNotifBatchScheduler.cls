global class CXE_CP_PaperlessNotifBatchScheduler implements Schedulable {
	global void execute(SchedulableContext sc) {
    	Id jobId = sc.getTriggerId();
        System.abortJob(jobId);
        
        Org_Wide_Fixed_Setting__mdt meta = [SELECT Paperless_Notification_Batch_Interval__c FROM Org_Wide_Fixed_Setting__mdt WHERE MasterLabel =: CXE_Constants.ALL_STR LIMIT 1];
        
        Database.executeBatch(new CXE_CP_PaperlessBillingNotifBatch(), 1); // CSM-15092 LISEN
        
        DateTime now  = DateTime.now();        
        Integer intervalTime = Integer.valueOf(meta.Paperless_Notification_Batch_Interval__c);
        DateTime nextRunTime = now.addMinutes(intervalTime);
        
        //String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
        //                      nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
        //                    nextRunTime.month() + ' ? ' + nextRunTime.year(); 
                                
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
                                nextRunTime.hour() + ' ' + ' * * ? *';
                                
        System.schedule(CXE_CP_PaperlessNotifBatchScheduler.class.getName() + (Test.isRunningTest()?'TEST':'') + '-' + now.format()
                            , cronString
                            , new CXE_CP_PaperlessNotifBatchScheduler());
	}
}