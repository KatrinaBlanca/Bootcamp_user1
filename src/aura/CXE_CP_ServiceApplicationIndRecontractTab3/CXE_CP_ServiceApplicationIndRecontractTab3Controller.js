({
	checkFieldsError : function(component, event) {
		
        //RADIO BUTTONS VARIABLES
        var smsRadio =document.getElementById("sms_radio").checked; 
        var emailRadio =document.getElementById("email_radio").checked; 
        var bothRadio =document.getElementById("both_radio").checked; 
        
        var yesProcRadio =document.getElementById("yesProc_radio").checked; 
        var noProcRadio =document.getElementById("noProc_radio").checked; 
        
        var yesBillRadio =document.getElementById("yesBill_radio").checked; 
        var noBillRadio =document.getElementById("noBill_radio").checked; 
        
        var yesAutoradio =document.getElementById("yesAuto_radio").checked; 
        var noAutoradio =document.getElementById("noAuto_radio").checked; 
        
        console.log('smsRadio: ' + smsRadio + ' ' + 'emailRadio: ' + emailRadio + ' ' + 'bothRadio: ' + bothRadio);
        console.log('yesProcRadio: ' + yesProcRadio + ' ' + 'noProcRadio: ' + noProcRadio);
        console.log('yesBillRadio: ' + yesBillRadio + ' ' + 'noBillRadio: ' + noBillRadio);
        console.log('yesAutoradio: ' + yesAutoradio + ' ' + 'noAutoradio: ' + noAutoradio);
        
        
        //if no selected first part
        if(smsRadio == false && emailRadio == false && bothRadio == false){
            
            var errorHolder = component.find('statApp-error');
            $A.util.removeClass(errorHolder, 'slds-hide');
            $A.util.addClass(errorHolder, 'statAppError');
            
        } else {
            
            var errorHolder = component.find('statApp-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'statAppError');
        }
        
        //if no selected in 2nd part
        if(yesProcRadio == false && noProcRadio == false){
            
            var errorHolder = component.find('procApp-error');
            $A.util.removeClass(errorHolder, 'slds-hide');
            $A.util.addClass(errorHolder, 'procAppError');
            
        } else {
            
            var errorHolder = component.find('procApp-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'procAppError');
        }
        
        //3rd part
        if(yesBillRadio == false && noBillRadio == false){
            
            var errorHolder = component.find('papBill-error');
            $A.util.removeClass(errorHolder, 'slds-hide');
            $A.util.addClass(errorHolder, 'papBillError');
            
        } else {
            
            var errorHolder = component.find('papBill-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'papBillError');
        }
        
        //4th part
        if(yesAutoradio == false && noAutoradio == false){
            
            var errorHolder = component.find('payArra-error');
            $A.util.removeClass(errorHolder, 'slds-hide');
            $A.util.addClass(errorHolder, 'payArraError');
            
        } else {
            
            var errorHolder = component.find('payArra-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'payArraError');
        }
        
	}
})