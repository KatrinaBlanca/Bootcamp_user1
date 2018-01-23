({
 
   fetchPicklistValues: function(component, controllerField, dependentField) {
      // call the server side function  
      var action = component.get("c.getDependentOptionsImpl");
      // pass paramerters [object name , contrller field name ,dependent field name] -
      // to server side function 
 
      action.setParams({
         "objApiName": component.get("v.objInfo"),
         "contrfieldApiName": controllerField,
         "depfieldApiName": dependentField
      });
      //set callback   
      action.setCallback(this, function(response) {
         if (response.getState() == "SUCCESS") {
            //store the return response from server (map<string,List<string>>)  
            var StoreResponse = response.getReturnValue();
            
            // once set #StoreResponse to depnedentFieldMap attribute 
            component.set("v.dependentFieldMap", StoreResponse);
            // create a empty array for store map keys(@@--->which is controller picklist values) 
 
            var listOfkeys = []; // for store all map keys (controller picklist values)
            var ControllerField = []; // for store controller picklist value to set on ui field. 
 
            // play a for loop on Return map 
            // and fill the all map key on listOfkeys variable.
            for (var singlekey in StoreResponse) {
               listOfkeys.push(singlekey);
            }
 
            //set the controller field value for ui:inputSelect  
            if (listOfkeys != undefined && listOfkeys.length > 0) {
               ControllerField.push({
                  class: "optionClass",
                  label: "Select One",
                  value: "Select One"
               });
            }
 
            for (var i = 0; i < listOfkeys.length; i++) {
               ControllerField.push({
                  class: "optionClass",
                  label: listOfkeys[i],
                  value: listOfkeys[i]
               });
            }
            // set the ControllerField variable values to country(controller picklist field)
            component.find("controllingFieldId").set("v.options", ControllerField);
            console.log( "dependentFieldMap" + component.find("v.controllingFieldId"));

         } else {
            console.log("Error!!!!!" + response.getReturnValue());
         }
      });
      $A.enqueueAction(action);
   },
 
 
   fetchDepValues: function(component, ListOfDependentFields) {
      // create a empty array var for store dependent picklist values for controller field)  
      var dependentFields = [];
 
      if (ListOfDependentFields != undefined && ListOfDependentFields.length > 0) {
         dependentFields.push({
            class: "optionClass",
            label: "Select One",
            value: "Select One"
         });
 
      }
      for (var i = 0; i < ListOfDependentFields.length; i++) {
         dependentFields.push({
            class: "optionClass",
            label: ListOfDependentFields[i],
            value: ListOfDependentFields[i]
         });
      }
      // set the dependentFields variable values to State(dependent picklist field) on ui:inputselect    
      component.find("dependentFieldId").set("v.options", dependentFields);
      // make disable false for ui:inputselect field 
      component.set("v.isDependentDisable", false);
   },

   handleEvent : function(component, event, helper, eventName){
      var selectEvent;
      // var selectDependentEvent = $A.get("e.c:" + component.get("v.dependentFieldEvt"));
      if(eventName == "CXE_selectBusinessProvinceEvent"){
         selectEvent = component.getEvent("businessProvince");
         selectEvent.setParams({ "businessProvince": event.getSource().get("v.value") }).fire();
      } else if (eventName == "CXE_selectBusinessCityEvent"){
         selectEvent = component.getEvent("businessCity");
         selectEvent.setParams({ "businessCity": event.getSource().get("v.value") }).fire();
      } else if (eventName == "CXE_selectControllingPicklistEvent"){
         selectEvent = component.getEvent("serviceProvince");
         selectEvent.setParams({ "serviceProvince": event.getSource().get("v.value") }).fire();
      } else if (eventName == "CXE_selectDependentPicklistEvent"){
         selectEvent = component.getEvent("serviceCity");
         selectEvent.setParams({ "serviceCity": event.getSource().get("v.value") }).fire();
      } 
   },
    proceedChangeHelper: function(component, event, helper) {
      console.log('proceedChangeHelper1'); 
      var controllerValueKey = event.getSource().get("v.value");
      var controllingFieldId = component.get("v.provincePicklistValue");
      //var dependentFieldId = component.get("v.dependentPicklistValue");
      var dependentFieldId = component.find("dependentFieldId").get("v.value"); 
      var flagCon = false; 
      var flagDep = false; 
      console.log('proceedChangeHelper2');   
        console.log('Michael_controllingFieldId: '+controllingFieldId);
        console.log('Michael_dependentFieldId: '+dependentFieldId);
      
       if(($A.util.isEmpty(controllingFieldId) || controllingFieldId =="Select One")){
           var sampp = component.find("controllingFieldId");             
           sampp.set("v.errors", [{message:"Please indicate your Province."}]); 
           flagCon = true; 
           
       }if(flagCon == false){
           var sampp = component.find("controllingFieldId");             
           sampp.set("v.errors", null); 
          
       }if(($A.util.isEmpty(dependentFieldId) || dependentFieldId =="Select One")){
           var sampp1 = component.find("dependentFieldId"); 
           sampp1.set("v.errors", [{message:"Please indicate your City."}]);   
           flagDep = true;
           
       }if(flagDep == false){
           var sampp1 = component.find("dependentFieldId"); 
           sampp1.set("v.errors", null);       
       }
   
   },
    
    proceedChangeHelper2: function(component, event, helper) {
      console.log('proceedChangeHelper2'); 
      var controllerValueKey = event.getSource().get("v.value");
      var controllingFieldId = component.get("v.provincePicklistValue");
      //var dependentFieldId = component.get("v.dependentPicklistValue");
      var dependentFieldId = component.find("dependentFieldId").get("v.value"); 
      var flagCon = false; 
      var flagDep = false; 
      console.log('proceedChangeHelper2');   
        console.log('Michael_controllingFieldId: '+controllingFieldId);
        console.log('Michael_dependentFieldId: '+dependentFieldId);
      
       if(($A.util.isEmpty(controllingFieldId) || controllingFieldId =="Select One")){
           var sampp = component.find("controllingFieldId");             
           sampp.set("v.errors", [{message:"Please indicate your Province."}]); 
           flagCon = true; 
           
       }if(flagCon == false){
           var sampp = component.find("controllingFieldId");             
           sampp.set("v.errors", null); 
          
       }if(($A.util.isEmpty(dependentFieldId) || dependentFieldId =="Select One")){
           var sampp1 = component.find("dependentFieldId"); 
           sampp1.set("v.errors", [{message:"Please indicate your City."}]);   
           flagDep = true;
           
       }if(flagDep == false){
           var sampp1 = component.find("dependentFieldId"); 
           sampp1.set("v.errors", null);       
       }
   
   },
})