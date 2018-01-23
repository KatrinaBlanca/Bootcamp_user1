@RestResource(urlMapping='/enrollPaperless')
global without sharing class CXE_BS_Paperless_Enroll  {

    @HttpGet
    global static List<Case> load(){
        Id uid = UserInfo.getUserId();

        Id aid = [SELECT AccountId FROM User WHERE Id = :uid].AccountId;
        
        return [
            SELECT Id, CaseNumber, Status, Application_Type_Subtype__c, RecordType.DeveloperName
                , (SELECT Id, To_Date_Stamp__c, To_State__c FROM Case_State_Transition__r ORDER By To_Date_Stamp__c DESC)
            FROM Case 
            WHERE AccountId = :aid
            AND RecordTypeId in (SELECT Id FROM RecordType WHERE sObjectType = 'Case' AND Name = :CXE_Constants.CASE_PAPERLESS_BILLING)
        ];
    }


    @HttpPost
    global static void post(String email, String account_no) {

        Map<String, String> params = RestContext.request.params;

        String msg = CXE_CP_PaperlessBillingSubscribeEmail.updateEmail(email, account_no);

        CXE_Json.text(msg);
    }
}