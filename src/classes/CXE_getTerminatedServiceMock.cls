@isTest
@RestResource(urlMapping='/getTerminatedService/*')
global with sharing class CXE_getTerminatedServiceMock {
	
	@HttpPost
	global static case CXE_getTerminatedServiceMock(String sin) {
		
		case terminateService = new case();
		terminateService.Service_Address_Landmarks_Directions__c = 'Service_Address_Landmarks_Directions__c';
		terminateService.Last_Name_Business_Name__c = 'Last_Name_Business_Name__c';
		terminateService.Doing_Business_As__c = 'Doing_Business_As__c';
		terminateService.Code_Salutation__c = '2000CUSTIT';
		terminateService.First_Name__c = 'First_Name__c';
		terminateService.Last_Name__c = 'Last_Name__c';
		terminateService.Middle_Name__c = 'Middle_Name__c';
		terminateService.Date_of_Birth__c = date.newInstance(1970, 1, 3);
		terminateService.Email_Address__c = 'sample@sample.com';
		terminateService.Code_Customer_Type__c = 'CT001';
		terminateService.Conglomerate_Tag__c = true;
		terminateService.Tax_Identification_No__c = '999999999';
		terminateService.Service_Description__c = 'Service_Description__c';
		terminateService.Business_Segment__c = 'BSEGTYP001';
		terminateService.Applied_Load__c = 1;
		terminateService.Code_Phase__c = 'SINGPHS';
		terminateService.Code_Voltage__c = 'CTENS00100';
		terminateService.Code_PSIC__c = '2929';
		terminateService.Demand_Factor__c = 1;
		terminateService.Load_Factor__c = 2;
		terminateService.Contracted_Capacity__c = 3;
		terminateService.Code_Service_Rate_Type__c = '131TYSERRA';
		terminateService.Code_Billing_Class__c = 9;
		terminateService.CXE_Discount_Programs__c = 'Senior Citizen Household Discount SCHD';
		terminateService.CXE_Rate_Programs__c = 'Peak Off-Peak';
		terminateService.Code_Service_Supply_Type__c = 'SSTIP00005';
		terminateService.Code_Metering_Scheme__c = 'TIMOD00001';
		terminateService.Code_Mode_of_Retrieval__c = 'TIHOR00004';
		terminateService.CXE_Service_Wire_Phase__c = 'SINGPHS';
		terminateService.CXE_Service_Wire_Voltage__c = 'CTENS00100';
		terminateService.Code_Service_Wire_Type__c = 'LINTYP0001';
		terminateService.TLN__c = '1';
		terminateService.Pole_Code__c = '2222';
		terminateService.Service_Wire_Length__c = 2;
		terminateService.Code_Wire_Size__c = 'SERWR00001';
		terminateService.Code_Material__c = 'MATER00001';

		return terminateService; 
	}
}