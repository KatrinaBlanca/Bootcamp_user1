({
    
    onClickUpdateHelper : function (component, event, helper) {
        
        var list;
        var list2;
        var MobileNum     = component.find("cmp_MobileNum").get("v.value");
        var Mobile2       = component.find("cmp_MobileNum2").get("v.value");
        var Phone         = component.find("cmp_landlineNum").get("v.value");
        var Birthdate     = component.find("cmp_bDate").get("v.value");

        console.log('MobileNum: '+MobileNum);
        console.log('Mobile2: '+Mobile2);
        console.log('Phone: '+Phone);
        console.log('Birthdate: '+Birthdate);
        
        
        list  = ["cmp_MobileNum", "cmp_email2", "cmp_bDate"];
        var hasError = this.hasErrorOnFieldList(component, list);
        
        if (!$A.util.isEmpty(Mobile2)){ 
            var regexMobileFormat = /(\+63)[0-9]{10}/;
            var isValid = false;
            
            if(!Mobile2.match(regexMobileFormat)){
                var sampp = component.find("cmp_MobileNum2");
                //START CSM-13668 JRances - Update error message based from R2A Requirements per Lisen
                    sampp.set("v.errors", [{message:"Please input your mobile number in the format +63XXXXXXXXXX."}]);
                    //sampp.set("v.errors", [{message:"Please input your mobile number in the format +639XXXXXXXXX."}]);
                //END CSM-13668 JRances
                hasError = true;
            }
        }
        
        
        if (!$A.util.isEmpty(Phone)){
            
            //START CSM-13668 JRances - Update error message based from R2A Requirements per Lisen
            //var regexPhoneFormat = /(\+63)[0-9]{9}/;
            //var regexPhoneFormat = /(\+63)[0-9]?[0-9]{8}/; //CSM-13668 12.18.2017
            var regexPhoneFormat = /(\+63)[0-9]{1,2}[0-9]{7}/; //CSM-13668 12.18.2017
            //var regexPhoneFormat = /(\+632)[0-9]{7}/;
            if(!Phone.match(regexPhoneFormat)){
                var sampp = component.find("cmp_landlineNum");
                //START CSM-14960 RReyes DEC-22-17 - R2C CR - change error message
                sampp.set("v.errors", [{message:"Please input your landline number in the format +63(area code)xxxxxxx."}]);
                //sampp.set("v.errors", [{message:"Phone should start with +63 then followed by 1 to 2-digit area code and 7-digit number."}]); //CSM-13668 12.18.2017
                //sampp.set("v.errors", [{message:"Phone should start with +632 then followed by 7 digit number."}]);
                //END CSM-14960 RReyes DEC-22-17 - R2C CR - change error message
                hasError = true;
            } 
            //END CSM-13668 JRances
        }
        if(!hasError) {
            
            var action = component.get("c.updateContact");
            var DropImg = component.get("v.DropImg");
            action.setParams({"MobileNum":MobileNum, 
                              "Mobile2":Mobile2, 
                              "Phone":Phone, 
                              "Birthdate":Birthdate,
                              "secondaryEmail":component.get("v.contactDetails.Email2"),
                              "salutation":component.get("v.contactDetails.Salutation"),
                              "googleAcct":component.get("v.contactDetails.googleAcct"),
                              "fbAcct":component.get("v.contactDetails.fbAcct"),
                              "twitterAcct":component.get("v.contactDetails.twitterAcct"),
                              "instagramAcct":component.get("v.contactDetails.instagramAcct")});
          
            action.setCallback(this,function(response){    
                
                var state = response.getState();
                
                if(component.isValid() && (state === "SUCCESS") && response.getReturnValue() != null){    

                    component.set("v.response", response.getReturnValue());

                    var serverResponse = component.get("v.response");
                    if(serverResponse.isSuccess) {
                        var file = component.get("v.imageFile");
                        var dataURL = component.get("v.pictureSrc");
                        
                        var errorHolder = component.find('Notif');
                        $A.util.removeClass(errorHolder, 'hideSuccessMessage');
                        
                        if(DropImg==true){
                            helper.upload(component, file, dataURL.match(/,(.*)$/)[1]); //GVG
                        }
                        
                        //START CSM-14556 R2B Retrofit
                        setTimeout(function(){ 
                            
                            var errorHolder = component.find('Notif');
                            $A.util.addClass(errorHolder, 'hideSuccessMessage');
                            
                            $A.get('e.force:refreshView').fire();   
                        }, 6000);
                        //END CSM-14556 R2B Retrofit
                        
                       
                    } else {
                        this.fireError(serverResponse.errorMessage);
                    }
                    
                } else{
                    console.log("Failed: " + response.getReturnValue());
                }
            });  
            $A.enqueueAction(action);        
        }
    },
    
    isFieldUndefined : function(cmpTarget) {
        
        if($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value"))){   
            //START CSM-13659 JRances - Update error message on Required Fields
                cmpTarget.set("v.errors", [{message:"Please input all required fields."}]);
                //cmpTarget.set("v.errors", [{message:"Please input up the required fields."}]);
            //END CSM-13659 JRances
            return true;   
            
        } else {
            cmpTarget.set("v.errors",null);
            return false;
        }
    },
    
    hasErrorOnFieldList: function(component, list) {
        
        var ctr = 0;
        var i = 0;
        
        for (i = 0; i < list.length; i++) {                
            if(list[i] != "cmp_email2" && list[i] != "cmp_bDate" && this.isFieldUndefined(component.find(list[i])) ) {
                ctr++;
                continue;
            }
            if(this.hasInvalidFormat(component.find(list[i]), list[i])) {
                ctr++;
            }
        }
        return (ctr > 0);
    },
    
    
    
    hasInvalidMobileFormat : function (cmpTarget) {
        
        var regexMobileFormat = /(\+63)[0-9]{10}/;
        //START CSM-13668 JRances - Update error message based from R2A Requirements per Lisen
        	var errorMessage = "Please input your mobile number in the format +63XXXXXXXXXX.";
        	//var errorMessage = "Please input your mobile number in the format +639XXXXXXXXX.";
        //END CSM-13668 JRances
        if(!cmpTarget.get("v.value").match(regexMobileFormat) && !$A.util.isEmpty(cmpTarget.get("v.value"))){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },
    
    
    
    hasInvalidPhoneFormat : function (cmpTarget) {
        //var regexMobileFormat = /(\+63)[0-9]?[0-9]{8}/; //CSM-13668 12.18.2017
        var regexMobileFormat = /(\+63)[0-9]{2}[0-9]{7}/; //CSM-13668 12.18.2017
        //START CSM-14960 RReyes DEC-22-17 - R2C CR - change error message
        var errorMessage = "Please input your landline number in the format +63(area code)xxxxxxx.";
        //var errorMessage = "Phone should start with +63 then followed by 2-digit area code and 7 digit number.";
        //END CSM-14960 RReyes DEC-22-17 - R2C CR - change error message
        if(!cmpTarget.get("v.value").match(regexMobileFormat) && !$A.util.isEmpty(cmpTarget.get("v.value"))){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },
    
    hasInvalidFormat : function (cmpTarget, auraId) {
        var isInvalid = false;        
        
        if(auraId === "cmp_MobileNum"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }
        
        if(auraId === "cmp_MobileNum2"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }
        
        if(auraId === "cmp_landlineNum"){
            isInvalid = this.hasInvalidPhoneFormat(cmpTarget);
        }

        if(auraId === "cmp_email2"){
            if(!($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value")))) {
                isInvalid = this.hasInvalidEmailFormat(cmpTarget);
            }
        }

        if(auraId === "cmp_bDate"){
            if(!($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value")))) {
                isInvalid = this.hasInvalidDate(cmpTarget);
            }
        }
        // if(auraId === "cmp_bDate"){
        //     isInvalid = this.hasInvalidDate(cmpTarget);
        // }
        return isInvalid;
    },
    
    hasInvalidEmailFormat : function (cmpTarget) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var errorMessage = "Please enter a valid email address.";
        if(!cmpTarget.get("v.value").match(regExpEmailformat)){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },
    
    editProfileCancelHelper : function(component, event, helper) { 
        component.set("v.showCancelModal", true);
    },
    
    
    removeMessageSuccessHelper : function(component, event, helper) {
        var errorHolder = component.find('secondMobileErrorFormat');       
        $A.util.removeClass(errorHolder, 'slds-show');
        $A.util.addClass(errorHolder, 'slds-hide');
    },
    
    removeMessageSuccessHelper2 : function(component, event, helper) {
        var errorHolder = component.find('landlineErrorFormat');
        $A.util.addClass(errorHolder, 'slds-hide');
        $A.util.removeClass(errorHolder, 'slds-show');
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
    
    readFile: function(component, helper, file) {
        if (!file) return;
        var reader = new FileReader();
        reader.onloadend = function() {
            var dataURL = reader.result;
            //console.log(dataURL);
            component.set("v.pictureSrc", dataURL);
            //helper.upload(component, file, dataURL.match(/,(.*)$/)[1]);
            component.set("v.message", "Please click save"); //
        };
        reader.readAsDataURL(file);
    },
    
    upload: function(component, file, base64Data) {
        var action = component.get("c.saveAttachment"); 
        action.setParams({
            "parentId": component.get("v.recordId"),
            "fileName": file.name,
            "base64Data": base64Data, 
            "contentType": file.type
        });
        console.log('>>>>>>>>>>>>> 1');
        action.setCallback(this, function(a) {
            component.set("v.message", "Image uploaded");
        });
        console.log('>>>>>>>>>>>>> 2');
        component.set("v.message", "Uploading...");
        $A.enqueueAction(action); 
    },
    
    helperHidePriNumError: function(component, event, helper) {
        var fieldValue = component.find("cmp_MobileNum").get("v.value");
        
        if($A.util.isEmpty(fieldValue)){
            var sampp = component.find("cmp_MobileNum");
            sampp.set("v.errors", null);
        } else {
            var sampp = component.find("cmp_MobileNum");
            sampp.set("v.errors", null);          
            
        }
        
    },
    
    helperHideSecNumError: function(component, event, helper) {
        var fieldValue = component.find("cmp_MobileNum2").get("v.value");
        
        if($A.util.isEmpty(fieldValue)){
            var sampp = component.find("cmp_MobileNum2");
            sampp.set("v.errors", null);
        } else {
            var sampp = component.find("cmp_MobileNum2");
            sampp.set("v.errors", null);          
            
        }
        
    },

    helperHideLandNumError: function(component, event, helper) {
        var fieldValue = component.find("cmp_landlineNum").get("v.value");
        
        if($A.util.isEmpty(fieldValue)){
            var sampp = component.find("cmp_landlineNum");
            sampp.set("v.errors", null);
        } else {
            var sampp = component.find("cmp_landlineNum");
            sampp.set("v.errors", null);          
            
        }
        
    },

    getSalutations: function(component, event, helper) {   
        var action = component.get("c.getSalutations");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){                
                component.set("v.salutationList", a.getReturnValue());
            }  
        });
        $A.enqueueAction(action); 
        
    },

    createToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"title": title ,
                              "message":message ,
                              "type": type,
                              "duration": 6000
                             });
        toastEvent.fire();
    },

    fireError : function(message) {
        this.createToast('', message, "error");
    },
    // //START CSM-13709 JRances - Remove Placeholder if there is Birthdate provided
    // removePlaceholderInit: function(component, event, helper) {  
    //     var bDate = component.get("v.contactDetails.Birthdate");
    //     var cmpTarget = component.find("birthDateDiv");
    //     if(bDate) {
    //         $A.util.removeClass(cmpTarget, "CXE_myProfileDatePHolder");
    //         //cmpTarget.classList.remove('slds-hide');
    //         // document.getElementById('signupToggleBox').classList.remove("CXE_placeHolderFix");
    //     } else {
    //         $A.util.addClass(cmpTarget, "CXE_myProfileDatePHolder");
    //         //cmpTarget.className += 'slds-hide';
    //         // document.getElementById('signupToggleBox').classList.add("CXE_placeHolderFix");
    //     }
    // //END CSM-13709 JRances
    // },

    removeCSSPlaceholder : function(component, event, helper) {
        var bDate = component.get("v.contactDetails.Birthdate");
        var cmpTarget = component.find("birthDateDiv");
        if(bDate) {
            $A.util.removeClass(cmpTarget, "CXE_myProfileDatePHolder");
            //cmpTarget.classList.remove('slds-hide');
            // document.getElementById('signupToggleBox').classList.remove("CXE_placeHolderFix");
        } else {
            $A.util.addClass(cmpTarget, "CXE_myProfileDatePHolder");
            //cmpTarget.className += 'slds-hide';
            // document.getElementById('signupToggleBox').classList.add("CXE_placeHolderFix");
        }
    },

    hasInvalidDate : function (cmpTarget) {
        var errorMessage = "Please enter valid date.";
        var valid = true;
        var inputDate = cmpTarget.get("v.value");
        var d = new Date(inputDate);   
        if (Object.prototype.toString.call(d) === "[object Date]") {
            valid =!isNaN(d);            
        }else {
            valid = false;
        }
        
        if(!valid){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
        } else {
            cmpTarget.set("v.errors", null);
        }

        return !valid;
    }

    // START CSM-14554 Jerome To 11/20/2017 Prompt that the user can edit the profile information but it doesn’t tell where the user can edit it.
    ,removeParamGetInfo : function (component, event, helper) {

        var sURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sURL.split("&");
        var sParamNameAndValue, sParameterName, i, sParameterValue;

        for (i = 0; i < sURLVariables.length; i++) {    
            sParamNameAndValue = sURLVariables[i].split("=");
            sParameterName = sParamNameAndValue[0];
            if(sParameterName === "getInfo") {
                sParameterValue = sParamNameAndValue[1];
            }
        }

        if(sParameterValue ) {
            var pageUrl = window.location.protocol + "//" + window.location.hostname + "/"
                       + window.location.pathname.split("/")[1] + "/"
                       + window.location.pathname.split("/")[2] + "/profile";
            window.history.pushState("", "", pageUrl);
            window.location.assign(pageUrl);

            // $A.get('e.force:refreshView').fire();
            // window.location.reload(true);
            // var urlEvent = $A.get("e.force:navigateToURL");
            // urlEvent.setParams({
            //   "url": pageUrl
            // });
            // urlEvent.fire();


            // window.history.pushState("", "", pageUrl);
        }
    }
    // END CSM-14554 Jerome To 11/20/2017 Prompt that the user can edit the profile information but it doesn’t tell where the user can edit it.


})