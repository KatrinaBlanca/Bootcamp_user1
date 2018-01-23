@RestResource(urlMapping='/preference')
global with sharing class CXE_BS_Preference  {


    @HttpPost
    global static void post(String billing,
                               String payment,
                               String reminder,
                               String service,
                               String outage,
                               String promotion) {

        CXE_Json.text(CXE_CP_MyProfileTab2CTRL.updateContact(billing, payment, reminder, service, outage, promotion));

    }


}