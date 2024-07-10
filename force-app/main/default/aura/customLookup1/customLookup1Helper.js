({
    searchRecordsHelper: function(component, event, helper, searchString, profile, condField) {
        debugger;
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
        component.set('v.message', '');
        component.set('v.recordsList', []);
        
        // Calling Apex Method
        var action = component.get('c.fetchSalesUsers');
        action.setParams({
            'objectName': component.get('v.objectName'),
            'filterField': component.get('v.fieldName'),
            'searchString': searchString,
            'profileName': profile,
            'condnField': condField
        });
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if (response.getState() === 'SUCCESS') {
                if (result.length > 0) {
                    component.set('v.recordsList', result);
                } else {
                    component.set('v.message', "No Records Found for '" + searchString + "'");
                }
            } else {
                // If server throws any error
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set('v.message', errors[0].message);
                }
            }
            
            // To open the drop-down list of records
            $A.util.addClass(component.find('resultsDiv'), 'slds-is-open');
            $A.util.addClass(component.find("Spinner"), "slds-hide");
        });
        
        $A.enqueueAction(action);
    },

    
    userRouteRecordsHelper: function(component, event, helper, value) {
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
        var searchString = component.get("v.searchString");
        var city = component.get("v.city");
        var state = component.get("v.state");
        
        component.set("v.message", "");
        component.set("v.recordsList", []);
        
        // Calling Apex Method
        var action = component.get("c.fetchUsersRoute");
        action.setParams({
            objectName: component.get("v.objectName"),
            filterField: component.get("v.fieldName"),
            searchString: searchString,
            city: city,
            state: state
        });
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if (response.getState() === "SUCCESS") {
                if (result.length > 0) {
                    // To check if value attribute is prepopulated or not
                    if ($A.util.isEmpty(value)) {
                        component.set("v.recordsList", result);
                    } else {
                        component.set("v.selectedRecord", result[0]);
                    }
                } else {
                    component.set(
                        "v.message",
                        "No Records Found for '" + searchString + "'"
                    );
                }
            } else {
                // If server throws any error
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set("v.message", errors[0].message);
                }
            }
            // To open the drop-down list of records
            if ($A.util.isEmpty(value)) {
                $A.util.addClass(component.find("resultsDiv"), "slds-is-open");
            }
            $A.util.addClass(component.find("Spinner"), "slds-hide");
        });
        $A.enqueueAction(action);
    },
    
    childComponentEvent : function(component, event, helper,SelectedId) { 
        debugger;
        var cmpEvent = component.getEvent("sampleCmpEvent"); 
        var value=SelectedId;
        cmpEvent.setParams({
            "message" : value
        }); 
        cmpEvent.fire(); 
    }
})
/*
 Code by CafeForce
 Website: http://www.cafeforce.com
 DO NOT REMOVE THIS HEADER/FOOTER FOR FREE CODE USAGE
*/