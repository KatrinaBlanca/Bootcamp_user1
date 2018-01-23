@isTest
public class CXE_DMSUpload_ctrl_Test {
    @isTest static void DMS_Document_Test(){
        
        Test.startTest();
        CXE_TestDataFactory.setOrgSettings();
        PageReference pageRef = Page.CXE_Heroku_Redirect;
        pageRef.getParameters().put('target', 'test');
        Test.setCurrentPageReference (pageRef);
        
        CXE_DMSUpload_ctrl dms = new CXE_DMSUpload_ctrl();
        
        ApexPages.StandardController sc ;
        
        CXE_DMSUpload_ctrl dms2 = new CXE_DMSUpload_ctrl(sc);
        String redirectURL = dms2.redirect;
        String baseURL = dms2.base_url;
        
        CXE_DMSUpload_ctrl.upload_sign('123456789012345','123456789012340');
        CXE_DMSUpload_ctrl.rename_file('a', 'b', 'c');
        CXE_DMSUpload_ctrl.find_dms('a');
        CXE_DMSUpload_ctrl.error_log('a');
        CXE_DMSUpload_ctrl.check_service('123123');

        String token = dms.token;
        System.assert(token !=null);
        
        Test.stopTest();
    }
}