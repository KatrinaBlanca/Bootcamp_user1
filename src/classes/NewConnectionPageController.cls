/**
  * @author       : Accenture IDC
  * @date         : 07/10/2015
  * @description  : Controller Class to save new connection and redirect to corresponding Product Page
  */

public class NewConnectionPageController
{
    private Connection__c potCustomer ;
    private final ApexPages.StandardController controller;
    //Constructor
     public NewConnectionPageController(ApexPages.StandardController controller)
     {
        this.controller = controller;
        potCustomer = (Connection__c) Controller.getRecord();
        Id oppid = ApexPages.currentPage().getParameters().get('Oppid');
        Opportunity opp = [select Id,AccountId from Opportunity where Id=:oppid];
        potcustomer.Account__c = opp.AccountId;     
     }

    // This method Saves the Connection and Redirects the page to corresponding product configurator.
    public PageReference Customsave()
    {
        PageReference newPage;
        try
        {
            insert potcustomer;
            String prodtype = ApexPages.currentPage().getParameters().get('Ptype');
            Id oppid = ApexPages.currentPage().getParameters().get('Oppid');
            if(prodtype=='Commodity')
            {
                newpage = page.CommodityProductsConfigurator;
                newpage.getParameters().put('Id', oppid);
                newpage.setRedirect(False);
            }
            if(prodtype=='Bundle')
            {
                newpage = page.BundleConfigurator;
                newpage.getParameters().put('Id', oppid);
                newpage.setRedirect(False);
            }    
        }
        catch(Exception exp)
        {
            ApexPages.addMessages(exp);
            newpage = null;
        }
        return newpage;   
                
    }
    
    // This method Cancels the Connection Save and Redirects the page to corresponding product configurator.
    public PageReference CustomCancel()
    {
        PageReference newPage;
        String prodtype = ApexPages.currentPage().getParameters().get('Ptype');
        Id oppid = ApexPages.currentPage().getParameters().get('Oppid');
        if(prodtype=='Commodity')
        {
            newpage = page.CommodityProductsConfigurator;
            newpage.getParameters().put('Id', oppid);
            newpage.setRedirect(false);
        }
        if(prodtype=='Bundle')
        {
            newpage = page.BundleConfigurator;
            newpage.getParameters().put('Id', oppid);
            newpage.setRedirect(False);
        }
        return newpage;    
     }
        
    
        
}