({
    doInit: function(component, event, helper) {
        debugger;
        helper.getRecordDetails(component);
    },
    
    onAddressSelect: function(component, event, helper) {
        helper.onShipAddressSelect(component, event, 'ship');
    },
    
    onBillAddressSelect: function(component, event, helper) {
        helper.onBillAddressSelect(component, event, 'bill');
    },
    
    handleNavigate: function(component, event, helper) {
        helper.handleNavigate(component);
    }
})