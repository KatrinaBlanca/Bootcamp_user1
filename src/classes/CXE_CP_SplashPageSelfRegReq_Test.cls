@isTest
public class CXE_CP_SplashPageSelfRegReq_Test{
    
    
    @isTest
    static void CXE_CP_SplashPageSelfRegistration_Req_Test(){
        Test.startTest();
        
        CXE_CP_SplashPageSelfRegistration_Req spr = new CXE_CP_SplashPageSelfRegistration_Req();
        spr.isNew = False;
        spr.email ='mctest@yahoo.com';
        spr.firstname = 'fname';
        spr.middle ='middle';
        spr.lastname ='lastname';
        spr.suffix ='suffix';
        spr.mobileNumber ='+639176917469';
        spr.amount = 23.00;
        spr.transactionDate = Date.today();
        spr.SIN ='123456789123';
        
        System.assert(spr !=null);
        Test.stopTest();
           
    }     
       
}