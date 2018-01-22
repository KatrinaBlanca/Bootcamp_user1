@RestResource(urlMapping='/PostAccountDetail/*')
global with sharing class Myu_PostAccountDetails {
@HttpPost
  global static sfdcresponse doPost(String accountId, String phone ,String email) 
  {
  system.debug('webservice is called ************');
      sfdcresponse resp = new sfdcresponse();
      try{
          List<Account> acc = new List<account>();
            if(accountId <> null){
                acc = [SELECT Id, PersonEmail, PersonMobilePhone,PersonHomePhone FROM Account  WHERE Id =: accountId LIMIT 1];
                if(acc.size() > 0){
                    if(phone <> null){
                        acc[0].PersonHomePhone = phone;
                    }
                    if(email <> null){
                        acc[0].PersonEmail = email;
                    }
                    update acc[0];
                    Account updAcc = [SELECT Id, PersonEmail, PersonHomePhone FROM Account  WHERE Id =: accountId LIMIT 1];
                    resp.status = 'successful update';
                    resp.accountId = accountId;
                    resp.telephonenumber = updAcc.PersonHomePhone ;
                    resp.emailaddress= updAcc.PersonEmail;                
                }
                else{
                    resp.error = 'no account record matched in SFDC';
                    resp.status = 'update failed';
                }
            }
            else{
                resp.error = 'accountId cannot be blank'; 
                resp.status = 'update failed';   
            }
            return resp;  
        }
        catch(exception e){
          resp.error = e.getMessage();
          resp.status = 'update failed';
          return resp;  
       }   
  }
 global class sfdcresponse{
      public string status{get;set;}
      public string error{get;set;}
      public string accountId{get;set;} 
      public string emailaddress{get;set;}  
      public string telephonenumber{get;set;} 
                     
  }  
}