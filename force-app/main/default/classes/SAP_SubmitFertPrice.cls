public without sharing class SAP_SubmitFertPrice {
    
    @future(callout=true)
    public static void submitFertPrice(String oppId){
        Opportunity opp = getOpportunity(oppId);
        
        String endPoint = 'callout:Fert_SAP'+ System.Label.SAP_Fert_URL;
        String tokenEndPoint = 'callout:Fert_SAP'+System.Label.SAP_Fert_URL;

        Map<String,String> tokenMap = SAPRequestTokenHeader.getInstance().getCSRFToken(tokenEndPoint, Constants.SAP_FERT_AUTH_HEADER);
        String cookies = tokenMap.get('cookies');
        String token = tokenMap.get('token');

        String body = getFertWrapper(opp);

        Map<String,String> headerMap = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        headerMap.put('X-CSRF-Token',token);
        headerMap.put('Cookie',cookies);
        headerMap.put('Authorization',HTTPUtility.getSAPCalloutHeader(Constants.SAP_FERT_AUTH_HEADER));

        HttpUtility.getInstance().httpReqHelper(headerMap,'POST',body,endPoint, oppId);
    }

    public static void submitProdTOSAP(String body){
        system.debug('body-->'+body);
        String endPoint = 'callout:Fert_SAP'+ System.Label.SAP_Fert_URL;
        String tokenEndPoint = 'callout:Fert_SAP'+System.Label.SAP_Fert_URL;

        Map<String,String> tokenMap = SAPRequestTokenHeader.getInstance().getCSRFToken(tokenEndPoint, Constants.SAP_FERT_AUTH_HEADER);
        String cookies = tokenMap.get('cookies');
        String token = tokenMap.get('token');

        Map<String,String> headerMap = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        headerMap.put('X-CSRF-Token',token);
        headerMap.put('Cookie',cookies);
        headerMap.put('Authorization',HTTPUtility.getSAPCalloutHeader(Constants.SAP_FERT_AUTH_HEADER));

        //HttpUtility.getInstance().httpReqHelper(headerMap,'POST',body,endPoint /*, oppId*/);
        //HttpUtility.createLog(body,resp,startDate,endDate /*, null*/);

        DateTime sDate = System.now();
        Map<String,String> respMap = new Map<String,String>();
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(endpoint);
        httpRequest.setMethod('POST');
        httpRequest.setBody(body);
        //httpRequest.setTimeout(600);     
        system.debug('headerMap -- ' + headerMap);

        if(!headerMap.isEmpty()){
            for(String key : headerMap.keySet()){
                httpRequest.setHeader(key,headerMap.get(key));
            }
        }

        System.debug('EndPoint-- '+endPoint);
        System.debug('X-CSRF-Token- '+httpRequest.getHeader('X-CSRF-Token'));
        System.debug('Authorization- '+httpRequest.getHeader('Authorization'));
        System.debug('Cookies- '+httpRequest.getHeader('Cookie'));

        Http http = new Http();
        HTTPResponse response = http.send(httpRequest);
        DateTime eDate = System.now();

        System.debug('RESPONSE BODY FERT----'+response.getBody());
        System.debug('AUTHHEADER FERT-----'+httpRequest);
        HttpUtility.createLog(httpRequest,response,sDate,eDate, null);

       if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            system.debug('Success -- ');
        }
    }


    @future(callout=true)
    public static void createBulkProdWrapper(String customerSAPCode, Map<Id,Id> prodToUpdate){
        System.debug('--- createBulkProdWrapper '+ customerSAPCode + ' --- ' + prodToUpdate);
        if(String.isBlank(customerSAPCode) || prodToUpdate==null || prodToUpdate.isEmpty())
            return;

        Map<Id,OpportunityLineItem> prodMap = new Map<Id,OpportunityLineItem>([Select Id,Name,FERT_Code__c,CurrencyIsoCode,UnitPrice,Quantity_Unit__c From OpportunityLineItem Where Id IN :prodToUpdate.keySet() OR ID IN :prodToUpdate.values()]);
        
        List<OpportunityLineItem> oppProd = new List<OpportunityLineItem>();

        for(String id : prodToUpdate.keySet()){
            if(prodMap.containsKey(id)){
                if(prodToUpdate.get(id)==null)
                    oppProd.add(prodMap.get(id)); // new product
                else if(prodMap.containsKey(prodToUpdate.get(id)) && prodMap.get(id).UnitPrice != prodMap.get(prodToUpdate.get(id)).UnitPrice){ // existing product but price change
                    oppProd.add(prodMap.get(id));
                }    
            }
        }

        if(!oppProd.isEmpty()){
            String body = getWrapperInBulk(customerSAPCode,oppProd);
            System.debug('--- FERT Body'+body);
            submitProdTOSAP(body);
        }
    }

    public static String getWrapperInBulk(String customerSAPCode, List<OpportunityLineItem> oppItems){
        FertWrapper fWrapper = new FertWrapper();
        fWrapper.CUSTOMER = customerSAPCode;
        List<FertProducts> fertProducts = new List<FertProducts>();

        for(OpportunityLineItem item : oppItems){
            FertProducts prod = new FertProducts();
            prod.PRODUCT_CODE = item.FERT_Code__c;
            prod.AMOUNT = item.UnitPrice;
            prod.UNIT = item.Quantity_Unit__c;
            prod.XCURRENCY = item.CurrencyIsoCode;

            fertProducts.add(prod);
        }
        fWrapper.PRODUCTS = fertProducts;

        String body = Json.serialize(fWrapper);
        body = body.replace('XCURRENCY','CURRENCY');
        return body;
    }


    public static Opportunity getOpportunity(String oppId){
        return [Select Id, Name, Customer_Billing_Address__c, Customer_Billing_Address__r.Customer_Code_SAP__c, Account_Billing_Address__c, Account.Customer_Code_SAP__c,(Select Id,Name,FERT_Code__c,CurrencyIsoCode,UnitPrice,Quantity_Unit__c From OpportunityLineItems) From Opportunity Where Id=:oppId];
    }

    public static String getFertWrapper(Opportunity opp){

        String customerCodeSAP = '';

        if(opp.Account_Billing_Address__c){
            customerCodeSAP = opp.Account.Customer_Code_SAP__c;
        }
        else if(opp.Customer_Billing_Address__c != null){
            customerCodeSAP = opp.Customer_Billing_Address__r.Customer_Code_SAP__c;
        }

        FertWrapper fWrapper = new FertWrapper();
        fWrapper.CUSTOMER = customerCodeSAP;
        fWrapper.PRODUCTS = getProducts(opp);

        String body = Json.serialize(fWrapper);
        body = body.replace('XCURRENCY','CURRENCY');

        return body;
    }

    public static List<FertProducts> getProducts(Opportunity opp){
        List<FertProducts> fertProducts = new List<FertProducts>();
        if(opp.OpportunityLineItems!=null && !opp.OpportunityLineItems.isEmpty()){
            for(OpportunityLineItem item : opp.OpportunityLineItems){
                FertProducts prod = new FertProducts();
                prod.PRODUCT_CODE = item.FERT_Code__c;
                prod.AMOUNT = item.UnitPrice;
                prod.UNIT = item.Quantity_Unit__c;
                prod.XCURRENCY = item.CurrencyIsoCode;

                fertProducts.add(prod);
            }
        }

        return fertProducts;
    }

    public class FertWrapper{
        public String CUSTOMER;
        public List<FertProducts> PRODUCTS;
    }

    public class FertProducts{
        public String PRODUCT_CODE;
        public Decimal AMOUNT;
        public String UNIT;
        public String XCURRENCY;
    }
}