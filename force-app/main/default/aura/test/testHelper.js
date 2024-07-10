({
    getRecordDetails: function(component) {
        debugger;
        var action = component.get("c.getAllCustomerAddress");
        action.setParams({ custId: '0011m00000oZhNQAA0' });
        
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
        } 
        else {
            alert('Selected Address should save all the data');
        }
    }    
})