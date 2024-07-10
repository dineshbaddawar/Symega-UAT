({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        console.log("Recx----",recordId)
    },
    handleClose : function(component, event, helper) {
		 var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	}
})