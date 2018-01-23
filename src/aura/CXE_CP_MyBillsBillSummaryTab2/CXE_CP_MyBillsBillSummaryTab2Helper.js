({
    tokenId: "",
    
    tokenize : function(url, auth, cc) {
        var isTrue = false;
        return new Promise(function(resolve, reject){
            var xhttp = new XMLHttpRequest();
            xhttp.open("POST", url, true);
            xhttp.setRequestHeader('Authorization', auth);
            xhttp.setRequestHeader('Content-Type', 'application/json');
            
            xhttp.send(JSON.stringify(cc));
            
            xhttp.onreadystatechange = function(e){
                var tokenID;
                if(e.target.readyState == 4 && e.target.status == 200) {
                    $A.getCallback(function(){
                        console.log('SUCESS1' + JSON.stringify(JSON.parse(e.target.responseText)));
                        resolve(JSON.parse(e.target.responseText));
                        
                    })();
                }else{
                    //alert('test123');
                    if(e.target.readyState == 4){
                        $A.getCallback(function(){
                            console.log('FAILED' + JSON.stringify(JSON.parse(e.target.responseText)));
                            reject(JSON.parse(e.target.responseText));
                            
                        })();
                        
                        /*var obj = JSON.parse(e.target.responseText);
                        alert('Obj.Code: >>>>'+obj.code + ' ' + 'Obj.Message: >>>>'+ obj.message);
                        errMesage = obj.message;
                        alert('error1 >>> ' + errMesage);
						component.set("v.errorMessage", errMesage);
                        */
                    }
                }
            }
            /*
			xhttp.onerror = function(e){
				$A.getCallback(function(){
					reject(e.target);
				})();
			}
            */
            
        });
        alert('3');
        if(isTrue){
            alert('4');
            alert('2' + tokenID);
            component.set('v.ccSecCode' , tokenID);
            console.log('final' + tokenID);
            console.log(component.get('v.ccSecCode'));
            alert("final" + component.get('v.ccSecCode'));
        }
    },
    
    errorMessage : function(err) {
        alert(err);
        alert('TEST456');
        console.log('error>>>>'  + err.status);
        //console.log(err + err.status);
        
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
                type: 'warning'
                , title: line[0]
                , message: line[1]
            });
        }
        
        toast.fire();
        
    },
    
    componentSet : function(val){
        var errMessage = val;
        alert('val' + val);
    },
    
    getConvenienceFee : function(component, event){
        console.log('CONVENIENCEFEE');

    },
    
    setEventPassData : function(component, event){
        console.log('TOKENS ' + this.tokenId);
    }
    
})