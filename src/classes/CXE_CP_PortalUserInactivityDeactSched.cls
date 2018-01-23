global class CXE_CP_PortalUserInactivityDeactSched implements Schedulable{
    
    global void execute(SchedulableContext sc){

    	Org_Wide_Fixed_Setting__mdt meta = [SELECT Portal_No_Enrollment_Grace_Period__c
    														,Portal_User_Inactivity_Deactivation__c
    														,Portal_User_Inactivity_Notif_Count__c
                                                            ,Portal_No_Password_Grace_Period__c //CSM-13881 10.12.2017
    													FROM Org_Wide_Fixed_Setting__mdt WHERE MasterLabel =: CXE_Constants.ALL_STR LIMIT 1];
        // We now call the batch class to be scheduled
         CXE_CP_PortalUserInactivityDeactBatch b 
         		= new CXE_CP_PortalUserInactivityDeactBatch(Integer.valueOf(meta.Portal_User_Inactivity_Deactivation__c)
                                    , Integer.valueOf(meta.Portal_No_Password_Grace_Period__c), null ); //START CSM-14517 JFernandez DEC-12-17 ADD NULL VALUE FOR THE INITAL LIST
       
         //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,200);
    }

}