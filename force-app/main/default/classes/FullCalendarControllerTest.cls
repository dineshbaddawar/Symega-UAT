@isTest
public class FullCalendarControllerTest {
    
    @isTest
    public Static void getTest1(){
        
        String currentUserId = UserInfo.getUserId();
        System.debug('Current User ID: ' + currentUserId);
            List<Visit__c> visitList = new   List<Visit__c>(); 
        Account acc = new Account();
        acc.Name = 'Test Acc';
        //acc.Account_Type__c = '';
        acc.Account_Segment__c = 'Key';
        acc.Currency__c = 'INR';
        acc.Email__c = 'test@gmail.com';
        
        acc.BillingCity = 'Bangalore';
        acc.BillingCountry = 'India';
        acc.BillingState = 'Punjab';
        acc.BillingStreet = 'XYZ, Test';
        acc.BillingPostalCode = '561011';
        acc.ShippingCity = 'Bangalore';
        acc.ShippingCountry = 'India';
        acc.ShippingState = 'Punjab';
        acc.ShippingStreet = 'XYZ, Test';
        acc.ShippingPostalCode = '561011';
        
        acc.Website = 'https://chat.openai.com/c/e1e8178b-6bd6-4d49-b71e-ca03caba95f6';
        acc.Phone = '4567889000';
       
        
        insert acc; 
        
         
        Monthly_Beat_Plan__c mbp = new Monthly_Beat_Plan__c();
         mbp.Approval_Status__c = 'Approved';
         mbp.Month_year__c = '2023';
         mbp.Month_Name__c = 'November';
         mbp.Sales_User__c = currentUserId;
         mbp.Start_Date__c = Date.newInstance(2023, 11, 17);
         insert mbp;
        
        Weekly_Beat_Plan__c wbp = new Weekly_Beat_Plan__c();
        wbp.End_Day_of_Week__c = Date.newInstance(2023, 11, 17);
        wbp.Monthly_Beat_Plan__c = mbp.Id;
        wbp.Week_Number__c ='Week 1';
           insert wbp;
        
        
        Roles_and_KPI__c rk = new Roles_and_KPI__c();
        rk.Name = 'new client';
        rk.Sales_User__c = currentUserId;
        insert rk;
         
         KPI_Target__c kt = new KPI_Target__c();
         kt.Monthly_Beat_Plan__c = mbp.Id;
         kt.Target_Count__c = 16;
         kt.Roles_and_KPI__c = rk.Id;
         insert kt;
         Datetime currentDateTime = System.now();
        Time currentTime = currentDateTime.time();
        
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
        
          Date testDate = Date.newInstance(2023, 11, 17);
        FullCalendarController.getEvents();
        FullCalendarController.BeetplannerDatareturn('November','2023');
         FullCalendarController.getWeeklyKPI(mbp.Id);
           FullCalendarController.formatDate(testDate);
        
        
    }

}