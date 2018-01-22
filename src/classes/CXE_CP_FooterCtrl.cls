public class CXE_CP_FooterCtrl {
    
    public static String generatedLink;
    
    @AuraEnabled
    public static String  iGLink() {
        return OrganizationSettings__c.getOrgDefaults().FooterLinkToInstagram__c;
    }
    
    @AuraEnabled
    public static String  youTubeLink() {
        return OrganizationSettings__c.getOrgDefaults().FooterLinkToYoutube__c;
    }
    
    @AuraEnabled
    public static String  twitterLink() {
        return OrganizationSettings__c.getOrgDefaults().FooterLinkToTwitter__c;
    }
    
    @AuraEnabled
    public static String  feedBackLink() {
        return OrganizationSettings__c.getOrgDefaults().FooterSubmitFeedback__c;
    }
    
    @AuraEnabled
    public static String  fBLink() {
        return OrganizationSettings__c.getOrgDefaults().FooterLinkToFacebook__c;
    }
    
    
	@AuraEnabled
    public static String  TermsAndConditionLink() {	
        return OrganizationSettings__c.getOrgDefaults().FooterTermsAndCondition__c;
    }
    
    @AuraEnabled
    public static String  PrivacyPolicyLink() {	
        return OrganizationSettings__c.getOrgDefaults().FooterLinkToPrivacyPolicy__c;
    }

    
    
    
}