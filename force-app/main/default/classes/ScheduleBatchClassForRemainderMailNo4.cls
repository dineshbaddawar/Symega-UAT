global class ScheduleBatchClassForRemainderMailNo4 implements Schedulable {

    global void execute(schedulablecontext sc){

Database.executebatch(new BatchClassForRemainderMailNo3());

    }

}