trigger TriggerOnRoute on Route__c (before insert) {
    
    SObject_Trigger_Control__c triggerConfig = SObject_Trigger_Control__c.getValues('Route');
    if(triggerConfig != null && triggerConfig.Trigger_Status__c) {
        RouteTriggerHelper handlerInstance = RouteTriggerHelper.getInstance();
        if(Trigger.isBefore && Trigger.isInsert) {
            handlerInstance.RouteDuplicateCheck(Trigger.New);
        }
    }
}