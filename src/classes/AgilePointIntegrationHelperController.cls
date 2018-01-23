public class AgilePointIntegrationHelperController {
/*
    private static final String GET = 'GET';
    private static final String POST = 'POST';
    
    public String username {get; set;}
    public String password {get; set;}
    public String processId {get; set;}
    public String result {get; set;}
    public String eventId {get; set;}
    public String processInstanceName {get; set;}
    public String workObjectId {get; set;}
    public String processInstanceId {get; set;}
    
    public AgilePointIntegrationHelperController() {
        username = 'nxone\\AJ';
        password = 'bX$84}iB';
        processId = 'DD85F2C5D61FE51180F1120F4EBD31E7';
        workObjectId = '1234567890';
        processInstanceName = 'TEST123';
    }
    
    private PageReference doCall(String uri, String method, String body) {
        
     HttpRequest req = new HttpRequest();
     req.setEndpoint(uri);
     req.setMethod(method);

     Blob headerValue = Blob.valueOf(username + ':' + password);
     String authorizationHeader = 'Basic ' +
     EncodingUtil.base64Encode(headerValue);
     req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');  
    
        if (method == POST) {
            req.setHeader('Content-Length', body.length() + '');
            req.setBody(body);
        }

        Http http = new Http();
     HTTPResponse res = http.send(req);
     result = res.getBody();
        
        return null;   
    }
    
    public PageReference getReleasedProcessDefinitions() {
        return doCall('https://trialas1.nxone.com/AgilePointServer/Workflow/GetReleasedProcDefs', GET, null);
    }
    
    public PageReference getProcessDefinitions() {
        return doCall('https://trialas1.nxone.com/AgilePointServer/Workflow/GetProcDefs', GET, null);   
    }
    
    public PageReference getProcessDefinitionGraphics() {
        String uri = 'https://trialas1.nxone.com/AgilePointServer/Workflow/GetProcDefGraphics/' + processInstanceId;
        return doCall(uri, GET, null);
    }

    public PageReference getActivityInstancesByProcessInstanceID() {
        String uri = 'https://trialas1.nxone.com/AgilePointServer/Workflow/GetActivityInstsByPIID/' + processInstanceId;
        return doCall(uri, GET, null);
    }
    
    public PageReference createProcessInstance() {
        String uri = 'https://trialas1.nxone.com/AgilePointServer/Workflow/CreateProcInst';
        
        Map<String, String> m = new Map<String, String>();
        m.put('ProcessID', processId);
        m.put('blnStartImmediately', 'true');
        m.put('ProcInstName', processInstanceName);
        m.put('WorkObjID', workObjectId);
        String s = JSON.serialize(m);
        
        return doCall(uri, POST, s);

  
      // postData.put("ProcessID", "D91BE666F2044DDEAF5BD202FBBE2467");
      // postData.put("ProcessInstID", "P91BE666F2044DDEAF5BD202FBBE2467");
      // postData.put("ProcInstName", "Process Map Approval - ");
      // postData.put("WorkObjID", "MN1BE666F2044DDEAF5BD202FBBE2467");
      // postData.put("WorkObjInfo", "");
      // postData.put("SuperProcInstID", "");
      // postData.put("Initiator", "demo3\\andy");
      // postData.put("CustomID", "MN1BE666F2044DDEAF5BD202FBBE2467");
      // postData.put("Attributes", "");
       // postData.put("blnStartImmediately", "true");
      // return ops.POSTMethod(URI, postData.toString());        
        
    }
    
    public PageReference getEvent() {
        String uri = 'https://trialas1.nxone.com/AgilePointServer/Workflow/GetEvent/' + eventId;
        return doCall(uri, GET, null);
    }
    */
}