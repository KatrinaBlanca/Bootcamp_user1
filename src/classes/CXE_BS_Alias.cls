@RestResource(urlMapping='/alias-icon')
global with sharing class CXE_BS_Alias  {

	@HttpGet
	global static CXE_Service_Enrollment__c load(){

		Map<String, String> params = RestContext.request.params;
        return load(params.get('sid'));
	}

    @HttpPost
    global static CXE_Service_Enrollment__c post(String sid, String alias, String icon) {

    	CXE_Service_Enrollment__c target = load(sid);
    	target.CXE_Alias__c = alias;
    	target.CXE_Icon_Id__c = icon;

    	update target;

    	return target;
        
        //CXE_Json.text(CXE_CP_MyAccounts.changeAura(sin, aura));
    }

    private static CXE_Service_Enrollment__c load(String sid){
    	return [
			Select Id, CXE_ServiceId__c
             , CXE_Alias__c
             , CXE_Icon_Id__c
             , CXE_ServiceId__r.Account__c 
             , CXE_ServiceId__r.SIN__c 
            From CXE_Service_Enrollment__c 
            Where CXE_UserId__c = :UserInfo.getUserId()
            and CXE_ServiceId__c = :sid
            limit 1
        ];
    }
}