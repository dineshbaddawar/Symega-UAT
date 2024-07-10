({
    onchange: function(component, event, helper) 
    {
        debugger;
     	event.stopPropagation();
        event.preventDefault();
        debugger;
        var fileName = 'No File Selected.';
        if (event.getSource().get("v.files").length > 0) { 
            fileName = event.getSource().get("v.files")[0]; //['name'];
        }
        component.set("v.newfileName", fileName['name']);
        helper.readFile(component,helper,fileName);
        
  	},
    
    processFileContent : function(component,event,helper){
        helper.saveRecords(component,event);
    },
    
    cancel : function(component,event,helper){
        debugger;
        component.set("v.showMain",true); 
         component.set("v.showMain1",true); 
         $A.get("e.force:closeQuickAction").fire(); 
  $A.get("e.force:refreshView").fire(); 
       
      //  var dismissActionPanel = $A.get("e.force:closeQuickAction");
       // dismissActionPanel.fire();
    }
})