@isTest
global class ExampleCalloutMockTset implements HttpCalloutMock{
    global HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('({address_components=({long_name=60, short_name=60, types=(street_number)}, {long_name=1st Cross Road, short_name=1st Cross Rd, types=(route)}, {long_name=Arekere MICO Layout 2nd stage, short_name=Arekere MICO Layout 2nd stage, types=(neighborhood, political)}, {long_name=Omkar Nagar, short_name=Omkar Nagar, types=(political, sublocality, sublocality_level_2)}, {long_name=Panduranga Nagar, short_name=Panduranga Nagar, types=(political, sublocality, sublocality_level_1)}');
        return res;
    }
}