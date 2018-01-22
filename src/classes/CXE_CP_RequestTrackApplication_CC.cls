public with sharing class CXE_CP_RequestTrackApplication_CC {
	public CXE_CP_RequestTrackApplication_CC() {
		
	}

	@AuraEnabled
	public static CXE_CP_PortalUtility.PortalData getCaseList() {
		return CXE_CP_PortalUtility.retrievePortalData();
	}

	@AuraEnabled
	public static CXE_CaseResponseWrapper trackApplication(String referenceNumber, String lastName){
		return CXE_ServiceApplication.trackApplication(referenceNumber, lastName);
	}
}