trigger TriggerOnAddress on Dispatch_Address__c (after update, after insert) {
    SObject_Trigger_Control__c triggerConfig = SObject_Trigger_Control__c.getValues('Address');
    System.debug('Address Trigger Config Started');
    
    if(triggerConfig != null && triggerConfig.Trigger_Status__c){
        AddressTriggerHandler handlerInstance = AddressTriggerHandler.getInstance();
        System.debug('Address Trigger Started');
        if(Trigger.isUpdate && Trigger.isAfter){
            handlerInstance.afterUpdate(Trigger.oldMap,Trigger.newMap);
        }
        if(Trigger.isInsert && Trigger.isAfter){
            handlerInstance.afterInsert(Trigger.new);
        }
    }
}