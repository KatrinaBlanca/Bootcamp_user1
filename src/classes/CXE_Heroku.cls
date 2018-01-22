public with sharing class CXE_Heroku {
/*  Start R2C CSM-14435 Von Pernicia 11-22-17
    @future(callout = true)
    public static void delete_from_s3(Map<Id, Id> dms_acc, String session) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
        req.setEndpoint(Label.CXE_Heroku_Endpoint + '/bucket?session=' + session);
        //req.setEndpoint('https://cxe-r2c-dev.herokuapp.com' + '/bucket?session=' + session);

        req.setBody(JSON.serialize(to15Chars(dms_acc)));
        req.setMethod('DELETE');

        system.debug('>>>>>delete req ' + req);

        if(!Test.isRunningTest()) {
            HttpResponse res = h.send(req);
            system.debug('>>>>>delete ' + res);
        }
    }
    @future(callout = true)
    public static void restore_from_s3(Map<Id, Id> dms_acc, String session) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
        req.setEndpoint(Label.CXE_Heroku_Endpoint + '/bucket?session=' + session);
        //req.setEndpoint('https://cxe-r2c-dev.herokuapp.com'+ '/bucket?session=' + session+ '?_HttpMethod=PATCH');
        //req.setEndpoint(Label.CXE_Heroku_Endpoint + '/bucket?session=' + session+ '_HttpMethod=PATCH');
        req.setBody(JSON.serialize(to15Chars(dms_acc)));
        req.setMethod('PATCH');
        //req.setMethod('POST');

        if(!Test.isRunningTest()) {
            HttpResponse res = h.send(req);
            //system.debug('>>>>> ' + res);
        }
    }
*/

    private static Map<String, String> to15Chars(Map<Id, Id> data){
        Map<String, String> result = new Map<String, String>();
        
        for(Id k : data.keySet()){
            result.put((k+'').substring(0, 15), (data.get(k)+'').substring(0, 15));
        }

        return result;
    }
    
    @future(callout = true)
    public static void dms_delete(Map<Id, Id> dms_acc) {
    
        for(Id docId : dms_acc.keySet()) {
            try{
                HttpRequest req = CXE_HerokuApps.tokenize(
                    OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'bucket/'
                );
        
                req.setMethod('DELETE');
                req.setBody(JSON.serialize(to15Chars(dms_acc)));
                req.setHeader('Content-Type', 'application/json');
                
                 if(!Test.isRunningTest()){
                    system.debug('>>>>> delete req ' + req);
                    Http h = new Http();
                    HttpResponse res = h.send(req);
                    system.debug('>>>>> delete res ' + res);
                }
            }catch(Exception e){
                ErrorHandlerException.recordException(null, true, 'CXE_Heroku', 'dmsDelete', e.getMessage());
            }
        }
    }
    //End R2C CSM-14435 Von Pernicia 11-22-17
}