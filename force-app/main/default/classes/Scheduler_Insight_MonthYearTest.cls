@isTest
public with sharing class Scheduler_Insight_MonthYearTest {

    @isTest(SeeAllData=true)
    public static void Scheduler_Insight_MonthYearTest() {
        Monthly_Beat_Plan__c mbp = new Monthly_Beat_Plan__c();
        Scheduler_Insight_MonthYear_handler.returnDAta  rd = new Scheduler_Insight_MonthYear_handler.returnDAta();
        rd.mbplRecord = mbp;
        Scheduler_Insight_MonthYear_handler.getMonthBeatPlan('November','2023');
        Scheduler_Insight_MonthYear_handler.getMonthlyRecord('November','2023');
        Scheduler_Insight_MonthYear_handler.getMonthlyDayVisitRecords('November','2023');
        Scheduler_Insight_MonthYear_handler.getAllroutes();
    }
}