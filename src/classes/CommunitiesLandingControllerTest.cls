/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
@IsTest public with sharing class CommunitiesLandingControllerTest {
    @isTest static void forwardToHomePage_Test(){
        
        Test.startTest();
        
        PageReference pageRef = Page.CommunitiesTemplate;
        
        CommunitiesLandingController ctrl = new CommunitiesLandingController();
        pageRef =ctrl.forwardToStartPage();
        
        System.assert(pageRef !=null);
        
        Test.stopTest();

    }
   
}