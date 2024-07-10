@isTest(SeeAllData=true)
public class TodayTaskAuraControllerTest {
    
    @isTest
    public static void TestClass1(){
 
            List<Visit__c> visitList = new   List<Visit__c>(); 
        Account acc = new Account();
        acc.Name = 'Test Acc';
        //acc.Account_Type__c = '';
        acc.Account_Segment__c = 'Key';
        acc.Currency__c = 'INR';
        acc.Email__c = 'test@gmail.com';
        
        acc.BillingStreet = 'jayanagar';
        acc.BillingCity = 'Bengaluru';
        acc.BillingState = 'karnataka';
        acc.BillingCountry = 'India';
        acc.BillingPostalCode = '57689';
        acc.ShippingCity = 'Bangalore';
        acc.ShippingCountry = 'India';
        acc.ShippingState = 'Punjab';
        acc.ShippingStreet = 'XYZ, Test';
        acc.ShippingPostalCode = '561011';
        
        acc.Website = 'https://chat.openai.com/c/e1e8178b-6bd6-4d49-b71e-ca03caba95f6';
        acc.Phone = '4567889000';
       
        
        insert acc; 
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp1';
        opp.CloseDate = Date.newInstance(2023, 11, 17);
        opp.Annual_Volume_Full__c = 1;
        opp.Target_Price_Kg__c = 1;
        opp.Annual_Volume_in_units__c = 'Kg';
        opp.StageName = 'New';
        opp.End_Use_Application__c = 'Biscuits and Cookies';
        opp.End_Use_Category__c = 'Baked Goods';
         opp.AccountId = acc.Id ;
        
        insert opp;
        
        String currentUserId = UserInfo.getUserId();
        System.debug('Current User ID: ' + currentUserId);
        
         Monthly_Beat_Plan__c mbp = new Monthly_Beat_Plan__c();
         mbp.Approval_Status__c = 'Approved';
      //  insert mbp;
        
        Weekly_Beat_Plan__c wbp = new Weekly_Beat_Plan__c();
        wbp.End_Day_of_Week__c = Date.newInstance(2023, 11, 17);
        wbp.Week_Identifier__c ='w1';
        wbp.Week_Number__c = 'Week 1';
        wbp.CurrencyIsoCode = 'INR';
     //   wbp.Monthly_Beat_Plan__c = mbp.Id;
        insert wbp;
        
       
        
        
        Datetime currentDateTime = System.now();
        Time currentTime = currentDateTime.time();
     //   System.debug('Current Time: ' + currentTime.format('h:mm a'));
           
        KPI_Target__c kt = new KPI_Target__c();
        insert kt;
   
      
        
        Visit__c vsRec = new Visit__c();
        vsRec.Planned_visit_date__c =  Date.newInstance(2023, 11, 16);
        vsRec.Assigned_User__c = currentUserId;
        vsRec.Account__c = acc.Id;
        vsRec.Visit_Status__c = 'Sent For Approval';
        vsRec.Weekly_Beat_Plan__c = wbp.Id;
        vsRec.KPI_Target__c = kt.Id;
        vsRec.Geo_Location__Latitude__s = 12.890992;
        vsRec.Geo_Location__Longitude__s = 77.570802;
        vsRec.Expected_Start_Time__c = currentTime ;
       
        visitList.add(vsRec);
        insert vsRec;
        
        Visit__c vsRec1 = new Visit__c();
        vsRec1.Planned_visit_date__c =  Date.newInstance(2023, 11, 16);
        vsRec1.Assigned_User__c = currentUserId;
        vsRec1.Account__c = acc.Id;
        vsRec1.Visit_Status__c = 'Sent For Approval';
        vsRec1.Weekly_Beat_Plan__c = wbp.Id;
        vsRec1.KPI_Target__c = kt.Id;
        vsRec1.Geo_Location__Latitude__s = 12.890992;
        vsRec1.Geo_Location__Longitude__s = 77.570802;
        vsRec1.Expected_Start_Time__c = currentTime ;
        vsRec1.CheckIn__Latitude__s = 12.890992; 
        vsRec1.CheckIn__Longitude__s = 77.570802;
        vsRec1.Check_Out__Latitude__s = 12.890992;
        vsRec1.Check_Out__Longitude__s = 77.570802;
       // visitList.add(vsRec);
        insert vsRec1;
        
        
           
       //  Datetime currentDateTime1 = System.now();
        String formattedDateTime = String.valueOf(vsRec.Planned_visit_date__c);
        
        case cs = new case();
        insert cs;
        
        task taskRec = new task();
        insert taskRec;
        
        TodayTaskAuraController.createVisitActivity(opp.Id, vsRec.Id);
        TodayTaskAuraController.getAllVisitTodays(formattedDateTime);
        
        TodayTaskAuraController.GetCompletedVisitRecords(formattedDateTime);
        TodayTaskAuraController.getSelectedVisitDetails(vsRec.Id);
        
        TodayTaskAuraController.getSelectedVisitDetails(vsRec.Id);
        TodayTaskAuraController.StartDayVisitForVistitRecord('12.890992','77.570802',visitList);
        TodayTaskAuraController.updateEndDayVisitRecord('12.890992','77.570802');
         TodayTaskAuraController.updateAmendVisitRecord(vsRec);
        TodayTaskAuraController.saveTask(taskRec);
         TodayTaskAuraController.LogCall(taskRec);
         TodayTaskAuraController.saveOpportunity(opp);
          TodayTaskAuraController.saveCase(cs);
          TodayTaskAuraController.checkInUpdateVisit('12.890992','77.570802',vsRec.Id);
         TodayTaskAuraController.checkOutUpdateVisit('12.890992','77.570802',vsRec.Id);
         TodayTaskAuraController.getPastVisitDetails(acc.Id);
        TodayTaskAuraController.getRelOppList(acc.Id);
        TodayTaskAuraController.getRelInvoiceList(acc.Id);
         TodayTaskAuraController.getRelCaseList(acc.Id);
        TodayTaskAuraController.getRelTaskList(acc.Id);
        
       
    }

 
}