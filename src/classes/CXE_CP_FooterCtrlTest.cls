/* 
 * Description: Test Class for CXE_CP_FooterCtrl
 * Author: Rom Edison Reyes (Accenture)
 * Date Created: JAN-02-2018
 */ 
@isTest
private class CXE_CP_FooterCtrlTest {

    @testSetup static void setUp() {
      // create custom setting OrganizationSettings__c
      OrganizationSettings__c orgSet = new OrganizationSettings__c();
      orgset.FooterLinkToInstagram__c = 'https://www.instagram.com/meralcoph';
      orgset.FooterLinkToYoutube__c = 'https://www.youtube.com/user/meralcoph';
      orgset.FooterLinkToTwitter__c = 'https://twitter.com/meralco';
      orgset.FooterSubmitFeedback__c = 'http://www.meralco.com.ph/contact-us/overview';
      orgset.FooterLinkToFacebook__c = 'https://www.facebook.com/meralco/';
      orgset.FooterTermsAndCondition__c = 'http://www.meralco.com.ph/contact-us/overview';
      orgset.FooterLinkToPrivacyPolicy__c = 'http://www.meralco.com.ph/privacy-policy';
      insert orgset;
    }

    static testmethod void testFooter() {
        //test method when only string is provided
        Test.startTest();
        System.assertEquals(CXE_CP_FooterCtrl.iGLink(), 'https://www.instagram.com/meralcoph');
        System.assertEquals(CXE_CP_FooterCtrl.youTubeLink(), 'https://www.youtube.com/user/meralcoph');
        System.assertEquals(CXE_CP_FooterCtrl.twitterLink(), 'https://twitter.com/meralco');
        System.assertEquals(CXE_CP_FooterCtrl.feedBackLink(), 'http://www.meralco.com.ph/contact-us/overview');
        System.assertEquals(CXE_CP_FooterCtrl.fBLink(), 'https://www.facebook.com/meralco/');
        System.assertEquals(CXE_CP_FooterCtrl.TermsAndConditionLink(), 'http://www.meralco.com.ph/contact-us/overview');
        System.assertEquals(CXE_CP_FooterCtrl.PrivacyPolicyLink(), 'http://www.meralco.com.ph/privacy-policy');
        System.assertEquals(CXE_CP_FooterCtrl.generatedLink, null);
        Test.stopTest();
    }
}