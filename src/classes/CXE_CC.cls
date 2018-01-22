public with sharing class CXE_CC {

	public String paymaya_endpoint{
        get{
            return OrganizationSettings__c.getOrgDefaults().Paymaya_Endpoint__c;
        }
    }

    public String paymaya_authorization{
        get{
            return OrganizationSettings__c.getOrgDefaults().Paymaya_Authorization__c;
        }
    }

    public CXE_CC() {
        //this.mysObject = (sObject)stdController.getRecord();
    }

    @AuraEnabled
    public static Map<String, Object> pay(String token, String amount, String fee, String total, String fname,String email ,String mode ,String office,String address,List<Object> trans){
        try{
            return (Map<String, Object>) JSON.deserializeUntyped(
                // Start R3A CSM-14884 Von Pernicia 1/4/17: Added origin parameter
                CXE_HerokuApps.cc_pay(token, amount, fee, total, fname, email, mode, office, address, null, CXE_Constants.PAYMENT_ORIGIN_PORTAL)
                // End R3A CSM-14884 Von Pernicia 1/4/17: Added origin parameter
            );    
        }
        catch(CXE_HerokuApps.HerokuException hx){
            if(hx.asJson() != null) return hx.asJson();

            throw hx;
        }
    }

    @AuraEnabled
    public static Map<String, Object> fee(String amount){
        try{
            return (Map<String, Object>) JSON.deserializeUntyped(
                CXE_HerokuApps.convenienceFee(amount)
            );
        }
        catch(CXE_HerokuApps.HerokuException hx){
            if(hx.asJson() != null) return hx.asJson();

            throw hx;
        }
    }
}