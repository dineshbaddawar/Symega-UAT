({
    convertArrayToCSV : function(component, metaDataRecord){
        debugger;
        // if (sObjectList == null || sObjectList.length == 0) {
        //     return null;  
        // } 
                
        var columnEnd = ',';
        var lineEnd =  '\n';
        
        var keys = ['SLI_Id', 'Release_Status', 'Sample_Invoice_Date', 'Actual_Date_Of_Dispatch', 'Courier', 'Dispatch_Details', 'Way_Bill_No','Additional_Comments'];

        var csvString = '';
        csvString += keys.join(columnEnd);
        csvString += lineEnd;
        // for(var i=0; i < sObjectList.length; i++){
        //     var counter = 0;
        //     for(var sTempkey in keys) {
        //         var skey = keys[sTempkey];
        //         // add , after every value except the first.
        //         if(counter > 0){
        //             csvString += columnEnd;
        //         }
        //         // If the column is undefined, leave it as blank in the CSV file.
        //         var value = sObjectList[i][skey] === undefined ? '' : sObjectList[i][skey];
        //         csvString += '"'+ value +'"';
        //         counter++;
        //     }
        //     csvString += lineEnd;
        // }
        return csvString;

    }
})