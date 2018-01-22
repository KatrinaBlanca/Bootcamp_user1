@isTest

global class MockBillPrintModeService implements HttpCalloutMock {

    private String accountNo;
    private String response;
    private Integer statusCode;
    private String status;
    private String description;
    private Boolean isMultiple;

    global MockBillPrintModeService(Boolean isMulti, String acctNo, String resp, Integer statCode, String statString, String descString){
        this.accountNo = acctNo;
        this.response = resp;
        this.statusCode = statCode;
        this.status = statString;
        this.description = descString;
        this.isMultiple = isMulti;
    }

    global HTTPResponse respond(HTTPRequest req) {
        
        String responseBody;

        if(isMultiple){
            responseBody ='{"BillPrintModeUpdateResponse":{"bpmResponseList":{"bpmResponseItem":{"description":"'+description
                                    +'","idPaymentForm":"'+accountNo
                                    +'","response":"'+response+'"},{"description":"'+description
                                    +'","idPaymentForm":"'+accountNo
                                    +'","response":"'+response+'"}}}}';
        }else{
            responseBody ='{"BillPrintModeUpdateResponse":{"bpmResponseList":{"bpmResponseItem":{"description":"'+description
                                    +'","idPaymentForm":"'+accountNo
                                    +'","response":"'+response+'"}}}}';
        }


        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(responseBody);
        res.setStatusCode(statusCode);
        res.setStatus(status);
        return res;

    }

}