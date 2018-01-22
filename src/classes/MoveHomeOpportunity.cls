public class MoveHomeOpportunity {
    
     //public id caseid ;
     //public case Thiscase{get;set;}
     //public opportunity opp{get;set;}
     
    public MoveHomeOpportunity(ApexPages.StandardController controller) {
    //caseid= ApexPages.currentPage().getParameters().get('caseid');
    //Thiscase=[select id,accountid,account.name,Description,NEW_Bank_Name__c,NEW_Terms_of_Payment__c,New_Payment_Day__c,NEW_IBAN__c from case where id=:caseid];
    //opp=new opportunity();

    
    }
   
   //public void SaveOpportunity()
   //{
   //if (Test.isrunningtest()) { 
   // Agreement__c contractid2=[select Contract__c from Agreement__c where case__c=:caseid][0];
   // system.assertequals(contractid2, null); system.assertequals(1, 2); 
   // }
   //    id contractid=[select Contract__c from Agreement__c where case__c=:caseid][0].Contract__c;
   //    boolean condition;
   //     for(Agreement__c Agrement:[select contract__c from Agreement__c where case__c=:caseid])
   //        {
   //             if(Agrement.contract__C==contractid)
   //             {
   //                 condition=true;
   //             }
   //             else 
   //             {
   //                 condition=false;
   //                 break;
   //             }
   //        }
   //        contract contract=[select id ,Bank_Name__c,IBAN__c,Method_of_Payment__c,Payment_Day__c,Terms_of_Payment__c from contract where id = :contractid];
           
   //         if(condition)
   //         {
   //             opp.name=thiscase.account.name +' '+ system.today().day()+'-'+ system.today().month()+'-'+ system.today().year();
   //             opp.accountid=thiscase.accountid;
   //             opp.closedate=system.today().adddays(30);
   //             opp.Description=thiscase.Description;
   //             opp.type='Retention Business';
   //             opp.Bank_Name__c=contract.Bank_Name__c;
   //             opp.Method_of_Payment__c=contract.Method_of_Payment__c;
   //             opp.Payment_Day__c=contract.Payment_Day__c;
   //             opp.Terms_of_Payment__c=contract.Terms_of_Payment__c ;
   //             opp.IBAN__c=contract.IBAN__c;
   //             opp.stagename='Proposal/Price Quote';
   //         }
   //         else
   //         {
   //             opp.name=thiscase.account.name +' '+ system.today().day()+'-'+ system.today().month()+'-'+ system.today().year();
   //             opp.accountid=thiscase.accountid;
   //             opp.closedate=system.today().adddays(30);
   //             opp.Description=thiscase.Description;
   //             opp.type='Retention Business';
   //             opp.stagename='Proposal/Price Quote';
   //         }
   //         insert opp;
            
   //         map<id,id> productToPricebookentrymap=new map<id,id>();            
   //         list<opportunitylineitem> opplineitems=new list<opportunityLineItem>();
   //         list<id> productids=new list<id>();
            
   //         for(Agreement__c Agrements:[select Case__c,Account__c,Agreement_End_Date__c,
   //                                        Agreement_Start_Date__c,Commercial_Product__c from Agreement__c where case__c=:caseid])
   //        {
   //         productids.add(agrements.Commercial_Product__c );
   //        }
           
   //        for(pricebookentry pbe:[select id,product2id from pricebookentry where product2id in :productids ])
   //        {
   //          productToPricebookentrymap.put(pbe.product2id,pbe.id);
   //          system.debug('Product to Pricebook map' + productToPricebookentrymap);
   //        }
           
   //        for(Agreement__c activeAgrements:[select Case__c,Account__c,Agreement_End_Date__c,Contract__c,
   //                                        Agreement_Start_Date__c,Commercial_Product__c from Agreement__c where case__c=:caseid])
   //        {
            
   //         if(productToPricebookentrymap.containskey(activeagrements.Commercial_Product__c))
   //         {
   //           opportunitylineitem oppline=new opportunityLineItem();
              
   //           oppline.pricebookentryid=productToPricebookentrymap.get(activeagrements.Commercial_Product__c);
   //           oppline.quantity=1;
   //           oppline.opportunityid=opp.id;
   //           system.debug('Opportunty Price' + oppline.TotalPrice);
   //           opplineitems.add(oppline);
   //          }
   //          else
   //          {
   //           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Contact administrator '));
   //          }
              
   //        }
            
   //   if(!opplineitems.isempty())
   //   insert opplineitems;
   //}

}