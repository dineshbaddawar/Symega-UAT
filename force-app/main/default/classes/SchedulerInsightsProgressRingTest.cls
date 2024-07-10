@isTest
public class SchedulerInsightsProgressRingTest {

    @isTest(SeeAllData=true)
    private static void getRoleAndKPITest(){
        
        Roles_and_KPI__c roleKPIRec = new Roles_and_KPI__c();
        roleKPIRec.Name = 'Testing KPI';
        insert roleKPIRec;
        
        SchedulerInsightsProgressRing_Handler.getRoleAndKPI();
        SchedulerInsightsProgressRing_Handler.getCountOfVisitsForDifferentKPIs('November','2023');
    }
}