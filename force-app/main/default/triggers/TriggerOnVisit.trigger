trigger TriggerOnVisit on Visit__c (before insert, after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
         //TriggerOnVisitHelper.updateDistanceOnRelatedDatVisit(Trigger.new, Trigger.oldMap);
         TriggerOnVisitHelper.updateAchivedCountOnKPI(Trigger.new, Trigger.oldMap);
         CalculateTravelAndTotalDistance_Shiva.CalculateTrvaelandTotalDistance_ShivaNew(Trigger.newMap); 
        
    }
}