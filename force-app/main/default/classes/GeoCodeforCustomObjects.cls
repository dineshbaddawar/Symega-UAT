public without sharing class GeoCodeforCustomObjects {

    @future(callout=true)
    public static void getGeolocation(Set<Id> addrIds) {
        System.debug('addrIds ==>' +addrIds);
        String API_KEY = System.Label.GeoCodeAPIKey;
        System.debug('API_KEY ==>' +API_KEY);
        
        List<Dispatch_Address__c> addressToUpdate = [SELECT Id, Address__c FROM Dispatch_Address__c WHERE Id IN :addrIds];
        List<Dispatch_Address__c> addressToUpdateWithGeolocation = new List<Dispatch_Address__c>();
        
        for (Dispatch_Address__c addr : addressToUpdate) {
            Address customAddress = addr.Address__c;
            String city = customAddress != null && customAddress.getCity() != null ? customAddress.getCity().deleteWhitespace() : null;
            String street = customAddress != null && customAddress.getStreet() != null ? customAddress.getStreet().deleteWhitespace() : null;
            String stateCode = customAddress != null && customAddress.getStateCode() != null ? customAddress.getStateCode() : null;
            //String countryCode = customAddress != null && customAddress.getCountryCode() != null ? customAddress.getCountryCode() : null;
            String countryCode = customAddress != null && customAddress.getCountry() != null ? customAddress.getCountry() : null;
            
            if (city != null && street != null && stateCode != null && countryCode != null) {
                String address = street + ', ' + city + ', ' + stateCode + ', ' + countryCode;
                string formatted_address = address.replace(' ', '+'); 
                system.debug('address -- ' + address );
                system.debug('formatted_address -- ' + formatted_address );
                Http httpProtocol = new Http();
                HttpRequest request = new HttpRequest();
                
                string address2 = 'White House, Pennsylvania Avenue Northwest, Washington, DC, United States'; 
                string formatted_address2 = address2.replace(' ', '+'); 
                system.debug('address2 -- ' + address2 );
                system.debug('formatted_address2 -- ' + formatted_address2 );
                
                String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(formatted_address, 'UTF-8') + '&key=' + API_KEY;
                request.setEndPoint(endpoint);
                request.setMethod('GET');
                HttpResponse response = httpProtocol.send(request);
                System.debug('response ==>' + response);
                Map<String, Decimal> coordinates = new Map<String, Decimal>();
                if (response.getStatusCode() == 200) {
                    System.debug('Inside 200 ==>');
                    Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    System.debug('jsonResponse ==>'+jsonResponse);
                    if ('OK'.equals(jsonResponse.get('status'))) {
                        List<Object> results = (List<Object>)jsonResponse.get('results');
                        if (!results.isEmpty()) {
                            Map<String, Object> geometry = (Map<String, Object>)((Map<String, Object>)results[0]).get('geometry');
                            Map<String, Object> location = (Map<String, Object>)geometry.get('location');
                            coordinates.put('latitude', (Decimal)location.get('lat'));
                            coordinates.put('longitude', (Decimal)location.get('lng'));
                            System.debug('geometry  ==> ' + geometry);
                            System.debug('geometry.Bounds  ==> ' + geometry.get('bounds'));
                            System.debug('location  ==> ' + location);
                        }
                    }
                    addr.Address__Latitude__s = coordinates.get('latitude') ;
                    addr.Address__Longitude__s = coordinates.get('longitude');
                    addressToUpdateWithGeolocation.add(addr);
                }
            }
        }
        
        if (!addressToUpdateWithGeolocation.isEmpty()) {
            update addressToUpdateWithGeolocation;
        }
    }
}