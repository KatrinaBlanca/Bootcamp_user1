@RestResource(urlMapping='/profile')
global with sharing class CXE_BS_Profile  {

    @HttpGet
    global static void get() {
        CXE_Json.response(CXE_CP_MyProfileCTRL.getProfileInfo());
    }

    @HttpPost
    global static void post(String mobile1, String mobile2, String phone, String bd, String email2, String salutation, String social_facebook, String social_twitter, String social_instagram, String social_google) {

        CXE_Json.response(
            //CXE_CP_MyProfileTab4CTRL.updateContact(mobile1, mobile2, phone, bd, email2, salutation, true, social_facebook, social_twitter, social_instagram, social_google)
            CXE_CP_MyProfileTab4CTRL.updateContact(mobile1, mobile2, phone, bd, email2, salutation, social_facebook, social_twitter, social_instagram, social_google)
        );

    }


}