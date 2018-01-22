public class MobileChangePwdController {
    public string message {get; set;}

    public PageReference init() {
        String pwd1 = ApexPages.currentPage().getParameters().get('pwd1');
        String pwd2 = ApexPages.currentPage().getParameters().get('pwd2');
        String old = ApexPages.currentPage().getParameters().get('old');
        System.debug(pwd1+ '|' + Pwd2 + '|'+ old);
        System.PageReference ref = Site.changePassword(pwd1, pwd2, old);
        if(ref != null)
            message = 'Success';
        else
            message = string.valueOf(ApexPages.getMessages());
        
        return null;
    }

}