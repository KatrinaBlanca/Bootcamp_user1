public class DiscountController {

 public DiscountController()
 {}

    public PageReference discountbutton()
    {
    
    string url = ApexPages.currentPage().getUrl();
    pagereference pr;
    id urlid=apexpages.currentpage().getparameters().get('id');
    Boolean result = url.contains('partners');
    if(result == true)
     {
       pr = new pagereference('/partners/apex/discountproductsconfiguratorSF1');
       pr.getParameters().put('id', urlid);
      pr.setRedirect(true);
     }
    else
      {
       pr= new pagereference('/apex/discountproductsconfiguratorSF1');
       pr.getParameters().put('id',urlid);
      pr.setRedirect(true);
      }
      
      return pr;
      
    }

}