@isTest(SeeAllData=true)
public class UservisitTrackingControllerTest {
    
    @isTest
    public Static void getTest1(){
         String currentUserId = UserInfo.getUserId();
         STring testDate = String.valueOf(Date.newInstance(2023, 11, 17));
        
          
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
        
         Datetime currentDateTime = System.now();
        Time currentTime = currentDateTime.time();
         
        Weekly_Beat_Plan__c wbp = new Weekly_Beat_Plan__c();
        wbp.End_Day_of_Week__c = Date.newInstance(2023, 11, 17);
        wbp.Week_Identifier__c ='w1';
        wbp.Week_Number__c = 'Week 1';
        wbp.CurrencyIsoCode = 'INR';
     //   wbp.Monthly_Beat_Plan__c = mbp.Id;
        insert wbp;

         KPI_Target__c kt = new KPI_Target__c();
        insert kt;
        Visit__c vsRec = new Visit__c();
        vsRec.Planned_visit_date__c =  Date.newInstance(2023, 11, 17);
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
        
       
        
        UservisitTrackingController utc = new UservisitTrackingController();
        UservisitTrackingController.fetchPlannedVisitDetails(testDate);
        double lat = 12.890992;
        double longt = 77.570802;
        Monthly_Travel_Expense__c mte = new Monthly_Travel_Expense__c();
        insert mte;
         
        
          Day_Visit_Plan__c vstPlan = new Day_Visit_Plan__c();
            vstPlan.Service_Executive__c = currentUserId;
            vstPlan.End_Location__Latitude__s = lat;
            vstPlan.End_Location__Longitude__s = longt;
        vstplan.Monthly_Travel_Expense__c = mte.Id;
            insert vstPlan;
        
           Day_Visit_Plan__c vstPlan1 = new Day_Visit_Plan__c();
           vstPlan1.Id = vstPlan.Id;
          vstPlan1.Service_Executive__c =currentUserId;
          vstPlan1.End_Location__Latitude__s = 13.890992;
            vstPlan1.End_Location__Longitude__s =  23.890992;
      //  vstplan.Monthly_Travel_Expense__c = mte.Id;
        update vstPlan1;
        
        UservisitTrackingController.userPopulated(testDate,currentUserId,lat,longt);
        UservisitTrackingController.changePlannedVisitdate(testDate,vsRec.Id);
        UservisitTrackingController.createVisitPlanAcrossUser(lat,longt,currentUserId,testDate);
        UservisitTrackingController.endDay(lat,longt,currentUserId,vstPlan.Id);
    }

}