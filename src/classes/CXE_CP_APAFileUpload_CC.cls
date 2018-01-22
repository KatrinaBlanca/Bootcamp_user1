/* Description: Controller class for APA File Uploader
 * Author: Rom Edison Reyes
 * Date Created: NOV-03-17
 * CSM-13109
 */
public without sharing class CXE_CP_APAFileUpload_CC {

	/* Description: Get case Details
    * Parameters: Case Id
    * Returns: Case
    * Author: Rom Edison Reyes
    * Date Created: NOV-03-17
    */
    @AuraEnabled
    public static Case getCaseDetails(Id caseId){
    	return [SELECT Id, Status, CaseNumber,
                    toLabel(CXE_APA_Agent__c), //START/END CSM-13154 RReyes NOV-08-17
        			CXE_APA_Attachment_Count__c, 
        			Application_Type_Subtype__c
                FROM Case 
                WHERE Id=: caseId LIMIT 1];
    }

    /* Description: Update attachment count
    * Parameters: Case Id, File count
    * Returns: String
    * Author: Rom Edison Reyes
    * Date Created: NOV-04-17
    */
    @AuraEnabled
    public static String updateFileCount(Id caseId, Integer fileCount){
        String updateStatus = 'SUCCESS';
        fileCount = Integer.valueOf(fileCount);

        Case caseRec = new Case();
        caseRec.Id = caseId;
        caseRec.CXE_APA_Attachment_Count__c = fileCount;
        try{
            update caseRec;
        }catch(DMLException dmlEx){
            updateStatus = 'FAILED';
            ErrorHandlerException.recordException(caseRec.Id, true, 'CXE_CP_APAFileUpload_CC', 'updateFileCount', dmlEx.getDMLMessage(0));
        }

        return updateStatus;
    }

    /* Description: Get key value settings
    * Parameters: none
    * Returns: List<CXE_KeyValueSetting__c>
    * Author: Rom Edison Reyes
    * Date Created: NOV-03-17
    */
    @AuraEnabled
    public static List<CXE_KeyValueSetting__c> getKeyValSettings(){
        return [SELECT Name, Value__c FROM CXE_KeyValueSetting__c];
    }

    /* Description: do an upload sign for apa
    * Parameters: documentName
    * Returns: String (url)
    * Author: Rom Edison Reyes
    * Date Created: NOV-03-17
    */
    @AuraEnabled
    public static String upload_sign(String documentName) {
        return CXE_HerokuApps.apa_upload_sign(documentName);
    }
}