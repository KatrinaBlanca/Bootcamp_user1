@RestResource(urlMapping='/ReportOutage/*')
global with sharing class Myu_ReportOutageClass {
@HttpPost
  global static sfdcresponse doPost(String accountId,String TypeOfPowerOutage,String NeighboursPowerAvailability,String AdditionalOutageInfo){
      sfdcresponse resp = new sfdcresponse();
      try{
          if(accountId <> NULL){
              recordtype rt = [select id,developername from recordtype where sobjecttype='case' and developername='Report_an_Outage'];  
              case cs = new case();
              cs.subject = 'Experiencing an Outage';
              cs.Origin = 'MyU app';
              cs.recordtypeid = rt.Id;
              cs.accountId= accountId;
              cs.Type_Of_Power_Outage__c = TypeOfPowerOutage;
              cs.Neighbour_s_Power_Availability__c = NeighboursPowerAvailability;
              cs.Additional_Outage_Information__c = AdditionalOutageInfo;
              insert cs;
              resp.status = 'success';
              resp.caseId = cs.Id;             
          }
          return resp;
      }
      catch(exception e){
          resp.error = e.getMessage();
          resp.status = 'fail';
          return resp;
      }
      

  }

  
  global class sfdcresponse{
      public string status{get;set;}
      public string error{get;set;}
      public string caseId{get;set;}            
  }
}