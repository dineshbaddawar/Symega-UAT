@isTest
public class DistAllocationControllerTest {

    @isTest
    static void testOnAfterInsert() {
        SObject_Trigger_Control__c triggerConfig = new SObject_Trigger_Control__c(
          
            Trigger_Status__c = true,
            Name = 'Distributor_Allocation'
        );
        insert triggerConfig;
        
        Account testAccount = new Account(
            Name = 'Test Account',
            BillingStreet = 'test',
            BillingCity = 'Patna',
            BillingState = 'Bihar',
            BillingPostalCode = '121001',
            
            ShippingStreet = 'test',
            ShippingCity = 'Patna',
            ShippingState = 'Bihar',
            ShippingPostalCode = '121001'
        );
        insert testAccount;
        
        Distributor_Allocation__c testRecord = new Distributor_Allocation__c(
            
            Customer_Account__c = testAccount.Id,
            Distributor_Account__c = testAccount.Id
            
        );
        
        Test.startTest();
        insert testRecord;
        Test.stopTest();

    }
}