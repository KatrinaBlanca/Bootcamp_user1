public class CXE_splashMeralcoMobileController {
    
    public String username {get; set;}
    public String password {get; set;}
    public String startURL {get; set;}
    
    public  String  headerdata{get;set;}
    public string urlvalue{get;set;}
    public string url{get;set;}
    public String fbLinking {get; set;}
    public String googleLinking {get; set;}
    
    public boolean showErrorWrongCred {get;set;}
    public boolean showErrorWrongCredPW {get;set;}
    public boolean wrongEmailFormat {get;set;}
    public boolean inactiveUser {get;set;}
    public boolean invalidUser {get;set;}
    public boolean lockedAccount {get;set;} // CSM-14879 Jintal 12/13/17    

    
    public CXE_splashMeralcoMobileController() {
        startUrl = System.currentPageReference().getParameters().get('startURL');
        String community = '?community=';
        String url = OrganizationSettings__c.getOrgDefaults().PortalEmailURL__c;
        
        /*String fbLink = CXE_CP_SplashPageLoginForm.getFbLink();
        fbLinking = fbLink + community + url + '/dashboard';
        
        String googleLink = CXE_CP_SplashPageLoginForm.getGoogleLink();
        googleLinking = googleLink + community + url + '/dashboard';*/
        
        headerdata= ApexPages.currentPage().getHeaders().get('Host');
         
         urlvalue=Apexpages.currentPage().getUrl();
         
         url='https://' + headerdata+ urlvalue;
    }
    
    public PageReference gotoForgotPwPage(){
         PageReference pageRef = new PageReference(OrganizationSettings__c.getInstance().PortalEmailURL__c + '/'+'mobforgotpassword');
            return pageRef;
    }
    
    public PageReference validateUser(){
       system.debug('validateUser username: ' + username);
       List<User> userList = [SELECT Id, CXE_CP_isPortalDeactivated__c FROM User WHERE UserName =: username];
        
        
        if(String.isBlank(username)) {
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'* Please enter your username and/or password.'));
            this.showErrorWrongCred=true;
            this.wrongEmailFormat = false;
            this.inactiveUser=false;
            this.invalidUser=false;
            this.showErrorWrongCredPW=false;
            this.lockedAccount=false;
        } else if(String.isBlank(password)) {
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'* Please enter your username and/or password.'));
            this.showErrorWrongCredPW=true;
            this.showErrorWrongCred=false;
            this.wrongEmailFormat = false;
            this.inactiveUser=false;
            this.invalidUser=false;
            this.lockedAccount=false;
        } else if(!isValidEmailFormat(username)){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, '* Invalid Email Format.'));
            this.wrongEmailFormat=true;
            this.showErrorWrongCred=false;
            this.inactiveUser=false;
            this.invalidUser=false;
            this.showErrorWrongCredPW=false;
            this.lockedAccount=false;
        } 
	// CSM-14879 Jintal 12/13/17    
	/*else if(checkLock.IsPasswordLocked == true){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, '* Invalid Email Format.'));
            this.wrongEmailFormat=false;
            this.showErrorWrongCred=false;
            this.inactiveUser=false;
            this.invalidUser=false;
            this.showErrorWrongCredPW=false;
            this.lockedAccount=true;
        }*/
        
           
        else {
            // start CSM-14879 Jintal 12/17/17 
            if(!userList.isEmpty()){
                UserLogin checkLock = [select IsPasswordLocked from UserLogin where UserId =: userList[0].id];
                if(checkLock.IsPasswordLocked == true){
                    this.wrongEmailFormat=false;
                    this.showErrorWrongCred=false;
                    this.inactiveUser=false;
                    this.invalidUser=false;
                    this.showErrorWrongCredPW=false;
                    this.lockedAccount=true;
                }
              // start CSM-14879 Jintal 12/17/17 
                else if(!userList.isEmpty() && userList[0].CXE_CP_isPortalDeactivated__c){
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'*  Meralco Online account has been deactivated.'));
                    this.inactiveUser=true;
                    this.wrongEmailFormat=false;
                    this.showErrorWrongCred=false;
                    this.invalidUser=false;
                    this.showErrorWrongCredPW=false;
                    this.lockedAccount=false;
                } 
                else{
                    String startUrl = System.currentPageReference().getParameters().get('startURL');
                    PageReference pr =  Site.login(username,password, startUrl);
                    if(pr==null){
                        this.invalidUser=true;
                        this.inactiveUser=false;
                        this.wrongEmailFormat=false;
                        this.showErrorWrongCred=false;
                        this.showErrorWrongCredPW=false;
                        this.lockedAccount=false;
                 } 
                
                else {return pr;}
                }
            
            //START CSM-14920 12/19/2017 JRances - [R3A SQT] No error prompt after logging in with incorrect email or password
            } else {
                this.invalidUser=true;
                this.inactiveUser=false;
                this.wrongEmailFormat=false;
                this.showErrorWrongCred=false;
                this.showErrorWrongCredPW=false;
                this.lockedAccount=false;
            }
            //END CSM-14920 
            /*if(!userList.isEmpty() && userList[0].CXE_CP_isPortalDeactivated__c){
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'*  Meralco Online account has been deactivated.'));
                this.inactiveUser=true;
                this.wrongEmailFormat=false;
            	this.showErrorWrongCred=false;
                this.invalidUser=false;
                this.showErrorWrongCredPW=false;
                this.lockedAccount=false;
            } 
            
            else {
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, '* You\'ve entered an incorrect username and/or password. Please re-enter your log-in information.'));
                //this.invalidUser=true;
                //return getLoginDetails();
                String startUrl = System.currentPageReference().getParameters().get('startURL');
                PageReference pr =  Site.login(username,password, startUrl);
                if(pr==null){
                    this.invalidUser=true;
                    this.inactiveUser=false;
                	this.wrongEmailFormat=false;
            		this.showErrorWrongCred=false;
                    this.showErrorWrongCredPW=false;
                    this.lockedAccount=false;
                } 
                
                else {return pr;}
				*/                
            }
        //}
       


        return null;
    }
    

    private Boolean isValidEmailFormat(String email) {
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
        Pattern myPattern = Pattern.compile(emailRegex);
        Matcher myMatcher = myPattern.matcher(email);
        return myMatcher.matches();
    }
    
    private PageReference getLoginDetails() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        //return Site.login(username,password, OrganizationSettings__c.getInstance().PortalEmailURL__c +'/'+'dashboard'); 
        return Site.login(username,password, startUrl);
    }

/***** CSM-14585 & CSM-14597 JIntal 12-04-17 ******/
    public static String getFbLink(){
        //return OrganizationSettings__c.getOrgDefaults().signInThruFacebook__c;
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        String community = '?community=';
        String url = OrganizationSettings__c.getOrgDefaults().PortalEmailURL__c + '/dashboard';
        String fbLink = OrganizationSettings__c.getOrgDefaults().signInThruFacebook__c;
        String fbLinking = fbLink + community + url;
        
        if(startURL != null){return  fbLinking += '&startURL='+startURL;}
        else{return fbLinking;}
             
        
    }
    public static String getGoogleLink(){
        //return OrganizationSettings__c.getOrgDefaults().signInThruGoogle__c;
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        String community = '?community=';
        String url = OrganizationSettings__c.getOrgDefaults().PortalEmailURL__c + '/dashboard';
        String googleLink = OrganizationSettings__c.getOrgDefaults().signInThruGoogle__c;
        String googleLinking = googleLink + community + url;
        
        if(startURL != null){return  googleLinking += '&startURL='+startURL;}
        else{return googleLinking;}
    }
/***** CSM-14585 & CSM-14597 JIntal 12-04-17 ******/
}