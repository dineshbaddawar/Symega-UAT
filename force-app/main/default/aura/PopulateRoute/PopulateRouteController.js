({
    doInit : function(component, event, helper) { 
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        // call the helper function
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
        
        var action = component.get("c.populateRoute");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var routeMap = response.getReturnValue();           
                component.set("v.routeMap", routeMap);
                component.set('v.loaded', true);
            } else {
                console.log("Error in fetching route data");
                component.set('v.loaded', true);
            }
        });
        $A.enqueueAction(action);
        
        var action1  =component.get("c.getSalesUser");
        action1.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){ 
                component.set('v.salesUsers', response.getReturnValue());
            }
            else {
                console.log("Error in fetching route data");
            }
        });
        $A.enqueueAction(action1);
        
        
    },
    
    onCityFieldChange: function(component, event, helper){
        var cityValue = event.getSource().get("v.value");
        var stateValue = component.get("v.selState");
        component.set("v.selCity", cityValue);
        var routeMap = component.get("v.routeMap");
        
        // Check if stateValue is defined in routeMap
        if (routeMap && routeMap[stateValue]) {
            var CityRouteMap = routeMap[stateValue];
            var routeList = CityRouteMap[cityValue];
            component.set("v.RouteObjectList", routeList);
        } else {
            console.log("State value is not defined in routeMap");
        }
        
        // Pass the selected city to the server-side controller
        var action = component.get("c.populateRoute");
        action.setParams({
            "city1": cityValue,
            "state1": stateValue
        });
        $A.enqueueAction(action);
        component.set("v.showRouteName", true);
        
    },
       
    
    onUserFieldChange: function(component, event, helper){
        debugger;
        var userValue = event.getSource().get("v.value");
        component.set("v.selUser", userValue);
    },
    
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        component.set("v.selState", controllerValueKey);
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
            var action = component.get("c.populateRoute");
            action.setParams({
                "city1": component.get("v.selCity"),
                "state1": controllerValueKey
            });
            $A.enqueueAction(action);
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    
    toggleRouteMaster : function(component, event, helper) {
        // Toggle the visibility of components
        component.set("v.showCreateRouteMaster", true);
    },
    
    handleBackEvent: function(component, event, helper) {
        var backEvent = component.getEvent("backEvent");
        if (backEvent) {
            backEvent.fire();
        }
    },
    
    childComponentEvent: function(cmp, event, helper) {
        var cmpEvent = cmp.getEvent("populateRouteEvent");
        var stateValue = cmp.get("v.state");
        var cityValue = cmp.get("v.city");
        cmpEvent.setParams({
            "state": stateValue,
            "city": cityValue
        });
        cmpEvent.fire();
    },
    
    handleComponentEvent : function(cmp, event, helper) {
        debugger;
        var message = event.getParam("message");
        
        cmp.set("v.selRouteNameId", message);
        
        var isBack = event.getParam("handleBackFromCreateRouteMaster");
        if(isBack){
            cmp.set('v.showCreateRouteMaster', false);
        }
    },
    
    saveDataToRouteObject: function(component, event, helper) {
        debugger;
        var routeToSave = component.get("v.objDetail");
        var action = component.get("c.saveRoute");
        action.setParams({
            "city": routeToSave.City__c,
            "state": routeToSave.State__c,
            "routeName": routeToSave.Route_Master__c,
            "salesUser": routeToSave.Sales_User__c
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Display success toast message
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Route saved successfully",
                    "type": "success"
                });
                toastEvent.fire();
                component.set('v.loaded', true);
                helper.closeModal(component, event, helper);
                
            } else {
                // Display error toast message
                var errors = response.getError();
                var errorMsg = "Unknown error"; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0 && errors[0].message) {
                    errorMsg = errors[0].message;
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error saving route: " + errorMsg,
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    closeModel: function(component, event, helper) {
      helper.closeModal(component, event, helper);
    }


    
})