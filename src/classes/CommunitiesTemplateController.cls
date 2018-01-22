/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesTemplateController {
    
    // Code we will invoke on page load.
    public PageReference forwardToHomePage() {
        PageReference pRef;
        try{
            pRef = new PageReference(OrganizationSettings__c.getInstance().PortalEmailURL__c +'/dashboard');
            
        }catch (Exception ex){
            pRef = Network.communitiesLanding();
            ErrorHandlerException.recordException(null, true, 'CommunitiesTemplateController ', 'forwardToHomePage'
                                                  , UserInfo.getUserId() + ' : ' + ex.getMessage());
        }
        return pRef;
    }
    
    public CommunitiesTemplateController () {}
}