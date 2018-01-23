public class CXE_CP_MiniAddsCtrl {
    
    @AuraEnabled
    public static String MiniAddsBillSummary() {
        return OrganizationSettings__c.getOrgDefaults().MiniAddsBillSummary__c;
    }
    
    //Start CSM-14499 Mike Verdad 12/05/2017
    @AuraEnabled
    public static String MiniAddsPaperlessBillingUnsubscribe() {
        return OrganizationSettings__c.getOrgDefaults().MiniAddsPaperlessBillingUnsubscribe__c;
    }
	//End CSM-14499 Mike Verdad 12/05/2017
	
    //Start CSM-14767 Mike Verdad 12/05/2017
    @AuraEnabled
    public static String MiniAddsPaperlessBillingTnC() {
        return OrganizationSettings__c.getOrgDefaults().MiniAddsPaperlessBillingTnC__c;
    }
	//End CSM-14767 Mike Verdad 12/05/2017

    
    /*@AuraEnabled
    public static String MiniAddsOnlineBillingFAQs() {
        return OrganizationSettings__c.getOrgDefaults().MiniAddsOnlineBillingFAQs__c;
    }*/
    
    @AuraEnabled
    public static String MIniAddsPaymentOptions() {
        return OrganizationSettings__c.getOrgDefaults().MIniAddsPaymentOptions__c;
    }
    
    @AuraEnabled
    public static String MiniAddsViewBillAnytimeAnyWhere() {
        return OrganizationSettings__c.getOrgDefaults().MiniAddsViewBillAnytimeAnyWhere__c;
    }
    
    /*@AuraEnabled
    public static String MiniAddsBillDashNoti() {
        return OrganizationSettings__c.getOrgDefaults().MiniAddsBillDashNoti__c;
    }*/
    
    

}