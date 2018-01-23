({
    doInit : function(component, event, helper) {
        //helper.getConvenienceFee(component, event);
    },
    //START CSM-14422 RReyes NOV-12-17
    payNow: function(c, e, h) {
        //START CSM-14422 RReyes NOV-16-17
        console.log('tab3 initialize START');
        console.log('filteredBillingSummary >>> ' + JSON.stringify(c.get("v.filteredBillingSummary")));
        console.log('tab3 initialize END');
        //END CSM-14422 RReyes NOV-16-17
        console.log('account_number >>> ' + c.get('v.account_number'));
        console.log(c.get('v.paymentTokenId'));
        console.log(c.get('v.totalAmountToPay'));
        console.log(c.get('v.convenienceFee'));
        console.log(c.get('v.totalAmountForSettlement'));
        console.log(c.get('v.ccCardName'));
        console.log(c.get('v.emailPass'));
        console.log(c.get('v.payAsGuestReference'));
        console.log('sample' +  c.get('v.filteredBillingSummary'));
        console.log('samplesample' + c.get('v.filteredBillingSummary').length);
        console.log('sampleStatus' + c.get('v.payment_status'));
        console.log('checkThis' + JSON.stringify(c.get('v.subTotalMap')));
        var subTotal = c.get('v.subTotalMap');
        var paymentTransaction = [];

        var paymentType = '';
        
        //viewbill
        var invoiceId = '';
        var billId = '';
        var acctNum = '';
        var servNum = '';
        var payAmount = '';
        var acctId = '';
        var invoiceNumber = '';

        //mybills
        var lstPartialAccounts = [];
        var partialToSubtotal = [];
        var lstSelectedInvoices = [];
        var lstSelectedSINS = [];
        var lstSelectedBillIds = [];
        var lstSelectedInvoiceNums = [];
        
        console.log('fbslength >>> ' + c.get('v.filteredBillingSummary').length);
        
        if(c.get('v.filteredBillingSummary').length == 0){
            acctNum = (c.get('v.account_number') != null) ? c.get('v.account_number') : '';
            billId = c.get('v.billId') != null ? c.get('v.billId') : '';
            payAmount = c.get('v.totalAmountToPay') != null ? c.get('v.totalAmountToPay') : '';
            acctId = c.get('v.external_ID') != null ? c.get('v.external_ID') : '';
            //START CSM-14422 RReyes NOV-15-17
            if(c.get('v.advancePayment') && c.get('v.payAsGuestReferenceValue') != acctNum){
                servNum = c.get('v.payAsGuestReferenceValue') != null ? c.get('v.payAsGuestReferenceValue') : '';
            }
            paymentType = 'Other';
            paymentTransaction.push({"accountNum": acctNum, "serviceNum": servNum ,"billId": billId,"paymentAmount" :  payAmount,"accountId" : acctId});
            //END CSM-14422 RReyes NOV-15-17
        }else{
            console.log('FIRST ELSE');
            var filteredBillingSummary = c.get('v.filteredBillingSummary');
            console.log('filtersam'+filteredBillingSummary.length);
            //From Advance Payment
            if(c.get('v.advancePayment')){
                console.log('FROM ADVANCE PAYMENT');
                paymentType = 'Advance';
                
                if(c.get('v.advanceState') == 'advanceAccount'){
                    console.log('isAdvancePaymentAccount');
                    paymentTransaction.push({"accountNum": c.get('v.account_number'), "serviceNum": null ,"billId": null,"paymentAmount" : c.get('v.totalAmountToPay') ,"accountId" : c.get('v.external_ID')}); 
                }else{
                    console.log('isAdvancePaymentAccountService');
                    //START CSM-14422 RReyes NOV-15-17
                    if(c.get('v.account_number') != c.get('v.payAsGuestReferenceValue')){
                        servNum = c.get('v.payAsGuestReferenceValue');
                    }
                    paymentTransaction.push({"accountNum": c.get('v.account_number'), "serviceNum": servNum ,"billId": null,"paymentAmount" : c.get('v.totalAmountToPay') ,"accountId" : c.get('v.external_ID')}); 
                    //END CSM-14422 RReyes NOV-15-17
                }
            }
            //from View Bills -> Exact, Single Invoice
            else if(c.get('v.myViewBills')){
                console.log('FROM VIEW BILL');
                paymentType = 'ViewBill';

                var currentData = filteredBillingSummary.billDtl;
                invoiceId = currentData.invoice_id;
                billId = currentData.id;
                acctNum = currentData.acctNum; //CSM-14404
                servNum = currentData.svcNum; //CSM-14404
                payAmount = currentData.penAmt; //CSM-14404
                //paymentTransaction.push({"accountNum": currentData.acctNum, "serviceNum": null ,"billId": currentData.id,"paymentAmount" : currentData.totalAmt ,"accountId" : c.get('v.external_ID')}); //CSM-14404
                //distribute based on invoice id/bill id
                //pass: accountNum/serviceNum/billId/paymentAmount/accountId
            }
            //from Pay As Guest Page - with invoice as input
            else if(c.get('v.payAsGuest') && !c.get('v.advancePayment')){
                console.log('FROM PAY AS GUEST');
                paymentType = 'PayAsGuestInvoice';
                invoiceNumber = c.get('v.payAsGuestReferenceValue');
                payAmount = c.get('v.totalAmountToPay').toString();
                console.log('>>payAmount: ' + payAmount);
            }
            //from Bill Summary Page
            else{
                console.log('FROM BILLING SUMMARY');
                paymentType = 'BillSum';

                for(i = 0; i < subTotal.length ; i++){
                    //Overpayment
                    if(subTotal[i].subtotal > subTotal[i].prevSubtotal){
                        console.log('booom' + subTotal[i].key);
                        var paymentAmountHolder =subTotal[i].subtotal - subTotal[i].prevSubtotal;
                        console.log('bompanes' + paymentAmountHolder);
                        paymentTransaction.push({"accountNum":  subTotal[i].key, "serviceNum": null ,"billId": null,"paymentAmount" : paymentAmountHolder ,"accountId" : subTotal[i].contractExternalId});
                    }
                    //Partial payment
                    else if(subTotal[i].subtotal < subTotal[i].prevSubtotal){
                        if(lstPartialAccounts != null && lstPartialAccounts.indexOf(subTotal[i].key) <= -1){
                            lstPartialAccounts.push(subTotal[i].key);
                            //partialToSubtotal.push({"accountNum":  subTotal[i].key, "subTotal": subTotal[i].subtotal});
                        }
                    }
                }
                console.log('lstPartialAccounts: ' + lstPartialAccounts);
                console.log('partialToSubtotal: ' + JSON.stringify(partialToSubtotal));

                for(var i = 0; i<filteredBillingSummary.length;i++ ){
                    for(var x = 0; x<filteredBillingSummary[i].listBills.length ; x++){ //CSM-14404
                        if(filteredBillingSummary[i].listBills[x].isSINSel == 'true'){ //CSM-14404
                            
                            var currentData = filteredBillingSummary[i].listBills[x]; //CSM-14404
                            
                            lstSelectedInvoices.push({"accountNum": currentData.acctNum, //CSM-14404
                                                      "serviceNum": currentData.svcNum, //CSM-14404
                                                      "billId": currentData.id,
                                                      "pendingAmount" : currentData.penAmt, //CSM-14404
                                                      "invoiceId": currentData.invoice_id}); 
                            if(lstSelectedSINS != null && lstSelectedSINS.indexOf(currentData.svcNum) <= -1 //CSM-14404
                                && currentData.svcNum != null && currentData.svcNum != ''){ //CSM-14404
                                    lstSelectedSINS.push(currentData.svcNum); //CSM-14404                    
                            }

                            if(lstSelectedBillIds != null && lstSelectedBillIds.indexOf(currentData.id) <= -1 
                                && currentData.id != null && currentData.id != ''){
                                    lstSelectedBillIds.push(currentData.id);                     
                            }

                            if(lstSelectedInvoiceNums != null && lstSelectedInvoiceNums.indexOf(currentData.invoice_id) <= -1 
                                && currentData.invoice_id != null && currentData.invoice_id != ''){
                                    lstSelectedInvoiceNums.push(currentData.invoice_id);                     
                            }
                        }
                    }
                }

            }
        }
        console.log('payment transaction '+ JSON.stringify(paymentTransaction));
        console.log('call pay START');
        h.promise(c, 'payV2', {
            token: c.get('v.paymentTokenId')
            , amount: c.get('v.totalAmountToPay').toString()
            , fee: c.get('v.convenienceFee').toString()
            , total: c.get('v.totalAmountForSettlement').toString()
            , fname: c.get('v.ccCardName')
            , emailPass : c.get('v.emailPass')
            , paymentMode : c.get('v.paymentOptionCode')
            , paymentOffice : '110008'
            , address: c.get('v.ccBillingAddress')
            , paymentTransaction: paymentTransaction
            , paymentType: paymentType
            , invoiceId: invoiceId
            , billId: billId
            , acctNum: acctNum
            , servNum: servNum
            , payAmount: payAmount
            , invoiceNumber: invoiceNumber
            , subTotalMap: JSON.stringify(subTotal)
            , lstSelectedInvoices: JSON.stringify(lstSelectedInvoices)
            , lstSelectedSINS: JSON.stringify(lstSelectedSINS)
            , lstSelectedBillIds: JSON.stringify(lstSelectedBillIds)
            , lstSelectedInvoiceNums: JSON.stringify(lstSelectedInvoiceNums)
        })
        .then(function(res){
            console.log('PAY >>> ', res);
            console.log('res.requestReferenceNumber >>> ' + res.requestReferenceNumber);
        
            /*var setEvent = c.getEvent("setTotalAmount");
            setEvent.setParams({"referenceNumber":res.requestReferenceNumber});
            setEvent.setParams({"tabToNavigate":"tab4"});
            setEvent.fire();
            console.log(res.verificationURL); */
            //if(!!res.verificationUrl)
            //window.location.href = res.verificationUrl;
            if(res.requestReferenceNumber){
                window.open(res.verificationUrl, '_self');
            }else{
                var toast = $A.get("e.force:showToast");
                toast.setParams({
                    type: 'warning'
                    , title: 'Error'
                    , message: 'Something Went Wrong'
                });
            }
            
            //c.show_tab(3);
            //document.getElementById('the-confirm').src = res.verificationUrl;
        })
        .catch(h.error);
    },
    //END CSM-14422 RReyes NOV-12-17
    Cancel: function(component, event, helper) {
        component.set("v.showLoader", true);
        location.reload();
    }
})