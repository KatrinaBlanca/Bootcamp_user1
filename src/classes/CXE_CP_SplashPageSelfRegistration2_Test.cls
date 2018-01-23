@isTest
private class CXE_CP_SplashPageSelfRegistration2_Test {
    
    
    
    @testSetup static void setup(){
        
        CXE_TestDataFactory.setupPortalData('3', true);
        
        
    }
     
       @isTest static void createUserTestTrue() {
        // Implement test code
        Test.startTest();
        
       
        CXE_CP_SplashPageSelfRegistration_CC splashPageSelfReg = new CXE_CP_SplashPageSelfRegistration_CC();
       
        
        List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
    
        try{
            
            if(!portalUsers.isEmpty()) {
                
           
                
                System.runAs(portalUsers.get(0)){
                    String email = 'cxe_tcuser2@test.com';
                    String fName = 'mfNametc2';
                    String mName = 'mmNametc2';
                    String lName = 'mlNametc2';
                    String suffix = '';
                    String mobile = '+639999999999';
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2017-10-15';
                    CXE_CP_SplashPageSelfRegistration_CC.Response response =
                        CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, True);
                    
                    System.assertEquals(CXE_Constants.PORTAL_REGISTRATION_ERROR_HAS_EXISTING_BILLING_RECORD, response.message);
                }                           
                
            }
            
        } catch (Exception e) {
            System.assertEquals('', e.getMessage());
        }
        Test.stopTest();
    }
    
   
    @isTest static void createUserTestFalse() {
        // Implement test code
        Test.startTest();
        
       
        CXE_CP_SplashPageSelfRegistration_CC splashPageSelfReg = new CXE_CP_SplashPageSelfRegistration_CC();
       
        
        List<User> portalUsers = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];
    
        try{
            
            if(!portalUsers.isEmpty()) {
                
           
                
                System.runAs(portalUsers.get(0)){
                    String email = 'cxe_tcuser2@test.com';
                    String fName = 'mfNametc2';
                    String mName = 'mmNametc2';
                    String lName = 'mlNametc2';
                    String suffix = '';
                    String mobile = '+639999999999';
                    String sin = '293028374839';
                    Decimal amt = 300;
                    String txnDate = '2017-10-15';
                    CXE_CP_SplashPageSelfRegistration_CC.Response response =
                        CXE_CP_SplashPageSelfRegistration_CC.createUser(email, fName, mName, lName, suffix, mobile, sin, amt, txnDate, false);
                    
                    //System.assertEquals(null, response.message);
                }                           
                
            }
            
        } catch (Exception e) {
            System.assertEquals('', e.getMessage());
        }
        Test.stopTest();
    }
    
       
     @isTest static void getHiearchySettings_Test() {
        // Implement test code
        Test.startTest();
         CXE_TestDataFactory.setOrgSettings(); 
        
       String hierarchy = CXE_CP_SplashPageSelfRegistration_CC.getHiearchySettings();
       System.assertEquals(null,hierarchy );
       
        Test.stopTest();
    }
    
    
}