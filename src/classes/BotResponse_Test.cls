@isTest
public class BotResponse_Test {
    
    @isTest static void BotResponseTest(){
        
        Test.startTest();
        List<BotMessage> messages ;
        BotMessage message;
        Map<String, String> session;
        BotResponse br = new BotResponse();
        
        BotResponse response = new BotResponse(messages, session);
        BotResponse response2 = new  BotResponse(message);
        BotResponse response3 = new BotResponse ( message,session); 
        BotResponse response34= new BotResponse ( messages); 
        
        Test.stopTest();
        
        
    }  



}