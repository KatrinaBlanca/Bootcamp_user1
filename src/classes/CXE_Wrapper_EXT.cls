public class CXE_Wrapper_EXT {

	public class serviceObject {
		
		public String url {get;set;}
		public String method {get;set;}
		public String authtype {get;set;} // If Bearer, OAuth, Basic
		public String username {get;set;}
		public String password {get;set;}
		public String clientId {get;set;}
		public String clientSecret {get;set;}
		public String bearerTokenSessionId {get;set;}
		public String codeBlock {get;set;}
	}

	public class marketingTokenFormat{
        
        public String clientId{get;set;}
        public String clientSecret{get;set;}
       
    }

    public class marketingsendSMSFormat{
        
        public String[] mobileNumbers{get;set;}
        public Boolean Subscribe{get;set;}
        public Boolean Resubscribe{get;set;}
        public Boolean Override1{get;set;}
        public String messageText{get;set;}    
    }

    public class BillPrintModeWrapper
	{
	     public String response;
	     public String idPaymentForm;
	     public String description;
	}
}