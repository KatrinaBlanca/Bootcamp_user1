/**
 * @author Aard-Jan van Kesteren
 * @group Test
 * @description Creates test data.
 */
@isTest
public class TestDataFactoryTest{


     /**
      * @description       This method creates test user for unit testing                           
      * @param             String      lastName     
      * @param             Id      profileId     
      * @return            User              Returns the user object
      * @throws            NA
      */
    public static User createUser(String lastName,Id profileId,Id roleId){
        User usr = new User(alias = lastName, email= Constants.USR_TMP_EMAIL,
                            emailencodingkey= Constants.ENCODE_KEY, lastname = lastName,
                            timezonesidkey=Constants.TIME_ZONE,
                            languagelocalekey=Constants.LOCALE_KEY,
                            localesidkey=Constants.LOCALE_KEY, profileid = profileId,
                            UserRoleId= roleId,
                            username= lastName + System.currentTimeMillis() +Constants.USER_POSTFIX);
        return usr;
    }

    public static Notification__c createNotification(Boolean published) {
        Notification__c notification = new Notification__c();
        notification.Status__c = published ? Constants.NOTIFICATION_STATUS_PUBLISHED : Constants.NOTIFICATION_STATUS_DRAFT;
        notification.Short_Message__c = 'SHORT MESSAGE';
        notification.Long_Message__c = 'LONG MESSAGE';
        insert notification;
        return notification;
    }
    
