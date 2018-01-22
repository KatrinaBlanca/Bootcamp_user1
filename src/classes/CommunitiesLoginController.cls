/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CommunitiesLoginController {
    public String password {get;set;}
    public String username {get;set;}



    global CommunitiesLoginController () {}
    
    // Code we will invoke on page load.
    global PageReference forwardToAuthPage() {
        //START CSM-13053 GGrandea 10.05.2017
            String startUrl = System.currentPageReference().getParameters().get('startURL');
            //return new PageReference(OrganizationSettings__c.getInstance().PortalEmailURL__c + '/splash?startURL=' + EncodingUtil.urlEncode(startURL, 'UTF-8'));
        //END CSM-13053 GGrandea 10.05.2017
        
        /*START JANAH 20171122*/
        //String startUrl = System.currentPageReference().getParameters().get('startURL');
        system.debug('>>>>>startURL ' + startUrl);
        String customHomePage = '/apex/CXE_splashMeralcoMobile';
        Boolean isMobile = startUrl.contains('RemoteAccessAuthorizationPage');

        if(startURL!= null && startURL.contains('RemoteAccessAuthorizationPage')){
            return new PageReference(OrganizationSettings__c.getInstance().CP_URL__c + '/CXE_splashMeralcoMobile?startURL=' + EncodingUtil.urlEncode(startUrl, 'UTF-8'));
           // return Site.login(username,password, startURL);
            
        }else{
            
                return new PageReference(OrganizationSettings__c.getInstance().PortalEmailURL__c + '/splash?startURL=' + EncodingUtil.urlEncode(startUrl, 'UTF-8'));
            
            
        }
        //*END JANAH 20171122*/
        
       
    }
}