/**
 * @author      Accenture IDC
 * @description Calculates the unit prices for 
 *              OpportunityLineItem or QuoteLineItem
 *              records if the related
 *              product is a Discount product.            
 */
public class DiscountProductUnitPriceCalculator
{
    //public static final String ONETIME = 'One-time';
    //public static final String PERCENTAGE = 'Percentage';
    //public static final String EUROKWH = 'Euro/kWh';
    //public static final String NONFINANCIAL = 'Non-financial';
    
    
    //// AJVK: I assume this line is changed to something that can actually be 
    //// deployed to another environment? 
    //public static final id Discountrecordtype='01228000000DMaV';
     
    
    //public void calculatediscprice(List<opportunitylineitem> olis)
    //{
    //    list<id> productids=new list<id>();
    //    list<id> opportunityids=new list<id>();
        
    //     for(opportunitylineitem oli:olis)
    //     {
    //        productids.add(oli.product2id);
    //        opportunityids.add(oli.opportunityid);
    //     }
    //      map<id,map<id,product2>> oliprotoprod=new map<id,map<id,product2>>();
    //      map<id,product2> prodidtoproductmap=new map<id,product2>([select id , master_product__c,recordtypeid,Discount_Type__c,Discount_Value__c
    //                                                       from product2 where id in :productids and recordtypeid=:Discountrecordtype ]);
    //      map<id,map<id,Master_Product_Discount__c >> discountProductMasterProductmap=new map<id,map<id,Master_Product_Discount__c >>();
    //      for(Master_Product_Discount__c MPD:[select id , Product__c,Master_Product__c 
    //                                  from Master_Product_Discount__c where product__C in :productids])
    //       {
    //          if(!discountProductMasterProductmap.containskey(MPD.product__c))
    //          discountProductMasterProductmap.put(mpd.product__C,new map<id,Master_Product_Discount__c>{MPD.Master_Product__c =>mpd});
    //          else
    //          discountProductMasterProductmap.get(mpd.product__C).put(mpd.Master_Product__c ,mpd);
                 
    //       }
    //           for(opportunitylineitem oli:olis)
    //         {
    //            if(prodidtoproductmap.containskey(oli.product2id))
    //            {
    //                if(!oliprotoprod.containskey(oli.opportunityid))
    //                  oliprotoprod.put(oli.opportunityid,new map<id,product2>{oli.product2id => prodidtoproductmap.get(oli.product2id)});
    //                  else if(!oliprotoprod.get(oli.opportunityid).containskey(oli.product2id))
    //                  oliprotoprod.get(oli.opportunityid).put(oli.product2id,prodidtoproductmap.get(oli.product2id));
    //             }
    //         }
    //       list<id> productsInOpportunity=new list<id>();
    //      for(opportunitylineitem oliItem:[select id ,product2id from opportunityLineItem where opportunityid in :opportunityids])
    //      {
    //         productsInOpportunity.add(oliitem.product2id);
    //      }
    //      map<id,product2> CommercialProdsInOPP=new map<id,product2>([select id , master_product__c,recordtypeid from product2
    //                                               where id in :productsInOpportunity and recordtypeid!=:Discountrecordtype]);  
    //      map<id,list<opportunityLineItem>> oliprodInopp=new map<id,list<opportunityLineItem>>();
    //     for(opportunitylineitem oliItem:[select id,product2id,opportunityid,eav__c,totalprice
    //                                     from opportunityLineItem where opportunityid  in :opportunityids])
    //      {
    //              if(CommercialProdsInOPP.containskey(oliItem.product2id))
    //            {
    //               if(!oliprodInopp.containskey(oliItem.opportunityid))
    //               {
    //                     list<opportunitylineitem> oplinelist=new list<opportunitylineitem>();
    //                     oplinelist.add(oliitem);
    //                      oliprodInopp.put(oliItem.opportunityid,oplinelist);
    //              }
    //              else 
    //                      oliprodInopp.get(oliItem.opportunityid).add(oliItem);    
    //            }
    //      }
          
    //      for(opportunitylineitem oli:olis)
    //     {
    //         system.debug('test ing     '+prodidtoproductmap.containskey(oli.product2id)
    //         +'       sdfsdfsdf    '+oliprodInOpp.containskey(oli.opportunityid));
    //           if(prodidtoproductmap.containskey(oli.product2id)&&oliprodInOpp.containskey(oli.opportunityid))
    //           {
    //           decimal total;
    //           system.debug(' inside loop   ');
    //              for(opportunityLineitem OppLineItem:oliprodInopp.get(oli.opportunityid))
    //              {
    //                if(discountProductMasterProductmap.get(oli.product2id).containskey(CommercialProdsInOPP.get(OppLineItem.product2id).master_product__c))
    //                {
                     
                         
    //                     If(prodidtoproductmap.get(oli.product2id).Discount_Type__c==PERCENTAGE)                      
    //                      total=((total==null)?0:total)-1*(((prodidtoproductmap.get(oli.product2id).Discount_Value__c==null)?0:prodidtoproductmap.get(oli.product2id).Discount_Value__c)*(OppLineItem.totalprice/100));
    //                     else if(prodidtoproductmap.get(oli.product2id).Discount_Type__c==EUROKWH)               
    //                      total=((total==null)?0:total)-1*(((prodidtoproductmap.get(oli.product2id).Discount_Value__c==null)?0:prodidtoproductmap.get(oli.product2id).Discount_Value__c)*((OppLineItem.EAV__c==null)?0:OppLineItem.EAV__c));
    //                     else if(prodidtoproductmap.get(oli.product2id).Discount_Type__c==NONFINANCIAL)                   
    //                      total=((total==null)?0:total)+0;
    //                 }
    //              }
    //              if(prodidtoproductmap.get(oli.product2id).Discount_Type__c==ONETIME)                     
    //                     total=((total==null)?0:total)-1*((prodidtoproductmap.get(oli.product2id).Discount_Value__c==null)?0:prodidtoproductmap.get(oli.product2id).Discount_Value__c);
    //              system.debug(' total   ' +total);
    //              oli.unitprice=total;
    //           }
             
    //     }
            
    //} 
}