    public static User_Notification__c createUserNotification(Notification__c notification) {
        User_Notification__c userNotification = new User_Notification__c();
        userNotification.Notification__c = notification.Id;
        userNotification.Status__c = Constants.USER_NOTIFICATION_STATUS_NEW;
        userNotification.User__c = UserInfo.getUserId();
        insert userNotification;
        return userNotification;
    }
     /**   
      * @description       This method creates test data for Master Product
      * @param             NA                 
      * @return            MAster Product
      * @throws            NA      
      */
    public static Master_Product__c createMasterProduct(string Name,String Type)
    {
        Master_Product__c masterProduct=new Master_Product__c ();
        masterProduct.name=name;
        masterProduct.type__C=type;
        insert masterProduct;
        return masterProduct;
    }
    /**   
      * @description       This method creates test data for Product
      * @param             NA                 
      * @return            Product
      * @throws            NA      
      */
     Public Static Product2 createProduct(string Name,id MasterproductId,id Prdrectype,String Feetype)
      {
           Product2 Prod=new Product2();
          Prod.Name=Name;
          Prod.Master_Product__c=MasterproductId;
          Prod.Fee_Type__c=Feetype;
          Prod.RecordTypeId=Prdrectype;
          //prod.isactive=true;
          insert Prod;

          Id standardPBId = Test.getStandardPricebookId();
          PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = standardPBId, Product2Id = Prod.Id, UnitPrice = 1000, IsActive = true);
          insert standardPBE;
          return prod;
      }
       Public Static PricebookEntry createPricebookEntry(id ProductId,id PricebookId,Decimal Unitprice)
       {
          Pricebookentry pbe=new Pricebookentry();
          pbe.isActive=true;
          pbe.product2id=ProductId;
          pbe.pricebook2id=PricebookId;
          pbe.UnitPrice=Unitprice;
          insert pbe;
          return Pbe;
       }

      Public Static PricebookEntry createStandardPricebookEntry(id ProductId,Decimal Unitprice)
       {
          Id standardPBId = Test.getStandardPricebookId();
          Pricebookentry pbe=new Pricebookentry();
          pbe.isActive=true;
          pbe.product2id=ProductId;
          pbe.pricebook2id=standardPBId;
          pbe.UnitPrice=Unitprice;
          insert pbe;
          return Pbe;
       }

       /**   
      * @description       This method creates test data for Product Item
      * @param             NA                 
      * @return            Product Item
      * @throws            NA      
      */
        Public Static Product_Item__c createProductItem(string Name,String Valuetype,Id MasterProduct,Boolean Mandatory)
       {
           Product_Item__c Proditem=new Product_Item__c();
          Proditem.Name=Name;
          Proditem.Value_Type__c=Valuetype;
          Proditem.Master_Product__c=MasterProduct;
          Proditem.Mandatory__c=Mandatory;
          proditem.Rate_Value__c=10;
          proditem.Operation__c='+ Value';
          insert Proditem;
          return Proditem;
       }
    
       public Static Commercial_Product_Value__c commercialProductValue(id ProductItem,id Product,decimal percentage,decimal Rate)
       {
            Commercial_Product_Value__c cpv=new Commercial_Product_Value__c ();
            cpv.Product__c=product;
            cpv.Product_Item__c=productItem;
            //cpv.Rate_Value__c=rate;
            insert cpv;
            return cpv;
       }
    
       public Static Commercial_Product_Value__c createCommercialProductValue(id ProductItem,id Product,decimal percentage,decimal Rate)
       {
            return commercialProductValue(productItem, product, percentage, rate);
       }
    
    public static Opportunity createOpportunity() {
        return createOpportunity(createAccount().Id, 'TESTTESTTEST', Date.today(), 'Prospecting', null, null);
    }
    
       /**   
      * @description       This method creates test data for Opportunity
      * @param             NA                 
      * @return            Opportunity    
      * @throws            NA      
      */
       public static Opportunity createOpportunity(id Accountid,String OpportunityName,Date closedate,String StageName,Id PricebookId,id BundleProductID)
       {
           
           opportunity opp=new opportunity();
              opp.accountid=Accountid;
              opp.name=OpportunityName;
              opp.closedate=closedate;
              opp.stagename=StageName;
              opp.pricebook2id=PricebookId;
              opp.Bundle__C=BundleProductID;
              opp.Closed_Lost_Reason__c = 'Test Reason';
              insert opp;
              return opp;
       }
        /**   
      * @description       This method creates test data for OpportunityLineItem
      * @param             NA                 
      * @return            OpportunityLineItem
      * @throws            NA      
      */
       Public Static OpportunityLineItem createOpportunityLineItem(id OpportunityId,id PricebookentryId,Integer Quantity,Decimal TotalPrice )
       {
           OpportunityLineItem OLI=new OpportunityLineItem();
              OLI.OpportunityId=OpportunityId;
              OLI.pricebookentryid=PricebookentryId;
              OLI.Quantity=Quantity;
              //OLI.TotalPrice = TotalPrice;
              OLI.UnitPrice = TotalPrice/Quantity;
              insert OLI;
              return OLI;
       }
       
       public static Pricebook2 createPricebook(Boolean Isactive,String Name)
       {
       Pricebook2 pb2=new Pricebook2();
       pb2.isactive=Isactive;
       pb2.name=Name;
       insert pb2;
       return pb2;
       }
    
        public static Account createAccount() {
            return createAccount('TESTTESTTEST');
        }
    
        /**   
      * @description       This method creates test data for Account
      * @param             NA                 
      * @return            Account     
      * @throws            NA      
      */
       Public static Account createAccount(String AccountName)
       {
           
           Account acc=new Account();
              acc.name=AccountName;
              acc.Tax_Identification_No__c = '123456789012'; //CXE PDC 3-28-2017 addition account validation
              acc.Customer_Accepted__c = 'Accepted';
              acc.Email__c = 'test@test.com';//START/END R2 RReyes JUL-08-17 - added email to pass validation
              insert acc;
              return acc;
       }
    
    public static Quote createQuote() {
        return createQuote(createOpportunity().Id, null, 'TESTTESTTEST',null);
    }
    
        /**   
      * @description       This method creates test data for Quote
      * @param             NA                 
      * @return            Quote
      * @throws            NA      
      */
       Public Static Quote createQuote(id OpportunityId,id AccountId,String Name,ID PricebookID)
       {
           Quote Q=new Quote();
              Q.OpportunityId=OpportunityId;
              Q.Name=Name;
              Q.Pricebook2id=PricebookID;
              //Q.Status=Status;
              insert Q;
              return Q;
       }
       /**   
      * @description       This method creates pricebook
      * @param             NA                 
      * @return            pricebook
      * @throws            NA      
      */
       public static Pricebook2 createPricebook(string name,boolean Isactive)
       {
         Pricebook2 customPB = new Pricebook2(Name=name, isActive=Isactive);
         insert customPB;
         return customPB;
       }
       /**   
      * @description       This method creates test data for Bundle Product
      * @param             NA                 
      * @return            Bundle Product
      * @throws            NA      
      */
         Public Static Product2 createBundleProduct(string Name,id PricebookId)
      {
            Master_Product__c MP=TestDataFactoryTest.createMasterProduct('test MasterProduct','gas');
            id  BundleRecordType=product2.sobjectType.getDescribe().getRecordTypeInfosByName().get('Bundle').getRecordTypeId();
            id  CommercialRecordType=product2.sobjectType.getDescribe().getRecordTypeInfosByName().get('Commercial Product').getRecordTypeId();
            product2 BundleProduct= TestDataFactoryTest.createProduct(Name,MP.id,BundleRecordType,'Fixed');
            TestDataFactoryTest.createPricebookEntry(BundleProduct.id,PricebookId,1);            
            Product2 Prod=TestDataFactoryTest.createProduct('Test Product1',MP.id,CommercialRecordType,'Fixed');
            Product2 Prod2=TestDataFactoryTest.createProduct('Test Product2',MP.id,CommercialRecordType,'Fixed');

            TestDataFactoryTest.createPricebookEntry(Prod.id,PricebookId,1);
            TestDataFactoryTest.createPricebookEntry(Prod2.id,PricebookId,1);
            Bundle_Line_Item__c Bundle=new Bundle_Line_Item__c();
            Bundle.Product__c=Prod.id;
            bundle.bundle__C=BundleProduct.id;
            Insert bundle;
            Bundle_Line_Item__c Bundle2=new Bundle_Line_Item__c();
            Bundle2.Product__c=Prod2.id;
            bundle2.bundle__C=BundleProduct.id;
            Insert bundle2;
           return BundleProduct;
      }
      
      Public Static QuoteLineItem createQuoteLIneItem(ID QuoteID,ID PriceBookEntryid,integer Quantity,Decimal UnitPrice,id ConnectionID)
      {
              QuoteLineItem QLI=new QuoteLineItem ();
              QLI.QuoteID=QuoteId;
              QLI.pricebookentryid=PricebookentryId;
              QLI.Quantity=Quantity;
              QLI.UnitPrice=UnitPrice;
              QLI.Connection__C=ConnectionID;
              QLI.Discount = 0;
              QLI.ServiceDate = System.Today() + 1;
              insert QLI;
              return QLI;
      }
      
      public static Connection__C createConnection(String Name,String EAN)
      {
        Connection__C NewConnection=new Connection__C();
        // Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
        //NewConnection.name=name;
        // End: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
        NewConnection.EAN__C=EAN;
        insert NewConnection;
        return NewConnection;
      }
      /**   
      * @description       This method creates test data for Discount Product
      * @param             NA                 
      * @return            Product
      * @throws            NA      
      */
     Public Static Product2 createDiscProduct(string Name,id Prdrectype,Date Disstartdate,String Disctype,string Enertype)
      {
          Product2 Prod=new Product2();
          Prod.Name=Name;
          Prod.RecordTypeId=Prdrectype;
          prod.Discount_Start_Date__c=Disstartdate;
          prod.Discount_Type__c=Disctype;
          prod.Energy_Type__c=Enertype;
          prod.isactive=true;
          insert Prod;

          Id standardPBId = Test.getStandardPricebookId();
          PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = standardPBId, Product2Id = Prod.Id, UnitPrice = 1000, IsActive = true);
          insert standardPBE;

          return prod;
      }

    public static Master_Product__c createMasterProduct() {
        Master_Product__c masterProduct = new Master_Product__c();
        insert masterProduct;
        return masterProduct;
    }
    
    public static Product_Item__c createPercentageProductItem(Master_Product__c masterProduct, 
                                                              Decimal value,
                                                              Integer calculationOrder, 
                                                              String criterium, 
                                                              String operation, 
                                                              String field) {
        Product_Item__c pi = new Product_Item__c();
        pi.Master_Product__c = masterProduct.Id;
        pi.Value_Type__c = Constants.PRODUCT_ITEM_VALUE_TYPE_PERCENTAGE;
        pi.Percentage_Value__c = value;                                                         
      
        pi.Criterium__c = criterium;
        pi.Operation__c = operation;
        pi.Field__c = field;     
        insert pi;                                                          
        return pi;
    }
    
    public static Product_Item__c createRateProductItem(Master_Product__c masterProduct, 
                                                              Decimal value,
                                                              Integer calculationOrder, 
                                                              String criterium, 
                                                              String operation, 
                                                              String field) {
        Product_Item__c pi = new Product_Item__c();
        pi.Master_Product__c = masterProduct.Id;
        pi.Value_Type__c = Constants.PRODUCT_ITEM_VALUE_TYPE_RATE;
        //pi.Rate_Value__c = value;                                                         
    
        pi.Criterium__c = criterium;
        pi.Operation__c = operation;
        pi.Field__c = field;     
        insert pi;                                                          
        return pi;
    }    
    
    public static Product2 createCommercialProduct(Master_Product__c masterProduct) {
        Product2 prod = new Product2();
        prod.RecordTypeId = [select Id from RecordType where DeveloperName = 'Commercial_Product' limit 1][0].Id;
        prod.Master_Product__c = masterProduct.Id;
        prod.Name = 'TEST COMMERCIAL PRODUCT';
        insert prod;
        
        Id standardPBId = Test.getStandardPricebookId();
        PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = standardPBId, Product2Id = Prod.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE;

        return prod;
    }
    
    public static Contract createcontract(Account acc, String status, Date startdate, Integer terms)
    {
        contract con = new contract();
        con.Accountid = acc.Id;
        con.status = status;
        con.StartDate = startdate;
        con.ContractTerm = terms;
        insert con;
        return con;        
    }
    
    public static Agreement__c createagreement(Account acc,Id conid,String agrnumber,integer advamnt)
    {
        Agreement__c agr = new Agreement__c();
        agr.Account__c = acc.Id;
        agr.Contract__c = conid;
        // Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
        //agr.Name = agrnumber;
        // End: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
        agr.Advance_amount__c = advamnt;
        insert agr;
        return agr;
    }
    
    public static case createcase(Account acc,Id conid,string status,string origin)
    {
        Case cas = new case();
        cas.AccountId = acc.Id;
        cas.Contract__c = conid;
        cas.status = status;
        cas.Origin = origin;
        insert cas;
        return cas;
    }
    
}