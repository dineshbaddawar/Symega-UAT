public class CalculateTravelAndTotalDistance_Shiva {
    
    public static void CalculateTrvaelandTotalDistance_ShivaNew(Map<Id, Visit__c> newVisitMap) {
        Set<Id> dayVisitIds = new Set<Id>();
        List<Visit__c> visitsToUpdate = new List<Visit__c>();
        List<Day_Visit_Plan__c> DayvisitsPalanToUpdate = new List<Day_Visit_Plan__c>();
        
        // Collect the IDs of Day_Visit_Plan__c related to the updated Visit__c records
        for (Visit__c visit : newVisitMap.values()) {
            if (visit.CheckIn__Longitude__s != null && visit.Visit_Plan__c != null) {
                dayVisitIds.add(visit.Visit_Plan__c);
            }
        }
        
        // Query the related Day_Visit_Plan__c records
        Map<Id, Day_Visit_Plan__c> relatedDayVisits = new Map<Id, Day_Visit_Plan__c>();
        if (!dayVisitIds.isEmpty()) {
            relatedDayVisits = new Map<Id, Day_Visit_Plan__c>(
                [SELECT Id, Total_Distances__c, Total_Covered_Distance__c, End_Location__c, Start_Location__c, Total_Distance__c, 
                 (SELECT Id, Name, Visit_Status__c, Check_Out__c, CheckIn__c, Distance_Km__c, Distance_Processed__c FROM visit__r) 
                 FROM Day_Visit_Plan__c WHERE Id IN :dayVisitIds]
            );
        }
        
        for (Day_Visit_Plan__c dayVisitPlan : relatedDayVisits.values()) {
            Visit__c lastVisit = null; // Initialize the last visit
            if (dayVisitPlan.Start_Location__c != null && dayVisitPlan.End_Location__c == null) {
                for (Visit__c visit : dayVisitPlan.visit__r) {
                    system.debug('visit---lv'+visit);
                    if (visit.CheckIn__c != null && visit.Check_Out__c == null && !visit.Distance_Processed__c) {
                        // First visit: distance from start location to check-in
                        Double totalDistance = Location.getDistance(dayVisitPlan.Start_Location__c, visit.CheckIn__c, 'km');
                        system.debug('totalDistance---in fl'+totalDistance);
                        if (totalDistance != null) {
                            if (dayVisitPlan.Total_Covered_Distance__c == null) {
                                dayVisitPlan.Total_Covered_Distance__c = 0.0;
                            }
                            dayVisitPlan.Total_Covered_Distance__c += totalDistance;
                            visit.Distance_Processed__c = true;
                            visitsToUpdate.add(visit);
                        }
                        lastVisit = visit; // Update last visit
                        system.debug('lastVisit---in fl'+lastVisit);
                    }else if(visit.CheckIn__c != null && visit.Check_Out__c != null && visit.Distance_Processed__c){
                        lastVisit = visit; // Update last visit
                    }                    
                    else if (visit.CheckIn__c != null && visit.Check_Out__c != null && lastVisit != null && !visit.Distance_Processed__c) {
                        // Subsequent visits: distance from last visit's check-out to current visit's check-in
                        system.debug('lastVisit.Check_Out__c---in sl'+lastVisit.Check_Out__c);
                        system.debug('visit.CheckIn__c---in sl'+visit.CheckIn__c);
                        Double totalDistance = Location.getDistance(lastVisit.Check_Out__c, visit.CheckIn__c, 'km');
                        system.debug('totalDistance---in sl'+totalDistance);
                        if (totalDistance != null) {
                            if (dayVisitPlan.Total_Covered_Distance__c == null) {
                                dayVisitPlan.Total_Covered_Distance__c = 0.0;
                            }
                            dayVisitPlan.Total_Covered_Distance__c += totalDistance;
                            visit.Distance_Processed__c = true;
                            visitsToUpdate.add(visit);
                        }
                        lastVisit = visit; // Update last visit
                        system.debug('lastVisit---in sl'+lastVisit);
                    }
                }
            } else if (dayVisitPlan.Start_Location__c != null && dayVisitPlan.End_Location__c != null) {
                for (Visit__c visit : dayVisitPlan.visit__r) {
                    if (visit.CheckIn__c != null && visit.Check_Out__c != null && !visit.Distance_Processed__c) {
                        // Distance from last visit's check-out to end location
                        Double totalDistance = Location.getDistance(lastVisit.Check_Out__c, dayVisitPlan.End_Location__c, 'km');
                        system.debug('totalDistance---in tl'+totalDistance);
                        if (totalDistance != null) {
                            if (dayVisitPlan.Total_Covered_Distance__c == null) {
                                dayVisitPlan.Total_Covered_Distance__c = 0.0;
                            }
                            dayVisitPlan.Total_Covered_Distance__c += totalDistance;
                            visit.Distance_Processed__c = true;
                            visitsToUpdate.add(visit);
                        }
                    }
                }
            }
            
            DayvisitsPalanToUpdate.add(dayVisitPlan);
        }
        
        if (!visitsToUpdate.isEmpty()) {
            update visitsToUpdate;
        }
        if (!DayvisitsPalanToUpdate.isEmpty()) {
            update DayvisitsPalanToUpdate;
        }
        
    }
    
    
}