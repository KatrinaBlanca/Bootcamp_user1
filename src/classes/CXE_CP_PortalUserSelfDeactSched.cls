global class CXE_CP_PortalUserSelfDeactSched implements Schedulable{
    
    global void execute(SchedulableContext sc){
        CXE_CP_PortalUserSelfDeactBatch b = new CXE_CP_PortalUserSelfDeactBatch();
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,200);
    }
    

}