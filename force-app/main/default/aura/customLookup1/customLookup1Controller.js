({
    // To prepopulate the seleted value pill if value attribute is filled
    doInit : function( component, event, helper ) {
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        var city = component.get('v.city');
        var state = component.get('v.state');
        if (!$A.util.isEmpty(city) && !$A.util.isEmpty(state)) {
            // Call userRouteRecordsHelper with city and state
            helper.userRouteRecordsHelper(component, event, helper,'');
        } else if (!$A.util.isEmpty(component.get('v.value'))) {
            // Call searchRecordsHelper if value is not empty
            helper.searchRecordsHelper(component, event, helper, component.get('v.value'));
        }
    },
    
    // When a keyword is entered in search box
    searchRecords: function(component, event, helper) {
        debugger;
        var city = component.get('v.city');
        var state = component.get('v.state');
        var searchString = component.get('v.searchString');
        
        if (!$A.util.isEmpty(searchString)) {
            if (!$A.util.isEmpty(city) && !$A.util.isEmpty(state)) {
                // Call userRouteRecordsHelper with city and state
                helper.userRouteRecordsHelper(component, event, helper, '');
            } else {
                helper.searchRecordsHelper(component, event, helper, searchString, 'Sales User', 'Profile.Name');
            }
        } else {
            $A.util.removeClass(component.find('resultsDiv'), 'slds-is-open');
        }
    },

    
    // When an item is selected
    selectItem : function( component, event, helper ) {
        debugger;
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            var recordsList = component.get('v.recordsList');
            var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
            if(index != -1) {
                var selectedRecord = recordsList[index];
            }
            component.set('v.selectedRecord',selectedRecord);
            component.set('v.value',selectedRecord.value);
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
            helper.childComponentEvent( component,event, helper,selectedRecord.value);
            
        }
    },
    
    showRecords : function( component, event, helper ) {
        if(!$A.util.isEmpty(component.get('v.recordsList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
            $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    
    // To remove the selected item.
    removeItem : function( component, event, helper ){
        component.set('v.selectedRecord','');
        component.set('v.value','');
        component.set('v.searchString','');
        setTimeout( function() {
            component.find( 'inputLookup' ).focus();
        }, 250);
    },
    
    // To close the dropdown if clicked outside the dropdown.
    blurEvent : function( component, event, helper ){
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    },
    
    routeComponentEvent: function(component, event, helper) {
        debugger;
        var stateValue = event.getParam("state");
        var cityValue = event.getParam("city");
        var action = component.get("c.fetchUsersRoute");
        action.setParams({
            "state": stateValue,
            "city": cityValue
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Handle the successful response and update component attributes accordingly
                var data = response.getReturnValue();
                // Update component attributes or perform other operations based on the data received
            } else {
                // Handle errors or display error messages
            }
        });
        $A.enqueueAction(action);
    }
})
/*
 Code by CafeForce
 Website: http://www.cafeforce.com
 DO NOT REMOVE THIS HEADER/FOOTER FOR FREE CODE USAGE
*/