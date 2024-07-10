trigger ProjectQuotientTrigger on Project_Quotient__c (After insert) {
    
    //   ProjectQuotientHandler.afterInsert(Trigger.New);
    
    SObject_Trigger_Control__c triggerConfig = SObject_Trigger_Control__c.getValues('Project_Quotient__c');
    if(triggerConfig != null && triggerConfig.Trigger_Status__c) {
        ProjectQuotientController handlerInstance = ProjectQuotientController.getInstance();             
        if(Trigger.isAfter && Trigger.isInsert ) {
            handlerInstance.afterInsert(Trigger.New);
        }
    }
    
}