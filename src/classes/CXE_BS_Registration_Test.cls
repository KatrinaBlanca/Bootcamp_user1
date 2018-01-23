@isTest
public class CXE_BS_Registration_Test {
    
    
    @isTest static void testRegistration(){
        test.startTest();
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
       	CXE_BS_Registration.post('test@test.com', 'test', 'test', 'test', 'z', '098888888', '11111111', 111, '11/11/11', true);
        test.stopTest();
        System.assertEquals(RestContext.response.headers.get('Content-Type'), 'application/json');
    }
    
}