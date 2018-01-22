public with sharing class CXE_HerokuApps {

    

    public class HerokuException extends Exception {
        public HerokuException(HttpResponse res){
            this.setMessage(res.getBody());
        }
        
        public Map<String, Object> asJson(){
            
            try{
                Map<String, Object> err = (Map<String, Object>) JSON.deserializeUntyped(this.getMessage());    
                err.put('error_source', 'payment_gateway');
                
                return err;
            }
            catch(Exception ex){
                return null;
            }
        }
    } 
    
    public static List<CXE_Heroku_Model.BillDetail> parseBillRecords(String jsonRes){
        List<CXE_Heroku_Model.BillDetail> bills = new List<CXE_Heroku_Model.BillDetail>();
        
        JSONParser parser = JSON.createParser(jsonRes);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {                    
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        CXE_Heroku_Model.BillDetail bill = (CXE_Heroku_Model.BillDetail)parser.readValueAs(CXE_Heroku_Model.BillDetail.class);
                        bills.add(bill);
                    }
                }
            }
        }
        return bills;
    }
    
    // START CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017
    public static List<CXE_Heroku_Model.BillDetail> getAllBillsByAcctNoAndSinNo(String sinStr, String acctNo){
        List<CXE_Heroku_Model.BillDetail> bills = new List<CXE_Heroku_Model.BillDetail>();        
        String response = CXE_HerokuApps.getBills(new List<String>{acctNo}, new List<String>{sinStr}, 'All','All');
        bills = parseBillRecords(response);
        return bills;                
    }
    // END CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017

    public static List<CXE_Heroku_Model.BillDetail> getAllBillsBySingleAcctNo(String acctNo){
        List<CXE_Heroku_Model.BillDetail> bills = new List<CXE_Heroku_Model.BillDetail>();        
        String response = CXE_HerokuApps.getBills(new List<String>{acctNo}, null, 'All','All');
        bills = parseBillRecords(response);
        return bills;                
    }
    
    public static List<CXE_Heroku_Model.BillDetail> getAllBillsBySingleSin(String sinStr){
        List<CXE_Heroku_Model.BillDetail> bills = new List<CXE_Heroku_Model.BillDetail>();
        String response = CXE_HerokuApps.getBills(null, new List<String>{sinStr}, 'All','All');
        bills = parseBillRecords(response);
        return bills;                
    }
    
    public static List<CXE_Heroku_Model.BillDetail> getAllBillsBySinNos(List<String> sinNos){
        List<CXE_Heroku_Model.BillDetail> bills = new List<CXE_Heroku_Model.BillDetail>();
        String response = CXE_HerokuApps.getBills(null, sinNos, 'All','All');
        bills = parseBillRecords(response);
        return bills;                
    }
    
    //START CSM-14404
    public static List<CXE_Heroku_Model.BillDetail> getFilteredBillsBySinNos(List<String> sinNos, String billType, String billStatus){
        List<CXE_Heroku_Model.BillDetail> bills = new List<CXE_Heroku_Model.BillDetail>();
        String response = CXE_HerokuApps.getBills(null, sinNos, billType, billStatus);
        bills = parseBillRecords(response);
        return bills;                
    }
    //END CSM-14404
    
    //Start Emandolado get all unpaid bills
    
    public static List<CXE_Heroku_Model.BillDetail> getAllUnpaidBillsBySingleSin(String sinStr){
        List<CXE_Heroku_Model.BillDetail> bills = new List<CXE_Heroku_Model.BillDetail>();
        String response = CXE_HerokuApps.getBills(null, new List<String>{sinStr}, 'All','Unpaid');
        bills = parseBillRecords(response);
        return bills;                
    }
    
    public static List<CXE_Heroku_Model.BillDetail> getAllUnpadBillsBySingleAcctNo(String acctNo){
        List<CXE_Heroku_Model.BillDetail> bills = new List<CXE_Heroku_Model.BillDetail>();        
        String response = CXE_HerokuApps.getBills(new List<String>{acctNo}, null, 'All','Unpaid');
        bills = parseBillRecords(response);
        return bills;                
    }
    
    public static List<CXE_Heroku_Model.BillDetail> getAllUnpadBillsByAcctNo(List<String> acctNo){
        List<CXE_Heroku_Model.BillDetail> bills = new List<CXE_Heroku_Model.BillDetail>();        
        String response = CXE_HerokuApps.getBills(acctNo, null, 'All','Unpaid');
        bills = parseBillRecords(response);
        return bills;                
    }
    
    
    public static List<CXE_Heroku_Model.BillDetail> getAllBillsBySingleInvoiceNo(String invoiceNo){
        List<CXE_Heroku_Model.BillDetail> bills = new List<CXE_Heroku_Model.BillDetail>();        
        String response = CXE_HerokuApps.getBillsbyInvoice(new List<String>{invoiceNo});
        bills = parseBillRecords(response);
        return bills;                
    }
    
    
    private static String getBillsbyInvoice(List<String> accountNos) {
        
        String endPointParams;
        
        if(accountNos!=null && !accountNos.isEmpty()){
            String accNos = '';
            for(String str : accountNos){
                if(String.isNotEmpty(accNos)){
                    accNos = accNos + ',' + str;
                }
                else{
                    accNos = str;
                }
            }
            endPointParams =  accNos;
        }
        
        
        Map<String, String> body = new Map<String, String>();
        
        Http h = new Http();
        HttpRequest req = CXE_HerokuApps.tokenize();
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        //req.setEndpoint(OrganizationSettings__c.getOrgDefaults().HerukoEndpointGetBills__c + '?session='+UserInfo.getOrganizationId().left(15)+'!' + endPointParams);
        //START CSM-14422 RReyes NOV-13-17
        req.setEndpoint(OrganizationSettings__c.getOrgDefaults().HerukoEndpointGetBillsByInvoice__c + endPointParams);
        System.debug('>>>>>>>>>>>>>>>>>>> '+OrganizationSettings__c.getOrgDefaults().HerukoEndpointGetBillsByInvoice__c + endPointParams);
        //END CSM-14422 RReyes NOV-13-17
        
        if(!Test.isRunningTest()){
            //HttpResponse res = h.send(req).getBody();
            return h.send(req).getBody();
        }
        else{
            StaticResource sr = [ select Body from StaticResource where Name = 'HerokuBillsTest' ];
            return sr.Body.toString();
        }    
    } 
    
    //End Emandolado get all unpaid bills 
    
    private static String getBills(List<String> accountNos, List<String> sinNos, String billType, String billStatus) {

        String endPointParams = '&BillType='+ billType + '&BillStatus=' + billStatus;

        if(accountNos!=null && !accountNos.isEmpty()){
            String accNos = '';
            for(String str : accountNos){
                if(String.isNotEmpty(accNos)){
                    accNos = accNos + ',' + str;
                }
                else{
                    accNos = str;
                }
            }
            endPointParams = endPointParams + '&AccountNumber='+accNos;
        }

        if(sinNos!=null && !sinNos.isEmpty()){
            String sins = '';
            for(String str : sinNos){
                if(String.isNotEmpty(sins)){
                    sins = sins + ',' + str;
                }
                else{
                    sins = str;
                }
            }
            endPointParams = endPointParams + '&ServiceNumber='+sins;
        }
        //START CSM-10961 RReyes AUG-15-17 - remove filter since system should show unpaid bills regardless of date
        //endPointParams = endPointParams + '&BillingInvoiceStartDate='+String.valueOf(Date.today().addMonths(-13));
        //END CSM-10961 RReyes AUG-15-17 - remove filter since system should show unpaid bills regardless of date

        Map<String, String> body = new Map<String, String>();

        Http h = new Http();
        HttpRequest req = CXE_HerokuApps.tokenize();
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setEndpoint(OrganizationSettings__c.getOrgDefaults().HerukoEndpointGetBills__c + '?session='+UserInfo.getOrganizationId().left(15)+'!' + endPointParams);
System.debug('>>>>>>>>>>>>>>>>>>> '+OrganizationSettings__c.getOrgDefaults().HerukoEndpointGetBills__c + '?session='+UserInfo.getOrganizationId().left(15)+'!' + endPointParams);
        

        if(!Test.isRunningTest()){
              //HttpResponse res = h.send(req).getBody();
              return h.send(req).getBody();
        }
        else{
            StaticResource sr = [ select Body from StaticResource where Name = 'HerokuBillsTest' ];
            return sr.Body.toString();
        }    
    } 






    public static List<CXE_Heroku_Model.PaymentDetail> parsePaymentRecords(String jsonRes){
        List<CXE_Heroku_Model.PaymentDetail> payments = new List<CXE_Heroku_Model.PaymentDetail>();

        JSONParser parser = JSON.createParser(jsonRes);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        CXE_Heroku_Model.PaymentDetail payment = (CXE_Heroku_Model.PaymentDetail)parser.readValueAs(CXE_Heroku_Model.PaymentDetail.class);
                        payments.add(payment);
                    }
                }
            }
        }
        return payments;
    }
    
    public static List<CXE_Heroku_Model.PaymentDetail> getAllPaymentsByRefNo(String referenceNum){
        List<CXE_Heroku_Model.PaymentDetail> payments = new List<CXE_Heroku_Model.PaymentDetail>();
        //String response = CXE_HerokuApps.getPayments(null, referenceNum, null);//CSM-12517 
        String response = CXE_HerokuApps.getPayments(null, referenceNum, null,null);//CSM-12570 
        payments = parsePaymentRecords(response);
        return payments;                
    }
  
    // CSM-12592 GGrandea changed date params to start & end date
    public static List<CXE_Heroku_Model.PaymentDetail> getAllPaymentsBySingleAcctNo(String acctNo, Date startDate, Date endDate){
        List<CXE_Heroku_Model.PaymentDetail> payments = new List<CXE_Heroku_Model.PaymentDetail>();
        //String response = CXE_HerokuApps.getPayments(new List<String>{acctNo}, null, payDate );//CSM-12517 
        String response = CXE_HerokuApps.getPayments(new List<String>{acctNo}, null, startDate, endDate);//CSM-12570 //CSM-12592 
        payments = parsePaymentRecords(response);
        return payments;                
    }   
  
    public static List<CXE_Heroku_Model.PaymentDetail> getAllPaymentsByAccountNos(List<String> accountNos , Date startDate , Date endDate){
        List<CXE_Heroku_Model.PaymentDetail> payments = new List<CXE_Heroku_Model.PaymentDetail>();
        //String response = CXE_HerokuApps.getPayments(accountNos, null, null);//CSM-12517 //CSM-12570 (disabled)
        String response = CXE_HerokuApps.getPayments(accountNos, null, startDate, endDate);//CSM-12570 (added date params)
        payments = parsePaymentRecords(response);
        return payments;                
    }
    
    // CSM-12570 Emandolado 9/15/2017 (Added payDateEnd variable)
    // CSM-12517 Mike Verdad 09/14/2017 (Added payDate variable)
    private static String getPayments(List<String> accountNos, String referenceNumber, Date startDate, Date endDate) {
        String endPointParams = '';
        
       

        if(accountNos!=null && !accountNos.isEmpty()){
            String accNos = '';
            for(String str : accountNos){
                if(String.isNotEmpty(accNos)){
                    accNos = accNos + ',' + str;
                }
                else{
                    accNos = str;
                }
            }
            endPointParams = endPointParams + '&accountNumber='+accNos;
        }

        if(referenceNumber!=null && String.isNotEmpty(referenceNumber)){
            endPointParams = endPointParams + '&referenceNumber='+referenceNumber;
        }
        
        //*** START Emandolado CSM-12570 added condition
        // Start CSM-12517 Mike Verdad 09/14/2017
        // if(payDate!=null){
        if(startDate!=null){
            //String dateOutput = payDate.year() +'-'+ payDate.month() +'-'+ payDate.day(); //CSM-12570 disabled
            String dateOutput = startDate.year() +'-'+ startDate.month() +'-'+ startDate.day();
            endPointParams = endPointParams + '&startDate='+dateOutput;
        }
        // End CSM-12517 Mike Verdad 09/14/2017
        
        if(endDate != null){
            String dateOutputEnd = endDate.year() +'-'+ endDate.month() +'-'+ endDate.day();
            endPointParams = endPointParams + '&endDate='+dateOutputEnd;
        }
        //*** END CSM-12570 Emandolado 9/15/2017
        
        Map<String, String> body = new Map<String, String>();

        Http h = new Http();
        HttpRequest req = CXE_HerokuApps.tokenize();
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setEndpoint(OrganizationSettings__c.getOrgDefaults().HerukoEndpointGetPayments__c + '?session='+UserInfo.getOrganizationId().left(15)+'!' + endPointParams);
System.debug('>>>>>>>>>>>>>>>>>>> '+OrganizationSettings__c.getOrgDefaults().HerukoEndpointGetPayments__c + '?session='+UserInfo.getOrganizationId().left(15)+'!' + endPointParams);
        //START CSM-14738 RReyes NOV-29-17
        req.setTimeout(120000);
        //END CSM-14738 RReyes NOV-29-17
        if(!Test.isRunningTest()){
              return h.send(req).getBody();
        }
        else{
            StaticResource sr = [ select Body from StaticResource where Name = 'HerokuPaymentsTest' ];
            return sr.Body.toString();
        }    
    } 


    
    /* 
    * Description: CSM-13671 utility method to retrieve consumption by single SIN
    * Parameters: String sinStr
    * Returns: List<CXE_Heroku_Model.BillDetail>
    * Author: GGrandea (Accenture)
    * Date Created: OCT-12-2017
    */
    public static List<CXE_Heroku_Model.BillDetail> getAllConsumptionBySingleSin(String sinStr){
        String response = CXE_HerokuApps.getConsumptions(sinStr);
        List<CXE_Heroku_Model.BillDetail> bills = parseBillRecords(response);
        return bills;                
    }

    /* 
    * Description: CSM-13671 Consumption Endpoint 
    * Parameters: String sinNo
    * Returns: String response
    * Author: GGrandea (Accenture)
    * Date Created: OCT-12-2017
    */
    private static String getConsumptions(String sinNo) {

        String endPointParams = '&SIN='+ sinNo;

        Http h = new Http();
        HttpRequest req = CXE_HerokuApps.tokenize();
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setEndpoint(OrganizationSettings__c.getOrgDefaults().HerokuEndpointGetConsumption__c 
                                + '?session='+UserInfo.getOrganizationId().left(15)+'!' + endPointParams);        

        if(!Test.isRunningTest()){
              return h.send(req).getBody();
        }
        else{
            StaticResource sr = [ select Body from StaticResource where Name = 'HerokuBillsConsumptionTest' ];
            return sr.Body.toString();
        }    
    }

    //START CSM-11039 RReyes AUG-18-17 - PDF Vault - get pdf vault url
    public static String getPDFUrl(String action, String fileName) 
    {      
        fileName = (fileName == null) ? '' :  fileName.replace('|','%7c');
        action = (action == null) ? '' :  action;

        String endPointParams = '&action=' + action + '&fileName='+ fileName;
        Map<String, String> body = new Map<String, String>();

        Http h = new Http();
        HttpRequest req = CXE_HerokuApps.tokenize();
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setEndpoint(OrganizationSettings__c.getOrgDefaults().HerukoEndpointGetPDFUrl__c + '?session='+UserInfo.getSessionId() + endPointParams);
System.debug('>>>>>>>>>>>>>>>>>>> '+OrganizationSettings__c.getOrgDefaults().HerukoEndpointGetPDFUrl__c + '?session='+UserInfo.getSessionId() + endPointParams);
       

        if(!Test.isRunningTest()){
            return h.send(req).getBody();
        }
        else{
            StaticResource sr = [ select Body from StaticResource where Name = 'HerokuPDFVaultTest' ];
            return sr.Body.toString();
        }    
    }
    //END CSM-11039 RReyes AUG-18-17 - PDF Vault - get pdf vault url


    // sopon.s
    public static String presign(String name){
        return presign(name, 'PDF', null);
    }

    // sopon.s [CSM-14267] merge with R2B
    public static String upload_sign(String type, String key){

        HttpRequest req = CXE_HerokuApps.tokenize(
            OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'upload'
        );
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(new Map<String, String>{
            'type' => type
            , 'key' => key
        }));

        if(!Test.isRunningTest()){
            Http h = new Http();
            
            HttpResponse res = h.send(req);
            return res.getBody();
        }
        else{
            return null;
        }
    }

    //START CSM-13109/CSM-13154 RReyes OCT-26-17| NOV-08-17
    public static String apa_upload_sign(String documentName){
        
        //sopon.s [CSM-14267] merge with R2B
        return upload_signv2('APA', documentName);
        /*// sopon.s [CSM-14267] merge with R2B
        HttpRequest req = CXE_HerokuApps.tokenize(
            OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'apa/' + documentName);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        if(!Test.isRunningTest()){
            Http h = new Http();
            
            HttpResponse res = h.send(req);
            return res.getBody();
        }
        else{
            return null;
        }
        // sopon.s [CSM-14267] merge with R2B ===== */
    }
    
    // sopon.s [CSM-14267] merge with R2B
    public static String upload_signv2(String type, String key){

        HttpRequest req = CXE_HerokuApps.tokenize(
            OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'upload'
        );
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(new Map<String, String>{
            'type' => type
            , 'key' => key
        }));

        if(!Test.isRunningTest()){
            Http h = new Http();
            
            HttpResponse res = h.send(req);
            return res.getBody();
        }
        else{
            return null;
        }
    }
    //END CSM-13109/CSM-13154 RReyes OCT-26-17| NOV-08-17
    
    //START CSM-13169 RReyes NOV-09-17
    public static String apa_zip_sign(String key, String target, String jobCode){
        
        HttpRequest req = CXE_HerokuApps.tokenize(
            OrganizationSettings__c.getOrgDefaults().PDF_Vault_URL__c + 'zip/start'
        );

        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(new Map<String, String>{
            'key' => key,
            'target' => target
            , 'jobCode' => jobCode
        }));
        
        if(!Test.isRunningTest()){
            Http h = new Http();
            HttpResponse res = h.send(req);
            //START CSM-14388 RReyes NOV-10-17
            if(res.getStatusCode() != 200){
                ErrorHandlerException.recordException(null, true, 'CXE_HerokuApps', 'apa_zip_sign', 'Status Code: ' + res.getStatusCode());
            }
            //END CSM-14388 RReyes NOV-10-17

            return res.getBody();
        }

        return '';
    }
    //END CSM-13169 RReyes NOV-09-17

    //START CSM-13174 RReyes NOV-09-17
    public static String apa_delete(String folderName){
        
        HttpRequest req = CXE_HerokuApps.tokenize(
            OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'apa/' + folderName
        );

        req.setMethod('DELETE');
        req.setHeader('Content-Type', 'application/json');
        
        if(!Test.isRunningTest()){
            Http h = new Http();
            HttpResponse res = h.send(req);

            return res.getBody();
        }

        return '';
    }
    //END CSM-13174 RReyes NOV-09-17

    public static String presign(String key, String type, String name){
        List<String> args = new List<String>();
        args.add('session=' + UserInfo.getOrganizationId() + '!' + EncodingUtil.urlEncode(CXE_Utility.getSecureToken(), 'UTF-8'));
        args.add('type='+ type);

        if(name != null && name != ''){
            args.add('name=' + EncodingUtil.URLENCODE(name, 'UTF-8'));
        }
        
        HttpRequest req = CXE_HerokuApps.tokenize(
            OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'sign/' + EncodingUtil.URLENCODE(key, 'UTF-8') + '?' + String.join(args, '&')
        );
        req.setMethod('GET');

        Http h = new Http(); //CSM-13922
        
        if(!Test.isRunningTest()){
            //START CSM-13922 GGrandea 10.17.2017
            /*Http h = new Http();
            
            HttpResponse res = h.send(req);
            //res.getHeader("Location")
            //if(res.getStatusCode() == 200){
                return res.getBody();*/
            return h.send(req).getBody();
            //END CSM-13922 GGrandea 10.17.2017
            //}
            //else{
            //    throw new HerokuException(res.getStatus());
            //}
        }
        else{
            StaticResource sr = [ select Body from StaticResource where Name = 'HerokuPDFVaultTest' ];
            return sr.Body.toString();
        } 
    }

    // sopon.s [CSM-14267] merge with R2B
    public static String download_sign(String type, String key, String name){
                
        HttpRequest req = CXE_HerokuApps.tokenize(
            OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'download'
        );
        
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(new Map<String, String>{
            'type' => type
            , 'key' => key
            , 'name' => name
        }));
        
        if(!Test.isRunningTest()){
            Http h = new Http();
            HttpResponse res = h.send(req);

            return res.getBody();
        }

        return '';
    }
    
    public static String dms_sign(String aid, String oid, String name){

        List<DMS_Document__c> found = [select Id from DMS_Document__c where Id = :oid];
        if(found == null || found.size() != 1) return null;

        HttpRequest req = CXE_HerokuApps.tokenize(
            OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'dms/' + EncodingUtil.URLENCODE(aid + '|' + oid, 'UTF-8')
        );
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(String.join(new String[]{
            'name=' + EncodingUtil.URLENCODE(name, 'UTF-8')
        }, '&'));

        Http h = new Http(); //CSM-13922

        if(!Test.isRunningTest()){
            //START CSM-13922 GGrandea 10.17.2017
            /*Http h = new Http();
            HttpResponse res = h.send(req);
            
            //if(res.getStatusCode() == 200){

            return res.getBody();*/
            return h.send(req).getBody();
            //END CSM-13922 GGrandea 10.17.2017
            // TODO:
            // res.getHeader("Location")
        }

        return '';
    }

    public static String pdf_sign(String key, String name){

        HttpRequest req = CXE_HerokuApps.tokenize(
            OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'pdf/' + EncodingUtil.URLENCODE(key, 'UTF-8')
        );
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(String.join(new String[]{
            'name=' + EncodingUtil.URLENCODE(name, 'UTF-8')
            , 'account_no=' + String.join(CXE_Utility.my_account_number(), ',')
        }, '&'));

        Http h = new Http(); //CSM-13922

        if(!Test.isRunningTest()){
            //START CSM-13922 GGrandea 10.17.2017
            /*Http h = new Http();
            HttpResponse res = h.send(req);
            
            //if(res.getStatusCode() == 200){

            return res.getBody();*/
            return h.send(req).getBody();
            //END CSM-13922 GGrandea 10.17.2017
            // TODO:
            // res.getHeader("Location")
        }

        return '';
    }

    public static String pdf_stat(String name){        
        HttpRequest req = CXE_HerokuApps.tokenize();
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded'); 

        String session = UserInfo.getSessionId();
        if(session.contains('REMOVED'))
            session = UserInfo.getOrganizationId() + '!a';
        
        req.setEndpoint(OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'stat/' + name + '?session='+session);

        Http h = new Http(); //CSM-13922
        
        if(!Test.isRunningTest()){            
            //Http h = new Http();
            return h.send(req).getBody();
        }
        else{
            return '';
        }  
    }

    public static String test_connection(String url){
        HttpRequest req = CXE_HerokuApps.tokenize();
        req.setMethod('GET');
        req.setEndpoint(url);

        Http h = new Http(); //CSM-13922

        if(!Test.isRunningTest()){
            //Http h = new Http(); //CSM-13922
            return h.send(req).getBody();
        }

        return '';
    }

    public static HttpRequest tokenize(){
        HttpRequest req = new HttpRequest();
        
        req.setHeader('Authorization', OrganizationSettings__c.getOrgDefaults().Heroku_Basic_Auth__c);


        return req;
    }

    public static HttpRequest tokenize(String url){
        HttpRequest req = tokenize();
        req.setEndpoint(url);

        System.debug('TOKENIZE - ' + url);

        return req;
    }

    public static String community_token(){
        return CXE_Utility.aes128(
            JSON.serialize(new CXE_HerokuApps.Community_User())
            , UserInfo.getOrganizationId().left(15) + '!'
        );
        
    }

    private class Community_User{
        public String user_id{get; set;}
        public String[] account_number{get; set;}
        public Datetime created {get; private set;}

        public Community_User(){
            this.user_id = UserInfo.getUserId();
            this.account_number = CXE_Utility.my_account_number();
            this.created = DateTime.now();
        }
    }
    
    public static String convenienceFee(String amount){
        system.debug('convenienceFee APEX CLASS');
        HttpRequest req = CXE_HerokuApps.tokenize();
        
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'payment/fee');
        
        Map<String, String> data = new Map<String, String>{
            'amount' => amount
        };
                    
        //req.setBody(CXE_Utility.form_data(data));
        req.setBody(JSON.serialize(data));
        
        if(!Test.isRunningTest()){
            HttpResponse res = (new Http()).send(req);
            
            if(res.getStatusCode() == 200){
                return res.getBody();
            }
            else {
                throw new HerokuException(res.getBody());
            }
        }
        
        return null;
    }
    
    // Start R3A CSM-14884 Von Pernicia 1/4/17: Added origin parameter
    public static String cc_pay(String token, String amount, String fee, String total, String fname,String emailPass ,String paymentMode ,String paymentOffice,String address,List<Object> paymentTransaction, String origin){
    // End R3A CSM-14884 Von Pernicia 1/4/17: Added origin parameter
        HttpRequest req = CXE_HerokuApps.tokenize();
        
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'payment/create');
        
		//START CSM-14620 R3A JRances
        String userProfile = [SELECT Id, Username, Profile.Name FROM USER WHERE Username =: UserInfo.getUserName()].Profile.Name; 
        String successURL;
        String failureURL;
        
        // Start R3A CSM-14884 Von Pernicia 1/4/17
        if (origin == CXE_Constants.PAYMENT_ORIGIN_MOBILE) {
            if(userProfile == CXE_Constants.PORTAL_GUEST_PROFILE){
                successURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/customers/s/mobilepayasguestsuccess';
                failureURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/customers/s/mobilepayasguestfail';
            } else {
                emailPass = UserInfo.getUserEmail();
                successURL = URL.getSalesforceBaseUrl().toExternalForm() + '/customers/s/mobilemybillssuccess';
                failureURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/customers/s/mobilemybillsfail';
            }
        } else {
            if(userProfile == CXE_Constants.PORTAL_GUEST_PROFILE){
                successURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/customers/s/payasguestsuccess';
                failureURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/customers/s/payasguestfail';
            } else {
                emailPass = UserInfo.getUserEmail();
                successURL = URL.getSalesforceBaseUrl().toExternalForm() + '/customers/s/mybillssucess';
                failureURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/customers/s/mybillsfail';
            }
        }
        // End R3A CSM-14884 Von Pernicia 1/4/17
        /*
        if(userProfile == 'MERALCO Customer Portal' || userProfile == 'Conglomerate Portal User'){
            emailPass = UserInfo.getUserEmail();
            successURL = URL.getSalesforceBaseUrl().toExternalForm() + '/customers/s/mybillssucess';
            failureURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/customers/s/mybillsfail';
        } else {
            successURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/customers/s/payasguestsuccess';
            failureURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/customers/s/payasguestfail';
        }
		*/
        //END CSM-14620 R3A JRances
        
        /*
        
        if(emailPass == null){
            emailPass = UserInfo.getUserEmail();
            successURL = URL.getSalesforceBaseUrl().toExternalForm() + '/customers/s/mybillssucess';
            failureURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/customers/s/mybillsfail';
        }*/
        
		
       //String sample = JSON.serialize(paymentTransaction);
        
        /*Map<String, String> data = new Map<String, String>{
            'token' => token
, 'amount' => amount
, 'fee' => fee
, 'total' => total
, 'fname' => fname
, 'mname' => mname
, 'lname' => lname
, 'invoices' => invoice
, 'addr_line1' => '9F Robinsons Cybergate 3'
, 'addr_line2' => 'Pioneer Street'
, 'addr_city' => 'Mandaluyong City'
, 'addr_state' => 'Metro Manila'
, 'addr_zip' => '12345'
, 'addr_country_code' => 'PH'
, 'callback' => 'https://meralco--r2cdev--c.cs6.visual.force.com/apex/CXE_CC_Complete'
, 'user_id' => UserInfo.getUserId()
, 'email' => emailPass
            'paymentToken' => token
                ,'billAmount' => amount
                ,'convenienceFee' => fee
                ,'totalAmount' => total
                ,'userId' => UserInfo.getUserId()
                ,'emailAddress' => emailPass
                ,'paymentMode' => paymentMode
                ,'paymentOffice' => paymentOffice
                ,'buyerName' => fname
                ,'billingAddress' => address
                ,'successURL' => 'https://meralco--r2cdev--c.cs6.visual.force.com/apex/CXE_CC_Complete'
                ,'failureURL' => 'https://meralco--r2cdev--c.cs6.visual.force.com/apex/CXE_CC_Complete'
                ,'cancelURL' => 'https://meralco--r2cdev--c.cs6.visual.force.com/apex/CXE_CC_Complete'
                ,'payment_transaction ' =>  JSON.Parse(paymentTransaction);
                };*/
        
                JSONGenerator data = JSON.createGenerator(false);
                data.writeStartObject();  
                data.writeStringField('paymentToken',token);
                data.writeStringField('billAmount',amount);
                data.writeStringField('convenienceFee',fee);
                data.writeStringField('totalAmount',total);
                data.writeStringField('userId',UserInfo.getUserId());
                data.writeStringField('emailAddress',emailPass);
                data.writeStringField('paymentMode',paymentMode);
                data.writeStringField('paymentOffice',paymentOffice);
                data.writeStringField('buyerName',fname);
                data.writeStringField('billingAddress',address);
                data.writeStringField('successURL', successURL);
                data.writeStringField('failureURL', failureURL);
                data.writeStringField('cancelURL', 'https://meralco--r2cdev--c.cs6.visual.force.com/apex/CXE_CC_Complete');
                data.writeObjectField('transaction_item', paymentTransaction);
                    
                
                
                data.writeEndObject();
        
                    
                    //req.setBody(CXE_Utility.form_data(data));
                    system.debug('returnJson' + data.getAsString());
            
                    //req.setBody(JSON.serialize(data));
                    req.setBody(data.getAsString());
                    system.debug('bodybody' + req.getBody());
        
        if(!Test.isRunningTest()){
            HttpResponse res = (new Http()).send(req);
            if(res.getStatusCode() == 200){
                system.debug('returned data' + res.getBody());
                return res.getBody();
            }
            else {
                throw new HerokuException(res.getBody());
            }
        }
        
        return null;
    }
    
    public static Map<String, Object> check_invoice(String invoice_id){
        HttpRequest req = CXE_HerokuApps.tokenize();
        req.setEndpoint(OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'invoice/check?id=' + invoice_id);
        
        if(!Test.isRunningTest()){
            HttpResponse res = (new Http()).send(req);
            if(res.getStatusCode() == 200){
                return (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            }
            else {
                throw new HerokuException(res.getBody());
            }
        }
        
        return null;
    }
    
    //START R2C CSM-13269 SHAYNE
    public static List<CXE_Heroku_Model.ConglomerateDetail> conglomerate(String account_id){
        System.debug('heroku conglomerate');
        HttpRequest req = CXE_HerokuApps.tokenize();    
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(OrganizationSettings__c.getOrgDefaults().Heroku_Url__c + 'conglomerate/viewRecord?accountId=' +account_id);
        
        if(!Test.isRunningTest()){
            HttpResponse res = (new Http()).send(req);
            
            if(res.getStatusCode() == 200){
                System.debug('heroku conglomerate '+res.getBody());
                //return res.getBody();
                List<CXE_Heroku_Model.ConglomerateDetail> congloParse = parseHerokuRecords(res.getBody());                
                return congloParse;
            }
            else {
                System.debug('heroku conglomerate ERROR');
                throw new HerokuException(res.getBody());
            }
        }
        return null;
    }
    
    
    public static List<CXE_Heroku_Model.ConglomerateDetail> parseHerokuRecords(String jsonRes){
        System.debug('parseHerokuRecords');
        List<CXE_Heroku_Model.ConglomerateDetail> conglomerates = new List<CXE_Heroku_Model.ConglomerateDetail>();
        
        JSONParser parser = JSON.createParser(jsonRes);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {                    
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        CXE_Heroku_Model.ConglomerateDetail bill = (CXE_Heroku_Model.ConglomerateDetail)parser.readValueAs(CXE_Heroku_Model.ConglomerateDetail.class);
                        conglomerates.add(bill);
                    }
                }
            }
        }
        System.debug('parseHerokuRecords size: '+conglomerates.size());
        return conglomerates;
    }
    //END R2C CSM-13269 SHAYNE
    
    // Start R3A CSM-14741 Von Pernicia
    public static List<CXE_Heroku_Model.PaymentDetail> getPaymentbyBillId(String billdId){
        List<CXE_Heroku_Model.PaymentDetail> payments = new List<CXE_Heroku_Model.PaymentDetail>();
        
        String response = CXE_HerokuApps.paymentbyBillId(billdId);
        payments = parsePaymentRecords(response);
        return payments;                
    }  

    private static String paymentbyBillId(String billdId) {
        
        Map<String, String> body = new Map<String, String>();

        Http h = new Http();
        HttpRequest req = CXE_HerokuApps.tokenize();
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        //req.setEndpoint(OrganizationSettings__c.getOrgDefaults().HerukoEndpointGetPayments__c + '?billid='+billdId);
        req.setEndpoint(OrganizationSettings__c.getOrgDefaults().HerukoEndpointPaymentbyBillId__c+billdId);


        if(!Test.isRunningTest()){
              return h.send(req).getBody();
        }
        else{
            StaticResource sr = [ select Body from StaticResource where Name = 'HerokuPaymentsTest' ];
            return sr.Body.toString();
        }    
    }
    // End R3A CSM-14741 Von Pernicia 
}