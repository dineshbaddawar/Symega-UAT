public class DayVisitPlanHelper {
    
    public static void finalizeDistanceProcessing(Map<Id, Day_Visit_Plan__c> newPlanMap, Map<Id, Day_Visit_Plan__c> oldPlanMap) {
        List<Day_Visit_Plan__c> plansToUpdate = new List<Day_Visit_Plan__c>();
        List<Visit__c> visitsToUpdate = new List<Visit__c>();
        
        Map<Id,Day_Visit_Plan__c> dayVisitPlanMap = new Map<Id,Day_Visit_Plan__c>();

        for (Id planId : newPlanMap.keySet()) {
            Day_Visit_Plan__c newPlan = newPlanMap.get(planId);
            Day_Visit_Plan__c oldPlan = oldPlanMap.get(planId);

            // Add debug logs to trace the flow
            System.debug('newPlan: ' + newPlan);
            System.debug('oldPlan: ' + oldPlan);
            System.debug('Processing Day_Visit_Plan__c for finalization: ' + newPlan.Id);
            //System.debug('Old End_Location__c: ' + (oldPlan != null ? oldPlan.End_Location__c : 'null'));

            if (newPlan.End_Location__Latitude__s != null && (oldPlan.End_Location__Latitude__s != newPlan.End_Location__Latitude__s)) {
                List<Visit__c> visits = [SELECT Id, Check_Out__c, Distance_Processed__c 
                                         FROM Visit__c 
                                         WHERE Visit_Plan__c = :newPlan.Id 
                                         ORDER BY CreatedDate DESC 
                                         LIMIT 1];
                System.debug('Related Visits: ' + visits);
				Location newPlanEndlocation = Location.newInstance(newPlan.End_Location__Latitude__s,newPlan.End_Location__Longitude__s);
                if (!visits.isEmpty()) {
                    Visit__c lastVisit = visits[0];
                    System.debug('Last Visit Checkout: ' + lastVisit.Check_Out__c);

                    if (lastVisit.Check_Out__c != null) {
                        Double totalDistance = Location.getDistance(lastVisit.Check_Out__c,newPlanEndlocation, 'km');
                        System.debug('Calculated Distance: ' + totalDistance);

                        if (totalDistance != null) {
                            if (newPlan.Total_Covered_Distance__c == null) {
                                newPlan.Total_Covered_Distance__c = 0.0;
                            }
                            Double totalDistanceCovered = newPlan.Total_Covered_Distance__c + totalDistance;
                            //newPlan.Total_Covered_Distance__c += totalDistance;
                            
                            dayVisitPlanMap.put(newPlan.Id,new Day_Visit_Plan__c(Id=newPlan.Id,Total_Covered_Distance__c = totalDistanceCovered));
                            System.debug('Updated Total_Covered_Distance__c: ' + newPlan.Total_Covered_Distance__c);
                            plansToUpdate.add(newPlan);
                            //lastVisit.Distance_Processed__c = true;
                            visitsToUpdate.add(lastVisit);
                        }
                    }
                }
            }
            System.debug('comminf in else part');
        }
        
        if (!dayVisitPlanMap.isEmpty()) {
            database.update(dayVisitPlanMap.values());
            //update plansToUpdate;
            System.debug('Updated Day_Visit_Plan__c records: ' + plansToUpdate);
        }

        if (!visitsToUpdate.isEmpty()) {
            update visitsToUpdate;
            System.debug('Updated Visit__c records: ' + visitsToUpdate);
        }
    }
}