global class ScheduleBatchClassForRemainderMailNo5 implements schedulable {

     global void execute(SchedulableContext sc) {

        database.executeBatch(new BatchClassForRemainderMailNo5());
    }


}