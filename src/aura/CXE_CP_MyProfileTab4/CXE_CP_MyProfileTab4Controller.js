({
    doInit : function(component, event, helper){
        helper.onInit(component);
        helper.getSalutations(component, event, helper);
        //START CSM-13709 JRances - Remove Placeholder if there is Birthdate provided
        helper.removeCSSPlaceholder(component, event, helper);
        //END CSM-13709 JRances
        // console.log('my record id is: ',component.get('v.recordId'));
    },
    checkValue : function(component, event, helper) { 
        helper.checkValueHelper(component, event, helper);
    },
    
    onClickUpdate : function(component, event, helper) {
        helper.onClickUpdateHelper(component, event, helper);
        // START CSM-14554 Jerome To 11/20/2017 Prompt that the user can edit the profile information but it doesn’t tell where the user can edit it.
        helper.removeParamGetInfo(component, event, helper);
        // END CSM-14554 Jerome To 11/20/2017 Prompt that the user can edit the profile information but it doesn’t tell where the user can edit it.
    },

    onChangeSalutation : function(component, event, helper) {
        component.set("{!v.contactDetails.Salutation}", event.getSource().get("v.value"));
    },
    
    editProfileCancel : function(component, event, helper) {
        helper.editProfileCancelHelper(component, event, helper);
    },
    
    hidePriNumError : function(component, event, helper) {
        helper.helperHidePriNumError(component, event, helper);
    },
    
    hideSecNumError : function(component, event, helper) {
        helper.helperHideSecNumError(component, event, helper);
    },
    
    hideLandNumError : function(component, event, helper) {
        helper.helperHideLandNumError(component, event, helper);
    },
    removeMessageSuccess2 : function(component, event, helper) {
        helper.removeMessageSuccessHelper2(component, event, helper);
    },
    
    onDragOver: function(component, event) {
        event.preventDefault();
    },
    
    onDrop: function(component, event, helper) {
        event.stopPropagation();
        event.preventDefault();
        event.dataTransfer.dropEffect = 'copy';
        var maxFileSize = 768000; //750KB
        var files = event.dataTransfer.files;
        var mimeType = files[0].type; //
        var toastEvent = $A.get("e.force:showToast");
        console.log('@@@@ImageType: ' + mimeType);
        console.log('File Size is: ',files[0].size);
        if (files[0].size > maxFileSize){
            //return alert("Sorry, but the photo you're trying to upload exceeds the maximum allowable size of 750 KB. Please upload another photo");
            toastEvent.setParams({"title": "Image Size Too Big",
						  "message": "Sorry, but the photo you're trying to upload exceeds the maximum allowable size of 750 KB. Please upload another photo",
						  "type": "error",
						  "duration" : 6000
						 });
            toastEvent.fire();
            return null;
        }
        if (files.length>1) {
            //return alert("You can only upload one profile picture");
            toastEvent.setParams({
						  "message": "You can only upload one profile picture",
						  "type": "error",
						  "duration" : 6000
						 });
            toastEvent.fire();
            return null;
        }
        if (mimeType == 'image/jpeg' || mimeType == 'image/jpg' || mimeType == 'image/png') {
            component.set("v.imageFile",files[0]);
            helper.readFile(component, helper, files[0]);
            component.set("v.DropImg", true);
        } else {
            //return alert("Image file not supported");
            toastEvent.setParams({
						  "message": "Image file not supported",
						  "type": "error",
						  "duration" : 6000
						 });
            toastEvent.fire();
            return null;
        }
        
    },

    removePlaceholder : function(component, event, helper) {
        helper.removeCSSPlaceholder(component, event, helper);
    }
    
    //START CSM-14163 UPLOAD PHOTO for Mobile 10.29.2017
    , onProfilePhotoDrop: function(component, event, helper) {
        console.log('>>>>>>>>>>>>>>>>>>>>>> onProfilePhotoDrop ');
        var profilePhoto = component.find("profile_photo").getElement().files[0];
        if(profilePhoto!=null){

            var maxFileSize = 768000; //750KB
            var mimeType = profilePhoto.type; //

            console.log('@@@@ImageType: ' + mimeType);
            console.log('File Size is: ', profilePhoto.size);

            var toastEvent = $A.get("e.force:showToast");

            if (profilePhoto.size > maxFileSize){
                //return alert("Sorry, but the photo you're trying to upload exceeds the maximum allowable size of 750 KB. Please upload another photo");
                toastEvent.setParams({"title": "Image Size Too Big",
                              "message": "Sorry, but the photo you're trying to upload exceeds the maximum allowable size of 750 KB. Please upload another photo",
                              "type": "error",
                              "duration" : 6000
                             });
                toastEvent.fire();
                return null;
            }
            if (mimeType == 'image/jpeg' || mimeType == 'image/jpg' || mimeType == 'image/png') {
                component.set("v.imageFile", profilePhoto);
                helper.readFile(component, helper, profilePhoto);
                component.set("v.DropImg", true);
            } else {
                //return alert("Image file not supported");
                toastEvent.setParams({
                              "message": "Image file not supported",
                              "type": "error",
                              "duration" : 6000
                             });
                toastEvent.fire();
                return null;
            }
        }
    }
    //END CSM-14163 10.29.2017
})