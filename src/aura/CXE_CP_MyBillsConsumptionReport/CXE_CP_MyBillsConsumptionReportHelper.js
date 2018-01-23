({
    loadTable : function (component,sinPass) {
        var itemNode = document.getElementById('myChart');
        //START CSM-13962 GGrandea 10.18.2017
        if(itemNode!=null){
            itemNode.parentNode.removeChild(itemNode);
        }
        var chartDivElem = document.getElementById('chartDiv');
        if(chartDivElem!=null){
            chartDivElem.innerHTML = '<label>kWh</label><canvas id="myChart"></canvas>';
        }
        //document.getElementById('chartDiv').innerHTML = '<label>kWh</label><canvas id="myChart"></canvas>';
        //END CSM-13962
        
        var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec","Jan"
                         ];
        var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
        var Data = [];
        var newMonths = [];
        var newValue=[0,0,0,0,0,0,0,0,0,0,0,0,0];
        var totalUsage = 0;
        var action = component.get("c.retrieveBillsData");
        var sinPass;
        action.setParams({"sinSelected":sinPass});
        var maxUsage = 0;
        action.setCallback(this,function(response){          
            var state = response.getState();
            
            //FOR ACCOUNT LIST PART DROPDOWN
            
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                console.log(response.getReturnValue());  
                component.set('v.billsInformations' , response.getReturnValue());
                var allbills = response.getReturnValue().allBills;
                console.log(response.getReturnValue());
                console.log(allbills.length);
                var latestBillingDate =  new Date(response.getReturnValue().oldestDate);
                var yearnow = latestBillingDate.getFullYear() - 1;//1976
                var lastyear = latestBillingDate.getFullYear();//1975
                var today = new Date(response.getReturnValue().oldestDate);
                console.log('today: ' + today);
                var earliest = new Date(response.getReturnValue().earliestDate);
                var todaymonth = monthNames[today.getMonth()];
                console.log('todaymonth: ' + todaymonth);
                
                if(difference == 0){
                    difference = 1;
                }
                if(todaymonth == "Jan"){
                    newMonths.push("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec","Jan"
                                  );  
                }
                if(todaymonth == "Feb"){
                    newMonths.push("Feb", "Mar", "Apr", "May", "Jun",
                                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec","Jan","Feb"
                                  );  
                }
                if(todaymonth == "Mar"){
                    newMonths.push("Mar", "Apr", "May", "Jun",
                                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec","Jan", "Feb", "Mar"
                                  );  
                }
                if(todaymonth == "Apr"){//
                    newMonths.push("Apr", "May", "Jun",
                                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec","Jan","Feb", "Mar", "Apr"
                                  );  
                }
                if(todaymonth == "May"){
                    newMonths.push("May", "Jun",
                                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec","Jan", "Feb", "Mar", "Apr", "May"
                                  );  
                }
                if(todaymonth == "Jun"){
                    newMonths.push("Jun",
                                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec","Jan", "Feb", "Mar", "Apr", "May", "Jun"
                                  );  
                }
                if(todaymonth == "Jul"){
                    newMonths.push(
                        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec","Jan","Feb", "Mar", "Apr", "May", "Jun",
                        "Jul"
                    );  
                }
                if(todaymonth == "Aug"){
                    newMonths.push("Aug", "Sep", "Oct", "Nov", "Dec","Jan","Feb", "Mar", "Apr", "May", "Jun",
                                   "Jul", "Aug"
                                  );  
                }
                if(todaymonth == "Sep"){
                    newMonths.push("Sep", "Oct", "Nov", "Dec","Jan","Feb", "Mar", "Apr", "May", "Jun",
                                   "Jul", "Aug", "Sep"
                                  );  
                }
                if(todaymonth == "Oct"){
                    newMonths.push("Oct", "Nov", "Dec","Jan","Feb", "Mar", "Apr", "May", "Jun",
                                   "Jul", "Aug", "Sep", "Oct"
                                  );  
                }
                if(todaymonth == "Nov"){
                    newMonths.push("Nov", "Dec","Jan","Feb", "Mar", "Apr", "May", "Jun",
                                   "Jul", "Aug", "Sep", "Oct", "Nov"
                                  );  
                }
                if(todaymonth == "Dec"){
                    newMonths.push("Dec","Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                                  );  
                }
                console.log('newMonths: ' + newMonths);
                console.log('allbills: ' + allbills);
                var monthsWithData = 0;
                for(var i = 0 ; i < allbills.length ; i++){
                    var objDate = new Date(allbills[i].bill_date);
                    //START CSM-12478 Emandolado 9/5/2017
                    var usage;
                    //START CSM-13671 GGrandea 10.12.2017
                    //if(allbills[i].bill_type == "Service" && parseInt(allbills[i].bill_usage.trim()) > 0){ //added to filter bill_type
                    if(parseInt(allbills[i].bill_usage.trim()) > 0){
                    //END CSM-13671 GGrandea 10.12.2017
                        if(monthNames[objDate.getMonth()] == newMonths[0]){
                            if(objDate.getFullYear() == lastyear){
                                if(newValue[12] == 0){
                                    monthsWithData += 1;
                                }
                                newValue[12] +=  parseInt(allbills[i].bill_usage.trim());
                                usage = newValue[12];
                                totalUsage +=  parseInt(allbills[i].bill_usage.trim());
                                
                            }else{
                                if(newValue[0] == 0){
                                    monthsWithData += 1;
                                }
                                newValue[0] +=  parseInt(allbills[i].bill_usage.trim());
                                usage = newValue[0];
                                totalUsage +=  parseInt(allbills[i].bill_usage.trim());
                            }
                        }
                        
                        if(monthNames[objDate.getMonth()] == newMonths[1]){
                            if(newValue[1] == 0){
                                monthsWithData += 1;
                            }
                            newValue[1] +=  parseInt(allbills[i].bill_usage.trim());
                            usage = newValue[1];
                            totalUsage +=  parseInt(allbills[i].bill_usage.trim());
                        }
                        
                        if(monthNames[objDate.getMonth()] == newMonths[2]){
                            if(newValue[2] == 0){
                                monthsWithData += 1;
                            }
                            newValue[2] +=  parseInt(allbills[i].bill_usage.trim());
                            usage = newValue[2];
                            totalUsage +=  parseInt(allbills[i].bill_usage.trim());
                        }
                        if(monthNames[objDate.getMonth()] == newMonths[3]){
                            if(newValue[3] == 0){
                                monthsWithData += 1;
                            }
                            newValue[3] +=  parseInt(allbills[i].bill_usage.trim());
                            usage = newValue[3];
                            totalUsage +=  parseInt(allbills[i].bill_usage.trim());
                        }
                        if(monthNames[objDate.getMonth()] == newMonths[4]){
                            if(newValue[4] == 0){
                                monthsWithData += 1;
                            }
                            newValue[4] +=  parseInt(allbills[i].bill_usage.trim());
                            usage = newValue[4];
                            totalUsage +=  parseInt(allbills[i].bill_usage.trim());
                        }
                        if(monthNames[objDate.getMonth()] == newMonths[5]){
                            if(newValue[5] == 0){
                                monthsWithData += 1;
                            }
                            newValue[5] +=  parseInt(allbills[i].bill_usage.trim());
                            usage = newValue[5];
                            totalUsage +=  parseInt(allbills[i].bill_usage.trim());
                        }
                        if(monthNames[objDate.getMonth()] == newMonths[6]){
                            if(newValue[6] == 0){
                                monthsWithData += 1;
                            }
                            newValue[6] +=  parseInt(allbills[i].bill_usage.trim());
                            usage = newValue[6];
                            totalUsage +=  parseInt(allbills[i].bill_usage.trim());
                        }
                        if(monthNames[objDate.getMonth()] == newMonths[7]){
                            if(newValue[7] == 0){
                                monthsWithData += 1;
                            }
                            newValue[7] +=  parseInt(allbills[i].bill_usage.trim());
                            usage = newValue[7];
                            totalUsage +=  parseInt(allbills[i].bill_usage.trim());
                        }
                        if(monthNames[objDate.getMonth()] == newMonths[8]){
                            if(newValue[8] == 0){
                                monthsWithData += 1;
                            }
                            newValue[8] +=  parseInt(allbills[i].bill_usage.trim());
                            usage = newValue[8];
                            totalUsage +=  parseInt(allbills[i].bill_usage.trim());
                        }
                        if(monthNames[objDate.getMonth()] == newMonths[9]){
                            if(newValue[9] == 0){
                                monthsWithData += 1;
                            }
                            newValue[9] +=  parseInt(allbills[i].bill_usage.trim());
                            usage = newValue[9];
                            totalUsage +=  parseInt(allbills[i].bill_usage.trim());
                        }
                        if(monthNames[objDate.getMonth()] == newMonths[10]){
                            if(newValue[10] == 0){
                                monthsWithData += 1;
                            }
                            newValue[10] +=  parseInt(allbills[i].bill_usage.trim());
                            usage = newValue[10];
                            totalUsage +=  parseInt(allbills[i].bill_usage.trim());
                        }
                        if(monthNames[objDate.getMonth()] == newMonths[11] ){
                            if(newValue[11] == 0){
                                monthsWithData += 1;
                            }
                            newValue[11] +=  parseInt(allbills[i].bill_usage.trim());
                            usage = newValue[11];
                            totalUsage +=  parseInt(allbills[i].bill_usage.trim());
                        }
                        
                        //var usage = parseInt(allbills[i].bill_usage);
                        console.log('allbills[i].bill_usage: ' + usage);
                        console.log('here5' + totalUsage);
                        if(usage > maxUsage){
                            maxUsage = usage;
                        }
                    }
                    //End CSM-12478 Emandolado 9/5/2017
                }
                var difference =  monthsWithData;
                console.log("halo" + totalUsage);
                console.log("haloo" + difference);
                console.log('maxUsage: ' + maxUsage);
                //var average = parseInt(totalusage)/difference;
                //
                // Lisen CSM-14048 20171022 - removed this var average = totalUsage / difference;
                // START Lisen CSM-14048 20171022
                if(response.getReturnValue().billingDaysDifference != 0){
                    var average = (totalUsage/response.getReturnValue().billingDaysDifference*365/12);
                }else{
                    var average = 0;
                }
                // END Lisen CSM-14048 20171022
                console.log('here');
                if(average > 0){
                    component.set("v.totalUsage" , average.toFixed(0));
                    component.set("v.dateMonth" , months[today.getMonth()] + ' ' + today.getFullYear() ); 
                }else{
                    // Start R2C CSM-15197 Von Pernicia 1/18/18
                    if (allbills.length > 0)
                    {
                        component.set("v.totalUsage" , "0");
                        component.set("v.dateMonth" , months[today.getMonth()] + ' ' + today.getFullYear() ); 
                    }
                    else
                    {
                        component.set("v.totalUsage" , "0");
                        component.set("v.dateMonth" , "No Record Found");
                    }
                    // End R2C CSM-15197 Von Pernicia 1/18/18
                }
                
                var ctx = document.getElementById("myChart");
                var myChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        //labels: monthNames,
                        labels: newMonths,
                        datasets: [{
                            label: 'kWh',
                            data: newValue,
                            backgroundColor: [
                                'rgba(255,89,30,1)',
                                'rgba(255,89,30,1)',
                                'rgba(255,89,30,1)',
                                'rgba(255,89,30,1)',
                                'rgba(255,89,30,1)',
                                'rgba(255,89,30,1)',
                                'rgba(255,89,30,1)',
                                'rgba(255,89,30,1)',
                                'rgba(255,89,30,1)',
                                'rgba(255,89,30,1)',
                                'rgba(255,89,30,1)',
                                'rgba(255,89,30,1)',
                                'rgba(255,89,30,1)'
                            ],
                            scaleOverride: true,
                            scaleSteps: 10,
                            borderWidth: 0,
                            
                        }]
                    },
                    options: {
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true,
                                    //max: maxUsage + (Math.ceil(((maxUsage*.125)) / 10) * 10),
                                    suggestedMax: maxUsage,
                                    //stepSize: Math.ceil(maxUsage*.125),
                                    stepSize: Math.ceil( (maxUsage/8) / 10) * 10,
                                    fontColor: "black",
                                    fontSize: 14,
                                    fontFamily: "'Open Sans', sans-serif"
                                },
                                barThickness: 14
                            }],
                            xAxes: [{
                                gridLines: {
                                    display: false
                                },
                                barThickness: 14,
                                ticks: {
                                    fontColor: "black",
                                    fontSize: 14,
                                    fontFamily: "'Open Sans', sans-serif"
                                }
                                
                            }]
                        },
                        legend: {
                            display: false
                        }
                    }
                    
                });
                
                var myChart = component.find("myChart");
                $A.util.removeClass(myChart, "slds-hide");
                
            }else{
                
                //alert('yow');
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });  
        $A.enqueueAction(action); 
    },
    
    
    //Start CSM-12826 Mike Verdad 09/22/17
    goToMybills : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/mybills';
        window.location.assign(pageUrl);     
    }
    //End CSM-12826 Mike Verdad 09/22/17

    // START CSM-14480 Jerome To [R2C Regression] Home breadcrumbs not working in Consumption Report Page
    ,goToHome : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/dashboard';
        window.location.assign(pageUrl);
    }
    // END CSM-14480 Jerome To [R2C Regression] Home breadcrumbs not working in Consumption Report Page
})