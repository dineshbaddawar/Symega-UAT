global class ScheduleBatchClassForRemainderMailNo1  implements Schedulable {

     global void execute(SchedulableContext sc) {

        Database.executeBatch(new BatchClassForRemainderMailNo1()); 
     }

}