public class CXE_CP_SplashPageSelfRegistration_Req {

        @AuraEnabled
        public Boolean isNew {get; set;}

        @AuraEnabled
        public String email {get; set;}

        @AuraEnabled
        public String firstname {get; set;}

        @AuraEnabled
        public String middle {get; set;}

        @AuraEnabled
        public String lastname {get; set;}

        @AuraEnabled
        public String suffix {get; set;}

        @AuraEnabled
        public String mobileNumber {get; set;}

        @AuraEnabled
        public String SIN {get; set;}

        @AuraEnabled
        public Decimal amount {get; set;}

        @AuraEnabled
        public Date transactionDate {get; set;}
    }