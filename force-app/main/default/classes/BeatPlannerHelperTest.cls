@isTest
public class BeatPlannerHelperTest {

     @isTest
    public static void BeetplannerDatareturnTest(){
        
        List<Visit__c> getAllvisitRecordList = new List<Visit__c>();
        List<Monthly_Beat_Plan__c> mbpRecList = new List<Monthly_Beat_Plan__c>();
        List<KPI_Target__c> kpiRecList = new List<KPI_Target__c>();
        
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
        
        Roles_and_KPI__c roleKpiRec = new Roles_and_KPI__c();
        roleKpiRec.Name = 'Test Role and Kpi';
        insert roleKpiRec;
        
        KPI_Target__c kpiTarRec = new KPI_Target__c();
        kpiTarRec.Roles_and_KPI__c = roleKpiRec.Id;
        insert kpiTarRec;
        kpiRecList.add(kpiTarRec);
        
        Monthly_Beat_Plan__c mbpRec = new Monthly_Beat_Plan__c();
        mbpRec.Approval_Status__c = 'Approved';
        mbpRec.Start_Date__c = system.today();
        mbpRec.End_Date__c = system.today();
        mbpRec.CurrencyIsoCode = 'INR';
        mbpRec.Status__c = 'Approved';
        insert mbpRec;
        mbpRecList.add(mbpRec);
        
        Visit__c visirtRec = new Visit__c();
        visirtRec.Actual_visit_date__c = System.today();
        visirtRec.KPI_Target__c = kpiTarRec.Id;
        visirtRec.Account__c = accRec.Id;
        insert visirtRec;
        getAllvisitRecordList.add(visirtRec);
        
        BeatPlannerHelper.alldataWrapper wr = new BeatPlannerHelper.alldataWrapper();
        wr.MBPlist = mbpRec;
        wr.visitRecList = getAllvisitRecordList;
        wr.KpiTList = kpiRecList;
        
        BeatPlannerHelper.BeetplannerDatareturn('November','2023');
        BeatPlannerHelper.CreateDocumentCategories(mbpRecList);
        BeatPlannerHelper.getTaskdetails(accRec.Id);
        BeatPlannerHelper.initiateApprovalProcess(mbpRec.Id);
    }
}