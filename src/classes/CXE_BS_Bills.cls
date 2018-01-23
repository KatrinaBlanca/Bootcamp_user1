@RestResource(urlMapping='/bills')
global without sharing class CXE_BS_Bills  {

    @HttpGet
    global static void get() 
    {
        Map<String, String> params = RestContext.request.params;
        List<CXE_Heroku_Model.BillDtlWrapper> lstBillDtlWrapper = new List<CXE_Heroku_Model.BillDtlWrapper>();
        
        for(CXE_Heroku_Model.BillDetail billDtl : CXE_CP_MyBillsSummaryCtlr.retrieveBillingDetails(params.get('sin')))
            lstBillDtlWrapper.add(new CXE_Heroku_Model.BillDtlWrapper(billDtl ));
        
        CXE_Json.response(lstBillDtlWrapper);
    }

}