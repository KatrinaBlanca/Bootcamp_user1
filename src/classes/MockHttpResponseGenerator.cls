@isTest

global class MockHttpResponseGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {

        //System.assertEquals('http://api.salesforce.com/g-recaptcha-response/{"success":true}', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"success":true}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;

    }

}