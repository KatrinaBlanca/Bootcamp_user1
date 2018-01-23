@RestResource(urlMapping='/unenroll')
global with sharing class CXE_BS_Unenroll {
	
	@HttpPost
    global static void get(String acc, String sin) {
    	CXE_Json.text(
    		CXE_CP_MyAccountsAccountDetail.checkSinToDelete(acc, sin)
		);
    }
}