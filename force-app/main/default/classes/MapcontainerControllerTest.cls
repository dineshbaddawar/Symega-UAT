@isTest
public class MapcontainerControllerTest {

    @isTest
    public static void getAccountDetailsTest() {
        
        Account acc = new Account();
        acc.Name = 'Test FSL';
        
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
        MapcontainerController.getAccountDetails(acc.id);
        // MapcontainerController.GoogleMapReverseGeocodeCallout('12.890992','77.570802');
    }
    
    static testMethod void shouldBeAbleToGetData(){
        // Case myCase = getTestCase();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMockTset());
        String res =  MapcontainerController.GoogleMapReverseGeocodeCallout('12.891530','77.594078');
        Test.stopTest();
      }
}