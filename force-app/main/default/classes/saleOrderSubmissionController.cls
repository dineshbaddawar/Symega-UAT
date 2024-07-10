public class saleOrderSubmissionController {
    
    /*@AuraEnabled
public static string submitSaleOrder(String soId){
try {
Sales_Order__c so = [Select Id, Account__c, 

Opportunity__r.Account.Customer_Code_SAP__c,Opportunity__r.AccountId,  Opportunity__r.Account.Submitted_to_SAP__c, Opportunity__r.Account.SAP_Update_Customer__c, 
Opportunity__r.Account.Shipping_Submitted_to_SAP__c, Opportunity__r.Account.Shipping_SAP_Update_Customer__c, Opportunity__r.Account.Shipping_Customer_Code_SAP__c,

Opportunity__r.Selected_Billing_Customer_Code__c, Opportunity__r.Selected_Shipping_Customer_Code__c,
Opportunity__r.Account_Billing_Address__c,Opportunity__r.Customer_Billing_Address__c,
Opportunity__r.Account_Shipping_Address__c, Opportunity__r.Customer_Shipping_Address__c, 

Opportunity__r.Customer_Billing_Address__r.SAP_Update_Customer__c, Opportunity__r.Customer_Billing_Address__r.Submitted_to_SAP__c,
Opportunity__r.Customer_Shipping_Address__r.SAP_Update_Customer__c, Opportunity__r.Customer_Shipping_Address__r.Submitted_to_SAP__c

From Sales_Order__c Where Id=:soId
];


Boolean isBillingAccount;
if(so.Opportunity__r.Account_Billing_Address__c){
isBillingAccount = true;
}
else if(so.Opportunity__r.Customer_Billing_Address__c != null){
isBillingAccount = false;
}

Boolean isShippingAccount;
if(so.Opportunity__r.Account_Shipping_Address__c){
isShippingAccount = true;
}
else if(so.Opportunity__r.Customer_Shipping_Address__c != null){
isShippingAccount = false;
}

string respNEW = '';

if(!so.Opportunity__r.Selected_Billing_Customer_Code__c || !so.Opportunity__r.Selected_Shipping_Customer_Code__c){
System.debug('1st Cust Code NULL----');

if(!so.Opportunity__r.Selected_Billing_Customer_Code__c){
if(so.Opportunity__r.Account_Billing_Address__c){

if(!so.Opportunity__r.Account.Submitted_to_SAP__c)
callFutureForAccountCreation(so.Opportunity__r.AccountId);

if(!so.Opportunity__r.Selected_Shipping_Customer_Code__c){
system.debug('Hiii... Inside Empty Shipping Customer Code Part... Test 1232uoi2');
if(isShippingAccount){
system.debug('Hiii... Inside Shipping Acount Part... 2eu83ui');

if(!so.Opportunity__r.Account.Shipping_Submitted_to_SAP__c)
callFutureForShippingAccountCreation(so.Opportunity__r.AccountId); 
respNEW = 'shipping account create';
}
else{
system.debug('Hiii... Inside Shipping Address Part... 3872ujr');
if(!so.Opportunity__r.Account.Shipping_Submitted_to_SAP__c)
callFutureForAddressCreation(so.Opportunity__r.AccountId);
respNEW = 'shipping address create';
}
}
else{
system.debug('Hiii... Inside Empty Shipping Customer Code Part... Test 1232uoi2');
if(isShippingAccount && !so.Opportunity__r.Account.Shipping_SAP_Update_Customer__c){
system.debug('Hiii... Inside Shipping Acount Part... 2eu83ui');
callFutureForShippingAccountUpdation(so.Opportunity__r.AccountId);  
respNEW = 'shipping account update';
}
else if(!isShippingAccount && !so.Opportunity__r.Customer_Shipping_Address__r.SAP_Update_Customer__c){
system.debug('Hiii... Inside Shipping Address Part... 3872ujr');
callFutureForAddressUpdation(so.Opportunity__r.Customer_Shipping_Address__c);
respNEW = 'shipping address update';
}
}
}                    
else if(!so.Opportunity__r.Account_Billing_Address__c){

if(!so.Opportunity__r.Customer_Billing_Address__r.Submitted_to_SAP__c)
callFutureForAddressCreation(so.Opportunity__r.Customer_Billing_Address__c);

if(!so.Opportunity__r.Selected_Shipping_Customer_Code__c){
system.debug('Hiii... Inside Empty Shipping Customer Code Part... Test 1232uoi2');
if(isShippingAccount){
system.debug('Hiii... Inside Shipping Acount Part... 2eu83ui');
callFutureForShippingAccountCreation(so.Opportunity__r.AccountId);     
respNEW = 'shipping account create';
}
else{
system.debug('Hiii... Inside Shipping Address Part... 3872ujr');
callFutureForAddressCreation(so.Opportunity__r.Customer_Shipping_Address__c);
respNEW = 'shipping address create';
}
}
else{
system.debug('Hiii... Inside Empty Shipping Customer Code Part... Test 1232uoi2');
if(isShippingAccount && !so.Opportunity__r.Account.Shipping_SAP_Update_Customer__c){
system.debug('Hiii... Inside Shipping Acount Part... 2eu83ui');
callFutureForShippingAccountUpdation(so.Opportunity__r.AccountId); 
respNEW = 'shipping account update';
}
else if(!isShippingAccount && !so.Opportunity__r.Customer_Shipping_Address__r.SAP_Update_Customer__c){
system.debug('Hiii... Inside Shipping Address Part... 3872ujr');
callFutureForAddressUpdation(so.Opportunity__r.Customer_Shipping_Address__c);
respNEW = 'shipping address update';
}
}
}

}
else if(!so.Opportunity__r.Selected_Shipping_Customer_Code__c){

if(isShippingAccount){ 
system.debug('Hiii... Inside Shipping Account Part... Test 123hgj278');
callFutureForShippingAccountCreation(so.Opportunity__r.AccountId);
respNEW = 'shipping account create';
}
else{
system.debug('Hiii... Inside Shipping Address Part... 398ijkdsdnfjs');
callFutureForAddressCreation(so.Opportunity__r.Customer_Shipping_Address__c);
respNEW = 'shipping address create';
}
}
}
else if(so.Opportunity__r.Selected_Billing_Customer_Code__c && so.Opportunity__r.Selected_Shipping_Customer_Code__c){
system.debug('All is fine...');
Utility.sendSONotification(soId);
}

String oppId = [Select Opportunity__c from Sales_Order__c Where Id =:soId].Opportunity__c;
if(!String.isEmpty(oppId)){
Opportunity op2p = new Opportunity(Id=oppId, StageName='Closed Won');
update op2p;
}

Sales_Order__c sOrder = new Sales_Order__c(Id=soId, Submission_Date__c=Date.Today());
update sOrder;
return 'Success';
} 
catch (Exception e) {
throw new AuraHandledException(e.getMessage());
}
} */
    
    
    @future(callout=true)
    public static void callFutureForAddressUpdation(Id caId){
        Dispatch_Address__c addrRec = [SELECT Id, Submitted_to_SAP__c, SAP_Update_Customer__c FROM Dispatch_Address__c WHERE Id =: caId];
        String resp = SAP_ADDRESS_UPDATE_CALLOUT.syncAddressCustomersWithSAP(caId);
        if(resp.equalsIgnoreCase('Success')){
            if(addrRec.Submitted_to_SAP__c != true){
                addrRec.Submitted_to_SAP__c = true;
                update addrRec;
            }
        }
        if(addrRec.SAP_Update_Customer__c != true){
            addrRec.SAP_Update_Customer__c = true;
            update addrRec;
        }
    }
    
    @future(callout=true)
    public static void callFutureForAddressCreation(Id caId){
        Dispatch_Address__c addrRec = [SELECT Id, Submitted_to_SAP__c, SAP_Update_Customer__c FROM Dispatch_Address__c WHERE Id =: caId];
        String resp = SAP_CreateAddressCustomerCallout.createCustomer(caId, false);
        if(resp.equalsIgnoreCase('Success')){
            if(addrRec.Submitted_to_SAP__c != true){
                addrRec.Submitted_to_SAP__c = true;
                update addrRec;
            }
        }
        if(addrRec.SAP_Update_Customer__c != true){
            addrRec.SAP_Update_Customer__c = true;
            update addrRec;
        }
    }
    
    @future(callout=true)
    public static void callFutureForAccountUpdation(Id accId){
        Account accRec = [SELECT Id, SAP_Update_Customer__c FROM Account WHERE Id =: accId];
        String resp = SAP_CUSTOMER_UPDATE_CALLOUT.syncCustomersWithSAP(accId);
        if(resp.equalsIgnoreCase('Success')){
            if(accRec.SAP_Update_Customer__c != true){
                accRec.SAP_Update_Customer__c = true;
                update accRec;
            } 
        }        
    }
    
    @future(callout=true)
    public static void callFutureForAccountCreation(Id accId){
        Account accRec = [SELECT Id, Submitted_to_SAP__c, SAP_Update_Customer__c FROM Account WHERE Id =: accId];
        String resp = SAP_CreateCustomerCallout.createCustomer(accId, false);
        if(resp.equalsIgnoreCase('Success')){
            if(accRec.Submitted_to_SAP__c != true){
                accRec.Submitted_to_SAP__c = true;
                update accRec;
            }
        }
        
        if(accRec.SAP_Update_Customer__c != true){
            accRec.SAP_Update_Customer__c = true;
            update accRec;
        } 
    }
    
    @future(callout=true)
    public static void callFutureForShippingAccountUpdation(Id accId){
        Account accRec = [SELECT Id, Shipping_SAP_Update_Customer__c FROM Account WHERE Id =: accId];
        String resp = SAP_CUSTOMER_UPDATE_CALLOUT_shipping.syncCustomersWithSAP(accId);
        if(resp.equalsIgnoreCase('Success')){
            if(accRec.Shipping_SAP_Update_Customer__c != true){
                accRec.Shipping_SAP_Update_Customer__c = true;
                update accRec;
            } 
        } 
    }
    
    @future(callout=true)
    public static void callFutureForShippingAccountCreation(Id accId){
        Account accRec = [SELECT Id, Shipping_Submitted_to_SAP__c, Shipping_SAP_Update_Customer__c FROM Account WHERE Id =: accId];
        String resp = SAP_CreateShippingCustomerCallout_NEW.createCustomer(accId, false);
        if(resp.equalsIgnoreCase('Success')){
            if(accRec.Shipping_Submitted_to_SAP__c != true){
                accRec.Shipping_Submitted_to_SAP__c = true;
                update accRec;
            }
        }
        
        if(accRec.Shipping_SAP_Update_Customer__c != true){
            accRec.Shipping_SAP_Update_Customer__c = true;
            update accRec;
        }
    }
    
    
    
    
    @AuraEnabled
    public static string submitSaleOrder(String soId){
        try {
            
            Sales_Order__c so = [Select Id, Send_Sales_Ops_Email__c, Account__c,Opportunity__r.Account.Customer_Code_SAP__c,Opportunity__r.AccountId, Opportunity__r.Customer_Billing_Address__r.SAP_Update_Customer__c,
                                 Opportunity__r.Account_Billing_Address__c,Opportunity__r.Customer_Billing_Address__c,
                                 Opportunity__r.Customer_Billing_Address__r.Customer_Code_SAP__c, Opportunity__r.Account.SAP_Update_Customer__c, Opportunity__r.Account.Submitted_to_SAP__c,
                                 Opportunity__r.Customer_Billing_Address__r.Submitted_to_SAP__c,
                                 
                                 Opportunity__r.Account.Shipping_SAP_Update_Customer__c, Opportunity__r.Selected_Shipping_Customer_Code__c,
                                 
                                 Opportunity__r.Selected_Billing_Customer_Code__c,
                                 
                                 Opportunity__r.Customer_Shipping_Address__r.SAP_Update_Customer__c, 
                                 
                                 Opportunity__r.Account.Shipping_Customer_Code_SAP__c, Opportunity__r.Account_Shipping_Address__c, Opportunity__r.Customer_Shipping_Address__c, 
                                 Opportunity__r.Customer_Shipping_Address__r.Customer_Code_SAP__c, Opportunity__r.Account.Shipping_Submitted_to_SAP__c, Opportunity__r.Customer_Shipping_Address__r.Submitted_to_SAP__c
                                 
                                 From Sales_Order__c Where Id=:soId
                                ];
            
            
            string response = '';
            if(so.Opportunity__r.Account_Billing_Address__c){
                if (so.Opportunity__r.Account_Shipping_Address__c) {
                    
                    system.debug('Handle Account Billing And Shipping -->> ');
                    response = handleAccountBillingAndShipping(so);
                } 
                else {
                    
                    system.debug('Handle Account Billing And Customer Address Shipping -->> ');
                    response = handleAccountBillingAndCustomerShipping(so);
                }
            }
            else{
                if (so.Opportunity__r.Account_Shipping_Address__c) {
                    
                    system.debug('Handle Customer Billing And Account Shipping -->> ');
                    response = handleCustomerBillingAndAccountShipping(so);
                } 
                else {
                    
                    system.debug('Handle Customer Billing And Shipping -->> ');
                    response = handleCustomerBillingAndShipping(so);
                }
            }
            
            if(response == 'Success'){
                String oppId = [Select Opportunity__c from Sales_Order__c Where Id =:soId].Opportunity__c;
                if(!String.isEmpty(oppId)){
                    Opportunity op2p = new Opportunity(Id=oppId, StageName='Closed Won');
                    update op2p;
                }
                
                Sales_Order__c sOrder = new Sales_Order__c(Id=soId, Submission_Date__c=Date.Today());
                update sOrder;
            }
            
            return response;
        } 
        catch (Exception ex) {
            system.debug('Error in testMethod1 -->> ' + ex.getMessage() + ' At Line No -->> ' + ex.getLineNumber());
            return ex.getMessage();
            //throw new AuraHandledException(e.getMessage());
        }
    }
    
    private static string handleAccountBillingAndShipping(Sales_Order__c soRec){
        if(soRec.Opportunity__r.Selected_Billing_Customer_Code__c && soRec.Opportunity__r.Selected_Shipping_Customer_Code__c){
            system.debug('handleAccountBillingAndShipping -->> Billing and Shipping Codes are present');
            /*if(soRec.Opportunity__r.Account.SAP_Update_Customer__c && soRec.Opportunity__r.Account.Shipping_SAP_Update_Customer__c){
Utility.sendSONotification(soRec.Id);
system.debug('Notification sent');
response = 'Success';
}
else{
if(!soRec.Opportunity__r.Account.SAP_Update_Customer__c){
system.debug('Account Billing Update');
callFutureForAccountUpdation(soRec.Opportunity__r.AccountId);
}
if(!soRec.Opportunity__r.Account.Shipping_SAP_Update_Customer__c){
system.debug('Account Shipping Update');
callFutureForShippingAccountUpdation(soRec.Opportunity__r.AccountId);
}
}*/
            
            //if(!soRec.Opportunity__r.Account.SAP_Update_Customer__c){
            system.debug('Account Billing Update');
            callFutureForAccountUpdation(soRec.Opportunity__r.AccountId);
            // }
            //if(!soRec.Opportunity__r.Account.Shipping_SAP_Update_Customer__c){
            system.debug('Account Shipping Update');
            callFutureForShippingAccountUpdation(soRec.Opportunity__r.AccountId);
            //}
            Utility.sendSONotification(soRec.Id);
            system.debug('Notification sent');
            return 'Success';
        }
        else{
            if(!soRec.Opportunity__r.Selected_Billing_Customer_Code__c && !soRec.Opportunity__r.Account.Submitted_to_SAP__c){
                system.debug('Account Billing Creation in Progress');
                callFutureForAccountCreation(soRec.Opportunity__r.AccountId);
            }
            if(!soRec.Opportunity__r.Selected_Shipping_Customer_Code__c && !soRec.Opportunity__r.Account.Shipping_Submitted_to_SAP__c){
                system.debug('Account Shipping Creation in Progress');
                callFutureForShippingAccountCreation(soRec.Opportunity__r.AccountId);
            }
            updateSO(soRec);
            return 'Customer Creation in Progress';
        }     
    }
    
    private static string handleAccountBillingAndCustomerShipping(Sales_Order__c soRec){
        try{
            if(soRec.Opportunity__r.Selected_Billing_Customer_Code__c && soRec.Opportunity__r.Selected_Shipping_Customer_Code__c){
                system.debug('handleAccountBillingAndCustomerShipping -->> Billing and Shipping Codes are present');
                //if(!soRec.Opportunity__r.Account.SAP_Update_Customer__c){
                system.debug('Account Billing Update');
                callFutureForAccountUpdation(soRec.Opportunity__r.AccountId);
                //}
                //if(!soRec.Opportunity__r.Customer_Shipping_Address__r.SAP_Update_Customer__c){
                system.debug('Customer Shipping Update');
                callFutureForAddressUpdation(soRec.Opportunity__r.Customer_Shipping_Address__c);
                //}            
                Utility.sendSONotification(soRec.Id);
                system.debug('Notification sent');
                return 'Success';
            }
            else{
                if(!soRec.Opportunity__r.Selected_Billing_Customer_Code__c && !soRec.Opportunity__r.Account.Submitted_to_SAP__c){
                    system.debug('Account Billing Creation in Progress');
                    callFutureForAccountCreation(soRec.Opportunity__r.AccountId);
                }
                if(!soRec.Opportunity__r.Selected_Shipping_Customer_Code__c && !soRec.Opportunity__r.Customer_Shipping_Address__r.Submitted_to_SAP__c){
                    system.debug('Customer Shipping Creation in Progress');
                    callFutureForAddressCreation(soRec.Opportunity__r.Customer_Shipping_Address__c);
                }
                updateSO(soRec);
                return 'Customer Creation in Progress';
            }     
        }
        catch(Exception ex){
            system.debug('Error in handleAccountBillingAndCustomerShipping -->> ' + ex.getMessage() + ' At Line No -->> ' + ex.getLineNumber());
            return ex.getMessage();
        }
    }
    
    private static string handleCustomerBillingAndAccountShipping(Sales_Order__c soRec){
        if(soRec.Opportunity__r.Selected_Billing_Customer_Code__c && soRec.Opportunity__r.Selected_Shipping_Customer_Code__c){
            system.debug('handleCustomerBillingAndAccountShipping -->> Billing and Shipping Codes are present');
            
            //if(!soRec.Opportunity__r.Customer_Billing_Address__r.SAP_Update_Customer__c){
            system.debug('Customer Billing Update');
            callFutureForAddressUpdation(soRec.Opportunity__r.Customer_Billing_Address__c);
            //}
            //if(!soRec.Opportunity__r.Account.Shipping_SAP_Update_Customer__c){
            system.debug('Account Shipping Update');
            callFutureForShippingAccountUpdation(soRec.Opportunity__r.AccountId);
            //}
            
            Utility.sendSONotification(soRec.Id);
            system.debug('Notification sent');
            return 'Success';
        }
        else{
            if(!soRec.Opportunity__r.Selected_Billing_Customer_Code__c && !soRec.Opportunity__r.Customer_Billing_Address__r.Submitted_to_SAP__c){
                system.debug('Customer Billing Creation in Progress');
                callFutureForAddressCreation(soRec.Opportunity__r.Customer_Billing_Address__c);
            }
            if(!soRec.Opportunity__r.Selected_Shipping_Customer_Code__c && !soRec.Opportunity__r.Account.Shipping_Submitted_to_SAP__c){
                system.debug('Account Shipping Creation in Progress');
                callFutureForAccountCreation(soRec.Opportunity__r.AccountId);
            }
            updateSO(soRec);
            return 'Customer Creation in Progress';
        }    
    }
    
    private static string handleCustomerBillingAndShipping(Sales_Order__c soRec){
        if(soRec.Opportunity__r.Selected_Billing_Customer_Code__c && soRec.Opportunity__r.Selected_Shipping_Customer_Code__c){
            system.debug('handleCustomerBillingAndShipping -->> Billing and Shipping Codes are present');
            
            //if(!soRec.Opportunity__r.Customer_Billing_Address__r.SAP_Update_Customer__c){
            system.debug('Customer Billing Update');
            callFutureForAddressUpdation(soRec.Opportunity__r.Customer_Billing_Address__c);
            //}
            //if(!soRec.Opportunity__r.Customer_Shipping_Address__r.SAP_Update_Customer__c){
            system.debug('Customer Shipping Update');
            callFutureForAddressUpdation(soRec.Opportunity__r.Customer_Shipping_Address__c);
            // }
            
            Utility.sendSONotification(soRec.Id);
            system.debug('Notification sent');
            return 'Success';
        }
        else{
            if(!soRec.Opportunity__r.Selected_Billing_Customer_Code__c && !soRec.Opportunity__r.Customer_Billing_Address__r.Submitted_to_SAP__c){
                system.debug('Customer Billing Creation in Progress');
                callFutureForAddressCreation(soRec.Opportunity__r.Customer_Billing_Address__c);
            }
            if(!soRec.Opportunity__r.Selected_Shipping_Customer_Code__c && !soRec.Opportunity__r.Customer_Shipping_Address__r.Submitted_to_SAP__c){
                system.debug('Customer Shipping Creation in Progress');
                callFutureForAddressCreation(soRec.Opportunity__r.Customer_Shipping_Address__c);
            }
            updateSO(soRec);
            return 'Customer Creation in Progress';
        }    
    }
    
    private static void updateSO(Sales_Order__c so){
        try {
            if(!so.Send_Sales_Ops_Email__c){
                so.Send_Sales_Ops_Email__c = true;
                update so;            
            }
        } 
        catch (Exception ex) {
            system.debug('Error in updateSO -->> ' + ex.getMessage() + ' At Line No -->> ' + ex.getLineNumber());
        }
    }
    
    
    @AuraEnabled
    public static soWrapper getLineItemDetails(String recId){
        List<OpportunityLineItem> lineItems = [SELECT Id, Sales_Order__c, Sales_Order__r.Account__c, Sales_Order__r.Account__r.Initial_SAP_Update__c,
                                               Sales_Order__r.Opportunity__r.Account_Billing_Address__c, Sales_Order__r.Opportunity__r.Account_Shipping_Address__c, Sales_Order__r.Opportunity__r.Customer_Shipping_Address__c,Sales_Order__r.Opportunity__r.AccountId, Sales_Order__r.Opportunity__r.Customer_Billing_Address__c
                                               FROM OpportunityLineItem WHERE Sales_Order__c =: recId];
        List<OpportunityLineItem> withFERTcodeItems = [SELECT Id, FERT_Code__c FROM OpportunityLineItem WHERE Sales_Order__c =: recId AND FERT_Code__c != NULL];
        
        system.debug('withFERTcodeItems.size() -- ' + withFERTcodeItems.size());
        system.debug('lineItems.size() -- ' + lineItems.size());
        
        soWrapper sWrap = new soWrapper();
        sWrap.accRecId = lineItems[0].Sales_Order__r.Account__c;
        
        if(lineItems.size() == withFERTcodeItems.size()){
            sWrap.fertCodesPresentForAll = true;
        }
        else{
            sWrap.fertCodesPresentForAll = false;
        }
        
        Sales_Order__c soRec = [SELECT Id, Opportunity__r.AccountId, Opportunity__r.Customer_Shipping_Address__c, Opportunity__r.Customer_Billing_Address__c FROM Sales_Order__c WHERE Id =: recId];
        missingListWrapper getMissingDetails = new missingListWrapper();
        
        sWrap.accRecId = lineItems[0].Sales_Order__r.Opportunity__r.AccountId;
        sWrap.billingDispRecId = lineItems[0].Sales_Order__r.Opportunity__r.Customer_Billing_Address__c;
        sWrap.shippingDispRecId = lineItems[0].Sales_Order__r.Opportunity__r.Customer_Shipping_Address__c;
        
        if(lineItems[0].Sales_Order__r.Opportunity__r.Account_Billing_Address__c){
            if(lineItems[0].Sales_Order__r.Opportunity__r.Account_Shipping_Address__c) {
                
                system.debug('Handle Account Billing And Shipping -->> ');
                sWrap.isBilling_ShippingAccount = true;
                getMissingDetails = ValidateAccountBillingAndShipping(soRec);
            } 
            else if(lineItems[0].Sales_Order__r.Opportunity__r.Customer_Shipping_Address__c != null){
                
                system.debug('Handle Account Billing And Customer Address Shipping -->> ');
                sWrap.isAccBilling_ShippigCustomer = true;
                getMissingDetails = ValidateAccountBillingAndCustomerShipping(soRec);
            }
        }
        else if(lineItems[0].Sales_Order__r.Opportunity__r.Customer_Billing_Address__c != null){
            if (lineItems[0].Sales_Order__r.Opportunity__r.Account_Shipping_Address__c) {
                
                system.debug('Handle Customer Billing And Account Shipping -->> ');
                sWrap.isBillingCustomer_AccShipping = true;
                getMissingDetails = ValidateCustomerBillingAndAccountShipping(soRec);
            } 
            else if(lineItems[0].Sales_Order__r.Opportunity__r.Customer_Shipping_Address__c != null){
                
                system.debug('Handle Customer Billing And Shipping -->> ');
                sWrap.isCustomerBilling_Shipping = true;
                getMissingDetails = ValidateCustomerBillingAndShipping(soRec);
            }
        }
        
        sWrap.accountMissingFieldList = getMissingDetails.accountMissingFieldList;
        sWrap.billingCustMissingFieldList = getMissingDetails.billingCustMissingFieldList;
        sWrap.shippingCustMissingFieldList = getMissingDetails.shippingCustMissingFieldList;
        sWrap.onlyAccMissingFieldList = getMissingDetails.onlyAccMissingFieldList;
        sWrap.userId = getMissingDetails.userId;
        sWrap.bhId = getMissingDetails.bhId;
        sWrap.addressUserId = getMissingDetails.addressUserId;
        sWrap.pickValList = GetPicklistValues_Object();
        sWrap.reqFieldsMissing = getMissingDetails.reqFieldMissing;
        
        return sWrap;
    }
    
    private static Map<String,Map<String,List<String>>> GetPicklistValues_Object(){
        string ObjectName,FieldApi_Name;
        
        ObjectName='Account';FieldApi_Name='Delivery_Plant__c';
        getPickListValuesIntoList(ObjectName,FieldApi_Name);
        
        Map<String,Map<String,List<String>>> ObjectName_FieldApiName_PickListValue=new Map<String,Map<String,List<String>>>();
        
        if(FieldApi_Name=='Delivery_Plant__c'){
            Map<String,List<String>> getPickListValuesIntoList= getPickListValuesIntoList(ObjectName,FieldApi_Name);   
            ObjectName_FieldApiName_PickListValue.put('Delivery_Plant__c',getPickListValuesIntoList);
            FieldApi_Name='Customer_Type__c';  
        }
        if(FieldApi_Name=='Customer_Type__c'){
            Map<String,List<String>> getPickListValuesIntoList= getPickListValuesIntoList(ObjectName,FieldApi_Name);   
            ObjectName_FieldApiName_PickListValue.put('Customer_Type__c',getPickListValuesIntoList);
            FieldApi_Name='Account_Segment__c';              
        }
        if(FieldApi_Name=='Account_Segment__c'){
            Map<String,List<String>> getPickListValuesIntoList= getPickListValuesIntoList(ObjectName,FieldApi_Name);   
            ObjectName_FieldApiName_PickListValue.put('Account_Segment__c',getPickListValuesIntoList);
            FieldApi_Name='Tax_Type__c';              
        }
        if(FieldApi_Name=='Tax_Type__c'){
            Map<String,List<String>> getPickListValuesIntoList= getPickListValuesIntoList(ObjectName,FieldApi_Name);   
            ObjectName_FieldApiName_PickListValue.put('Tax_Type__c',getPickListValuesIntoList);
            FieldApi_Name='Tax_Collected_At_Source__c';   
        }
        if(FieldApi_Name=='Tax_Collected_At_Source__c'){
            Map<String,List<String>> getPickListValuesIntoList= getPickListValuesIntoList(ObjectName,FieldApi_Name);   
            ObjectName_FieldApiName_PickListValue.put('Tax_Collected_At_Source__c',getPickListValuesIntoList);
            FieldApi_Name='Payment_terms__c';              
        }
        if(FieldApi_Name=='Payment_terms__c'){
            Map<String,List<String>> getPickListValuesIntoList= getPickListValuesIntoList(ObjectName,FieldApi_Name);   
            ObjectName_FieldApiName_PickListValue.put('Payment_terms__c',getPickListValuesIntoList);
            FieldApi_Name='Transportation_Terms__c';   
        }
        if(FieldApi_Name=='Transportation_Terms__c'){
            Map<String,List<String>> getPickListValuesIntoList= getPickListValuesIntoList(ObjectName,FieldApi_Name);   
            ObjectName_FieldApiName_PickListValue.put('Transportation_Terms__c',getPickListValuesIntoList);
        }
        
        return ObjectName_FieldApiName_PickListValue;
    }
    
    public static Map<String,List<String>> getPickListValuesIntoList(String ObjectName,String FieldApiName){
        
        Map<String,List<String>> ObjectName_FieldApiName_PickListValue=new  Map<String,List<String>>();
        List<String> pickListValuesList= new List<String>();
        
        Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe() ;
        Map<String,Schema.SObjectField> fields = objDescribeSobject.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(FieldApiName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());  
        }
        ObjectName_FieldApiName_PickListValue.put(FieldApiName,pickListValuesList);
        return ObjectName_FieldApiName_PickListValue;
    }
    
    
    
    private static missingListWrapper ValidateAccountBillingAndShipping(Sales_Order__c soRec){
        List<String> accountMissingFieldList = new List<String>();
        missingListWrapper mlw = new missingListWrapper();
        Id userId = null;
        Id bhId = null;
        
        Account accRec = [Select Id, Initial_SAP_Update__c, Name, User__c, Customer_Contact__c, Customer_Type__c,OwnerId,CurrencyIsoCode,BillingCity,BillingCountry,BillingStreet,BillingPostalCode,BillingState,
                          Delivery_Plant__c,Account_Segment__c,Transportation_Terms__c,PAN_Number__c,GST_number__c,Tax_Type__c, Payment_terms__c, Tax_Collected_At_Source__c, FSSAI__c 
                          From Account Where Id =: soRec.Opportunity__r.AccountId];
        userId = accRec.OwnerId;
        bhId = accRec.User__c;
        
        if(!accRec.Initial_SAP_Update__c){
            if((accRec.Name == null) || (accRec.Name == '')){
                accountMissingFieldList.add('Name');
            }
            
            if((accRec.BillingCity == null) || (accRec.BillingCity == '')){
                accountMissingFieldList.add('BillingCity');
            }
            
            if(((accRec.BillingState == null) || (accRec.BillingState == '')) && accRec.Customer_Type__c!='Export'){
                accountMissingFieldList.add('BillingState');
                
            }               
            
            if((accRec.BillingStreet == null) || (accRec.BillingStreet == '')){
                accountMissingFieldList.add('BillingStreet');
            }
            
            if((accRec.BillingCountry == null) || (accRec.BillingCountry == '')){
                accountMissingFieldList.add('BillingCountry');
            }
            
            if((accRec.BillingPostalCode == null) || (accRec.BillingPostalCode == '')){
                accountMissingFieldList.add('BillingPostalCode');
            }
            
            if((accRec.Customer_Type__c == null) || (accRec.Customer_Type__c == '')){
                accountMissingFieldList.add('Customer_Type__c');
            }
            
            if((accRec.Account_Segment__c == null) || (accRec.Account_Segment__c == '')){
                accountMissingFieldList.add('Account_Segment__c');
            }
            
            if((accRec.CurrencyIsoCode == null) || (accRec.CurrencyIsoCode == '')){
                accountMissingFieldList.add('CurrencyIsoCode');
            }
            if(accRec.Customer_Contact__c == null){
                accountMissingFieldList.add('Customer_Contact__c');
            }                
            
            if((accRec.Delivery_Plant__c == null) || (accRec.Delivery_Plant__c == '')){
                accountMissingFieldList.add('Delivery_Plant__c');
            }
        }
        
        if(String.isBlank(accRec.Tax_Type__c)){
            accountMissingFieldList.add('Tax_Type__c');
        }
        if(!String.isBlank(accRec.BillingCountry) && accRec.BillingCountry.equalsIgnoreCase('India') && (String.isBlank(accRec.PAN_Number__c) || String.isBlank(accRec.GST_number__c))){
            if(String.isBlank(accRec.PAN_Number__c)){
                accountMissingFieldList.add('PAN_Number__c');
            }
            if(String.isBlank(accRec.GST_number__c)){
                accountMissingFieldList.add('GST_number__c');
            }
        }
        if(String.isBlank(accRec.Payment_terms__c)){
            accountMissingFieldList.add('Payment_terms__c');
        }
        if(String.isBlank(accRec.Tax_Collected_At_Source__c)){
            accountMissingFieldList.add('Tax_Collected_At_Source__c');
        }
        if(accRec.FSSAI__c == null || accRec.FSSAI__c == 0){
            accountMissingFieldList.add('FSSAI__c');
        }
        if(String.isBlank(accRec.Transportation_Terms__c)){
            accountMissingFieldList.add('Transportation_Terms__c');
        }        
        
        System.debug('accountMissingFieldList---->'+accountMissingFieldList); 
        
        List<User> userRec = [SELECT Id, Name, SAP_USER_CODE__c FROM User WHERE Id =: userId];
        if(userRec.size()>0 && userRec[0].SAP_USER_CODE__c != null){
            userId = null;
        }
        
        List<User> bhRec = [SELECT Id, Name, SAP_USER_CODE__c FROM User WHERE Id =: bhId];
        if(bhRec.size()>0 && bhRec[0].SAP_USER_CODE__c != null){
            bhId = null;
        }
        
        mlw.accountMissingFieldList = accountMissingFieldList;
        mlw.userId = userId;
        mlw.bhId = bhId;
        if(accountMissingFieldList.size()>0)
            mlw.reqFieldMissing = true;
        return mlw;        
    }   
    
    private static missingListWrapper ValidateAccountBillingAndCustomerShipping(Sales_Order__c soRec){
        List<String> shippingCustMissingFieldList = new List<String>();
        List<String> accMissingFieldList = new List<String>();
        missingListWrapper mlw = new missingListWrapper();
        Id bhId = null;
        
        Account accRec = [Select Id, Initial_SAP_Update__c, Name, User__c, Customer_Contact__c, Customer_Type__c,OwnerId,CurrencyIsoCode,BillingCity,BillingCountry,BillingStreet,BillingPostalCode,BillingState,
                          Delivery_Plant__c,Account_Segment__c,Transportation_Terms__c,PAN_Number__c,GST_number__c,Tax_Type__c, Payment_terms__c, Tax_Collected_At_Source__c, FSSAI__c 
                          From Account Where Id =: soRec.Opportunity__r.AccountId];
        Id userId = accRec.OwnerId;
        bhId = accRec.User__c;
        
        if(!accRec.Initial_SAP_Update__c){
            if((accRec.Name == null) || (accRec.Name == '')){
                accMissingFieldList.add('Name');
            }
            
            if((accRec.BillingCity == null) || (accRec.BillingCity == '')){
                accMissingFieldList.add('BillingCity');
            }
            
            if(((accRec.BillingState == null) || (accRec.BillingState == '')) && accRec.Customer_Type__c!='Export'){
                accMissingFieldList.add('BillingState');
                
            }               
            
            if((accRec.BillingStreet == null) || (accRec.BillingStreet == '')){
                accMissingFieldList.add('BillingStreet');
            }
            
            if((accRec.BillingCountry == null) || (accRec.BillingCountry == '')){
                accMissingFieldList.add('BillingCountry');
            }
            
            if((accRec.BillingPostalCode == null) || (accRec.BillingPostalCode == '')){
                accMissingFieldList.add('BillingPostalCode');
            }
            
            if((accRec.Customer_Type__c == null) || (accRec.Customer_Type__c == '')){
                accMissingFieldList.add('Customer_Type__c');
            }
            
            if((accRec.Account_Segment__c == null) || (accRec.Account_Segment__c == '')){
                accMissingFieldList.add('Account_Segment__c');
            }
            
            if((accRec.CurrencyIsoCode == null) || (accRec.CurrencyIsoCode == '')){
                accMissingFieldList.add('CurrencyIsoCode');
            }
            if(accRec.Customer_Contact__c == null){
                accMissingFieldList.add('Customer_Contact__c');
            }                
            
            if((accRec.Delivery_Plant__c == null) || (accRec.Delivery_Plant__c == '')){
                accMissingFieldList.add('Delivery_Plant__c');
            }
        }
        
        if(String.isBlank(accRec.Tax_Type__c)){
            accMissingFieldList.add('Tax_Type__c');
        }
        if(!String.isBlank(accRec.BillingCountry) && accRec.BillingCountry.equalsIgnoreCase('India') && (String.isBlank(accRec.PAN_Number__c) || String.isBlank(accRec.GST_number__c))){
            if(String.isBlank(accRec.PAN_Number__c)){
                accMissingFieldList.add('PAN_Number__c');
            }
            if(String.isBlank(accRec.GST_number__c)){
                accMissingFieldList.add('GST_number__c');
            }
        }
        if(String.isBlank(accRec.Payment_terms__c)){
            accMissingFieldList.add('Payment_terms__c');
        }
        if(String.isBlank(accRec.Tax_Collected_At_Source__c)){
            accMissingFieldList.add('Tax_Collected_At_Source__c');
        }
        if(accRec.FSSAI__c == null || accRec.FSSAI__c == 0){
            accMissingFieldList.add('FSSAI__c');
        }
        if(String.isBlank(accRec.Transportation_Terms__c)){
            accMissingFieldList.add('Transportation_Terms__c');
        }
        
        
        Dispatch_Address__c disRec = [select id, Customer_Category__c, Tax_Type__c, FSSAI_Number__c, PAN_Number__c, Initial_SAP_Update__c, Account__r.User__c, Address__city__s, Address__Street__s, Address__PostalCode__s, Address__CountryCode__s, Address__StateCode__s,
                                      Contact__c,Account__c,Type__c, OwnerId, Account__r.Customer_Type__c, Account__r.Account_Segment__c, Account__r.Delivery_Plant__c, CurrencyIsoCode, GST_Number__c,
                                      Account__r.Transportation_Terms__c, Account__r.PAN_Number__c, Account__r.Tax_Type__c, Account__r.Payment_terms__c, Account__r.Tax_Collected_At_Source__c, Account__r.FSSAI__c
                                      from Dispatch_Address__c WHERE Id =: soRec.Opportunity__r.Customer_Shipping_Address__c];
        
        Id addressUserId = disRec.OwnerId;
        
        if(!disRec.Initial_SAP_Update__c){
            if((disRec.Address__city__s == null) || (disRec.Address__city__s == '')){
                shippingCustMissingFieldList.add('Address__city__s');
            }
            
            if(((disRec.Address__StateCode__s == null) || (disRec.Address__StateCode__s == '')) && disRec.Account__r.Customer_Type__c!='Export'){
                shippingCustMissingFieldList.add('Address__StateCode__s');
            }               
            
            if((disRec.Address__Street__s == null) || (disRec.Address__Street__s == '')){
                shippingCustMissingFieldList.add('Address__Street__s');
            }
            
            if((disRec.Address__CountryCode__s == null) || (disRec.Address__CountryCode__s == '')){
                shippingCustMissingFieldList.add('Address__CountryCode__s');
            }
            
            if((disRec.Address__PostalCode__s == null) || (disRec.Address__PostalCode__s == '')){
                shippingCustMissingFieldList.add('Address__PostalCode__s');
            }
            
            if(disRec.Contact__c == null){
                shippingCustMissingFieldList.add('Contact__c');
            } 
            
            if((disRec.CurrencyIsoCode == null) || (disRec.CurrencyIsoCode == '')){
                shippingCustMissingFieldList.add('CurrencyIsoCode');
            }
            
            if(String.isBlank(disRec.Customer_Category__c)){
                shippingCustMissingFieldList.add('Customer_Category__c');
            }
            
        }
        
        if(String.isBlank(disRec.Tax_Type__c)){
            shippingCustMissingFieldList.add('Tax_Type__c');
        }
        if(disRec.FSSAI_Number__c == null || disRec.FSSAI_Number__c == 0){
            shippingCustMissingFieldList.add('FSSAI_Number__c');
        }
        
        if(!String.isBlank(disRec.Address__CountryCode__s) && disRec.Address__CountryCode__s.equalsIgnoreCase('IN') && (String.isBlank(disRec.PAN_Number__c) || String.isBlank(disRec.GST_Number__c))){
            if(String.isBlank(disRec.PAN_Number__c)){
                shippingCustMissingFieldList.add('PAN_Number__c');
            }
            if(String.isBlank(disRec.GST_Number__c)){
                shippingCustMissingFieldList.add('GST_Number__c');
            }
        }                 
        
        
        System.debug('accMissingFieldList---->'+ accMissingFieldList); 
        System.debug('shippingCustMissingFieldList---->'+shippingCustMissingFieldList); 
        
        List<User> userRec = [SELECT Id, Name, SAP_USER_CODE__c FROM User WHERE Id =: userId];
        if(userRec.size()>0 && userRec[0].SAP_USER_CODE__c != null){
            userId = null;
        }
        
        List<User> addressUserRec = [SELECT Id, Name, SAP_USER_CODE__c FROM User WHERE Id =: addressUserId];
        if(addressUserRec.size()>0 && addressUserRec[0].SAP_USER_CODE__c != null){
            addressUserId = null;
        }
        
        List<User> bhRec = [SELECT Id, Name, SAP_USER_CODE__c FROM User WHERE Id =: bhId];
        if(bhRec.size()>0 && bhRec[0].SAP_USER_CODE__c != null){
            bhId = null;
        }
        
        mlw.accountMissingFieldList = accMissingFieldList;
        mlw.shippingCustMissingFieldList = shippingCustMissingFieldList;
        mlw.userId = userId;
        mlw.addressUserId = addressUserId;
        mlw.bhId = bhId;
        if(accMissingFieldList.size()>0 || shippingCustMissingFieldList.size()>0)
            mlw.reqFieldMissing = true;
        return mlw;        
    }   
    
    private static missingListWrapper ValidateCustomerBillingAndAccountShipping(Sales_Order__c soRec){
        List<String> accMissingFieldList = new List<String>();
        List<String> billingCustMissingFieldList = new List<String>();
        missingListWrapper mlw = new missingListWrapper();
        
        Id bhId = null;
        
        Dispatch_Address__c disRec = [select id, Customer_Category__c, Tax_Type__c, FSSAI_Number__c, PAN_Number__c, Initial_SAP_Update__c, Account__r.User__c, Address__city__s, Address__Street__s, Address__PostalCode__s, Address__CountryCode__s, Address__StateCode__s,
                                      Contact__c,Account__c,Type__c, OwnerId, Account__r.Customer_Type__c, Account__r.Account_Segment__c, Account__r.Delivery_Plant__c, CurrencyIsoCode, GST_Number__c,
                                      Account__r.Transportation_Terms__c, Account__r.PAN_Number__c, Account__r.Tax_Type__c, Account__r.Payment_terms__c, Account__r.Tax_Collected_At_Source__c, Account__r.FSSAI__c
                                      from Dispatch_Address__c WHERE Id =: soRec.Opportunity__r.Customer_Billing_Address__c];
        
        Id addressUserId = disRec.OwnerId;
        
        if(!disRec.Initial_SAP_Update__c){
            if((disRec.Address__city__s == null) || (disRec.Address__city__s == '')){
                billingCustMissingFieldList.add('Address__city__s');
            }
            
            if(((disRec.Address__StateCode__s == null) || (disRec.Address__StateCode__s == '')) && disRec.Account__r.Customer_Type__c!='Export'){
                billingCustMissingFieldList.add('Address__StateCode__s');
            }               
            
            if((disRec.Address__Street__s == null) || (disRec.Address__Street__s == '')){
                billingCustMissingFieldList.add('Address__Street__s');
            }
            
            if((disRec.Address__CountryCode__s == null) || (disRec.Address__CountryCode__s == '')){
                billingCustMissingFieldList.add('Address__CountryCode__s');
            }
            
            if((disRec.Address__PostalCode__s == null) || (disRec.Address__PostalCode__s == '')){
                billingCustMissingFieldList.add('Address__PostalCode__s');
            }
            
            if(disRec.Contact__c == null){
                billingCustMissingFieldList.add('Contact__c');
            } 
            
            if((disRec.CurrencyIsoCode == null) || (disRec.CurrencyIsoCode == '')){
                billingCustMissingFieldList.add('CurrencyIsoCode');
            }
            
            if(String.isBlank(disRec.Customer_Category__c)){
                billingCustMissingFieldList.add('Customer_Category__c');
            }
            
        }
        
        if(String.isBlank(disRec.Tax_Type__c)){
            billingCustMissingFieldList.add('Tax_Type__c');
        }
        if(disRec.FSSAI_Number__c == null || disRec.FSSAI_Number__c == 0){
            billingCustMissingFieldList.add('FSSAI_Number__c');
        }
        
        if(!String.isBlank(disRec.Address__CountryCode__s) && disRec.Address__CountryCode__s.equalsIgnoreCase('IN') && (String.isBlank(disRec.PAN_Number__c) || String.isBlank(disRec.GST_Number__c))){
            if(String.isBlank(disRec.PAN_Number__c)){
                billingCustMissingFieldList.add('PAN_Number__c');
            }
            if(String.isBlank(disRec.GST_Number__c)){
                billingCustMissingFieldList.add('GST_Number__c');
            }
        }      
        
        
        Account accRec = [Select Id, Initial_SAP_Update__c, Name, User__c, Customer_Contact__c, Customer_Type__c,OwnerId,CurrencyIsoCode,BillingCity,BillingCountry,BillingStreet,BillingPostalCode,BillingState,
                          Delivery_Plant__c,Account_Segment__c,Transportation_Terms__c,PAN_Number__c,GST_number__c,Tax_Type__c, Payment_terms__c, Tax_Collected_At_Source__c, FSSAI__c 
                          From Account Where Id =: soRec.Opportunity__r.AccountId];
        Id userId = accRec.OwnerId;
        bhId = accRec.User__c;
        
        if(!accRec.Initial_SAP_Update__c){
            if((accRec.Name == null) || (accRec.Name == '')){
                accMissingFieldList.add('Name');
            }
            
            if((accRec.BillingCity == null) || (accRec.BillingCity == '')){
                accMissingFieldList.add('BillingCity');
            }
            
            if(((accRec.BillingState == null) || (accRec.BillingState == '')) && accRec.Customer_Type__c!='Export'){
                accMissingFieldList.add('BillingState');
                
            }               
            
            if((accRec.BillingStreet == null) || (accRec.BillingStreet == '')){
                accMissingFieldList.add('BillingStreet');
            }
            
            if((accRec.BillingCountry == null) || (accRec.BillingCountry == '')){
                accMissingFieldList.add('BillingCountry');
            }
            
            if((accRec.BillingPostalCode == null) || (accRec.BillingPostalCode == '')){
                accMissingFieldList.add('BillingPostalCode');
            }
            
            if((accRec.Customer_Type__c == null) || (accRec.Customer_Type__c == '')){
                accMissingFieldList.add('Customer_Type__c');
            }
            
            if((accRec.Account_Segment__c == null) || (accRec.Account_Segment__c == '')){
                accMissingFieldList.add('Account_Segment__c');
            }
            
            if((accRec.CurrencyIsoCode == null) || (accRec.CurrencyIsoCode == '')){
                accMissingFieldList.add('CurrencyIsoCode');
            }
            if(accRec.Customer_Contact__c == null){
                accMissingFieldList.add('Customer_Contact__c');
            }                
            
            if((accRec.Delivery_Plant__c == null) || (accRec.Delivery_Plant__c == '')){
                accMissingFieldList.add('Delivery_Plant__c');
            }
        }
        
        if(String.isBlank(accRec.Tax_Type__c)){
            accMissingFieldList.add('Tax_Type__c');
        }
        if(!String.isBlank(accRec.BillingCountry) && accRec.BillingCountry.equalsIgnoreCase('India') && (String.isBlank(accRec.PAN_Number__c) || String.isBlank(accRec.GST_number__c))){
            if(String.isBlank(accRec.PAN_Number__c)){
                accMissingFieldList.add('PAN_Number__c');
            }
            if(String.isBlank(accRec.GST_number__c)){
                accMissingFieldList.add('GST_number__c');
            }
        }
        if(String.isBlank(accRec.Payment_terms__c)){
            accMissingFieldList.add('Payment_terms__c');
        }
        if(String.isBlank(accRec.Tax_Collected_At_Source__c)){
            accMissingFieldList.add('Tax_Collected_At_Source__c');
        }
        if(accRec.FSSAI__c == null || accRec.FSSAI__c == 0){
            accMissingFieldList.add('FSSAI__c');
        }
        if(String.isBlank(accRec.Transportation_Terms__c)){
            accMissingFieldList.add('Transportation_Terms__c');
        }
        
        
        
        System.debug('accMissingFieldList---->'+accMissingFieldList); 
        System.debug('billingCustMissingFieldList---->'+billingCustMissingFieldList); 
        
        List<User> userRec = [SELECT Id, Name, SAP_USER_CODE__c FROM User WHERE Id =: userId];
        if(userRec.size()>0 && userRec[0].SAP_USER_CODE__c != null){
            userId = null;
        }
        
        List<User> addressUserRec = [SELECT Id, Name, SAP_USER_CODE__c FROM User WHERE Id =: addressUserId];
        if(addressUserRec.size()>0 && addressUserRec[0].SAP_USER_CODE__c != null){
            addressUserId = null;
        }
        
        List<User> bhRec = [SELECT Id, Name, SAP_USER_CODE__c FROM User WHERE Id =: bhId];
        if(bhRec.size()>0 && bhRec[0].SAP_USER_CODE__c != null){
            bhId = null;
        }
        
        mlw.accountMissingFieldList = accMissingFieldList;
        mlw.billingCustMissingFieldList = billingCustMissingFieldList;
        mlw.userId = userId;
        mlw.addressUserId = addressUserId;
        mlw.bhId = bhId;
        if(accMissingFieldList.size()>0 || billingCustMissingFieldList.size()>0)
            mlw.reqFieldMissing = true;
        return mlw;        
    }   
    
    private static missingListWrapper ValidateCustomerBillingAndShipping(Sales_Order__c soRec){
        List<String> shippingCustMissingFieldList = new List<String>();
        List<String> billingCustMissingFieldList = new List<String>();
        List<String> onlyAccMissingFieldList = new List<String>();
        
        missingListWrapper mlw = new missingListWrapper();
        
        
        
        Dispatch_Address__c disRec = [select id, Customer_Category__c, Tax_Type__c, FSSAI_Number__c, PAN_Number__c, Initial_SAP_Update__c, Account__r.User__c, Address__city__s, Address__Street__s, Address__PostalCode__s, Address__CountryCode__s, Address__StateCode__s,
                                      Contact__c,Account__c,Type__c, OwnerId, Account__r.Customer_Type__c, Account__r.Account_Segment__c, Account__r.Delivery_Plant__c, CurrencyIsoCode, GST_Number__c,
                                      Account__r.Transportation_Terms__c, Account__r.PAN_Number__c, Account__r.Tax_Type__c, Account__r.Payment_terms__c, Account__r.Tax_Collected_At_Source__c, Account__r.FSSAI__c
                                      from Dispatch_Address__c WHERE Id =: soRec.Opportunity__r.Customer_Billing_Address__c];
        
        Id addressUserId = disRec.OwnerId;
        Id bhId = disRec.Account__r.User__c;
        
        if(!disRec.Initial_SAP_Update__c){
            if((disRec.Address__city__s == null) || (disRec.Address__city__s == '')){
                billingCustMissingFieldList.add('Address__city__s');
            }
            
            if(((disRec.Address__StateCode__s == null) || (disRec.Address__StateCode__s == '')) && disRec.Account__r.Customer_Type__c!='Export'){
                billingCustMissingFieldList.add('Address__StateCode__s');
            }               
            
            if((disRec.Address__Street__s == null) || (disRec.Address__Street__s == '')){
                billingCustMissingFieldList.add('Address__Street__s');
            }
            
            if((disRec.Address__CountryCode__s == null) || (disRec.Address__CountryCode__s == '')){
                billingCustMissingFieldList.add('Address__CountryCode__s');
            }
            
            if((disRec.Address__PostalCode__s == null) || (disRec.Address__PostalCode__s == '')){
                billingCustMissingFieldList.add('Address__PostalCode__s');
            }
            
            if(disRec.Contact__c == null){
                billingCustMissingFieldList.add('Contact__c');
            } 
            
            if((disRec.CurrencyIsoCode == null) || (disRec.CurrencyIsoCode == '')){
                billingCustMissingFieldList.add('CurrencyIsoCode');
            }
            
            if(String.isBlank(disRec.Customer_Category__c)){
                billingCustMissingFieldList.add('Customer_Category__c');
            }
            
        }
        
        if(String.isBlank(disRec.Tax_Type__c)){
            billingCustMissingFieldList.add('Tax_Type__c');
        }
        if(disRec.FSSAI_Number__c == null || disRec.FSSAI_Number__c == 0){
            billingCustMissingFieldList.add('FSSAI_Number__c');
        }
        
        if(!String.isBlank(disRec.Address__CountryCode__s) && disRec.Address__CountryCode__s.equalsIgnoreCase('IN') && (String.isBlank(disRec.PAN_Number__c) || String.isBlank(disRec.GST_Number__c))){
            if(String.isBlank(disRec.PAN_Number__c)){
                billingCustMissingFieldList.add('PAN_Number__c');
            }
            if(String.isBlank(disRec.GST_Number__c)){
                billingCustMissingFieldList.add('GST_Number__c');
            }
        }      
        
        
        Dispatch_Address__c shippingDispRec = [select id, Customer_Category__c, Tax_Type__c, FSSAI_Number__c, PAN_Number__c, Initial_SAP_Update__c, Account__r.User__c, Address__city__s, Address__Street__s, Address__PostalCode__s, Address__CountryCode__s, Address__StateCode__s,
                                               Contact__c,Account__c,Type__c, OwnerId, Account__r.Customer_Type__c, Account__r.Account_Segment__c, Account__r.Delivery_Plant__c, CurrencyIsoCode, GST_Number__c,
                                               Account__r.Transportation_Terms__c, Account__r.PAN_Number__c, Account__r.Tax_Type__c, Account__r.Payment_terms__c, Account__r.Tax_Collected_At_Source__c, Account__r.FSSAI__c
                                               from Dispatch_Address__c WHERE Id =: soRec.Opportunity__r.Customer_Shipping_Address__c];
        
        if(!shippingDispRec.Initial_SAP_Update__c){
            if((shippingDispRec.Address__city__s == null) || (shippingDispRec.Address__city__s == '')){
                shippingCustMissingFieldList.add('Address__city__s');
            }
            
            if(((shippingDispRec.Address__StateCode__s == null) || (shippingDispRec.Address__StateCode__s == '')) && shippingDispRec.Account__r.Customer_Type__c!='Export'){
                shippingCustMissingFieldList.add('Address__StateCode__s');
            }               
            
            if((shippingDispRec.Address__Street__s == null) || (shippingDispRec.Address__Street__s == '')){
                shippingCustMissingFieldList.add('Address__Street__s');
            }
            
            if((shippingDispRec.Address__CountryCode__s == null) || (shippingDispRec.Address__CountryCode__s == '')){
                shippingCustMissingFieldList.add('Address__CountryCode__s');
            }
            
            if((shippingDispRec.Address__PostalCode__s == null) || (shippingDispRec.Address__PostalCode__s == '')){
                shippingCustMissingFieldList.add('Address__PostalCode__s');
            }
            
            if(shippingDispRec.Contact__c == null){
                shippingCustMissingFieldList.add('Contact__c');
            } 
            
            if((shippingDispRec.CurrencyIsoCode == null) || (shippingDispRec.CurrencyIsoCode == '')){
                shippingCustMissingFieldList.add('CurrencyIsoCode');
            }
            
            if(String.isBlank(shippingDispRec.Customer_Category__c)){
                shippingCustMissingFieldList.add('Customer_Category__c');
            }
            
            
            if((disRec.Account__r.Customer_Type__c == null) || (disRec.Account__r.Customer_Type__c == '')){
                onlyAccMissingFieldList.add('Customer_Type__c');
            }
            
            if((disRec.Account__r.Account_Segment__c == null) || (disRec.Account__r.Account_Segment__c == '')){
                onlyAccMissingFieldList.add('Account_Segment__c');
            }
            
            if((disRec.Account__r.Delivery_Plant__c == null) || (disRec.Account__r.Delivery_Plant__c == '')){
                onlyAccMissingFieldList.add('Delivery_Plant__c');
            }
            
        }
        
        if(String.isBlank(shippingDispRec.Tax_Type__c)){
            shippingCustMissingFieldList.add('Tax_Type__c');
        }
        if(shippingDispRec.FSSAI_Number__c == null || shippingDispRec.FSSAI_Number__c == 0){
            shippingCustMissingFieldList.add('FSSAI_Number__c');
        }
        
        if(!String.isBlank(shippingDispRec.Address__CountryCode__s) && shippingDispRec.Address__CountryCode__s.equalsIgnoreCase('IN') && (String.isBlank(shippingDispRec.PAN_Number__c) || String.isBlank(shippingDispRec.GST_Number__c))){
            if(String.isBlank(shippingDispRec.PAN_Number__c)){
                shippingCustMissingFieldList.add('PAN_Number__c');
            }
            if(String.isBlank(shippingDispRec.GST_Number__c)){
                shippingCustMissingFieldList.add('GST_Number__c');
            }
        }     
        
        
        if(String.isBlank(disRec.Account__r.Payment_terms__c)){
            onlyAccMissingFieldList.add('Payment_terms__c');
        }
        if(String.isBlank(disRec.Account__r.Tax_Collected_At_Source__c)){
            onlyAccMissingFieldList.add('Tax_Collected_At_Source__c');
        }
        if(String.isBlank(disRec.Account__r.Transportation_Terms__c)){
            onlyAccMissingFieldList.add('Transportation_Terms__c');
        }   
        
        
        System.debug('billingCustMissingFieldList---->'+ billingCustMissingFieldList); 
        System.debug('shippingCustMissingFieldList---->'+shippingCustMissingFieldList); 
        
        
        List<User> addressUserRec = [SELECT Id, Name, SAP_USER_CODE__c FROM User WHERE Id =: addressUserId];
        if(addressUserRec.size()>0 && addressUserRec[0].SAP_USER_CODE__c != null){
            addressUserId = null;
        }
        
        List<User> bhRec = [SELECT Id, Name, SAP_USER_CODE__c FROM User WHERE Id =: bhId];
        if(bhRec.size()>0 && bhRec[0].SAP_USER_CODE__c != null){
            bhId = null;
        }
        
        mlw.shippingCustMissingFieldList = shippingCustMissingFieldList;
        mlw.billingCustMissingFieldList = billingCustMissingFieldList;
        mlw.onlyAccMissingFieldList = onlyAccMissingFieldList;
        mlw.addressUserId = addressUserId;
        mlw.bhId = bhId;
        if(shippingCustMissingFieldList.size()>0 || billingCustMissingFieldList.size()>0 || onlyAccMissingFieldList.size()>0)
            mlw.reqFieldMissing = true;
        return mlw;        
    }   
    
    public class soWrapper{
        @AuraEnabled
        public boolean fertCodesPresentForAll = false;
        @AuraEnabled
        public boolean reqFieldsMissing = false;        
        
        @AuraEnabled
        public Id accRecId = null;
        @AuraEnabled 
        public Id billingDispRecId = null;
        @AuraEnabled 
        public Id shippingDispRecId = null;
        
        @AuraEnabled
        public Boolean isBilling_ShippingAccount = false;
        @AuraEnabled
        public Boolean isAccBilling_ShippigCustomer = false;
        @AuraEnabled
        public Boolean isBillingCustomer_AccShipping = false;
        @AuraEnabled
        public Boolean isCustomerBilling_Shipping = false;
        
        @AuraEnabled
        public List<String> accountMissingFieldList = new list<string>();
        @AuraEnabled
        public List<String> billingCustMissingFieldList = new list<string>();
        @AuraEnabled
        public List<String> shippingCustMissingFieldList = new list<string>();
        @AuraEnabled
        public List<String> onlyAccMissingFieldList = new list<string>();
        
        @AuraEnabled
        public Map<String,Map<String,List<String>>> pickValList = new Map<String,Map<String,List<String>>>();
        
        
        @AuraEnabled 
        public Id userId = null;
        @AuraEnabled 
        public Id addressUserId = null;
        @AuraEnabled 
        public Id bhId = null;
    }
    
    
    public class missingListWrapper{
        
        @AuraEnabled
        public List<String> shippingCustMissingFieldList = new list<string>();
        @AuraEnabled
        public List<String> billingCustMissingFieldList = new list<string>();
        @AuraEnabled
        public List<String> accountMissingFieldList = new list<string>();
        @AuraEnabled
        public List<String> onlyAccMissingFieldList = new list<string>();
        
        @AuraEnabled 
        public Id addressUserId;
        @AuraEnabled 
        public Id userId;
        @AuraEnabled 
        public Id bhId;
        @AuraEnabled 
        public Boolean reqFieldMissing = false;
    }
    
}