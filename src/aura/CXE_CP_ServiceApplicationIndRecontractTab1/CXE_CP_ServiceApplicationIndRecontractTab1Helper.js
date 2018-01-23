({
    checkFieldsError : function(component, event) {

        //var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        //var regExpMobileformat = /^(09|\+639)\d{9}$/;
        //var regExpLandlineformat = /(0|\+63)[0-9]{7}/;
        
        //ACCOUNT HOLDER VARIABLES
        var gSin = component.find("guest_Sin").get("v.value");
        var gFirstName = component.find("guest_FirstName").get("v.value");
        var gMiddleName = component.find("guest_MiddleName").get("v.value");
        var gLastName = component.find("guest_LastName").get("v.value");
        var gEmail = component.find("guest_Email").get("v.value");
        var gMobile = component.find("guest_Mobile").get("v.value");
        var gLandline = component.find("guest_Landline").get("v.value");
        var gBirthday = component.find("guest_Birthday").get("v.value"); 
        //RADIO BUTTON VARIABLES
        var yesRadio =document.getElementById("yes_radio").checked; 
        var noRadio =document.getElementById("no_radio").checked; 
        //RELATED PERSON VARIABLES
        var rFirstName = component.find("related_FirstName").get("v.value");
        var rMiddleName = component.find("related_MiddleName").get("v.value");
        var rLastName = component.find("related_LastName").get("v.value");
        var rEmail = component.find("related_Email").get("v.value");
        var rMobile = component.find("related_Mobile").get("v.value");
        var rRelationship = component.find("related_Relationship").get("v.value");
        
        var isTrue = true;
        
        //VALIDATION IF SIN IS BLANK
        if ($A.util.isEmpty(gSin)){

            //alert('input sin');
            var errorHolder = component.find('sin-error');
            $A.util.removeClass(errorHolder, 'slds-hide');
            $A.util.addClass(errorHolder, 'sinError');
            isTrue = false;
        } else {

            var errorHolder = component.find('sin-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'sinError');
            
        }
        
        //VALIDATION IF FIRST NAME IS BLANK
        if ($A.util.isEmpty(gFirstName)){

            //alert('input sin');
            var errorHolder = component.find('gFirstName-error');
            $A.util.removeClass(errorHolder, 'slds-hide');
            $A.util.addClass(errorHolder, 'gFirstNameError');
            isTrue = false;
        } else {

            var errorHolder = component.find('gFirstName-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gFirstNameError');
        }
        
        //VALIDATION IF LAST NAME IS BLANK
        if ($A.util.isEmpty(gLastName)){
            
            //alert('input sin');
            var errorHolder = component.find('gLastName-error');
            $A.util.removeClass(errorHolder, 'slds-hide');
            $A.util.addClass(errorHolder, 'gLastNameError');
            isTrue = false;
        } else {
            
            var errorHolder = component.find('gLastName-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gLastNameError');
        }
        
        //VALIDATION IF EMAIL IS BLANK
        if ($A.util.isEmpty(gEmail)){
            
            //alert('input sin');
            var errorHolder = component.find('gEmail-error');
            $A.util.removeClass(errorHolder, 'slds-hide');
            $A.util.addClass(errorHolder, 'gEmailError');
            isTrue = false;
        } else {
            
            var errorHolder = component.find('gEmail-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gEmailError');
        }
        
        //VALIDATION IF MOBILE IS BLANK
        if ($A.util.isEmpty(gMobile)){
            
            //alert('input sin');
            var errorHolder = component.find('gMobile-error');
            $A.util.removeClass(errorHolder, 'slds-hide');
            $A.util.addClass(errorHolder, 'gMobileError');
            isTrue = false;
        } else {
            
            var errorHolder = component.find('gMobile-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gMobileError');
        }
        
        //VALIDATION IF BIRTHDAY IS BLANK
        if ($A.util.isEmpty(gBirthday)){
            
            //alert('input sin');
            var errorHolder = component.find('gBirthday-error');
            $A.util.removeClass(errorHolder, 'slds-hide');
            $A.util.addClass(errorHolder, 'gBirthdayError');
            isTrue = false;
        } else {
            
            var errorHolder = component.find('gBirthday-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gBirthdayError');
        }
        
        //VALIDATION FOR RELATED PERSON ----------------------------------------------------------
        if(yesRadio == true && noRadio == false){
            
            //VALIDATION IF FIRST NAME IS BLANK
            if ($A.util.isEmpty(rFirstName)){
                
                //alert('input sin');
                var errorHolder = component.find('rFirstName-error');
                $A.util.removeClass(errorHolder, 'slds-hide');
                $A.util.addClass(errorHolder, 'rFirstNameError');
                isTrue = false;
                
            } else {
                
                var errorHolder = component.find('rFirstName-error');
                $A.util.addClass(errorHolder, 'slds-hide');
                $A.util.removeClass(errorHolder, 'rFirstNameError');
            }
            
            //VALIDATION IF LAST NAME IS BLANK
            if ($A.util.isEmpty(rLastName)){
                
                //alert('input sin');
                var errorHolder = component.find('rLastName-error');
                $A.util.removeClass(errorHolder, 'slds-hide');
                $A.util.addClass(errorHolder, 'rLastNameError');
                isTrue = false;
                
            } else {
                
                var errorHolder = component.find('rLastName-error');
                $A.util.addClass(errorHolder, 'slds-hide');
                $A.util.removeClass(errorHolder, 'rLastNameError');
            }
            
            //VALIDATION IF EMAIL IS BLANK
            if ($A.util.isEmpty(rEmail)){
                
                //alert('input sin');
                var errorHolder = component.find('rEmail-error');
                $A.util.removeClass(errorHolder, 'slds-hide');
                $A.util.addClass(errorHolder, 'rEmailError');
                isTrue = false;
                
            } else {
                
                var errorHolder = component.find('rEmail-error');
                $A.util.addClass(errorHolder, 'slds-hide');
                $A.util.removeClass(errorHolder, 'rEmailError');
            }
            
            //VALIDATION IF MOBILE IS BLANK
            if ($A.util.isEmpty(rMobile)){
                
                //alert('input sin');
                var errorHolder = component.find('rMobile-error');
                $A.util.removeClass(errorHolder, 'slds-hide');
                $A.util.addClass(errorHolder, 'rMobileError');
                isTrue = false;
                
            } else {
                
                var errorHolder = component.find('rMobile-error');
                $A.util.addClass(errorHolder, 'slds-hide');
                $A.util.removeClass(errorHolder, 'rMobileError');
            }
            
            //VALIDATION IF RELATIONSHIP IS BLANK
            if ($A.util.isEmpty(rRelationship)){
                
                //alert('input sin');
                var errorHolder = component.find('rRelationship-error');
                $A.util.removeClass(errorHolder, 'slds-hide');
                $A.util.addClass(errorHolder, 'rRelationshipError');
                isTrue = false;
                
            } else {
                
                var errorHolder = component.find('rRelationship-error');
                $A.util.addClass(errorHolder, 'slds-hide');
                $A.util.removeClass(errorHolder, 'rRelationshipError');
            }
            
        }
        
        //console.log(istrue);
        if(istrue){
            var setEvent = component.getEvent("callTabEvent");
            setEvent.setParams({"param1":2});
            setEvent.fire();
        } else{
            var setEvent = component.getEvent("callTabEvent");
            setEvent.setParams({"param1":1});
            setEvent.fire();
            
        }

    },
    
    //START BLUR VALIDATION PER FIELD ---------------------------------------------------------------------------------------------------------
    checkOnBlurSin : function(component, event) {
        
        var gSin = component.find("guest_Sin").get("v.value");
        
        if ($A.util.isEmpty(gSin)){
            
            var errorHolder = component.find('sin-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'sinError');
            
        } else {
            
            var errorHolder = component.find('sin-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'sinError');
            
        } 

    },
    
    //START BLUR VALIDATION PER FIELD
    checkOnBlurFirstName : function(component, event) {
        
        var gFirstName = component.find("guest_FirstName").get("v.value");
        
        if ($A.util.isEmpty(gFirstName)){
            
            var errorHolder = component.find('gFirstName-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gFirstNameError');
            
        } else {
            
            var errorHolder = component.find('gFirstName-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gFirstNameError');
            
        }
    },
    
    //START BLUR VALIDATION PER FIELD
    checkOnBlurLastName : function(component, event) {
        
        var gLastName = component.find("guest_LastName").get("v.value");
        
        if ($A.util.isEmpty(gLastName)){
            
            var errorHolder = component.find('gLastName-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gLastNameError');
            
        } else {
            
            var errorHolder = component.find('gLastName-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gLastNameError');
            
        }
    },
    
    //START BLUR VALIDATION PER FIELD
    checkOnBlurEmail : function(component, event) {
        
        var gEmail = component.find("guest_Email").get("v.value");
        
        if ($A.util.isEmpty(gEmail)){
            
            var errorHolder = component.find('gEmail-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gEmailError');
            
            var errorHolder = component.find('gEmailFormat-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gEmailFormatError');
            
        } else{
            
            var errorHolder = component.find('gEmail-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gEmailError');
            
            var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            
            if(gEmail.match(regExpEmailformat)){
                
                var errorHolder = component.find('gEmailFormat-error');
                $A.util.addClass(errorHolder, 'slds-hide');
                $A.util.removeClass(errorHolder, 'gEmailFormatError');
                
            } else{
                
                var errorHolder = component.find('gEmailFormat-error');
                $A.util.removeClass(errorHolder, 'slds-hide');
                $A.util.addClass(errorHolder, 'gEmailFormatError');
                
            }
        }
    },
    
    //START BLUR VALIDATION PER FIELD
    checkOnBlurMobile : function(component, event) {
        
        var gMobile = component.find("guest_Mobile").get("v.value");
        
        if ($A.util.isEmpty(gMobile)){
            
            var errorHolder = component.find('gMobile-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gMobileError');
            
            var errorHolder = component.find('gMobileFormat-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gMobileFormatError');
            
        } else{
            
            var errorHolder = component.find('gMobile-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gMobileError');
            
            var regExpEmailformat = /^(09|\+639)\d{9}$/;
            
            if(gMobile.match(regExpEmailformat)){
                
                var errorHolder = component.find('gMobileFormat-error');
                $A.util.addClass(errorHolder, 'slds-hide');
                $A.util.removeClass(errorHolder, 'gMobileFormatError');
                
            } else{
                
                var errorHolder = component.find('gMobileFormat-error');
                $A.util.removeClass(errorHolder, 'slds-hide');
                $A.util.addClass(errorHolder, 'gMobileFormatError');
                
            }
        }
    },
    
    //START BLUR VALIDATION PER FIELD
    checkOnBlurLandline : function(component, event) {
        
        var gLandline = component.find("guest_Landline").get("v.value");
        
        var regExpEmailformat = /^(02|\+63)\d{7}$/;
        
        if(gLandline.match(regExpEmailformat)){
            
            var errorHolder = component.find('gLandlineFormat-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gLandlineFormatError');
            
        } else {
            
            var errorHolder = component.find('gLandlineFormat-error');
            $A.util.removeClass(errorHolder, 'slds-hide');
            $A.util.addClass(errorHolder, 'gLandlineFormatError');
            
        }
    },
    
    
    //START BLUR VALIDATION PER FIELD
    checkOnBlurBirthday : function(component, event) {
        
        var gBirthday = component.find("guest_Birthday").get("v.value");
        
        if ($A.util.isEmpty(gBirthday)){
            
            var errorHolder = component.find('gBirthday-error');
            $A.util.addClass(errorHolder, 'slds-show');
            $A.util.removeClass(errorHolder, 'gBirthdayError');
            
            
        } else if (!$A.util.isEmpty(gBirthday)){
            
            var errorHolder = component.find('gBirthday-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'gBirthdayError');
            
        }
    },
    
    //RADIO BUTTON SHOW/HIDE DIV FOR RELATED PERSON -------------------------------------------------------------------------------------------------------
    handleRadioClick : function(component, event) {
        
        var yesRadio =document.getElementById("yes_radio").checked; 
        var noRadio =document.getElementById("no_radio").checked; 
        console.log('If yes is ticked Id is: ' + yesRadio);
        console.log('If no is ticked value is: ' + noRadio);
        
        
        if(yesRadio == true && noRadio == false){
            
            //alert('show Div');
            var errorHolder = component.find('relDiv');                       
            $A.util.addClass(errorHolder, 'slds-show');
            $A.util.removeClass(errorHolder, 'slds-hide'); 
                       
            
        } else if(yesRadio == false && noRadio == true){
            
            //alert('hide Div');
            var errorHolder = component.find('relDiv');                       
            $A.util.removeClass(errorHolder, 'slds-show');
            $A.util.addClass(errorHolder, 'slds-hide'); 
        }
    },

	//START ON BLUR VALIDATION FOR RELATED PERSON -------------------------------------------------------------------------------------------------------
    checkOnBlurRelFirstName : function(component, event) {    
    
        var rFirstName = component.find("related_FirstName").get("v.value");
        
        if ($A.util.isEmpty(rFirstName)){
            
            var errorHolder = component.find('rFirstName-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'rFirstNameError');
            
        } else {
            
            var errorHolder = component.find('rFirstName-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'rFirstNameError');
            
        }
    },
    
    checkOnBlurRelLastName : function(component, event) {    
    
        var rLastName = component.find("related_LastName").get("v.value");
        
        if ($A.util.isEmpty(rLastName)){
            
            var errorHolder = component.find('rLastName-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'rLastNameError');
            
        } else {
            
            var errorHolder = component.find('rLastName-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'rLastNameError');
            
        }
    },
    
    checkOnBlurRelEmail : function(component, event) {    
    	
        var rEmail = component.find("related_Email").get("v.value");
        
        if ($A.util.isEmpty(rEmail)){
            
            var errorHolder = component.find('rEmail-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'rEmailError');
            
            var errorHolder = component.find('rEmailFormat-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'rEmailFormatError');
            
        } else{
            
            var errorHolder = component.find('rEmail-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'rEmailError');
            
            var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            
            if(rEmail.match(regExpEmailformat)){
                
                var errorHolder = component.find('rEmailFormat-error');
                $A.util.addClass(errorHolder, 'slds-hide');
                $A.util.removeClass(errorHolder, 'rEmailFormatError');
                
            } else{
                
                var errorHolder = component.find('rEmailFormat-error');
                $A.util.removeClass(errorHolder, 'slds-hide');
                $A.util.addClass(errorHolder, 'rEmailFormatError');
                
            }
        }

    },
    
    checkOnBlurRelMobile : function(component, event) {    
    
        var rMobile = component.find("related_Mobile").get("v.value");
        
        if ($A.util.isEmpty(rMobile)){
            
            var errorHolder = component.find('rMobile-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'rMobileError');
            
            var errorHolder = component.find('rMobileFormat-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'rMobileFormatError');
            
        } else{
            
            var errorHolder = component.find('rMobile-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'rMobileError');
            
            var regExpEmailformat = /^(09|\+639)\d{9}$/;
            
            if(rMobile.match(regExpEmailformat)){
                
                var errorHolder = component.find('rMobileFormat-error');
                $A.util.addClass(errorHolder, 'slds-hide');
                $A.util.removeClass(errorHolder, 'rMobileFormatError');
                
            } else{
                
                var errorHolder = component.find('rMobileFormat-error');
                $A.util.removeClass(errorHolder, 'slds-hide');
                $A.util.addClass(errorHolder, 'rMobileFormatError');
                
            }
        }
    },
    
    checkOnBlurRelRelationship : function(component, event) {    
    	
        var rRelationship = component.find("related_Relationship").get("v.value");
        
        if ($A.util.isEmpty(rRelationship)){
            
            var errorHolder = component.find('rRelationship-error');
            $A.util.addClass(errorHolder, 'slds-show');
            $A.util.removeClass(errorHolder, 'rRelationshipError');
            
            
        } else if (!$A.util.isEmpty(rRelationship)){
            
            var errorHolder = component.find('rRelationship-error');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.removeClass(errorHolder, 'rRelationshipError');
            
        }
    },
})