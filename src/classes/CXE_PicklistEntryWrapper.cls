/* 
* Description: Wrapper Class which is use to deserialize the JSON format.
*              Source: SFDC Monkey dependent-picklist-fields-lightning-component
* Author: Jerome To
* Date Created: JUN-13-2017
*/ 
public class CXE_PicklistEntryWrapper{    
    public CXE_PicklistEntryWrapper(){  }
    public String active {get;set;}
    public String defaultValue {get;set;}
    public String label {get;set;}
    public String value {get;set;}
    public String validFor {get;set;}
}