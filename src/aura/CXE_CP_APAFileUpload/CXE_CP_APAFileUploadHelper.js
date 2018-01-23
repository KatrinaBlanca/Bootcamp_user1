({
    initialize : function(component, event, helper) {
        component.set("v.fileUploadMessage", "");
        component.set("v.isFileUploaded", false);
        component.set("v.fileSizeErrorMsg", '');
        component.set("v.fileTypeErrorMsg", '');
        component.set("v.hasFileError",false);
        component.set("v.fileToUpload",false);
        component.set("v.selectedFileName", "No file selected.");
        component.set("v.uploadInProgress", false);
    },

    getCase : function(component, event, helper) {
        var action = component.get("c.getCaseDetails");
        action.setParams({
            caseId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var currentCase = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.caseRec", currentCase);
                console.log('>> caseRec: ' + JSON.stringify(currentCase));
                if(currentCase != null){
                    if(currentCase.Application_Type_Subtype__c == 'APA Cancellation'){
                        component.set("v.isAPACancel", true);
                    }else{
                        component.set("v.isAPACancel", false);

                        var errorMsg = '';
                        if(currentCase.Status != 'Open'){
                            errorMsg = $A.get("$Label.c.APA_UPLOAD_INVALID_STATUS");
                        }else if(currentCase.CXE_APA_Attachment_Count__c == 3){
                            errorMsg = $A.get("$Label.c.APA_UPLOAD_MAX_FILE_UPLOADED");
                        }

                        if(errorMsg != ''){
                            component.set("v.uploadErrorReason", errorMsg);
                            component.set("v.isUploadDisabled", true);
                        }else{
                            component.set("v.isUploadDisabled", false);
                        }
                    }
                }
            }
        });
        $A.enqueueAction(action); 
    },

    getSettings : function(component, event, helper) {
        var action = component.get("c.getKeyValSettings");        
        action.setCallback(this, function(response){
            var state = response.getState();
            var keyValSet = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.keyValueSettings", keyValSet);
                if(keyValSet != null && keyValSet.length > 0){
                    for(var x = 0; x < keyValSet.length; x++){
                        if(keyValSet[x].Name == 'APA_UPLOAD_MAX_FILESIZE'){
                            component.set("v.maxFileSize", parseInt(keyValSet[x].Value__c));
                            console.log('maxFileSize: ' + component.get("v.maxFileSize"));
                        }else if(keyValSet[x].Name == 'APA_UPLOAD_VALID_FILETYPES'){
                            var fileTypes = keyValSet[x].Value__c;
                            var lstFileTypes = fileTypes.split(';');
                            component.set("v.validFileTypes", lstFileTypes);
                            console.log('validFileTypes: ' + component.get("v.validFileTypes"));
                        }
                    }
                }
            }
        });
        $A.enqueueAction(action); 
    },

    validateFile : function(component, event, helper) {
        
        var fileInput = component.find("file").getElement();

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

            var fname = fileName;
            var flimit = 29;
            if(fname.length > flimit){
                fname = fname.substring(0, flimit) + '...';
            }
            
            component.set("v.selectedFileName", fname);
            component.set("v.noFileErrorMsg", "");

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

            if(hasError){
                component.set("v.hasFileError", true);
            }else{
                component.set("v.hasFileError", false);
                component.set("v.fileToUpload", file);
            }
            console.log('>>file: ' + JSON.stringify(file));
            console.log('>>fileType: ' + file.type);
            console.log('>>fileName: ' + fileName);
            console.log('>>fileSize before: ' + file.size);
            console.log('>>fileSize: ' + fileSize);
        }else{
            console.log("nullify file to upload");
            component.set("v.fileToUpload", null);
            component.set("v.selectedFileName", "No file selected.");
        }
    },

    validateUpload : function(component, event, helper) {
        component.set("v.uploadInProgress", true);
        var fileInput = component.find("file").getElement();
        var noOfFile = fileInput.files.length;
        console.log('>> noOfFile: ' + noOfFile);
        var hasError = component.get("v.hasFileError");
        var file = component.get("v.fileToUpload");
        console.log('>>file: ' + file);
        if(noOfFile != 0){
            if(!hasError){
                //upload
                //alert("upload started...")
                component.set("v.fileUploadMessage", "Uploading file...");
                component.set("v.noFileErrorMsg", "");
                this.uploadSign(component, event, helper, file);
            }else{
                component.set("v.uploadInProgress", false);
            }
        }else{
            component.set("v.uploadInProgress", false);
            component.set("v.noFileErrorMsg", "Please select a file to upload.");
            component.set("v.selectedFileName", "No file selected.");
            component.set("v.fileSizeErrorMsg", '');
            component.set("v.fileTypeErrorMsg", '');
            component.set("v.hasFileError",false);
        }
    },

    uploadSign : function(component, event, helper, file) {
        var fileName = file.name;
        var fileExt = fileName.split('.').pop();
        console.log('>> file extension: ' + fileExt);

        var caseRec = component.get("v.caseRec");

        var formattedDate = '' + this.getDate();
        var formattedTimeStamp = '' + formattedDate + this.getTimeStamp();
        //START CSM-13154 RReyes - NOV-08-17
        //var documentName = formattedDate + '/' + caseRec.CXE_APA_Agent__c + '_' + caseRec.CaseNumber + '_' + formattedTimeStamp + '.' + fileExt;
        var documentName = formattedDate + '|' + caseRec.CXE_APA_Agent__c + '|' + caseRec.CaseNumber + '_' + formattedTimeStamp + '.' + fileExt;
        //END CSM-13154 RReyes - NOV-08-17
        console.log('manual doc name');
        //var documentName = '11042017/076006_A1711-00350234_11042017104147569.png';
        //var documentName = 'datetoday/testdocu.png';
        console.log('documentName: ' + documentName);
        var action = component.get("c.upload_sign");
        action.setParams({"documentName": documentName});
        action.setCallback(this,function(response){          
            var state = response.getState();
            var res = response.getReturnValue();
            if(state == 'SUCCESS'){
                console.log('>>res: ' + res);
                this.upload(component, event, helper, res, file);
            }        
        });  
        $A.enqueueAction(action);
    },

    upload: function(component, event, helper, url, file){
        var prom = new Promise(function(resolve, reject){
            console.log('promise? ');
            var xhr = new XMLHttpRequest();
            var reader = new FileReader();
            
            xhr.onreadystatechange = function(e){
                console.log('>> xhr.readyState: ' + xhr.readyState);
                console.log('>> xhr.status: ' + xhr.status);
                if(xhr.readyState == 4){
                    if(xhr.status == 200){
                        console.log('update apa case.');
                        helper.updateAPAFileCount(component, event, helper);
                        component.set("v.isFileUploaded", true);
                        component.set("v.fileUploadMessage", "File has been successfully uploaded.");
                        //alert("file has been uploaded!");
                        resolve(xhr);
                    }
                    else{
                        component.set("v.isFileUploaded", false);
                        component.set("v.fileUploadMessage", "Error uploading file.");
                        alert("error uploading file...");
                        reject(xhr);
                    }
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

    updateAPAFileCount : function(component, event, helper) {
        console.log('updateAPAFileCount');
        component.set("v.fileUploadMessage", "Updating APA File count...");
        var caseRec = component.get("v.caseRec");
        var fileCount = caseRec.CXE_APA_Attachment_Count__c;

        if(fileCount != null){
            fileCount = parseInt(fileCount) + 1;
        }else{
            fileCount = 1;
        }
        console.log('>> fileCount after upload: ' + fileCount);
        var action = component.get("c.updateFileCount");
        action.setParams({
            caseId : component.get("v.recordId"),
            fileCount: fileCount
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var response = response.getReturnValue();
            if (state === "SUCCESS") {
                if(response == "SUCCESS"){
                    console.log('Case Update Successful.');
                }
            }
        });
        $A.enqueueAction(action); 
    }

})