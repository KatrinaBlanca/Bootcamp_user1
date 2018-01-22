({
    submitForm : function(component) {
        
        /* Author: Rj Rances Date: 7/28/2017
         * Description: Added Variable "Page", Redirection if "?=page" has value
         * */
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //get whole URL of the page
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
        
        var Page;
        var sinNo;
        var acctNo;
        var bpBillDt;        
        var bpinvoiceDate;
        var bpBillId; //CSM-14200 added bpBillId 11.15.2017 //CSM-14664 JRances [R2B WARRANTY] - User is not redirected to the correct page.
        var startURL;
        
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
            
            if(sParameterName[0]=='page'){
                Page = sParameterName[1];
            }
            if(sParameterName[0]=='sinNo'){
                sinNo = sParameterName[1];
            }
            if(sParameterName[0]=='acctNo'){
                acctNo = sParameterName[1];
            }
            if(sParameterName[0]=='bpBillDt'){
                bpBillDt = sParameterName[1];
            }
            if(sParameterName[0]=='bpinvoiceDate'){
                bpinvoiceDate = sParameterName[1];
            }
            //START CSM-14664 JRances [R2B WARRANTY] - User is not redirected to the correct page.
            if(sParameterName[0]=='bpBillId'){ //CSM-14200 added bpBillId 11.15.2017
                bpBillId = sParameterName[1];
            }
            //END CSM-14664 
            if(sParameterName[0]=='startURL'){
                startURL = sURLVariables[i].substring(sURLVariables[i].indexOf('=') + 1);
            }
        }

        var loginEmail = component.find("input_email");
        var loginEmailValue = loginEmail.get("v.value");
        var isValid = true;
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        var loginPass = component.find("input_password");
        var loginPassValue = loginPass.get("v.value");
        loginEmail.set("v.errors", [{message:""}]);
        loginPass.set("v.errors", [{message:""}]);
        
        //START CSM-13063 JRances - Removed red highlight after clicking submit
        //START CSM-14494 RReyes NOV-25-17
        var hasEmptyField = false;
        if (!$A.util.isEmpty(loginEmailValue)) {
            if(!loginEmailValue.match(regExpEmailformat)){
                loginEmail.set("v.errors", [{message:"Invalid Email Format"}]);
                isValid = false;
            } else {
                loginEmail.set("v.errors", null);
            }
        }else{
            isValid = false;
            hasEmptyField = true;
        }
        
        if ($A.util.isEmpty(loginPassValue)) {
            hasEmptyField = true;
            isValid = false;
        }else {
            loginPass.set("v.errors", null);
        }
        //END CSM-14494 RReyes NOV-25-17
        /*if ($A.util.isEmpty(loginEmailValue)) {
            loginEmail.set("v.errors", [{message:"Email Address Can't be Empty"}]);
            isValid = false;
        }else{
            if(!loginEmailValue.match(regExpEmailformat)){
                loginEmail.set("v.errors", [{message:"Invalid Email Format"}]);
                isValid = false;
            } else {
                loginEmail.set("v.errors", null);
            }
        }
        
        if ($A.util.isEmpty(loginPassValue)) {
            loginPass.set("v.errors", [{message:"Password Can't be Empty"}]);
            isValid = false;
        } else {
            loginPass.set("v.errors", null);
        }*/
        //END CSM-13063
        if(isValid){
            var action = component.get("c.getLoginDetails");
            action.setParams({"LoginDetail":loginEmailValue 
                              , "PassDetail":loginPassValue
                              , "Page":Page
                              , "acctNo": acctNo
                              , "sinNo": sinNo
                              , "bpBillDt": bpBillDt                              
                              , "bpinvoiceDate": bpinvoiceDate
                              , "bpBillId": bpBillId //CSM-14200 added bpBillId 11.15.2017 //CSM-14664 JRances [R2B WARRANTY] - User is not redirected to the correct page.
                              , "startURL":startURL
                             });//"user_id": UserId, 
            
            action.setCallback(this,function(response){          
                var state = response.getState();
                if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                    if(response.getReturnValue() != null)
                    {
                        console.log(response.getReturnValue());
                        if(!response.getReturnValue().isSuccess){
                            
                            //START CSM-14857 JRances 12/11/2017 - [R3A REGRESSION] Notification Update
                            var getRetVal = response.getReturnValue().message;
                            var apexRetMsg = 'Your account has now been locked for security purposes.';
                            var lockedPrompt = 'Your account has now been locked for security purposes. Please reset your password by clicking on Forgot Password.';
                            var toastEvent = $A.get("e.force:showToast");
                            
                            if(getRetVal.match(apexRetMsg)){
                                toastEvent.setParams({"title": " ",
                                                      "message": lockedPrompt,
                                                      "type": "info",
                                                      "duration": 6000
                                                     });
                                toastEvent.fire();
                            } else {
                                toastEvent.setParams({"title": " ",
                                                      "message": response.getReturnValue().message,
                                                      "type": "info",
                                                      "duration": 6000
                                                     });
                                toastEvent.fire();
                            }
                            /*
                            var toastEvent = $A.get("e.force:showToast");
                            //START CSM-13763 JRances - Removing title on Toast
                            //toastEvent.setParams({"title": "Error!",
                            toastEvent.setParams({"title": " ",
                                                  "message": response.getReturnValue().message,
                                                  "type": "info",     //CSM-1945
                                                    "duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
                            });
                            //END CSM-13763 JRances
                            toastEvent.fire();
                            */
                            //END CSM-14857 JRances
                        }
                        
                    }
                    else{
                        var errorHolder = component.find('pw-error');
                        $A.util.removeClass(errorHolder, 'Hideme');
                        $A.util.addClass(errorHolder, 'pw-error');
                        console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
                    }
                }else{
                    console.log("Failed With state: " + state);
                    console.log("Returned:");
                    console.log(response.getReturnValue());
                }
            });  
            $A.enqueueAction(action);        
        } 
        //START CSM-14494 RReyes NOV-25-17
        if (hasEmptyField){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({"title": " ",
                                  "message": "Please enter your username and/or password.",
                                  "type": "info",
                                  "duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
            });
            toastEvent.fire();
        }
        //END CSM-14494 RReyes NOV-25-17
    },
    
    setCookie : function (component, event, helper){
		var isRem = component.find("rem_me").get("v.value");
		var userName = component.find("input_email").get("v.value");
		var today  = new Date();
		today.setTime(today.getTime() + (365 * 24 * 60 * 60 * 1000));
		var expires = "expires=" + today.toUTCString();
        
		if(isRem)
			document.cookie = "RemMe=" + userName + ";" + expires + ";path=/";
		else
			document.cookie = "RemMe=;" + expires + ";path=/";
	},
	
	initializeForm: function(component) {
        //Set "Remembered Name"
		var name = "RemMe=";
		var remName = "";
		var ca = document.cookie.split(';');
		for(var i = 0; i < ca.length; i++) {
			var c = ca[i];
			while (c.charAt(0) == ' ') {
				c = c.substring(1);
			}
			if (c.indexOf(name) == 0) {
				remName = c.substring(name.length, c.length);
			}
		}
		var inputEmail = component.find("input_email");
        inputEmail.set("v.value", remName); 
        
        if(remName != null)
            component.find("rem_me").set("v.value", true);
    },
    
    getStartURL: function(component) {
        var startURL;
        var sParameterName;
        var i;
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //get whole URL of the page
        
        if(sPageURL != null && sPageURL != '')
        {
            var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
            
            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('='); //to split the key from the value.
                if(sParameterName[0]=='startURL'){
                    startURL = sURLVariables[i].substring(sURLVariables[i].indexOf('=') + 1);
                }
            }
        }

        return startURL;
    },
    
    //START CSM-14664 JRances [R2B WARRANTY] - User is not redirected to the correct page.
    //START CSM-14200 JRances / UAT, Bills link from Marketing Cloud does not automatically direct to Viewbills
    goForRedirection : function(component, helper) {

        var query = helper.url_param();

        query.page = query.page || ''; //set query.page to '' if it is undefined(null)
        query.sinNo = query.sinNo || ''; //set query.sinNo to '' if it is undefined(null)
        query.acctNo = query.acctNo || ''; //set query.acctNo to '' if it is undefined(null)
        query.bpBillDt = query.bpBillDt || ''; //set query.bpBillDt to '' if it is undefined(null)
        query.bpinvoiceDate = query.bpinvoiceDate || ''; //set query.bpinvoiceDate to '' if it is undefined(null)
        query.bpBillId = query.bpBillId || ''; //set query.bpBillId to '' if it is undefined(null)
        
        if(query.bpinvoiceDate != '' && query.acctNo != '' && query.page =='viewbills'){
            var action = component.get("c.redirectToViewBills");
            action.setParams({"Page":query.page
                              , "acctNo": query.acctNo
                              , "sinNo": query.sinNo
                              , "bpBillDt": query.bpBillDt                              
                              , "bpinvoiceDate": query.bpinvoiceDate
                              , "bpBillId": query.bpBillId
                             });
            
            action.setCallback(this,function(response){
                var state = response.getState();
                if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){

                    if(response.getReturnValue().newPage != null && response.getReturnValue().billParameter != null){
                        console.log('isSuccessful: ' + response.getReturnValue().isSuccessful);
                        console.log('retMessage: ' + response.getReturnValue().retMessage);
                        console.log('newPage: ' + response.getReturnValue().newPage);
                        console.log('billParameter: ' + response.getReturnValue().billParameter);
                        
                        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                        + location.pathname.split('/')[1] + '/'
                        + location.pathname.split('/')[2] + '/' + response.getReturnValue().newPage + response.getReturnValue().billParameter;
                        window.location.assign(pageUrl);
                        
                    }
                } 
            });  
            $A.enqueueAction(action);  
        }
        else if(query.page != ''){
            console.log('1');
            
            //START - GGrandea and JRances : Redirection purposes
            var action = component.get("c.checkUserSession");
                
            action.setCallback(this, function(response){
                console.log(response.getState());
                console.log(response.getReturnValue());
                if(response.getState() == 'SUCCESS'){
                    if(response.getReturnValue() == 'WITH_SESSION'){
                        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                        + location.pathname.split('/')[1] + '/'
                        + location.pathname.split('/')[2] + '/' + query.page;
                        window.location.assign(pageUrl);
                    }
                }
                
            });
            $A.enqueueAction(action);
            //END -  GGrandea and JRances : Redirection purposes
            
            //var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
            //+ location.pathname.split('/')[1] + '/'
            //+ location.pathname.split('/')[2] + '/' + query.page;
            //window.location.assign(pageUrl);
        }
        else {
            console.log('2');
            var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
            + location.pathname.split('/')[1] + '/'
            + location.pathname.split('/')[2] + '/dashboard';
            window.location.assign(pageUrl);
        }

    },

    url_param: function(){
        return window.location.search.substring(1).split('&').map(function(e){
            return e.split('=');
        }).reduce(function(cur, nex){
            cur[nex[0]] = decodeURIComponent(nex[1]);
            return cur;
        }, {})
    }
    //END CSM-14200 JRances
    //END CSM-14664 JRances [R2B WARRANTY] - User is not redirected to the correct page.
})