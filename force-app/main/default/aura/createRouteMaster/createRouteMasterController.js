({
    doInit : function(component, event, helper) { 
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        // call the helper function
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
    },
    
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    
    save: function(component, event, helper) {
        // Get the text input value
        var toastEvent = $A.get("e.force:showToast");
        var textInputValue = component.get("v.routeNameValue");
        var city = component.get("v.objDetail.City__c");
        var state = component.get("v.objDetail.State__c");
        
        // Call the Apex controller method to update the text
        var action = component.get("c.createRouteMaster");
        action.setParams({
            "routeName": textInputValue,
            "city": city,
            "state": state
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                toastEvent.setParams({
                    title: 'Success',
                    message: 'Route Master Created successfully',
                    duration: '5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                
                // Refresh the view after a delay to allow time for the user to read the success message
                setTimeout($A.getCallback(function() {
                    $A.get("e.force:refreshView").fire();
                }), 2000); // 2000 milliseconds delay
            } else {
                toastEvent.setParams({
                    title: 'Error',
                    message: 'Error Creating Route Master',
                    duration: '5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            //self.handleBack(component, event, helper);
            helper.handleBackFunction(component);  
        });
        $A.enqueueAction(action);
    },

    
    handleBack: function(component, event, helper) {
        debugger;
        /*var cmpEvent = component.getEvent("sampleCmpEvent"); 
        cmpEvent.setParams({
            "handleBackFromCreateRouteMaster" : true
        }); 
        cmpEvent.fire();*/
        
        setTimeout($A.getCallback(function() {
                    $A.get("e.force:refreshView").fire();
                }), 10);
        
    },
    
    closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
})