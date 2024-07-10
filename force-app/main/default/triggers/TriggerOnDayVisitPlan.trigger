trigger TriggerOnDayVisitPlan on Day_Visit_Plan__c (before insert, before update, after update) {
    if (trigger.isbefore && trigger.isupdate || trigger.isafter && trigger.isupdate) {
        //DayVisitPlanHelper.finalizeDistanceProcessing(trigger.newMap,trigger.oldMap);
    }    
    
    if(Trigger.isUpdate && Trigger.isAfter){
        DayVisitPlanHelper.finalizeDistanceProcessing(trigger.newMap,trigger.oldMap);
    }
}