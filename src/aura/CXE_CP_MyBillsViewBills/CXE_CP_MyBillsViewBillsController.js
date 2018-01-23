({
    init : function(cmp, evt, h) {
      	var query = h.url_param();

      	query.acctNo = query.acctNo || 'none';
      	query.sinNo = query.sinNo || 'none';
      	query.bpinvoiceDate = query.bpinvoiceDate || 'none';
      	query.fromBillSumm = query.fromBillSumm || 'none';

      	cmp.set("v.passedAcctNo", query.acctNo);

      	// console.log("query", query);

      	if(cmp.get("v.isLocked")){
      	    cmp.set("v.isLocked", (query.fromBillSumm == 'none') );
      	}
        
      	// h.retrieveBillsData(cmp, evt, h);

      	// debugger;
      	window.addEventListener("message", function(event){
      	    // debugger;
      	    var msg = event.data;
            
      	    if(msg === 'pdf-ready'){
      	        if(cmp.get('v.containsPdf') && cmp.get("v.urlValue").length > 8){
      	            h.broadcast({pdf: cmp.get("v.urlValue")});
      	        }
      	        else{
      	            h.broadcast({pdf: 'about:blank'});
      	        }   
      	    }
      	    else{
      	        console.log('message', typeof msg, msg.length);
      	        h.run(function(){
      	            console.log('set download', typeof msg, msg.length);
      	            var a = document.getElementById('download-btn');
      	            // CSM-14175 Lisen 20171030
      	            //a.href = 'data:application/octet-stream;filename=test.pdf;base64,'+encodeURIComponent(msg.split(',')[1].trim());
      	            //a.download = cmp.get("v.selected.__alias") + " - " + cmp.get("v.selected.billDtl.invoice_date__date").replace(RegExp('/', 'g'), '-') + ".pdf";    
      	            a.href = cmp.get("v.urlValue");
      	            a.target = '_blank';
      	            // CSM-14175 Lisen 20171030

                    //START CSM-14219 GGrandea 11.09.2017
                    var userAgent = navigator.userAgent || navigator.vendor || window.opera;
                    if (/Android|iPad|iPhone|iPod|webOS|BlackBerry|Windows Phone/.test(userAgent) && !window.MSStream) {
                        var spinner = cmp.find('iframe-div');
                        $A.util.addClass(spinner, "slds-hide"); 
                    }
                    //END CSM-14219
      	        });    
      	    }
            
      	}, false);

      	cmp.load_bill()
      	.then(function(res){
      	    cmp.set('v.allBillingSummary', res);

      	    h.setupPageData(cmp ,evt, h)

      	    cmp.bind();
      	    cmp.toggle_load(); 
      	})
      	.catch(h.error)
    },
    
    bind: function(cmp, evt, h){    
    	  var selected_id = (!!evt.target && !!evt.target.value)?evt.target.value : cmp.get("v.selected_id");
    	  var selected = cmp.get('v.allBillingSummary').filter(function(e){return e.billDtl.id == selected_id});

    	  cmp.set('v.selected', selected[0] || cmp.get('v.allBillingSummary')[0]);
    	  cmp.set('v.containsPdf', !!(cmp.get('v.selected').billDtl||{}).document_id);
        
      	h.broadcast({loading: true});

      	if(!!cmp.get('v.containsPdf')){
      	    // debugger;
      	    cmp.set("v.passedDocId", cmp.get('v.selected').billDtl.document_id);
      	    cmp.pdf_presign(cmp.get('v.selected').billDtl.document_id)
      	        .then(h.broadcast);
            
      	    // h.refreshPdfHelper(cmp, evt, h);
      	}
      	else{
      	    h.broadcast({ pdf: 'about:blank' });
      	} 
    },

    
    payNow: function(cmp, evt, h){
        var currentACT = cmp.get('v.passedAcctNo');
        var currentRecord = cmp.get('v.currentRecord');
        var currentAmount = cmp.get('v.selected').billDtl.total_amount;
        console.log(cmp.get('v.selected').billDtl.bill_number);
        console.log(currentAmount);
        console.log(currentRecord);
        
        var action = cmp.get("c.validateData");
        action.setParams({"acctNo":currentACT,"amount":currentAmount});
        action.setCallback(this,function(response){ 
            console.log(response.getReturnValue());
            var state = response.getState();
            
            if(cmp.isValid() && (state === "SUCCESS") && response.getReturnValue != null){   
                if(response.getReturnValue() == 'reactivate pending'){
                    cmp.set("v.errorTerminated", true);
                }else if(response.getReturnValue() == 'reactivate pending 2'){
                    cmp.set("v.errorDisconnected", true);
                }else if(response.getReturnValue() == 'overdue'){
                    cmp.set("v.errorOverdue", true);
                }else if(response.getReturnValue() =='active'){ //Start Of CSM-14775 |12.5.2017 |Corbes Melvin  line# 113
                    cmp.set("v.myBillsViewBillsTab2", true);
                     
                    /*else if(response.getReturnValue().errorMessage =='active'){
                        console.log(response.getReturnValue().totalPaidAmount);
                        component.set("v.myBillsViewBillsTab2", true);
                    */ //End of CSM-14775 |12.5.2017 | Corbes Melvin  line# 119   
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "",
                        "type": "Error",
                        "message": response.getReturnValue()
                    });
                    toastEvent.fire();   
                }
            }else{
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
        
        //cmp.set('v.myBillsViewBillsTab2' , true);
    },EventFireTotalAmount : function(component, event, helper) {
        var eventValue= event.getParam("tabToNavigate");
        //alert(eventValue);
        component.set("v.errorOverdue" , false);
        if(eventValue == "tab2"){
            component.set("v.myBillsViewBillsTab2", true);
        }
    },
    eventClose: function(component, event, helper) {
        var eventValue= event.getParam("attributeValue");
        //alert(eventValue);
        if(eventValue=="proceed"){
            component.set("v.myBillsViewBillsTab2", true);
        }
        component.set("v.errorTerminated", false);
        component.set("v.errorDisconnected", false);
        component.set("v.errorOverdue", false);
    },
    embed: function(cmp, evt, h){
        cmp.set('v.containsPdf', false);
        var source = cmp.get("v.urlValue");

        if(source!='NONE' && source!=''){
            cmp.set('v.containsPdf', true);

            setTimeout(function(){ 

                document.getElementById('download-btn').setAttribute('href', source);
                document.getElementById('download-btn').setAttribute('download', 'proposed_file_name');

                var pdf = document.getElementById('i-pdf') || document.createElement("IFRAME");
                pdf.id = 'i-pdf';
                
                pdf.width = 800;
                pdf.height = 500;
                pdf.border = 0;
                pdf.src = source;
                document.getElementById('embed-container').appendChild(pdf);
            }, 500);

            

        }
    },
    
    toggle_load: function(cmp, evt, h) {
        setTimeout(function(){
            h.run(function(){
                var spinner = cmp.find('spinner');
                $A.util.addClass(spinner, "slds-hide");        
            })
        }, 250);        
    },
    
    ctrl_p: function (cmp, event, helper){
        
        if(event.ctrlKey && event.keyCode == 80){
            event.preventDefault();
            console.log('ctrlPrint');
            helper.print_pdf();
        }
    },
    
    print_pdf: function (cmp, event, helper){       
        helper.stat(cmp, 'print');
        document.getElementById('the-loader').contentWindow.postMessage({print: true}, window.location.origin + '/customers/apex/CXE_pdf')

    },
    download_pdf: function(cmp, evt, h){
        //START CSM-14137 JRances / UAT, PDF download button and radio button is not working in Internet Explorer
        //helper.stat(cmp, 'download');
        h.stat(cmp, 'download');
        var file_name = cmp.get("v.selected.__alias") + " - " + cmp.get("v.selected.billDtl.invoice_date__date").replace(RegExp('/', 'g'), '-') + ".pdf";
        document.getElementById('the-loader').contentWindow.postMessage(
            { download: file_name }
            , window.location.origin + '/customers/apex/CXE_pdf'
        );
        //END CSM-14137 JRances
    },

    pdf: function (component, event, helper){    
        
        helper.stat(component, 'view');
        
        component.set('v.containsPdf', true);   
        var arg = event.getParam('arguments');
        setTimeout(function(){
            document.getElementById('the-loader').contentWindow.postMessage({pdf: arg.url}, window.location.origin + '/customers/apex/CXE_pdf');
        }, 500);
        
        window.addEventListener("message", function(event){
            var a = document.getElementById('download-btn');
            a.href = event.data.replace('application/pdf', 'application/octet-stream');
            a.download = component.get("v.selected.__alias") + " - " + component.get("v.selected.billDtl.invoice_date__date").replace(RegExp('/', 'g'), '-') + ".pdf";
        }, false);
    }
    //START CSM-11039 RReyes AUG-18-17 - added odf refresh on change of bill period
    , clearSelection: function (cmp, evt, h){
        cmp.set("v.isLocked", false);
        h.setupPageData(cmp, evt, h);
    }
    , pdf_presign: function(cmp, evt, h){
        return new Promise(function(resolve, reject){
            var doc_id = cmp.get("v.passedDocId");
            if(!doc_id || doc_id.length < 5) resolve();

            var act = cmp.get('c.presign');
            act.setParams({name: doc_id});
            act.setCallback(this, function(res){
                cmp.toggle_load(); 
                
                if(res.getState() == 'SUCCESS' && !!res.getReturnValue()){
                    cmp.set("v.urlValue", res.getReturnValue());
                    h.run(function(){
                        resolve({pdf: res.getReturnValue(), doc_id: doc_id});
                        // cmp.pdf(res.getReturnValue());    
                    });
                }
                else{
                    // console.error(doc_id, res.getError());
                    reject(res.getError());
                }
            });
            $A.enqueueAction(act);
        })
        
    }
    , load_bill: function(cmp, evt, h){
        
        var query = h.url_param();
        var action1 = cmp.get("c.retrieveBillingDetails");
        action1.setParam("legacyV10AcctNo", query.acctNo);
        var self = this;
        
        return new Promise(function(resolve, reject){
            action1.setCallback(self, function(res){
                
                var state = res.getState();
                var val = res.getReturnValue();

                console.log('load_bill', val);
                
                if(state === "SUCCESS"){
                    h.run(function(){resolve(val);});
                    // h.setupPageData(cmp, evt, h, query);
                }
                else{
                    reject(res.getError());
                }
            }); 
            
            $A.enqueueAction(action1);
        });
    }
    
    //START CSM-14096 JRances / UAT, Billed Amount and Current Amount Due in View Bill page should not have a Peso sign before the amount
    //START Breadcrumb-task IPenaflor SEPT-25-17
    , redirectToHome : function (component, event, helper){
        helper.goToHome(component, event, helper);
    },
    
    redirectToMyBills : function (component, event, helper){
        helper.goToMyBills(component, event, helper);
    }
    //END Breadcrumb-task IPenaflor SEPT-25-17
    
    , EventFire : function(component, event, helper) {
        var eventValue= event.getParam("attributeValue");
        if(eventValue){
            component.set("v.mainComponent", false);
            component.set("v.paperlessCmp", true);
        }
    }
    //END CSM-14096 JRances 
})