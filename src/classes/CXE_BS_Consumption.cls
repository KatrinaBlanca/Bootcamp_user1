@RestResource(urlMapping='/consumption')
global without sharing class CXE_BS_Consumption {
	public CXE_BS_Consumption() {}

    @HttpGet
    global static void get() 
    {
        Map<String, String> params = RestContext.request.params;
        List<CXE_Heroku_Model.BillDtlWrapper> lstBillDtlWrapper = new List<CXE_Heroku_Model.BillDtlWrapper>();
        
        for(CXE_Heroku_Model.BillDetail billDtl : CXE_HerokuApps.getAllConsumptionBySingleSin(params.get('sin')))
            lstBillDtlWrapper.add(new CXE_Heroku_Model.BillDtlWrapper(billDtl));
        
        CXE_Json.response(lstBillDtlWrapper);
    }
}