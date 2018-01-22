/**  
* @author       : Accenture IDC  
* @date         : 17/07/2015  
* @description  : Wrapper Class for Opportunity Stage Controller, being called from trigger 
*/ 
public class UpdateOppStageHandler
{

       /**   
      * @description       This method Updates Opportunity Stage based on Quote Status.
      * @param             Quote List
      * @return            NA
      * @throws            NA      
      */
      
 /* Commenting out the code as the Trigger which calls this class is not in use
    public void Updateoppstage(List<Quote> lstquote)
    {
        Map<Id, Quote> quoteMap = new Map<Id, Quote>();
        map<id,id> MissingEAN=new map<id,id>();
        List<Opportunity> opptoupdate = new List<Opportunity>();
        for(QuoteLineItem QLI:[select id , Connection__r.EAN__c,QuoteID from QuoteLineItem where QuoteId in :LstQuote])
        {
             if((QLI.connection__r.EAN__C)==null)
             {
              MissingEAN.put(QLI.QuoteID,QLI.id);
             }
            
        }
        for (Quote quote: lstquote)
        {
            
                Opportunity opp = new Opportunity();
                opp.id = quote.OpportunityId;
                opp.StageName = Constants.OPP_STAGE_CLOSED_WON;
                opp.CloseDate = Date.today();
                opptoupdate.add(opp);
                quotemap.put(opp.id,quote);
                if(MissingEAN.containskey(Quote.id))
                quote.status='Missing EAN';
               
        }
        try
        {
            if(opptoupdate.size()>0)
            {
                Update opptoupdate;
            }
        }
        catch(dmlexception dmx) 
        {        
            for (Integer i = 0; i < dmx.getNumDml(); i++)
            {
            Quote source = QuoteMap.get(dmx.getDmlId(i));
            if (source != null) source.addError(Label.OPP_STAGE_UPDATE_ERROR);
            }
        }        
     }
      */
}