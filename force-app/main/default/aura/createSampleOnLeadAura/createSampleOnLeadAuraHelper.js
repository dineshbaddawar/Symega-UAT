({
    /*getRcType: function(component, recordName) {
    return new Promise(
      $A.getCallback(function(resolve, reject) {
        var action = component.get('c.getProjectRecordTypeId'); 
        action.setParams({
            "recordTypeName" : "Sample" 
        });
        action.setCallback(this, function(result){
            var state = result.getState(); // get the response state
            resolve(result.getReturnValue());
            if(state == 'SUCCESS') {
                console.log('RECTYPEHELPER----',result.getReturnValue());
                return result.getReturnValue();
            }
        });
        
        $A.enqueueAction(action);
      }));
  }*/
})