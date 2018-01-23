public with sharing class CXE_CP_DeactivationCtrl {

//end of Melvin Corbes Jul-28-2017
    /* Author: Melvin Corbes
     * August-02-2017
     * Rendering for Related Articles
     */ 
    
    Public class PortalDeactivationReasonLinkUrl{
        
        @AuraEnabled
        public String DifferentEmail {get; set;}
        @AuraEnabled
        public String MoveOutAddress {get; set;}
        @AuraEnabled
        public String NoActiveSin {get; set;}
        @AuraEnabled
        public String NoLongerUse {get; set;}
        @AuraEnabled
        public String PortalDifficult {get; set;}
        @AuraEnabled
        public String PortalUnuseful {get; set;} 
        @AuraEnabled
        public String PrivacyConcerns {get; set;}
        @AuraEnabled
        public String ReceivedManyEmails {get; set;}
        @AuraEnabled
        public String RegCustmerNotAssctd {get; set;}
        
        public String Response {get; set;}
        
    }
    
    
    
    @AuraEnabled
    public List<PortalDeactivationReasonLinkUrl> getDeactivationReason(){
        
         List<PortalDeactivationReasonLinkUrl> portalDeactionReason = new List<PortalDeactivationReasonLinkUrl>();
        
        List<CXE_PortalDeactivation_Reason__mdt> retrieveRecords =[SELECT Different_Email__c, Move_Out_Address__c,No_Active_Sin__c,No_Longer_Use__c,
                                                                   Portal_Difficult__c,Portal_Unuseful__c,Privacy_Concerns__c,Received_Many_Emails__c,
                                                                   RegCustmer_Not_Assctd__c
                                                                   FROM CXE_PortalDeactivation_Reason__mdt];
                 
        for(CXE_PortalDeactivation_Reason__mdt pdreasonRec: retrieveRecords){
            PortalDeactivationReasonLinkUrl pdrlu = new PortalDeactivationReasonLinkUrl();
                pdrlu.DifferentEmail = pdreasonRec.Different_Email__c;        
                pdrlu.MoveOutAddress = pdreasonRec.Move_Out_Address__c;
                pdrlu.NoActiveSin = pdreasonRec.No_Active_Sin__c;          
                pdrlu.NoLongerUse = pdreasonRec.No_Longer_Use__c;          
                pdrlu.PortalDifficult = pdreasonRec.Portal_Difficult__c;           
                pdrlu.PortalUnuseful = pdreasonRec.Portal_Unuseful__c;           
                pdrlu.PrivacyConcerns = pdreasonRec.Privacy_Concerns__c;          
                pdrlu.ReceivedManyEmails = pdreasonRec.Received_Many_Emails__c;         
                pdrlu.RegCustmerNotAssctd  = pdreasonRec.RegCustmer_Not_Assctd__c;

                portalDeactionReason.add(pdrlu);
            
        }

        return portalDeactionReason;

    }
    
    
    @AuraEnabled
    public static String PortalAccountDeactivated(String relatedArticle){
        
        PortalDeactivationReasonLinkUrl req = new PortalDeactivationReasonLinkUrl();
        List<User> portalUser = [SELECT CXE_CP_isPortalDeactivated__c FROM User WHERE Id=:UserInfo.getUserId()];
        portalUser[0].CXE_CP_isPortalDeactivated__c =true;
        portalUser[0].UserArticleSelected__c =relatedArticle;
        
        try{
            update portalUser[0];
            req.Response ='successfull';  
        }catch(DMLException ex){
            
            req.Response =String.valueOf(ex);
            ErrorHandlerException.recordException(null, true, 'CXE_CP_MyProfileCTRL', 'execute', ex.getMessage());
        }
        
        return  req.Response ;  
    }
    
   


}