public class AccountTriggerClass
{
   public list<opportunity> accountAcceptance(list<account> accounts)
   {
       list<opportunity> updatingOpportunities=new list<opportunity>();       
      for(Opportunity opp:[select id , stagename,accountid,account.Customer_Accepted__c from opportunity where accountid in :accounts])
      {
         if(opp.account.Customer_Accepted__c=='Rejected')
         {
              if(opp.stagename!='Closed Lost')
              {
                opp.stagename='closed lost';
               updatingOpportunities.add(opp);  
              }   
          }       
      }
      if(!updatingOpportunities.isempty())
        update updatingOpportunities;  
        
        return  updatingOpportunities;
   }
}