/* Description: Controller class for Auto Pay Arrangement (APA) Subscribe and Unsubscribe Lightning components
 * Author: Rom Edison Reyes
 * Date Created: OCT-04-17
 * APA Enrollment: CSM-XXXXX, --- 
 * APA Cancellation: CSM-13204, CSM-13209, CSM-13214, CSM-13219, CSM-13224, CSM-13229, CSM-13234, CSM-13239
 */
 public without sharing class CXE_CP_AutoPaymentArrangement_CC {

public class AutoPayData {
    @AuraEnabled
    public List<String> validAccts;

    //START CSM-13089 RReyes OCT-26-17
    @AuraEnabled
    public List<String> blacklistedAccts;
    //END CSM-13089 RReyes OCT-26-17

    //START CSM-13099 RReyes OCT-11-17
    @AuraEnabled
    public List<CXE_KeyValueSetting__c> keyValueSetting;
    //END CSM-13099 RReyes OCT-11-17
}
 
//START CSM-13094 RReyes OCT-04-17
 /* Description: Get contract account Ids for Enrollment/Cancellation
 * Parameters: none
 * Returns: List<String>
 * Author: Rom Edison Reyes
 * Date Created: OCT-05-17
 */
 @AuraEnabled
 public static AutoPayData getAccounts(Boolean isEnroll){
    AutoPayData apaData = new AutoPayData();
    Set<String> setAccounts = new Set<String>();
    List<String> lstAccounts = new List<String>();
    Set<String> setBlacklist = new Set<String>();
    List<String> lstBlacklist = new List<String>();
    List<CXE_Service_Enrollment__c> listofEnrollments = [SELECT Id, CXE_ServiceId__c, CXE_Alias__c,
                                                                    CXE_ServiceId__r.SIN__c,
                                                                    CXE_ServiceId__r.Account__c,
                                                                    CXE_ServiceId__r.Payor__c,
                                                                    CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c, //START/END CSM-14973 RReyes
                                                                    CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c,
                                                                    CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c,
                                                                    CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c,
                                                                  //  CXE_ServiceId__r.Payor__r.CXE_APA_Blacklist_Tagging__c
                                                                    CXE_ServiceId__r.Payor__r.CXE_Is_APA_Blacklisted__c, //Start/End Rabayon updated code CSM-13204 10/11/17
                                                                    CXE_ServiceId__r.Payor__r.V10_Account_No__c,
                                                                    CXE_ServiceId__r.Payor__r.AccountId,
                                                                    CXE_Type__c,
                                                                    CXE_IsActive__c
                                                                    FROM CXE_Service_Enrollment__c 
                                                                    WHERE CXE_UserId__c=:UserInfo.getUserId() 
                                                                    AND CXE_IsActive__c = true];
    if(!listofEnrollments.isEmpty()){
        for(CXE_Service_Enrollment__c serv: listofEnrollments){
            if(serv.CXE_ServiceId__r.Payor__c != null){
                //For APA Enrollment - get contracts which is NOT enrolled to APA 
                    //OR, contracts which is ENROLLED to APA and has a pending APA Cancellation case with Change in bank account or card no. as reason for cancellation, 
                    //AND has no pending APA enrollment request
                //For APA Cancellation - get contracts which is enrolled to APA, and has no pending APA cancellation request
                //START CSM-14973 RReyes DEC-27-17- change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                if(!String.isBlank(serv.CXE_ServiceId__r.Payor__r.V10_Account_No__c) 
                && !setAccounts.contains(serv.CXE_ServiceId__r.Payor__r.V10_Account_No__c)
                && (
                    (isEnroll 
                    && (!serv.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c 
                        || (serv.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c 
                            && serv.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c 
                            && serv.CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c == Label.RFC_CHANGE_IN_NUMBER)) 
                        && !serv.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c ) 
                    || 
                    (!isEnroll 
                        && serv.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c 
                        && !serv.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c)
                    ))
                {
                //END CSM-14973 RReyes DEC-27-17- change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                    setAccounts.add(serv.CXE_ServiceId__r.Payor__r.V10_Account_No__c);
                    //get blacklisted accounts
                    //START CSM-13089 RReyes OCT-26-17
                    if(serv.CXE_ServiceId__r.Payor__r.CXE_Is_APA_Blacklisted__c //Start/end Rabayon updated code CSM-13204 10/11/17 
                        && !setBlacklist.contains(serv.CXE_ServiceId__r.Payor__r.V10_Account_No__c)){
                        setBlacklist.add(serv.CXE_ServiceId__r.Payor__r.V10_Account_No__c);
                    }
                    //END CSM-13089 RReyes OCT-26-17
                }
            }
        }

        lstAccounts.addAll(setAccounts);
        lstBlacklist.addAll(setBlacklist); //START/END CSM-13089 RReyes OCT-26-17
        if(!lstAccounts.isEmpty()){
            lstAccounts.sort();  
        }
    }

    apaData.validAccts = lstAccounts;
    apaData.blacklistedAccts = lstBlacklist; //START/END CSM-13089 RReyes OCT-26-17
    //START CSM-13099 RReyes OCT-11-17
    if(isEnroll){
        List<CXE_KeyValueSetting__c> keyValueSet = [SELECT Name, Value__c FROM CXE_KeyValueSetting__c];
        if(!keyValueSet.isEmpty()){
            apaData.keyValueSetting = keyValueSet;
        }
    }
    //END CSM-13099 RReyes OCT-11-17

    return apaData;
 }

