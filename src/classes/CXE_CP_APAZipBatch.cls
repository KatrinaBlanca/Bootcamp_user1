/* 
 * Description: Scheduled Batch which zips all files inside a folder in S3
 * Author: Rom Edison Reyes (Accenture)
 * Date Created: NOV-09-17
 * Requirement: CSM-13169
 */ 
global class CXE_CP_APAZipBatch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        createZip();
    }

    @future(callout=true)
    public static void createZip(){
    	try{
            DateTime today = DateTime.now().addDays(-1);
            String folderName = today.format('MMddyyyy');
            String res = CXE_HerokuApps.apa_zip_sign('APA', folderName, 'APA_' + folderName);

        }catch(Exception e){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_APAZipBatch', 'execute', e.getMessage());
        }
    }
}