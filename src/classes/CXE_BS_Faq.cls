@RestResource(urlMapping='/faq')
global with sharing class CXE_BS_Faq  {

    @HttpPost
    global static List<sObject> post(String q){
        return [
            FIND :q IN All FIELDS RETURNING Knowledge__kav (Id, Title, Summary, ArticleNumber)
        ].get(0);
    }


    @HttpGet
    global static List<Knowledge__kav> load() {
        Map<String, String> params = RestContext.request.params;
        
        String cat = params.get('category').toLowerCase();

        if(cat == 'billing') return billing();
        else if(cat == 'reading') return reading();
        else if(cat == 'assistance') return assistance();
        else if(cat == 'irregularity') return irregularity();
        else if(cat == 'adjustment') return adjustment();
        else if(cat == 'presentment') return presentment();
        else if(cat == 'payment') return payment();
        else if(cat == 'bill') return bill();
        else if(cat == 'rcoa') return rcoa();
        else if(cat == 'service') return service();
        else if(cat == 'others') return others();
        else if(cat == 'sa') return sa();
        else if(cat == 'deposit') return deposit();
        else if(cat == 'advance') return advance();
        else if(cat == 'special') return special();

        return null;
    }


    private static List<Knowledge__kav> billing(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Billing__c
        ];
    }

    private static List<Knowledge__kav> reading(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Meter_Reading__c
        ];
    }

    private static List<Knowledge__kav> assistance(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Customer_Assistance__c
        ];
    }

    private static List<Knowledge__kav> irregularity(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Service_Irregularity__c
        ];
    }

    private static List<Knowledge__kav> adjustment(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Billing_Adjustment__c
        ];
    }

    private static List<Knowledge__kav> presentment(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Bill_Presentment__c
        ];
    }

    private static List<Knowledge__kav> payment(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Payments_Management_and_Credits__c
        ];
    }

    private static List<Knowledge__kav> bill(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Management_of_Unpaid_and_Paid_Bills__c
        ];
    }

    private static List<Knowledge__kav> rcoa(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE RCOA_SoLR__c
        ];
    }

    private static List<Knowledge__kav> service(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Service_Standards__c
        ];
    }

    private static List<Knowledge__kav> others(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Others__c
        ];
    }

    private static List<Knowledge__kav> sa(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Service_Application__c
        ];
    }

    private static List<Knowledge__kav> deposit(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Handling_of_Deposits__c
        ];
    }

    private static List<Knowledge__kav> advance(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Cash_Advance__c
        ];
    }

    private static List<Knowledge__kav> special(){
        return [
            select Id, Title, Summary, ArticleNumber from Knowledge__kav
            where PublishStatus = 'Online'
            WITH DATA CATEGORY CXE__c ABOVE Special_Programs__c
        ];
    }

}