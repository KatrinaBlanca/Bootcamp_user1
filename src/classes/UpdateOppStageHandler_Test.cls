/**
  * @author       : Accenture IDC
  * @date         : 17/7/2015
  * @description  : Test Class for UpdateOppStageController class to check the opportunity stage update.
  */   
@isTest
private class UpdateOppStageHandler_Test
{

    private static final String ADMIN_PROFILE = 'System Administrator';
    Private static final String ACC_NAME = 'Test Account';
    Private static final String OPP_NAME = 'Test Opportunity';
    Private static final String OPP_STAGE = 'Prospecting';
    Private static final String QUOTE_NAME = 'Test Quote';
    Private static final String QUOTE_STATUS_ACCEPTED = 'Accepted';
    Private static final String QUOTE_STATUS_DRAFT = 'Draft';
    Private static final String QUOTE_STATUS_DENIED = 'Denied';
    
    /**
      * @description       Test method to validate Stage of Opportunity.(Positive Scenario)
      * @param             NA
      * @return            Void
      * @throws            NA
      */
/*
       private static testMethod void Oppupdatequoteaccepted()
       {
           Profile prof = [select id from profile where Name =: ADMIN_PROFILE LIMIT 1];
           User contextUser = TestDataFactoryTest.createUser('Hulk',prof.id,null);
           System.runAs(contextUser)
           {
               Account acc=TestDataFactoryTest.createAccount(ACC_NAME);      
               opportunity opp=TestDataFactoryTest.createOpportunity(acc.id,OPP_NAME,System.today(),OPP_STAGE,System.Test.getStandardPricebookId(),null);
               Quote Quo = TestDataFactoryTest.CreateQuote(opp.id,acc.id,QUOTE_NAME,System.test.getStandardPricebookId());
               Connection__C CONN1=TestDataFactoryTest.createConnection('TestConnection',null);
               Connection__C CONN2=TestDataFactoryTest.createConnection('TestConnection','123456');
             //  Pricebook2 pricebookID=TestDataFactoryTest.createPricebook(true,'testpricebook');
               Master_Product__c MP=TestDataFactoryTest.createMasterProduct('test MasterProduct','gas');
               id  CommercialRecordType=product2.sobjectType.getDescribe().getRecordTypeInfosByName().get('Commercial Product').getRecordTypeId();
               Product2 Prod=TestDataFactoryTest.createProduct('Test Product1',MP.id,CommercialRecordType,'Fixed');
               Product2 Prod2=TestDataFactoryTest.createProduct('Test Product2',MP.id,CommercialRecordType,'Fixed');
               Pricebookentry SPBE1=[select id from Pricebookentry where product2id=:Prod.id];
             //  pricebookentry SPBE1=TestDataFactoryTest.createPricebookEntry(Prod.id,test.getStandardPricebookId(),0); 
            //   pricebookentry SPBE2=TestDataFactoryTest.createPricebookEntry(Prod2.id,test.getStandardPricebookId(),1); 
               TestDataFactoryTest.createQuoteLIneItem(Quo.id,SPBE1.id,1,10,CONN1.id);
             //  TestDataFactoryTest.createQuoteLIneItem(Quo.id,SPBE2.id,1,10,CONN2.id);
               System.Test.startTest();
                   Quo.Status = QUOTE_STATUS_ACCEPTED;  
                   Quo.Quote_Signed_Date__c= System.Today(); 
                  // Quo.Security_Deposit_Pending__c = true;             
                   Update Quo;
                   opportunity opp1=[select Id,StageName from opportunity where Id=: opp.Id];
                   Quote Q=[select id , status from quote where id =:quo.id];
               System.Test.stopTest();
               system.assertEquals(opp1.StageName,'Cooling-Off Period');
               system.assertEquals(q.status,'Accepted');
           }
       }
       
       /**
      * @description       Test method to validate Stage of Opportunity.(Negative Scenario)
      * @param             NA
      * @return            Void
      * @throws            NA
      */
      
  /*
       private static testMethod void Oppupdatequotedraft()
       {
           Profile prof = [select id from profile where Name =: ADMIN_PROFILE LIMIT 1];
           User contextUser = TestDataFactoryTest.createUser('Hulk',prof.id,null);
           System.runAs(contextUser)
           {
               Account acc=TestDataFactoryTest.createAccount(ACC_NAME);      
               opportunity opp=TestDataFactoryTest.createOpportunity(acc.id,OPP_NAME,System.today(),OPP_STAGE,System.Test.getStandardPricebookId(),null);
               Quote Quo = TestDataFactoryTest.CreateQuote(opp.id,acc.id,QUOTE_NAME,System.Test.getStandardPricebookId());
               System.Test.startTest();
                   Quo.Status = QUOTE_STATUS_DRAFT;
                   Update Quo;
                   opportunity opp1=[select Id,StageName from opportunity where Id=: opp.Id];
               System.Test.stopTest();
               system.assertNotEquals(opp1.StageName,'Closed Won');
           }
       }
       
        /**
      * @description       Test method to validate Stage of Opportunity.(Negative Scenario)
      * @param             NA
      * @return            Void
      * @throws            NA
      */
      /*
       private static testMethod void Oppupdatequotedenied()
       {
           Profile prof = [select id from profile where Name =: ADMIN_PROFILE LIMIT 1];
           User contextUser = TestDataFactoryTest.createUser('Hulk',prof.id,null);
           System.runAs(contextUser)
           {
               Account acc=TestDataFactoryTest.createAccount(ACC_NAME);      
               opportunity opp=TestDataFactoryTest.createOpportunity(acc.id,OPP_NAME,System.today(),OPP_STAGE,System.Test.getStandardPricebookId(),null);
               Quote Quo = TestDataFactoryTest.CreateQuote(opp.id,acc.id,QUOTE_NAME,System.Test.getStandardPricebookId());
               System.Test.startTest();
                       Quo.Status = QUOTE_STATUS_DENIED;
                       opp.name = null;
                       opp.stagename=null;
                       Update Quo;
               System.Test.stopTest();
              
               opportunity opp1=[select Id,StageName from opportunity where Id=: opp.Id];
               system.assertNotEquals(opp1.StageName,'Closed Won');
           }
       }
 */
}