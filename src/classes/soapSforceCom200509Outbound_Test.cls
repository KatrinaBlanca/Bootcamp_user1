@isTest
private class soapSforceCom200509Outbound_Test
{   
    static testMethod void soapSforceCom200509OutboundTest() {
    new soapSforceCom200509Outbound.CaseNotification();
    Test.setMock(WebServiceMock.class, new soapSforceCom200509OutboundMockupcls());
    soapSforceCom200509Outbound.Notification notif = new  soapSforceCom200509Outbound.Notification();
    Boolean res = notif.notifications('OrganizationId','ActionId','SessionId','EnterpriseUrl','partnerUrl',new soapSforceCom200509Outbound.CaseNotification[]{});
    system.assert(res);
    }
}