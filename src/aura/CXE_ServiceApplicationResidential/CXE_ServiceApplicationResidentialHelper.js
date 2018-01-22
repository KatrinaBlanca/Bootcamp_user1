({
    makeFileListHelper : function(component, event, helper) {
        //function makeFileList() {
        //alert();
        var input = document.getElementById("filesToUpload");
        var ul = document.getElementById("fileList");
        while (ul.hasChildNodes()) {
            ul.removeChild(ul.firstChild);
        }
        
        for (var i = 0; i < input.files.length; i++) {
            var li = document.createElement("li");
            li.className = "slds-truncate";
            li.innerHTML = '<img src="/resource/LDSAssets/assets/icons/standard/file_120.png" alt="attachment" class="CXE_serviceApplication--AttachmentIcon slds-m-horizontal--xx-small slds-m-vertical--xxx-small" />' + input.files[i].name;
            ul.appendChild(li);
        }
        if(!ul.hasChildNodes()) {
            var li = document.createElement("li");
            li.innerHTML = 'No Files Selected';
            ul.appendChild(li);
        }
        //}
    },
    
    openModalHelper : function(component, elementId) {
        var modal = component.find(elementId); 
        $A.util.addClass(modal, 'slds-backdrop--open');
        $A.util.removeClass(modal, 'slds-fade-in-hide');
    },
    
    setFocus : function(component, helper, elementId) {
        setTimeout(function() {
            component.find(elementId).focus();
        }, 100);
    }, 
    
    closeModalHelper : function(component, elementId) {
        var modal = component.find(elementId); 
        $A.util.addClass(modal, 'slds-fade-in-hide'); 
        $A.util.removeClass(modal, 'slds-backdrop--open'); 
    },
    
    getAddressReference : function(component, event, helper, searchFilterValue){
        var action = component.get("c.getAddressReference");		
        
        action.setParams({"searchInput": component.find("referenceSearch").get("v.value"),
                          "fieldGroup" : component.get('v.filterGroup')});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){  
                component.set("v.searchResults", response.getReturnValue());
            } else {
                console.log('>>>>>>>>>>>>>>>>>> something went wrong.');
            }                
        });
        $A.enqueueAction(action);
    }, 
    
    getHomeOwnershipPicklistValues : function (component, event, helper) {
        var action = component.get("c.getHomeOwnership");
        var inputsel = component.find("homeOwnership");
        var opts=[];
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){                
                for(var i=0;i< a.getReturnValue().length;i++){
                    opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
                }
                inputsel.set("v.options", opts);
            }   
        });
        $A.enqueueAction(action); 
    },
    
    displaySearchModal : function(component, event, helper) {

     	//Display search modal
    	helper.openModalHelper(component, 'searchDiv');

        var searchReference = component.find("referenceSearch");

        //Update ui:inputText placeholder based on trigger event
        searchReference.set("v.placeholder", "Search "+ event.getSource().getLocalId());

        //Focus on search field
        helper.setFocus(component, helper, 'referenceSearch');
	},
    
    getSalutations : function (component, event, helper) {
        var action = component.get("c.getSalutations");
        var inputsel = component.find("salutations");
        var opts=[];
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){                
                for(var i=0;i< a.getReturnValue().length;i++){
                    opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
                }
                inputsel.set("v.options", opts);
            }  
        });
        $A.enqueueAction(action); 
    },
    
    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');          
	},
    
    MAX_FILE_SIZE: 750 000, /* 1 000 000 * 3/4 to account for base64 */

    attachFile : function(component, parentid) {
    	console.log('>>>>>>>>>>>>>>>> attachFile >>>>>>' + parentid);
        var fileInput = component.find("attachment").getElement();
    	var file = fileInput.files[0];
   
        if (file.size > this.MAX_FILE_SIZE) {
            alert('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
    		  'Selected file size: ' + file.size);
    	    return;
        }
    
        var fr = new FileReader();
        
		var self = this;
       	fr.onload = function() {
            var fileContents = fr.result;
    	    var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;

            fileContents = fileContents.substring(dataStart);
        
    	    self.upload(component, file, fileContents, parentid);
        };

        fr.readAsDataURL(file);
    },
        
    upload: function(component, file, fileContents, parentid) {
        var action = component.get("c.saveTheFile"); 

        action.setParams({
            parentId: parentid,
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });

        action.setCallback(this, function(a) {
            attachId = a.getReturnValue();
            console.log('>>>>>>>>>>>>>>>> attachId >>>>>>' + attachId);
        });
            
        $A.run(function() {
            $A.enqueueAction(action); 
        });
    },
        
    validateCaptcha : function(component, event, helper) {    	
        //Clear search text and results
    	var captcha = component.find("captcha");
        console.log('>>>>>>>>>>>>>> captcha : ' + JSON.stringify(captcha));
    }
    
})