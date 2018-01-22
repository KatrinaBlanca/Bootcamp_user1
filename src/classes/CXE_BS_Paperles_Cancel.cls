@RestResource(urlMapping='/cancelPaperless')
global without sharing class CXE_BS_Paperles_Cancel  {

    @HttpPost
    global static void create(String account_no, String reason, String other) {

        CXE_Json.response(
            CXE_CP_PaperlessBillingUnSubscribe.insertCase(
                account_no
                , reason
                , other != null && other == 'true'
            )
        );
    }

}