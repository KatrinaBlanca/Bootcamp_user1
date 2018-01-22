({
	linkFeedbackHelper  : function (component, event, helper){
        
        var action = component.get("c.feedBackLink");
        action.setCallback(this, function(response){
           
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    linkFacebookHelper  : function (component, event, helper){
        
        var action = component.get("c.fBLink");
        action.setCallback(this, function(response){
           
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    linkTwitterHelper  : function (component, event, helper){
        
        var action = component.get("c.twitterLink");
        action.setCallback(this, function(response){
           
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    linkInstagramHelper  : function (component, event, helper){
        
        var action = component.get("c.iGLink");
        action.setCallback(this, function(response){
           
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    linkYoutubeHelper  : function (component, event, helper){
        
        var action = component.get("c.youTubeLink");
        action.setCallback(this, function(response){
           
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    }
})