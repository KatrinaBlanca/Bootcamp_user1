@RestResource(urlMapping='/getConvenienceFee')
global with sharing class CXE_BS_Fee  {

    @HttpGet
    global static void fee() {
        RestContext.response.addHeader('Content-Type', 'application/json');
        Map<String, String> params = RestContext.request.params;

        CXE_Json.response(CXE_CC.fee(params.get('amount')));

    }

}