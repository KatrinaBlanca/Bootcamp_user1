@IsTest 
public with sharing class MobileChangePwdController_Test {
    	
    @IsTest(SeeAllData=true) public static void testinit3() {
        // Instantiate a new controller with all parameters in the page
        MobileChangePwdController controller = new MobileChangePwdController();        
        System.assertEquals(controller.init(),null);                           
    }  
}