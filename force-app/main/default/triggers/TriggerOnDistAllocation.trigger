trigger TriggerOnDistAllocation on Distributor_Allocation__c (after insert) {
    
    SObject_Trigger_Control__c triggerConfig = SObject_Trigger_Control__c.getValues('Distributor_Allocation');
    System.debug('Trigger Config Started');
    
    if(triggerConfig != null && triggerConfig.Trigger_Status__c){
        DistAllocationController handlerInstance = DistAllocationController.getInstance();
        System.debug('Trigger Started');
        if(Trigger.isInsert && Trigger.isAfter){
            handlerInstance.onAfterInsert(Trigger.new);
        }
    }
}