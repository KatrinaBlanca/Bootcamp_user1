({
    getTotalBill : function(component, event, helper) {
        /*var action = component.get("c.fee");
        alert('action >>>>>>>>>> '+ action);*/
    },
    error : function(err) {
        console.error(err);
        
        var toast = $A.get("e.force:showToast");
        
        if(err.error_source == 'payment_gateway'){
            toast.setParams({
                type: 'warning'
                , title: err.message
                , message: (err.parameters || []).map(function(e){return e.description;}).join('\n\n')
            });
        }
        else{
            $A.reportError(err.message, err);
            var line = err.message.split('\n');
            toast.setParams({
                type: 'error'
                , title: line[0]
                , message: line[1]
            });
        }
        
        toast.fire();
    },
    promise: function(c, method, data){
        var self = this;
        console.log('here');
       	console.log(method);
        console.log(data);
        return new Promise(function(resolve, reject){
            var act = c.get('c.' + method);
            
            act.setParams(data);
            act.setCallback(this, function(res){
                console.log("output" + res.getReturnValue().requestReferenceNumber);
                if(res.getError().length > 0){
                    reject(res.getError()[0]);
                }
                else{
                    console.log('here');
                    //self.run(function(){
                    if(!!res.getReturnValue().error_source){
                        reject(res.getReturnValue());
                    }
                    else{
                        console.log('here');
                        resolve(res.getReturnValue());	
                    }
                    //});
                }	
            });
            $A.enqueueAction(act);	
        });
    }
    
    
})