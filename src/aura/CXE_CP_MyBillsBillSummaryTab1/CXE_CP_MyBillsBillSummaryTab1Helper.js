({
	/*//START CSM-14404 
			Variable Name Changes:
				"list" to "listBills
				account_number to acctNum
				service_number to svcNum
				isAccountSelected to isAcctSel
				isAccountDisabled to isAcctOff
				isSINDisabled to isSINOff
				isSINSelected to isSINSel
				pending_amount to penAmt
				total_amount to totalAmt
				due_date to dueDt
				bill_status_filter to payStatus
				bill_date to billDt
		END CSM-14404	*/
	
    SELECT_ALL: "Select Account Number",
    
    setPicklistOptions : function(component, event) {
        var action = component.get("c.retrievePortalData");
        action.setParams({"hasBilling": false});
        action.setCallback(this,function(response){
            var state = response.getState();
            var retVal = response.getReturnValue();
            
            
            //START CSM-12645 RReyes SEP-21-17
            console.log('>> AccountsWithAllSINEnrolled: ' + retVal.AccountsWithAllSINEnrolled);
            component.set("v.accountsWithSINsAllEnrolled", retVal.AccountsWithAllSINEnrolled);
            //END CSM-12645 RReyes SEP-21-17
		
            //FOR ACCOUNT LIST PART DROPDOWN
            if(retVal.ContractCountViewBill > 1){ //START/END CSM-10961 - add account# from service.contract for view bills
                //START CSM-12924 GGrandea 09.28.2017
                //var accountList = [this.SELECT_ALL];
                var accountList = [];
                accountList.push({ class: "optionClass", label: this.SELECT_ALL, value: "--Select All--", selected: true});
                //END CSM-12924 GGrandea 09.28.2017
               // alert('contract count'+ retVal.ContractCountViewBill);
            }else{
                var accountList = [];
                //accountList.unshift({ class: "optionClass", label: this.SELECT_ALL, value: "--Select All--", selected: "false"});
            }

            if(retVal.ServicesCount > 1){
               //  alert('ServicesCount count'+ retVal.ServicesCount);
                          var sinList = [];
               sinList.unshift({ class: "optionClass", label: "Select Service ID Number", value: "--Select All--", selected: "false"});
               
            }else{
                var sinList = [];
            }
            
            if(component.isValid() && (state === "SUCCESS") && retVal != null){
                //START CSM-10961 - add account# from service.contract for view bills
                for(var i = 0; i < retVal.ContractCountViewBill ; i++){ 
                    //START CSM-12924 GGrandea 09.28.2017
                    accountList.push({ class: "optionClass", label: retVal.UserContractsViewBill[i].V10_Account_No__c
                                                    , value: retVal.UserContractsViewBill[i].V10_Account_No__c, selected: false});
                    //accountList.push(retVal.UserContractsViewBill[i].V10_Account_No__c);
                    //END CSM-12924 GGrandea 09.28.2017
                }       
                //END CSM-10961 - add account# from service.contract for view bills         
                //START CSM-12924 GGrandea 09.28.2017
                //component.set("v.acctOptions" , accountList);
                component.find("accountSelected").set("v.options", accountList);
                component.find("accountSelected").set("v.value","--Select All--");
                //END CSM-12924 GGrandea 09.28.2017

                var tempLabel = '';
                var tempSelected;
                for(var i = 0 ; i < retVal.ServiceCount ; i++){
                  
                  //console.log('retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c'+ retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c);
                    tempSelected = false;
                    if(retVal.ServiceCount==1 && i==0){
                        tempSelected = true;
                    }
                    if(retVal.UserEnrollments[i].CXE_Alias__c){
                        //tempLabel = retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c + '_' + retVal.UserEnrollments[i].CXE_Alias__c;
                        tempLabel = retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c + ' - ' + retVal.UserEnrollments[i].CXE_Alias__c; //CSM-12852 Emandolado 9/20/2017
                    }else{
                        tempLabel = retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c;
                    }
                    sinList.push({ class: "optionClass"
                            , label: tempLabel
                            , value: retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c
                            , selected: tempSelected});
                }
                
                component.find("sinPopulated").set("v.options", sinList);
            
                //component.set("v.sinOptions", sinList);
                component.set("v.UserDataHolder", response.getReturnValue());
                
            }else{
               
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(retVal);
            }
        });  
        $A.enqueueAction(action);
        
    },
    
    modifySinPicklist : function (component, event){
        
        var accSelected = component.find("accountSelected").get("v.value");
        console.log('Selected Account: ' + accSelected);

        /*if(accSelected != "--Select All--"){
            component.find("sinPopulated").set("v.disabled",true);
        }else{
            component.find("sinPopulated").set("v.disabled",false);
        }*/

        var retVal = component.get("v.UserDataHolder");
            
        var sinList = [];
        var tempLabel = '';
        console.log('retVal.ServiceCount: ' + retVal.ServiceCount);
        for(var i = 0 ; i < retVal.ServiceCount ; i++){
            console.log('retVal.UserEnrollments: ' + i + ' ' +  retVal.UserEnrollments[i]);
            if(retVal.UserEnrollments[i].CXE_Alias__c){
                tempLabel = retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c + '_' + retVal.UserEnrollments[i].CXE_Alias__c;
            }else{
                tempLabel = retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c;
            }
            if(accSelected != "--Select All--"){
                //START CSM-10961 - add account# from service.contract for view bills
                if(retVal.UserEnrollments[i].CXE_ServiceId__r.Payor__r.V10_Account_No__c == accSelected ||
                    retVal.UserEnrollments[i].CXE_ServiceId__r.Contract__r.V10_Account_No__c == accSelected){
                //END CSM-10961 - add account# from service.contract for view bills
                    sinList.push({ class: "optionClass"
                            , label: tempLabel
                            , value: retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c
                            , selected: false});
                }
            }else{
                    sinList.push({ class: "optionClass"
                            , label: tempLabel
                            , value: retVal.UserEnrollments[i].CXE_ServiceId__r.SIN__c
                            , selected: false});
            }
        }

        if(sinList.length> 1){
            sinList.unshift({ class: "optionClass", label: "Select Service ID Number", value: "--Select All--", selected: "false"});
        }
        component.find("sinPopulated").set("v.options", sinList);
        
        this.generateFilteredMap(component, event);
    },
    
    modifyAccountPicklist : function (component, event, helper){
            
        var sinSelected = component.find("sinPopulated").get("v.value");
        //console.log('Selected SIN<>>>>>>:  ' + sinSelected);

        /*if(sinSelected != "--Select All--"){
            component.find("accountSelected").set("v.disabled",true);
        }else{
            component.find("accountSelected").set("v.disabled",false);
        }*/
        
        var retVal = component.get("v.UserDataHolder");
        var accOptions = [];
        //START CSM-10961 - add account# from service.contract for view bills
        var accList = [];
        for(var i = 0 ; i < retVal.ServiceCount ; i++){
            console.log('retVal.UserServices: ' + i + ' ' +  JSON.stringify(retVal.UserServices[i]));
            if(sinSelected != "--Select All--"){
                if(sinSelected==retVal.UserServices[i].SIN__c){
                    console.log(retVal.UserServices[i].Payor__r.V10_Account_No__c);
                    console.log('contract: '+ retVal.UserServices[i].Contract__r.V10_Account_No__c);
                    console.log('compare'+sinSelected + '='+retVal.UserServices[i].SIN__c);
                    var CurrentValue = retVal.UserServices[i].Payor__r.V10_Account_No__c;
                    //accOptions.unshift({ class: "optionClass", label: "--Select All--", value: "--Select All--", selected: "false"});
                    if(accList != null && accList.indexOf(CurrentValue) <= -1){
                        accList.push(CurrentValue);
                        accOptions.push({ class: "optionClass", label: CurrentValue, value: CurrentValue, selected: true});
                        
                       
                    }/* Start CSM-12415
                      * Author: Melvin Corbes
                      * Date : 09-08-2017
                      */
                    else if(accList != null && accList.indexOf(CurrentValue) >-1){ 
                        var removeValue =accList.indexOf(CurrentValue)
                        accOptions.splice(removeValue, 1);
                        accOptions.push({ class: "optionClass", label: CurrentValue, value: CurrentValue, selected: true});  
                    }// end of CSM-12415: Melvin Corbes                     
                    if(CurrentValue != retVal.UserServices[i].Contract__r.V10_Account_No__c){
                        var otherValue = retVal.UserServices[i].Contract__r.V10_Account_No__c;
                        if(accList != null && accList.indexOf(otherValue) <= -1){
                            accList.push(otherValue);
                            accOptions.push({ class: "optionClass", label: otherValue, value: otherValue, selected: false});
                        }
                    }
                }else{
                   
                    
                    var CurrentValue = retVal.UserServices[i].Payor__r.V10_Account_No__c;
                    if(accList != null && accList.indexOf(CurrentValue) <= -1){
                            accList.push(CurrentValue);
                            accOptions.push({ class: "optionClass", label: CurrentValue, value: CurrentValue});
                    }
                    if(CurrentValue != retVal.UserServices[i].Contract__r.V10_Account_No__c){
                        var otherValue = retVal.UserServices[i].Contract__r.V10_Account_No__c;
                        if(accList != null && accList.indexOf(otherValue) <= -1){
                            accList.push(otherValue);
                            accOptions.push({ class: "optionClass", label: otherValue, value: otherValue, selected: false});
                        }
                    }
                }
            }else{
                var CurrentValue = retVal.UserServices[i].Payor__r.V10_Account_No__c;
                if(accList != null && accList.indexOf(CurrentValue) <= -1){
                    accList.push(CurrentValue);
                    accOptions.push({ class: "optionClass", label: CurrentValue, value: CurrentValue, selected: false});
                   //  alert('first else>>>> if' + accList.indexOf(CurrentValue));
                }
                
                if(CurrentValue != retVal.UserServices[i].Contract__r.V10_Account_No__c){
                    var otherValue = retVal.UserServices[i].Contract__r.V10_Account_No__c;
                    if(accList != null && accList.indexOf(otherValue) <= -1){
                        accList.push(otherValue);
                        accOptions.push({ class: "optionClass", label: otherValue, value: otherValue, selected: false});
                         // alert('Second else>>>> if' + accList.indexOf(CurrentValue));
                    }
                }
                console.log(retVal.UserServices[i].Payor__r.V10_Account_No__c);
                
               
            }
            console.log('AccountNum[' + i + ']: ' + retVal.UserServices[i].Payor__r.V10_Account_No__c);
            console.log('accOptions[' + i + ']: ' + JSON.stringify(accOptions));
        }
        //END CSM-10961 - add account# from service.contract for view bills
        if(accOptions.length> 1){
            accOptions.unshift({ class: "optionClass", label: "Select Account Number", value: "--Select All--", selected: "true"});
        }
        
        component.find("accountSelected").set("v.options", accOptions);
        component.find("accountSelected").set("v.value","--Select All--");

        this.generateFilteredMap(component, event);
    },


    //START CSM-10913 RReyes JUL-24-17
    initializeBillingDetails : function(component, event) {
        //START CSM-14260 RReyes NOV-07-17 - changed from retrieveBillingDetails to retrieveBillingDetailsNoParam
        //var action = component.get("c.retrieveBillingDetailsNoParam"); //CSM-14404
        //END CSM-14260 RReyes NOV-07-17 - changed from retrieveBillingDetails to retrieveBillingDetailsNoParam
        component.set("v.filterBillType", 'All');//CSM-14404
        component.set("v.filterBillStatus", 'Unpaid');//CSM-14404
        
	//START CSM-14404
        /*action.setCallback(this,function(response){   
            //CSM-12823 Start Emandolado 9/20/2017
            var setEvent = component.getEvent("setLoader");
            setEvent.setParams({"loader":'success'});
            setEvent.fire();
            //CSM-12823 End Emandolado 9/20/2017
            var state = response.getState();
            var result = response.getReturnValue();
            //console.log('heroko state' + state +'and result'+result); //CSM-14070
            if(state === "SUCCESS"){
                component.set('v.allBillingSummary', result);
                this.generateFilteredMap(component, event);   
                             
                var totalAmountPass = component.get("v.totalAmountToPay"); 
                var setEvent = component.getEvent("setTotalAmount"); 
                var passObject = component.get('v.filteredBillingSummary'); 
                setEvent.setParams({"filteredBillingSummary":passObject}); 
                setEvent.setParams({"totalAmountToPay":totalAmountPass}); 
                setEvent.fire(); 
            }
        });  
        $A.enqueueAction(action); */
	//END CSM-14404

		//START CSM-14404
                this.generateFilteredMap(component, event);
                
                //CSM-12823 Start Emandolado 9/20/2017
                var setEvent = component.getEvent("setLoader");
                setEvent.setParams({"loader":'success'});
                setEvent.fire();
                //CSM-12823 End Emandolado 9/20/2017
		//END CSM-14404
    },

    filterData : function (component, event, helper){
        var filterBy = event.target.name;
        var filterVal = event.target.value;

        // CSM-14137 Lisen 20171027
        if(document.getElementById('new-radio1').checked){
            var billStatus = 'All';//CSM-14404
        }else if(document.getElementById('new-radio2').checked){
            var billStatus = 'Unpaid';//CSM-14404
        }else{
            var billStatus = 'Paid';//CSM-14404
        }

        if(document.getElementById('new-radio4').checked){
            var billType = 'All';//CSM-14404
        }else if(document.getElementById('new-radio5').checked){
            var billType = 'Service';//CSM-14404
        }else{
            var billType = 'Others';//CSM-14404
        }
        // CSM-14137 Lisen 20171027

        if(filterBy == 'billType'){
            //component.set("v.filterBillType", filterVal);
            component.set("v.filterBillType", billType);
        }else if(filterBy == 'billStatus'){
            //component.set("v.filterBillStatus", filterVal);
            component.set("v.filterBillStatus", billStatus);
        }

        this.generateFilteredMap(component, event);
    },

    generateFilteredMap : function(component, event) {
        //var result = component.get("v.allBillingSummary"); //CSM-14404
        var typeFilter = component.get("v.filterBillType");
        var statusFilter = component.get("v.filterBillStatus");

        //START CSM-14404
        var action = component.get("c.retrieveFilteredBills"); 
        action.setParams({"serviceNo": component.find("sinPopulated").get("v.value"),
                            "accountNo": component.find("accountSelected").get("v.value"),
                            "billType": typeFilter,
                            "billStatus": statusFilter
                            });       
        action.setCallback(this,function(response){          
            var state = response.getState();
            console.log('>>>state: ' + state);
            if(state === "SUCCESS"){
                var responseValue = response.getReturnValue();
                //var result = response.getReturnValue();
                var result = responseValue.summaryList;
                var objMap = responseValue.billObjMainMap;
                var totalSINSSelectable = 0;
                var totalOfSubTotals = 0;
                var totalCurrentAmt = 0.0;

                //var myObjectMap = []; //CSM-14404
                var myObjectMap = objMap; //CSM-14404
                var subTotalMap = [];
                var accountList = [];
                var serviceList = [];
                var idList = [];
                		
                console.log('# of total bills: ' + result.length);

                if(result.length >= 100 && statusFilter!='Unpaid'){
                    console.log('***** More than 100 data. *****');
                    component.set("v.showExceedPrompt", true);
                }
                else{
                    component.set("v.showExceedPrompt", false);
                    // Loop through results; remember, this is a list of sObjects
                    for(var i=0; i<result.length; i++) {                
                        // Get the record
                        var myRecord = result[i];
                        var subtotal = 0;

                        //START CSM-12924 GGrandea 09.28.2017
                        /*if( //START CSM-14404
                            (
                                (component.find("accountSelected").get("v.value")=="--Select All--"
                                        && myRecord.svcNum!=component.find("sinPopulated").get("v.value") )
                                    ||
                                (component.find("sinPopulated").get("v.value")=="--Select All--"
                                        && myRecord.acctNum!=component.find("accountSelected").get("v.value") )
                                    ||
                                (component.find("accountSelected").get("v.value")!="--Select All--"
                                        && component.find("sinPopulated").get("v.value")!="--Select All--"
                                        && (myRecord.acctNum!=component.find("accountSelected").get("v.value") 
                                            || myRecord.svcNum!=component.find("sinPopulated").get("v.value") )  )
                            )
                                && !(component.find("accountSelected").get("v.value")=="--Select All--" 
                                        && component.find("sinPopulated").get("v.value")=="--Select All--") ){
                            continue;
                        }*/ //END CSM-14404
                        //END CSM-12924 GGrandea 09.28.2017

                        //START CSM-12321 RReyes AUG-29 - changed from bill_type to bill_type_filter and bill_status to payStatus
                        if(typeFilter == 'All' || (typeFilter == 'Service' && myRecord.billType == 'Service') || (typeFilter == 'Others' && myRecord.billType != 'Service')){
                            if((statusFilter == 'All' && myRecord.payStatus != 'Cancelled') || (statusFilter == 'Unpaid' && myRecord.payStatus == 'Unpaid') || (statusFilter == 'Paid' && myRecord.payStatus == 'Paid')){
                        //END CSM-12321 RReyes AUG-29 - changed from bill_type to bill_type_filter and bill_status to payStatus
                                myRecord.isAcctSel = 'true';//CSM-14404

                                // Pull out the field that's going to be my key
                                var myKey = myRecord.acctNum;
                                // Keep track of whether our key already exists in myObjectMap
                                var found = false;
                                // Loop through our map and see if an entry for our key exists
                                /*for(var x=0; x<myObjectMap.length; x++) { //START CSM-14404
                                    // Look to see if our object has a "key" value
                                    // and whether that key is equal to the key we want
                                    // to use to group everything
                                    if("key" in myObjectMap[x] && myObjectMap[x]["key"] == myKey) {

                                        myObjectMap[x]["listBills"].push(myRecord);
                                        // We found our key and pushed the record into its
                                        // list, no need to continue
                                        found = true;
                                        break;
                                    }
                                }*/ //END CSM-14404
                                // Need to make sure this record found a home; if it didn't
                                // then we need to initialize it in our "map"
                                /*if(!found) { //CSM-14404
                                    var temp = { "key": myKey, "listBills": [myRecord] };
                                    myObjectMap.push(temp);
                                }*/ //CSM-14404

                                if(accountList != null && accountList.indexOf(myRecord.acctNum) <= -1){
                                    accountList.push(myRecord.acctNum);
                                }

                                if(myRecord.isSINOff != 'true'){
                                    if(serviceList != null && serviceList.indexOf(myRecord.svcNum) <= -1){
                                        serviceList.push(myRecord.svcNum);
                                    }
                                    if(idList != null && idList.indexOf(myRecord.id) <= -1){
                                        idList.push(myRecord.id);
                                    }
                                    myRecord.isSINSel = 'true';
                                    totalSINSSelectable++;
                                }

                                if(myRecord.penAmt != null && myRecord.payStatus == 'Unpaid'){
                                   totalCurrentAmt = totalCurrentAmt + parseFloat(myRecord.penAmt);
                                }
                            }
                        }
                    }
                    
                    //disable account checkbox if SIN is 1 and SIN is disabled
                    for(var a=0; a<myObjectMap.length; a++){
                        if(myObjectMap[a]["listBills"].length == 1){
                            if(myObjectMap[a]["listBills"][0].isSINOff == 'true'){
                                myObjectMap[a]["listBills"][0].isAcctOff = 'true';
                                myObjectMap[a]["listBills"][0].isAcctSel = 'false';
                                if(accountList != null && accountList.indexOf(myObjectMap[a]["listBills"][0].acctNum) > -1){
                                    accountList.splice(0, 1);
                                }
                            }
                        }
                    }

                    //START CSM-14404
                    //get maximum selectable SINs per account
                    //Check Disabled Accounts
                    var disabledAccts = [];

                    for(var a=0; a < myObjectMap.length; a++){
                        var acctNum = myObjectMap[a]["key"];
                        //var maximumSelectable = 0;
                	var isSelectable = false;
                        
                        for(var s=0; s < myObjectMap[a]["listBills"].length; s++){
                            //if(myObjectMap[a]["listBills"][s].acctNum == acctNum){
                                if(myObjectMap[a]["listBills"][s].isSINOff == 'false'){
                                    //maximumSelectable++;
                                    isSelectable = true;
                                    break;
                                }
                            //}
                        }
                        //console.log('maximumSelectable: ' + maximumSelectable); //CSM-14070
                        
                        //if(maximumSelectable == 0){
                        if(!isSelectable){
                            if(disabledAccts != null && disabledAccts.indexOf(acctNum) <= -1){
                                disabledAccts.push(acctNum);
                            }
                        }
                    }
                    //console.log('disabledAccts: ' + disabledAccts);
                    //END CSM-14404

                    //START CSM-12645 RReyes
                    var accountsWithSingleSelect = [];
                    var accountsWithDisabled = [];
                    var accountsWithSingleSINAllSelected = [];

                    for(var a=0; a < myObjectMap.length; a++){
                        var acctNum = myObjectMap[a]["key"];
                        var selectedSIN = 0;
                        var totalSelectableSIN = 0;
                        var totalSINVisible = 0;
                        console.log('>>rreyes NEW: ' + a + ' | acctNum: ' + acctNum);
                        for(var s=0; s < myObjectMap[a]["listBills"].length; s++){
                            var disAcctIndex = disabledAccts.indexOf(myObjectMap[a]["listBills"][0].acctNum);
                            //console.log('acctNum: ' + acctNum);
                            //console.log('disabledAccts: ' + disabledAccts);
                            //console.log('disAcctIndex: ' + disAcctIndex);
                            //console.log('-----');
                            //no selectable SIN
                            if(disabledAccts != null && disAcctIndex > -1){
                                myObjectMap[a]["listBills"][s].isAcctSel = 'false';
                                myObjectMap[a]["listBills"][s].isAcctOff = 'true';
                                var acctIndex = accountList.indexOf(myObjectMap[a]["listBills"][0].acctNum);
                                if(accountList != null && acctIndex > -1){
                                    accountList.splice(acctIndex, 1);
                                }

                                if(accountsWithDisabled != null && accountsWithDisabled.indexOf(acctNum) <= -1){
                                    accountsWithDisabled.push(acctNum);
                                }
                            }else{
                                 myObjectMap[a]["listBills"][s].isAcctSel = 'true';
                                 myObjectMap[a]["listBills"][s].isAcctOff = 'false';

                                 //check if SIN is disabled - add account to accountsWithDisabled
                                 if(myObjectMap[a]["listBills"][s].isSINOff == 'true'){
                                    if(accountsWithDisabled != null && accountsWithDisabled.indexOf(acctNum) <= -1){
                                        accountsWithDisabled.push(acctNum);
                                    }
                                 }

                                 //Count selected SINs per accountt
                                 if(myObjectMap[a]["listBills"][s].isSINSel == 'true'){
                                    selectedSIN++;
                                 }
                            }
                            //count total selectable SIN per account
                            if(myObjectMap[a]["listBills"][s].isSINOff == 'false'){
                                totalSelectableSIN++;
                            }
                        }
                        if(selectedSIN == 1){
                            if(accountsWithSingleSelect != null && accountsWithSingleSelect.indexOf(acctNum) <= -1){
                                accountsWithSingleSelect.push(acctNum);
                            }

                            //if only 1 sin is selectable
                            if(myObjectMap[a]["listBills"].length == 1){
                                if(accountsWithSingleSINAllSelected != null && accountsWithSingleSINAllSelected.indexOf(acctNum) <= -1){
                                    accountsWithSingleSINAllSelected.push(acctNum);
                                }
                            }
                        }
                        console.log('>>rreyes NEW: ' + s + ' | accountsWithDisabled: ' + accountsWithDisabled);
                        console.log('>>rreyes NEW: ' + s + ' | selectedSIN: ' + selectedSIN);
                        console.log('>>rreyes NEW: ' + s + ' | totalSelectableSIN: ' + totalSelectableSIN);
                        console.log('>>rreyes NEW: ' + s + ' | totalSINVisible: ' + myObjectMap[a]["listBills"].length);
                        
                    }

                    console.log('>>rreyes NEW: | accountsWithDisabled : ' + accountsWithDisabled);
                    console.log('>>rreyes NEW: | accountsWithSingleSelect : ' + accountsWithSingleSelect);
                    console.log('>>rreyes NEW: | accountsWithSingleSINAllSelected : ' + accountsWithSingleSINAllSelected);
                    console.log('>>rreyes NEW: | myObjectMap : BEFORE: ' + JSON.stringify(myObjectMap));
                    myObjectMap = this.updateDetailsOnFilteredMap(component, myObjectMap, accountsWithDisabled, accountsWithSingleSelect, accountsWithSingleSINAllSelected);
                    var acctWithSINAllEnrolled = component.get("v.accountsWithSINsAllEnrolled");
                    //alert(JSON.stringify(myObjectMap));
                    console.log('>>rreyes NEW: | myObjectMap : AFTER: ' + JSON.stringify(myObjectMap));
                    //END CSM-12645 RReyes

                    //compute subtotal
                    for(var a=0; a<myObjectMap.length; a++){
                        var subTotal = this.computeAccountSubtotal(myObjectMap, myObjectMap[a]["key"]);
                        this.setAccountSubtotal(myObjectMap, myObjectMap[a]["key"], subTotal);
                        totalOfSubTotals += subTotal;
                        //START CSM-12645 RReyes SEP-26-17 - added variables
                        var acctNum = myObjectMap[a]["key"];
                        var accountHasDisabled = false;
                        var isSingleSINSelected = false;
                        var isSingleSINAllSelected = false;
                        var isAllSINSEnrolled = false;
                        var isAccountSelected = 'false';

                        if(accountsWithDisabled != null){
                            var i = accountsWithDisabled.indexOf(acctNum);
                            if(i >= 0){
                                accountHasDisabled = true;
                            }
                        }
                        
                        if(accountsWithSingleSelect != null){
                            var i = accountsWithSingleSelect.indexOf(acctNum);
                            if(i >= 0){
                                isSingleSINSelected = true;
                            }
                        }

                        if(accountsWithSingleSINAllSelected != null){
                            var i = accountsWithSingleSINAllSelected.indexOf(acctNum);
                            if(i >= 0){
                                isSingleSINAllSelected = true;
                            }
                        }

                        if(acctWithSINAllEnrolled != null){
                            var i = acctWithSINAllEnrolled.indexOf(acctNum);
                            if(i >= 0){
                                isAllSINSEnrolled = true;
                            }
                        }

                        if(accountList != null){
                            var i = accountList.indexOf(acctNum);
                            if(i >= 0){
                                isAccountSelected = 'true';
                            }
                        }
                        var isDisabled = true;
                        
                        if((isAccountSelected == 'true' && accountHasDisabled == false && isAllSINSEnrolled == true) 
                            || isSingleSINSelected == true || isSingleSINAllSelected == true){
                            isDisabled = false;
                        }
                        //END CSM-12645 RReyes SEP-26-17 - added variables
                        var myKey = myObjectMap[a]["key"];
                        var record = myObjectMap[a]["listBills"][0];//START/END CSM-12705 RReyes OCT-26-17 
                        var found = false;
                        for(var x=0; x<subTotalMap.length; x++) {
                            if("key" in subTotalMap[x] && subTotalMap[x]["key"] == myKey) {
                                found = true;
                                //START CSM-12645 RReyes SEP-26-17 - added variables
                                subTotalMap[x]["prevSubtotal"] =  subTotal;
                                subTotalMap[x]["accountHasDisabled"] =  accountHasDisabled;
                                subTotalMap[x]["isSingleSINSelected"] =  isSingleSINSelected;
                                subTotalMap[x]["isSingleSINAllSelected"] =  isSingleSINAllSelected;
                                subTotalMap[x]["isAllSINSEnrolled"] =  isAllSINSEnrolled;
                                subTotalMap[x]["isAccountSelected"] =  isAccountSelected;
                                subTotalMap[x]["isDisabled"] =  isDisabled;
                                subTotalMap[x]["contractExternalId"] =  record.contractExternalId;//START/END CSM-12705 RReyes OCT-26-17 
                                //END CSM-12645 RReyes SEP-26-17 - added variables
                                break;
                            }
                        }

                        if(!found) {
                            //START CSM-12645 RReyes SEP-26-17 - added variables
                            //START CSM-12705 RReyes OCT-26-17 
                            var temp = { "key": myKey, "subtotal": subTotal, "prevSubtotal": subTotal, "accountHasDisabled": accountHasDisabled, 
                                        "isSingleSINSelected": isSingleSINSelected, "isSingleSINAllSelected": isSingleSINAllSelected,
                                        "isAllSINSEnrolled": isAllSINSEnrolled, "isAccountSelected": isAccountSelected, "isDisabled": isDisabled,
                                        "contractExternalId": record.contractExternalId}; 
                            //END CSM-12705 RReyes OCT-26-17 
                            //END CSM-12645 RReyes SEP-26-17 - added variables
                            subTotalMap.push(temp);
                        }
                    }
                    //console.log('subtotalMap: ' + JSON.stringify(subTotalMap));

                    if(totalSINSSelectable > 0){
                        component.set("v.markAll", true);
                        component.set("v.isMarkAllDisabled", false);
                    }else{
                        component.set("v.markAll", false);
                        component.set("v.isMarkAllDisabled", true);
                    }

                	//Emandolado CSM-12619
                	 var totalChecker = 0;
                     component.set("v.isAdvancable", false);
                	 for(var a=0; a<myObjectMap.length; a++){
                        var subTotal = this.computeAccountSubtotal(myObjectMap, myObjectMap[a]["key"]);
                        this.setAccountSubtotal(myObjectMap, myObjectMap[a]["key"], subTotal);
                         totalChecker += subTotal;
                    }
                
                    if(totalChecker == 0){
                        //alert('here');
                        component.set("v.isAdvancable", true);
                    }  
                	//Emandolado CSM-12619	
                
                    component.set("v.filteredBillingSummary", myObjectMap);
                    component.set("v.subTotalMap", subTotalMap);
                    component.set("v.selectedAccounts", accountList);
                    component.set("v.selectedServices", serviceList);
                    component.set("v.selectedIds", idList);
                    component.set("v.enabledSINs", totalSINSSelectable);
                    component.set("v.selectedSINs", idList.length);
                    component.set("v.totalAmountToPay", totalOfSubTotals);
                    component.set("v.totalCurrentAmount", totalCurrentAmt);
                    //this.sortByAccount(component, event); //test only
                    //this.sortByBilledAmount(component, event); //test only

                    //sort by most recent
                    component.set("v.endOfBillingSortMode", 'asc');
                    //this.sortByAccount(component, event); //CSM-14404
                    //this.sortByEndOfBillingPeriod(component, event); //CSM-14404
                    /*
                    console.log('Selected ACCOUNTS: ' + component.get("v.selectedAccounts"));
                    console.log('Selected SINS: ' + component.get("v.selectedServices"));
                    console.log('Selected IDs: ' + component.get("v.selectedIds"));
                    console.log('No. of VISIBLE Ids: ' + component.get("v.visibleSINs"));
                    console.log('No. of SELECTABLE Ids: ' + component.get("v.enabledSINs"));
                    console.log('No. of SELECTED Ids: ' + component.get("v.selectedSINs"));
                    console.log('filteredBillingSummary: ' + JSON.stringify(component.get("v.filteredBillingSummary")));
                    console.log('generate: subtotalMap: ' + JSON.stringify(component.get("v.subTotalMap")));
                    */
                        
                }

                this.hide_spinner(component); //CSM-14070 GGrandea 10.24.2017

            }
        });  
        $A.enqueueAction(action);
    },
    
    setAccountDetails : function(component, event, myObjectMap) {
      //START CSM-12645 RReyes
      var accountsWithSingleSelect = [];
      var accountsWithSingleSINAllSelected = [];
      var accountsWithDisabled = [];

      for(var a=0; a < myObjectMap.length; a++){
          var acctNum = myObjectMap[a]["key"];
          var selectedSIN = 0;
          var totalSelectableSIN = 0;
          var totalSINVisible = 0;
          console.log('>>rreyes NEW: ' + a + ' | acctNum: ' + acctNum);
          for(var s=0; s < myObjectMap[a]["listBills"].length; s++){
              //check if SIN is disabled - add account to accountsWithDisabled
               if(myObjectMap[a]["listBills"][s].isSINOff == 'true'){
                  if(accountsWithDisabled != null && accountsWithDisabled.indexOf(acctNum) <= -1){
                      accountsWithDisabled.push(acctNum);
                  }
               }

               //Count selected SINs per accountt
               if(myObjectMap[a]["listBills"][s].isSINSel == 'true'){
                  selectedSIN++;
               }

              //count total selectable SIN per account
              if(myObjectMap[a]["listBills"][s].isSINOff == 'false'){
                  totalSelectableSIN++;
              }
          }

          if(selectedSIN == 1){
              if(accountsWithSingleSelect != null && accountsWithSingleSelect.indexOf(acctNum) <= -1){
                  accountsWithSingleSelect.push(acctNum);
              }

              //if only 1 sin is selectable
              if(myObjectMap[a]["listBills"].length == 1){
                  if(accountsWithSingleSINAllSelected != null && accountsWithSingleSINAllSelected.indexOf(acctNum) <= -1){
                      accountsWithSingleSINAllSelected.push(acctNum);
                  }
              }
          }

          console.log('>>rreyes NEW: ' + s + ' | accountsWithDisabled: ' + accountsWithDisabled);
          console.log('>>rreyes NEW: ' + s + ' | selectedSIN: ' + selectedSIN);
          console.log('>>rreyes NEW: ' + s + ' | totalSelectableSIN: ' + totalSelectableSIN);
          console.log('>>rreyes NEW: ' + s + ' | totalSINVisible: ' + myObjectMap[a]["listBills"].length); 
      }
      console.log('>>rreyes NEW: | accountsWithDisabled : ' + accountsWithDisabled);
      console.log('>>rreyes NEW: | accountsWithSingleSelect : ' + accountsWithSingleSelect);
      console.log('>>rreyes NEW: | accountsWithSingleSINAllSelected : ' + accountsWithSingleSINAllSelected);
      //END CSM-12645 RReyes
      return this.updateDetailsOnFilteredMap(component, myObjectMap, accountsWithDisabled, accountsWithSingleSelect, accountsWithSingleSINAllSelected);
    }, 

    updateDetailsOnFilteredMap : function(component, myObjectMap, accountsWithDisabled, accountsWithSingleSelect, accountsWithSingleSINAllSelected) {
        var acctWithSINAllEnrolled = component.get("v.accountsWithSINsAllEnrolled");
        for(var a=0; a < myObjectMap.length; a++){
            var acctNum = myObjectMap[a]["key"];
            for(var s=0; s < myObjectMap[a]["listBills"].length; s++){
                if(accountsWithDisabled != null && accountsWithDisabled.indexOf(acctNum) >= 0){
                    myObjectMap[a]["listBills"][s].hasDisabledSIN = true;
                }else{
                    myObjectMap[a]["listBills"][s].hasDisabledSIN = false;
                }

                if(accountsWithSingleSelect != null && accountsWithSingleSelect.indexOf(acctNum) >= 0){
                    myObjectMap[a]["listBills"][s].isSingleSINSelected = true;
                }else{
                    myObjectMap[a]["listBills"][s].isSingleSINSelected = false;
                }

                if(accountsWithSingleSINAllSelected != null && accountsWithSingleSINAllSelected.indexOf(acctNum) >= 0){
                    myObjectMap[a]["listBills"][s].isSingleSINSelectAll = true;
                }else{
                    myObjectMap[a]["listBills"][s].isSingleSINSelectAll = false;
                }

                if(acctWithSINAllEnrolled != null && acctWithSINAllEnrolled.indexOf(acctNum) >= 0){
                    myObjectMap[a]["listBills"][s].allSINsEnrolled = true;
                }else{
                    myObjectMap[a]["listBills"][s].allSINsEnrolled = false;
                }
            }
        }
        //alert(JSON.stringify(myObjectMap));
        return myObjectMap;
    },

    updateAllSelected : function(component, event) {
        var isChecked = event.target.checked;
        var result = component.get("v.filteredBillingSummary");
        var acctList = component.get("v.selectedAccounts");
        var serviceList = component.get("v.selectedServices");
        var idList = component.get("v.selectedIds");
        var totalOfSubTotals = 0.0;
        var subTotalMap = []; //add

        for(var a=0; a<result.length; a++){
            for(var s=0; s<result[a]["listBills"].length; s++){
                if(isChecked){
                    if(result[a]["listBills"][s].isAcctOff != 'true'){
                        result[a]["listBills"][s].isAcctSel = 'true';
                        if(acctList != null && acctList.indexOf(result[a]["listBills"][s].acctNum) == -1){
                                acctList.push(result[a]["listBills"][s].acctNum);
                        }
                    }
                    
                    if(result[a]["listBills"][s].isSINOff != 'true'){
                        result[a]["listBills"][s].isSINSel = 'true';
                        if(serviceList != null && serviceList.indexOf(result[a]["listBills"][s].svcNum) == -1){
                            serviceList.push(result[a]["listBills"][s].svcNum);
                        }
                        if(idList != null && idList.indexOf(result[a]["listBills"][s].id) == -1){
                            idList.push(result[a]["listBills"][s].id);
                        }
                    }
                }else{
                    result[a]["listBills"][s].isSINSel = 'false';
                    result[a]["listBills"][s].isAcctSel = 'false';
                    acctList = [];
                    serviceList = [];
                    idList = [];
                }
            }
        }

        //START CSM-12645 RReyes SEP-22-17
        result = this.setAccountDetails(component, event, result);
        //END CSM-12645 RReyes SEP-22-17

        if(isChecked){
            //compute subtotal
            for(var a=0; a<result.length; a++){
                var subTotal = this.computeAccountSubtotal(result, result[a]["key"]);
                this.setAccountSubtotal(result, result[a]["key"], subTotal);
                totalOfSubTotals += subTotal;

                var myKey = result[a]["key"];
                var found = false;
                //START CSM-12645 RReyes SEP-26-17 - change subtotalMap
                var record = result[a]["listBills"][0];
                console.log('record: ' + a + ': ' + JSON.stringify(record));
                var isDisabled = true;
                
                if((record.isAcctSel == 'true' && record.hasDisabledSIN == false && record.allSINsEnrolled == true) 
                    || record.isSingleSINSelected == true || record.isSingleSINSelectAll == true){
                    isDisabled = false;
                }
                //END CSM-12645 RReyes SEP-26-17 - change subtotalMap
                for(var x=0; x<subTotalMap.length; x++) {
                    if("key" in subTotalMap[x] && subTotalMap[x]["key"] == myKey) {
                        found = true;
                        //START CSM-12645 RReyes SEP-26-17
                        subTotalMap[x]["prevSubtotal"] =  subTotal;
                        subTotalMap[x]["accountHasDisabled"] =  record.hasDisabledSIN;
                        subTotalMap[x]["isSingleSINSelected"] =  record.isSingleSINSelected;
                        subTotalMap[x]["isSingleSINAllSelected"] =  record.isSingleSINSelectAll;
                        subTotalMap[x]["isAllSINSEnrolled"] =  record.allSINsEnrolled;
                        subTotalMap[x]["isAccountSelected"] =  record.isAcctSel;
                        subTotalMap[x]["isDisabled"] =  isDisabled;
                        subTotalMap[x]["contractExternalId"] =  record.contractExternalId;//START/END CSM-12705 RReyes OCT-26-17 
                        //END CSM-12645 RReyes SEP-26-17
                        break;
                    }
                }

                if(!found) {
                    //START CSM-12645 RReyes SEP-26-17 - added variables
                    //START CSM-12705 RReyes OCT-26-17 
                    var temp = { "key": myKey, "subtotal": subTotal,"prevSubtotal": subTotal, "accountHasDisabled": record.hasDisabledSIN, 
                    "isSingleSINSelected": record.isSingleSINSelected, "isSingleSINAllSelected": record.isSingleSINSelectAll,
                    "isAllSINSEnrolled": record.allSINsEnrolled, "isAccountSelected": record.isAcctSel, "isDisabled":isDisabled,
                    "contractExternalId": record.contractExternalId};
                    //END CSM-12705 RReyes OCT-26-17
                    //END CSM-12645 RReyes SEP-26-17 - added variables 
                    subTotalMap.push(temp);
                }
            }
        }else{
            for(var a=0; a<result.length; a++){
                this.setAccountSubtotal(result, result[a]["key"], 0.0);

                var myKey = result[a]["key"];
                var found = false;
                //START CSM-12645 RReyes SEP-26-17 - change subtotalMap
                var record = result[a]["listBills"][0];
                console.log('record: ' + a + ': ' + JSON.stringify(record));
                var isDisabled = true;
                
                if((record.isAcctSel == 'true' && record.hasDisabledSIN == false && record.allSINsEnrolled == true) 
                    || record.isSingleSINSelected == true || record.isSingleSINSelectAll == true){
                    isDisabled = false;
                }
                //END CSM-12645 RReyes SEP-26-17 - change subtotalMap
                for(var x=0; x<subTotalMap.length; x++) {
                    if("key" in subTotalMap[x] && subTotalMap[x]["key"] == myKey) {
                        found = true;
                        //START CSM-12645 RReyes SEP-26-17
                        subTotalMap[x]["prevSubtotal"] =  0.0;
                        subTotalMap[x]["accountHasDisabled"] =  record.hasDisabledSIN;
                        subTotalMap[x]["isSingleSINSelected"] =  record.isSingleSINSelected;
                        subTotalMap[x]["isSingleSINAllSelected"] =  record.isSingleSINSelectAll;
                        subTotalMap[x]["isAllSINSEnrolled"] =  record.allSINsEnrolled;
                        subTotalMap[x]["isAccountSelected"] =  record.isAcctSel;
                        subTotalMap[x]["isDisabled"] =  record.isDisabled;
                        subTotalMap[x]["contractExternalId"] =  record.contractExternalId;//START/END CSM-12705 RReyes OCT-26-17 
                        //END CSM-12645 RReyes SEP-26-17
                        break;
                    }
                }

                if(!found){
                    //START CSM-12645 RReyes SEP-26-17 - added variables
                    //START CSM-12705 RReyes OCT-26-17 
                    var temp = { "key": myKey, "subtotal": 0.0, "prevSubtotal": 0.0, "accountHasDisabled": record.hasDisabledSIN, 
                    "isSingleSINSelected": record.isSingleSINSelected, "isSingleSINAllSelected": record.isSingleSINSelectAll,
                    "isAllSINSEnrolled": record.allSINsEnrolled, "isAccountSelected": record.isAcctSel, "isDisabled": isDisabled,
                    "contractExternalId": record.contractExternalId };
                    //END CSM-12705 RReyes OCT-26-17 
                    //END CSM-12645 RReyes SEP-26-17 - added variables
                    subTotalMap.push(temp);
                }
            }
        }

        component.set("v.subTotalMap", subTotalMap);
        component.set("v.totalAmountToPay", totalOfSubTotals);
        component.set("v.markAll", isChecked);
        component.set("v.filteredBillingSummary", result);
        component.set("v.selectedAccounts", acctList);
        component.set("v.selectedServices", serviceList);
        component.set("v.selectedIds", idList);
        component.set("v.selectedSINs", idList.length);
        //console.log('subTotalMap: from mark all ' + JSON.stringify(component.get("v.subTotalMap"))); //CSM-14070
        /*
        console.log('Selected ACCOUNTS: ' + component.get("v.selectedAccounts"));
        console.log('Selected SINS: ' + component.get("v.selectedServices"));
        console.log('Selected IDs: ' + component.get("v.selectedIds"));
        console.log('No. of VISIBLE Ids: ' + component.get("v.visibleSINs"));
        console.log('No. of SELECTABLE Ids: ' + component.get("v.enabledSINs"));
        console.log('No. of SELECTED Ids: ' + component.get("v.selectedSINs"));
        */
    },
    
    updateAccountSelection: function (component, event, helper){
        var acctNum = event.target.value;
        var isChecked = event.target.checked;
        var billSums = component.get("v.filteredBillingSummary");
        var acctList = component.get("v.selectedAccounts");
        var serviceList = component.get("v.selectedServices");
        var idList = component.get("v.selectedIds");
        var totalOfSubTotals = component.get("v.totalAmountToPay");
        var subTotalMap = component.get("v.subTotalMap");
        //console.log('subTotalMap BEFORE: '+ JSON.stringify(component.get("v.subTotalMap"))); //add //CSM-14070

        if(!isChecked){
            component.set("v.markAll", false);
        }
        
        for(var a=0; a < billSums.length; a++){
            if(billSums[a]["key"] == acctNum){
                for(var s=0; s < billSums[a]["listBills"].length; s++){
                    if(billSums[a]["listBills"][s].isAcctOff != 'true'){
                        if(isChecked){
                           billSums[a]["listBills"][s].isAcctSel = 'true';
                           if(billSums[a]["listBills"][s].isSINOff != 'true'){
                               billSums[a]["listBills"][s].isSINSel = 'true';
                               if(serviceList != null && serviceList.indexOf(billSums[a]["listBills"][s].svcNum) <= -1){
                                    serviceList.push(billSums[a]["listBills"][s].svcNum);
                               }
                               if(idList != null && idList.indexOf(billSums[a]["listBills"][s].id) <= -1){
                                    idList.push(billSums[a]["listBills"][s].id);
                               }
                               if(acctList != null && acctList.indexOf(billSums[a]["listBills"][s].acctNum) <= -1){
                                acctList.push(billSums[a]["listBills"][s].acctNum);
                               }
                           }
                       }else{
                           billSums[a]["listBills"][s].isSINSel = 'false';
                           billSums[a]["listBills"][s].isAcctSel = 'false';
                           
                           var indexServ = serviceList.indexOf(billSums[a]["listBills"][s].svcNum);
                           if (indexServ > -1) {
                                serviceList.splice(indexServ, 1);
                           }

                           var indexId = idList.indexOf(billSums[a]["listBills"][s].id);
                           if (indexId > -1) {
                                idList.splice(indexId, 1);
                           }
                           
                           var indexAcct = acctList.indexOf(billSums[a]["listBills"][s].acctNum);
                           if (indexAcct > -1) {
                                acctList.splice(indexAcct, 1);
                           }
                       }
                    }
                }               
            }
        }
        
        var selectableSINs = component.get("v.enabledSINs");
        if(idList.length > 0 && (idList.length == selectableSINs)){
            component.set("v.markAll", true);
        }

        //START CSM-12645 RReyes SEP-22-17
        billSums = this.setAccountDetails(component, event, billSums);
        //END CSM-12645 RReyes SEP-22-17

        if(isChecked){
            //compute subtotal
            for(var a=0; a<billSums.length; a++){
                if(billSums[a]["key"] == acctNum){
                    var subTotal = this.computeAccountSubtotal(billSums, billSums[a]["key"]);
                    this.setAccountSubtotal(billSums, billSums[a]["key"], subTotal);
                    totalOfSubTotals += subTotal;

                    var myKey = billSums[a]["key"];
                    var found = false;
                    //START CSM-12645 RReyes SEP-26-17 - change subtotalMap
                    var record = billSums[a]["listBills"][0];
                    console.log('record: ' + a + ': ' + JSON.stringify(record));
                    var isDisabled = true;
                    if((record.isAcctSel == 'true' && record.hasDisabledSIN == false && record.allSINsEnrolled == true) 
                        || record.isSingleSINSelected == true || record.isSingleSINSelectAll == true){
                        isDisabled = false;
                    }
                    //END CSM-12645 RReyes SEP-26-17 - change subtotalMap
                    for(var x=0; x<subTotalMap.length; x++) {
                        if("key" in subTotalMap[x] && subTotalMap[x]["key"] == myKey) {
                            subTotalMap[x]["subtotal"] = subTotal;
                            //START CSM-12645 RReyes SEP-26-17
                            subTotalMap[x]["prevSubtotal"] =  subTotal;
                            subTotalMap[x]["accountHasDisabled"] =  record.hasDisabledSIN;
                            subTotalMap[x]["isSingleSINSelected"] =  record.isSingleSINSelected;
                            subTotalMap[x]["isSingleSINAllSelected"] =  record.isSingleSINSelectAll;
                            subTotalMap[x]["isAllSINSEnrolled"] =  record.allSINsEnrolled;
                            subTotalMap[x]["isAccountSelected"] =  record.isAcctSel;
                            subTotalMap[x]["isDisabled"] =  isDisabled;
                            subTotalMap[x]["contractExternalId"] =  record.contractExternalId;//START/END CSM-12705 RReyes OCT-26-17 
                            //END CSM-12645 RReyes SEP-26-17
                            found = true;
                            break;
                        }
                    }

                    if(!found) {
                        //START CSM-12645 RReyes SEP-26-17 - added variables
                        //START CSM-12705 RReyes OCT-26-17 
                        var temp = { "key": myKey, "subtotal": subTotal,"prevSubtotal": subTotal, "accountHasDisabled": record.hasDisabledSIN, 
                        "isSingleSINSelected": record.isSingleSINSelected, "isSingleSINAllSelected": record.isSingleSINSelectAll,
                        "isAllSINSEnrolled": record.allSINsEnrolled, "isAccountSelected": record.isAcctSel, "isDisabled": isDisabled,
                        "contractExternalId": record.contractExternalId};
                        //END CSM-12705 RReyes OCT-26-17 
                        //END CSM-12645 RReyes SEP-26-17 - added variables
                        subTotalMap.push(temp);
                    }
                }
            }
        }else{
            for(var a=0; a<billSums.length; a++){
                if(billSums[a]["key"] == acctNum){
                    totalOfSubTotals = totalOfSubTotals - parseFloat(billSums[a]["listBills"][0].subTotal);
                    this.setAccountSubtotal(billSums, billSums[a]["key"], 0.0);

                    var myKey = billSums[a]["key"];
                    var found = false;
                    //START CSM-12645 RReyes SEP-26-17 - change subtotalMap
                    var record = billSums[a]["listBills"][0];
                    console.log('record: ' + a + ': ' + JSON.stringify(record));
                    var isDisabled = true;
                    if((record.isAcctSel == 'true' && record.hasDisabledSIN == false && record.allSINsEnrolled == true) 
                        || record.isSingleSINSelected == true || record.isSingleSINSelectAll == true){
                        isDisabled = false;
                    }
                    //END CSM-12645 RReyes SEP-26-17 - change subtotalMap
                    for(var x=0; x<subTotalMap.length; x++) {
                        if("key" in subTotalMap[x] && subTotalMap[x]["key"] == myKey) {
                            subTotalMap[x]["subtotal"] = 0.0;
                            found = true;
                            //START CSM-12645 RReyes SEP-26-17
                            subTotalMap[x]["prevSubtotal"] =  0.0;
                            subTotalMap[x]["accountHasDisabled"] =  record.hasDisabledSIN;
                            subTotalMap[x]["isSingleSINSelected"] =  record.isSingleSINSelected;
                            subTotalMap[x]["isSingleSINAllSelected"] =  record.isSingleSINSelectAll;
                            subTotalMap[x]["isAllSINSEnrolled"] =  record.allSINsEnrolled;
                            subTotalMap[x]["isAccountSelected"] =  record.isAcctSel;
                            subTotalMap[x]["isDisabled"] =  isDisabled;
                            subTotalMap[x]["contractExternalId"] =  record.contractExternalId;//START/END CSM-12705 RReyes OCT-26-17 
                            //END CSM-12645 RReyes SEP-26-17
                            break;
                        }
                    }

                    if(!found) {
                        //START CSM-12645 RReyes SEP-26-17 - added variables
                        //START CSM-12705 RReyes OCT-26-17 
                        var temp = { "key": myKey, "subtotal": 0.0, "prevSubtotal": 0.0, "accountHasDisabled": record.hasDisabledSIN, 
                        "isSingleSINSelected": record.isSingleSINSelected, "isSingleSINAllSelected": record.isSingleSINSelectAll,
                        "isAllSINSEnrolled": record.allSINsEnrolled,"isAccountSelected": record.isAcctSel, "isDisabled": isDisabled,
                        "contractExternalId": record.contractExternalId };
                        //END CSM-12705 RReyes OCT-26-17 
                        //END CSM-12645 RReyes SEP-26-17 - added variables
                        subTotalMap.push(temp);
                    }
                }
            }
        }
        //console.log('account: subtotalMap: ' + JSON.stringify(subTotalMap)); //CSM-14070
        component.set("v.subTotalMap", subTotalMap);
        component.set("v.totalAmountToPay", totalOfSubTotals);
        component.set("v.filteredBillingSummary", billSums);
        component.set("v.selectedAccounts", acctList);
        component.set("v.selectedServices", serviceList);
        component.set("v.selectedIds", idList);
        component.set("v.selectedSINs", idList.length);
        this.computeTotal(component, subTotalMap);
        /*
        console.log('Selected ACCOUNTS: ' + component.get("v.selectedAccounts"));
        console.log('Selected SINS: ' + component.get("v.selectedServices"));
        console.log('Selected IDs: ' + component.get("v.selectedIds"));
        console.log('No. of VISIBLE Ids: ' + component.get("v.visibleSINs"));
        console.log('No. of SELECTABLE Ids: ' + component.get("v.enabledSINs"));
        console.log('No. of SELECTED Ids: ' + component.get("v.selectedSINs"));
        */
    },
    
    updateServiceSelection : function (component, event, helper){
        var sin = event.target.value;
        var id = event.target.id;
        var isChecked = event.target.checked;
        var billSums = component.get("v.filteredBillingSummary");
        var serviceList = component.get("v.selectedServices");
        var acctList = component.get("v.selectedAccounts");
        var idList = component.get("v.selectedIds");
        var totalOfSubTotals = component.get("v.totalAmountToPay");
        var subTotalMap = component.get("v.subTotalMap");

        var parentAccount = this.getParentAccountNum(billSums, id);
        var maximumSelection = this.getMaximumSelected(billSums, parentAccount);
        var totalSINSelected = 0;
        
        var billSumToSet;
        var currentSubtotal = 0.0;
        var amountDue = 0.0; 
        var newSubTotal = 0.0; 
        
        if(!isChecked){
            component.set("v.markAll", false);
        }
        
        for(var a=0; a < billSums.length; a++){
            for(var s=0; s < billSums[a]["listBills"].length; s++){
                if(billSums[a]["listBills"][s].id == id){
                    if(isChecked){
                        if(serviceList != null && serviceList.indexOf(sin) <= -1){
                            serviceList.push(sin);
                        } 
                        if(idList != null && idList.indexOf(id) <= -1){
                            idList.push(id);
                        } 
                        billSums[a]["listBills"][s].isSINSel = 'true';
                    }else{
                       var indexServ = serviceList.indexOf(sin);
                       if (indexServ > -1) {
                           serviceList.splice(indexServ, 1);
                       }
                       var indexId = idList.indexOf(id);
                       if (indexId > -1) {
                           idList.splice(indexId, 1);
                       }
                       billSums[a]["listBills"][s].isSINSel = 'false';
                    }
                    //console.log('subtotal: ' + billSums[a]["listBills"][s].subTotal); //CSM-14070
                    if(billSums[a]["listBills"][s].subTotal != null){
                        currentSubtotal = parseFloat(billSums[a]["listBills"][s].subTotal);
                    }

                    if(billSums[a]["listBills"][s].penAmt != null){
                        amountDue = parseFloat(billSums[a]["listBills"][s].penAmt);
                    }
                }

                if(billSums[a]["listBills"][s].acctNum == parentAccount){
                    if(billSums[a]["listBills"][s].isSINSel == 'true'){
                        totalSINSelected++;
                    }
                }
            }
        }

        //console.log('totalSINSelected: ' + totalSINSelected); //CSM-14070
        //console.log('maximumSelection: ' + maximumSelection); //CSM-14070
        if(totalSINSelected > 0 && totalSINSelected == maximumSelection){
            console.log('select all accounts');
            billSumToSet = this.modifyAccountCheckbox(billSums, parentAccount, true);
            if(acctList != null && acctList.indexOf(parentAccount) <= -1){
                acctList.push(parentAccount);
            }
        }else{
            //console.log('deselect all accounts'); //CSM-14070
            billSumToSet = this.modifyAccountCheckbox(billSums, parentAccount, false);
            var indexAcct = acctList.indexOf(parentAccount);
           if (indexAcct > -1) {
                acctList.splice(indexAcct, 1);
           }
        }

        var selectableSINs = component.get("v.enabledSINs");
        if(idList.length > 0 && (idList.length == selectableSINs)){
            component.set("v.markAll", true);
        }
        
        if(isChecked){
            newSubTotal = currentSubtotal +  amountDue;
            totalOfSubTotals = totalOfSubTotals + amountDue;
        }else{
            newSubTotal = currentSubtotal -  amountDue;
            totalOfSubTotals = totalOfSubTotals - amountDue;
        }

        //START CSM-12645 RReyes SEP-22-17
        billSums = this.setAccountDetails(component, event, billSums);
        //END CSM-12645 RReyes SEP-22-17

        this.setAccountSubtotal(billSums, parentAccount, newSubTotal);

        var myKey = parentAccount;
        var found = false;

        //START CSM-12645 RReyes SEP-26-17
        var record;
        for(var x=0; x<billSums.length; x++) {
            if(billSums[x]["key"] == myKey) {
                record = billSums[x]["listBills"][0];
                break;
            }
        }
        var isDisabled = true;
        if((record.isAcctSel == 'true' && record.hasDisabledSIN == false && record.allSINsEnrolled == true) 
            || record.isSingleSINSelected == true || record.isSingleSINSelectAll == true){
            isDisabled = false;
        }
        //END CSM-12645 RReyes SEP-26-17
        for(var x=0; x<subTotalMap.length; x++) {
            if("key" in subTotalMap[x] && subTotalMap[x]["key"] == myKey) {
                subTotalMap[x]["subtotal"] = newSubTotal;
                found = true;
                //START CSM-12645 RReyes SEP-26-17
                console.log('record found: ' + JSON.stringify(record));
                subTotalMap[x]["prevSubtotal"] =  newSubTotal;
                subTotalMap[x]["accountHasDisabled"] =  record.hasDisabledSIN;
                subTotalMap[x]["isSingleSINSelected"] =  record.isSingleSINSelected;
                subTotalMap[x]["isSingleSINAllSelected"] =  record.isSingleSINSelectAll;
                subTotalMap[x]["isAllSINSEnrolled"] =  record.allSINsEnrolled;
                subTotalMap[x]["isAccountSelected"] =  record.isAcctSel;
                subTotalMap[x]["isDisabled"] =  isDisabled;
                subTotalMap[x]["contractExternalId"] =  record.contractExternalId;//START/END CSM-12705 RReyes OCT-26-17 
                //END CSM-12645 RReyes SEP-26-17
                break;
            }
        }

        if(!found) {
            //START CSM-12645 RReyes SEP-26-17
            console.log('record not found: ' + JSON.stringify(record));
            //START CSM-12705 RReyes OCT-26-17 
            var temp = { "key": myKey, "subtotal": newSubTotal,"prevSubtotal": newSubTotal, "accountHasDisabled": record.hasDisabledSIN, 
                        "isSingleSINSelected": record.isSingleSINSelected, "isSingleSINAllSelected": record.isSingleSINSelectAll,
                        "isAllSINSEnrolled": record.allSINsEnrolled, "isAccountSelected": record.isAcctSel, "isDisabled": isDisabled,
                        "contractExternalId": record.contractExternalId };
            //END CSM-12705 RReyes OCT-26-17 
            //EMD CSM-12645 RReyes SEP-26-17
            subTotalMap.push(temp);
        }

        component.set("v.subTotalMap", subTotalMap);
        //console.log('service: subtotalMap: ' + JSON.stringify(component.get("v.subTotalMap"))); //CSM-14070
        //component.set("v.filteredBillingSummary", billSumToSet); //lol
        component.set("v.filteredBillingSummary", billSums);
        component.set("v.selectedServices", serviceList);
        component.set("v.selectedAccounts", acctList);
        component.set("v.selectedIds", idList);
        component.set("v.selectedSINs", idList.length);
        component.set("v.totalAmountToPay", totalOfSubTotals);
        /*
        console.log('Selected ACCOUNTS: ' + component.get("v.selectedAccounts"));
        console.log('Selected SINS: ' + component.get("v.selectedServices"));
        console.log('Selected IDs: ' + component.get("v.selectedIds"));
        console.log('No. of VISIBLE Ids: ' + component.get("v.visibleSINs"));
        console.log('No. of SELECTABLE Ids: ' + component.get("v.enabledSINs"));
        console.log('No. of SELECTED Ids: ' + component.get("v.selectedSINs"));
        */
        this.computeTotal(component, subTotalMap);
    },

    getParentAccountNum : function (billSummary, id){
        var acctNum = '';
        for(var a=0; a < billSummary.length; a++){
            for(var s=0; s < billSummary[a]["listBills"].length; s++){
                if(billSummary[a]["listBills"][s].id == id){
                    acctNum = billSummary[a]["listBills"][s].acctNum;
                    break;
                }
            }
        }
        return acctNum;
    },
    
    getMaximumSelected : function (billSummary, acctNo){
        var maxSelected = 0;
        for(var a=0; a < billSummary.length; a++){
            for(var s=0; s < billSummary[a]["listBills"].length; s++){
                if(billSummary[a]["listBills"][s].acctNum == acctNo){
                    if(billSummary[a]["listBills"][s].isSINOff == 'false'){
                        maxSelected++;
                    }
                }
            }
        }
        return maxSelected;
    },
    
    modifyAccountCheckbox : function (billSummary, acctNo, isSelect){
        console.log('modifyAccountCheckbox');
        for(var a=0; a < billSummary.length; a++){
            for(var s=0; s < billSummary[a]["listBills"].length; s++){
                if(billSummary[a]["listBills"][s].acctNum == acctNo){
                    if(isSelect){
                        billSummary[a]["listBills"][s].isAcctSel = 'true';
                    }else{
                        billSummary[a]["listBills"][s].isAcctSel = 'false';
                    }
                }
            }
        }
        //pending logic to update acctList and serviceList
        return billSummary;
    },   

    computeAccountSubtotal : function (billSummary, acctNo){
        var subtotal = 0;
        for(var a=0; a < billSummary.length; a++){
            for(var s=0; s < billSummary[a]["listBills"].length; s++){
                if(billSummary[a]["listBills"][s].acctNum == acctNo){
                    if(billSummary[a]["listBills"][s].isSINSel == 'true'){
                        console.log('pending amount: ' + billSummary[a]["listBills"][s].penAmt);
                        if(billSummary[a]["listBills"][s].penAmt != null){
                            //console.log('before'); //CSM-14070
                            subtotal = subtotal + parseFloat(billSummary[a]["listBills"][s].penAmt);
                            //console.log('after:' + subtotal); //CSM-14070
                        }
                    }
                }
            }
        }
        return subtotal;
    },

    setAccountSubtotal : function (billSummary, acctNo, subTot){
        for(var a=0; a < billSummary.length; a++){
            for(var s=0; s < billSummary[a]["listBills"].length; s++){
                if(billSummary[a]["listBills"][s].acctNum == acctNo){
                    if(subTot != null){
                        billSummary[a]["listBills"][s].subTotal = subTot; 
                    }else{
                        billSummary[a]["listBills"][s].subTotal = 0; 
                    }
                }
            }
        }
    }, 

    sortByAccount : function (component, event){
        console.log('sort by account');
        var billSummary = component.get("v.filteredBillingSummary");
        var previousSortMode = component.get("v.accountSortMode");
        var newSortMode = 'asc';
        
        if(previousSortMode == 'asc'){
            newSortMode = 'desc';
        }

        var acctListToSort = [];
        var sortedList = [];

        //get all accounts list
        for(var a=0; a < billSummary.length; a++){
            if(acctListToSort != null && acctListToSort.indexOf(billSummary[a]["key"]) <= -1){
                acctListToSort.push(billSummary[a]["key"]);
            }
        }

        acctListToSort.sort();

        if(newSortMode == 'asc'){
           sortedList =  acctListToSort;
        }else{
            for(var i= acctListToSort.length - 1; i >= 0; i--){
                sortedList.push(acctListToSort[i]);
            }
        }

        var myObjectMap = [];
        for(var a = 0; a < sortedList.length; a++){                     
            for(var i=0; i<billSummary.length; i++) {  
                if(billSummary[i]["key"] == sortedList[a]){
                    for(var s=0; s<billSummary[i]["listBills"].length; s++) {  
                        //push only if record's account number is similar to current account numcon                
                        // Get the record
                        var myRecord = billSummary[i]["listBills"][s];
                        var myKey = myRecord.acctNum;

                        var found = false;
                        for(var x=0; x<myObjectMap.length; x++) {
                            if("key" in myObjectMap[x] && myObjectMap[x]["key"] == myKey) {
                                myObjectMap[x]["listBills"].push(myRecord);
                                found = true;
                                break;
                            }
                        }

                        if(!found){
                            var temp = { "key": myKey, "listBills": [myRecord] };
                            myObjectMap.push(temp);
                        }
                    }
                }    
            }
        }
        //console.log('myObjectMap: ' + JSON.stringify(myObjectMap)); //CSM-14070
        component.set("v.accountSortMode", newSortMode);
        component.set("v.filteredBillingSummary", myObjectMap);
    }, 

    sortByServiceNumber : function (component, event){
        console.log('sort by service number');
        var billSummary = component.get("v.filteredBillingSummary");
        var previousSortMode = component.get("v.serviceSortMode");
        var newSortMode = 'asc';
        
        if(previousSortMode == 'asc'){
            newSortMode = 'desc';
        }

        var acctListSort = [];
        var listToSort = [];
        var sortedList = [];


        //get all billed amount list
        for(var a=0; a < billSummary.length; a++){
            if(acctListSort != null && acctListSort.indexOf(billSummary[a]["key"]) <= -1){
                acctListSort.push(billSummary[a]["key"]);
            }
            for(var s=0; s < billSummary[a]["listBills"].length; s++){
                if(listToSort != null && listToSort.indexOf(billSummary[a]["listBills"][s].svcNum) <= -1){
                    listToSort.push(billSummary[a]["listBills"][s].svcNum);
                }
                
            }
        }

        listToSort.sort();
        //console.log('listToSort:' + listToSort); //CSM-14070

        //console.log('newSortMode: ' + newSortMode); //CSM-14070
        //console.log('listToSort: ' + listToSort); //CSM-14070
        if(newSortMode == 'asc'){
           sortedList =  listToSort;
        }else{
            for(var i= listToSort.length - 1; i >= 0; i--){
                sortedList.push(listToSort[i]);
            }
        }
        //console.log('sortedList: ' + sortedList); //CSM-14070

        var myObjectMap = [];
        for(var y=0; y<acctListSort.length; y++) {  //added
            for(var a = 0; a < sortedList.length; a++){                     
                for(var i=0; i<billSummary.length; i++) { 
                    if(billSummary[i]["key"] == acctListSort[y]){ //added
                        for(var s=0; s<billSummary[i]["listBills"].length; s++) {  
                            if(billSummary[i]["listBills"][s].svcNum == sortedList[a]){
                                //push only if record's account number is similar to current account numcon                
                                // Get the record
                                var myRecord = billSummary[i]["listBills"][s];
                                var myKey = myRecord.acctNum;

                                var found = false;
                                for(var x=0; x<myObjectMap.length; x++) {
                                    if("key" in myObjectMap[x] && myObjectMap[x]["key"] == myKey) {
                                        myObjectMap[x]["listBills"].push(myRecord);
                                        found = true;
                                        break;
                                    }
                                }

                                if(!found){
                                    var temp = { "key": myKey, "listBills": [myRecord] };
                                    myObjectMap.push(temp);
                                }
                            }
                        }
                    }
                }
            }
        }
        //console.log('myObjectMap: ' + JSON.stringify(myObjectMap)); //CSM-14070
        component.set("v.serviceSortMode", newSortMode);
        component.set("v.filteredBillingSummary", myObjectMap);
    }, 

    sortByBilledAmount : function (component, event){
        console.log('sort by billed amount');
        var billSummary = component.get("v.filteredBillingSummary");
        var previousSortMode = component.get("v.billedAmountSortMode");
        var newSortMode = 'asc';
        
        if(previousSortMode == 'asc'){
            newSortMode = 'desc';
        }

        var acctListSort = [];
        var listToSort = [];
        var sortedList = [];


        //get all billed amount list
        for(var a=0; a < billSummary.length; a++){
            if(acctListSort != null && acctListSort.indexOf(billSummary[a]["key"]) <= -1){
                acctListSort.push(billSummary[a]["key"]);
            }
            for(var s=0; s < billSummary[a]["listBills"].length; s++){
                if(listToSort != null && listToSort.indexOf(billSummary[a]["listBills"][s].totalAmt) <= -1){
                    listToSort.push(billSummary[a]["listBills"][s].totalAmt);
                }
                
            }
        }

        listToSort.sort(function(a, b){return a-b});
        //console.log('listToSort:' + listToSort); //CSM-14070

        //console.log('newSortMode: ' + newSortMode); //CSM-14070
        //console.log('listToSort: ' + listToSort); //CSM-14070
        if(newSortMode == 'asc'){
           sortedList =  listToSort;
        }else{
            for(var i= listToSort.length - 1; i >= 0; i--){
                sortedList.push(listToSort[i]);
            }
        }
        //console.log('sortedList: ' + sortedList); //CSM-14070

        var myObjectMap = [];
        for(var y=0; y<acctListSort.length; y++) {  //added
            for(var a = 0; a < sortedList.length; a++){                     
                for(var i=0; i<billSummary.length; i++) { 
                    if(billSummary[i]["key"] == acctListSort[y]){ //added
                        for(var s=0; s<billSummary[i]["listBills"].length; s++) {  
                            if(billSummary[i]["listBills"][s].totalAmt == sortedList[a]){
                                //push only if record's account number is similar to current account numcon                
                                // Get the record
                                var myRecord = billSummary[i]["listBills"][s];
                                var myKey = myRecord.acctNum;

                                var found = false;
                                for(var x=0; x<myObjectMap.length; x++) {
                                    if("key" in myObjectMap[x] && myObjectMap[x]["key"] == myKey) {
                                        myObjectMap[x]["listBills"].push(myRecord);
                                        found = true;
                                        break;
                                    }
                                }

                                if(!found){
                                    var temp = { "key": myKey, "listBills": [myRecord] };
                                    myObjectMap.push(temp);
                                }
                            }
                        }
                    } //added
                }
            }
        }
        //console.log('myObjectMap: ' + JSON.stringify(myObjectMap)); //CSM-14070
        component.set("v.billedAmountSortMode", newSortMode);
        component.set("v.filteredBillingSummary", myObjectMap);
    }, 

    sortByCurrentAmountDue : function (component, event){
        console.log('sort by current amount due');
        var billSummary = component.get("v.filteredBillingSummary");
        var previousSortMode = component.get("v.currentAmountSortMode");
        var newSortMode = 'asc';
        
        if(previousSortMode == 'asc'){
            newSortMode = 'desc';
        }

        var acctListSort = [];
        var listToSort = [];
        var sortedList = [];


        //get all billed amount list
        for(var a=0; a < billSummary.length; a++){
            if(acctListSort != null && acctListSort.indexOf(billSummary[a]["key"]) <= -1){
                acctListSort.push(billSummary[a]["key"]);
            }
            for(var s=0; s < billSummary[a]["listBills"].length; s++){
                if(listToSort != null && listToSort.indexOf(billSummary[a]["listBills"][s].penAmt) <= -1){
                    listToSort.push(billSummary[a]["listBills"][s].penAmt);
                }
                
            }
        }

        listToSort.sort(function(a, b){return a-b});
        //console.log('listToSort:' + listToSort); //CSM-14070

        //console.log('newSortMode: ' + newSortMode); //CSM-14070
        //console.log('listToSort: ' + listToSort); //CSM-14070
        if(newSortMode == 'asc'){
           sortedList =  listToSort;
        }else{
            for(var i= listToSort.length - 1; i >= 0; i--){
                sortedList.push(listToSort[i]);
            }
        }
        //console.log('sortedList: ' + sortedList); //CSM-14070

        var myObjectMap = [];
        for(var y=0; y<acctListSort.length; y++) {  //added
            for(var a = 0; a < sortedList.length; a++){                     
                for(var i=0; i<billSummary.length; i++) { 
                    if(billSummary[i]["key"] == acctListSort[y]){ //added
                        for(var s=0; s<billSummary[i]["listBills"].length; s++) {  
                            if(billSummary[i]["listBills"][s].penAmt == sortedList[a]){
                                //push only if record's account number is similar to current account numcon                
                                // Get the record
                                var myRecord = billSummary[i]["listBills"][s];
                                var myKey = myRecord.acctNum;

                                var found = false;
                                for(var x=0; x<myObjectMap.length; x++) {
                                    if("key" in myObjectMap[x] && myObjectMap[x]["key"] == myKey) {
                                        myObjectMap[x]["listBills"].push(myRecord);
                                        found = true;
                                        break;
                                    }
                                }

                                if(!found){
                                    var temp = { "key": myKey, "listBills": [myRecord] };
                                    myObjectMap.push(temp);
                                }
                            }
                        }
                    } //added
                }
            }
        }
        //console.log('myObjectMap: ' + JSON.stringify(myObjectMap)); //CSM-14070
        component.set("v.currentAmountSortMode", newSortMode);
        component.set("v.filteredBillingSummary", myObjectMap);
    }, 

    sortByDueDate : function (component, event){
        console.log('sort by bill due date');
        var billSummary = component.get("v.filteredBillingSummary");
        var previousSortMode = component.get("v.dueDateSortMode");
        var newSortMode = 'asc';
        
        if(previousSortMode == 'asc'){
            newSortMode = 'desc';
        }

        var acctListSort = [];
        var listToSort = [];
        var sortedList = [];


        //get all billed amount list
        for(var a=0; a < billSummary.length; a++){
            if(acctListSort != null && acctListSort.indexOf(billSummary[a]["key"]) <= -1){
                acctListSort.push(billSummary[a]["key"]);
            }
            for(var s=0; s < billSummary[a]["listBills"].length; s++){
                if(listToSort != null && listToSort.indexOf(billSummary[a]["listBills"][s].dueDt) <= -1){
                    listToSort.push(billSummary[a]["listBills"][s].dueDt);
                }
                
            }
        }

        listToSort.sort(function(a, b){return new Date(a) -new Date(b)});
        //console.log('listToSort:' + listToSort); //CSM-14070

        //console.log('newSortMode: ' + newSortMode); //CSM-14070
        //console.log('listToSort: ' + listToSort); //CSM-14070
        if(newSortMode == 'asc'){
           sortedList =  listToSort;
        }else{
            for(var i= listToSort.length - 1; i >= 0; i--){
                sortedList.push(listToSort[i]);
            }
        }
        //console.log('sortedList: ' + sortedList); //CSM-14070

        var myObjectMap = [];
        for(var y=0; y<acctListSort.length; y++) {  //added
            for(var a = 0; a < sortedList.length; a++){                     
                for(var i=0; i<billSummary.length; i++) { 
                    if(billSummary[i]["key"] == acctListSort[y]){ //added
                        for(var s=0; s<billSummary[i]["listBills"].length; s++) {  
                            if(billSummary[i]["listBills"][s].dueDt == sortedList[a]){
                                //push only if record's account number is similar to current account numcon                
                                // Get the record
                                var myRecord = billSummary[i]["listBills"][s];
                                var myKey = myRecord.acctNum;

                                var found = false;
                                for(var x=0; x<myObjectMap.length; x++) {
                                    if("key" in myObjectMap[x] && myObjectMap[x]["key"] == myKey) {
                                        myObjectMap[x]["listBills"].push(myRecord);
                                        found = true;
                                        break;
                                    }
                                }

                                if(!found){
                                    var temp = { "key": myKey, "listBills": [myRecord] };
                                    myObjectMap.push(temp);
                                }
                            }
                        }
                    } //added
                }
            }
        }
        //console.log('myObjectMap: ' + JSON.stringify(myObjectMap)); //CSM-14070
        component.set("v.dueDateSortMode", newSortMode);
        component.set("v.filteredBillingSummary", myObjectMap);
    }, 
        
    sortByEndOfBillingPeriod : function (component, event){
        console.log('sort by end of billing period');
        var billSummary = component.get("v.filteredBillingSummary");
        var previousSortMode = component.get("v.endOfBillingSortMode");
        var newSortMode = 'asc';
        
        if(previousSortMode == 'asc'){
            newSortMode = 'desc';
        }

        var acctListSort = [];
        var listToSort = [];
        var sortedList = [];


        //get all billed amount list
        for(var a=0; a < billSummary.length; a++){
            if(acctListSort != null && acctListSort.indexOf(billSummary[a]["key"]) <= -1){
                acctListSort.push(billSummary[a]["key"]);
            }
            for(var s=0; s < billSummary[a]["listBills"].length; s++){
                if(listToSort != null && listToSort.indexOf(billSummary[a]["listBills"][s].billDt) <= -1){
                    listToSort.push(billSummary[a]["listBills"][s].billDt);
                }
                
            }
        }

        listToSort.sort(function(a, b){return new Date(a) -new Date(b)});
        //console.log('listToSort:' + listToSort); //CSM-14070
        //console.log('newSortMode: ' + newSortMode); //CSM-14070
        if(newSortMode == 'asc'){
           sortedList =  listToSort;
        }else{
            for(var i= listToSort.length - 1; i >= 0; i--){
                sortedList.push(listToSort[i]);
            }
        }
        //console.log('sortedList: ' + sortedList); //CSM-14070

        var myObjectMap = [];
        for(var y=0; y<acctListSort.length; y++) {  //added
            for(var a = 0; a < sortedList.length; a++){                     
                for(var i=0; i<billSummary.length; i++) { 
                    if(billSummary[i]["key"] == acctListSort[y]){ //added
                        for(var s=0; s<billSummary[i]["listBills"].length; s++) {  
                            if(billSummary[i]["listBills"][s].billDt == sortedList[a]){
                                //push only if record's account number is similar to current account numcon                
                                // Get the record
                                var myRecord = billSummary[i]["listBills"][s];
                                var myKey = myRecord.acctNum;

                                var found = false;
                                for(var x=0; x<myObjectMap.length; x++) {
                                    if("key" in myObjectMap[x] && myObjectMap[x]["key"] == myKey) {
                                        myObjectMap[x]["listBills"].push(myRecord);
                                        found = true;
                                        break;
                                    }
                                }

                                if(!found){
                                    var temp = { "key": myKey, "listBills": [myRecord] };
                                    myObjectMap.push(temp);
                                }
                            }
                        }
                    } //added
                }
            }
        }
        //console.log('myObjectMap: ' + JSON.stringify(myObjectMap)); //CSM-14070
        component.set("v.endOfBillingSortMode", newSortMode);
        component.set("v.filteredBillingSummary", myObjectMap);
    },

    trackChanges : function (component, event, helper){
        console.log('trackChanges: ' + event.target);
        var id = event.target.value;
        var isChecked = event.target.checked;
        
        if(!isChecked){
            component.set("v.markAll", false);
        }
        console.log('id: ' + id);
        console.log('isChecked: ' + isChecked);
    }, 

    computeTotal : function (component, subTotalMap){
        console.log('computeTotal: subTotalMap: ' + JSON.stringify(subTotalMap));
        var totalAmount = 0.0;
        for(var x=0; x<subTotalMap.length; x++) {
            //console.log(x + ' : ' + subTotalMap[x]["subtotal"]); //CSM-14070
            if(subTotalMap[x]["subtotal"] != null){
                if(subTotalMap[x]["subtotal"] < 0 ){
                    subTotalMap[x]["subtotal"] = 0;
                }else{
                    totalAmount += parseFloat(subTotalMap[x]["subtotal"]);    
                }
            }else{
                subTotalMap[x]["subtotal"] = 0;
            }
        }
        component.set("v.totalAmountToPay", totalAmount);
        component.set("v.subTotalMap", subTotalMap);
        console.log('total: totalAmount GET: ' + component.get("v.totalAmountToPay"));
    },
    //END CSM-10913 RReyes JUL-24-17

    goToManageService : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/manageservice';
        window.location.assign(pageUrl);     
    }
    //START CSM-12645 RReyes SEP-26-17
    ,validateSubtotalChange : function (component, event, helper, subTotalMap){
        for(var x=0; x<subTotalMap.length; x++) {
            var subtotalRec;
            var errorMsg = '';
            if(subTotalMap[x]["subtotal"] != subTotalMap[x]["prevSubtotal"]){
                subtotalRec = subTotalMap[x];
                if(subtotalRec.subtotal == null){
                    subtotalRec.subtotal = 0;
                }
                console.log('>> subtotalRec' + JSON.stringify(subtotalRec));
                if(subtotalRec.isSingleSINSelected && !subtotalRec.isSingleSINAllSelected && subtotalRec.subtotal > subtotalRec.prevSubtotal){
                    console.log('Value should be less or equal to ' + subtotalRec.prevSubtotal);
                    subtotalRec.subtotal = subtotalRec.prevSubtotal;
                }

                //add logic to check if isAccountSelected
                if(subtotalRec.isAllSINSEnrolled && !subtotalRec.accountHasDisabled && subtotalRec.isAccountSelected == 'true'
                    && !subtotalRec.isSingleSINAllSelected && subtotalRec.subtotal < subtotalRec.prevSubtotal){
                    console.log('Value should be greater or equal to ' + subtotalRec.prevSubtotal);
                    subtotalRec.subtotal = subtotalRec.prevSubtotal;
                }
                break;
            }
        }
        component.set("v.subTotalMap", subTotalMap);
        
    }
    //END CSM-12645 RReyes SEP-26-17
    //START CSM-12629 RReyes SEP-29-17
    ,proceedPay: function(component, event, helper) {
        var filteredBillingSummary = component.get("v.filteredBillingSummary");
        var totalAmountToPay = component.get("v.totalAmountToPay");
        var subTotalMap = component.get("v.subTotalMap")
        
        var setEvent = component.getEvent("setTotalAmount");
        setEvent.setParams({"tabToNavigate":"tab2"});
        setEvent.setParams({"filteredBillingSummary":filteredBillingSummary});
        setEvent.setParams({"totalAmountToPay":totalAmountToPay});
        setEvent.setParams({"subTotalMap":subTotalMap});
        setEvent.fire();
        console.log('proceedPay');
        
    }
    ,checkOverduePrompt : function (component, event, helper) {
        var billSums = component.get("v.filteredBillingSummary");
        var selectedAllSINS = [];
        var sinsWithOverDueDisconnected = [];
        var sinsWithOverDueTerminated = [];
        var hasAnyOverdue = false; //check if there is at least one overdue
        var hasTerminatedOverdue = false; //check if there is at least one terminated overdue
        var allOverdueCount = 0;
        var selectedOverdueCount = 0;
        var allDisconnectedCount = 0;
        var selectedDisconnectedCount = 0;
        var allTerminatedCount = 0;
        var selectedTerminatedCount = 0;
        var subMap = component.get("v.subTotalMap");
        var singleSINAcctPartialPayment = [];
        var promptType = '';
        //START CSM-14742 RReyes NOV-29-17
        var hasOtherOverduePartial = false;
        //END CSM-14742 RReyes NOV-29-17

        //get those single sins with partial payment
        console.log('subtotalMap: ' + JSON.stringify(subMap));
        for(var x=0; x<subMap.length; x++) {
            if(subMap[x]["subtotal"] < subMap[x]["prevSubtotal"]){
                if(singleSINAcctPartialPayment != null && singleSINAcctPartialPayment.indexOf(subMap[x]["key"]) == -1){
                    singleSINAcctPartialPayment.push(subMap[x]["key"]);
                } 
            }   
        }
        console.log('>>singleSINAcctPartialPayment: ' + singleSINAcctPartialPayment);

        for(var a=0; a<billSums.length; a++) {
            for(var s=0; s < billSums[a]["listBills"].length; s++) {
                if(billSums[a]["listBills"][s].hasAnyOverdue){
                    hasAnyOverdue = true;
                    allOverdueCount++;
                    if(billSums[a]["listBills"][s].isSINSel == 'true'){
                        selectedOverdueCount++;
                    }
                    //get
                    if(billSums[a]["listBills"][s].hasOverdueDisconnected){
                        allDisconnectedCount++;
                        if(billSums[a]["listBills"][s].isSINSel == 'true'){
                            selectedDisconnectedCount++;
                        }

                        if(sinsWithOverDueDisconnected != null && sinsWithOverDueDisconnected.indexOf(billSums[a]["listBills"][s].svcNum) == -1){
                            sinsWithOverDueDisconnected.push(billSums[a]["listBills"][s].svcNum);
                        }
                    }

                    if(billSums[a]["listBills"][s].hasOverdueTerminated){
                        allTerminatedCount++;
                        hasTerminatedOverdue = true;
                        if(billSums[a]["listBills"][s].isSINSel == 'true'){
                            selectedTerminatedCount++;
                        }
                        if(sinsWithOverDueTerminated != null && sinsWithOverDueTerminated.indexOf(billSums[a]["listBills"][s].svcNum) == -1){
                            sinsWithOverDueTerminated.push(billSums[a]["listBills"][s].svcNum);
                        }
                    }
                }
            }
        }

        console.log('>>sinsWithOverDueDisconnected BEFORE: ' + sinsWithOverDueDisconnected);
        console.log('>>sinsWithOverDueTerminated BEFORE: ' + sinsWithOverDueTerminated); 
        console.log('>>singleSINAcctPartialPayment: ' + singleSINAcctPartialPayment); 

        for(var a=0; a<billSums.length; a++) {
            for(var s=0; s < billSums[a]["listBills"].length; s++) {
                var isPartiallyPaid = false;
                if(billSums[a]["listBills"][s].hasAnyOverdue){
                    var acctNum = billSums[a]["listBills"][s].acctNum;
                    if(singleSINAcctPartialPayment != null && singleSINAcctPartialPayment.indexOf(acctNum) >= 0){
                        isPartiallyPaid = true;
                    }
                    //remove SIN with disconnected which is not all selected
                    if(billSums[a]["listBills"][s].hasOverdueDisconnected){
                        if(billSums[a]["listBills"][s].isSINSel == 'false' || (billSums[a]["listBills"][s].isSingleSINSelectAll && isPartiallyPaid)){
                            if(sinsWithOverDueDisconnected != null && sinsWithOverDueDisconnected.indexOf(billSums[a]["listBills"][s].svcNum) >= 0){
                                sinsWithOverDueDisconnected.splice(sinsWithOverDueDisconnected.indexOf(billSums[a]["listBills"][s].svcNum), 1);
                            }
                        }
                    }
                    //remove SIN with disconnected which is not all selected
                    if(billSums[a]["listBills"][s].hasOverdueTerminated){
                        if(billSums[a]["listBills"][s].isSINSel == 'false' || (billSums[a]["listBills"][s].isSingleSINSelectAll && isPartiallyPaid)){
                            if(sinsWithOverDueTerminated != null && sinsWithOverDueTerminated.indexOf(billSums[a]["listBills"][s].svcNum) >= 0){
                                sinsWithOverDueTerminated.splice(sinsWithOverDueTerminated.indexOf(billSums[a]["listBills"][s].svcNum), 1);
                            }
                        }
                    }

                    //START CSM-14742 RReyes NOV-29-17
                    if((!billSums[a]["listBills"][s].hasOverdueDisconnected && !billSums[a]["listBills"][s].hasOverdueTerminated) 
                        && (billSums[a]["listBills"][s].hasOverduePayNow || billSums[a]["listBills"][s].hasOverdueForDisconnection) 
                        && isPartiallyPaid){
                        hasOtherOverduePartial = true;
                    }
                    //END CSM-14742 RReyes NOV-29-17
                }
            }
        }

        //is there an overdue invoice detected across all bill notes?
        if(allOverdueCount > 0){
            //did user select all overdue of at least 1 disconnected service?
            if(sinsWithOverDueDisconnected != null && sinsWithOverDueDisconnected.length > 0){
                promptType = 'pay-disconnected';
            }else if(allOverdueCount == selectedOverdueCount){
                if(hasTerminatedOverdue){
                    if((sinsWithOverDueTerminated != null && sinsWithOverDueTerminated.length > 0)){
                        promptType = 'pay-terminated';
                    }else{
                        promptType = 'settle-bills';
                    }
                }
                //START CSM-14742 RReyes NOV-29-17
                else if(hasOtherOverduePartial){
                    promptType = 'settle-bills';
                }
                //END CSM-14742 RReyes NOV-29-17
            }else if(allOverdueCount != selectedOverdueCount){
                promptType = 'settle-bills';
            }
        }
        console.log('>>allOverdueCount: ' + allOverdueCount);
        console.log('>>selectedOverdueCount: ' + selectedOverdueCount);

        console.log('>>allDisconnectedCount: ' + allDisconnectedCount);
        console.log('>>selectedDisconnectedCount: ' + selectedDisconnectedCount);

        console.log('>>allTerminatedCount: ' + allTerminatedCount);
        console.log('>>selectedTerminatedCount: ' + selectedTerminatedCount);

        console.log('>>sinsWithOverDueDisconnected AFTER: ' + sinsWithOverDueDisconnected);
        console.log('>>sinsWithOverDueTerminated AFTER: ' + sinsWithOverDueTerminated); 
        console.log('>>promptType: ' + promptType); 
        return promptType;
    }
    //END CSM-12629 RReyes SEP-29-17
    //START CSM-14070 GGrandea 10.24.2017
    , hide_spinner: function(cmp) {
        setTimeout(function(){
            var setEvent = cmp.getEvent("spinnerHandler");
            setEvent.setParams({"hideSpinner":true});
            setEvent.fire();
        }, 500);        
    }
    
    , show_spinner: function(cmp) {
        var setEvent = cmp.getEvent("spinnerHandler");
        setEvent.setParams({"hideSpinner":false});
        setEvent.fire();
    }
    //END CSM-14070
	
	, initTooltips: function(component, event) {
		var toolTipMap = [];
        toolTipMap.push({ "key" : "IPA", "value" : $A.get("$Label.c.TOOLTIP_IPA")});
		toolTipMap.push({ "key" : "TRO", "value" : $A.get("$Label.c.TOOLTIP_TRO")});
		toolTipMap.push({ "key" : "UNDER_REVIEW", "value" : $A.get("$Label.c.TOOLTIP_UNDER_REVIEW")});
		toolTipMap.push({ "key" : "APA", "value" : $A.get("$Label.c.TOOLTIP_APA")});
		toolTipMap.push({ "key" : "BD", "value" : $A.get("$Label.c.TOOLTIP_BILL_DEPOSIT")});
		toolTipMap.push({ "key" : "IRREG", "value" : $A.get("$Label.c.TOOLTIP_SERV_IRREG")});
		component.set("v.toolTipMap", toolTipMap);
    }
})