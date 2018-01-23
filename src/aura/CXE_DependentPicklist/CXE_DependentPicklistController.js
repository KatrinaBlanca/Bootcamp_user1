({ 
   doInit: function(component, event, helper) {
      //call the helper function with pass [component, Controller field and Dependent Field] Api name 
      helper.fetchPicklistValues(component, component.get("v.controllingFieldApi"), component.get("v.dependentFieldApi"));
   },
   // function call on change tha controller field  
   onControllerFieldChange: function(component, event, helper) {
      console.log(event.getSource().get("v.value"));
      // get the selected value
      var controllerValueKey = event.getSource().get("v.value");
 
      // get the map values   
      var Map = component.get("v.dependentFieldMap");
 
      // check if selected value is not equal to None then call the helper function.
      // if controller field value is none then make dependent field value is none and disable field
      if (controllerValueKey != "--- None ---") {
 
         var ListOfDependentFields = Map[controllerValueKey];
         helper.fetchDepValues(component, ListOfDependentFields);
 
      } else {
         var defaultVal = [{
            class: "optionClass",
            label: "--- None ---",
            value: "--- None ---"
         }];
         component.find("dependentFieldId").set("v.options", defaultVal);
         component.set("v.isDependentDisable", true);
      }

      helper.handleEvent(component, event, helper, component.get("v.controllingFieldEvt"));
      
   },
 
   // function call on change tha Dependent field    
   onDependentFieldChange: function(component, event, helper) {
      console.log(event.getSource().get("v.value"));
      helper.handleEvent(component, event, helper, component.get("v.dependentFieldEvt"));
   }
})