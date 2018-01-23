public without sharing class CXE_CP_ConglomerateTableCtrl {
    //10-12-17 for conglomerate -SHAYNE 
    public class ConglomerateData {
        @AuraEnabled
        public String accountName;
        @AuraEnabled
        public integer totalServices;
        @AuraEnabled
        public List<CXE_Heroku_Model.ConglomerateDisplay> conglomerateRecords;
        //START CSM-14073 Shayne 10/26/17 
        @AuraEnabled
        public CXE_Heroku_Model.ConglomerateDisplay totalRecord;
        //END CSM-14073 Shayne 10/26/17 
        
    }
    
	@AuraEnabled
    public static ConglomerateData retrieveConglomerateDetails(String account_id){
        System.debug('retrieveConglomerateDetails');
        try{
            List<CXE_Heroku_Model.ConglomerateDetail> congloDetails = CXE_HerokuApps.conglomerate(account_id);            
            ConglomerateData congloDisplay = conglomerateDisplay(congloDetails, account_id);
            System.debug('retrieveConglomerateDetails size: ' + congloDetails.size());
            return congloDisplay;
        }
        catch(CXE_HerokuApps.HerokuException hx){
            System.debug('retrieveConglomerateDetails error');
            //if(hx.asJson() != null) return hx.asJson();
            throw hx;
        }
        
    }
    
     public static ConglomerateData conglomerateDisplay(
         List<CXE_Heroku_Model.ConglomerateDetail> congloDetails, String userAccountId){   
        System.debug('CXE_CP_ConglomerateDashboardCtlr conglomerateDisplay START');
         List<String> account_id = new List<String>();
             String accountName = '';
         List<CXE_Heroku_Model.ConglomerateDisplay> congloDisplay = new List<CXE_Heroku_Model.ConglomerateDisplay>();
         List<CXE_Heroku_Model.ConglomerateDisplay> returnDisplay = new List<CXE_Heroku_Model.ConglomerateDisplay>();
             CXE_Heroku_Model.ConglomerateDisplay total = new CXE_Heroku_Model.ConglomerateDisplay();
        
        //START CSM-14726 Shayne 11/28/2017 Moved to try-catch block
        try{
            System.debug('congloDetails '+congloDetails.size());            
             for(CXE_Heroku_Model.ConglomerateDetail conglomerate : congloDetails){
                 account_id.add(conglomerate.account_id);
                 CXE_Heroku_Model.ConglomerateDisplay display = new CXE_Heroku_Model.ConglomerateDisplay();
                 account_id.add(conglomerate.account_id);
                 display.account_id = conglomerate.account_id;
                 display.sin = (conglomerate.total_sin == null) ? conglomerate.direct_sin : conglomerate.total_sin;
                 display.kwh = (conglomerate.total_kwh == null) ? conglomerate.direct_kwh : conglomerate.total_kwh;
                 display.bill_demand = (conglomerate.total_bill_demand == null) ? conglomerate.direct_bill_demand : conglomerate.total_bill_demand;
                 display.prev_bal = (conglomerate.total_prev_bal == null) ? conglomerate.direct_prev_bal : conglomerate.total_prev_bal;
                 display.bill_amt = (conglomerate.total_bill_amt == null) ? conglomerate.direct_bill_amt : conglomerate.total_bill_amt;
                 display.pay_amt = (conglomerate.total_pay_amt == null) ? conglomerate.direct_pay_amt : conglomerate.total_pay_amt;
                 display.pending_amt = (conglomerate.total_pending_amt == null) ? conglomerate.direct_pending_amt : conglomerate.total_pending_amt;

                 total.sin += display.sin;
                 total.kwh += display.kwh;
                 total.bill_demand += display.bill_demand;
                 total.prev_bal += display.prev_bal;
                 total.bill_amt += display.bill_amt;
                 total.pay_amt += display.pay_amt;
                 total.pending_amt += display.pending_amt;
                 congloDisplay.add(display);
             }
			 accountName = [select Name from Account where id = :userAccountId].Name;
             System.debug('conglomerateDisplay account_id list '+account_id);
             List<Account> account_names = [select id,Account_ID__c, Name from Account where id IN :account_id];
             Map<String, String> accountMap = new Map<String, String>();
             integer ctr=0;
             integer acc_size = account_names.size();
             System.debug('account_names '+account_names.size());
             while(ctr < acc_size){
                 accountMap.put(account_names[ctr].id, account_names[ctr++].Name);
             }
             for(CXE_Heroku_Model.ConglomerateDisplay conglomerate : congloDisplay){
                conglomerate.name = accountMap.get(conglomerate.account_id);
                returnDisplay.add(conglomerate);
             }

              }catch(Exception e){
                System.debug('>>>>>>>>>conglomerateDisplay '+e);
             }
             //END CSM-14726 Shayne 11/28/2017
             
             System.debug('display '+returnDisplay.size());
              ConglomerateData congloData = new ConglomerateData();             
             if(!returnDisplay.isEmpty()) congloData.totalRecord = total; //CSM-14073 Shayne 10/26/17 
             congloData.conglomerateRecords = returnDisplay;
             congloData.totalServices = total.sin;
             congloData.accountName = accountName;
             return congloData;
     }
}