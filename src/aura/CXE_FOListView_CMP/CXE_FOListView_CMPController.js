({
    doInit : function(component, event, helper) {
        helper.getFieldOrderRecords(component, helper);
    },
    
    isAllSelected : function(component, event, helper){
        var fieldOrderTemp;
        var isAllCheck = true;        
        var fieldOrderList = component.get("v.filteredfieldOrderList");
        //component.set("v.fieldOrderPrint", component.get("v.filteredfieldOrderList"));
        
        for(var counter in fieldOrderList){
            fieldOrderTemp = fieldOrderList[counter];
            
            if(!fieldOrderTemp.isCheck){
                isAllCheck = false;
            }
        }
        
        component.set("v.isAllCheck", isAllCheck);
    }, 
    
    selectAll : function(component, event, helper){
        var fieldOrderTemp;
        var fieldOrderList = component.get("v.filteredfieldOrderList");
       
        for(var counter in fieldOrderList){
            fieldOrderTemp = fieldOrderList[counter];
            
            fieldOrderTemp.isCheck = event.target.checked;
            console.log("fieldOrderTemp.isCheck : ", fieldOrderTemp.isCheck);
        }
        component.set("v.filteredfieldOrderList", fieldOrderList);
        component.set("v.fieldOrderPrint", fieldOrderList);
    },
    
    /*filterList : function(component, event, helper){
        var scheduleDateFilter = component.get("v.scheduleDateFilter");
        var oldScheduleDateFilter = component.get("v.oldScheduleDateFilter")
        
        if((scheduleDateFilter != null && scheduleDateFilter != "" && scheduleDateFilter != undefined) && scheduleDateFilter != undefined && scheduleDateFilter != oldScheduleDateFilter){
            component.set("v.oldScheduleDateFilter", scheduleDateFilter);
            
            var filteredFieldOrderList = helper.filterListHelper(component.get("v.fieldOrderList"), "ScheduleDate", scheduleDateFilter);        
        	component.set("v.filteredfieldOrderList", filteredFieldOrderList);
        } else if(scheduleDateFilter == null || scheduleDateFilter == "" || scheduleDateFilter == undefined){
            component.set("v.filteredfieldOrderList", component.get("v.fieldOrderList"));
            component.set("v.oldScheduleDateFilter", null);
        }
    },*/
    
    print : function(component, event, helper){
      
        var pdf = new jsPDF('p','pt','letter');
        
        var fields = component.get("v.fieldOrderPrint");
        console.log("fields.length : ", fields.length);
        if(fields.length > 0){
            for(var x in fields){
                var imgData = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAD4AAAA2CAYAAACfkiopAAAO1UlEQVRoBeVaCXBVx5U9/Za/aUESi8ACBcxmDIFBWDgMCcYVDNgIV8I2cmKDB5nVNSZjHHCFissOmytVQR6mmClcXoCC4FQSbAwEs9mABvBEowkIiQGzSkIgEwnpS/rrW3rq9td7+l9fYvkSTqrcVeL1v+/27Xv6Ln27H4xzzvEtbNK3ELOA/HcHnNyP48E7ofJNWlwDYHj/CtRdB7y14CGfAMmdHrCUHmA9siCn9YYCBvaAFWMPOsZ1ANrVMzCKPwMrK4J84ytITbfBwkEw04zYV5LBVSd4cjr0Pg+DD38C8vemQ314JB6UZbocOOVKxhgMAIEzR8H3bIRaegyq3wtJcYI5nICkgDMGy6xMeLYJGAZMPQQzFILmSYU2ZiqUWSvhGjQKFJMUAl3lC10PnADfroa29ZdQj/8OLsOA5EkBl+SI83JTWDs+jDmgOMAVh4DITAPc50XQnQztx8vhmL4UzqRuYKxr0lIXAucwwOAvPQb8+2Ik3bgIKTUdnLUAJticQ+eAljUEXGIxSYxJKpjfC9etCjC5xcEZA9NDCPy1HsFf/QFp359pOUmnM0CXhFAkCzP4Tv4BSuECeAwdPK0nYksEBrOpDv5nFsO9ZKMIB3Jeq9GiBX/9U7irzgOelAiZA4bPi/CPFiJ53PQuA03CuwQ4BWtTyWdQfjMfHiaBu5KFdS1Q9GThAIK9+sP5k1VwUHyLFnkS/NDpQ3Cf+hTMnRxZDrJ2UwMCj06Ac+EGqDKFQNe1LgmYALn1OwvgIW92uEWMtlUxHPTB+MkqqGm9o+wc4dIMDfy3a+GEGUl6lMKCPjRnZEJ59QO4XEltxXX6d6eBa6YBY/O/IqnhFrhQsNV9I9oxMF8DgjmT4P7hPJGdLXsTp7D2sZ1wnjsJ7o64ODPCCHIOc9lmOHsP6DTI9gQkDNyCFzi2A66Sz8BS0uLcmyZkpoagwwN53loo5L5RWlA/5PeC/X4DVBd5CsA4h+bzIvTiGnhGT2nXe4ivs9VdwsBp8lA4AGn3JqgOt9hhheYx/zAYzfUI5y2FZ2BODGiLTdv7H3BXlgEOChTAaKqH/+kFSHp2mUhAsUtljQJ000Aw0NhKuM9ep4BrfzkI55UzLS4ePzMLNSPQ71E4Zr0WB5o8xl9bBbb3PyEnpQobspAfvhEToBT8BjA0aP7GNjtD6xzMMODbuQ5aMDHwCQMXxeapT6F0dKrlHEEtDD73LbiS0uJclio7fec6uG9VgYuihInixdFcC+mXT8O35B/QVHoUPDo2WnHDuF0D5cD70K+URlHvvZswcCPYBPlCMVhLbMZMSdtVcwO0cc/CPW5Gy6tYBKGKMvDTR6D3HYpgWi+YVLfKKly3quD4y3HIuVOQOnZanKdY8+gXi+H6uhZG+X/F7RIWz52eCe/j5s3LkOuqhbJxE2hhBJLTIc1d3WGh4OrVH3zDCTDVhUDJPhiFBZBdKdB9Xvim/TPcCza0O5ZChLwNZUVQZUC/WCKAxy5rnEZxhIQtjq8rwcL+2JK0Rbzp88KY8TO4sx6Jm9AiyO5kKN16gnlSIJ3+AjIdUJpuwzf6Kbhe3gTVYmznqetB4PwpMI8K9vVVcD3UDtedSQkD5411oAQT54tBHwKDc6A++y9iz77z9ECo/gakkoOQDQ2+73wX6s+3wOlwx4m15JBljarzUG5cBqNzfHMDaKHvtyUM3Aj54oAxbiJsGGDz1sDpvHu1Jdy25DDkG9fg65ENaeV2uLtlxiXCtqCM8hNQ/E2ALIPrYZjhYFuWu/5OGLhER8g24s2mBgQn5sM5enKHFoseImL1i99Cd7iA17bB029Yy+uOI5bGsLNFkOTIqY+OqfZpLlr4XfoJJzcphY6crQoyLQR/94fgeOFNRB1E7zi9XlkO4+xR8Nfeh2fED9osFi1rq3xLkO5rgHzlDBidCegGx+WBRIei+2wJW5z36geTJufCbtADzTDmrICrR3Y76kZq8uhjKsEKHNoKPnM5kib+NCZsxB4vrqVi0dAY7eKfIddeB1dVUeSYaZlgLTV+LPedfyUMnD00GEZaL5HguL8R/uE/gHPqgjjQVFPT0njLjsPUArY2wcY66L0fRvK81TFjws318J74pN0rJrHEZ4ugUFYHA9fCMPsNaznb26LvqZMwcCW5O8xBo4FAM8KSDHner+CQ1bjDA9XaoarzMD78BbhJtow0yhHdJs+HHGXrsBZEYN0/wVV/A7IkxecQqhL/7xQk1SkWiy4vMHx8lARL+t2fCQMXA8dNh+YNIzS5AM5Hvy+UaXuoIKjGJ4XwXDsLHmi2NXJ6UqCqrZcLoVAA2vrn4CgvgvJ4nuBrG+HGrauQKs8BqgvQNWjd+0AZNdGWeT+dTgF3jZmKxvGT4J798w6rrMCV/4VydCdkxmHevtmubqFgM7S3n4Pn2CfAyCcg9cxul888/9+QG+sAWYEZaIKemwdnela7vHcjJgycBCvJPeD5xe+gdG9/crpTFzcrWhBM18GpxLVbZDMMBZoQXv8c3MV7ALcCowPXJc/hFN803tARdKdAzluSkJuTiE4BJwHulIwOhYRL9sNZ/CewpPRIBr5VERW3DCF/A8Lr5iCpZD/klB7QHW5IIybYSxPd0ejsf+HPkJxumM23oU19Cep3hkez3Fc/4X38brOE6MPAzvVQKEkxJj4L6TVXRYan1Q4110Mn0KVHwVJ7gGsh6L2yoQ7MaXchzYqzUGouA+EgfIPGwJ2/6o71/N3067TFO5og9PkOuOggYd2j0deTryvFFxaxla2eBU/pF2Cp3SMiQgEYQ8ZA7mBPNsu/hFLfAH9SBqRl78LhocuLxFuXA6fIpb1Y/mMhVFfkOkmop8jiQBGurYaxdjaSzh0HS+1pa65zDv696e1bm3bt//kTQh4PzBXb4X54dNy2aQu6x06XuzolId/vf43UK2VAr972BSRXXZBqr0NbPRMpFaVAag/7HX1hAV0/XStHwNdkf0ykIoW+w5l11dDraiGv3QvPd59sWZy2m909Im5h68JPSBGJohQtOQDz/RVwVZRB8aSKL6Gi7jZ1QA+3XCxGsnqrugwmXR7q9DGZqgEOHtKghYHwuB9C/dl7cGX2Fye3trVCq4x773U5cGvqoK8B4d3/BuXwNjhuVUJSFEh0k6ooHdzIRq6WCTgP+UFbYXBgDvCjV+B+Il9YOVLLdc7Sln4PDDhNQLV1sL4G5qlPgeL9kK6VQvHWQNZ0cX9uHe6onueQYDpc0DIegjF0DNg/zoSS+zScqiumlrcU7+zzgQInOBGnjSyCXl8DOoqi5ipwuwYI+iLHNrcHvPtDkLKGQM0eDjm6NqD4t1aos2ijxj9Q4FHz2F3yAnLW6AinrYV+01+XbzP2zLGdbxx47PR/u1/f1AL/7RB2MPNd9/Gqqir4/X707dsXSUmRC8Tq6mo0NzdjwIABqK2tRVNTk30ZIEkSMjMzUVNTIz7/0K2LqqrIzs6GosROd+nSJciyLORY+lVUVCAYDKJPnz5ITY2tzrxeL8rKyqDrOh555BExjzXOepIu5eXlME1T8GRkZFivYp/0v546amVlZTwtLY0zxnhRUZFg++qrr3hGRoagXbhwgc+ZM0f0o8KU79q1i3s8HitsxXP48OH8yJEj9lSnT5/msizzpKQkXlVVZdMff/xxwb9jxw6bRp3CwkLep08fW2a3bt34ypUruWEYNt8777zDs7KybJ6ePXvy1atX2++jO2SVdpuu6/yxxx6zhZw6dUrwTZgwwaadP3+ez5gxQ/weMWKE6D///PP8wIEDXJIkQR81apRYKFoYUqShoUHIWbx4sS1nzZo1tg5jxowR9O3bt9u09evX27zZ2dl80KBB9u/58+cLvrffftumEc+AAQPs38uXL7dlWZ0Ogb/xxhv2QFL64sWL/IMPPoihkcVnz54taNu2bbNk8nPnzglaenq6sEhtba0Nvri4mAcCAU4Ws7yEgGiaJsaPHTtW0C2LV1ZWclVVBe3NN98UY8nKH374oT1+y5Yttrx169bxYDAo5G3atMn2xtLSUls/6rQL/OTJk/YAmpRc8t133+UEhJR1OBziGQ185MiRwuIvvPACP3TokHhP/NSuX7/OU1NTBY367733nuiTdS3L7N+/X/C2BU6WpznJc9o20pO866233hI8ubm5bVn4U089Jd5RqES3uKxOiaWgoEAkpsWLF2PYsGGiv2LFCtTX12PRokUYMmRIbKIAUFpail27dmH79u0i8VFCa2xsxIQJE5CTkyP6+fn5yMrKQmFhoRi/YcMGrFy5UvQ3b94snnQoiW6UWKmlp6dHk0V/3LhxmDx5Mvr3pxoeSEujz9GxrXv3yLE3EGi94RUc0atA/VdeeUWs0NChQ7nX6+WDBw8Wv2nVLdrAgQMFLdriFKfk0nV1dZwSF8W4Fec0dtasWWIqyxuI9uqrr/KXXnpJyCIvqq6u5k8++aT4vXv3bsFPIUa8LpeLHzt2zFb30qVLfOrUqZyS4caNG7miKNztdvPjx4/bPGfOnBHJmcYfPHjQplMnxtUPHz4sJiFGS0C/fv1smjVx3759BS0aeEFBAf/444/53r17+ZdffineU+y+/vrrop+Tk8N9Pp+dE2iOtn9r167l06ZNE/SXX36Zk5vv27ePP/PMM4JGwBYuXMiXLVvGMzMzBa1///68sbGR5+fn2zyU8BYtWmSH18SJEzkl6+hmA798+bK9BS1dulTwUBKytqUlS5YIGiUO2oJIaUpiU6ZMEf1oEB999JGgOZ1OkWjGjx8vfkdnY4q5zz//XPytWrVKvKecEL0dWTJv3rxpL4hFoyctJnkEtfr6ep6XlxenC3kQjW/b7JK1pKQER44cgcfjwYsvvojk5GRomoYtW7aIAmb+/PlISUkRxcPWrVtFHM+dOxcnT54EFSJWczqdmDRpEvbt2weXyyVywrVr17B79274fD7QeyqEKH9YLRQKgWKcChMqcqI/NZE+CxYsEKx79uxBUVGR0Cs3NxczZ84U8iw59Dx06BBOnDghCpixY8ciLy8v+rXdt4HblG9JJy6rf0twf2OnwL+79fx/xfiaTMow1eMAAAAASUVORK5CYII=';
                pdf.addImage(imgData, 'png', 510, 35, 50, 50)
                
                pdf.setFontSize(20);
                pdf.setFont("times");
                pdf.setFontType("bold");
                pdf.setTextColor('#000');
                pdf.text(50,50, 'FIELD ORDER');
                
                pdf.setFontSize(15);
                pdf.setFont("times");
                pdf.setFontType("normal");
                pdf.setTextColor('#000');
                pdf.text(50,65, fields[x].fieldOrderName);
                
                var col = 50;
                var row = 60;
                var address = '';
                var section = '';
                var sectionCount = 0;
                var fieldCount = 1;
                for(var y in fields[x].fieldValues){
                    if(section != fields[x].fieldValues[y].section){
                        fieldCount = 1;
                        
                        row += 40;
                        col = 50;
                        
                        pdf.setFontSize(12);
                        pdf.setFontStyle('Bold');
                        pdf.setFont("times");
                        pdf.setTextColor('#000');
                        pdf.text(col,row, fields[x].fieldValues[y].section);
                        
                        row += 30;
                        
                        if(sectionCount == 0){
                            pdf.setFontSize(10);
                            pdf.setFont("times");
                            pdf.setFontStyle('Bold');
                            pdf.setTextColor('#000');
                            pdf.text(col,row, 'Address');
                            
                            row += 15;
                            
                            pdf.setFontSize(8);
                            pdf.setFont("times");
                            pdf.setFontStyle('normal');
                            pdf.setTextColor('#4a4a56');
                            pdf.text(col,row, pdf.splitTextToSize(fields[x].address, 500));
                            
                            row += 20;
                            
                            pdf.setFontSize(10);
                            pdf.setFont("times");
                            pdf.setFontStyle('Bold');
                            pdf.setTextColor('#000');
                            pdf.text(col,row, 'Landmarks');
                            
                            row += 15;
                            
                            pdf.setFontSize(8);
                            pdf.setFont("times");
                            pdf.setFontStyle('normal');
                            pdf.setTextColor('#4a4a56');
                            pdf.text(col,row, pdf.splitTextToSize(fields[x].landmark, 500));
                        }else if(fields[x].fieldValues[y].fieldName.includes('Instructions') || fields[x].fieldValues[y].fieldName.includes('Resolution Remarks')){
                            pdf.setFontSize(10);
                            pdf.setFont("times");
                            pdf.setFontStyle('Bold');
                            pdf.setTextColor('#000');
                            pdf.text(col,row, fields[x].fieldValues[y].fieldName);
                            
                            row += 15;
                            
                            pdf.setFontSize(8);
                            pdf.setFont("times");
                            pdf.setFontStyle('normal');
                            pdf.setTextColor('#4a4a56');
                            
                            if(fields[x].fieldValues[y].fieldName.includes('Instructions')){
                                pdf.text(col,row, pdf.splitTextToSize(fields[x].fieldValues[y].fieldValue, 500));
                                row+=5;
                            }else{
                                pdf.setLineWidth(0.8)
                                pdf.line(col, row+30, col+505, row+30)
                                
                                row += 20;
                            } 
                        }else if(fields[x].fieldValues[y].section.includes('Additional')){
                            row -= 15;
                        }
                        
                        sectionCount++;
                    }
                    
                    section = fields[x].fieldValues[y].section;
                    
                    if(!(fields[x].fieldValues[y].fieldName.includes('Instructions') || fields[x].fieldValues[y].fieldName.includes('Resolution Remarks'))){
                        if(fieldCount % 3 === 1){
                            col = 50;
                            row += 20;
                        }else{
                            col += 180;
                            row -= 15;
                        }
                        
                        if((fields[x].fieldValues[y].section.includes('Instructions') && !(fields[x].fieldValues[y].fieldName === 'Re-Inspection Result')) || 
                           (fields[x].fieldValues[y].section === 'Resolution Details' && !(fields[x].fieldValues[y].fieldName.includes('Result')))){
                            pdf.rect(col, row-8, 8, 8);
                            col += 10;
                            
                            pdf.setFontSize(10);
                            pdf.setFont("times");
                            pdf.setFontStyle('Bold');
                            pdf.setTextColor('#000');
                            
                            var str = pdf.splitTextToSize(fields[x].fieldValues[y].fieldName, 130);
                            
                            if(str.length > 1){
                                pdf.text(col,row, str[0] + '...');
                            }else{
                                pdf.text(col,row, str[0]);
                            }
                        }else{
                            pdf.setFontSize(10);
                            pdf.setFont("times");
                            pdf.setFontStyle('Bold');
                            pdf.setTextColor('#000');
                            
                            pdf.text(col,row, fields[x].fieldValues[y].fieldName);
                        }
                        
                        row += 15;
                        
                        if(fields[x].fieldValues[y].fieldName.includes('Result') && fields[x].fieldValues[y].section === 'Resolution Details'){
                            pdf.setLineWidth(0.8)
                            pdf.line(col, row+10, col+505, row+10)
                            row += 5;
                            col = 50;
                        }else if(fields[x].fieldValues[y].section.includes('Additional')){
                            pdf.setLineWidth(0.8)
                            pdf.line(col, row+10, col+150, row+10)
                            fieldCount++;
                        }else if(fields[x].fieldValues[y].section.includes('Instructions') && !(fields[x].fieldValues[y].fieldName === 'Re-Inspection Result')){
                            if(fields[x].fieldValues[y].fieldValue === 'true'){
                                pdf.line(col-10, row-22, col-6, row-17);
                                pdf.line(col-6, row-17, col+2, row-25);
                            }
                            
                            col -= 20;
                            fieldCount++;
                        }else if(fields[x].fieldValues[y].section === 'Resolution Details' && !(fields[x].fieldValues[y].fieldName.includes('Result'))){
                            col -= 20;
                            fieldCount++;
                        }else if(fields[x].fieldValues[y].fieldName === 'Re-Inspection Result'){
                            pdf.setFontSize(8);
                            pdf.setFont("times");
                            pdf.setFontStyle('normal');
                            pdf.setTextColor('#4a4a56');
                            pdf.text(col,row, fields[x].fieldValues[y].fieldValue);
                            
                            col = 50;
                        }else{
                            pdf.setFontSize(8);
                            pdf.setFont("times");
                            pdf.setFontStyle('normal');
                            pdf.setTextColor('#4a4a56');
                            pdf.text(col,row,  pdf.splitTextToSize(fields[x].fieldValues[y].fieldValue, 170));
                            
                            fieldCount++;
                        }
                    }
                }
                
                if(x < fields.length-1){
                    pdf.addPage();
                }
            }
            
             pdf.output('datauri');
        } else {
            helper.showToast(component, "error", "Error!", "Please select records before printing.");
        }
    },
    
    catchFilteredFieldOrderList : function(component, event, helper){
        console.log("event.getParams().fieldOrderList ", event.getParams().fieldOrderList);
        component.set("v.filteredfieldOrderList", event.getParams().fieldOrderList);
    },
    
    afterScriptsLoaded: function(component, event, helper){
        
    },
    
    openActionWindow : function(component, event, helper) {
        var foList = component.get("v.fieldOrderPrint");
        if(foList.length > 0){
            var foIdsParam = '';
            var counter = 0;
            for(var fo in foList){
            	foIdsParam += foList[fo].fieldOrderId + ';';
                counter++;
        	}
            var vfLink = $A.get("$Label.c.CXE_FOPrintLink");
            window.open(vfLink + "/apex/CXE_FOPrintingPDF?foIdList=" + foIdsParam);
        }else {
            helper.showToast(component, "error", "Error!", "Please select records before printing.");
        }
	}
})