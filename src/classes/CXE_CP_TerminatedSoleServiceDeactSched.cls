global class CXE_CP_TerminatedSoleServiceDeactSched implements Schedulable{
 global void execute(SchedulableContext sc){

    	Org_Wide_Fixed_Setting__mdt meta = [SELECT Portal_No_Enrollment_Grace_Period__c
    														,Portal_User_Inactivity_Deactivation__c
    														,Portal_User_Inactivity_Notif_Count__c
    													FROM Org_Wide_Fixed_Setting__mdt WHERE MasterLabel =: CXE_Constants.ALL_STR LIMIT 1];
        // We now call the batch class to be scheduled
         CXE_CP_TerminatedSoleServiceDeactBatch b 
         		= new CXE_CP_TerminatedSoleServiceDeactBatch(Integer.valueOf(meta.Portal_No_Enrollment_Grace_Period__c) );
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,200);
    }

}