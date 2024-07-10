({
    getVisitRecord : function(component, event, helper){
        debugger;
        var visitRecId = component.get('v.visitId');
        var baseURL = $A.get("$Label.c.orgBaseURLforVFPages");
        baseURL = baseURL + 'apex/docCategories?id='+visitRecId;
        //console.log('baseURL === >'+baseURL);
        component.set("v.siteURL",baseURL);
        var action = component.get('c.getSelectedVisitDetails');
        action.setParams({
            visitId :  visitRecId
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.visitRec', result);
                //component.set('v.leadId', result.Lead__c);
                var street = '';
                var city = '';
                var state = '';
                var zipCode = '';

                if(result.Account__c){
                    component.set('v.accID', result.Account__c);
                    street = result.Account__r.BillingStreet;
                    city = result.Account__r.BillingCity;
                    state = result.Account__r.BillingState;
                    zipCode = result.Account__r.BillingPostalCode;
                }
                else{
                    component.set('v.accID', result.Lead__c);
                    street = result.Lead__r.Street;
                    city = result.Lead__r.City;
                    state = result.Lead__r.State;
                    zipCode = result.Lead__r.PostalCode;
                }
                var fullAddress = street + ', ' + city + ', ' + state+ '- ' + zipCode;


                component.set('v.accountAddress', fullAddress);
                if(result.Check_Out__Latitude__s != null && result.Check_Out__Latitude__s != undefined && result.Check_Out__Latitude__s != ''){
                    component.set("v.ShowCheckInButton",true);
                    component.set("v.ShowCheckOutButton",true);
                }
                if((result.CheckIn__Latitude__s != null && result.CheckIn__Latitude__s != undefined && result.CheckIn__Latitude__s != '')&&(result.Check_Out__Latitude__s == null || result.Check_Out__Latitude__s == undefined || result.Check_Out__Latitude__s == '')){
                    component.set("v.ShowCheckInButton",true);
                    component.set("v.ShowCheckOutButton",false);
                    component.set("v.showPopupModal",false);
                }
                else{
                    component.set("v.showPopupModal",true);
                }
            } 
            
        });
        $A.enqueueAction(action);
    },
    
    getPastVisitRecord : function(component, event, helper){
        debugger;
        var accountId = component.get('v.accID');
        var action = component.get('c.getPastVisitDetails');
        action.setParams({
            accId : accountId 
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.pastVisitList', result);
            } 
            
        });
        $A.enqueueAction(action);
    },
    
    getAccRelatedOppList : function(component, event, helper){
        debugger;
        var accountId = component.get('v.accID');
        var action = component.get('c.getRelOppList');
        action.setParams({
            accId : accountId
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.relOppList', result);
            } 
            
        });
        $A.enqueueAction(action);
    },

    getAccRelatedSampleList : function(component, event, helper){
        debugger;
        var accountId = component.get('v.accID');
        var action = component.get('c.getRelSampleProjectList');
        action.setParams({
            accId : accountId,
            recordType : 'Sample'
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.relSampleList', result);
            } 
            
        });
        $A.enqueueAction(action);
    },

    getAccRelatedProjectList : function(component, event, helper){
        debugger;
        var accountId = component.get('v.accID');
        var action = component.get('c.getRelSampleProjectList');
        action.setParams({
            accId : accountId,
            recordType : 'Project'
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.relProjectList', result);
            } 
            
        });
        $A.enqueueAction(action);
    },
    
    getRelatedActivityList : function(component, event, helper){
        debugger;
        var accountId = component.get('v.accID');
        var action = component.get('c.getRelTaskList');
        action.setParams({
            accId : accountId
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.relActivityList', result);
            } 
            
        });
        $A.enqueueAction(action);
    },
    
    getRelatedInvoiceList : function(component, event, helper){
        debugger;
        var accountId = component.get('v.accID');
        var action = component.get('c.getRelInvoiceList');
        action.setParams({
            accId : accountId
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.relInvoicesList', result);
            } 
            
        });
        $A.enqueueAction(action);
    },
    
    getRelatedCaseList : function(component, event, helper){
        debugger;
        var accountId = component.get('v.accID');
        var action = component.get('c.getRelCaseList');
        action.setParams({
            accId : accountId
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.relCaseList', result);
            } 
            
        });
        $A.enqueueAction(action);
    },

    createDayVisit : function (component, lat, long){
        debugger;
        //alert('HIII');

        var visitRecId = component.get('v.visitId');
        var action = component.get("c.StartDayVisitForNewVisits");
        action.setParams({
            startLat: lat,
            startLang: long,
            visitId: visitRecId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue(); 
                if (data != null) {                   
                }
            } 
            else if (state === "ERROR") {
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            } 
            else if (state === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
        })
        $A.enqueueAction(action);
    },

    
    CheckInVisithelper : function(component,lat,long){
        debugger;
        var toastEvent = $A.get("e.force:showToast");
        var visitRecId = component.get('v.visitId');
        var action = component.get("c.checkInUpdateVisit");

        

        action.setParams({
            checkInLat: lat,
            checkInLang: long,
            recId: visitRecId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.spinner', false);
                var data = response.getReturnValue(); 
                if(data !=null){
                     component.set("v.ShowCheckInButton",true);
                     component.set("v.ShowCheckOutButton",false);
                }
                //alert('Check In Done Successfully');
                toastEvent.setParams({
                     title : 'Success',
                     message: 'Checked In Successfully',
                     duration:' 5000',
                     key: 'info_alt',
                     type: 'success',
                     mode: 'pester'
                 });
            } 
            else if (state === "ERROR") {
                component.set('v.spinner', false);
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            } 
            else if (state === "INCOMPLETE") {
                component.set('v.spinner', false);
                alert('No response from server or client is offline.');
            }
            component.set('v.spinner', false);
            toastEvent.fire();
        })
        $A.enqueueAction(action);
    },
    
    CheckOutVisithelper: function(component,lat,long){
        debugger;
        var toastEvent = $A.get("e.force:showToast");
        var visitRecId = component.get('v.visitId');
        var action = component.get("c.checkOutUpdateVisit");
        action.setParams({
            checkOutLat: lat,
            checkOutLong: long,
            recId: visitRecId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if (data != null) {
                    component.set("v.ShowCheckInButton", true);
                    component.set("v.ShowCheckOutButton", true);
                }
                toastEvent.setParams({
                    title: 'Success',
                    message: 'Checked Out Successfully',
                    duration: '5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                
                // Callback function to reload the page and navigate to the child component
                var reloadCallback = $A.getCallback(function() {
                    var navigateToChildEvent = $A.get("e.force:navigateToComponent");
                    navigateToChildEvent.setParams({
                        componentDef: "c:DashboardComponent", 
                        componentAttributes: {
                            showtabOne:false,
                            showtabTwo:true
                        } 
                    });
                    navigateToChildEvent.fire();
                    $A.get('e.force:refreshView').fire(); 
                });
                
                // Invoke the callback function after a slight delay
                setTimeout(reloadCallback, 1000);
            } else if (state === "ERROR") {
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            } else if (state === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
        });
        $A.enqueueAction(action);
    },
    
    
    callNavigation:function(component,event,helper,accId){
        debugger;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": accId,
            "slideDevName": "related"
        });
        navEvt.fire();
    },
    
    showSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Record Saved Successfully',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },

    showError : function(component, event, helper, errorMessage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message: errorMessage,
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
        showErrorOpp : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message: 'Please fill all the required fields',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },

    getRecordDetails: function(component) {
        debugger;
        var accountId = component.get('v.accID');
        var action = component.get("c.getAllCustomerAddress");
        action.setParams({ custId: accountId });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if (data) {
                    var clonedData = JSON.parse(JSON.stringify(data));
                    //component.set("v.accRecord", clonedData.account);
                    component.set("v.ship_addresses", clonedData.customer_ship_addresses);
                    component.set("v.bill_addresses", clonedData.customer_bill_addresses);
                    component.set("v.selectedAddressIndex", clonedData.ship_selected_index != undefined ? clonedData.ship_selected_index : -1);
                    component.set("v.selectedBilAddressIndex", clonedData.bill_selected_index != undefined ? clonedData.bill_selected_index : -1);
                }
            } else if (state === "ERROR") {
                // Handle errors
                var errors = response.getError();
                console.error(errors);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    onBillAddressSelect: function(component, event, helper) {
        debugger;
        var selectedId = event.target.id;
        
        var billingAddresses = component.get("v.bill_addresses");
        billingAddresses.forEach(function(billingAddress) {
            billingAddress.checked = false;
        });
        
        for (var i = 0; i < billingAddresses.length; i++) {
            if (billingAddresses[i].id === selectedId) {
                billingAddresses[i].checked = true;
                break;
            }
        }
    },
    
    onShipAddressSelect: function(component, event, helper) {
        debugger;
        var selectedId = event.target.id;
        
        var shippingAddresses = component.get("v.ship_addresses");
        shippingAddresses.forEach(function(shippingAddress) {
            shippingAddress.checked = false;
        });
        
        for (var i = 0; i < shippingAddresses.length; i++) {
            if (shippingAddresses[i].id === selectedId) {
                shippingAddresses[i].checked = true;
                break;
            }
        }
    },
    
    handleNavigate: function(component) {
        debugger;
        var shipAddresses = component.get("v.ship_addresses");
        var billingAddresses = component.get("v.bill_addresses");
        
        var index = shipAddresses.findIndex(function(item) {
            return item.checked === true;
        });
        
        var billingIndex = billingAddresses.findIndex(function(item) {
            return item.checked === true;
        });
        
        if (index === -1 || billingIndex === -1) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "No Selection",
                message: "Please select Shipping and Billing address in order to proceed.",
                type: "warning"
            });
            toastEvent.fire();
            return;
        }
        
        var selectedAddress = shipAddresses[index];
        var addressId = selectedAddress.id;
        var accShipAddress = false;
        
        var selectedBillingAddress = billingAddresses[billingIndex];
        var billAddressId = selectedBillingAddress.id;
        var accountBillAddress = false;
        
        if (selectedAddress.id === 'Shipping') {
            addressId = undefined;
            accShipAddress = true;
        }
        
        if (selectedBillingAddress.id === 'Billing') {
            billAddressId = undefined;
            accountBillAddress = true;
        }
        
        if (selectedAddress.state != null && selectedAddress.city != null && selectedAddress.country != null &&
            selectedAddress.street != null && selectedAddress.postalCode != null &&
            selectedBillingAddress.state != null && selectedBillingAddress.city != null &&
            selectedBillingAddress.country && selectedBillingAddress.postalCode != null &&
            selectedBillingAddress.street != null) {
            
            //this.openCreateRecordForm(addressId, accShipAddress, billAddressId, accountBillAddress);
            
            component.set("v.billCity", selectedBillingAddress.city);
            component.set("v.billState", selectedBillingAddress.state);
            component.set("v.billCountry", selectedBillingAddress.country);
            component.set("v.billPostalCode", selectedBillingAddress.postalCode);
            component.set("v.billStreet", selectedBillingAddress.street);
            
            component.set("v.shipCity", selectedAddress.city);
            component.set("v.shipState", selectedAddress.state);
            component.set("v.shipCountry", selectedAddress.country);
            component.set("v.shipPostalCode", selectedAddress.postalCode);
            component.set("v.shipStreet", selectedAddress.street);

            component.set("v.customShipAdrsId", addressId);
            component.set("v.accShipAdrs", accShipAddress);
            component.set("v.customBillAdrsId", billAddressId);
            component.set("v.accBillAdrs", accountBillAddress);
        } 
        else {
            alert('Selected Address should save all the data');
        }
    },

    validateFields: function(component, auraId) {
        debugger;
        var customerSuccessValue = component.find(auraId).get('v.value');
        if ($A.util.isEmpty(customerSuccessValue)) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                message: "Please fill all Mandatory fields.",
                type: "error"
            });
            toastEvent.fire();
            return false;
        } 
        else {
            return true;
        }
    }

    
});