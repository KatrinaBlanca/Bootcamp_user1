({
    //FOR BUTTON VALIDATION | IF ITS BLANK OR NOT
    checkFieldsError : function(component, event) {
        
        //SERVICE ADDRESS VARIABLES
        var servHome = component.find("serv_home").get("v.value");
        console.log(servHome);
        //declare var for dropdown province
        //declare var for dropdown city
        //declare var for dropdown home ownership               
        //RADIO BUTTONS VARIABLES
        var yesRadio =document.getElementById("yes_radio").checked; 
        var noRadio =document.getElementById("no_radio").checked; 
        //BILLING ADDRESS VARIABLES
        var billHome = component.find("bill_home").get("v.value");
        //declare var for dropdown province
        //declare var for dropdown city
        //declare var for dropdown home ownership 
        
        if ($A.util.isEmpty(servHome)){
            
            var errorHolder = component.find('servHome-error');
            $A.util.removeClass(errorHolder, 'slds-hide');
            $A.util.addClass(errorHolder, 'servHomeError');
            
        } else {
            
            var errorHolder = component.find('servHome-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'servHomeError');
        }
        
        
        if(yesRadio == false && noRadio == true){

            if ($A.util.isEmpty(billHome)){
                
                var errorHolder = component.find('billHome-error');
                $A.util.removeClass(errorHolder, 'slds-hide');
                $A.util.addClass(errorHolder, 'billHomeError');
                
            } else {
                
                var errorHolder = component.find('billHome-error');
                $A.util.addClass(errorHolder, 'slds-hide');
                $A.util.removeClass(errorHolder, 'billHomeError');
            }
        } 
        
    },
    
    //FOR SHOWING BILLING ADDRESS FIELD | THRU RADION BUTTON
    handleRadioClick : function(component, event) {
		
        var yesRadio =document.getElementById("yes_radio").checked; 
        var noRadio =document.getElementById("no_radio").checked; 
        console.log('If yes is ticked Id is: ' + yesRadio);
        console.log('If no is ticked value is: ' + noRadio);
        
        
        if(yesRadio == true && noRadio == false){
     
            //alert('hide Div');
            var errorHolder = component.find('billAddDiv');                       
            $A.util.removeClass(errorHolder, 'slds-show');
            $A.util.addClass(errorHolder, 'slds-hide'); 
                       
            
        } else if(yesRadio == false && noRadio == true){
            
            //alert('show Div');
            var errorHolder = component.find('billAddDiv');                       
            $A.util.addClass(errorHolder, 'slds-show');
            $A.util.removeClass(errorHolder, 'slds-hide'); 
        }
	},
    
    //FOR SERVICE ADDRESS BLUR FIELD VALIDATION --------------------------------------------------------------------------------------
    handleOnBlurServHome : function(component, event) {
        
        var servHome = component.find("serv_home").get("v.value");
        
        if ($A.util.isEmpty(servHome)){
            
            var errorHolder = component.find('servHome-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'servHomeError');
            
        } else {
            
            var errorHolder = component.find('servHome-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'servHomeError');
            
        } 
        
    },
    
    //FOR BILLING ADDRESS BLUR FIELD VALIDATION --------------------------------------------------------------------------------------
    handleOnBlurBillHome : function(component, event) {
        
        var billHome = component.find("bill_home").get("v.value");
        
        if ($A.util.isEmpty(billHome)){
            
            var errorHolder = component.find('billHome-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'billHomeError');
            
        } else {
            
            var errorHolder = component.find('billHome-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'billHomeError');
            
        } 
    }
})