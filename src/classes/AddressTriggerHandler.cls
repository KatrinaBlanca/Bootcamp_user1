/* 
* Description: Handles the logic for Address Trigger
* Author: Von Pernicia (Accenture)
* Date Created: MAR-02-17
*/ 
//START CSM-14753 RReyes NOV-30-17 - changed to without sharing
public without sharing class AddressTriggerHandler implements TriggerInterface
//END CSM-14753 RReyes NOV-30-17 - changed to without sharing
{
    //CSM-12509 START JEROME TO   SEP-11-2017
    static final Map<String, String> picklistCodeMapping;
    static final Map<String, String> picklistDescMapping;
    static{        
        picklistDescMapping = new Map<String, String>();
        picklistCodeMapping = new Map<String, String>();
        List<List<String>> arrayList = CXE_Constants.CASE_PICKLIST_ARRAY;
        List<String> sTypeList = new List<String>();
        
        for (Integer x = 0; x < arrayList.size(); x++)
        {
          sTypeList.add(arrayList[x][2]);
        }
        
        for(Reference__c ref : [SELECT Name, Name_Code__c, Field__c FROM Reference__c WHERE Field__c IN: sTypeList and Type__c = 'Picklist' ORDER BY Field__c]){
            picklistDescMapping.put(ref.Name_Code__c + ref.Field__c, ref.Name);
            picklistCodeMapping.put(ref.Name + ref.Field__c, ref.Name_Code__c);
        }

        system.debug(picklistDescMapping.size());
        system.debug(picklistCodeMapping.size());
    }
    static Boolean isAdministrator = CXE_Utility.isAdmin();
    //CSM-12509 END JEROME TO   SEP-11-2017

    
    
//Checks to see if the trigger has been disabled either by custom setting or by running code
public Boolean IsDisabled() {
//Added trigger control from heirarchy custom setting
TriggerControl__c accessControl = TriggerControl__c.getInstance();
return accessControl.Address__c;
}

public void BeforeInsert(List<SObject> newList) 
{
//Begin CSM-973: Von Pernicia Mar-02-17
List<Address__c> newLists = (List<Address__c>)newList;
checkDuplicateCustomerAddressTypeForRelatedAccounts(newLists); // JEROME TO     MAY-29-17
checkDuplicateServiceAddressTypeForRelatedServices(newLists); // JEROME TO     MAY-30-17 CSM-6138, CSM-6137, CSM-6136
checkDuplicateBillingAddressTypeForRelatedContract(newLists); // JEROME TO     MAY-30-17 CSM-6135, CSM-6134, CSM-6133
synchAddressCodesAndLookups(newLists, null, false);
picklistTransformation(null, null, newLists, false);
//End CSM-973: Von Pernicia Mar-02-17

//associateAddressToAccount(newList);
} 

public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) 
{
//Begin CSM-973: Von Pernicia Mar-02-17
Map<id, Address__c> newMaps = (Map<id, Address__c>)newMap;
Map<id, Address__c> oldMaps = (Map<id, Address__c>)oldMap;
synchAddressCodesAndLookups(newMaps.values(), oldMaps, true);
//TriggerDispatcher.isRecursion = false; //START/END CSM-2130 RReyes 04/29-17
picklistTransformation(newMaps, oldMaps, null, true);
//End CSM-973: Von Pernicia Mar-02-17
}

public void BeforeDelete(Map<Id, SObject> oldMap){}

public void AfterInsert(Map<Id, SObject> newMap){
//BEGIN Michael Lasala MAR-03-11 Populate Case Responsible Office (CSM-161)
Map<Id, Address__c> newMaps = (Map<Id, Address__c>)newMap;
populateCaseResponsibleOffice(newMaps.values());
//END Michael Lasala MAR-02-17
//CSM 1854: BEGIN Jerson Poblete MAR - 14 -2017 Update Service ADdress
//START CSM-2130 RReyes 04/29-17
updateCaseServiceAddress(newMaps);
//END CSM-2130 RReyes 04/29-17
//END CSM 1854: Jerson Polbete 
}
//START CSM-2130 RReyes 04/29-17
public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) { 
//START CSM-11448 RReyes JUL-14-17 - filter case to update to prevent SOQL101 on Create Service Button
Map<Id, Address__c> newMaps = (Map<Id, Address__c>)newMap;
Map<id, Address__c> oldMaps = (Map<id, Address__c>)oldMap;
if(validateIfCaseUpdateIsRequired(newMaps.values(), oldMaps)){
    updateCaseServiceAddress(newMaps);
}
//END CSM-11448 RReyes JUL-14-17 - filter case to update to prevent SOQL101 on Create Service Button
}
//END CSM-2130 RReyes 04/29-17
public void AfterDelete(Map<Id, SObject> oldMap){}

