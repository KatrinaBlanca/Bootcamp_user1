({
    MAX_FILE_SIZE: 4 500 000, /* 6 000 000 * 3/4 to account for base64 */
    CHUNK_SIZE: 170 000, /* Use a multiple of 4 */

    save : function(component) {
        var params = event.getParam('arguments');
        if(params) {            
            var parentId = params.parentId;
            //alert(parentId); //CSM-13020 Melvin Corbes 10-02-17
            var fileInput = component.find("file").getElement();
            var file = fileInput.files[0];
            var self = this;
            if(file){                    
                var fr = new FileReader();            
                fr.onload = function() {
                    var fileContents = fr.result;
                    var base64Mark = 'base64,';
                    var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                    fileContents = fileContents.substring(dataStart);
                    self.upload(component, file, fileContents, parentId);
                };
                fr.readAsDataURL(file);
            }
        }
    },
        
    upload: function(component, file, fileContents, parentId) {
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
        this.uploadChunk(component, file, fileContents, fromPos, toPos, '', parentId);   
    },
     
    uploadChunk : function(component, file, fileContents, fromPos, toPos, attachId, parentId) {
        
        var action = component.get("c.saveTheChunk"); 
        var chunk = fileContents.substring(fromPos, toPos);

        action.setParams({
            parentId: parentId,
            fileName: file.name,
            base64Data: encodeURIComponent(chunk), 
            contentType: file.type,
            fileId: attachId
        });
       
        var self = this;
        action.setCallback(this, function(a) {
            attachId = a.getReturnValue();      
            fromPos = toPos;
            toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);
            
            if (fromPos < toPos) {
                self.uploadChunk(component, file, fileContents, fromPos, toPos, attachId);  
            }          
        });
        $A.enqueueAction(action); 
    },

    isValidFileSize : function(component) {
        var checkFileEvt = $A.get("e.c:CXE_CheckFileEvent");
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        if(file) {   
            if (file.size > this.MAX_FILE_SIZE) {     
                checkFileEvt.setParams({ "isValid": false }).fire();
                var errorMsg = "File size cannot exceed " + this.MAX_FILE_SIZE/1000000 + "MB.\n Selected file size: " + file.size/1000000 + "MB";
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Please validate your application.",
                                      "message": errorMsg,
                                      "type": "error",
                                      "duration": 6000
                                     });
                toastEvent.fire();                
            } else {
                checkFileEvt.setParams({ "isValid": true }).fire();
            }
        } else {
            checkFileEvt.setParams({ "isValid": true }).fire();
        }
    },

    removeFile : function(component) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        if(file) {   
            component.find("file").getElement().value = "";
        }
    }

    
})