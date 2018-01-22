/* Author: Melvin Corbes
 * Date : 10-19-2017
 * 
 */ 

@isTest
public class CXE_CP_DeactivationCtrl_Test {
    
    @isTest
    private static void getDeactivationReason_Test() {
        
       
        
        List<CXE_CP_DeactivationCtrl.PortalDeactivationReasonLinkUrl> linksUrl;
           // CXE_CP_DeactivationCtrl.getDeactivationReason();
        Test.startTest();
        CXE_CP_DeactivationCtrl ctrl = new CXE_CP_DeactivationCtrl();
        linksUrl =ctrl.getDeactivationReason();
        
        Test.stopTest();
        
        System.assertEquals(1,linksUrl.size());
        
        
    }    
    
   
    @isTest
    private static void getRelatedArticles() {
        
       
        String PortalAccountDeactivated;
        Test.startTest();
        
        PortalAccountDeactivated = CXE_CP_DeactivationCtrl.PortalAccountDeactivated('relatedArticle');
        
        Test.stopTest();
        
        System.assertEquals('successfull',PortalAccountDeactivated);
            
    }    
    

}