@isTest
 public class NonCommodityControllerTest
 {
   private static testMethod void TestMet1()
   {
    Account acc= new Account();
    // Start CXE Update test class
    acc.Firstname='Firsname';
    // End CXE Update test class
    acc.LastName='Test';
    acc.Phone = '+63464187364';//START/END R2 RReyes JUL-08-17 - added phone to pass validation
    acc.PersonHomePhone='+6321236547';
    acc.PersonEmail='test@test.com';
    acc.PersonMobilePhone='+631221112221';
    insert acc;
   
    
    Opportunity opp= new Opportunity();
    opp.Accountid= acc.id;
    opp.StageName= 'Qualification';
    opp.Closedate = System.today();
    opp.Name = 'oopp';
    insert opp;
    PageReference oppPage;
        
    oppPage = new PageReference('https://accentureutilities.force.com/partners?id' + opp.id);
    System.Test.setCurrentPage(oppPage);
          
    NonCommodityController T= new NonCommodityController();
      System.Test.startTest();
      
       T.noncommodity();
      System.Test.stopTest();
      
     //System.assertEquals();
     
   }

    private static testMethod void TestMet2()
   {
    Account acc= new Account();
    // Start CXE Update test class
    acc.Firstname='Firsname';
    // End CXE Update test class
    acc.LastName='Test';
    acc.Phone = '+63464187364';//START/END R2 RReyes JUL-08-17 - added phone to pass validation
    acc.PersonHomePhone='+6321236547';
    acc.PersonEmail='test@test.com';
    acc.PersonMobilePhone='+631221112221';
    insert acc;
   
    
    Opportunity opp= new Opportunity();
    opp.Accountid= acc.id;
    opp.StageName= 'Qualification';
    opp.Closedate = System.today();
    opp.Name = 'oopp';
    insert opp;
     PageReference oppPage;
    
    oppPage = new PageReference('https://accenture-utilities.my.salesforce.com?id' + opp.id);
    System.Test.setCurrentPage(oppPage);
    
    NonCommodityController T= new NonCommodityController();
      System.Test.startTest();
      
       T.noncommodity();
      System.Test.stopTest();
      
     //System.assertEquals();
     
   }
  }