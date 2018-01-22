({
    retrieveBillsData: function(cmp, evt, h){
        var query = h.url_param();

        var action1 = cmp.get("c.retrieveBillingDetails");
        action1.setParam("legacyV10AcctNo", query.acctNo);
        action1.setCallback(this,function(response){

            cmp.toggle_load(); 
            var state = response.getState();
            var retVal = response.getReturnValue();
            console.log('>>response: ' + JSON.stringify(retVal));
            if(state === "SUCCESS"){
                cmp.set('v.allBillingSummary', retVal);

                h.setupPageData(cmp, evt, h, query);
            }
        }); 
        
        $A.enqueueAction(action1);
    }, 

    setupPageData: function(cmp, evt, h){
        
        var query = h.url_param();
        query.sinNo = query.sinNo || 'none';

        var filteredBillingSummary = [];

        var serv = {}, billPeriods = {}, servAlias = {};

        //filter of bill note data
        cmp.get('v.allBillingSummary').forEach(function(e){
            
            var alias = (e.enrollment||{}).CXE_Alias__c;
            e.__alias = e.billDtl.service_number + (!!alias?(" - " + alias) : "")

            if(e.billDtl.account_number == query.acctNo){
                /*
                *** why? It has bugs

                if(cmp.get("v.isLocked") 
                    && query.sinNo!='none' 
                    && (e.billDtl.service_number!=query.sinNo || e.billDtl.invoice_date!=query.bpinvoiceDate) 
                ){
                    return;
                }
                if(cmp.get("v.isLocked") && query.sinNo=='none' && e.billDtl.invoice_date!=query.bpinvoiceDate){
                    return;
                }
                */

                //Start CSM-12587 Emandoaldo 9/15/2017
                    //START CSM-14600 GGrandea 11.21.2017 - adding bill id check
                if(cmp.get("v.isLocked") 
                    && query.sinNo!='none' 
                    && (e.billDtl.service_number!=query.sinNo || e.billDtl.invoice_date!=query.bpinvoiceDate || e.billDtl.id!=query.bpBillId) 
                ){
                    return;
                }
                    //END CSM-14600
                if(cmp.get("v.isLocked") && query.sinNo=='none' && e.billDtl.invoice_date!=query.bpinvoiceDate){
                    return;
                }
                //End CSM-12587 Emandoaldo 9/15/2017
                
                filteredBillingSummary.push(e);
                serv[e.billDtl.service_number] = serv[e.billDtl.service_number] || [];
                serv[e.billDtl.service_number].push(e);

                if(e.enrollment!=null){
                    servAlias[e.billDtl.service_number] = e.enrollment.CXE_Alias__c;
                }else{
                    servAlias[e.billDtl.service_number] = '';
                }

                h.date(e.billDtl, ['due_date', 'bill_date', 'gen_date', 'invoice_date', 'last_bill_date']);
            }
        });

        // build Bill Period dropdown
        cmp.set('v.billPeriods', Object.keys(serv).map(function(servNum){                    
            return {
                no: servNum + (!!servAlias[servNum]?(" - " + servAlias[servNum]) : "")
                , period: serv[servNum].map(function(e){
                    return {
                        val: e.billDtl.id, 
                        label: [e.billDtl.last_bill_date__date, e.billDtl.bill_date__date].join(' - ')
                    }
                })
            }
        }));

        var selected_id = null;
        var selected = filteredBillingSummary.filter(function(e){
            return (e.billDtl.service_number == query.sinNo
                    &&  e.billDtl.bill_date == query.bpBillDt
                    &&  e.billDtl.id == query.bpBillId // CSM-12973 Mike Verdad 09/29/2017
                    &&  (!query.bpinvoiceDate || e.billDtl.invoice_date == query.bpinvoiceDate)
                    //&&  (!query.billid || e.billDtl.id == query.billid)
            )
        });
        
        if(!!selected && !!selected.length){
            selected_id = selected[0].billDtl.id;
        }
        else{
            selected_id = filteredBillingSummary[0].billDtl.id;
        }
        
        cmp.set("v.selected_id", selected_id);

        setTimeout(function(){ // delay set. The options is not render yet.
            var options = document.getElementById("period").options;
            for(var i = 0; i < options.length; i++){
                options[i].selected = options[i].value == selected_id;
            }
        }, 500);

        cmp.bind();
    },

    distinct: function(arr, field){
        arr = arr || [];
        var result = {};
        for(var i = 0; i < arr.length; i++){
            result[arr[i].billDtl[field]] = 1;
        }
        
        return Object.keys(result);
    }, 
    
    distinct: function(arr, field, field2, field3){
        arr = arr || [];
        var result = {};
        for(var i = 0; i < arr.length; i++){
            result[ arr[i].billDtl[field] + " : " +arr[i].billDtl[field2] +'-'+arr[i].billDtl[field3] ] = 1;
        }
        return Object.keys(result);
    }, 
    
    date: function(obj, fields){
        fields.forEach(function(f){
            if(!!obj[f]){
                var ymd = obj[f].split('-');    
                obj[f + "__date"] = [ymd[1], ymd[2], ymd[0]].join('/');
            }
        })
    }
    , url_param: function(){
        return window.location.search.substring(1).split('&').map(function(e){
            return e.split('=');
        }).reduce(function(cur, nex){
            cur[nex[0]] = decodeURIComponent(nex[1]);
            return cur;
        }, {})
    },
    
    redirectPdfHelper: function(component, event, helper){
        var action = 'print';
        //START CSM-11039 RReyes AUG-18-17
        //var fileName = 'document_id'; 
        var fileName = component.get("v.passedDocId");
        //END CSM-11039 RReyes AUG-18-17
        var act = component.get('c.pdfVault');
        act.setParams({
            'action': action,
            'fileName': fileName
        });
        act.setCallback(this,function(response){
            var urlPdf = response.getReturnValue();

            var fix = new RegExp('"', 'g');
            var fix2 = new RegExp(window.location.protocol + '//' + window.location.hostname + '/'
                                 + location.pathname.split('/')[1] + '/' 
                                 + location.pathname.split('/')[2]
                                 , 'g');

            window.open(urlPdf.replace(fix, '').replace(fix2,''));
        });
        $A.enqueueAction(act);
    },
    
     downloadPdfHelper: function(component, event, helper){
        var action = 'download';
        //START CSM-11039 RReyes AUG-18-17
        //var fileName = 'document_id'; 
        var fileName = component.get("v.passedDocId");
        //END CSM-11039 RReyes AUG-18-17
        var act = component.get('c.pdfVault');
        act.setParams({
            'action': action,
            'fileName': fileName
        });
        act.setCallback(this,function(response){
            
            var urlPdf = response.getReturnValue();

            var fix = new RegExp('"', 'g');
            var fix2 = new RegExp(window.location.protocol + '//' + window.location.hostname + '/'
                                 + location.pathname.split('/')[1] + '/' 
                                 + location.pathname.split('/')[2]
                                 , 'g');

            

            document.getElementById('download-btn').setAttribute('href', urlPdf.replace(fix, '').replace(fix2,'') );
            document.getElementById('download-btn').setAttribute('download', 'proposed_filename' );
        });

        $A.enqueueAction(act);
    }
    //START CSM-11039 RReyes AUG-18-17
    ,refreshPdfHelper: function(component, event, helper){

        component.set("v.urlValue", 'NONE');

        // validate for blank pdf
        if(!component.get("v.passedDocId") || component.get("v.passedDocId").length < 4) return;

        var act = component.get('c.presign');
        act.setParams({
            'name': component.get("v.passedDocId")
        });
        act.setCallback(this, function(res){
            if(res.getState() == 'SUCCESS' && !!res.getReturnValue()){
                component.set("v.urlValue", res.getReturnValue());
                component.pdf(res.getReturnValue());
            }
            else{
                console.error(component.get("v.passedDocId"), res.getError());
            }
        });
        $A.enqueueAction(act);
    }
    //END CSM-11039 RReyes AUG-18-17

    , stat: function(component, name){
        var act = component.get('c.pdf_stat');
        act.setParams({
            'name': name
        });
        act.setCallback(this, function(res){console.log('STAT', res)});
        $A.enqueueAction(act);
    }
    
     //START Breadcrumb-task IPenaflor SEPT-25-17
    , goToHome : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/dashboard';
        window.location.assign(pageUrl);
    },
    
    goToMyBills : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/mybills';
        window.location.assign(pageUrl);
    }
    //END Breadcrumb-task IPenaflor SEPT-25-17
    , run: function(callback){
        $A.getCallback(callback)();
    }
    , broadcast: function(msg){
        var self = this;

        return new Promise(function(resolve, reject){
            var loader = document.getElementById('the-loader');
            // debugger;
            if(!!loader && !!loader.contentWindow){
                console.log('broadcast', msg);
                loader.contentWindow.postMessage(msg, window.location.origin + '/customers/apex/CXE_pdf');
                $A.getCallback(resolve)();
            }
            else{
                setTimeout(function(){self.broadcast(msg)}, 250);
            }
        })
        
    }
    , error : function(err) {
        console.error(err);

        var toast = $A.get("e.force:showToast");

        $A.reportError(err.message, err);
        var line = err.message.split('\n');
        toast.setParams({
            type: 'error'
            , title: line[0]
            , message: line[1],
            duration: 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
        });

        toast.fire();
    }
})