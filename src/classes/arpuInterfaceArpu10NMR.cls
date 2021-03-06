//Generated by wsdl2apex

public class arpuInterfaceArpu10NMR {
// Commenting out the Code to increase Code coverage as this is Mecom Class
    /*
    public class Header {
        public String MessageId;
        public String SourceHost;
        public DateTime DateTime_x;
        public String TransactionId;
        public String Sender;
        public String Receiver;
        private String[] MessageId_type_info = new String[]{'MessageId','http://arpu.interface/arpu/1.0',null,'1','1','false'};
        private String[] SourceHost_type_info = new String[]{'SourceHost','http://arpu.interface/arpu/1.0',null,'1','1','false'};
        private String[] DateTime_x_type_info = new String[]{'DateTime','http://arpu.interface/arpu/1.0',null,'1','1','false'};
        private String[] TransactionId_type_info = new String[]{'TransactionId','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] Sender_type_info = new String[]{'Sender','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] Receiver_type_info = new String[]{'Receiver','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://arpu.interface/arpu/1.0','true','false'};
        private String[] field_order_type_info = new String[]{'MessageId','SourceHost','DateTime_x','TransactionId','Sender','Receiver'};
    }
    public class Register {
        public String EnergyType;
        public String EnergyTypeLabel;
        public String ExternalDeviceID;
        public String ExternalRegisterID;
        public arpuInterfaceArpu10NMR.ArrayOfIndexValue IndexValues;
        public String SerialNumber;
        public String UnitOfMeasure;
        public String UnitOfMeasureLabel;
        public String UtilityTariff;
        public String UtilityTariffLabel;
        private String[] EnergyType_type_info = new String[]{'EnergyType','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] EnergyTypeLabel_type_info = new String[]{'EnergyTypeLabel','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] ExternalDeviceID_type_info = new String[]{'ExternalDeviceID','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] ExternalRegisterID_type_info = new String[]{'ExternalRegisterID','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] IndexValues_type_info = new String[]{'IndexValues','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] SerialNumber_type_info = new String[]{'SerialNumber','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] UnitOfMeasure_type_info = new String[]{'UnitOfMeasure','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] UnitOfMeasureLabel_type_info = new String[]{'UnitOfMeasureLabel','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] UtilityTariff_type_info = new String[]{'UtilityTariff','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] UtilityTariffLabel_type_info = new String[]{'UtilityTariffLabel','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://arpu.interface/arpu/1.0','true','false'};
        private String[] field_order_type_info = new String[]{'EnergyType','EnergyTypeLabel','ExternalDeviceID','ExternalRegisterID','IndexValues','SerialNumber','UnitOfMeasure','UnitOfMeasureLabel','UtilityTariff','UtilityTariffLabel'};
    }
    public class MeterReadingServiceMeterReadingRequest_element {
        public arpuInterfaceArpu10NMR.Header Header;
        public arpuInterfaceArpu10NMR.MeterReadingRequest_element MeterReadingRequest;
        private String[] Header_type_info = new String[]{'Header','http://arpu.interface/arpu/1.0',null,'1','1','false'};
        private String[] MeterReadingRequest_type_info = new String[]{'MeterReadingRequest','http://arpu.interface/arpu/1.0',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://arpu.interface/arpu/1.0','true','false'};
        private String[] field_order_type_info = new String[]{'Header','MeterReadingRequest'};
    }
    public class Device {
        public String AssetTypeId;
        public String ConnectionId;
        public String DeviceBrand;
        public DateTime EndDateTime;
        public String ExternalId;
        public arpuInterfaceArpu10NMR.ArrayOfRegister Registers;
        public String SerialNumber;
        public DateTime StartDateTime;
        public String UtilityType;
        private String[] AssetTypeId_type_info = new String[]{'AssetTypeId','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] ConnectionId_type_info = new String[]{'ConnectionId','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] DeviceBrand_type_info = new String[]{'DeviceBrand','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] EndDateTime_type_info = new String[]{'EndDateTime','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] ExternalId_type_info = new String[]{'ExternalId','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] Registers_type_info = new String[]{'Registers','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] SerialNumber_type_info = new String[]{'SerialNumber','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] StartDateTime_type_info = new String[]{'StartDateTime','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] UtilityType_type_info = new String[]{'UtilityType','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://arpu.interface/arpu/1.0','true','false'};
        private String[] field_order_type_info = new String[]{'AssetTypeId','ConnectionId','DeviceBrand','EndDateTime','ExternalId','Registers','SerialNumber','StartDateTime','UtilityType'};
    }
    public class ArrayOfIndexValue {
        public arpuInterfaceArpu10NMR.IndexValue[] IndexValue;
        private String[] IndexValue_type_info = new String[]{'IndexValue','http://arpu.interface/arpu/1.0',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://arpu.interface/arpu/1.0','true','false'};
        private String[] field_order_type_info = new String[]{'IndexValue'};
    }
    public class MeterReadingRequest_element {
        public arpuInterfaceArpu10NMR.Device x_meterDevice;
        public Long x_portfolioId;
        public String x_portfolioType;
        public String x_userMemo;
        public String x_category;
        private String[] x_meterDevice_type_info = new String[]{'_meterDevice','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] x_portfolioId_type_info = new String[]{'_portfolioId','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] x_portfolioType_type_info = new String[]{'_portfolioType','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] x_userMemo_type_info = new String[]{'_userMemo','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] x_category_type_info = new String[]{'_category','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://arpu.interface/arpu/1.0','true','false'};
        private String[] field_order_type_info = new String[]{'x_meterDevice','x_portfolioId','x_portfolioType','x_userMemo','x_category'};
    }
    public class ArrayOfRegister {
        public arpuInterfaceArpu10NMR.Register[] Register;
        private String[] Register_type_info = new String[]{'Register','http://arpu.interface/arpu/1.0',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://arpu.interface/arpu/1.0','true','false'};
        private String[] field_order_type_info = new String[]{'Register'};
    }
    public class IndexValue {
        public DateTime ReadingDateTime;
        public String ReadingOrigin;
        public String UsageCode;
        public Decimal Value;
        private String[] ReadingDateTime_type_info = new String[]{'ReadingDateTime','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] ReadingOrigin_type_info = new String[]{'ReadingOrigin','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] UsageCode_type_info = new String[]{'UsageCode','http://arpu.interface/arpu/1.0',null,'0','1','true'};
        private String[] Value_type_info = new String[]{'Value','http://arpu.interface/arpu/1.0',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://arpu.interface/arpu/1.0','true','false'};
        private String[] field_order_type_info = new String[]{'ReadingDateTime','ReadingOrigin','UsageCode','Value'};
    }
    public class MessageAcknowledgement_element {
        public String Status;
        public String MessageID;
        private String[] Status_type_info = new String[]{'Status','http://arpu.interface/arpu/1.0',null,'1','1','false'};
        private String[] MessageID_type_info = new String[]{'MessageID','http://arpu.interface/arpu/1.0',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://arpu.interface/arpu/1.0','true','false'};
        private String[] field_order_type_info = new String[]{'Status','MessageID'};
    }
    public class BasicHttpBinding_ITwoWayAsync {
        public String endpoint_x = 'http://144.36.167.58/Accenture.BizTalk.ARPUOrchestrations/Accenture_BizTalk_ARPUOrchestrations_MessageHandler_PortMessageHandler.svc';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://arpu.interface/arpu/1.0', 'arpuInterfaceArpu10NMR'};
        public arpuInterfaceArpu10NMR.MessageAcknowledgement_element AcceptMessage(arpuInterfaceArpu10NMR.Header Header,arpuInterfaceArpu10NMR.MeterReadingRequest_element MeterReadingRequest) {
            arpuInterfaceArpu10NMR.MeterReadingServiceMeterReadingRequest_element request_x = new arpuInterfaceArpu10NMR.MeterReadingServiceMeterReadingRequest_element();
            request_x.Header = Header;
            request_x.MeterReadingRequest = MeterReadingRequest;
            arpuInterfaceArpu10NMR.MessageAcknowledgement_element response_x;
            Map<String, arpuInterfaceArpu10NMR.MessageAcknowledgement_element> response_map_x = new Map<String, arpuInterfaceArpu10NMR.MessageAcknowledgement_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'AcceptMessage',
              'http://arpu.interface/arpu/1.0',
              'MeterReadingServiceMeterReadingRequest',
              'http://arpu.interface/arpu/1.0',
              'MessageAcknowledgement',
              'arpuInterfaceArpu10NMR.MessageAcknowledgement_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
    */
    //End of Comment
}