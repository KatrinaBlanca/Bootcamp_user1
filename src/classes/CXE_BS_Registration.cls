@RestResource(urlMapping='/register')
global without sharing class CXE_BS_Registration  {


    @HttpPost
    global static void post(String email, String fname, String mname, String lname, String suffix, String mobile, String sin, Decimal amount, string tdate, Boolean isnew) {
                                                                           
        CXE_Json.response(
            CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fname, mname, lname, suffix, mobile, sin, amount, tdate, isnew)
        );
    }


}