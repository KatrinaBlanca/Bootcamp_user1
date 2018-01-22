global class CXE_CP_LastEnrolledServiceNotiSched implements Schedulable{
    
    global void execute(SchedulableContext sc){
        // We now call the batch class to be scheduled
         CXE_CP_LastEnrolledServiceNotiBatch b = new CXE_CP_LastEnrolledServiceNotiBatch();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,200);
    }

}