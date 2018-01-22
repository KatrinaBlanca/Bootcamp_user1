@RestResource(urlMapping='/processPayment')
global with sharing class CXE_BS_Payment  {

    @HttpGet
    global static void load(){
        Map<String, String> params = RestContext.request.params;

        // Start R3A CSM-14741 Von Pernicia
        CXE_Json.response(
            //CXE_HerokuApps.getAllPaymentsByRefNo(params.get('ref'))
            //CXE_HerokuApps.getAllBillsBySingleInvoiceNo(params.get('ref'))
            //CXE_HerokuApps.getAllPaymentsBySingleAcctNo(params.get('ref'), null, null)
            CXE_HerokuApps.getPaymentbyBillId(params.get('billid'))
        );
        // End R3A CSM-14741 Von Pernicia
    }

    @HttpPost
    // Start R3A CSM-14884/CSM-15068 Von Pernicia 1/4/17: Added origin parameter
    global static void pay(String token, String amount, String fee, String total, String fname,String email , String payment_mode, String payment_office, String address, List<CXE_Json.PaymentDetail> payment_transaction, String origin){
        RestContext.response.addHeader('Content-Type', 'application/json');
        Map<String, String> params = RestContext.request.params;

        system.debug(payment_transaction);

        try{
            CXE_Json.response((Map<String, Object>) JSON.deserializeUntyped(
                CXE_HerokuApps.cc_pay(token, amount, fee, total, fname, email, payment_mode, payment_office, address, payment_transaction, origin)
            ));    
        }
        catch(CXE_HerokuApps.HerokuException hx){
            if(hx.asJson() != null) CXE_Json.response(hx.asJson());
            else throw hx;
        }
    }
    // End R3A CSM-14884/CSM-15068 Von Pernicia 1/4/17: Added origin parameter
}