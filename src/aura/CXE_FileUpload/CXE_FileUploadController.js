({  add: function(c, e, h){
        var self = this;
        var file = c.find("file_upload").getElement().files[0];
        var is_valid = file.size < h.MAX_FILE_SIZE;

        if(!file) return;

        if(is_valid){
            h.read(file).then(function(base64){
                $A.getCallback(function() {
                    h.files.push({file: file, chunk: h.chunk(base64), size: base64.length});
                    c.set("v.files", h.files);
                    c.find("file_upload").getElement().value = "";
                })();
            });
        }
        else{
            h.toast_invalid_file();
        }

        h.fire(
            c.getEvent("onchange")
            , {invalid : !is_valid}
        );
    }
    , remove: function(c, e, h){
        h.files.splice(parseInt(e.srcElement.getAttribute('data-index')), 1);
        c.set("v.files", h.files);
    }
    , submit: function(c, e, h) {

        var files = {};
        var parent_id = e.getParam('arguments').parent_id;

        h.files.forEach(function(f){ f.parent_id = parent_id; });
        c.set("v.total", h.files.length + h.files.map(function(f){return f.chunk}).reduce(function(cur, nex){ return cur + nex.length}, 0));
        c.set("v.process", 0);
        c.set("v.progress", 0);

        h.upload(c, h.files.slice());
    },

    isValidFileSize : function(component, event, helper) {
        
        helper.isValidFileSize(Array.from(component.find("file").getElement().files));
    },

    // remove : function(component, event, helper) {
    //     helper.removeFile(component);
    // }
    //,
    
    // waiting: function(component, event, helper) {
    //  $A.util.addClass(component.find("uploading").getElement(), "uploading");
    //  $A.util.removeClass(component.find("uploading").getElement(), "notUploading");
    // },
    
    // doneWaiting: function(component, event, helper) {
    //  $A.util.removeClass(component.find("uploading").getElement(), "uploading");
    //  $A.util.addClass(component.find("uploading").getElement(), "notUploading");
    // }
})