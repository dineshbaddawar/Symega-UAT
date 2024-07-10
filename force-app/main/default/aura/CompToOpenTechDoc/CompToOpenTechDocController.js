({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getUserDocUrl");
        action.setParams({
            udId : component.get("v.recordId")
        });       
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS"){
                debugger;
                console.log('response.getReturnValue() -- ', response.getReturnValue());
                component.set("v.linkUrl",response.getReturnValue());
            } 
            else{
                debugger;
            }
        });
        $A.enqueueAction(action);
    },
    
    openLink : function(component, event, helper) {
        debugger;
        var url = component.get("v.url");
        if (url && !url.startsWith('http://') && !url.startsWith('https://')) {
            // Add the scheme dynamically if needed
            url = '//' + url;
        }
         url = '//' + url;
        window.open(url, "_blank");
    }
})