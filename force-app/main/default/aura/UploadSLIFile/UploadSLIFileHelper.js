({
    readFile: function(component, helper, file) {
        debugger;
        if (!file) return;
        console.log('file'+file.name);
        if(!file.name.match(/\.(csv||CSV)$/)){
            return alert('only support csv files');
        }else{
            
            reader = new FileReader();
            reader.onerror =function errorHandler(evt) {
                switch(evt.target.error.code) {
                    case evt.target.error.NOT_FOUND_ERR:
                        alert('File Not Found!');
                        break;
                    case evt.target.error.NOT_READABLE_ERR:
                        alert('File is not readable');
                        break;
                    case evt.target.error.ABORT_ERR:
                        break; // noop
                    default:
                        alert('An error occurred reading this file.');
                };
            }
            //reader.onprogress = updateProgress;
            reader.onabort = function(e) {
                alert('File read cancelled');
            };
            reader.onloadstart = function(e) { 
                debugger;
                var output = '<ui type=\"disc\"><li><strong>'+file.name +'</strong> ('+file.type+')- '+file.size+'bytes, last modified: '+file.lastModifiedDate.toLocaleDateString()+'</li></ui>';
                component.set("v.newfileName",file.name);
                component.set("v.TargetFileName",output);
                
            };
            reader.onload = function(e) {
                var data=e.target.result;
                component.set("v.fileContentData",data);
                console.log("file data"+JSON.stringify(data));
                var allTextLines = data.split(/\r\n|\n/);
                var dataRows=allTextLines.length-1;
                var headers = allTextLines[0].split(',');
                console.log("Rows length::"+dataRows);
                
                var columnsToExclude = [];
                 var filteredHeaders = headers.filter(function(header) {
                    return !columnsToExclude.includes(header.trim());
                });
                
                var filteredDataRows = [];
                
                // Start from index 1 to skip the header row
                for (var i = 1; i < allTextLines.length; i++) {
                    var columns = allTextLines[i].split(',');
                    var filteredData = {};
                    
                    for (var j = 0; j < filteredHeaders.length && j < columns.length; j++) {
                        if (!columnsToExclude.includes(headers[j].trim())) {
                            filteredData[filteredHeaders[j].trim()] = columns[j];
                        }
                    }
                    filteredDataRows.push(filteredData);
                }
                
                console.log("Filtered headers: " + JSON.stringify(headers));
                console.log("Filtered data rows: " + JSON.stringify(filteredDataRows));
                
                var numOfRows=component.get("v.NumOfRecords");
                if(dataRows > numOfRows+1 || dataRows == 1 || dataRows== 0){
                    alert("File Rows between 1 to .");
                    component.set("v.showMain",true);
                    
                } 
                else{
                    var lines = [];
                    var filecontentdata;
                    var content = "<table style=\"table-layout: fixed; width: 100%\" class=\"table slds-table slds-table--bordered slds-table--cell-buffer\">";
                    content += "<thead><tr  class=\"slds-text-title--caps\">";
                    for(i=0;i<filteredHeaders.length; i++){
                        content += '<th class=\"slds-truncate\" scope=\"col"\>'+filteredHeaders[i]+'</th>';
                        console.log('filteredHeaders[i] -- ', filteredHeaders[i]);
                    }
                    content += "</tr></thead><tbody>";
                    for (var i = 0; i < filteredDataRows.length-1; i++) {
                        var rowData = filteredDataRows[i];
                        content += '<tr>';
                        for (var j = 0; j < filteredHeaders.length; j++) {
                            var columnName = filteredHeaders[j];
                            content += '<td>' + rowData[columnName] + '</td>';
                        }
                        content += '</tr>';
                    }
                    content += '</tbody></table>';
                    component.set("v.TableContent",content);
                    component.set("v.showMain",false);                   
                }
            }
            reader.readAsText(file);
            
        }
        var reader = new FileReader();
        reader.onloadend = function() {
            
        };
        reader.readAsDataURL(file);
    },
    
    saveRecords : function(component,event){
        debugger;
        
        component.set("v.showError",true);
        var action = component.get("c.uploadFinalResult"); // apex method name
        // var recId = component.get("v.recordId");
        var fieldsList=['SLI_Id', 'Release_Status', 'Sample_Invoice_Date', 'Actual_Date_Of_Dispatch', 'Courier', 'Dispatch_Details', 'Way_Bill_No','Additional_Comments'];
        var extraData = component.get("v.fileContentData");
        var allTextLines = extraData.split(/\r\n|\n/);
        var dataRows=allTextLines.length;
        var headers = allTextLines[0].split(',');
        var fieldsList = headers;
        
        action.setParams({ fileData : component.get("v.fileContentData"),
                          sobjectName:'Sample_Line_Item__c', //Any object
                          fields:fieldsList});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                component.set("v.loading", false);
                component.set("v.showMain",true);
                /*var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "message": 'Records saved successfully.'
                });
                
                resultsToast.fire();*/
                component.set("v.loading", false);
                
                // Close the action panel
                //var dismissActionPanel = $A.get("e.force:closeQuickAction");
                //dismissActionPanel.fire();
                
                component.set("v.showError",false);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.showError",false);
                        console.log("Error message: " + 
                                    errors[0].message);
                        /*var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type": 'warning',
                            "message": errors[0].message
                        });
                        toastEvent.fire();*/
                    }
                } else {
                    component.set("v.showError",false);
                    console.log("Unknown error");
                }
            }
            var currPageURL = window.location.href; 
            window.location.assign(currPageURL);
        });
        $A.enqueueAction(action);
    }
});