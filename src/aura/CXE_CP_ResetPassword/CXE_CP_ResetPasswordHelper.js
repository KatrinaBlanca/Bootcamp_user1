({
    helperResetPassword : function(component, event) {

        var p1 = component.find("cp_initpass").get("v.value");
        var p2 = component.find("cp_confirminitpass").get("v.value");
        var p3 = component.get("v.LabelIndicator");
        var indicator = component.get("v.LabelIndicator"); //Start/End R2C CSM-14982 Von Pernicia
               
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //get whole URL of the page
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var sParameterName2;
        var i;
		
        /* Author: Rj Rances		Date: 8/3/2017
         * Description:	Updated codes below to specify where the user should
         * 				be redirected after resetting/setting password
         * 				if there is a param = page value in the URL           
         * */
        
        var UserId;
        var Page;
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if(sParameterName[0]=='id'){
                UserId = sParameterName[1];
            }
            if(sParameterName[0]=='page'){
                Page = sParameterName[1];
            }
        }
        
        
        
        /* Author: Rj Rances			Date: 8/10/2017
         * Description: Reworked validation upon submit click
         * 				checks if fields are blank, password match
         * 				and if password met requirements
         * */
        if($A.util.isEmpty(p1) && $A.util.isEmpty(p2)){ 
            // Start R2C CSM-14982 Von Pernicia
            if (indicator == 'Set') {
                this.showBlankInitErrorSet(component, event);
                this.hideBlankConfirmErrorSet(component, event);
                this.hidePassDontMatchErrorSet(component, event);
            } else {
                this.showBlankInitError(component, event);
                this.hideBlankConfirmError(component, event);
                this.hidePassDontMatchError(component, event);
            }
            // End R2C CSM-14982 Von Pernicia
        } else if(!$A.util.isEmpty(p1) && $A.util.isEmpty(p2)){ 
            // Start R2C CSM-14982 Von Pernicia
            if (indicator == 'Set') {
                this.hideBlankInitErrorSet(component, event);
                this.showBlankConfirmErrorSet(component, event);
            } else {
                this.hideBlankInitError(component, event);
                this.showBlankConfirmError(component, event);
            }
            // End R2C CSM-14982 Von Pernicia
        } else if ($A.util.isEmpty(p1) && !$A.util.isEmpty(p2)){
            // Start R2C CSM-14982 Von Pernicia
            if (indicator == 'Set') {
                this.showBlankInitErrorSet(component, event);
                this.hideBlankConfirmErrorSet(component, event);
                this.hidePassDontMatchErrorSet(component, event);
            } else {
                this.showBlankInitError(component, event);
                this.hideBlankConfirmError(component, event);
                this.hidePassDontMatchError(component, event);//Rabayon for CSM-13798 10/09/17
            }
            // End R2C CSM-14982 Von Pernicia
        } else if (!$A.util.isEmpty(p1) && $A.util.isEmpty(p2)){
            // Start R2C CSM-14982 Von Pernicia
            if (indicator == 'Set') {
                this.hideBlankInitErrorSet(component, event);
                this.showBlankConfirmErrorSet(component, event);
                this.hidePassDontMatchErrorSet(component, event);
            } else {
                this.hideBlankInitError(component, event);
                this.showBlankConfirmError(component, event);
                this.hidePassDontMatchError(component, event);
            }
            // End R2C CSM-14982 Von Pernicia
            this.validateInitPass(component, event);
            
            if(p1.length <=7){
            this.showReqError(component, event);
            } else {
                if(!p1.match("[A-Z]")){                
                    this.showReqError(component, event);
                } else if(!p1.match("[a-z]")){   
                    this.showReqError(component, event);
                } else if(!p1.match("[0-9]")){     
                    this.showReqError(component, event);
            //START CSM-14670 11.24.2017 GGrandea - remove special characters from password pages
                //START CSM-13945 JRances / UAT, Include in Special Character for 'Change Password', (!@#$%&^) [!#$%=_+<>-] [!@#$%^&]
                /*} else if(!p1.match("[!#$%=_+<>-]")){
                    this.showReqError(component, event);*/
                //END CSM-13945 JRances
            //END CSM-14670 11.24.2017 GGrandea
                } else {
                    this.hideReqError(component, event);
                }
            }
            
        } else {
            // Start R2C CSM-14982 Von Pernicia
            if (indicator == 'Set') {
                this.hideBlankInitErrorSet(component, event);
                this.hideBlankConfirmErrorSet(component, event);
            } else {
                this.hideBlankInitError(component, event);
                this.hideBlankConfirmError(component, event);
            }            
			// End R2C CSM-14982 Von Pernicia
            if(p1.length <=7){
            this.showReqError(component, event);
            } else {
                if(!p1.match("[A-Z]")){         
                    this.showReqError(component, event);
                } else if(!p1.match("[a-z]")){   
                    this.showReqError(component, event);
                } else if(!p1.match("[0-9]")){     
                    this.showReqError(component, event);
            //START CSM-14670 11.24.2017 GGrandea - remove special characters from password pages
                //START CSM-13945 JRances / UAT, Include in Special Character for 'Change Password', (!@#$%&^) [!#$%=_+<>-] [!@#$%^&]
                /*} else if(!p1.match("[!#$%=_+<>-]")){
                    this.showReqError(component, event);*/
            //END CSM-14670 11.24.2017 GGrandea
                //END CSM-13945 JRances
                } else {
                    this.hideReqError(component, event);
                }
            }

            if(p1 != p2){
                // Start R2C CSM-14982 Von Pernicia
                if (indicator == 'Set') {
                    this.showPassDontMatchErrorSet(component, event);
                } else {
                    this.showPassDontMatchError(component, event);   
                }
                // End R2C CSM-14982 Von Pernicia
            } else {
                // Start R2C CSM-14982 Von Pernicia
                if (indicator == 'Set') {
                    this.hidePassDontMatchErrorSet(component, event);
                } else {
                    this.hidePassDontMatchError(component, event);
                }
                // End R2C CSM-14982 Von Pernicia
                var action = component.get("c.getChangePassword");
                action.setParams({"initPass":p1 , "confirmInitPass":p2 , "user_id": UserId, "Page": Page, "Action":p3});
                
                action.setCallback(this,function(response){  
                    
                    var state = response.getState();
                    if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                        console.log(response.getReturnValue());
                        
                        /* Author: Joebhelle Rances
                        *  Date:   09/20/2017
                        *  Description: CSM 12507 and CSM 12594 - For Password Already Used Notification/Error Message/Exception Display
                        */ 
                        var retException = response.getReturnValue();
                        var message = retException.split(": ");
                        var res = message[1];

                        var splitStr = res.toLowerCase().split(' ');
                        for (var i = 0; i < splitStr.length; i++) {
                            splitStr[i] = splitStr[i].charAt(0).toUpperCase() + splitStr[i].substring(1);     
                        }
                        var errorException = splitStr.join(' '); 

                        if(retException != null){
                            //component.set("v.setPassException", errorException);
                            //this.showPasswordException(component, event);
                            if(!p1.match("[A-Z]")){         
                                component.set("v.setPassException", '');
                                this.hidePasswordException(component, event);
                            } else if(!p1.match("[a-z]")){   
                                component.set("v.setPassException", '');
                                this.hidePasswordException(component, event);
                            } else if(!p1.match("[0-9]")){     
                                component.set("v.setPassException", '');
                                this.hidePasswordException(component, event);
                        //START CSM-14670 11.24.2017 GGrandea - remove special characters from password pages
                            //START CSM-13945 JRances / UAT, Include in Special Character for 'Change Password', (!@#$%&^) [!#$%=_+<>-] [!@#$%^&]
                            /*} else if(!p1.match("[!#$%=_+<>-]")){
                                component.set("v.setPassException", '');
                                this.hidePasswordException(component, event);*/
                            //END CSM-13945 JRances
                        //END CSM-14670 11.24.2017 GGrandea
                        //START CSM-14534  12/18/2017 JIntal
                            } else if(p1.length <=7){ //12/19/2017 JRances Change !p1 to p1
                                component.set("v.setPassException", '');
                                this.hidePasswordException(component, event);
                            } else {
                                component.set("v.setPassException", errorException);
                                this.showPasswordException(component, event);
                            }
                         //END CSM-14534  12/18/2017 JIntal
                        } else {
                            component.set("v.setPassException", ' ');
                            this.hidePasswordException(component, event);
                        }
                        //End CSM 12507 and CSM 12594
						                       
                    }else{
                        console.log("Failed With state: " + state);
                        console.log("Returned:");
                        console.log('What: >>>>>>>>>>>>'+response.getReturnValue());
                    }
                });  
                $A.enqueueAction(action);  
                
            }
        }
    },
    
    
    validateInitPass : function(component, event) {
        var p1 = component.find("cp_initpass").get("v.value");
        if(p1.length <=7){
            this.showReqError(component, event);
            } else {
                if(!p1.match("[A-Z]")){         
                    this.showReqError(component, event);
                } else if(!p1.match("[a-z]")){   
                    this.showReqError(component, event);
                } else if(!p1.match("[0-9]")){     
                    this.showReqError(component, event);
            //START CSM-14670 11.24.2017 GGrandea - remove special characters from password pages
                //START CSM-13945 JRances / UAT, Include in Special Character for 'Change Password', (!@#$%&^) [!#$%=_+<>-] [!@#$%^&]
                /*} else if(!p1.match("[!#$%=_+<>-]")){
                    this.showReqError(component, event);*/
                //END CSM-13945 JRances
            //END CSM-14670 11.24.2017 GGrandea
                } else {
                    this.hideReqError(component, event);
                }
            }
    },    
    
    
    /* Showing of errors ------------------------------------------------------------------------------------------------------------------------
     * */
    showBlankInitError : function(component, event) {
        var changeElement = component.find("blankInitError");        
        $A.util.removeClass(changeElement, 'slds-hide');
        $A.util.addClass(changeElement, 'slds-show');
    },
    // Start R2C CSM-14982 Von Pernicia
    showBlankInitErrorSet : function(component, event) {
        var changeElement = component.find("blankInitErrorSet");        
        $A.util.removeClass(changeElement, 'slds-hide');
        $A.util.addClass(changeElement, 'slds-show');
    },
    // End R2C CSM-14982 Von Pernicia
    showBlankConfirmError : function(component, event) {
        var changeElement = component.find("blankConfirmError");        
        $A.util.removeClass(changeElement, 'slds-hide');
        $A.util.addClass(changeElement, 'slds-show');
    },
    // Start R2C CSM-14982 Von Pernicia
    showBlankConfirmErrorSet : function(component, event) {
        var changeElement = component.find("blankConfirmErrorSet");        
        $A.util.removeClass(changeElement, 'slds-hide');
        $A.util.addClass(changeElement, 'slds-show');
    },
    // End R2C CSM-14982 Von Pernicia
    showPassDontMatchError : function(component, event) {
        var changeElement = component.find("passDontMatchError");        
        $A.util.removeClass(changeElement, 'slds-hide');
        $A.util.addClass(changeElement, 'slds-show');
    },
    // Start R2C CSM-14982 Von Pernicia
    showPassDontMatchErrorSet : function(component, event) {
        var changeElement = component.find("passDontMatchErrorSet");        
        $A.util.removeClass(changeElement, 'slds-hide');
        $A.util.addClass(changeElement, 'slds-show');
    },
    // End R2C CSM-14982 Von Pernicia
    showReqError : function(component, event) {
        var changeElement = component.find("reqError");        
        $A.util.removeClass(changeElement, 'slds-hide');
        $A.util.addClass(changeElement, 'slds-show');
    },
    /* Author: Joebhelle Rances
     *  Date:   09/18/2017
     *  Description: CSM 12594 - For Password Already Used Notification/Error Message
     */ 
    showPasswordUsedError : function(component, event) {
        var changeElement = component.find("passwordUsedError");        
        $A.util.removeClass(changeElement, 'slds-hide');
        $A.util.addClass(changeElement, 'slds-show');
    },
    //End CSM 12594
    //CSM 12507
    showPasswordException : function(component, event) {
        var changeElement = component.find("passwordException");        
        $A.util.removeClass(changeElement, 'slds-hide');
        $A.util.addClass(changeElement, 'slds-show');
    },
    //End CSM 12507
    
    /* Hiding of errors ------------------------------------------------------------------------------------------------------------------------
     * */
    hideBlankInitError : function(component, event) {
        var changeElement = component.find("blankInitError");        
        $A.util.removeClass(changeElement, 'slds-show');
        $A.util.addClass(changeElement, 'slds-hide');
    },
    // Start R2C CSM-14982 Von Pernicia
    hideBlankInitErrorSet : function(component, event) {
        var changeElement = component.find("blankInitErrorSet");        
        $A.util.removeClass(changeElement, 'slds-show');
        $A.util.addClass(changeElement, 'slds-hide');
    },
    // End R2C CSM-14982 Von Pernicia
    hideBlankConfirmError : function(component, event) {
        var changeElement = component.find("blankConfirmError");        
        $A.util.removeClass(changeElement, 'slds-show');
        $A.util.addClass(changeElement, 'slds-hide');
    },
    // Start R2C CSM-14982 Von Pernicia
    hideBlankConfirmErrorSet : function(component, event) {
        var changeElement = component.find("blankConfirmErrorSet");        
        $A.util.removeClass(changeElement, 'slds-show');
        $A.util.addClass(changeElement, 'slds-hide');
    },
    // End R2C CSM-14982 Von Pernicia
    hidePassDontMatchError : function(component, event) {
        var changeElement = component.find("passDontMatchError");        
        $A.util.removeClass(changeElement, 'slds-show');
        $A.util.addClass(changeElement, 'slds-hide');
    },
    // Start R2C CSM-14982 Von Pernicia
    hidePassDontMatchErrorSet : function(component, event) {
        var changeElement = component.find("passDontMatchErrorSet");        
        $A.util.removeClass(changeElement, 'slds-show');
        $A.util.addClass(changeElement, 'slds-hide');
    },
    // End R2C CSM-14982 Von Pernicia
    hideReqError : function(component, event) {
        var changeElement = component.find("reqError");        
        $A.util.removeClass(changeElement, 'slds-show');
        $A.util.addClass(changeElement, 'slds-hide');
    },
    /* Author: Joebhelle Rances
     *  Date:   09/18/2017
     *  Description: CSM 12594 - For Password Already Used Notification/Error Message
     */
	hidePasswordUsedError : function(component, event) {
        var changeElement = component.find("passwordUsedError");        
        $A.util.removeClass(changeElement, 'slds-show');
        $A.util.addClass(changeElement, 'slds-hide');
    }, 
    //End CSM 12594
    //CSM 12507
    hidePasswordException : function(component, event) {
        var changeElement = component.find("passwordException");        
        $A.util.removeClass(changeElement, 'slds-show');
        $A.util.addClass(changeElement, 'slds-hide');
    }, 
    //End CSM 12507
    
    /* Flipping of requirement icons ----------------------------------------------------------------------------------------------------------
     * */
    uncheckUP : function(component, event) {
        var changeElement = component.find("up_check");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
        
        var changeElement = component.find("up_uncheck");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
    },
    uncheckLW : function(component, event) {
        var changeElement = component.find("lw_check");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
        
        var changeElement = component.find("lw_uncheck");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
    },
    uncheckNum : function(component, event) {
        var changeElement = component.find("num_check");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
        
        var changeElement = component.find("num_uncheck");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
    },
    uncheckChar : function(component, event) {
        var changeElement = component.find("sp_check");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
        
        var changeElement = component.find("sp_uncheck");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
    },
    checkUP : function(component, event) {
        var changeElement = component.find("up_check");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
        var changeElement = component.find("up_uncheck");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
    },
    checkLW : function(component, event) {
        var changeElement = component.find("lw_check");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
        var changeElement = component.find("lw_uncheck");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
    },
    checkNum : function(component, event) {
        var changeElement = component.find("num_check");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
        var changeElement = component.find("num_uncheck");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
    },
    checkChar : function(component, event) {
        var changeElement = component.find("sp_check");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
        var changeElement = component.find("sp_uncheck");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
    },
    
    /* Clearing all error messages in the screen
     * */
    helperClearAllErrorMsgs : function(component, event) {
        var errorHolder = component.find('reqError');
        $A.util.removeClass(errorHolder, 'slds-show');
        $A.util.addClass(errorHolder, 'slds-hide');
        
        /* Author: Joebhelle Rances
         *  Date:   09/18/2017
         *  Description: CSM 12594 - For Password Already Used Notification/Error Message/Exception Display
         */
        var changeElement = component.find("passwordUsedError");        
        $A.util.removeClass(changeElement, 'slds-show');
        $A.util.addClass(changeElement, 'slds-hide');
        
        var changeElement = component.find("passwordException");        
        $A.util.removeClass(changeElement, 'slds-show');
        $A.util.addClass(changeElement, 'slds-hide');
        //End CSM 12594
    },
    
    //START CSM-13900 GGrandea 10.13.2017
    verifyPortalUserId : function(component, event) {
        var action = component.get("c.verifyPortalUser");
        action.setParams({"user_id":component.get("v.user_id"), 
            "action":component.get("v.LabelIndicator"),
            "guid":component.get("v.guid")}); // LISEN CSM-14898
        
        action.setCallback(this,function(response){  
            
            var state = response.getState();
            console.log("state: " + state );
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue() != null){
                var response = response.getReturnValue();
                console.log("response: " + response );

                var compToShow = component.find("mainPanel");
                if(response=='expired'){
                    compToShow = component.find("expiredMsgPanel");
                }
                $A.util.removeClass(compToShow, 'slds-hide');


            }else{
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log('What: >>>>>>>>>>>>'+response.getReturnValue());
            }
        });  
        $A.enqueueAction(action); 
    }, 
    //End CSM-13900

})