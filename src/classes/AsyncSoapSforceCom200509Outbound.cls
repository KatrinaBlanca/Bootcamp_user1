//Generated by wsdl2apex

public class AsyncSoapSforceCom200509Outbound {
    public class notificationsResponse_elementFuture extends System.WebServiceCalloutFuture {
        public Boolean getValue() {
            soapSforceCom200509Outbound.notificationsResponse_element response = (soapSforceCom200509Outbound.notificationsResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.Ack;
        }
    }
    public class AsyncNotification {
        public String endpoint_x = 'https://provide.castiron.ibmcloud.com:443/env/Production/meralcoSFDC';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/2005/09/outbound', 'soapSforceCom200509Outbound', 'urn:sobject.enterprise.soap.sforce.com', 'sobjectEnterpriseSoapSforceCom', 'urn:enterprise.soap.sforce.com', 'enterpriseSoapSforceCom'};
        public AsyncSoapSforceCom200509Outbound.notificationsResponse_elementFuture beginNotifications(System.Continuation continuation,String OrganizationId,String ActionId,String SessionId,String EnterpriseUrl,String PartnerUrl,soapSforceCom200509Outbound.CaseNotification[] Notification) {
            soapSforceCom200509Outbound.notifications_element request_x = new soapSforceCom200509Outbound.notifications_element();
            request_x.OrganizationId = OrganizationId;
            request_x.ActionId = ActionId;
            request_x.SessionId = SessionId;
            request_x.EnterpriseUrl = EnterpriseUrl;
            request_x.PartnerUrl = PartnerUrl;
            request_x.Notification = Notification;
            return (AsyncSoapSforceCom200509Outbound.notificationsResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncSoapSforceCom200509Outbound.notificationsResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2005/09/outbound',
              'notifications',
              'http://soap.sforce.com/2005/09/outbound',
              'notificationsResponse',
              'soapSforceCom200509Outbound.notificationsResponse_element'}
            );
        }
    }
}