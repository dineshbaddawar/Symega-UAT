global without sharing class  OpportunityOwnerSchedule implements Schedulable{

     global void execute(SchedulableContext sc) {
         
       Database.executeBatch(new BatchClassForOpportunityOwner(),1);
    }

}