/**
 * An apex page controller that exposes the site login functionality
 */
@IsTest global with sharing class CommunitiesLoginControllerTest {
    @IsTest(SeeAllData=true) 
    global static void testCommunitiesLoginController () {
    	PageReference pRef = new PageReference(OrganizationSettings__c.getInstance().PortalEmailURL__c +'/splash?startURL=null');
        ApexPages.currentPage().getParameters().put('startURL','null');
     	CommunitiesLoginController controller = new CommunitiesLoginController();
        controller.username = 'test';
        controller.password = 'test';
     	System.assertEquals(String.valueOf(pRef), String.valueOf(controller.forwardToAuthPage()) );       
    }

	@IsTest(SeeAllData=true) 
    global static void testCommunitiesIsMobile () {
        String portalEmailUrl = OrganizationSettings__c.getInstance().PortalEmailURL__c;
        String portalEmailUrlRemovedS = portalEmailUrl.left(portalEmailUrl.length() - 2);
    	PageReference pRef = new PageReference(portalEmailUrlRemovedS +'/CXE_splashMeralcoMobile?startURL=RemoteAccessAuthorizationPage');
        ApexPages.currentPage().getParameters().put('startURL','RemoteAccessAuthorizationPage');
     	CommunitiesLoginController controller = new CommunitiesLoginController();
     	System.assertEquals(String.valueOf(pRef), String.valueOf(controller.forwardToAuthPage()) );       
    }     
    
}