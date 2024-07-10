@isTest(SeeAllData=true)
public with sharing class Scheduler_Insights_HandlerTest {
    @isTest
    public static void getAllDateOfSchdeularSightTest() {
        
        List<Lead> getAllLeadReordcList =new List<Lead>();
        List<Visit__c> getAllvisitRecordList = new List<Visit__c>();
        List<Day_Visit_Plan__c> updateDvpList = new List<Day_Visit_Plan__c>();
        List<Event> GetAlleventList = new List<Event>();
        List<Quote> getAllquoteRecordList = new List<Quote>();
        List<Purchase_Order__c> getAllPurchaseOrderRecordList = new  List<Purchase_Order__c>();
        List<Opportunity> getAlloppRecordList = new List<Opportunity>();
        
        Account accRec = new Account();
        accRec.Name = 'Test FSL';

        accRec.BillingCity = 'Bangalore';
        accRec.BillingCountry = 'India';
        accRec.BillingState = 'Punjab';
        accRec.BillingStreet = 'XYZ, Test';
        accRec.BillingPostalCode = '561011';
        accRec.ShippingCity = 'Bangalore';
        accRec.ShippingCountry = 'India';
        accRec.ShippingState = 'Punjab';
        accRec.ShippingStreet = 'XYZ, Test';
        accRec.ShippingPostalCode = '561011';
        
        insert accRec;
        
        Lead ledRec = new Lead();
        ledRec.FirstName = 'Test';
        ledRec.LastName = 'Lead';
        ledRec.AccountId__c = accRec.Id;
        ledRec.Company = 'Test PVT.';
        ledRec.CurrencyIsoCode = 'INR';
        ledRec.Status = 'Sales Qualification';
        insert ledRec;
        getAllLeadReordcList.add(ledRec);
        
        Opportunity oppRec = new Opportunity();
        oppRec.Name = 'Test Opp';
        oppRec.CloseDate = system.today();
        oppRec.CurrencyIsoCode = 'INR';
        oppRec.Annual_Volume_Full__c = 12.01;
        oppRec.Annual_Volume_in_units__c = 'Kg';
        oppRec.End_Use_Category__c = 'Beverages';
        oppRec.End_Use_Application__c = 'Beer';
        oppRec.Target_Price_Kg__c = 30;
        oppRec.AccountId = accRec.Id;
        oppRec.StageName = 'New';
        insert oppRec;
        getAlloppRecordList.add(oppRec);
        
        Event eventRec = new Event();
        eventRec.WhoId = ledRec.Id;
        eventRec.Subject = 'Test Subject';
        eventRec.Description = 'Test Description'; 
        eventRec.StartDateTime = System.Now();
        eventRec.EndDateTime = System.Now() + 5;
        insert eventRec;
        GetAlleventList.add(eventRec);
        
        Quote quoteRec = new Quote();
        quoteRec.Name = 'Test Quote';
        quoteRec.OpportunityId = oppRec.Id;
        insert quoteRec;
        getAllquoteRecordList.add(quoteRec);
        
        Roles_and_KPI__c roleKpiRec = new Roles_and_KPI__c();
        roleKpiRec.Name = 'Test Role and Kpi';
        insert roleKpiRec;
        
        KPI_Target__c kpiTarRec = new KPI_Target__c();
        kpiTarRec.Roles_and_KPI__c = roleKpiRec.Id;
        insert kpiTarRec;
        
        Visit__c visirtRec = new Visit__c();
        visirtRec.Actual_visit_date__c = System.today();
        visirtRec.KPI_Target__c = kpiTarRec.Id;
        visirtRec.Account__c = accRec.Id;
        insert visirtRec;
        getAllvisitRecordList.add(visirtRec);
        
        Monthly_Travel_Expense__c mteRec = new Monthly_Travel_Expense__c();
        mteRec.Name = 'Test';
        insert mteRec;
        
        Day_Visit_Plan__c dvpRec= new Day_Visit_Plan__c();
        dvpRec.Start_Date__c= System.today();
        dvpRec.Monthly_Travel_Expense__c= mteRec.Id;
        insert dvpRec;
        updateDvpList.add(dvpRec);
        
        Purchase_Order__c purOrdRec = new Purchase_Order__c();
        purOrdRec.Description__c = 'Testing';
        insert purOrdRec;
        getAllPurchaseOrderRecordList.add(purOrdRec);
        
         List<Feedback__c> feedbackList  = new  List<Feedback__c>();
        List<EmailMessage> emailList = new List<EmailMessage>();
        List<Invoices__c> invoList = new List<Invoices__c>();
        List<Day_Visit_Plan__c> dayVisitPlanList = new List<Day_Visit_Plan__c>();
        List<EmailMessage> emailList1 = new  List<EmailMessage>();
        List<Case> caseList = new List<Case>();
        Scheduler_Insights_Handler.SchedulerInsightsWrapper sw= new  Scheduler_Insights_Handler.SchedulerInsightsWrapper();
        sw.visitRecList = getAllvisitRecordList ;
        sw.LeadRecList = getAllLeadReordcList;
        sw.eventList = GetAlleventList;
        sw.oppList = getAlloppRecordList;
        sw.oppNegoList = getAlloppRecordList;
        sw.quoteList = getAllquoteRecordList;
        sw.purOrdList =getAllPurchaseOrderRecordList;
        sw.invoList = invoList;
        sw.feedbackList = feedbackList;
        sw.dayVisitPlanList = dayVisitPlanList;
        sw.emailList = emailList1;
        sw.caseList =  caseList;
        
        
        Scheduler_Insights_Handler.getAllDateOfSchdeularSight(1,2,'November','2023');
        Scheduler_Insights_Handler.getAllDateOfTravelDayVisitPlan('November','2023');
        Scheduler_Insights_Handler.updateMonthname(updateDvpList);
    }
}