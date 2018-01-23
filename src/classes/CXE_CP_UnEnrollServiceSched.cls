global class CXE_CP_UnEnrollServiceSched implements Schedulable{
    
    global void execute(SchedulableContext sc){

    	        // We now call the batch class to be scheduled
         CXE_CP_UnEnrollServiceBatch b  = new CXE_CP_UnEnrollServiceBatch();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,200);
    }

}