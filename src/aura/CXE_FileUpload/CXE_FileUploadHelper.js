({
    // MAX_FILE_SIZE: 4500000, /* 6 000 000 * 3/4 to account for base64 */
    MAX_FILE_SIZE: 5242880,
    CHUNK_SIZE: 400000, /* Use a multiple of 4 */
    files: [],
    upload: function(cmp, tasks){

        var self = this;
        
        if(tasks.length == 0){
            self.increment(cmp, true);
            return;
        }

        var task = tasks.pop();

        function _init(data){

            return new Promise(function(resolve, reject){
                self.increment(cmp);

                var action = cmp.get("c.init_attachment"); 

                action.setParams({
                    parent_id: data.parent_id
                    , name: data.file.name
                    , type: data.file.type
                });

                action.setCallback(self, function(result) {
                    if(result.getState() == 'SUCCESS')
                        resolve(result.getReturnValue());
                    else
                        reject(result.getError())
                });

                $A.enqueueAction(action); 
            });
        }

        _init(task)
        .then(function(oid){
            task.oid = oid;
            $A.getCallback(function() {
                task.chunk = task.chunk.reverse();
                self.batch(cmp, task, tasks);
            })();
        });
    },
    
    batch: function(cmp, data, tasks){
        var self = this;
        if(data.chunk.length > 0){
            console.log("appending", data.oid, data.chunk.length);
            self.increment(cmp);
            var action = cmp.get("c.append_attachment"); 

            action.setParams({
                oid: data.oid
                , base64: encodeURIComponent(data.chunk.pop())
            });

            action.setCallback(self, function(result) {
                console.info(result.getState(), result.getReturnValue(), result.getError());
                if(result.getState() == 'SUCCESS'){
                    self.batch(cmp, data, tasks);
                }
                else
                    console.error(result.getError());
            });

            $A.enqueueAction(action); 
        }
        else{
            self.upload(cmp, tasks);
        }
    },
    increment: function(c, complete){
        if(!complete){
            c.set("v.process", c.get("v.process") + 1);
            c.set("v.progress", ((c.get("v.process") * 100) / c.get("v.total")).toFixed(0));    
        }
        
        console.log(c.get("v.process"), c.get("v.total"), c.get("v.progress"))

        this.fire(c.getEvent("onprogress"), {progress : c.get("v.progress"), complete: !!complete});
    },
    read: function(file){
        return new Promise(function(resolve, reject){
            var reader = new FileReader();
            reader.onload = function(){
                resolve(reader.result.split(',')[1].trim());
            }
            reader.onerror = reject;
            reader.readAsDataURL(file);    
        });
    },
    chunk: function(base64){
        var i,j,result = [];
        for (i=0,j=base64.length; i<j; i+=this.CHUNK_SIZE) {
            result.push(base64.slice(i,i+this.CHUNK_SIZE));
        }

        return result;
    },

    // files: function(c){
    //     return (new Array(5))
    //         .map(function(x, i){ 
    //             return c.find("file_upload_" + (i + 1)).getElement().files[0]
    //         })
    //         .filter(function(f){ return !!f;});
    // },  
    save : function(component) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        if(file){
                
            var fr = new FileReader();
            var self = this;
            fr.onload = $A.getCallback(function() {
                var fileContents = fr.result;
                var base64Mark = 'base64,';
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;

                fileContents = fileContents.substring(dataStart);
           
                self.upload(component, file, fileContents);
            });

            fr.readAsDataURL(file);
            // }
        }
    },
        
    _old_upload: function(component, file, fileContents) {
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
        // start with the initial chunk
        this.uploadChunk(component, file, fileContents, fromPos, toPos, '');   
    },
     
    uploadChunk : function(component, file, fileContents, fromPos, toPos, attachId) {
        var action = component.get("c.saveTheChunk"); 
        var chunk = fileContents.substring(fromPos, toPos);
        console.log("attachId:" + attachId);
        action.setParams({
            parentId: component.get("v.parentId"),
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
        // console.log("isValidFileSize" );
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        // console.log("file:" + file );
        if(file) {   
            // console.log("file.size > this.MAX_FILE_SIZE" + file.size > this.MAX_FILE_SIZE);         
            if (file.size > this.MAX_FILE_SIZE) {     
                var errorMsg = "File size cannot exceed " + this.MAX_FILE_SIZE + " bytes.\n Selected file size: " + file.size;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Please validate your application.",
                                      "message": errorMsg,
                                      "type": "error",
                                      "duration": 6000
                                     });
                toastEvent.fire();                
            } else {
                // console.log("dsadsadsfile.size:" + file.size);   
                var checkFileEvt = $A.get("e.c:CXE_CheckFileEvent");
                checkFileEvt.setParams({ "isValid": true }).fire();
            }
        } else {
            var checkFileEvt = $A.get("e.c:CXE_CheckFileEvent");
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
    , toast_invalid_file: function(){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Please validate your application.",
            "message": "Your file exceeds the maximum limit of 5MB. Please choose another file.",
            "type": "error",
            "duration": 6000
        });
        toastEvent.fire(); 
    }
    , fire: function(e, args){
        e.setParams(args);
        e.fire();
    }
})