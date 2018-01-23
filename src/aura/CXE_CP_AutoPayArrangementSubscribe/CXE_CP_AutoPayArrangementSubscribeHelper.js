({
	getAccountsForEnrollment : function(component,event, helper) {
		console.log('>>> doInit ENROLL');
        
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //get whole URL of the page
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var acctNo;
        
        for (var i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
            if(sParameterName[0]=='accts'){
                acctNo = sParameterName[1];
            }
        }
        console.log('>> accts: ' + acctNo);

        var action = component.get("c.getAccounts");
        action.setParams({"isEnroll": true});
        action.setCallback(this,function(response){          
            var state = response.getState();
            var res = response.getReturnValue();

            console.log('>> acctsForEnrollment: ' + JSON.stringify(res));
            
            if(state === "SUCCESS"){
            	var acctsForEnrollment = res.validAccts;
            	var blackLst = res.blacklistedAccts;

                if(acctsForEnrollment != null && acctsForEnrollment.length > 0){
            		component.set("v.acctOptions", acctsForEnrollment);
            		component.set("v.blackList", blackLst);

            		if(acctNo != null && acctNo!='' && acctsForEnrollment.indexOf(acctNo) >-1){
            			console.log('acctNo is not null: ' + acctNo);
            			if(acctsForEnrollment.length == 1){
                            component.set("v.selectedAcct", acctsForEnrollment[0]);
                        }
                        else{
                            component.set("v.selectedAcct", acctNo);
                        }
                        this.validateSelectedAccount(component, event, helper, component.get("v.selectedAcct"));
            		}
            		console.log('selected: ' + component.get("v.selectedAcct"));
            		console.log('acctoptions: ' + component.get("v.acctOptions"));
            		console.log('blacklist: ' + component.get("v.blackList"));
            	}

                //START CSM-13099 RReyes OCT-11-17
                var keyValSet = res.keyValueSetting;
                component.set("v.keyValueSettings", keyValSet);
                if(keyValSet != null && keyValSet.length > 0){
                    for(var x = 0; x < keyValSet.length; x++){
                        if(keyValSet[x].Name == 'APA_AUTO_DEBIT_FORM_URL'){
                            component.set("v.autoDebitFormURL", keyValSet[x].Value__c);
                        }else if(keyValSet[x].Name == 'APA_AUTO_CHARGE_FORM_URL'){
                            component.set("v.autoChargeFormURL", keyValSet[x].Value__c);
                        //START CSM-13114 RReyes OCT-13-17
                        }else if(keyValSet[x].Name == 'APA_UPLOAD_MAX_FILESIZE'){
                            component.set("v.maxFileSize", parseInt(keyValSet[x].Value__c));
                            console.log('maxFileSize: ' + component.get("v.maxFileSize"));
                        }else if(keyValSet[x].Name == 'APA_UPLOAD_VALID_FILETYPES'){
                            var fileTypes = keyValSet[x].Value__c;
                            var lstFileTypes = fileTypes.split(';');
                            component.set("v.validFileTypes", lstFileTypes);
                            console.log('validFileTypes: ' + component.get("v.validFileTypes"));
                        }
                        //END CSM-13114 RReyes OCT-13-17
                    }
                }
                //END CSM-13099 RReyes OCT-11-17
            }
            
		});  
        $A.enqueueAction(action);
        this.getAPAAgents(component);
	},

    getAPAAgents : function(component){
        //START CSM-13104 RReyes OCT-12-17
        console.log('getAPAAgents');
        var autoDebit = [{"code": '076006', "name": 'AUB'},
                        {"code": '003006', "name": 'BDO'},
                        {"code": '002006', "name": 'BPI'},
                        {"code": '010206', "name": 'Chinabank'},
                        {"code": '010506', "name": 'Citibank'},
                        {"code": '001106', "name": 'PBCOM'},
                        {"code": '026506', "name": 'PNB'},
                        {"code": '031306', "name": 'RCBC'},
                        {"code": '031106', "name": 'RCBC Savings'}, //START/END CSM-14630 NOV-27-17
                        {"code": '031806', "name": 'Robinsons Bank'},
                        {"code": '032406', "name": 'Security Bank'},
                        {"code": '035506', "name": 'UCPB'},
                        {"code": '035006', "name": 'UnionBank'}];

        var autoCharge = [{"code": '097006', "name": 'PNB Card'},
                        {"code": '109006', "name": 'BDO Card'},
                        {"code": '108006', "name": 'BPI Card'},
                        {"code": '107006', "name": 'Citibank Card'},
                        {"code": '074006', "name": 'Equicom Card'},
                        {"code": '000606', "name": 'East West Card'},
                        {"code": '019406', "name": 'Metrobank Card'},
                        {"code": '031206', "name": 'RCBC Bankard'},
                        {"code": '032606', "name": 'Security Bank MasterCard'},
                        {"code": '035406', "name": 'Unionbank Visa'}];
        //END CSM-13104 RReyes OCT-12-17
        component.set("v.autoDebitAgents", autoDebit);
        component.set("v.autoChargeAgents", autoCharge);
    },

    validateSelectedAccount : function(component, event, helper, selectedAcct) {
        //START CSM-13089 RReyes OCT-26-17
		var blacklistedAccts = component.get("v.blackList");
		console.log('>> blacklistedAccts: ' + blacklistedAccts);
		console.log('>> selectedAcct: ' + selectedAcct);
		
		if(selectedAcct != null && selectedAcct!='' && blacklistedAccts != null && blacklistedAccts.indexOf(selectedAcct) >-1){
			console.log('BLACKLIST!!!');
			component.set("v.acctErrorMsg", $A.get("$Label.c.APA_ENROLL_BLACKLIST_ERROR"));
			component.set("v.isAccountValid", false);
            //set values to default
			component.find("autodebit").set("v.value", false);
			component.find("autocharge").set("v.value", false);
            component.set("v.selectedScheme",'');
            component.set("v.selectedAgent", 'Select APA Agent');
            component.set("v.selectedAgentCode", 'Select APA Agent');
            //remove error message
            component.set("v.schemeErrorMsg", '');
            component.set("v.noAgentErrorMsg", '');//START/END CSM-13854 RReyes OCT-11-17
		}else{
			component.set("v.acctErrorMsg", '');
			component.set("v.isAccountValid", true);
            component.set("v.noAcctErrorMsg", '');//START/END CSM-13854 RReyes OCT-11-17
		}
        //END CSM-13089 RReyes OCT-26-17

        //validate account number
        var defaultAcct = 'Select Account Number';
        if(selectedAcct != null && selectedAcct != '' && selectedAcct != defaultAcct) {
            console.log('set no account error message');
            component.set("v.noAcctErrorMsg", '');//START/END CSM-13854 RReyes OCT-11-17
        }
	},
	
	goToMyAccounts : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/myaccounts';
        window.location.assign(pageUrl);
    },

    setAPAAgents : function (component, event, helper){
        var label = event.getSource().getLocalId();
        console.log('>>> id: ' + label);
        var agents = [];
        if(label == 'autodebit'){
            //var autoDebitAgents = $A.get("$Label.c.APA_AUTO_DEBIT");
            //agents = autoDebitAgents.split(';');
            agents = component.get("v.autoDebitAgents");
            component.set("v.selectedScheme",'Auto-Debit');
        }else if(label == 'autocharge'){
            //var autoChargeAgents = $A.get("$Label.c.APA_AUTO_DEBIT");
            //agents = autoChargeAgents.split(';');
            agents = component.get("v.autoChargeAgents");
            component.set("v.selectedScheme",'Auto-Charge');
        }
        component.set("v.selectedAgent", 'Select APA Agent');
        component.set("v.selectedAgentCode", 'Select APA Agent');
        component.set("v.agentOptions", agents);

        //remove error message
        component.set("v.schemeErrorMsg", '');
    },

    setSelectedAgent : function (component, event, helper){
        var agentCode = component.find("agentSelected").get("v.value");
        component.set("v.selectedAgentCode", agentCode);

        var apaScheme = component.get("v.selectedScheme");
        var apaAgents = [];
        
        if(apaScheme == 'Auto-Debit'){
            apaAgents = component.get("v.autoDebitAgents");
        }else if(apaScheme == 'Auto-Charge'){
            apaAgents = component.get("v.autoChargeAgents");
        }

        if(apaAgents != null){
            for(var a = 0; a< apaAgents.length; a++){
                if(apaAgents[a].code == agentCode){
                    component.set("v.selectedAgent", apaAgents[a].name);
                    break;
                }
            }
        }
        console.log('>> selectedAgentCode:  ' + component.get("v.selectedAgentCode"));
        console.log('>> selectedAgentName: ' + component.get("v.selectedAgent"));

        //validate selected agent
        var defaultAgent = 'Select APA Agent';
        //START CSM-13854 RReyes OCT-11-17
        var agentName = component.get("v.selectedAgent");
        if(agentName != null && agentName != '' && agentName != defaultAgent) {
            component.set("v.noAgentErrorMsg", '');
        }
        //END CSM-13854 RReyes OCT-11-17
    },

    validateRequiredFields : function (component, event, helper){
        console.log('validateFields');
        var acctSelected = component.get("v.selectedAcct");
        var schemeSelected = component.get("v.selectedScheme");
        var agentSelected = component.get("v.selectedAgent");
        var isValid = component.get("v.isAccountValid");
        var defaultAcct = 'Select Account Number';
        var defaultAgent = 'Select APA Agent';
        var hasError = false;

        if(!isValid){
            component.find("accountSelected").focus();
        }
        //START CSM-13854 RReyes OCT-11-17
        if(isValid && (acctSelected == defaultAcct || acctSelected == null || acctSelected == '')) {
            component.set("v.noAcctErrorMsg", $A.get("$Label.c.APA_ENROLL_NO_ACCT"));
            component.find("accountSelected").focus();
            hasError = true;
        } else {
            component.set("v.noAcctErrorMsg", '');
        }

        if(isValid && (agentSelected == defaultAgent || agentSelected == null || agentSelected == '')) {
            component.set("v.noAgentErrorMsg", $A.get("$Label.c.APA_ENROLL_NO_AGENT"));
            component.find("agentSelected").focus();
            hasError = true;
        } else {
            component.set("v.noAgentErrorMsg", '');
        }

        if(isValid && (schemeSelected == null || schemeSelected == '')) {
            component.set("v.schemeErrorMsg", $A.get("$Label.c.APA_ENROLL_NO_SCHEME"));
            component.find("autodebit").focus();
            component.find("autocharge").focus();
            hasError = true;
        }else {
            component.set("v.schemeErrorMsg", '');
        }
        //END CSM-13854 RReyes OCT-11-17

        if(!hasError && isValid){
            this.validateAttachments(component, event, helper);
        }   
    },

    validateAttachments : function (component, event, helper){
        //START CSM-13114 RReyes OCT-13-17 - file uploader
        var files = component.get("v.filesToUpload");
        if(files != null && files.length > 0){
            this.showAPAEnrollPrompt(component, event, helper);
        }else{
            component.set("v.popUpModal", 'attachForm');
        }
        //END CSM-13114 RReyes OCT-13-17 - file uploader
    },

    showAPAEnrollPrompt : function (component, event, helper){
        component.set("v.popUpModal", 'proceed');
    },

    createCase : function (component, event, helper){
        //START CSM-13109 RReyes OCT-27-17 - added fileCount
        var fileCount = 0;
        var files = component.get("v.filesToUpload");
        if(files != null){
            fileCount = files.length;
        }
        console.log('>>fileCount: ' + fileCount);
        var action = component.get("c.createAPACase");
        action.setParams({"contractAcctNum": component.get("v.selectedAcct"),
                          "isAPAEnroll" : true,
                          "reasonForCancel": '',
                          "apaScheme": component.get("v.selectedScheme"),
                          "apaAgent": component.get("v.selectedAgentCode"),//START/END CSM-13104 RReyes OCT-12-17
                          "fileCount": fileCount}); 
        //END CSM-13109 RReyes OCT-27-17 - added fileCount
        action.setCallback(this,function(response){          
            var state = response.getState();
            var caseNumber = response.getReturnValue();
            console.log('>>>caseNumber: ' + caseNumber);
            if(state === "SUCCESS"){
                if(caseNumber != null && caseNumber != ''){
                    console.log('SUCCESS!: ' + caseNumber);
                    //START CSM-13109 RReyes OCT-26-17
                    console.log('>>START file iteration');
                    this.iterateFilesToUpload(component, caseNumber, function() {
                        component.set("v.caseNum", caseNumber);
                    });
                    console.log('>>END file iteration');
                    console.log('>>SET v.caseNum');
                    component.set("v.caseNum", caseNumber);
                    //END CSM-13109 RReyes OCT-26-17
                }else{
                    console.log('caseNumber failed!');
                }
            }
        });  
        $A.enqueueAction(action);
    }

    //START CSM-13099 - RReyes OCT-11-17 download form
    ,downloadAutoDebitForm: function(component, event, helper){
        var hiddenElement = document.createElement('a');
        hiddenElement.href = component.get("v.autoDebitFormURL");
        hiddenElement.target = '_blank'; //
        hiddenElement.download = 'APA Auto Debit Form.pdf';  // File Name
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click();
    },

    downloadAutoChargeForm: function(component, event, helper){
        var hiddenElement = document.createElement('a');
        hiddenElement.href = component.get("v.autoChargeFormURL");
        hiddenElement.target = '_blank'; //
        hiddenElement.download = 'APA Auto Charge Form.pdf';  // File Name
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click();
    }
    //END CSM-13099 - RReyes OCT-11-17 download form
    //START CSM-13114 RReyes OCT-13-17 - file uploader
    ,addFileToList : function(component, event, helper) {
        
        var fileInput = component.find("file").getElement();
        var lstFiles = component.get("v.filesToUpload");
        var maxSize = component.get("v.maxFileSize");
        var lstFileTypes = component.get("v.validFileTypes");

        console.log('>>fileInput.files: ' + JSON.stringify(fileInput.files));
        console.log('>>fileInput.files.length: ' + fileInput.files.length);
        
        if(fileInput.files.length > 0){
            var file = fileInput.files[0];
            var fileName = file.name;
            var fileSize = (file.size / (1024*1024)).toFixed(2);
            var fileType = file.type;
            var hasError = false;

            console.log('>>fileSize: ' + file.size + ' maxSize: ' + maxSize);
            if(file.size > maxSize){
                console.log('fileSize ERROR');
                component.set("v.fileSizeErrorMsg", $A.get("$Label.c.APA_UPLOAD_INVALID_SIZE"));
                hasError = true;
            }else{
                component.set("v.fileSizeErrorMsg", '');
            }

            if(lstFileTypes != null && lstFileTypes.length > 0 && lstFileTypes.indexOf(file.type) < 0){
                console.log('fileType ERROR');
                component.set("v.fileTypeErrorMsg", $A.get("$Label.c.APA_UPLOAD_INVALID_TYPE"));
                hasError = true;
            }else{
                component.set("v.fileTypeErrorMsg", '');
            }
            console.log('>>file: ' + JSON.stringify(file));
            console.log('>>fileType: ' + file.type);
            console.log('>>fileName: ' + fileName);
            console.log('>>fileSize before: ' + file.size);
            console.log('>>fileSize: ' + fileSize);

            if(!hasError){
                for(var x = 0 ; x < fileInput.files.length; x++ ){
                    lstFiles.push(fileInput.files[x]);
                }
                component.set("v.filesToUpload", lstFiles);
                component.find("file").getElement().value = "";
            }

        }
        console.log('>>lstFiles.length: ' + lstFiles.length);
        
    },

    removeFileFromList : function(component, event, helper) {
        console.log(event.target.id);
        var fileInput = component.find("file").getElement();
        var file; 
        var fileName;
        var fileIndex = event.target.id;
        var fileSize = "";
        console.log('>>fileInput.files.length: ' + fileInput.files.length);
        console.log('>>fileIndex: ' + fileIndex);
        var lstFiles = component.get("v.filesToUpload");
        if(lstFiles != null && lstFiles.length > 0 && fileIndex < lstFiles.length){
            lstFiles.splice(fileIndex, 1);
        }
        component.set("v.filesToUpload", lstFiles);
        component.set("v.fileSizeErrorMsg", '');
        component.set("v.fileTypeErrorMsg", '');
        component.find("file").getElement().value = "";
        if(fileInput.files.length > 0){
            file = fileInput.files[0];
            fileName = file.name;
            fileSize = (file.size / (1024*1024)).toFixed(2);
            console.log('>>file: ' + JSON.stringify(file));
            console.log('>>fileName: ' + fileName);
            console.log('>>fileSize before: ' + file.size);
            console.log('>>fileSize: ' + fileSize);
        }
        console.log('>>lstFiles.length: ' + lstFiles.length);
    }
    //END CSM-13114 RReyes OCT-13-17 - file uploader

    //START CSM-13109 RReyes OCT-26-17
    ,iterateFilesToUpload : function(component, caseNumber, callback) {
        console.log('iterateFilesToUpload');
        console.log('caseNum: ' + caseNumber);
        //START CSM-13109 RReyes - NOV-08-17
        var agentName = component.get("v.selectedAgent");//component.get("v.selectedAgent");
        //END CSM-13109 RReyes - NOV-08-17
        console.log('agentName: ' + agentName);
        var files = component.get("v.filesToUpload");
        console.log('files: ' + files.length);
        if(files != null && files.length > 0){
            for(var x = 0; x < files.length; x++){
                console.log('>> file: ' + x);
                console.log('>> file.name: ' + files[x].name);
                console.log('>> file.type: ' + files[x].type);
                this.uploadSign(component, files[x], caseNumber, agentName);
                if(x + 1 == files.length){
                    callback();
                }
            }
        }
    },

    uploadSign : function(component, file, caseNumber, agentName) {
        var fileName = file.name;
        var fileExt = fileName.split('.').pop();
        console.log('>> file extension: ' + fileExt);

        var formattedDate = this.getDate();
        var formattedTimeStamp = '' + formattedDate + this.getTimeStamp();
        //START CSM-13109 RReyes - NOV-08-17
        //var documentName = formattedDate + '/' + agentName + '_' + caseNumber + '_' + formattedTimeStamp + '.' + fileExt;
        var documentName = formattedDate + '|' + agentName + '|' + caseNumber + '_' + formattedTimeStamp + '.' + fileExt;
        //END CSM-13109 RReyes - NOV-08-17
        var docList = component.get("v.documentsList");
        var doc = { "folderName": formattedDate, "fileName": documentName, "agentName": component.get("v.selectedAgent")}; 
        docList.push(doc);
        component.set("v.documentsList", docList);

        console.log('documentName: ' + documentName);
        var action = component.get("c.upload_sign");
        action.setParams({"documentName": documentName});
        action.setCallback(this,function(response){          
            var state = response.getState();
            var res = response.getReturnValue();
            if(state == 'SUCCESS'){
                console.log('>>res: ' + res);
                this.upload(res, file);
            }        
        });  
        $A.enqueueAction(action);
    },

    upload: function(url, file){
        var prom = new Promise(function(resolve, reject){
            console.log('promise? ');
            var xhr = new XMLHttpRequest();
            var reader = new FileReader();
            
            xhr.onreadystatechange = function(e){
                console.log('>> xhr.readyState: ' + xhr.readyState);
                console.log('>> xhr.status: ' + xhr.status);
                if(xhr.readyState == 4){
                    if(xhr.status == 200)
                        resolve(xhr);
                    else
                        reject(xhr);
                }
            }
            
            reader.onloadend = function (e) {
                xhr.open("PUT", url);
                xhr.setRequestHeader("Content-Type", "application/octet-stream");
                xhr.send(e.target.result);
            };
            reader.readAsArrayBuffer(file);
        });
    },

    getDate: function(){
        var today = new Date();
        var year = today.getFullYear();
        var month = today.getMonth() + 1;
        var day = today.getDate();

        if(month < 10){
            month = '0' + month;
        }

        if(day < 10){
            day = '0' + day;
        }
        
        var formattedDate = '' + month + day + year;
        return formattedDate;
    },

    getTimeStamp: function(){
        var today = new Date();
        var hr = today.getHours();
        var min = today.getMinutes();
        var sec = today.getSeconds();
        var ms = today.getMilliseconds();

        if(hr < 10){
            hr = '0' + hr;
        }

        if(min < 10){
            min = '0' + min;
        }

        if(sec < 10){
            sec = '0' + sec;
        }

        if(ms < 10){
            ms = '00' + ms;
        }else if(ms > 9 && ms < 100){
            ms = '0' + ms;
        }
        
        var formattedTimeStamp = '' + hr + min + sec + ms;
        return formattedTimeStamp;
    },
    //END CSM-13109 RReyes OCT-26-17
    
    //START R2C CSM-14749 Shayne 12/01/2017
    initializeCheckConglomerate : function(component, event) {
        console.log('initializeCheckConglomerate');
       var action = component.get("c.retrieveCheckConglomerate");
        action.setCallback(this,function(response){             
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('initializeCheckConglomerate state' + state +' and result '+result);
            if(state === "SUCCESS"){
                 var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                + location.pathname.split('/')[1] + '/' 
                + location.pathname.split('/')[2] + '/congloaccerror';
               if(result === true) window.location.assign(pageUrl);
               else component.set('v.isLoaded',true); //R2C CSM-14773 Shayne 12/05/2017
            }
        });  
        $A.enqueueAction(action);
    }
    //END R2C CSM-14749 Shayne 12/01/2017
})