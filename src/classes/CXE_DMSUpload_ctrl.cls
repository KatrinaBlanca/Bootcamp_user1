global without sharing class CXE_DMSUpload_ctrl {

    // sopon.s [CSM-14267] merge with R2B
    public String redirect {get{
        Map<String, String> q = ApexPages.currentPage().getParameters();
        // START CSM-14862 Jerome To 12/13/2017 [R2C Regression] Unable to upload and view DMS Document
        return CXE_HerokuApps.download_sign(
            q.get('target').toUpperCase()
            , q.get('target').toUpperCase() + '|' + q.get('aid') + '|' + q.get('oid')
            , q.get('name')
        );
        // END CSM-14862 Jerome To 12/13/2017 [R2C Regression] Unable to upload and view DMS Document
    }}
    public DMS_Document__c dms{get; private set;}
    public String dms_id{get; private set;}
    public String token{ 
        get{
            return UserInfo.getOrganizationId() + '!' + CXE_Utility.getSecureToken();
        }
    }
    public String base_url{ 
        get{
            return System.URL.getSalesforceBaseURL().toExternalForm();
        }
    }
    //public String file_name{
    //    get{
    //        Map<String, String> q = ApexPages.currentPage().getParameters();
    //        String oid = q.get('oid');
    //        return [select Id, CXE_File_Name_f__c from DMS_Document__c where Id = :oid].CXE_File_Name_f__c;
    //    }
    //}


    public CXE_DMSUpload_ctrl(ApexPages.StandardController ctrl) {
        this.dms = new DMS_Document__c();

    }

    public CXE_DMSUpload_ctrl(){
        this.dms = new DMS_Document__c();
    }

    
 

    // sopon.s [CSM-14267] merge with R2B
    @RemoteAction
    global static String upload_sign(String aid, String oid){

        return CXE_HerokuApps.upload_sign('DMS', aid + '|' + oid);
    }

    @RemoteAction
    global static String rename_file(String aid, String oid, String tid){

        String uid = UserInfo.getUserId().substring(0, 15);

        HttpRequest req = CXE_HerokuApps.tokenize(
            OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'rename/'
        );
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(new Map<String, String>{
            'old' => String.join(new String[]{'DMS', aid, uid + '-' + tid}, '|')
            , 'new' => String.join(new String[]{'DMS', aid, oid}, '|')
        }));

        if(!Test.isRunningTest()){
            Http h = new Http();
            
            HttpResponse res = h.send(req);
            return res.getBody();
        }
        else{
            return null;
        }
    }

    @RemoteAction
    global static Integer find_dms(String name){
        return [
            select count() from DMS_Document__c where CXE_File_Name__c = :name
        ];
    }
    
    @RemoteAction
    global static Agreement__c check_service(String caseId ){
        Agreement__c service = new Agreement__c();
        service.Id = null;
        //START CSM-15029 RReyes JAN-04-17
        service.Case__c = null;
        if(caseId != null && caseId != '' && caseId != '000000000000000') {
            List<Agreement__c> serviceList = new List<Agreement__c>();
            serviceList = [SELECT Id, SIN__c, Case__c, Case__r.CaseNumber FROM Agreement__c WHERE Case__c = :caseId AND Parent_Tag__c = true];
            
            if(!serviceList.isEmpty())
                service = serviceList[0];
        }
        //END CSM-15029 RReyes JAN-04-17
        return service;
    }


    @RemoteAction
    global static void error_log(String context){
        if(!Test.isRunningTest())
            ErrorHandlerException.recordException(null, true, 'CXE_DMSUpload_ctrl', '', context);
    }
}