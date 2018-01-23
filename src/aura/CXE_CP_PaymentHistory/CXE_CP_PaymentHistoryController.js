({
    doInit : function(component, event, helper) {
        helper.initializeCheckConglomerate(component, event, helper); //R2C CSM-14749 Shayne 12/01/2017
        //CSM-12823 Start Emandolado 9/20/2017
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
        //CSM-12823 End Emandolado 9/20/2017
        component.find('nextBTN').set('v.disabled' , true);
        component.find('lastBTN').set('v.disabled' , true);
        component.find('firstBTN').set('v.disabled' ,true);
        component.find('prevBTN').set('v.disabled' , true);
        
        var action = component.get("c.retrievePayment");
        action.setCallback(this,function(response){          
            var state = response.getState();
            
            //FOR ACCOUNT LIST PART DROPDOWN
            
            //START CSM-12878 GGrandea 09.22.2017
            //if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue() != null){
                //END CSM-12878 GGrandea 09.22.2017
                console.log(response.getReturnValue());
                if(response.getReturnValue().allData!=null){ //CSM-12878 *****
                    var returnsize = response.getReturnValue().allData.length;
                    if(response.getReturnValue().paymentrecordList.length>0){ //START CSM-13804 added 'if'
                        component.set('v.tableReturn' , response.getReturnValue().paymentrecordList);
                        var tableRet = component.get('v.tableReturn');
                        component.set('v.tableCurrent' , tableRet[0].paymentList);
                        component.set('v.allData' , response.getReturnValue().allData);
                        component.set('v.currentPageNum' , tableRet[0].recordPagenum);
                        if(returnsize > 0){
                            component.find("downloadBTN").set('v.disabled' , false);
                            component.find("printBTN").set('v.disabled' , false);
                            if(response.getReturnValue().paymentrecordList.length > 1){
                                component.find('firstBTN').set('v.disabled' , true);
                                component.find('prevBTN').set('v.disabled' , true);
                                component.find('nextBTN').set('v.disabled' , false);
                                component.find('lastBTN').set('v.disabled' , false);
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
                    }//END CSM-13804 GGrandea
                    
                }//CSM-12878 *****
                //START CSM-12878 GGrandea 09.22.2017 ** disabled below code
                /*var cmpTarget = component.find("appSpinner");
                $A.util.toggleClass(cmpTarget, 'slds-hide');*/
                //END CSM-12878 GGrandea 09.22.2017
            }else{
                //START CSM-12878 GGrandea 09.22.2017 ** disabled below code
                //CSM-12823 Start Emandolado 9/20/2017
                /*var cmpTarget = component.find("appSpinner");
                $A.util.toggleClass(cmpTarget, 'slds-hide');*/
                //CSM-12823 End Emandolado 9/20/2017
                //END CSM-12878 GGrandea 09.22.2017
                //alert('yow');
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
            //START CSM-12878 GGrandea 09.22.2017
            var cmpTarget = component.find("appSpinner");
            $A.util.toggleClass(cmpTarget, 'slds-hide');
            //END CSM-12878 GGrandea 09.22.2017
        });  
        $A.enqueueAction(action); 
    },
    downloadPDF  : function(component, event, helper) {
        var stockData = component.get("v.allData");
        var csv = helper.convertArrayOfObjectsToCSV(component,stockData);   
        if (csv == null){return;} 
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = 'ExportData.csv';
        document.body.appendChild(hiddenElement);
        hiddenElement.click();
    },
    printTable  : function(component, event, helper) {
        window.print();
    },
    Pagination : function(component, event, helper) {
        var tableReturn = component.get('v.tableReturn');
        var lastPage = tableReturn.length;
        var firstPage = 1;
        var curentPage = event.getSource().get("v.label");
        var tableReturn = component.get('v.tableReturn');
        var pageBTN = component.find("pagesBTN");
        console.log(pageBTN);
        component.find('nextBTN').set('v.disabled' , false);
        component.find('lastBTN').set('v.disabled' , false);
        component.find('firstBTN').set('v.disabled' , false);
        component.find('prevBTN').set('v.disabled' , false);
        for (var i = 0; i < pageBTN.length; i++){
            pageBTN[i].set('v.disabled' , false);
            if(pageBTN[i].get('v.label') == curentPage){
                pageBTN[i].set('v.disabled' , true);
                if(pageBTN[i].get('v.label') == lastPage){                    
                    component.find('nextBTN').set('v.disabled' , true);
                    component.find('lastBTN').set('v.disabled' , true);
                    component.find('firstBTN').set('v.disabled' , false);
                    component.find('prevBTN').set('v.disabled' , false);
                }
                else if(pageBTN[i].get('v.label') == firstPage){
                    component.find('nextBTN').set('v.disabled' , false);
                    component.find('lastBTN').set('v.disabled' , false);
                    component.find('firstBTN').set('v.disabled' , true);
                    component.find('prevBTN').set('v.disabled' , true);
                }
            }
        }
        
        for(var i = 0 ; i < tableReturn.length ; i++){
            if(tableReturn[i].recordPagenum == curentPage){
                component.set('v.tableCurrent' , tableReturn[i].paymentList);
                component.set('v.currentPageNum' , tableReturn[i].recordPagenum);
            }
        }
    },
    /*Start R2C CSM-14692 Von Pernicia*/
    search : function(component, event, helper) {
        if(event.keyCode ===13){
            console.log('sample' + event.keyCode);
            helper.search(component, event);
        }
        
    },
    searchIcon : function(component, event, helper) {
        console.log('click');
        helper.search(component, event);
    },
    /*End R2C CSM-14692 Von Pernicia*/
    firstPage : function(component, event, helper) {
        var tableReturn = component.get('v.tableReturn');
        var pageBTN = component.find("pagesBTN");
        var firstPage = 1;
        for (var i = 0; i < pageBTN.length; i++){
            pageBTN[i].set('v.disabled' , false);
            if(pageBTN[i].get('v.label') == firstPage){
                pageBTN[i].set('v.disabled' , true);
            }
        }
        
        component.set('v.tableCurrent' , tableReturn[0].paymentList);
        component.set('v.currentPageNum' , tableReturn[0].recordPagenum);
        component.find('nextBTN').set('v.disabled' , false);
        component.find('lastBTN').set('v.disabled' , false);
        component.find('firstBTN').set('v.disabled' , true);
        component.find('prevBTN').set('v.disabled' , true);
    },
    lastPage  : function(component, event, helper) {
        var tableReturn = component.get('v.tableReturn');
        var lastPage = tableReturn.length - 1;
        var pageBTN = component.find("pagesBTN");
        
        for (var i = 0; i < pageBTN.length; i++){
            pageBTN[i].set('v.disabled' , false);
            if(pageBTN[i].get('v.label') == lastPage + 1){
                pageBTN[i].set('v.disabled' , true);
            }
        }      
        
        component.set('v.tableCurrent' , tableReturn[lastPage].paymentList);
        component.set('v.currentPageNum' , tableReturn[lastPage].recordPagenum);
        component.find('nextBTN').set('v.disabled' , true);
        component.find('lastBTN').set('v.disabled' , true);
        component.find('firstBTN').set('v.disabled' , false);
        component.find('prevBTN').set('v.disabled' , false);
    },
    nextPage  : function(component, event, helper) {
        var currentPage = component.get('v.currentPageNum') - 1;
        var tableReturn = component.get('v.tableReturn');
        var lastPage = tableReturn.length - 1;
        var pageBTN = component.find("pagesBTN");
        
        
        currentPage = currentPage + 1;
        
        for (var i = 0; i < pageBTN.length; i++){
            pageBTN[i].set('v.disabled' , false);
            if(pageBTN[i].get('v.label') == currentPage + 1){
                pageBTN[i].set('v.disabled' , true);
            }
        }      
        
        component.set('v.tableCurrent' , tableReturn[currentPage].paymentList);
        component.set('v.currentPageNum' , tableReturn[currentPage].recordPagenum);
        if(currentPage == lastPage){
            component.find('nextBTN').set('v.disabled' , true);
            component.find('lastBTN').set('v.disabled' , true);
        }
        component.find('firstBTN').set('v.disabled' , false);
        component.find('prevBTN').set('v.disabled' , false);
        
    },
    prevPage  : function(component, event, helper) {
        var currentPage = component.get('v.currentPageNum') - 1;
        var tableReturn = component.get('v.tableReturn');
        var firstPage = 0;
        var pageBTN = component.find("pagesBTN");
        
        currentPage = currentPage - 1;
        for (var i = 0; i < pageBTN.length; i++){
            pageBTN[i].set('v.disabled' , false);
            if(pageBTN[i].get('v.label') == currentPage + 1){
                pageBTN[i].set('v.disabled' , true);
            }
        }   
        component.set('v.tableCurrent' , tableReturn[currentPage].paymentList);
        component.set('v.currentPageNum' , tableReturn[currentPage].recordPagenum);
        if(currentPage == firstPage){
            component.find('firstBTN').set('v.disabled' , true);
            component.find('prevBTN').set('v.disabled' , true);
        }
        component.find('nextBTN').set('v.disabled' , false);
        component.find('lastBTN').set('v.disabled' , false);
        
    },
    //START Breadcrumb-task GSerrano SEPT-25-17
    redirectToHome : function (component, event, helper){
        helper.goToHome(component, event, helper);
    },
    redirectToBillsPayments : function (component, event, helper){
        helper.goToBillsPayments(component, event, helper);
    }
  	//END Breadcrumb-task GSerrano SEPT-25-17
})