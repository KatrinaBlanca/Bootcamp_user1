trigger updatepaymentdetails on Contract (after insert)
{
    //List<String> accids = new List<String>();
    //List<String> erpconids = new List<String>();
    //List<String> Conids = new List<String>();
    //Map<String,Date> conidstartdatemap = new map<string,Date>();
    //List<opportunitylineitem> olitoupdate = new List<opportunitylineitem>();
    //for(contract con:[select Id,StartDate,AccountId,ERP_Contract_Id__c from Contract where Id = :Trigger.new[0].id])
    //{
    //    accids.add(con.AccountId);
    //    conidstartdatemap.put(con.id,con.Startdate);
    //    erpconids.add(con.ERP_Contract_Id__c);
    //    Conids.add(con.id);
    //}
    //Account Acc = [select Id,ERPAccountID__c from Account where Id in :accids Limit 1];
    
    //Opportunity opp = [select Id from Opportunity where AccountId in :accids Limit 1];
    ////opp.Contract_ERP_ID__c =  erpconids[0];
    ////update opp;
    
    //List<OpportunityLineitem> oppli = [select Id, Contract_ERP_ID__c from Opportunitylineitem where Opportunityid = :opp.id and Connection__c != Null];
    //for(Opportunitylineitem oli: oppli)
    //{
    //    oli.Contract_ERP_ID__c = erpconids[0];
    //    oli.Account_Id__c = accids[0];
    //    oli.Contract_Id__c = Conids[0];
    //    oli.Account_ERP_Id__c = Acc.ERPAccountID__c;
    //    oli.Agreement_Start_Date__c = conidstartdatemap.get(oli.Contract_Id__c);
    //    olitoupdate.add(oli);
    //}
    //update olitoupdate;    
}