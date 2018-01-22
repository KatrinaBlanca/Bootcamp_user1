/**  
* @author       : Accenture IDC  
* @date         : 17/07/2015  
* @description  : Utility Class for creating test data for Test Classes  
*/ 
Public class Util_TestMethod
{
  /*
    // Constants
    private static final String USR_TMP_EMAIL = 'us.name@vmail.com';
    private static final String ENCODE_KEY = 'UTF-8';
    private static final String TIME_ZONE = 'America/Los_Angeles';
    private static final String LOCALE_KEY = 'en_US';
    private static final String USER_POSTFIX = '@testorg.com';
    
     /**
      * @description       This method creates test user for unit testing                           
      * @param             String      lastName     
      * @param             Id      profileId     
      * @return            User              Returns the user object
      * @throws            NA
      */
      
    /*
    public static User createUser(String lastName,Id profileId,Id roleId){
        User usr = new User(alias = lastName, email= USR_TMP_EMAIL,
                            emailencodingkey= ENCODE_KEY, lastname = lastName,
                            timezonesidkey=TIME_ZONE,
                            languagelocalekey=LOCALE_KEY,
                            localesidkey= LOCALE_KEY, profileid = profileId,
                            UserRoleId= roleId,
                            username= lastName + System.currentTimeMillis() + USER_POSTFIX);
        return usr;
    }
    /**   
      * @description       This method creates test data for Account
      * @param             NA                 
      * @return            Account     
      * @throws            NA      
      */
   /*
   Public static Account createAccount(String AccountName)
   {
   Account acc=new Account();
      acc.name=AccountName;
      insert acc;
      return acc;
   }
   /**   
      * @description       This method creates test data for Opportunity
      * @param             NA                 
      * @return            Opportunity    
      * @throws            NA      
      *//*
   public static Opportunity createOpportunity(id Accountid,String OpportunityName,Date closedate,String StageName,Id PricebookId)
   {
   opportunity opp=new opportunity();
      opp.accountid=Accountid;
      opp.name=OpportunityName;
      opp.closedate=closedate;
      opp.stagename=StageName;
      opp.pricebook2id=PricebookId;
      insert opp;
      return opp;
   }
   
   /**   
      * @description       This method creates test data for OpportunityLineItem
      * @param             NA                 
      * @return            OpportunityLineItem
      * @throws            NA      
      *//*
   Public Static OpportunityLineItem createOpportunityLineItem(id OpportunityId,id PricebookentryId,Integer Quantity,Decimal TotalPrice )
   {
   OpportunityLineItem OLI=new OpportunityLineItem();
      OLI.OpportunityId=OpportunityId;
      OLI.pricebookentryid=PricebookentryId;
      OLI.Quantity=Quantity;
      OLI.TotalPrice=TotalPrice ;
      insert OLI;
      return OLI;
   }
   
   /**   
      * @description       This method creates test data for Quote
      * @param             NA                 
      * @return            Quote
      * @throws            NA      
      *//*
   Public Static Quote createQuote(id OpportunityId,id AccountId,String Name)
   {
   Quote Q=new Quote();
      Q.OpportunityId=OpportunityId;
      Q.Name=Name;
      //Q.Status=Status;
      insert Q;
      return Q;
   }
   
   /**   
      * @description       This method creates test data for Master Product
      * @param             NA                 
      * @return            MAster Product
      * @throws            NA      
      *//*
   Public Static Master_Product__c createMasterProduct(string Name)
   {
   Master_Product__c MasProd=new Master_Product__c();
      MasProd.Name=Name;
      insert MasProd;
      return MasProd;
   }
   
   /**   
      * @description       This method creates test data for Product Item
      * @param             NA                 
      * @return            Product Item
      * @throws            NA      
      *//*
   Public Static Product_Item__c createProductItem(string Name,String Valuetype,Id MasterProduct,Boolean Mandatory)
   {
   Product_Item__c Proditem=new Product_Item__c();
      Proditem.Name=Name;
      Proditem.Value_Type__c=Valuetype;
      Proditem.Master_Product__c=MasterProduct;
      Proditem.Mandatory__c=Mandatory;
      insert Proditem;
      return Proditem;
   }
   
   /**   
      * @description       This method creates test data for Product
      * @param             NA                 
      * @return            Product
      * @throws            NA      
      *//*
   Public Static Product2 createProduct(string Name,id MasterproductId,id Prdrectype,String Feetype)
   {
   Product2 Prod=new Product2();
      Prod.Name=Name;
      Prod.Master_Product__c=MasterproductId;
      Prod.Fee_Type__c=Feetype;
      Prod.RecordTypeId=Prdrectype;
      prod.isactive=true;
      insert Prod;
      Pricebookentry pbe=new Pricebookentry();
      pbe.product2id=prod.id;
      pbe.pricebook2id=Test.getStandardPricebookId();
      pbe.unitprice=20;
      insert pbe;
      return Prod;
   }
   /**   
      * @description       This method creates test data for Bundle Product
      * @param             NA                 
      * @return            Bundle Product
      * @throws            NA      
      *//*
      Public Static Product2 createBundleProduct()
      {
        Master_Product__c MP=Util_TestMethod.createMasterProduct('test MasterProduct');
        id  BundleRecordType=product2.sobjectType.getDescribe().getRecordTypeInfosByName().get('Bundle').getRecordTypeId();
        product2 BundleProduct= Util_TestMethod.createProduct('BundleProduct',MP.id,BundleRecordType,'Fixed');
        list<Bundle_Line_Item__c> bundletoInsert=new list<Bundle_Line_Item__c>();
        for(product2 Product:[select id from product2 where recordtypeid!=:BundleRecordType limit 3])
        {
                Bundle_Line_Item__c Bundle=new Bundle_Line_Item__c();
                Bundle.Product__c=product.id;
                bundle.bundle__C=bundleproduct.id;
                bundletoInsert.add(Bundle);
        }
       try{
            database.insert(bundletoInsert);
        }
        catch(exception e)
        {
            system.debug('exception catched  '+e);
        }
        
       return BundleProduct;
      }
      */
}