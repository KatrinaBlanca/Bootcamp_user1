({
    
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ['PaymentDate','PaymentReference','PaymentStatus','PaymentOffice','PaymentMode','AmountPaid','PostingDate'];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                
                csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult;        
    },
    //START Breadcrumb-task GSerrano SEPT-25-17
    goToHome : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/dashboard';
        window.location.assign(pageUrl);
    },
    goToBillsPayments : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/mybills';
        window.location.assign(pageUrl);
    },
    //END Breadcrumb-task GSerrano SEPT-25-17
    //START R2C CSM-14749 Shayne 12/01/2017
    initializeCheckConglomerate : function(component, event) {
        console.log('initializeCheckConglomerate');
       var action = component.get("c.retrieveCheckConglomerate");
        action.setCallback(this,function(response){             
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('initializeCheckConglomerate state' + state +' and result '+result);
            if(state === "SUCCESS"){
                 component.set('v.isConglomerate',result);
            }
        });  
        $A.enqueueAction(action);
    }
    //END R2C CSM-14749 Shayne 12/01/2017

    /*Start R2C CSM-14692 Von Pernicia*/
    ,search : function(component, event) {
       console.log('helper');
        var searchRef = component.find('searchId').get('v.value');
        var alldata = component.get('v.allData');
        var none = true;
        for(var i = 0 ; i < alldata.length; i++){
            if(alldata[i].PaymentReference == searchRef){
                component.set('v.tableCurrent' , alldata[i]);
                none = false;
            }
        }
        if(none){
            if(searchRef != ''){
                component.find('searchId').set('v.errors' , [{message:"Invalid Payment Reference No."}]);
            }else{
                component.find('searchId').set('v.errors' , [{message:""}]);
            }
            var tableRet = component.get('v.tableReturn');
            component.set('v.tableCurrent' , tableRet[0].paymentList);
            component.set('v.currentPageNum' , tableRet[0].recordPagenum);
            if(returnsize > 0){
                component.find("downloadBTN").set('v.disabled' , false);
                component.find("printBTN").set('v.disabled' , false);
                if(response.getReturnValue().paymentrecordList.length > 1){
                    component.find('firstBTN').set('v.disabled' , true);
                    component.find('prevBTN').set('v.disabled' , true);
                    var pageBTN = component.find("pagesBTN");
                    pageBTN[0].set('v.disabled', true);
                }else if(response.getReturnValue().paymentrecordList.length == 1){
                    component.find('nextBTN').set('v.disabled' , true);
                    component.find('lastBTN').set('v.disabled' , true);
                    component.find('firstBTN').set('v.disabled' ,true);
                    component.find('prevBTN').set('v.disabled' , true);
                    var pageBTN = component.find("pagesBTN");
                    pageBTN.set('v.disabled' , true);
                }
            }
        }else{
            component.find('searchId').set('v.errors' , [{message:""}]);
        }
    }
    /*End R2C CSM-14692 Von Pernicia*/
})