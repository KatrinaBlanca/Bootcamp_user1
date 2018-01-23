/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
    	PageReference pRef;
    	try{
	        pRef = new PageReference(OrganizationSettings__c.getInstance().PortalEmailURL__c +'/splash');
            
        }catch (Exception ex){
        	pRef = Network.communitiesLanding();
            ErrorHandlerException.recordException(null, true, 'CommunitiesLandingController', 'forwardToStartPage'
                                                  , UserInfo.getUserId() + ' : ' + ex.getMessage());
        }
        return pRef;
    }
    
    public CommunitiesLandingController() {}
}