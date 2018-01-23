public class NonCommodityController {

    public NonCommodityController() {}

          
  public pagereference noncommodity()
{  
    pagereference pr;
  id urlid=apexpages.currentpage().getparameters().get('id');
  
    string url = ApexPages.currentPage().getUrl();
    
     
    Boolean result = url.contains('partners'); 
   if(result == true)
     {
        
        pr = new pagereference('/partners/apex/NonCommodityProductsConfiguratorsf1');
      pr.getParameters().put('id', urlid);
    pr.setRedirect(true); 
       
     } 
     else
     {
       pr = new pagereference('/apex/NonCommodityProductsConfiguratorsf1');
        
   pr.getParameters().put('id', urlid);
    pr.setRedirect(true);
    }
    return pr;
    
   
}
}