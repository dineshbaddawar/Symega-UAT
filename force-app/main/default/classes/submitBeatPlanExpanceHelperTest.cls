@isTest
public class submitBeatPlanExpanceHelperTest {
    
    @isTest
    public static void getTest1(){
        
        Account accRec = new Account();
        accRec.Name = 'Test Account';
        
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
        submitBeatPlanExpanceHelper.submitApproval(accRec.ID);
        
    }

}