public void AfterUndelete(Map<Id, SObject> oldMap){}  

//Begin CSM-973: Von Pernicia Mar-02-17

/* 
* Description: Pull the Name code and Id of the Reference object
* Parameters: N/A
* Returns: Picklist Value
* Author: Von Pernicia (Accenture)
* Date Created: MAR-2-17

public void addressTransformation(Map<Id, Address__c> newAddressMappings, Map<Id, Address__c> oldAddressMappings, List<Address__c> newAddressList, Boolean isUpdate)
{
if (!isUpdate)
{
addressTransCodeIdformation(newAddressList, oldAddressMappings, isUpdate);
}
else
{
addressTransCodeIdformation(newAddressMappings.values(), oldAddressMappings, isUpdate);
}
} */    

/* 
* Description: Transform address record base on Name Code and Id of the Reference object
* Parameters: N/A
* Returns: Picklist Value
* Author: Von Pernicia (Accenture)
* Date Created: MAR-2-17
*/  
public void picklistTransformation(Map<Id, Address__c> newAddressMappings, Map<Id, Address__c> oldAddressMappings, List<Address__c> newAddressList, Boolean isUpdate)
{

List<List<String>> arrayList = CXE_Constants.ADDRESS_PICKLIST_ARRAY;
Map<String, String> mapPicklistCode = CXE_Utility.picklistTransformationCode(arrayList);
Map<String, String> mapPicklistDesc = CXE_Utility.picklistTransformationDesc(arrayList);

CXE_Utility utilClass = new CXE_Utility();

if (!isUpdate)
{
utilClass.picklistTransformationInsert(newAddressList, arrayList, mapPicklistCode, mapPicklistDesc);
}
else
{   
utilClass.picklistTransformationUpdate(newAddressMappings, oldAddressMappings, arrayList, mapPicklistCode, mapPicklistDesc);
}

/*Set<Id> proviceIDs = new Set<Id>();
Set<String> proviceCodes = new Set<String>();
Map<Id, String> addressCodeTransMapping = new Map<Id, String>();
Map<String, Id> addressIdTransMapping = new Map<String, Id>();

// Get the Code and ID for Province
for (Address__c a: newAddressList)
{
if (a.Address_Province__c != null)
{   
    proviceIDs.add(a.Address_Province__c);
}
if (a.Code_Address_Province__c != null)
{
    proviceCodes.add(a.Code_Address_Province__c);
}

}

// Mapping of Reference record base on ID
if (proviceIDs.size() > 0)
{
addressCodeTransMapping = CXE_Utility.getAddressCodeTransformation(proviceIDs); 
}

// Mapping of Reference record base on Name Code
if (proviceCodes.size() > 0)
{
addressIdTransMapping = CXE_Utility.getAddressIdTransformation(proviceCodes);   
}

// Code and Lookup field names array
List<List<String>> addressFieldArray = CXE_Constants.ADDRESS_ARRAY;

for (Address__c a: newAddressList)
{
for (Integer x = 0; x < addressFieldArray.size(); x++)
{
    if (!isUpdate)
    {
        // Update code base on lookup id
        if (a.get(addressFieldArray[x][0]) == null)
        {
            a.put(addressFieldArray[x][0], addressCodeTransMapping.get((Id)a.get(addressFieldArray[x][1])));
        }
        
        // Update lookup Id base on code
        if (a.get(addressFieldArray[x][1]) == null)
        {
            a.put(addressFieldArray[x][1], addressIdTransMapping.get((String)a.get(addressFieldArray[x][0])));
        }
        
    }
    else
    {
        // Update code base on lookup id
        if (a.get(addressFieldArray[x][1]) != oldAddressMappings.get(a.Id).get(addressFieldArray[x][1]))
        {
            a.put(addressFieldArray[x][0], addressCodeTransMapping.get((Id)a.get(addressFieldArray[x][1])));
        }
        
        // Update lookup Id base on code
        else if (a.get(addressFieldArray[x][0]) != oldAddressMappings.get(a.Id).get(addressFieldArray[x][0]))
        {
            a.put(addressFieldArray[x][1], addressIdTransMapping.get((String)a.get(addressFieldArray[x][0])));
        }    
    }               
}
}*/
}
//End CSM-973: Von Pernicia Mar-02-17   



