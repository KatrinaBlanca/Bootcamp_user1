/* Description: CXE_DMSUpload_ctrl test class
 * Author: Rom Edison Reyes
 * Date Created: SEP-10-17
 */
@isTest
private class CXE_DMSUpload_ctrlTest
{
    static testMethod void testGetToken(){
        CXE_DMSUpload_ctrl dmsCtrl = new CXE_DMSUpload_ctrl();
        String myToken = dmsCtrl .token;
        System.assertEquals(myToken, UserInfo.getOrganizationId() + '!' + CXE_Utility.getSecureToken());
    }
    
    static testMethod void testDMS(){
        DMS_Document__c dms = new DMS_Document__c();
        insert dms;
        ApexPages.StandardController sc = new ApexPages.StandardController(dms);
        CXE_DMSUpload_ctrl dmsCont = new CXE_DMSUpload_ctrl(sc);
        System.assertNotEquals(null, dmsCont.dms);
    }         
}