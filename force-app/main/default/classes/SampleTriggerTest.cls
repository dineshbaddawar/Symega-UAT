@isTest
public class SampleTriggerTest {
    @isTest(SeeAllData=true)
    private static void run(){
        Database.SaveResult dsr;
        
        Account acc = new Account();
        acc.Name = 'DUMMY ACCOUNT';
        acc.BillingCity = 'Bangalore';
        acc.BillingCountry = 'India';
        acc.BillingState = 'Karnataka';
        acc.BillingStreet = 'XYZ, Test';
        acc.BillingPostalCode = '561011';
        
        acc.ShippingCity = 'Bangalore';
        acc.ShippingCountry = 'India';
        acc.ShippingState = 'Punjab';
        acc.ShippingStreet = 'XYZ, Test';
        acc.ShippingPostalCode = '561011';
        
        Insert acc;
        
        Opportunity oppRecType = new Opportunity();
        oppRecType.Name = 'Dummy';
        oppRecType.StageName = 'New';
        oppRecType.CloseDate = System.TODAY();
        oppRecType.End_Use_Application__c = 'Popcorn';
        oppRecType.End_Use_category__c = 'Snacks';
        oppRecType.Annual_Volume_Full__c = 1;
        oppRecType.Target_Price_Kg__c = 1;
        oppRecType.Annual_Volume_in_units__c = 'Kg';
        insert oppRecType;
        
        Project__c ud = new Project__c();
        ud.Account__c = acc.Id;
        ud.Product_Family__c = 'CPD';
        ud.End_Use_Applications__c = 'Popcorn';
        ud.End_Use_category__c = 'Snacks';
        ud.Opportunity__c = oppRecType.Id;
        insert ud;
        ud.Application_Name__c = 'Test';
        update ud;
        
        
        
        Project_Quotient__c projQuoRec = new Project_Quotient__c();
        projQuoRec.Product_Name__c = 'xyz';
        projQuoRec.SSC_Code__c  = '1234';
        projQuoRec.Sample_Project_Application__c = ud.Id;
        insert projQuoRec;
        
    }
}