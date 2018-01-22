global with sharing class Heroku {

    private static string endpoint = 'https://ss-m-p.herokuapp.com/';

    public Heroku() {
        
    }

    @RemoteAction
    global static String history(String args){
        return Heroku.json('bill/history', args);
    }

    @RemoteAction
    global static String invoice(String args){
        return Heroku.json('bill/list', args);
    }

    @RemoteAction
    global static String search(String args){
        return Heroku.json('bill/search', args);
    }


    public static String json(String title, String args) {

        //return 'mock';

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded'); 
        req.setEndpoint(endpoint + title + '.json');
        
        if(!String.isEmpty(args)){
            req.setBody(args);
            req.setMethod('POST');
        }
        else{
            req.setMethod('GET');
        }

        if(!Test.isRunningTest()){
            HttpResponse res = h.send(req);
            return res.getBody();
        }
        else{
            return 'test';  
        }       
    }
}