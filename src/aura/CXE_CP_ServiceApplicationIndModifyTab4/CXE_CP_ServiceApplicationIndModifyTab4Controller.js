({    
    onSubmit : function(component, event, helper) {
        helper.submitModify(component, event, helper);
    },

    onCheck: function(component, event, helper) {
        var cmpBtn = component.find("modifySubmitBtn");
        cmpBtn.set("v.disabled",!event.getSource().get("v.value"));
    },

    upload: function(cmp, event, h){
        var parent_id = event.getParam('arguments').id;
        var files = Array.from(document.getElementById("file-upload-modify").files);
        var read = [];

        Promise.all(files.map(function(file){
            return new Promise(function(resolve, reject){
                var reader = new FileReader();
                reader.onerror = console.error;

                reader.readAsDataURL(file);
                reader.onload = function (e) {
                    var part = reader.result.split(",");
                    resolve({ParentId: parent_id, Body: part[part.length - 1], Name: file.name, ContentType: file.type })
                };
                reader.onerror = reject;
            })
        })).then(function(content){
            document.getElementById('vf-upload-modify').contentWindow.postMessage(content, 'https://meralco--devwcxe--c.cs58.visual.force.com')
        })
    }, 
    done: function(cmp, evt, h){
        console.log("COMPLETE", evt.getParam('arguments').id);
        h.toggleSpinner(cmp, evt, h);
    },
    init: function(cmp, evt, h){
        window.addEventListener("message", function(event){
            cmp.done(event.data);
        });
    }
})