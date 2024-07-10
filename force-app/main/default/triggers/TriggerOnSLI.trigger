trigger TriggerOnSLI on Sample_Line_Item__c (before insert,before update) {
    
    SObject_Trigger_Control__c triggerConfig = SObject_Trigger_Control__c.getValues('Sample_Line_Item__c');
   
    if(triggerConfig != null && triggerConfig.Trigger_Status__c) {
        SampleLineItemTriggerHandler handlerInstance = SampleLineItemTriggerHandler.getInstance();
        
        if(Trigger.isBefore && Trigger.isInsert ){
            handlerInstance.onAfterInsert(Trigger.New);
        }
        if(Trigger.isBefore && Trigger.isUpdate){
             handlerInstance.onAfterUpdate(Trigger.New,Trigger.oldmap);
        }
    }

}