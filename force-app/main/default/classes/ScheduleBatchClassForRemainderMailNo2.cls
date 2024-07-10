global class ScheduleBatchClassForRemainderMailNo2 implements Schedulable{
    global void execute(SchedulableContext sc) {

         Database.executeBatch(new BatchClassForRemainderMailNo2());
    }


}