/* 
* Description: synchronize codes and lookups during record creation, update and integration
* Author: Jerome To
* Date Created: MAR-03-17
*/  
public void synchAddressCodesAndLookups(List<Address__c> newList, Map<Id, Address__c> oldMap, Boolean isUpdate) {

Set<Id> referenceIds = new Set<Id>();
Set<String> referenceNameCodes = new Set<String>();
Map<Id, Reference__c> referenceIdMap = new Map<Id, Reference__c>();
Map<String, Reference__c> referenceCodeMap = new Map<String, Reference__c>();

for(Address__c addressRec : newList) {
// check if from integration
// lookup is not null, update
if (isUpdate)
{
    if(addressRec.Address_Province__c != oldMap.get(addressRec.Id).Address_Province__c) {
        referenceIds.add(addressRec.Address_Province__c);
    } else if(addressRec.Code_Address_Province__c != oldMap.get(addressRec.Id).Code_Address_Province__c) {
        referenceNameCodes.add(addressRec.Code_Address_Province__c);
    }
    if(addressRec.Address_City_Municipality__c != oldMap.get(addressRec.Id).Address_City_Municipality__c) {
        referenceIds.add(addressRec.Address_City_Municipality__c);
    } else if(addressRec.Code_Address_City_Municipality__c != oldMap.get(addressRec.Id).Code_Address_City_Municipality__c) {
        referenceNameCodes.add(addressRec.Code_Address_City_Municipality__c);
    }
    if(addressRec.Address_Barangay__c != oldMap.get(addressRec.Id).Address_Barangay__c) {
        referenceIds.add(addressRec.Address_Barangay__c);
    } else if(addressRec.Code_Address_Barangay__c != oldMap.get(addressRec.Id).Code_Address_Barangay__c) {
        referenceNameCodes.add(addressRec.Code_Address_Barangay__c);
    }               
    if(addressRec.Address_Subdivision__c != oldMap.get(addressRec.Id).Address_Subdivision__c) {
        referenceIds.add(addressRec.Address_Subdivision__c);
    } else if(addressRec.Code_Address_Subdivision__c != oldMap.get(addressRec.Id).Code_Address_Subdivision__c) {
        referenceNameCodes.add(addressRec.Code_Address_Subdivision__c);
    }
    if(addressRec.Address_Street_Name__c != oldMap.get(addressRec.Id).Address_Street_Name__c) {
        referenceIds.add(addressRec.Address_Street_Name__c);
    } else if(addressRec.Code_Address_Street_Name__c != oldMap.get(addressRec.Id).Code_Address_Street_Name__c) {
        referenceNameCodes.add(addressRec.Code_Address_Street_Name__c);
    }  
}
else
{
    if(addressRec.Address_Province__c != null) {
        referenceIds.add(addressRec.Address_Province__c);
    } else if(addressRec.Code_Address_Province__c != null) {
        referenceNameCodes.add(addressRec.Code_Address_Province__c);
    }
    if(addressRec.Address_City_Municipality__c != null) {
        referenceIds.add(addressRec.Address_City_Municipality__c);
    } else if(addressRec.Code_Address_City_Municipality__c != null) {
        referenceNameCodes.add(addressRec.Code_Address_City_Municipality__c);
    }
    if(addressRec.Address_Barangay__c != null) {
        referenceIds.add(addressRec.Address_Barangay__c);
    } else if(addressRec.Code_Address_Barangay__c != null) {
        referenceNameCodes.add(addressRec.Code_Address_Barangay__c);
    }               
    if(addressRec.Address_Subdivision__c != null) {
        referenceIds.add(addressRec.Address_Subdivision__c);
    } else if(addressRec.Code_Address_Subdivision__c != null) {
        referenceNameCodes.add(addressRec.Code_Address_Subdivision__c);
    }
    if(addressRec.Address_Street_Name__c != null) {
        referenceIds.add(addressRec.Address_Street_Name__c);
    } else if(addressRec.Code_Address_Street_Name__c != null) {
        referenceNameCodes.add(addressRec.Code_Address_Street_Name__c);
    }  
}
}

if(!referenceIds.isEmpty()) {
referenceIdMap = new Map<Id, Reference__c>([SELECT Name_Code__c 
                                            FROM Reference__c 
                                            WHERE Id =:referenceIds and type__c = :CXE_Constants.REFERENCE_TYPE_GEO]);

}//CSM-2071 Rhyan Cruz 04/08/2017 added filtering of records where Type is Geo

if(!referenceNameCodes.isEmpty()) {
for(Reference__c ref : [SELECT Id,Name_Code__c FROM Reference__c WHERE Name_Code__c =:referenceNameCodes and type__c = :CXE_Constants.REFERENCE_TYPE_GEO]) {
    referenceCodeMap.put(ref.Name_Code__c, ref);
}
}//CSM-2071 Rhyan Cruz 04/08/2017 added filtering of records where Type is Geo

for(Address__c addressRec : newList) {
if(addressRec.Address_Province__c != null && referenceIdMap.containsKey(addressRec.Address_Province__c)) {
    addressRec.Code_Address_Province__c = referenceIdMap.get(addressRec.Address_Province__c).Name_Code__c;
} else if(String.isNotEmpty(addressRec.Code_Address_Province__c) && referenceCodeMap.containsKey(addressRec.Code_Address_Province__c))  {
    addressRec.Address_Province__c = referenceCodeMap.get(addressRec.Code_Address_Province__c).Id;
}
if(addressRec.Address_City_Municipality__c != null && referenceIdMap.containsKey(addressRec.Address_City_Municipality__c)) {
    addressRec.Code_Address_City_Municipality__c = referenceIdMap.get(addressRec.Address_City_Municipality__c).Name_Code__c;
} else if(String.isNotEmpty(addressRec.Code_Address_City_Municipality__c) && referenceCodeMap.containsKey(addressRec.Code_Address_City_Municipality__c))  {
    addressRec.Address_City_Municipality__c = referenceCodeMap.get(addressRec.Code_Address_City_Municipality__c).Id;
}
if(addressRec.Address_Barangay__c != null && referenceIdMap.containsKey(addressRec.Address_Barangay__c)) {                    
    addressRec.Code_Address_Barangay__c = referenceIdMap.get(addressRec.Address_Barangay__c).Name_Code__c;
} else if(String.isNotEmpty(addressRec.Code_Address_Barangay__c) && referenceCodeMap.containsKey(addressRec.Code_Address_Barangay__c))  {
    addressRec.Address_Barangay__c = referenceCodeMap.get(addressRec.Code_Address_Barangay__c).Id;
}           
if(addressRec.Address_Subdivision__c != null && referenceIdMap.containsKey(addressRec.Address_Subdivision__c)) {
    addressRec.Code_Address_Subdivision__c = referenceIdMap.get(addressRec.Address_Subdivision__c).Name_Code__c;
} else if(String.isNotEmpty(addressRec.Code_Address_Subdivision__c) && referenceCodeMap.containsKey(addressRec.Code_Address_Subdivision__c))  {
    addressRec.Address_Subdivision__c = referenceCodeMap.get(addressRec.Code_Address_Subdivision__c).Id;
}
if(addressRec.Address_Street_Name__c != null && referenceIdMap.containsKey(addressRec.Address_Street_Name__c)) {
    addressRec.Code_Address_Street_Name__c = referenceIdMap.get(addressRec.Address_Street_Name__c).Name_Code__c;
} else if(String.isNotEmpty(addressRec.Code_Address_Street_Name__c) && referenceCodeMap.containsKey(addressRec.Code_Address_Street_Name__c))  {
    addressRec.Address_Street_Name__c = referenceCodeMap.get(addressRec.Code_Address_Street_Name__c).Id;
}  

}
}

