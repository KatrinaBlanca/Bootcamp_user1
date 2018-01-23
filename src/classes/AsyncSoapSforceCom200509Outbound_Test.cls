@isTest
private class AsyncSoapSforceCom200509Outbound_Test
{   
    static testMethod void AsyncSoapSforceCom200509OutboundTest() {
    Test.setMock(WebServiceMock.class, new AsyncSoapSforceCom200509OutboundMockcls());
    AsyncSoapSforceCom200509Outbound.AsyncNotification asyncNotif = new  AsyncSoapSforceCom200509Outbound.AsyncNotification();
    AsyncSoapSforceCom200509Outbound.notificationsResponse_elementFuture res = asyncNotif.beginNotifications(new Continuation(120),'OrganizationId','ActionId','SessionId','EnterpriseUrl','PartnerUrl',new soapSforceCom200509Outbound.CaseNotification[]{});
    system.assertNotEquals(res, null);
    }
}