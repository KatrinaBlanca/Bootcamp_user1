trigger BundlelineItem on Bundle_Line_Item__c (after insert,after update) {
   // list<product2> updatingproducts=new list<product2>();
   // list<id> bundleprodids=new list<id>();
   // set<id> originalprod=new set<id>();
   // for(Bundle_Line_Item__c bli:trigger.new)
   // {
   //  bundleprodids.add(bli.product__C);
   //  originalprod.add(bli.bundle__C);
   // }
   
   //map<id,product2> bundleproducts=new map<id,product2>([select id ,Master_Product_Type__c,Electiricity_Bundle__c,
   //                                        Gas_Bundle__c from product2 where id in:originalprod] );
   //map<id,product2> productsinbundle=new map<id,product2>([select id ,Master_Product_Type__c,Electiricity_Bundle__c,
   //                                        Gas_Bundle__c from product2 where id in  :bundleprodids] ); 
   // for(Bundle_Line_Item__c blis:trigger.new)
   // {
   //   if(productsinbundle.get(blis.product__C).Master_Product_Type__c=='Electricity'&&!bundleproducts.get(blis.bundle__C).Electiricity_Bundle__c)
   //   {
   //      bundleproducts.get(blis.bundle__C).Electiricity_Bundle__c=true;
   //       updatingproducts.add(bundleproducts.get(blis.bundle__C));
   //   }
   //   else if(productsinbundle.get(blis.product__C).Master_Product_Type__c=='Gas'&&!bundleproducts.get(blis.bundle__C).Gas_Bundle__c )
   //   {
   //       bundleproducts.get(blis.bundle__C).Gas_Bundle__c =true;
   //       updatingproducts.add(bundleproducts.get(blis.bundle__C));
   //   }
      
   //   update updatingProducts;
   // }
                                           
   
     
 }