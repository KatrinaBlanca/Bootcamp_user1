@isTest
 public class ElecGasProductControllerTest
 {
   private static testMethod void TestMet()
   {
    Account acc= new Account();
    // Start CXE Update test class
    acc.Firstname='Firsname';
    // End CXE Update test class
    acc.LastName='Test';
    acc.Phone = '+63464187364';//START/END R2 RReyes JUL-08-17 - added phone to pass validation
    acc.PersonHomePhone = '+63021231234';
    acc.Mobile_1__pc = '+639221231234';
    acc.PersonEmail = 'aa@aa.com';
    insert acc;
   
    
    Opportunity opp= new Opportunity();
    opp.Accountid= acc.id;
    opp.StageName= 'Qualification';
    opp.Closedate = System.today();
    opp.Name = 'oopp';
    insert opp;
     PageReference oppPage;
    
    
     id uid = userinfo.getProfileId();
     system.debug('uiddddd'+uid);
      if (uid =='00e28000000JQz5')
      {
  oppPage = new PageReference('https://accentureutilities.force.com/partners?id' + opp.id);
        System.Test.setCurrentPage(oppPage);
     }

    else
    {
   oppPage = new PageReference('https://accenture-utilities.my.salesforce.com?id' + opp.id);
      System.Test.setCurrentPage(oppPage);
      system.debug('opppageelse' +opppage);
        
    }
    System.debug('opppageeee'+oppPage);
    
    ElecGasProductController T = new ElecGasProductController();
    System.Test.startTest();
    //START RReyes 04/24 - add system assert
    PageReference pr =  T.AddProd();
    System.Test.stopTest();
    System.assertNotEquals(pr, null);
    //END RReyes 04/24 - add system assert 
     
   }

   //START RReyes 04/24 - add test method for url with parameter
   private static testMethod void testUrlWithPartner()
   {
    Account acc= new Account();
    acc.Firstname='Firsname';
    acc.LastName='Test';
    acc.Phone = '+63464187364';//START/END R2 RReyes JUL-08-17 - added phone to pass validation
    acc.PersonHomePhone = '+63021231234';
    acc.Mobile_1__pc = '+639221231234';
    acc.PersonEmail = 'aa@aa.com';
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
    
    ElecGasProductController T = new ElecGasProductController();
    System.Test.startTest();
    PageReference pr = T.AddProd();
    System.Test.stopTest();
    System.assertNotEquals(pr, null);
   }
   //END RReyes 04/24 - add test method for url with parameter
  }