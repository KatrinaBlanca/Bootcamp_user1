public class CXE_FOListView_CC {
    public class Response {
        @AuraEnabled
        public String message;

        @AuraEnabled
        public String status;

        @AuraEnabled
        public List<FieldOrder> fieldOrderList;

        public Response(){
            this.message = '';
            this.status = 'SUCCESS';
            this.fieldOrderList = new List<FieldOrder>();
        }
    }

    public class FieldOrder {
        @AuraEnabled
        public Boolean isCheck;
        @AuraEnabled
        public Id fieldOrderId;
        @AuraEnabled
        public String fieldOrderName;
        @AuraEnabled
        public String caseId;
        @AuraEnabled
        public String caseNumber;
        @AuraEnabled
        public Date scheduleDate;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public String address;
        @AuraEnabled
        public String landmark;
        @AuraEnabled
        public Date createdDate;
        @AuraEnabled
        public String recordTypeName;
        @AuraEnabled
        public List<FieldValues> fieldValues;
    }
    
    public class FieldValues {
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String fieldValue;
        @AuraEnabled
        public String section;
    }

    @AuraEnabled
    public static Response getFieldOrders(){        
        User currentUser;        
        FieldOrder fieldOrderTemp;
        Response res = new Response();
        Set<String> validRecordTypeSet;
        Set<String> validStatusSet = new Set<String>();     
        List<Field_Order__c> fieldOrderList = new List<Field_Order__c>();

        Map<String, List<String>> fieldsInspectionFOLayout = new Map<String, List<String>>{
            'Inspection'=>new List<String>{'Case__r.CaseNumber', 'Telephone_No__c', 'Status__c', 'Account_Name__c', 'Mobile_No__c', 'CreatedDate', 'Contact_Name__c', 'Email__c', 'Schedule_Date__c', 'Office__r.Name', 'Executing_Personnel_FO__c', 'Resolution_Date__c'}, 
                    'Instructions/Remarks' => new List<String>{'Inspection_Instructions__c'}, 
                        'Additional Information'=> new List<String>{'TLN__c', 'Pole_Code__c', 'Material__c', 'Metering_Scheme__c', 'Mode_of_Retrieval__c', 'Service_Wire_Size__c', 'Service_Wire_Length__c', 'Service_Wire_Type__c'}, 
                            'Resolution Details' => new List<String>{'Resolution_Remarks__c', 'Inspection_Result__c', 'Ready_for_Connection__c', 'SE_Not_Compliant__c', 'SE_Not_Installed_Yet__c', 'Wrong_SE_Location__c'}
        };
        Map<String, List<String>> fieldsMeterSocketFOLayout = new Map<String, List<String>>{
            'Meter Socket Delivery'=>new List<String>{'Case__r.CaseNumber', 'Telephone_No__c', 'Status__c', 'Account_Name__c', 'Mobile_No__c', 'CreatedDate', 'Contact_Name__c', 'Email__c', 'Schedule_Date__c', 'Office__r.Name', 'Executing_Personnel_FO__c', 'Resolution_Date__c'}, 
                'Instructions/Remarks' => new List<String>{'Meter_Socket_Delivery_Instructions__c'}, 
                    'Resolution Details' => new List<String>{'Resolution_Remarks__c', 'Meter_Socket_Delivery__c', 'SE_Completion_Target_Negotiated__c', 'Delivery_for_Reschedule__c', 'Contact_Person_Unreachable__c', 'For_BC_Pickup__c'}
        };
        Map<String, List<String>> fieldsReInspectionFOLayout = new Map<String, List<String>>{
            'Re-Inspection'=>new List<String>{'Case__r.CaseNumber', 'Telephone_No__c', 'Status__c', 'Account_Name__c', 'Mobile_No__c', 'CreatedDate', 'Contact_Name__c', 'Email__c', 'Schedule_Date__c', 'Office__r.Name', 'Executing_Personnel_FO__c', 'Resolution_Date__c'}, 
                'Additional Information'=> new List<String>{'TLN__c', 'Pole_Code__c', 'Material__c', 'Metering_Scheme__c', 'Mode_of_Retrieval__c', 'Service_Wire_Size__c', 'Service_Wire_Length__c', 'Service_Wire_Type__c'}, 
                    'Instructions/Remarks' => new List<String>{'Re_inspection_Instructions__c', 'Resolution_Remarks__c', 'Re_Inspection_Result__c', 'Ready_for_Connection__c', 'SE_Not_Compliant__c', 'SE_Not_Installed_Yet__c', 'Wrong_SE_Location__c'}
        };
        Map<String, List<String>> fieldsSurveyFOLayout = new Map<String, List<String>>{
            'Pre-Survey'=>new List<String>{'Case__r.CaseNumber', 'Telephone_No__c', 'Status__c', 'Account_Name__c', 'Mobile_No__c', 'CreatedDate', 'Contact_Name__c', 'Email__c', 'Schedule_Date__c', 'Office__r.Name', 'Executing_Personnel_FO__c', 'Resolution_Date__c'}, 
                'Instructions/Remarks' => new List<String>{'Survey_Instructions__c', 'Pick_Up_Document__c', 'Deliver_Document__c', 'Additional_Documents_for_Evaluation_Requ__c'},
                    'Resolution Details' => new List<String>{'Resolution_Remarks__c', 'Pre_Survey_Result__c', 'Inconsistent_SA_Data_Required__c', 'ROW_Grant_for_SE_Required__c', 'Extensive_modifications_to_premises_requ__c', 'Unable_to_Locate_Given_Address__c', 'Add_Distribution_Facilities_Required__c'}
        };

        validRecordTypeSet = new Set<String>{
            'Energization FO',
            'Inspection FO',
            'Meter Socket Delivery',
            'Re-Inspection FO',
            'Survey FO'
        };

        for(String status : Label.FO_Status_Filter.trim().split(';')){
            validStatusSet.add(status.trim());
        }

        try{
            currentUser = [SELECT Id, Name, Office__c, ProfileId, Profile.Name
                           FROM User 
                           WHERE Id =: UserInfo.getUserId()];
        } catch(Exception e){
            res.status = 'FAILED';
            res.message = e.getMessage();
        }

        try{
            if(res.status != 'FAILED'){
                if(currentUser.Office__c != null){
                    fieldOrderList = [SELECT Id, Name, Case__c, Case__r.CaseNumber, Mobile_No__c, Email__c, Address__c, Landmarks__c, Status__c, Schedule_Date__c, CreatedDate, Meter_Socket_Delivery_Instructions__c,
                                      RecordType.Name, Account_Name__c, Contact_Name__c, Telephone_No__c, Resolution_Date__c, Office__r.Name, Executing_Personnel_FO__r.Name, Inspection_Instructions__c, 
                                      TLN__c, Pole_Code__c, Material__c, Metering_Scheme__c, Mode_of_Retrieval__c, Service_Wire_Size__c, Service_Wire_Length__c, Service_Wire_Type__c, Resolution_Remarks__c, 
                                      Inspection_Result__c, Ready_for_Connection__c, SE_Not_Compliant__c, SE_Not_Installed_Yet__c, Wrong_SE_Location__c, Meter_Socket_Delivery__c, SE_Completion_Target_Negotiated__c,
                                      Delivery_for_Reschedule__c, Contact_Person_Unreachable__c, For_BC_Pickup__c, Re_inspection_Instructions__c, Re_Inspection_Result__c, Survey_Instructions__c, Pick_Up_Document__c, 
                                      Deliver_Document__c, Additional_Documents_for_Evaluation_Requ__c, Pre_Survey_Result__c, Inconsistent_SA_Data_Required__c, ROW_Grant_for_SE_Required__c, Extensive_modifications_to_premises_requ__c,
                                      Unable_to_Locate_Given_Address__c, Add_Distribution_Facilities_Required__c
                                      FROM Field_Order__c
                                      WHERE Status__c IN: validStatusSet
                                        AND RecordType.Name IN: validRecordTypeSet
                                        AND Office__r.Name =: currentUser.Office__c
                                      ORDER BY Name];
                } else if(currentUser.Profile.Name.equalsIgnoreCase('System Administrator')){
                    fieldOrderList = [SELECT Id, Name, Case__c, Case__r.CaseNumber, Mobile_No__c, Email__c, Address__c, Landmarks__c, Status__c, Schedule_Date__c, CreatedDate, Meter_Socket_Delivery_Instructions__c,
                                      RecordType.Name, Account_Name__c, Contact_Name__c, Telephone_No__c, Resolution_Date__c, Office__r.Name, Executing_Personnel_FO__r.Name, Inspection_Instructions__c, 
                                      TLN__c, Pole_Code__c, Material__c, Metering_Scheme__c, Mode_of_Retrieval__c, Service_Wire_Size__c, Service_Wire_Length__c, Service_Wire_Type__c, Resolution_Remarks__c, 
                                      Inspection_Result__c, Ready_for_Connection__c, SE_Not_Compliant__c, SE_Not_Installed_Yet__c, Wrong_SE_Location__c, Meter_Socket_Delivery__c, SE_Completion_Target_Negotiated__c,
                                      Delivery_for_Reschedule__c, Contact_Person_Unreachable__c, For_BC_Pickup__c, Re_inspection_Instructions__c, Re_Inspection_Result__c, Survey_Instructions__c, Pick_Up_Document__c, 
                                      Deliver_Document__c, Additional_Documents_for_Evaluation_Requ__c, Pre_Survey_Result__c, Inconsistent_SA_Data_Required__c, ROW_Grant_for_SE_Required__c, Extensive_modifications_to_premises_requ__c,
                                      Unable_to_Locate_Given_Address__c, Add_Distribution_Facilities_Required__c
                                      FROM Field_Order__c
                                      WHERE Status__c IN: validStatusSet
                                        AND RecordType.Name IN: validRecordTypeSet
                                      ORDER BY Name];
                } else {
                    res.status = 'NO RECORDS';
                    res.message = 'No records available';
                }

                for(Field_Order__c fieldOrder : fieldOrderList){
                    fieldOrderTemp = new FieldOrder();

                    fieldOrderTemp.isCheck = false;
                    fieldOrderTemp.fieldOrderId = fieldOrder.Id;
                    fieldOrderTemp.fieldOrderName = fieldOrder.Name;
                    fieldOrderTemp.caseId = fieldOrder.Case__c;
                    fieldOrderTemp.caseNumber = fieldOrder.Case__r.CaseNumber;
                    fieldOrderTemp.scheduleDate = fieldOrder.Schedule_Date__c;
                    fieldOrderTemp.status = fieldOrder.Status__c;
                    fieldOrderTemp.createdDate = fieldOrder.CreatedDate.date();
                    fieldOrderTemp.recordTypeName = fieldOrder.RecordType.Name;
                    fieldOrderTemp.address = fieldOrder.Address__c <> null ? fieldOrder.Address__c : '';
                    fieldOrderTemp.landmark = fieldOrder.Landmarks__c <> null ? fieldOrder.Landmarks__c : '';
                    fieldOrderTemp.fieldValues = new List<FieldValues>();
                    
                    Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Field_Order__c').getDescribe().fields.getMap();
                    Map<String, List<String>> fieldSets = new Map<String, List<String>>();
                    
                    if(fieldOrder.RecordType.Name == 'Inspection FO'){
                        fieldSets = fieldsInspectionFOLayout;
                    }else if(fieldOrder.RecordType.Name == 'Meter Socket Delivery'){
                        fieldSets = fieldsMeterSocketFOLayout;
                    }else if(fieldOrder.RecordType.Name == 'Re-Inspection FO'){
                        fieldSets = fieldsReInspectionFOLayout;
                    }else if(fieldOrder.RecordType.Name == 'Survey FO'){
                        fieldSets = fieldsSurveyFOLayout;
                    }
                    
                    for(String section : fieldSets.keySet()){
                        for(String fieldName: fieldSets.get(section)){
                            FieldValues fv = new FieldValues();
                            fv.section = section;
                            
                            if(fieldName.split('\\.').size() == 2){
                                String name = fieldName.split('\\.')[0].replace('__r', '__c');
                                fv.fieldName = String.valueOf(fieldMap.get(name).getDescribe().getLabel());
                            }else{
                                fv.fieldName = String.valueOf(fieldMap.get(fieldName).getDescribe().getLabel());
                            }
                            
                            if(fieldName <> 'Executing_Personnel_FO__c'){
                                if(fieldName.split('\\.').size() == 2 && fieldOrder.getSobject(fieldName.split('\\.')[0]) <> null){
                                    fv.fieldValue = fieldOrder.getSobject(fieldName.split('\\.')[0]).get(fieldName.split('\\.')[1]) <> null ? String.valueOf(fieldOrder.getSobject(fieldName.split('\\.')[0]).get(fieldName.split('\\.')[1])) : '';
                                }else if(fieldName.split('\\.').size() == 2 && fieldOrder.getSobject(fieldName.split('\\.')[0]) == null){
                                    fv.fieldValue = '';
                                }else{
                                    fv.fieldValue = fieldOrder.get(fieldName) <> null ? String.valueOf(fieldOrder.get(fieldName)) : '';
                                }
                            }else{
                                fv.fieldValue = fieldOrder.Executing_Personnel_FO__r.Name != null ? fieldOrder.Executing_Personnel_FO__r.Name : '';
                            }
                            
                            fieldOrderTemp.fieldValues.add(fv);
                        }
                    }
                    
                    res.fieldOrderList.add(fieldOrderTemp);
                }
            }
        } catch(Exception e){
            res.status = 'FAILED';
            res.message = e.getMessage() + '>>' + e.getStackTraceString();
        }

        return res;
    }
}