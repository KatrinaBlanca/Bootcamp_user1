@isTest
public class CommunitiesTemplateController_Test {
    
    @isTest static void forwardToHomePage_Test(){
        
        Test.startTest();
        
        PageReference pageRef = Page.CommunitiesTemplate;
        
        CommunitiesTemplateController ctrl = new CommunitiesTemplateController();
        pageRef =ctrl.forwardToHomePage();
        
        System.assert(pageRef !=null);
        
        Test.stopTest();

    }
   
	

}