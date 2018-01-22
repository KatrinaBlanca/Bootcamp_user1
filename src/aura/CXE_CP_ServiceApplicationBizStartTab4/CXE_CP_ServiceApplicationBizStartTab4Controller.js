({
    init: function(cmp, evt, h){
        window.addEventListener("message", function(event){
            cmp.done(event.data);
        });
    }
	, submitTab : function(component, event, helper) {

        console.log(' >>>>>>>>>>>>>>>>>>>>>>>>>>> submitTab4: ');

		//PLACE VALIDATION HERE


		//var servReq = component.get("v.caseRecord.CXE_Service_Request_s__c");
		var servReq = true;
        if(servReq){ //if no errors
            var setEvent = component.getEvent("callTabEvent");
            setEvent.setParams({"param1":2});
            setEvent.fire();
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({"title": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Please check your input.",
                                  "message": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Please select a service modification.",
                                  "type": "error",
                                  "duration" : 6000
                                 });
            toastEvent.fire();
        }
	},
    
    onSubmit : function(component, event, helper) {
        helper.submitStartService(component, event, helper);


        // component.upload('0010l000002tMSCAA2');
    },

    onCheck: function(component, event, helper) {
        var cmpBtn = component.find("submitBtn");
        cmpBtn.set("v.disabled",!event.getSource().get("v.value"));
    }, 
    upload: function(cmp, event, h){
        var parent_id = event.getParam('arguments').id;
        var files = Array.from(document.getElementById("file-upload").files);
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
            document.getElementById('vf-upload').contentWindow.postMessage(content, 'https://devwcxe-meralco.cs58.force.com')
        })
    }, 
    done: function(cmp, evt, h){
        console.log("COMPLETE", evt.getParam('arguments').id);
        h.toggleSpinner(cmp, evt, h);
    }
})