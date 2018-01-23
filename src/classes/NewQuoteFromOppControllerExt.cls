public class NewQuoteFromOppControllerExt {

    private Opportunity opp;
    
    public NewQuoteFromOppControllerExt(ApexPages.StandardController stdController) {
        opp = (Opportunity)stdController.getRecord();
    }
    
    public PageReference createQuote() {
    Quote quote = new Quote();
        
        opp = [
            select Id, type, Name, Pricebook2Id, Won_Lost_Reason__c, Bundle__c,RecordTypeId,
                 Contract_End_Date__c, Contract_Start_Date__c,
                 Duration_Status__c
            from Opportunity
            where Id = :opp.Id
            limit 1
        ][0];
        
        // Query existing quotes
        List<Quote> quotes = [
            select Id
            from Quote
            where OpportunityId = :opp.Id
        ];
        
        quote.OpportunityId = opp.Id;
        quote.Name = opp.Name + ' - ' + (quotes.size() + 1);
        quote.ExpirationDate = Date.today() + 7;
        quote.Pricebook2Id = opp.Pricebook2Id;
        
        quote.Won_Lost_Reason__c = opp.Won_Lost_Reason__c;
        quote.Bundle__c = opp.Bundle__c;
        quote.Contract_End_Date__c = opp.Contract_End_Date__c;
        quote.Contract_Start_Date__c = opp.Contract_Start_Date__c;
        quote.Duration_status__c = opp.Duration_status__c;
        quote.Quote_Reason__c = opp.type;
        system.debug('Test Record Type:' +opp.RecordTypeId);
        if(opp.RecordTypeId == '01228000000EOqN')
        {
            quote.RecordTypeId = '01228000000DE4J';
        }    
        insert quote;
        for (OpportunityLineItem oli: [
            select PricebookEntryId, Quantity, Connection__c, UnitPrice
            from OpportunityLineItem
            where OpportunityId = :opp.Id
        ]) {
          QuoteLineItem qli = new QuoteLineItem();
            qli.QuoteId = quote.Id;
            qli.PricebookEntryId = oli.PricebookEntryId;
            qli.Quantity = oli.Quantity;
            qli.UnitPrice = oli.UnitPrice;
            qli.Connection__c = oli.Connection__c;
            insert qli;
        }
        
        return (new ApexPages.StandardController(quote)).view();
    }
}