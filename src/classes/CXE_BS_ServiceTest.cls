@isTest
public class CXE_BS_ServiceTest {
    
    
    static testmethod void testPost() {
        
        Test.startTest();
        
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        CXE_BS_Service.link('1096854311', 100.00, String.valueOf(system.today()), true);
        Test.stopTest();
        
        System.assertEquals(RestContext.response.headers.get('Content-Type'), 'application/json');
    }

     static testmethod void testGet() {
        
        Test.startTest();
        
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        CXE_BS_Service.mine();
        Test.stopTest();
        
        System.assertEquals(RestContext.response.headers.get('Content-Type'), 'application/json');
    }
}