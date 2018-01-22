@RestResource(urlMapping='/GetMyAccount/*')
global with sharing class Myu_GetMyAccountDetails{
@HttpGet
  global static sfdcresponse doGet(){
     sfdcresponse resp = new sfdcresponse();
     try{ 
          RestRequest req = RestContext.request;
          Id accId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
          system.debug('*************'+accId);
          //Id accId = RestContext.request.params.get('Id');
          List<Account> acc = new List<Account>();
          List<Contract> contrList = new List<Contract>();
          Set<String> payMethods = new Set<String>();
 
          if(accId <> null){
              acc = [select id,PersonEmail,PersonMobilePhone,PersonHomePhone from account where id = :accId limit 1];
              contrList = [SELECT Id,Method_of_Payment__c FROM  Contract where accountId = :accId ];
              if(acc.size() > 0){
                  resp.EmailAddress = acc[0].personEmail;
                  resp.TelephoneNumber= acc[0].PersonHomePhone;
                  resp.MobileTelephone = acc[0].PersonMobilePhone;
                  resp.accountId = string.valueOf(acc[0].Id);
                  resp.status = 'success'; 
                  resp.error = '';
                  if(contrList.size() > 0){
                      for(contract ctr:contrList)  {
                          if(ctr.Method_of_Payment__c  <> null){
                              payMethods.add(ctr.Method_of_Payment__c);    
                          }
                      }  
                      if(payMethods.size() > 0){
                          string str='';
                          for(string st:payMethods){
                              str = str+st+';';
                          }
                          resp.PaymentMethod = str;        
                      } 
                      else{
                          resp.PaymentMethod = '';    
                      }                   
                  } 
                  else{
                      resp.PaymentMethod = '';    
                  }                 
              } 
              else{
                  resp.error = 'no account record matched in SFDC'; 
                  resp.status = 'fail';    
              } 
               return resp; 
          }
         resp.error = 'id is blank';
         resp.status = 'fail';
         return resp; 
      }
      catch(exception e){
          resp.error = e.getMessage();
          resp.status = 'fail';
          return resp;  
      }
      

  }
  
  global class sfdcresponse{
      public string PaymentMethod{get;set;}  
      public string status{get;set;}
      public string error{get;set;}
      public string accountId{get;set;} 
      public string EmailAddress{get;set;}  
      public string TelephoneNumber{get;set;} 
      public string MobileTelephone{get;set;}                       
  }
}