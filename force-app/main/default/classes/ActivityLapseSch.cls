global without sharing class ActivityLapseSch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new ActivityLapseBatch());
    }
    
}