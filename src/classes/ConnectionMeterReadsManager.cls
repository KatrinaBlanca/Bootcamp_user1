public class ConnectionMeterReadsManager {
/*
    public String connectionId {get; set;}
    public Map<Date, MeterRead> meterReads {get; set;} 
    public Case_Connection__c newManualMeterRead {get; set;}
    
    public ConnectionMeterReadsManager(String connectionId) {
        this.connectionId = connectionId;
        
        meterReads = new Map<Date, MeterRead>();
    }
  
    public void fetchMeterReads() {
        Date d1 = Date.newInstance(2013, 5, 23);
        meterReads.put(d1, new MeterRead(d1, 433));
        
        Date d2 = Date.newInstance(2013, 11, 5);
        meterReads.put(d2, new MeterRead(d2, 657));
        
        Date d3 = Date.newInstance(2014, 4, 30);
        meterReads.put(d3, new MeterRead(d3, 812));
        
        Date d4 = Date.newInstance(2014, 10, 14);
        meterReads.put(d4, new MeterRead(d4, 1011));
        
        Date d5 = Date.newInstance(2015, 3, 29);
        meterReads.put(d5, new MeterRead(d5, 1267));
    }

    public String meterReadsAsGoogleChartsJson {
        get {
            String s = '[[{type: \'date\', label: \'Date\'}, \'Index\', {role: \'certainty\'}]';
            for (MeterRead meterRead: meterReads.values()) {
                s += ', [\'Date(' + meterRead.meterReadDate.year() + ', ' + meterRead.meterReadDate.month() + 
                    ', ' + meterRead.meterReadDate.day() + ')\', ' + meterRead.meterReadValue + ', true]';
            }
            
            if (newManualMeterRead.Meter_Read_Date__c != null && newManualMeterRead.Meter_Read_Value__c != null) {
                s += ', [\'Date(' + newManualMeterRead.Meter_Read_Date__c.year() + ', ' + newManualMeterRead.Meter_Read_Date__c.month() + 
                    ', ' + newManualMeterRead.Meter_Read_Date__c.day() + ')\', ' + newManualMeterRead.Meter_Read_Value__c + ', false]';
            }
            
            s += ']';
            return s;
        }
    }
    
    class MeterRead {
        public Date meterReadDate {get; set;}
        public Double meterReadValue {get; set;}
        
        public MeterRead(Date meterReadDate, Double meterReadValue) {
            this.meterReadDate = meterReadDate;
            this.meterReadValue = meterReadValue;
        }
    }
 */   
}