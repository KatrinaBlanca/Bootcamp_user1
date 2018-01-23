/**
 * @author Aard-Jan van Kesteren
 * @description Tests Util.
 */
@isTest
private class UtilTest {
    
    @isTest
    static void testIsOpportunityId() {
        system.Test.startTest();
        Opportunity opp = TestDataFactoryTest.createOpportunity();
        System.Test.stopTest();
        System.assert(Util.isOpportunityId(opp.Id));
        System.assert(!Util.isQuoteId(opp.Id));
    }
    
    @isTest
    static void testIsQuoteId() {
        System.Test.startTest();
        Quote quote = TestDataFactoryTest.createQuote();
        system.Test.stopTest();
        System.assert(!Util.isOpportunityId(quote.Id));
        System.assert(Util.isQuoteId(quote.Id));        
    }   
    
    @isTest
    static void testFormatRate() {
        System.assertEquals('PHP 0.00056', Util.formatRate(0.00056));
        System.assertEquals('PHP 0.2', Util.formatRate(0.2));
        System.assertEquals('PHP 0.2', Util.formatRate(0.20000));
        System.assertEquals('PHP 2,160.00', Util.formatRate(2160));
    }
    
    @isTest 
    static void testFormatPercentage() {
        System.assertEquals('0.8 %', Util.formatPercentage(0.8));
    }
    //start melvin corbes Jul-14-2017
    @isTest static void is_activeTest(){
        // Inactive_For__c is null
        Test.startTest();
         Boolean active = Util.is_active('Key');
        Test.stopTest();
        System.assert(true ==active );
        
    }
    
    //start melvin corbes Jul-17-2017
    /*
    @isTest(SeeAllData=true)
     static void is_activeWithData(){
        //Query for the user 
       Trigger_Setting__mdt tsm = [select  Id, Inactive_For__c, Label, DeveloperName
                                   from    Trigger_Setting__mdt][0]; 
       
        
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = p.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com'); 
         System.runAs(u) {
        Test.startTest();
         Boolean active = Util.is_active(tsm.DeveloperName);
        Test.stopTest();
        System.assert(true ==active );
         }
    }
    
    */
    
    
    
}