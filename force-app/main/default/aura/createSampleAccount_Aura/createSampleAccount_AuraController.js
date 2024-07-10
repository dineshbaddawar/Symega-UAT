({
    doInit : function(component, event, helper) {

    },

    handleRecordChange : function(component, event, helper) {
      
        const recordId = event.getParam('recordId');
        console.log('Record ID changed:', recordId);
        component.set("v.recordId", recordId);
    }
})