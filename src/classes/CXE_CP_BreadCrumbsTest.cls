/* 
 * Description: Test Class for CXE_CP_BreadCrumbs_CC
 * Author: Rom Edison Reyes (Accenture)
 * Date Created: JAN-02-2018
 */ 
@isTest
private class CXE_CP_BreadCrumbsTest {

    static testmethod void testBreadcrumbs_List() {
        //test method when only string is provided
        Test.startTest();
        List<CXE_CP_BreadCrumbs_CC.BreadCrumbWrapper> breadCrumbsList = CXE_CP_BreadCrumbs_CC.getBreadCrumbs('test1,test2', new List<String>());
        System.assertEquals(breadCrumbsList.size(), 0);
        Test.stopTest();
    }

    static testmethod void testBreadcrumbs_Source() {
        //test method when only source pages list is provided
        Test.startTest();
        List<String> sourcePages = new List<String>{'Accounts', 'dashboard'};
        List<CXE_CP_BreadCrumbs_CC.BreadCrumbWrapper> breadCrumbsList = CXE_CP_BreadCrumbs_CC.getBreadCrumbs(null, sourcePages);
        System.assertEquals(breadCrumbsList.size(), 2);
        Test.stopTest();
    }

    static testmethod void instantiate() {
        //test method when only source pages list is provided
        Test.startTest();
        CXE_CP_BreadCrumbs_CC breadcrumb = new CXE_CP_BreadCrumbs_CC();
        System.assertNotEquals(breadcrumb, null);
        Test.stopTest();
    }
}