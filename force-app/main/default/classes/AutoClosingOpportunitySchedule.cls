global without sharing class AutoClosingOpportunitySchedule implements Schedulable {
     global void execute(SchedulableContext sc) {
         
       Database.executeBatch(new BatchClassForAutoClosingOpportunity(),1);
    }

}