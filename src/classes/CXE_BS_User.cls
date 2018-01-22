@RestResource(urlMapping='/loginHistory')
global without sharing class CXE_BS_User {

	private class cxeLoginHistory{
		DateTime lastLoginDate {get; set;}

		public cxeLoginHistory(DateTime value){
			lastLoginDate = value;
		}
	}

	@HttpGet
    global static void get(){

		CXE_CP_PortalUtility.PortalData portalData = CXE_CP_Dashboard.retrieveLoginHistory();
		DateTime lastLoginDate = portalData.LastLoginDate;

		if(portalData.loginHistoryList.size() > 0){
			for(LoginHistory o : portalData.loginHistoryList){
				if(o.Status == 'Success'){
					lastLoginDate = o.LoginTime;
					break;
				}
			}
		}

    	CXE_Json.Response(
    		new cxeLoginHistory(LastLoginDate)
    	);
    }
}