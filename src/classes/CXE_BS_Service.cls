@RestResource(urlMapping='/enroll-service')
global with sharing class CXE_BS_Service  {

    @HttpGet
    global static void mine() {
        Map<String, String> params = RestContext.request.params;

        String acc_num = null, service_num = null;

        if(params.containsKey('accountNum')) acc_num = params.get('accountNum');
        if(params.containsKey('serviceNum')) service_num = params.get('serviceNum');

        if(acc_num != null || service_num != null){
            CXE_Json.response(CXE_CP_MyAccounts.SelectedData(acc_num, service_num));
        }
        else{
            CXE_Json.response(CXE_CP_PortalUtility.retrievePortalData());    
        }
    }

    @HttpPost
    global static void link(String sin, Decimal amount, String transactionDate, Boolean isNew){
    	CXE_Json.response(
            CXE_CP_MyAccountsManageService_CC.enrollService(sin, amount, transactionDate, isNew)
        );
    }
}