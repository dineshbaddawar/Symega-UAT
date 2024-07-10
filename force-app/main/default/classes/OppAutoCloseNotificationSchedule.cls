global without sharing class OppAutoCloseNotificationSchedule implements Schedulable {

     global void execute(SchedulableContext sc) {
         
       Database.executeBatch(new BatchClassForOppAutoCloseNotification(),1);
    }

}