/* Description: Populate Case Responsible Office (CSM-161)
* Parameters: List<Address__c>
* Returns: Void
* Author: Michael Lasala
* Date Created: MAR-11-17
*/
public void populateCaseResponsibleOffice(List<Address__c> addressList){

if(!addressList.isEmpty()){

Map<Id, Id> caseAddressMap = new Map<Id, Id>();
Set<Id> cityIds = new Set<Id>();
Set<Id> streetIds = new Set<Id>();

for(Address__c address: addressList){

    //Process only for Addresses related to Case and Type = Service
    if(!String.isBlank(address.Case__c) && 
       address.Type__c == CXE_Constants.ADDRESS_TYPE_SERVICE){

        if(!String.isBlank(address.Address_City_Municipality__c)){

            //Map Case and city id
            caseAddressMap.put(address.Case__c, address.Address_City_Municipality__c);
            cityIds.add(address.Address_City_Municipality__c);
        }

        if(!String.isBlank(address.Address_Street_Name__c)){
            
            //Map Case and street id
            caseAddressMap.put(address.Case__c, address.Address_Street_Name__c);
            streetIds.add(address.Address_Street_Name__c);
        }
    }
    System.debug('caseAddressMap: '+caseAddressMap);
}

if(!caseAddressMap.keySet().isEmpty()){
    
    Map<Id, List<String>> officeMap = new Map<Id, List<String>>();
    Map<String, Id> officeIdMap = new Map<String, Id>();

    //Retrieve office jurisdiction based on city and street
    for(Office_Jurisdiction__c oj: [SELECT  Id, 
                                            Office__c, 
                                            Office__r.Name, 
                                            Street_Name__c, 
                                            City__c 
                                    FROM    Office_Jurisdiction__c 
                                    WHERE   City__c IN: cityIds 
                                    OR      Street_Name__c IN: streetIds]){

        //Map office Name based on city
        if(!String.isBlank(oj.City__c)){
            if(officeMap.containsKey(oj.City__c)){
                officeMap.get(oj.City__c).add(oj.Office__r.Name);
            } else {
                List<String> tempList = new List<String>();
                tempList.add(oj.Office__r.Name);
                officeMap.put(oj.City__c, tempList);
            }
        }

        //Map office Name based on street
        if(!String.isBlank(oj.Street_Name__c)){
            if(officeMap.containsKey(oj.Street_Name__c)){
                officeMap.get(oj.Street_Name__c).add(oj.Office__r.Name);
            } else {
                List<String> tempList = new List<String>();
                tempList.add(oj.Office__r.Name);
                officeMap.put(oj.Street_Name__c, tempList);
            }
            
            //Map office id by street name
            officeIdMap.put(oj.Street_Name__c, oj.Office__c);
        }
    }
    System.debug('officeMap: '+officeMap);
    System.debug('officeIdMap: '+officeIdMap);

    if(!officeMap.keySet().isEmpty()){

        List<Case> caseList = new List<Case>();
        
        //Retrieve case
        for(Case c: [SELECT Id, Origin, Initial_Responsible_Office__c FROM Case WHERE Id IN: caseAddressMap.keySet()]){

            //Only process records without initial responsible office
            if(String.isBlank(c.Initial_Responsible_Office__c)){
                String initialResponsibleOffice = '';
                String addressField = '';
                Boolean isWalkIn = false;

                //Toggle address type (city/street) based on case origin
                if(c.Origin == CXE_Constants.RECORD_TYPE_NAME_OFFICE_WEB){
                    addressField = CXE_Constants.REFERENCE_FIELD_CITY;
                } else {
                    addressField = CXE_Constants.REFERENCE_FIELD_STREET;
                    isWalkIn = true;
                }
                System.debug('addressField: '+addressField);
                System.debug('isWalkIn: '+isWalkIn);

                Set<String> officeSet = new Set<String>();

                //Iterate over offices to get office name based on case and street/city
                for(String s: officeMap.get(caseAddressMap.get(c.Id))){
                    if(!officeSet.contains(s)){
                        initialResponsibleOffice += s+',';
                        officeSet.add(s);
                    }
                }

                //Trim last comma
                initialResponsibleOffice = initialResponsibleOffice.subString(0, initialResponsibleOffice.length() - 1);
                System.debug('initialResponsibleOffice: '+initialResponsibleOffice);
                
                c.Initial_Responsible_Office__c = initialResponsibleOffice;

                //Auto populate responsible office lookup if walk in because street should have only 1 office
                if(isWalkIn){

                    //Populate responsible office by street
                    c.Responsible_Office_Lookup__c = officeIdMap.get(caseAddressMap.get(c.Id));
                    System.debug('Responsible_Office_Lookup__c: '+officeIdMap.get(caseAddressMap.get(c.Id)));
                }
                caseList.add(c);
            }
        }

        if(!caseList.isEmpty()){
            //Update case
            try {
                CasetriggerHandler.isIns = true; // Start CSM-12180 Von Pernicia AUG-03-17
                update caseList;
                System.debug('caseList: '+caseList);

            } catch (DMLException error){
                System.debug('update cases error: '+error.getMessage());
                ErrorHandlerException.recordException(null, true, 'AddressTriggerHandler', 'populateCaseResponsibleOffice', error.getMessage());
            }
        }
    }
}
}
}
/* 
* Description: Update Case Service Address 
* Parameters: Service Map
* Returns: N/A
* Author: Jerson Poblete (Accenture)
* Date Created: MAR-13-17
*/  
//Begin CSM-1854: Jerson Poblete MAR-14-17
//START CSM-2130 RReyes 04/29/17
public void updateCaseServiceAddress(Map<Id, Address__c> newMap)
{

    if(!newMap.values().isEmpty())
    {

        Map<Id, Id> caseAddressMap = new Map<Id, Id>();
        Set<Id> cityIds = new Set<Id>();
        Set<Id> streetIds = new Set<Id>();
        //START CSM-7329 RReyes - added new set of case ids and converted List from sObject to case
        List<Case> caseList = new List<Case>();
        Set<Id> caseIds = new Set<Id>();
        //END CSM-7329 RReyes - added new set of case ids and converted List from sObject to case
        Case caseRec = null;

        for(Address__c address: [SELECT Id, Type__c,  Case__c, Address_Province__r.Name,  Address_City_Municipality__r.Name,
                            Address_Barangay__r.Name, Address_Street_Name__r.Name, Address_Subdivision__r.Name, Address_Unit_No__c, Address_Street_No__c
                            FROM Address__c WHERE Id in: newMap.keySet()])
        {     
            if(!String.isBlank(address.Case__c) && 
                      address.Type__c == CXE_Constants.ADDRESS_TYPE_SERVICE)
             {
                //START CSM-7329 RReyes - added condition to check if case is already in the list
                if(!caseIds.contains(address.Case__c))
                {
                    caseRec = new Case();
                    caseRec.Id = address.Case__c;
                    //START RReyes - 04-29-17 - comment out code and use only one address field
                    String barangay = address.Address_Barangay__r.Name != null ? address.Address_Barangay__r.Name : '';
                    String city = address.Address_City_Municipality__r.Name != null ? address.Address_City_Municipality__r.Name : '';
                    String province = address.Address_Province__r.Name != null ? address.Address_Province__r.Name : '';
                    String streetName = address.Address_Street_Name__r.Name != null ? address.Address_Street_Name__r.Name : '';
                    String streetNo = address.Address_Street_No__c != null ? address.Address_Street_No__c : '';
                    String subdivision = address.Address_Subdivision__r.Name != null ? address.Address_Subdivision__r.Name : '';
                    String unitNo = address.Address_Unit_No__c != null ? address.Address_Unit_No__c : '';
                    caseRec.CXE_Service_Address__c = streetNo + ' ' + unitNo + ' ' + streetName + ' ' +  subdivision + ' ' + barangay + ' ' + city + ' ' + province;
                    /*
                                caseRec.Id = address.Case__c;
                                caseRec.Service_Address_Barangay__c = address.Address_Barangay__r.Name;
                                caseRec.Service_Address_City_Municiple__c = address.Address_City_Municipality__r.Name;
                                caseRec.Service_Address_Province__c = address.Address_Province__r.Name;
                                caseRec.Service_Address_Street_Name__c = address.Address_Street_Name__r.Name;
                                caseRec.Service_Address_Street_No__c = address.Address_Street_No__c;
                                caseRec.Service_Address_Subdivision__c = address.Address_Subdivision__r.Name;
                                caseRec.Service_Address_Unit_No__c = address.Address_Unit_No__c;
                    */
                    //END RReyes - 04-29-17
                    caseList.add(caseRec);
                    caseIds.add(caseRec.Id); //START/END CSM-7329 RReyes- added condition to check if case is already in the list
                }
                //END CSM-7329 RReyes -  - added condition to check if case is already in the list
            }
        }
        
        if(!caseList.isEmpty())
            {
                CasetriggerHandler.isIns = true; // Start CSM-12027 Von Pernicia AUG-03-17
                update caseList;
            }
    }
            
}
    //END CSM-2130 RReyes 04/29/17
    //END CSM-1854: Jerson Poblete MAR-14-17
    
    /*
    //BEGIN CSM-1832: Christian Peter Doctolero MAR-15-17
    public void associateAddressToAccount(List<Address__c> newList)
    {
        Id addressAccountId;
        Id caseAccountId;
        Id addressId;
        //select case - account
            for(Address__c addressRec: newList])
        {
            //addressAccountId = addressRec.Account__c;
            addressId = addressRec.Id;
            caseAccountId = addressRec.Case__c;
        }
        
      }*/

    /* Description: Prevent creation of more than one customer address for an account for non system administrator
     * Parameters: List<Address__c>
     * Returns: Void
     * Author: Jerome To
     * Date Created: MAY-29-17
     */
    public void checkDuplicateCustomerAddressTypeForRelatedAccounts(List<Address__c> addressList) {
        Set<Id> accountIds = new Set<Id>();
        Set<String> addressTypes = new Set<String> { CXE_Constants.ADDRESS_TYPE_CUSTOMER };
        //CSM-12509 START JEROME TO   SEP-11-2017
        Boolean isAdmin = isAdministrator;
        //CSM-12509 END JEROME TO   SEP-11-2017

        Set<Id> duplicateAccountIdOnCustomer = new Set<Id>();

        for(Address__c addressRecord : addressList) {
            if(addressRecord.Account__c != null && !isAdmin && addressTypes.contains(addressRecord.Type__c)) {
                accountIds.add(addressRecord.Account__c);
            }
        }
        if(!accountIds.isEmpty()) {
            for(Address__c addressRecord : [SELECT Account__c, Type__c FROM Address__c WHERE Account__c IN: accountIds AND Type__c IN:addressTypes]) {
                if(addressRecord.Type__c == CXE_Constants.ADDRESS_TYPE_CUSTOMER) {
                    duplicateAccountIdOnCustomer.add(addressRecord.Account__c);
                }
            }
            for(Address__c addressRecord : addressList) {
                if(addressRecord.Account__c != null && !isAdmin && addressTypes.contains(addressRecord.Type__c)) {
                    if(addressRecord.Type__c == CXE_Constants.ADDRESS_TYPE_CUSTOMER && duplicateAccountIdOnCustomer.contains(addressRecord.Account__c)) {
                        addressRecord.addError(CXE_Constants.ADDRESS_ERROR_CUSTOMER_ADDRESS_ALREADY_EXISTS);
                    }
                }
            }
        }        
    }

    /* Description: Prevent creation of more than one service address for Service Record for non system administrator 
     *              CSM-6138, CSM-6137, CSM-6136
     * Parameters: List<Address__c> 
     * Returns: Void
     * Author: Jerome To
     * Date Created: MAY-30-17
     */
    public void checkDuplicateServiceAddressTypeForRelatedServices(List<Address__c> addressList) {
        Set<Id> serviceIds = new Set<Id>();
        Set<String> addressTypes = new Set<String> { CXE_Constants.ADDRESS_TYPE_SERVICE };
        //CSM-12509 START JEROME TO   SEP-11-2017
        Boolean isAdmin = isAdministrator;
        //CSM-12509 END JEROME TO   SEP-11-2017

        Set<Id> duplicateServiceIdOnService = new Set<Id>();

        for(Address__c addressRecord : addressList) {
            if(addressRecord.Service__c != null && !isAdmin && addressTypes.contains(addressRecord.Type__c)) {
                serviceIds.add(addressRecord.Service__c);
            }
        }

        if(!serviceIds.isEmpty()) {
            for(Address__c addressRecord : [SELECT Service__c, Type__c FROM Address__c WHERE Service__c IN: serviceIds AND Type__c IN:addressTypes]) {
                if(addressRecord.Type__c == CXE_Constants.ADDRESS_TYPE_SERVICE) {
                    duplicateServiceIdOnService.add(addressRecord.Service__c);
                }                
            }
            for(Address__c addressRecord : addressList) {
                if(addressRecord.Service__c != null && !isAdmin && addressTypes.contains(addressRecord.Type__c)) {                    
                    if(addressRecord.Type__c == CXE_Constants.ADDRESS_TYPE_SERVICE && duplicateServiceIdOnService.contains(addressRecord.Service__c)) {
                        addressRecord.addError(CXE_Constants.ADDRESS_ERROR_SERVICE_ADDRESS_ALREADY_EXISTS);
                    }                                        
                }
            }
        }        
    }

    /* Description: Prevent creation of more than one service address for Billing Record for non system administrator 
     *              CSM-6133, CSM-6134, CSM-6135
     * Parameters: List<Address__c> 
     * Returns: Void
     * Author: Jerome To
     * Date Created: MAY-30-17
     */
    public void checkDuplicateBillingAddressTypeForRelatedContract(List<Address__c> addressList) {
        Set<Id> contractIds = new Set<Id>();
        Set<String> addressTypes = new Set<String> { CXE_Constants.ADDRESS_TYPE_BILLING };
        //CSM-12509 START JEROME TO   SEP-11-2017
        Boolean isAdmin = isAdministrator;
        //CSM-12509 END JEROME TO   SEP-11-2017

        Set<Id> duplicateAccountIdOnBilling = new Set<Id>();

        for(Address__c addressRecord : addressList) {
            if(addressRecord.Contract__c != null && !isAdmin && addressTypes.contains(addressRecord.Type__c)) {
                contractIds.add(addressRecord.Contract__c);
            }
        }

        if(!contractIds.isEmpty()) {
            for(Address__c addressRecord : [SELECT Contract__c, Type__c FROM Address__c WHERE Contract__c IN: contractIds AND Type__c IN:addressTypes]) {
                if(addressRecord.Type__c == CXE_Constants.ADDRESS_TYPE_BILLING) {
                    duplicateAccountIdOnBilling.add(addressRecord.Contract__c);
                }                
            }
            for(Address__c addressRecord : addressList) {
                if(addressRecord.Contract__c != null && !isAdmin && addressTypes.contains(addressRecord.Type__c)) {                    
                    if(addressRecord.Type__c == CXE_Constants.ADDRESS_TYPE_BILLING && duplicateAccountIdOnBilling.contains(addressRecord.Contract__c)) {
                        addressRecord.addError(CXE_Constants.ADDRESS_ERROR_BILLING_ADDRESS_ALREADY_EXISTS);
                    }                                        
                }
            }
        }        
    }

    //START CSM-11448 RReyes JUL-14-17 - filter case to update to prevent SOQL101 on Create Service Button
    /* Description: Validate if updating the case is needed
     * Parameters: List<Address__c>, Map<Id, Address__c>
     * Returns: Void
     * Author: Rom Edison Reyes
     * Date Created: JUL-14-17
     */
    public Boolean validateIfCaseUpdateIsRequired(List<Address__c> newAddresses, Map<Id, Address__c> oldAddresses) {
        for(Address__c newAdd: newAddresses){
            if(newAdd.Type__c == CXE_Constants.ADDRESS_TYPE_SERVICE){
                if(oldAddresses.containsKey(newAdd.Id)){
                    Address__c oldAddress = oldAddresses.get(newAdd.Id);
                    if(newAdd.Case__c != oldAddress.Case__c ||
                       newAdd.Service__c != oldAddress.Service__c || //START/END CSM-12476 RReyes SEP-14-17
                       newAdd.Address_Province__c != oldAddress.Address_Province__c ||
                       newAdd.Address_City_Municipality__c != oldAddress.Address_City_Municipality__c ||
                       newAdd.Address_Barangay__c != oldAddress.Address_Barangay__c ||
                       newAdd.Address_Street_Name__c != oldAddress.Address_Street_Name__c ||
                       newAdd.Address_Subdivision__c != oldAddress.Address_Subdivision__c ||
                       newAdd.Address_Unit_No__c != oldAddress.Address_Unit_No__c ||
                       newAdd.Address_Street_No__c != oldAddress.Address_Street_No__c)
                    {
                        return true;
                    }
                }
            }   
        }
        return false;
    }
    //END CSM-11448 RReyes JUL-14-17 - filter case to update to prevent SOQL101 on Create Service Button
}