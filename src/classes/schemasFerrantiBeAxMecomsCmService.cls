//Generated by wsdl2apex

public class schemasFerrantiBeAxMecomsCmService {
// Commenting out the Code to increase Code coverage as this is Mecom Class
    /*
    public class WebUserServiceGetLostPasswordRequest_element {
        public String x_userName;
        private String[] x_userName_type_info = new String[]{'_userName','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_userName'};
    }
    public class MeterReadingServicePreviousMeterReadingRequest_element {
        public schemasDatacontractOrg200407Dynamic.ArrayOfConnection x_connections;
        public DateTime x_startDate;
        public DateTime x_endDate;
        private String[] x_connections_type_info = new String[]{'_connections','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_startDate_type_info = new String[]{'_startDate','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_endDate_type_info = new String[]{'_endDate','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_connections','x_startDate','x_endDate'};
    }
    public class PortfolioServiceGetPersonalInfoResponse_element {
        public schemasDatacontractOrg200407Dynamic.PersonalInfo response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class InvoiceServiceGetInvoiceOverviewResponse_element {
        public schemasDatacontractOrg200407Dynamic.ArrayOfInvoiceOverview response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class CustomerServiceGetTopicsRequest_element {
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class MeterReadingServiceMeterReadingResponse_element {
        public Boolean response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class InvoiceServiceGetInvoiceDetailsRequest_element {
        public Long x_invoiceRefRecId;
        public String x_languageId;
        private String[] x_invoiceRefRecId_type_info = new String[]{'_invoiceRefRecId','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_languageId_type_info = new String[]{'_languageId','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_invoiceRefRecId','x_languageId'};
    }
    public class CustomerServiceLogActivityResponse_element {
        public Boolean response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class ConsumptionServiceGetConsumptionRequest_element {
        public String x_measurementType;
        public schemasDatacontractOrg200407Dynamic.ArrayOfConnection x_connections;
        public String x_languageId;
        public DateTime x_startDate;
        public DateTime x_endDate;
        public String x_timeResolution;
        private String[] x_measurementType_type_info = new String[]{'_measurementType','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_connections_type_info = new String[]{'_connections','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_languageId_type_info = new String[]{'_languageId','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_startDate_type_info = new String[]{'_startDate','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_endDate_type_info = new String[]{'_endDate','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_timeResolution_type_info = new String[]{'_timeResolution','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_measurementType','x_connections','x_languageId','x_startDate','x_endDate','x_timeResolution'};
    }
    public class PortfolioServiceGetPersonalInfoRequest_element {
        public String x_userName;
        public String x_language;
        private String[] x_userName_type_info = new String[]{'_userName','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_language_type_info = new String[]{'_language','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_userName','x_language'};
    }
    public class InvoiceServiceGetInvoicesRequest_element {
        public schemasDatacontractOrg200407Dynamic.ArrayOfConnection x_connections;
        public String x_languageId;
        public DateTime x_startDate;
        public DateTime x_endDate;
        private String[] x_connections_type_info = new String[]{'_connections','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_languageId_type_info = new String[]{'_languageId','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_startDate_type_info = new String[]{'_startDate','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_endDate_type_info = new String[]{'_endDate','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_connections','x_languageId','x_startDate','x_endDate'};
    }
    public class WebUserServiceRegisterResponse_element {
        public String response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class ConsumptionServiceGetConsumptionResponse_element {
        public schemasDatacontractOrg200407Dynamic.ArrayOfConsumption response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class MeterReadingServiceMeterReadingRequest_element {
        public schemasDatacontractOrg200407Dynamic.Device x_meterDevice;
        public Long x_portfolioId;
        public String x_portfolioType;
        public String x_userMemo;
        public String x_category;
        private String[] x_meterDevice_type_info = new String[]{'_meterDevice','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_portfolioId_type_info = new String[]{'_portfolioId','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_portfolioType_type_info = new String[]{'_portfolioType','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_userMemo_type_info = new String[]{'_userMemo','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_category_type_info = new String[]{'_category','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_meterDevice','x_portfolioId','x_portfolioType','x_userMemo','x_category'};
    }
    public class PortfolioServiceSetPersonalInfoRequest_element {
        public String x_userName;
        public String x_email;
        public String x_authAuthority;
        public String x_password;
        private String[] x_userName_type_info = new String[]{'_userName','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_email_type_info = new String[]{'_email','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_authAuthority_type_info = new String[]{'_authAuthority','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_password_type_info = new String[]{'_password','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_userName','x_email','x_authAuthority','x_password'};
    }
    public class WebUserServiceRegisterRequest_element {
        public String x_authAuthority;
        public String x_custAccount;
        public String x_invoiceId;
        public String x_userName;
        public String x_password;
        public String x_email;
        private String[] x_authAuthority_type_info = new String[]{'_authAuthority','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_custAccount_type_info = new String[]{'_custAccount','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_invoiceId_type_info = new String[]{'_invoiceId','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_userName_type_info = new String[]{'_userName','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_password_type_info = new String[]{'_password','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_email_type_info = new String[]{'_email','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_authAuthority','x_custAccount','x_invoiceId','x_userName','x_password','x_email'};
    }
    public class MeterReadingServicePreviousMeterReadingResponse_element {
        public schemasDatacontractOrg200407Dynamic.ArrayOfDevice response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class InvoiceServiceGetInvoicesResponse_element {
        public schemasDatacontractOrg200407Dynamic.ArrayOfInvoiceSummary response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class ConnectionServiceGetConnectionsRequest_element {
        public String x_userName;
        public String x_portfolioType;
        public Long x_portfolioId;
        public String x_languageId;
        public DateTime x_startDateTime;
        public DateTime x_endDateTime;
        private String[] x_userName_type_info = new String[]{'_userName','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_portfolioType_type_info = new String[]{'_portfolioType','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_portfolioId_type_info = new String[]{'_portfolioId','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_languageId_type_info = new String[]{'_languageId','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_startDateTime_type_info = new String[]{'_startDateTime','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_endDateTime_type_info = new String[]{'_endDateTime','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_userName','x_portfolioType','x_portfolioId','x_languageId','x_startDateTime','x_endDateTime'};
    }
    public class PortfolioServiceSetPersonalInfoResponse_element {
        public Boolean response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class PortfolioServiceSetPersonalDescriptionResponse_element {
        public Boolean response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class WebUserServiceGetLostPasswordResponse_element {
        public String response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class PortfolioServiceSetPersonalDescriptionRequest_element {
        public String x_userName;
        public String x_descriptionType;
        public Long x_refRecId;
        public String x_description;
        private String[] x_userName_type_info = new String[]{'_userName','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_descriptionType_type_info = new String[]{'_descriptionType','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_refRecId_type_info = new String[]{'_refRecId','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_description_type_info = new String[]{'_description','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_userName','x_descriptionType','x_refRecId','x_description'};
    }
    public class WebUserServiceLoginRequest_element {
        public String x_authAuthority;
        public String x_userName;
        public String x_password;
        private String[] x_authAuthority_type_info = new String[]{'_authAuthority','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_userName_type_info = new String[]{'_userName','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_password_type_info = new String[]{'_password','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_authAuthority','x_userName','x_password'};
    }
    public class CustomerServiceGetActivitiesResponse_element {
        public schemasDatacontractOrg200407Dynamic.ArrayOfActivity response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class CustomerServiceLogActivityRequest_element {
        public Long x_portfolioId;
        public String x_portfolioType;
        public String x_topicName;
        public String x_userMemo;
        public String x_category;
        public String x_activityType;
        private String[] x_portfolioId_type_info = new String[]{'_portfolioId','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_portfolioType_type_info = new String[]{'_portfolioType','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_topicName_type_info = new String[]{'_topicName','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_userMemo_type_info = new String[]{'_userMemo','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_category_type_info = new String[]{'_category','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_activityType_type_info = new String[]{'_activityType','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_portfolioId','x_portfolioType','x_topicName','x_userMemo','x_category','x_activityType'};
    }
    public class WebUserServiceLoginResponse_element {
        public String response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class CustomerServiceGetActivitiesRequest_element {
        public Long x_portfolioId;
        public String x_portfolioType;
        private String[] x_portfolioId_type_info = new String[]{'_portfolioId','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_portfolioType_type_info = new String[]{'_portfolioType','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_portfolioId','x_portfolioType'};
    }
    public class InvoiceServiceGetInvoiceOverviewRequest_element {
        public schemasDatacontractOrg200407Dynamic.ArrayOfConnection x_connections;
        public String x_languageId;
        public DateTime x_startDate;
        public DateTime x_endDate;
        private String[] x_connections_type_info = new String[]{'_connections','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_languageId_type_info = new String[]{'_languageId','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] x_startDate_type_info = new String[]{'_startDate','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] x_endDate_type_info = new String[]{'_endDate','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'x_connections','x_languageId','x_startDate','x_endDate'};
    }
    public class ConnectionServiceGetConnectionsResponse_element {
        public schemasDatacontractOrg200407Dynamic.PortfolioConnection response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class CustomerServiceGetTopicsResponse_element {
        public schemasMicrosoftCom200310Serializat.ArrayOfstring response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class InvoiceServiceGetInvoiceDetailsResponse_element {
        public schemasDatacontractOrg200407Dynamic.ArrayOfInvoiceDetail response;
        private String[] response_type_info = new String[]{'response','http://schemas.ferranti.be/ax/mecoms/cm/services',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.ferranti.be/ax/mecoms/cm/services','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class BasicHttpBinding_ITwoWayAsync {
        public String endpoint_x = 'http://144.36.167.58/ARPUDev/MessageHandler.svc';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/Arrays', 'schemasMicrosoftCom200310Serializat', 'http://schemas.datacontract.org/2004/07/Microsoft.Dynamics.AX.Framework.Services', 'schemasDatacontractOrg200407Microso', 'http://schemas.microsoft.com/dynamics/2008/01/documents/Fault', 'schemasMicrosoftComDynamics200801D', 'http://schemas.datacontract.org/2004/07/Dynamics.Ax.Application', 'schemasDatacontractOrg200407Dynamic', 'http://schemas.microsoft.com/2003/10/Serialization/', 'schemasMicrosoftCom200310Serializat', 'http://schemas.datacontract.org/2004/07/Microsoft.Dynamics.Ax.Xpp', 'schemasDatacontractOrg200407Microso', 'http://schemas.microsoft.com/dynamics/2010/01/datacontracts', 'schemasMicrosoftComDynamics201001D', 'http://schemas.ferranti.be/ax/mecoms/cm/services', 'schemasFerrantiBeAxMecomsCmService'};
        public schemasDatacontractOrg200407Dynamic.ArrayOfDevice ProcessRequest(schemasDatacontractOrg200407Dynamic.ArrayOfConnection x_connections,DateTime x_startDate,DateTime x_endDate) {
            schemasFerrantiBeAxMecomsCmService.MeterReadingServicePreviousMeterReadingRequest_element request_x = new schemasFerrantiBeAxMecomsCmService.MeterReadingServicePreviousMeterReadingRequest_element();
            request_x.x_connections = x_connections;
            request_x.x_startDate = x_startDate;
            request_x.x_endDate = x_endDate;
            schemasFerrantiBeAxMecomsCmService.MeterReadingServicePreviousMeterReadingResponse_element response_x;
            Map<String, schemasFerrantiBeAxMecomsCmService.MeterReadingServicePreviousMeterReadingResponse_element> response_map_x = new Map<String, schemasFerrantiBeAxMecomsCmService.MeterReadingServicePreviousMeterReadingResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'ProcessRequest',
              'http://schemas.ferranti.be/ax/mecoms/cm/services',
              'MeterReadingServicePreviousMeterReadingRequest',
              'http://schemas.ferranti.be/ax/mecoms/cm/services',
              'MeterReadingServicePreviousMeterReadingResponse',
              'schemasFerrantiBeAxMecomsCmService.MeterReadingServicePreviousMeterReadingResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.response;
        }
    }
    */
    //End of Comment
}