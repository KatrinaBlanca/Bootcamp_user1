public class AgilePointGateway {
//Commented out as not been used
/*
    // public static final String TEST_PROCESS_ID = '45030322AD24E51180F1120F4EBD31E7';
    public static final String TEST_PROCESS_ID = '397EB9EEF424E51180F1120F4EBD31E7';
    
    private static final String GET = 'GET';
    private static final String POST = 'POST';    
    
    private static final String USERNAME = 'nxone\\Paker';
    private static final String PASSWORD = 'd+6BH4w!3$';
    
    public static final String NEW_STATUS = 'New';
    public static final String ASSIGNED = 'Assigned';
    
    @future(callout=true)
    public static void createProcessInstanceForCase(Id caseId, String processId) {

        Case c = [select RecordType.Name, AccountId from Case where Id = :caseId limit 1][0];
        
        List<Map<String, String>> attributes = new List<Map<String, String>>();
        
        Map<String, String> accountIdAttribute = new Map<String, String>();
        accountIdAttribute.put('Name', 'AccountId');
        accountIdAttribute.put('Value', c.AccountId + '');
        attributes.add(accountIdAttribute);
  
        Map<String, String> caseIdAttribute = new Map<String, String>();
        caseIdAttribute.put('Name', 'CaseId');
        caseIdAttribute.put('Value', c.Id + '');
        attributes.add(caseIdAttribute);        
        
        Map<String, Object> m = new Map<String, Object>();
        m.put('ProcessID', processId);
        m.put('blnStartImmediately', 'true');
        m.put('ProcInstName', 'Case - ' + c.RecordType.Name + ' - ' + caseId);
        m.put('WorkObjID', caseId);
        m.put('ProcessInstID', caseId);
        m.put('Attributes', attributes);
        String s = JSON.serialize(m);
        
        String result = doCall('https://trialas1.nxone.com/AgilePointServer/Workflow/CreateProcInst', POST, s);
        
    }
    
    public static List<Map<String, String>> getWorkList(Id caseId, String status) {
        
        Map<String, String> m = new Map<String, String>();
    m.put('UserName', USERNAME);
    m.put('Status', status);        
        
        String result = doCall('https://trialas1.nxone.com/AgilePointServer/Workflow/GetWorkListByUserID', POST, JSON.serialize(m));
    
      List<Map<String, String>> workListJson = new List<Map<String, String>>();
        try {
           worklistJson = (List<Map<String, String>>)JSON.deserialize(result, List<Map<String, String>>.class);
        } catch (Exception e) {
            
        }
        
        List<Map<String, String>> worklistFilteredJson = new List<Map<String, String>>();
        
        for (Map<String, String> workItem: worklistJson) {
            if (workItem.get('WorkObjectID') == (caseId + '')) {
                worklistFilteredJson.add(workItem);
            }
        }
        
        return worklistFilteredJson;
    }
        
    public static String assignWorkItem(String id) {
       
        Map<String, String> m = new Map<String, String>();
    m.put('clientData', null);        
        
        String result = doCall('https://trialas1.nxone.com/AgilePointServer/Workflow/AssignWorkItem/' + id, POST, JSON.serialize(m));        
      return result;
    
    }
    
    private static String doCall(String uri, String method, String body) {
        
     HttpRequest req = new HttpRequest();
     req.setEndpoint(uri);
     req.setMethod(method);

     Blob headerValue = Blob.valueOf(USERNAME + ':' + PASSWORD);
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
     return res.getBody();
        
    }
    */
}