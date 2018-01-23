@RestResource(urlMapping='/changePwd')
global with sharing class CXE_BS_Me  {

    global class response {
        // Start CSM-14504: Jayson Sarion 12/1/2017
        public String status {get; set;}
        public String errorMessage {get; set;}
        // End CSM-14504: Jayson Sarion 12/1/2017
    }

    @HttpPost
    global static void post(String pwd1, String pwd2, String old){
        // Start CSM-14504: Jayson Sarion 12/1/2017
        CXE_BS_Me.response res = new CXE_BS_Me.response();
        
        try{
            //Site.changePassword(pwd1, pwd2, old);
            PageReference pr = new PageReference(OrganizationSettings__c.getInstance().CP_URL__c + '/CXE_MobileChangePwd?pwd1=' + pwd1 + '&pwd2=' + pwd2 + '&old=' + old);
            String message = pr.getContent().toString();
            
            if(message.contains('ApexPages.Message')) {
                message = message.replaceAll('\\"', '&');
                
                Integer fi = message.indexOf('&') + 1;
                Integer li = message.lastIndexOf('&');
                
                message = message.substring(fi, li);
            }
            
            if(message.contains('Success')) {
                res.status = 'Success';
                CXE_JSON.response(res);
            }
            else {
                res.status = 'Failed';
                
                if(message.contains(CXE_Constants.CHANGE_PW_ERROR_1))
                    res.errorMessage = CXE_Constants.CHANGE_PW_NEW_ERROR_1;
                else if(message.contains(CXE_Constants.CHANGE_PW_ERROR_2))
                    res.errorMessage = CXE_Constants.CHANGE_PW_NEW_ERROR_2;
                else if(message.contains(CXE_Constants.CHANGE_PW_ERROR_3))
                    res.errorMessage = CXE_Constants.CHANGE_PW_NEW_ERROR_3;
                
                CXE_JSON.response(res);
            }
        }
        catch(Exception ex){
            res.errorMessage = ex.getMessage();
            CXE_JSON.response(res);
        }
        // End CSM-14504: Jayson Sarion 12/1/2017
    }
}