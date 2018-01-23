public class SINValidatorController {

    public String sinList {get; set;}
    public String herokuResponse {get; set;}

    public SINValidatorController(){
    
    }
    
    public void validateSIN(){
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET');
        String url = 'https://cxe-qa.herokuapp.com/payment/search?session=00D0l0000000VbT!&accountNumber=12650339';
        req.setEndpoint(url);
        HTTPResponse resp = http.send(req);
        herokuResponse = resp.getBody();   
    }

}