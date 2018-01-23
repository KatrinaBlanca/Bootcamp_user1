({
	 notifSetCancelHelper : function(component, event, helper) {
        
        //START CSM-14541 R2B Retrofit
        component.set("v.showCancelModal", true);
         
         /*
        var returnValue = confirm('Cancel Notification settings?');
        
        if(returnValue == true){
            var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                                 + location.pathname.split('/')[1] + '/' 
                                 + location.pathname.split('/')[2] + '/profile';
            window.location.assign(pageUrl);
        }
        */
		//END CSM-14541_____ R2B Retrofit
    },
    
	notifSetSaveHelper : function(component, event, helper) {
       
        var billNotifEmail = component.find("cmp_billNotifEmail").get("v.value");
        var billNotifSms = component.find("cmp_billNotifSms").get("v.value");
        var payConfirmEmail = component.find("cmp_payConfirmEmail").get("v.value");
        var payConfirmSms = component.find("cmp_payConfirmSms").get("v.value");
        var payRemindEmail = component.find("cmp_payRemindEmail").get("v.value");
        var payRemindSms = component.find("cmp_payRemindSms").get("v.value");
        var servAppEmail = component.find("cmp_servAppEmail").get("v.value");
        var servAppSms = component.find("cmp_servAppSms").get("v.value");
        var outagesEmail = component.find("cmp_outagesEmail").get("v.value");
        var outagesSms = component.find("cmp_outagesSms").get("v.value");
        var promotionsEmail = component.find("cmp_promotionsEmail").get("v.value");
        var promotionsSms = component.find("cmp_promotionsSms").get("v.value");
        
    	var action = component.get("c.UpdateNotifSettings");
    
            action.setParams({"billNotifEmail":billNotifEmail, "billNotifSms":billNotifSms, "payConfirmEmail":payConfirmEmail, 
                             "payConfirmSms":payConfirmSms, "payRemindEmail":payRemindEmail, "payRemindSms":payRemindSms, 
                             "servAppEmail":servAppEmail, "servAppSms":servAppSms, "outagesEmail":outagesEmail, 
                             "promotionsEmail":promotionsEmail, "promotionsSms":promotionsSms, "outagesSms":outagesSms });
         				
            action.setCallback(this,function(response){   
           
                var state = response.getState();
              
                if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                    console.log('billNotifEmail       ' + response.getReturnValue().billNotifEmail       );
                    console.log('billNotifSms         ' + response.getReturnValue().billNotifSms         );
                    console.log('payConfirmEmail      ' + response.getReturnValue().payConfirmEmail      );
                    console.log('payConfirmSms        ' + response.getReturnValue().payConfirmSms        );
                    console.log('payConfirmRemindEmail' + response.getReturnValue().payConfirmRemindEmail);
                    console.log('payConfirmRemindSms  ' + response.getReturnValue().payConfirmRemindSms  );
                    console.log('servAppEmail         ' + response.getReturnValue().servAppEmail         );
                    console.log('servAppSms           ' + response.getReturnValue().servAppSms           );
                    console.log('outagesEmail         ' + response.getReturnValue().outagesEmail         );
                    console.log('outagesSms           ' + response.getReturnValue().outagesSms           );
                    console.log('promotionsEmail      ' + response.getReturnValue().promotionsEmail      );
                    console.log('promotionsSms        ' + response.getReturnValue().promotionsSms        );
                    
                    var errorHolder = component.find('Notif');
            		$A.util.removeClass(errorHolder, 'slds-hide');
            		//$A.util.addClass(errorHolder, 'new-pw-error');
                }else{
                  // alert('Failed'); //CSM-13020 Melvin Corbes 10-02-17  
                   
                }
            });  
            $A.enqueueAction(action);        
    },
    
    onClickUpdateNotifHelper : function (component, event, helper) {
        
        var billNotifEmail        = component.find("cmp_billNotifEmail").get("v.value");
        var billNotifSms          = component.find("cmp_billNotifSms").get("v.value");
        var payConfirmEmail       = component.find("cmp_payConfirmEmail").get("v.value");
        var payConfirmSms         = component.find("cmp_payConfirmSms").get("v.value");
        var payRemindEmail        = component.find("cmp_payRemindEmail").get("v.value");
        var payRemindSms          = component.find("cmp_payRemindSms").get("v.value");
        var servAppEmail          = component.find("cmp_servAppEmail").get("v.value");
        var servAppSms            = component.find("cmp_servAppSms").get("v.value");
        var outagesEmail          = component.find("cmp_outagesEmail").get("v.value");
        var outagesSms            = component.find("cmp_outagesSms").get("v.value");
        var promotionsEmail       = component.find("cmp_promotionsEmail").get("v.value");
        var promotionsSms         = component.find("cmp_promotionsSms").get("v.value");
       
        var billingNotificationString;
        var paymentConfirmationString;
        var paymentReminderString;
        var serviceApplicationString;
        var outagesString;
        var promotionsString;
        
        var emailString = "Email";
        var smsString   = "SMS";
        var nullValue   = "";
        
        var action = component.get("c.updateContact");
        
        if(billNotifEmail == true){
           billNotifEmail = emailString; 
        }else{
           billNotifEmail = nullValue;      
        }
        
        if(billNotifSms == true){
           billNotifSms = smsString; 
        }else{
           billNotifSms = nullValue;     
        }
		
		if(payConfirmEmail == true){
           payConfirmEmail = emailString; 
        }else{
           payConfirmEmail = nullValue;      
        }
        
        if(payConfirmSms == true){
           payConfirmSms = smsString; 
        }else{
           payConfirmSms = nullValue;     
        }
        //-----------------------------
		if(payRemindEmail == true){
           payRemindEmail = emailString; 
        }else{
           payRemindEmail = nullValue;      
        }
        
        if(payRemindSms == true){
           payRemindSms = smsString; 
        }else{
           payRemindSms = nullValue;     
        }
        //--------------
		if(servAppEmail == true){
           servAppEmail = emailString; 
        }else{
           servAppEmail = nullValue;      
        }
        
        if(servAppSms == true){
           servAppSms = smsString; 
        }else{
           servAppSms = nullValue;     
        }
        
        if(outagesEmail == true){
           outagesEmail = emailString; 
        }else{
           outagesEmail = nullValue;      
        }
        
        if(outagesSms == true){
           outagesSms = smsString; 
        }else{
           outagesSms = nullValue;     
        }
		
		if(promotionsEmail == true){
           promotionsEmail = emailString; 
        }else{
           promotionsEmail = nullValue;      
        }
        
        if(promotionsSms == true){
           promotionsSms = smsString; 
        }else{
           promotionsSms = nullValue;     
        }
		
        if(billNotifEmail == emailString && billNotifSms == smsString){
            billingNotificationString = billNotifEmail+";"+billNotifSms;
        }else{
            billingNotificationString = billNotifEmail + billNotifSms;
        }
		
		if(payConfirmEmail == emailString && payConfirmSms == smsString){
            paymentConfirmationString = payConfirmEmail+";"+payConfirmSms;
        }else{
            paymentConfirmationString = payConfirmEmail + payConfirmSms;
        }
				
		if(payRemindEmail == emailString && payRemindSms == smsString){
            paymentReminderString = payRemindEmail+";"+payRemindSms;
        }else{
            paymentReminderString = payRemindEmail + payRemindSms;
        }
		
		if(servAppEmail == emailString && servAppSms == smsString){
            serviceApplicationString = servAppEmail+";"+servAppSms;
        }else{
            serviceApplicationString = servAppEmail + servAppSms;
        }
		
		if(outagesEmail == emailString && outagesSms == smsString){
            outagesString = outagesEmail+";"+outagesSms;
        }else{
            outagesString = outagesEmail + outagesSms;
        }
		
		if(promotionsEmail == emailString && promotionsSms == smsString){
            promotionsString = promotionsEmail+";"+promotionsSms;
        }else{
            promotionsString = promotionsEmail + promotionsSms;
        }
       
		
        action.setParams({"billingNotificationString":billingNotificationString, "paymentConfirmationString":paymentConfirmationString,
				  "paymentReminderString":paymentReminderString, "serviceApplicationString":serviceApplicationString,
				  "outagesString":outagesString, "promotionsString":promotionsString});
        
        action.setCallback(this,function(response){    
            
            var state = response.getState();
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                var errorHolder = component.find('Notif');
                $A.util.removeClass(errorHolder, 'hideSuccessMessage');// CSM-12911 Mike Verdad 09/25/2017
				
                //START CSM-14556 JRances - Remove inlint text "Your changes have been saved." after 6 seconds
                window.setTimeout(
                    $A.getCallback(function() {
                        var errorHolder = component.find('Notif');
                        $A.util.addClass(errorHolder, 'hideSuccessMessage');
                    }), 6000
                );
                //END CSM-14556 JRances
                
            }else{
                console.log("Failed: " + response.getReturnValue());
            }
        });  
        $A.enqueueAction(action);        
    },
    onInit: function(component) {
        var action = component.get("c.getProfilePicture"); 
        action.setParams({
            parentId: component.get("v.recordId"),
        });
        action.setCallback(this, function(a) {
            var photoURL = a.getReturnValue();
            if (photoURL) {
	            component.set('v.pictureSrc', photoURL);
            }
        });
        $A.enqueueAction(action); 
    },

})