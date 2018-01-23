Public Class TestSoapRequest
{
  /*
    Public String makehttprequestnow()
    {
        String xml = '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><env:Header /><env:Body><ArpuAdvanceAmountServiceUpdateAdvanceAmountRequest xmlns="http://tempuri.org"><connections><Connection xmlns="http://schemas.datacontract.org/2004/07/Dynamics.Ax.Application"><AdvanceAmount>10.01</AdvanceAmount><AmountBased>Total</AmountBased><ConnectionId>DEM-0000000037</ConnectionId><Split>EqualSplit</Split></Connection></connections></ArpuAdvanceAmountServiceUpdateAdvanceAmountRequest></env:Body></env:Envelope>';
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        //req.setHeader('SOAPAction','ProcessRequest');
        req.setHeader('Accept-Encoding','gzip,deflate');
        req.setHeader('Content-Type','text/xml;charset=UTF-8');
        System.Debug(xml);
        req.setBody(xml);
        req.setEndpoint('http://144.36.167.58/ARPUDev/MessageHandler.svc');
        string bodyRes = '';
        string ssourl='';
        HttpResponse res;
        try 
        {
            if(!Test.isRunningTest())
            {
                res = h.send(req);
                bodyRes = res.getBody();
                system.debug('response:' +bodyRes);
            }
        }
        catch(System.CalloutException e)
        {
            //SendExceptionEmail(e.getMessage(),'Salesforce Emptoris Connector CallOut Error:',errormail);
            System.Debug(e.getMessage());
        }
        return ssourl;
    }
    */
}