/* Description: create APA case
 * Parameters: contractAcctNum, isAPAEnroll, reasonForCancel
 * Returns: List<String>
 * Author: Rom Edison Reyes
 * Date Created: OCT-05-17
 */
 @AuraEnabled
 //START CSM-13109 RReyes OCT-27-17 - added fileCount
 public static String createAPACase(String contractAcctNum, Boolean isAPAEnroll, String reasonForCancel, String apaScheme, String apaAgent, Integer fileCount){
 //END CSM-13109 RReyes OCT-27-17 - added fileCount   
    Id apaRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_APA).getRecordTypeId();
    String caseNum = '';
    CXE_Service_Enrollment__c servEnroll = new CXE_Service_Enrollment__c();
    List<CXE_Service_Enrollment__c> listofEnrollments = [SELECT Id, CXE_ServiceId__c,
                                                            CXE_Type__c,
                                                            CXE_ServiceId__r.Payor__c,
                                                            CXE_ServiceId__r.Payor__r.V10_Account_No__c,
                                                            CXE_ServiceId__r.Payor__r.AccountId,
                                                            CXE_IsActive__c
                                                        FROM CXE_Service_Enrollment__c 
                                                        WHERE CXE_UserId__c =: UserInfo.getUserId()
                                                        AND CXE_IsActive__c = true];

    User myUser = [SELECT Id, ContactId FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
        
    if(!listofEnrollments.isEmpty()){
        for(CXE_Service_Enrollment__c enroll : listofEnrollments){
            if(enroll.CXE_ServiceId__r.Payor__c != null){
                if(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c == contractAcctNum){
                    servEnroll = enroll;
                    break;
                }
            }
        }

        if(servEnroll != null){
            Case newCase = new Case();
            //START CSM-13144/CSM-13234 RReyes OCT-13-17
            //START CSM-14517 JFernandez 1252017 Commented the code and transfer to CaseTriggerHandler after sending of email for APA
            /*List<Group> paymentOpsQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName =:CXE_Constants.QUEUE_PAYMENT_OPERATIONS LIMIT 1];
            if(!paymentOpsQueue.isEmpty()){
                newCase.OwnerId = paymentOpsQueue[0].Id;
            }*/
            //END CSM-14517 JFernandez 1252017
            //END CSM-13144/CSM-13234 RReyes OCT-13-17
            newCase.RecordTypeId = apaRecTypeId;
            newCase.Account_Number__c = contractAcctNum;
            if(isAPAEnroll){
                newCase.Application_Type_Subtype__c = 'APA Enrollment';
                newCase.CXE_APA_Scheme__c = apaScheme;
                newCase.CXE_APA_Agent__c = apaAgent;
                newCase.Status = 'Document Received';//START/END CSM-13144 RReyes OCT-19-17
                //START CSM-13109 RReyes OCT-27-17 - added fileCount
                fileCount = Integer.valueOf(fileCount);
                newCase.CXE_APA_Attachment_Count__c = fileCount; 
                //END CSM-13109 RReyes OCT-27-17 - added fileCount
            }else{
                newCase.Application_Type_Subtype__c = 'APA Cancellation';
                newCase.CXE_Reason_for_Cancellation_APA__c = reasonForCancel;
                newCase.Status = 'Open';//START/END CSM-13144 RReyes OCT-19-17
            }
            //newCase.Origin = 'Customer'; ///START END CSM-15047 JFernandez JAN-10-18 Commented
            newCase.Origin = CXE_Constants.PAYMENT_ORIGIN_PORTAL;//START END CSM-15047 JFernandez JAN-10-18
            //newCase.Status = 'Open';//START/END CSM-13144 RReyes OCT-19-17
            newCase.CXE_Request_Date__c = date.today();

            newCase.AccountId = servEnroll.CXE_ServiceId__r.Payor__r.AccountId;
            newCase.Contract__c = servEnroll.CXE_ServiceId__r.Payor__c;
            newCase.ContactId = myUser.ContactId;
            insert newCase;
            
            Case c = [SELECT CaseNumber FROM Case WHERE Id=:newCase.Id LIMIT 1];
            caseNum = c.CaseNumber;

            if(!String.isBlank(caseNum)){
                if(servEnroll.CXE_ServiceId__r.Payor__c != null){
                    Contract ctr = new Contract();
                    ctr.Id = servEnroll.CXE_ServiceId__r.Payor__c;
                    if(isAPAEnroll){
                        ctr.CXE_Pending_APA_Enrollment__c = true;
                    }else{
                        ctr.CXE_Pending_APA_Cancellation__c = true;
                        ctr.CXE_Reason_for_Cancellation_APA__c = reasonForCancel; //START/END CSM-13848 RReyes OCT-11-17
                    }
                    try{
                        update ctr;
                    }catch(DMLException dmlEx){
                        ErrorHandlerException.recordException(ctr.Id, true, 'CXE_CP_AutoPaymentArrangement_CC', 'createAPACase', dmlEx.getDMLMessage(0));
                    }
                }
            }
        }
    }

    return caseNum;
 }
 //END CSM-13209 RReyes OCT-04-17

//START CSM-13109 RReyes OCT-26-17
/* Description: do an upload sign for apa
* Parameters: caseNumber, agentName, ext
* Returns: String (url)
* Author: Rom Edison Reyes
* Date Created: OCT-26-17
*/
@AuraEnabled
public static String upload_sign(String documentName) {
    return CXE_HerokuApps.apa_upload_sign(documentName);
}
//END CSM-13109 RReyes OCT-26-17
     
    //START R2C CSM-14749 Shayne 12/01/2017
	@AuraEnabled
     public static Boolean retrieveCheckConglomerate(){
         return CXE_CP_PortalUtility.checkIfConglomerateAccount();
     }
     //END R2C CSM-14749 Shayne 12/01/2017
}