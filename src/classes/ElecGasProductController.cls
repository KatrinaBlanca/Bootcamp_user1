public class ElecGasProductController {

  public ElecGasProductController(){}

    public PageReference AddProd()
     {
      string url= Apexpages.Currentpage().geturl();
      id urlid = Apexpages.currentpage().getparameters().get('id');
      Boolean result= url.contains('partners');
      pagereference pr;
      
      if(result== true)
       {
        pr= new pagereference('/partners/apex/Lightning_Commodity?id={!Opportunity.Id}');
        pr.getParameters().put('id',urlid);
        pr.setredirect(true);
       }
      
      else
       {
        pr= new pagereference('/apex/Lightning_Commodity?id={!Opportunity.Id}');
        pr.getParameters().put('id',urlid);
        pr.setredirect(true);
       }
       
       return pr;
        
     }

}