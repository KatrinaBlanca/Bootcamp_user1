@RestResource(urlMapping='/GetUserDetails/*')
    global with sharing class Myu_GetUserDetailsREST 
    {
        @HttpGet
        global static GetUserDetailsResponse doGet() 
        {
            String username = RestContext.request.params.get('username');
            String password = RestContext.request.params.get('password');
            GetUserDetailsResponse gudr = new GetUserDetailsResponse();
            //username and password is not blank            
            if(username <> null && password <> null){  
                List<Account> accs = new List<Account>();
                accs = [SELECT Id,LastName, FirstName,UserName__pc,Password__pc FROM Account  WHERE UserName__pc = :username AND Password__pc = :password LIMIT 1];
                if(accs.isEmpty())  // credentials are not matched in sfdc
                {
                    gudr.errorMessage = 'There is no account for the user name and password supplied'  + username + ' ' + password;
                    return gudr;  
                }
                else  // credentials are met in sfdc
                {
                    system.debug('^^^^^^^^^^^'+accs[0].Id);
                    gudr.accountId = accs[0].Id;
                    gudr.username = accs[0].UserName__pc;
                    gudr.password = accs[0].Password__pc ;
                    gudr.FirstName = accs[0].Firstname;
                    gudr.LastName= accs[0].Lastname; 
                    gudr.FullName = accs[0].Firstname + accs[0].Lastname;                               
                    return gudr;
                }
            }
            else{    //username or password is blank
                    gudr.errorMessage = 'username or password cannot be blank';
                    return gudr;                 
            }
               
         }
    
   
    global class GetUserDetailsResponse
    {
        public String accountId {get;set;}
        public String FullName {get;set;}
        public String errorMessage {get;set;}   
        public string username{get;set;}
        public string password{get;set;}
        public String FirstName{get;set;}
        public String LastName{get;set;}               
        
    }
}