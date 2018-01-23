({
    ToggleSubmitPassword : function(component, event) {
        
        var cp_initpassField = component.find("cp_initpass").get("v.value");
        var cp_confirminitpassField = component.find("cp_confirminitpass").get("v.value");
        
        if(cp_initpassField != cp_confirminitpassField){
            
            var errorHolder = component.find('pw-error');
            $A.util.removeClass(errorHolder, 'hideError');
            $A.util.addClass(errorHolder, 'pw-error');
            isValid = false;
            
        } else {
            
            //alert('bye');
            
            var action = component.get("c.getChangePassword");
            action.setParams({"initPass":cp_initpassField , "confirmInitPass":cp_confirminitpassField});
            
            action.setCallback(this,function(response){          
                var state = response.getState();
                if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                    //alert(response.getReturnValue()); // CSM-13020 Melvin Corbes 10-02-17
                    console.log(response.getReturnValue());
                }else{
                    console.log("Failed With state: " + state);
                    console.log("Returned:");
                    console.log(response.getReturnValue());
                }
                
            });
            
            $A.enqueueAction(action);
            
        }/*,
            ToggleCheckCharLimit : function(component, event) {
                
                //SHOW ERROR MESSAGE FOR CHAR LIMIT
                var errorHolder = component.find('le-error');
                $A.util.removeClass(errorHolder, 'lengthError');
                $A.util.addClass(errorHolder, 'le-error');
            }*/
    }
})