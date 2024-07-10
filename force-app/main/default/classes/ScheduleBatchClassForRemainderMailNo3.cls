global class ScheduleBatchClassForRemainderMailNo3 implements schedulable {

    global void execute(SchedulableContext sc){

         Database.executeBatch(new BatchClassForRemainderMailNo3());
    }

}