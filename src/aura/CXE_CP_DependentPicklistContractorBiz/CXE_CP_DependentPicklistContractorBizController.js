({ 
   doInit: function(component, event, helper) {
       
      //call the helper function with pass [component, Controller field and Dependent Field] Api name 
      helper.fetchPicklistValues(component, component.get("v.controllingFieldApi"), component.get("v.dependentFieldApi"));
   },
   // function call on change tha controller field  
   onControllerFieldChange: function(component, event, helper) {

       var controllerValueKey = event.getSource().get("v.value");
       component.set("v.provincePicklistValue", controllerValueKey);
       console.log('>>>>controllerValueKey: '+controllerValueKey);
       
       component.set("v.controllingFieldIdValue", controllerValueKey);
	
       var Map = component.get("v.dependentFieldMap");

       
      // check if selected value is not equal to None then call the helper function.
      // if controller field value is none then make dependent field value is none and disable field
      if (controllerValueKey != "Select One") {
 		 var sampp = component.find("controllingFieldId");             
         sampp.set("v.errors", null); 
          
         var ListOfDependentFields = Map[controllerValueKey];
         helper.fetchDepValues(component, ListOfDependentFields);
 
      }else {
          
          var defaultVal = [{
            class: "optionClass",
            label: "Select One",
            value: "Select One"
         }];
         component.find("dependentFieldId").set("v.options", defaultVal);
         component.set("v.isDependentDisable", true);
         component.set("v.dependentPicklistValue", "Select One");
      }
	
      helper.handleEvent(component, event, helper, component.get("v.controllingFieldEvt"));
      
      
   },
 
   // function call on change tha Dependent field    
   onDependentFieldChange: function(component, event, helper) {
       var sampp1 = component.find("dependentFieldId");             
       sampp1.set("v.errors", null); 
      helper.handleEvent(component, event, helper, component.get("v.dependentFieldEvt"));
   },
    
   proceedChange: function(component, event, helper) {
      helper.proceedChangeHelper(component, event, helper);
      component.set("v.isNextClicked", false);
   },
  
})