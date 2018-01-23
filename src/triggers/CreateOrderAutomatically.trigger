trigger CreateOrderAutomatically on Opportunity (Before update,before insert)
{
    //if(trigger.isupdate)
    //{
    //List<String> opptylist = new List<String>();
    //List<Order> orderList = new List<Order>();
    //map<String,Order> orderMap = new map<String,Order>();
    //map<String,List<OpportunityLineItem>> nonComProd = new map<String,List<OpportunityLineItem>>();
    //List<OpportunityLineItem> comProd = new List<OpportunityLineItem>();
    //map<String,List<OpportunityLineItem>> mapOpptyProduct =new map<String,List<OpportunityLineItem>>();
    //List<OrderItem> orderLineList = new List<OrderItem>();
    //map<String,string> opptyAccountMap = new map<String,string>();
    //map<String,string> opptyPriceBookMap = new map<String,string>();
    //map<String,Account> accountAddressMap = new map<String,Account>();
    //for(Opportunity opp: Trigger.new){
    //    Opportunity oldMap = Trigger.oldMap.get(opp.id);
    //    if(opp.StageName != oldMap.StageName){
    //        if(opp.StageName == 'Closed Won' && oldMap.StageName!= 'Closed Won'){
    //            opptylist.add(opp.id);
    //            opptyAccountMap.put(opp.id,opp.Accountid);
    //            opptyPriceBookMap.put(opp.id,opp.Pricebook2Id);
    //        }
    //    }
    //}
    //List<Account> accList= [Select billingstreet,billingState,BillingPostalCode,BillingCountry,Billingcity from Account where id=: opptyAccountMap.Values()];
    //for(Account ac : accList){
    //    accountAddressMap.put(ac.id,ac);
    //}
    //if(!opptylist.isEmpty()){
    //    List<OpportunityLineItem> listOpptyProd = [select id,OpportunityId,Connection__c,PricebookEntryId,UnitPrice,Quantity,ProductCode from OpportunityLineItem where OpportunityId =:opptylist];
    //    for(OpportunityLineItem olt :listOpptyProd ){
    //        if(!mapOpptyProduct.containsKey(olt.OpportunityId)){
    //            mapOpptyProduct.put(olt.OpportunityId, new List<OpportunityLineItem>());
    //        }
    //        System.debug('mapOpptyProduct'+mapOpptyProduct);
    //        mapOpptyProduct.get(olt.OpportunityId).add(olt);
    //    }
    //    System.debug('mapOpptyProduct'+mapOpptyProduct);
    //    for(String st : mapOpptyProduct.keyset()){
    //        for(OpportunityLineItem olt : mapOpptyProduct.get(st)){
    //            system.debug('st'+st+'olt'+olt);
    //            system.debug('Connectionid:' +olt.connection__c);
    //            if(olt.Connection__c == null){
    //                if(!nonComProd.containsKey(st)){
    //                    nonComProd.put(st,new List<OpportunityLineItem>());
    //                }
    //                System.debug('nonComProd'+nonComProd);
    //                nonComProd.get(st).add(olt);
                    
    //            }
    //        }
    //    }
    //    for(String st:nonComProd.keyset()){
    //        Order ord= new Order();
    //        ord.Opportunityid = st;
    //        ord.EffectiveDate = System.today();
    //        ord.Status = 'Draft';
    //        ord.Accountid=opptyAccountMap.get(st);
    //        ord.Billingstreet = accountAddressMap.get(opptyAccountMap.get(st)).Billingstreet ;
    //        ord.Billingstate= accountAddressMap.get(opptyAccountMap.get(st)).Billingstate ;
    //        ord.BillingCountry= accountAddressMap.get(opptyAccountMap.get(st)).BillingCountry;
    //        ord.BillingPostalCode= accountAddressMap.get(opptyAccountMap.get(st)).BillingPostalCode;
    //        ord.BillingCity= accountAddressMap.get(opptyAccountMap.get(st)).Billingcity;
    //        ord.Pricebook2Id = opptyPriceBookMap.get(st);
    //        orderList.add(ord);
    //        orderMap.put(st,ord);
    //    }
    //    if(!orderList.isEmpty())
    //        insert orderList;
    //    for(String od:orderMap.keyset()){
    //        for(OpportunityLineItem olt : mapOpptyProduct.get(od)){
    //            OrderItem ol = new OrderItem();
    //            ol.Orderid = orderMap.get(od).id;
    //            ol.PricebookEntryId = olt.PricebookEntryId;
    //            ol.UnitPrice = olt.UnitPrice;
    //            ol.Quantity =olt.Quantity ;
    //            //ol.ProductCode = olt.ProductCode;
    //            orderLineList.add(ol);
    //        }
    //    }
    //    if(!orderLineList.isEmpty())
    //            insert orderLineList;   
    //}
    //}
    //if(trigger.isinsert)
    //{
    //    map<Id,Id> opptyAccountMap = new map<Id,Id>();
    //    map<Id,string> accmap = new map<Id,string>();
    //    //List<opportunity> opptoupdate = new List<opportunity>();
    //    for(Opportunity opp: Trigger.new)
    //    {
    //        opptyAccountMap.put(opp.id,opp.Accountid);            
    //    }
    //    system.debug('Opportunity and Account Ids:' +opptyAccountMap);
    //    List<Account> Accounts = [select Id,RecordTypeId from Account where Id in :opptyAccountMap.values()]; 
    //    for(account acc :Accounts)
    //    {
    //        accmap.put(acc.id,acc.RecordTypeId);
    //    }
    //    system.debug('Account Id to Recordtype map' +accmap);
    //    for(Opportunity opp: Trigger.new)
    //    {
    //        String rtname = accmap.get(opp.AccountId);
    //        system.debug('Record Type Name' +rtname);
    //        if(rtname == '01228000000DCy6AAG' || rtname == '01228000000EOwuAAG')
    //        {
    //            opp.RecordtypeId = '01228000000EOwG';
    //        }
    //        else
    //        {
    //            opp.RecordtypeId = '01228000000EOqN';    
    //        }
    //        //opptoupdate.add(opp);    
    //    }
    //    //update opptoupdate;    
    //}
}