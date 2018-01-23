@RestResource(urlMapping='/ticket')
global without sharing class CXE_BS_Ticket  {

    @HttpGet
    global static List<Case> load(){
        Map<String, String> params = RestContext.request.params;
        String t = '';
        Id uid = UserInfo.getUserId();
        Id aid = [select Contact.AccountId from User where Id = :uid].Contact.AccountId;
        
        if(params.containsKey('type')) t = params.get('type');

        // START LISEN : CSM-15085
        Id userId = UserInfo.getUserId();
        Set<Id> accountIds = new Set<Id> ();
        Set<Id> contactIds = new Set<Id> {CXE_CP_PortalUtility.getCurrentUserContacId()}; 

        List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c, CXE_Alias__c  
                                                                     , CXE_ServiceId__r.SIN__c
                                                                     , CXE_ServiceId__r.Account__c
                                                                     , CXE_ServiceId__r.Payor__c
                                                                     , CXE_ServiceId__r.Payor__r.V10_Account_No__c
                                                                     , CXE_ServiceId__r.Payor__r.AccountId
                                                                     , CXE_Type__c
                                                                     , CXE_IsActive__c
                                                                     From CXE_Service_Enrollment__c 
                                                                     Where CXE_UserId__c=:UserInfo.getUserId() 
                                                                     and CXE_IsActive__c = True
                                                                           ];

        for(CXE_Service_Enrollment__c enroll : listofEnrollments){
            if(enroll.CXE_ServiceId__r.Payor__r.AccountId!=null){
                accountIds.add(enroll.CXE_ServiceId__r.Payor__r.AccountId);
            }
        }
        // END LISEN : CSM-15085

        if(t == 'paperless'){
            return [
                select Id, CaseNumber, Status, Application_Type_Subtype__c, RecordType.DeveloperName, Account.Name, RecordType.Name, CreatedDate
                    , CXE_Service_Address_R2__c, Service_Address_from_Web__c, CXE_Service_Address__c, Legacy_Service_Address__c, CXE_Effective_Date__c
                    , (SELECT Id, NewValue, CreatedDate FROM Histories WHERE Field = 'Status' ORDER By CreatedDate DESC)
                from Case 
                where (AccountId = :accountIds OR (ContactId IN:contactIds AND ContactId != '') OR CreatedById = :userId) and RecordTypeId in (select Id from RecordType where sObjectType = 'Case' and Name = :CXE_Constants.CASE_PAPERLESS_BILLING) // LISEN : CSM-15085
            ];
        }
        else{
            return [
                select Id, CaseNumber, Status, Application_Type_Subtype__c, RecordType.DeveloperName, Account.Name, RecordType.Name, CreatedDate
                    , CXE_Service_Address_R2__c, Service_Address_from_Web__c, CXE_Service_Address__c, Legacy_Service_Address__c, CXE_Effective_Date__c
                    , (SELECT Id, NewValue, CreatedDate FROM Histories WHERE Field = 'Status' ORDER By CreatedDate DESC)
                from Case 
                where AccountId = :accountIds OR (ContactId IN:contactIds AND ContactId != '') OR CreatedById = :userId // LISEN : CSM-15085
            ];
        }
    }

}