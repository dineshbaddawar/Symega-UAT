@isTest
public class OpportunityEmailSenderTest {
    
    @isTest
    public static void getTest1(){
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Email__c ='test1@gmail.com';
        
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
        
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp1';
        opp.CloseDate = Date.newInstance(2024, 11, 17);
        opp.Annual_Volume_Full__c = 1;
        opp.Target_Price_Kg__c = 1;
        opp.Annual_Volume_in_units__c = 'Kg';
        opp.StageName = 'New';
        opp.End_Use_Application__c = 'Biscuits and Cookies';
        opp.End_Use_Category__c = 'Baked Goods';
        opp.AccountId = acc.Id ;
        insert opp;
        OpportunityEmailSender.sendEmailOnOpportunity(opp.Id);
    }

}