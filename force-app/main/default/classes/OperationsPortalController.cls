public without sharing class OperationsPortalController {
    public string quantityUnit  {get;set;}
    public string endUseCategory  {get;set;}
    public string sampleReqBy  {get;set;}
    public string mainReasonForSelPro  {get;set;}
    public string annulaVolInUnits  {get;set;}
    public string transportationTerms  {get;set;}
    public string sampleStatusValues  {get;set;}
    public List<SampleStatusWrapper> statusWrapper {get; set;}
    public string packingType {get;set;}
    public string vegNonVegLabel {get;set;}
    public string ingredients {get;set;}
    public string label {get;set;}
    public string plant {get;set;}
    public string customerType {get;set;}
    public string currencyCode {get;set;}
    public string deliveryPlant {get;set;}
    public string accountSegmant {get;set;}
    public string customerAddType {get;set;}
    public string releaseStatusPick {get; set;}
    public string productFamily  {get;set;}
    public string unitMeasure{get;set;}
    public string salesUnit{get;set;}
    public string materialSector{get;set;}
    public string primary{get;set;}
    public string secondary{get;set;}
    public string teritory{get;set;}
    
    
    public OperationsPortalController() {
        
        quantityUnit = JSON.serialize(Utility.getPicklistValues('Sample_Line_Item__c' , 'Quantity_Unit__c'));
        endUseCategory = JSON.serialize(Utility.getPicklistValues('Project__c' , 'End_Use_category__c'));
        sampleReqBy = JSON.serialize(Utility.getPicklistValues('Project__c' , 'Sample_Requested_by__c'));
        mainReasonForSelPro = JSON.serialize(Utility.getPicklistValues('Project__c' , 'Main_reason_for_selecting_product__c'));
        annulaVolInUnits = JSON.serialize(Utility.getPicklistValues('Project__c' , 'Annual_Volume_in_units__c'));
        transportationTerms = JSON.serialize(Utility.getPicklistValues('Account' , 'Transportation_Terms__c'));
        packingType = JSON.serialize(Utility.getPicklistValues('OpportunityLineItem' , 'Packaging_Type__c'));
        vegNonVegLabel = JSON.serialize(Utility.getPicklistValues('Product2' , 'Veg_Nonveg_Logo_In_Label__c'));
        ingredients = JSON.serialize(Utility.getPicklistValues('OpportunityLineItem' , 'Ingredients_List_Declared_With_Customer__c'));
        label = JSON.serialize(Utility.getPicklistValues('OpportunityLineItem' , 'Label__c'));
        plant = JSON.serialize(Utility.getPicklistValues('OpportunityLineItem' , 'Plant__c'));
        customerType = JSON.serialize(Utility.getPicklistValues('Account' , 'Customer_Type__c'));
        currencyCode = JSON.serialize(Utility.getPicklistValues('Account' , 'CurrencyIsoCode'));
        deliveryPlant = JSON.serialize(Utility.getPicklistValues('Account' , 'Delivery_Plant__c'));
        accountSegmant = JSON.serialize(Utility.getPicklistValues('Account' , 'Account_Segment__c'));
        customerAddType = JSON.serialize(Utility.getPicklistValues('Dispatch_Address__c' , 'Type__c'));
        sampleStatusValues = JSON.serialize(Utility.getPicklistValues('Sample_Line_Item__c' , 'Sample_Request_Status__c'));
        releaseStatusPick = JSON.serialize(Utility.getPicklistValues('Sample_Line_Item__c' , 'Release_Status__c'));
        productFamily = JSON.serialize(Utility.getPicklistValues('Project__c' , 'Product_Family__c'));
        unitMeasure = JSON.serialize(Utility.getPicklistValues('OpportunityLineItem' , 'Quantity_Unit__c')); 
        salesUnit = JSON.serialize(Utility.getPicklistValues('OpportunityLineItem' , 'Sales_Unit__c')); 
        materialSector =  JSON.serialize(Utility.getPicklistValues('OpportunityLineItem' , 'Material_Sector__c')); 
        primary =     JSON.serialize(Utility.getPicklistValues('OpportunityLineItem' , 'Primary__c'));
        secondary  =  JSON.serialize(Utility.getPicklistValues('OpportunityLineItem' , 'Secondary__c'));
        teritory  =  JSON.serialize(Utility.getPicklistValues('OpportunityLineItem' , 'Tertiary__c'));
    }
    
    @RemoteAction
    public static Contact loginUser(String username, String password){
        try{
            List<Contact> conRecord = [SELECT Id,Name,Email,Password__c,Role__c FROM Contact WHERE Email=: username AND Password__c=: password LIMIT 1];
            if(conRecord.size() > 0 ){
                conRecord[0].Login_Hash_Code__c = generateRandomString();
                System.debug('The Hash Code Value');
                update conRecord;                    
                return conRecord[0];
            }else{
                return null;
            }
        }catch(Exception e){
            system.debug(e.getLineNumber()+'---error Message---'+e.getMessage());
            return null;
        }
    }
    
    public static String generateRandomString(){
        Integer len = 10;
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr+string.ValueOf(system.now().getTime()); 
    }
    
    
    /*@RemoteAction
public static List<Attachment> getAttachments(String sliId){
try{
List<Attachment> attchList = [SELECT Id, Name, ContentType, Body FROM Attachment WHERE ParentId = :sliId];
system.debug('attchList ====> '+attchList);
if(!attchList.isEmpty()){
return attchList;
}
// Return an empty list instead of null
return new List<Attachment>();
}catch(Exception e){
// Return an empty list in case of an exception
return new List<Attachment>();
}
}*/
    
    @RemoteAction
    public static accountDetailWrapper getCustomerDetails(string hashCode, string selProdFamily, string startDate, string endDate, boolean isToday, boolean isCreatedDate, string objectType, string releaseStatus){
        try{
            System.debug('selProdFamily==> ' + selProdFamily);
            System.debug('startDate==> ' + startDate);
            System.debug('endDate==> ' + endDate);
            system.debug('hashCode ====> '+hashCode);
            Set<Id> setOfSampleAssignment = New Set<Id>();
            Set<Id> setOfAccountIds = New Set<Id>();
            Set<Id> setOfSampleIds = New Set<Id>();
            Set<Id> setOfOppIds = New Set<Id>();
            List<OpportunityLineItem> oppLIneItems = New List<OpportunityLineItem>();
            List<Opportunity> oppList = New List<Opportunity>();
            List<Account> allCustomerList = New List<Account>();
            List<Project__c> listOfSamples = New List<Project__c>();
            List<Sample_Line_Item__c> listOfAllSLI = New List<Sample_Line_Item__c>();
            
            Contact conRecord = [SELECT Id,Name,Role__c,Login_Hash_Code__c,FirstName,LastName,Email,Phone,MobilePhone,Password__c,Sample_Assignment_Team__r.Team_Type__c FROM Contact WHERE Login_Hash_Code__c =: hashCode];
            system.debug('conRecord ====> '+conRecord);
            
            set<Id> setOfOppsIds = new set<Id>();
            oppLIneItems = [SELECT Id,Name,OpportunityId,Product2Id,Product2.Name,Quantity,ListPrice,UnitPrice,TotalPrice,Price_In_KG__c,Quantity_In_KG__c FROM OpportunityLineItem WHERE Product_Family__c =: conRecord.Sample_Assignment_Team__r.Team_Type__c ORDER BY CreatedDate DESC limit 2000 ]; //offset :offsetNum
            system.debug('oppLIneItems size-->'+oppLIneItems.size());
            for(OpportunityLineItem oli : oppLIneItems){
                setOfOppsIds.add(oli.OpportunityId);
            }
            
            //set<Id> setOfAccsIds = new set<Id>();
            oppList = [SELECT Id,Name,Account.Name,Amount,CloseDate,AccountId,StageName,Probability,Type,RecordType.Name FROM Opportunity WHERE Id IN : setOfOppsIds ORDER BY CreatedDate DESC limit 2000];
            
            List<Sample_Allocation_Team__c> listOfAllocationTeam = [SELECT Id,Name,Sample_Assignment_Team__c FROM Sample_Allocation_Team__c WHERE Contact__r.Login_Hash_Code__c =: hashCode];
            system.debug('listOfAllocationTeam ====> '+listOfAllocationTeam);
            if(!listOfAllocationTeam.isEmpty()){
                for(Sample_Allocation_Team__c SAT : listOfAllocationTeam){
                    if(SAT.Sample_Assignment_Team__c != null){
                        setOfSampleAssignment.add(SAT.Sample_Assignment_Team__c);
                    }
                }
            }
            system.debug('setOfSampleAssignment ====> '+setOfSampleAssignment);
            
            if(conRecord.Role__c == 'Dispatch Team'){
                system.debug('Dipatch Team');
                listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Release_Date_Time__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c FROM Sample_Line_Item__c WHERE Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Release_to_Dispatch_Team__c = True ORDER By Release_Date_Time__c DESC limit 2000];
            }
            else{
                system.debug('Operation & Sample Team');
                listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Release_Date_Time__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c FROM Sample_Line_Item__c WHERE Sample_Assignment_Team__c IN : setOfSampleAssignment AND Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' limit 2000];
                for(Opportunity opp : oppList){
                    setOfAccountIds.add(opp.AccountId);
                }
            }
            system.debug('listOfAllSLI ====> '+listOfAllSLI);
            accountDetailWrapper wrapper = new accountDetailWrapper();
            // wrapper.listOfSLI = listOfAllSLI;
            wrapper.conRec = conRecord;
            if(!listOfAllSLI.isEmpty()){
                for(Sample_Line_Item__c SLI : listOfAllSLI){
                    if(conRecord.Role__c == 'Dispatch Team'){
                        setOfAccountIds.add(SLI.Account_Id__c);
                    }
                    setOfSampleIds.add(SLI.Sample__c);
                }
                system.debug('setOfAccountIds ===> '+setOfAccountIds);
            }
            if(!setOfAccountIds.isEmpty()){
                if(startDate != null && endDate != null && objectType == 'Account'){
                    System.debug('inside date filter');
                    DateTime startDateAPEX = Datetime.valueOf(startDate.replace('T', ' '));
                    DateTime endDateAPEX = Datetime.valueOf(endDate.replace('T', ' '));
                    Date startCreatedDateAPEX = Date.valueOf(startDate);
                    Date endCreatedDateAPEX = Date.valueOf(endDate);
                    if(isCreatedDate){
                        allCustomerList = [SELECT Id,Name,Email__c,Phone,RecordType.Name,Customer_Number__c,CreatedDate,Account_Segment__c,Customer_Code_SAP__c FROM Account WHERE Id IN : setOfAccountIds AND CreatedDate >=: startDateAPEX AND CreatedDate <=: endDateAPEX ORDER By CreatedDate DESC limit 2000];  
                    }
                }else if(isToday && objectType == 'Account'){
                    if(isCreatedDate){
                        allCustomerList = [SELECT Id,Name,Email__c,Phone,RecordType.Name,Customer_Number__c,CreatedDate,Account_Segment__c,Customer_Code_SAP__c FROM Account WHERE Id IN : setOfAccountIds AND CreatedDate = TODAY ORDER By CreatedDate DESC limit 2000];
                    }
                }else{
                    allCustomerList = [SELECT Id,Name,Email__c,Phone,RecordType.Name,Customer_Number__c,CreatedDate,Account_Segment__c,Customer_Code_SAP__c FROM Account WHERE Id IN : setOfAccountIds ORDER By CreatedDate DESC limit 2000];
                }
                system.debug('allCustomerList ====> '+allCustomerList);
                //oppList = [SELECT Id,Name,Account.Name,Amount,CloseDate,AccountId,StageName,Probability,Type,RecordType.Name FROM Opportunity WHERE AccountId IN : setOfAccountIds limit 2000];
            }
            if(!oppList.isEmpty()){
                for(Opportunity op : oppList){
                    setOfOppIds.add(op.Id);
                }
            }
            if(!setOfOppIds.isEmpty()){
                //oppLIneItems = [SELECT Id,Name,OpportunityId,Product2Id,Product2.Name,Quantity,ListPrice,UnitPrice,TotalPrice,Price_In_KG__c,Quantity_In_KG__c FROM OpportunityLineItem WHERE OpportunityId IN : setOfOppIds limit 2000];
            }
            if(!setOfSampleIds.isEmpty()){
                if(conRecord.Role__c == 'Dispatch Team'){
                    system.debug('Dispatch Team Query....');
                    if(selProdFamily != '' && selProdFamily != null && objectType == 'Sample'){
                        System.debug('inside product family filter');
                        listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Release_Date_Time__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Release_Status__c FROM Sample_Line_Item__c WHERE Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Release_to_Dispatch_Team__c = True AND Product_Family__c =: selProdFamily ORDER By Release_Date_Time__c DESC limit 2000];
                        set<Id> setOfSampleIdss = New set<Id>();
                        if(!listOfAllSLI.isEmpty()){
                            for(Sample_Line_Item__c sli : listOfAllSLI){
                                setOfSampleIdss.add(sli.Sample__c);
                            }
                        }
                        system.debug('setOfSampleIdss ====> '+setOfSampleIdss);
                         system.debug('listOfSamples 1 ====> '+listOfSamples);
                        listOfSamples = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Account__r.Name, Account__c,
                                         Sample_Requested_by__c,Actual_Date_of_Dispatch__c,Owner.Name,Customers_Contact__c,Customers_Contact__r.Name,Customers_Contact__r.Phone,Customers_Contact__r.Email,Customers_Contact__r.MailingStreet,
                                         Customers_Contact__r.MailingCity,Customers_Contact__r.MailingState,Customers_Contact__r.MailingCountry,Customers_Contact__r.MailingPostalCode, CreatedDate, Sample_Submitted_Date__c, Release_Date_Time__c,(SELECT Id,Product_Name__c,Release_Status__c,Actual_date_of_dispatch__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled' AND Release_Status__c != 'Dispatched') From Project__c WHERE Id IN : setOfSampleIdss AND Submitted_To_SAP_Optiva__c = true AND Record_Type_Name__c = 'Sample' ORDER By Release_Date_Time__c DESC limit 2000];
                    }else if(startDate != null && endDate != null && objectType == 'Sample'){
                        System.debug('inside date filter');
                        DateTime startDateAPEX = Datetime.valueOf(startDate.replace('T', ' '));
                        DateTime endDateAPEX = Datetime.valueOf(endDate.replace('T', ' '));
                        Date startCreatedDateAPEX = Date.valueOf(startDate);
                        Date endCreatedDateAPEX = Date.valueOf(endDate);
                        if(isCreatedDate){
                            listOfSamples = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Account__r.Name, Account__c,
                                             Sample_Requested_by__c,Actual_Date_of_Dispatch__c,Owner.Name,Customers_Contact__c,Customers_Contact__r.Name,Customers_Contact__r.Phone,Customers_Contact__r.Email,Customers_Contact__r.MailingStreet,
                                             Customers_Contact__r.MailingCity,Customers_Contact__r.MailingState,Customers_Contact__r.MailingCountry,Customers_Contact__r.MailingPostalCode, CreatedDate, Sample_Submitted_Date__c, Release_Date_Time__c,(SELECT Id,Product_Name__c,Release_Status__c,Actual_date_of_dispatch__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled' AND Release_Status__c != 'Dispatched') From Project__c WHERE Id IN : setOfSampleIds AND Submitted_To_SAP_Optiva__c = true AND Record_Type_Name__c = 'Sample' AND CreatedDate >=: startDateAPEX AND CreatedDate <=: endDateAPEX ORDER By Release_Date_Time__c DESC limit 2000];   
                         system.debug('listOfSamples 2 ====> '+listOfSamples);
                        }else{
                            listOfSamples = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Account__r.Name, Account__c,
                                             Sample_Requested_by__c,Actual_Date_of_Dispatch__c,Owner.Name,Customers_Contact__c,Customers_Contact__r.Name,Customers_Contact__r.Phone,Customers_Contact__r.Email,Customers_Contact__r.MailingStreet,
                                             Customers_Contact__r.MailingCity,Customers_Contact__r.MailingState,Customers_Contact__r.MailingCountry,Customers_Contact__r.MailingPostalCode, CreatedDate, Sample_Submitted_Date__c, Release_Date_Time__c,(SELECT Id,Product_Name__c,Release_Status__c,Actual_date_of_dispatch__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled' AND Release_Status__c != 'Dispatched') From Project__c WHERE Id IN : setOfSampleIds AND Submitted_To_SAP_Optiva__c = true AND Record_Type_Name__c = 'Sample' AND Sample_Submitted_Date__c >=: startCreatedDateAPEX AND Sample_Submitted_Date__c <=: endCreatedDateAPEX ORDER By Release_Date_Time__c DESC limit 2000]; 
                        system.debug('listOfSamples 3 ====> '+listOfSamples);
                        }
                    }else if(isToday && objectType == 'Sample'){
                        if(isCreatedDate){
                            System.debug('inside today filter');
                            listOfSamples = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Account__r.Name, Account__c,
                                             Sample_Requested_by__c,Actual_Date_of_Dispatch__c,Owner.Name,Customers_Contact__c,Customers_Contact__r.Name,Customers_Contact__r.Phone,Customers_Contact__r.Email,Customers_Contact__r.MailingStreet,
                                             Customers_Contact__r.MailingCity,Customers_Contact__r.MailingState,Customers_Contact__r.MailingCountry,Customers_Contact__r.MailingPostalCode, CreatedDate, Sample_Submitted_Date__c, Release_Date_Time__c,(SELECT Id,Product_Name__c,Release_Status__c,Actual_date_of_dispatch__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled' AND Release_Status__c != 'Dispatched') From Project__c WHERE Id IN : setOfSampleIds AND Submitted_To_SAP_Optiva__c = true AND Record_Type_Name__c = 'Sample' AND CreatedDate = TODAY ORDER By Release_Date_Time__c DESC limit 2000]; 
                         system.debug('listOfSamples 4 ====> '+listOfSamples);
                        }else{
                            System.debug('inside today filter');
                            listOfSamples = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Account__r.Name, Account__c,
                                             Sample_Requested_by__c,Actual_Date_of_Dispatch__c,Owner.Name,Customers_Contact__c,Customers_Contact__r.Name,Customers_Contact__r.Phone,Customers_Contact__r.Email,Customers_Contact__r.MailingStreet,
                                             Customers_Contact__r.MailingCity,Customers_Contact__r.MailingState,Customers_Contact__r.MailingCountry,Customers_Contact__r.MailingPostalCode, CreatedDate, Sample_Submitted_Date__c, Release_Date_Time__c,(SELECT Id,Product_Name__c,Release_Status__c,Actual_date_of_dispatch__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled' AND Release_Status__c != 'Dispatched') From Project__c WHERE Id IN : setOfSampleIds AND Submitted_To_SAP_Optiva__c = true AND Record_Type_Name__c = 'Sample' AND Sample_Submitted_Date__c = TODAY ORDER By Release_Date_Time__c DESC limit 2000]; 
                         system.debug('listOfSamples 5 ====> '+listOfSamples);
                        }
                    }
                    
                    else{
                        system.debug('Last Else Condition....');
                        listOfSamples = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Account__r.Name, Account__c,
                                         Sample_Requested_by__c,Actual_Date_of_Dispatch__c,Owner.Name,Customers_Contact__c,Customers_Contact__r.Name,Customers_Contact__r.Phone,Customers_Contact__r.Email,Customers_Contact__r.MailingStreet,
                                         Customers_Contact__r.MailingCity,Customers_Contact__r.MailingState,Customers_Contact__r.MailingCountry,Customers_Contact__r.MailingPostalCode, CreatedDate, Sample_Submitted_Date__c, Release_Date_Time__c,(SELECT Id,Product_Name__c,Release_Status__c,Actual_date_of_dispatch__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled' AND Release_Status__c != 'Dispatched') From Project__c WHERE Id IN : setOfSampleIds AND Submitted_To_SAP_Optiva__c = true AND Record_Type_Name__c = 'Sample' ORDER By Release_Date_Time__c DESC limit 2000];
                     system.debug('listOfSamples 6 ====> '+listOfSamples);
                    }
                    
                    
                    /* For Sample Line Items : */ 
                    
                    if(selProdFamily != '' && selProdFamily != null && objectType == 'SLI'){
                        listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Release_Date_Time__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Release_Date__c,Release_Status__c,Sample_Submitted_Date__c FROM Sample_Line_Item__c WHERE Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Release_to_Dispatch_Team__c = True AND Product_Family__c =: selProdFamily ORDER By Release_Date_Time__c DESC];
                    }else if(startDate != null && endDate != null && objectType == 'SLI'){
                        System.debug('inside date filter');
                        DateTime startDateAPEX = Datetime.valueOf(startDate.replace('T', ' '));
                        DateTime endDateAPEX = Datetime.valueOf(endDate.replace('T', ' '));
                        Date startCreatedDateAPEX = Date.valueOf(startDate);
                        Date endCreatedDateAPEX = Date.valueOf(endDate);
                        if(isCreatedDate){
                            listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Release_Date_Time__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Release_Date__c,Release_Status__c,Owner.Name,Sample_Invoice_Date__c,Sample_Submitted_Date__c FROM Sample_Line_Item__c WHERE Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Release_to_Dispatch_Team__c = True AND Release_Date_Time__c >=: startDateAPEX AND Release_Date_Time__c <=: endDateAPEX ORDER By Release_Date_Time__c DESC];
                            
                        }else{
                            listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Release_Date_Time__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Release_Date__c,Release_Status__c,Sample_Submitted_Date__c,Owner.Name,Sample_Invoice_Date__c FROM Sample_Line_Item__c WHERE Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Release_to_Dispatch_Team__c = True AND Sample_Submitted_Date__c >=: startCreatedDateAPEX AND Sample_Submitted_Date__c <=: endCreatedDateAPEX ORDER By Release_Date_Time__c DESC];
                        }
                    }else if(isToday && objectType == 'SLI'){
                        if(isCreatedDate){
                            System.debug('inside today filter');
                            listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Release_Date_Time__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Release_Date__c,Release_Status__c,Sample_Submitted_Date__c,Owner.Name,Sample_Invoice_Date__c FROM Sample_Line_Item__c WHERE Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Release_to_Dispatch_Team__c = True AND Release_Date_Time__c = TODAY ORDER By Release_Date_Time__c DESC];
                            
                        }else{
                            System.debug('inside today filter');
                            listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Release_Date_Time__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Release_Date__c,Release_Status__c,Sample_Submitted_Date__c,Owner.Name,Sample_Invoice_Date__c FROM Sample_Line_Item__c WHERE Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Release_to_Dispatch_Team__c = True AND Sample_Submitted_Date__c = TODAY ORDER By Release_Date_Time__c DESC];
                            
                        }
                    }else if(releaseStatus != '' && releaseStatus != null && objectType == 'SLI'){
                        listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Release_Date_Time__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Release_Date__c,Release_Status__c,Owner.Name,Sample_Invoice_Date__c,Sample_Submitted_Date__c FROM Sample_Line_Item__c WHERE Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Release_to_Dispatch_Team__c = True AND Release_Status__c =: releaseStatus ORDER By Release_Date_Time__c DESC];
                    }
                    else{
                        system.debug('Last Else Condition....');
                        listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Release_Date_Time__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Release_Status__c,Owner.Name,Sample_Invoice_Date__c,Sample_Submitted_Date__c FROM Sample_Line_Item__c WHERE Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Release_to_Dispatch_Team__c = True ORDER By Release_Date_Time__c DESC];
                        
                    }
                    
                    /* End of List Of Sample Line Items */
                    
                    
                }
                
                else{
                    system.debug('Sample Team Query....');
                    if(selProdFamily != '' && selProdFamily != null && objectType == 'Sample'){
                        System.debug('inside product family filter');
                        
                        if(conRecord.Role__c == 'Dispatch Team'){
                            system.debug('Dipatch Team');
                            listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Release_Date_Time__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Release_Status__c FROM Sample_Line_Item__c WHERE Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Release_to_Dispatch_Team__c = True AND Product_Family__c =: selProdFamily ORDER By Release_Date_Time__c DESC limit 2000];
                        }else{
                            system.debug('Operation & Sample Team');
                            listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Release_Date_Time__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Release_Status__c FROM Sample_Line_Item__c WHERE Sample_Assignment_Team__c IN : setOfSampleAssignment AND Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Product_Family__c =: selProdFamily limit 2000];
                        }
                        set<Id> setOfSampleIdss = New set<Id>();
                        if(!listOfAllSLI.isEmpty()){
                            for(Sample_Line_Item__c sli : listOfAllSLI){
                                setOfSampleIdss.add(sli.Sample__c);
                            }
                        }
                        system.debug('setOfSampleIdss ====> '+setOfSampleIdss);
                        listOfSamples = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Account__r.Name, Account__c,
                                         Sample_Requested_by__c,Actual_Date_of_Dispatch__c,Owner.Name,Customers_Contact__c,Customers_Contact__r.Name,Customers_Contact__r.Phone,Customers_Contact__r.Email,Customers_Contact__r.MailingStreet,
                                         Customers_Contact__r.MailingCity,Customers_Contact__r.MailingState,Customers_Contact__r.MailingCountry,Customers_Contact__r.MailingPostalCode, CreatedDate, Sample_Submitted_Date__c,Release_Date_Time__c,(SELECT Id,Product_Name__c,Release_Status__c,Actual_date_of_dispatch__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled' AND Release_Status__c != 'Dispatched') From Project__c WHERE Id IN : setOfSampleIdss AND Submitted_To_SAP_Optiva__c = true AND Record_Type_Name__c = 'Sample' ORDER By Sample_Submitted_Date__c DESC limit 2000];
                    system.debug('listOfSamples 7 ====> '+listOfSamples);
                    }else if(startDate != null && endDate != null && objectType == 'Sample'){
                        System.debug('inside date filter');
                        DateTime startDateAPEX = Datetime.valueOf(startDate.replace('T', ' '));
                        DateTime endDateAPEX = Datetime.valueOf(endDate.replace('T', ' '));
                        Date startCreatedDateAPEX = Date.valueOf(startDate);
                        Date endCreatedDateAPEX = Date.valueOf(endDate);
                        if(isCreatedDate){
                            listOfSamples = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Account__r.Name, Account__c,
                                             Sample_Requested_by__c,Actual_Date_of_Dispatch__c,Owner.Name,Customers_Contact__c,Customers_Contact__r.Name,Customers_Contact__r.Phone,Customers_Contact__r.Email,Customers_Contact__r.MailingStreet,
                                             Customers_Contact__r.MailingCity,Customers_Contact__r.MailingState,Customers_Contact__r.MailingCountry,Customers_Contact__r.MailingPostalCode, CreatedDate, Sample_Submitted_Date__c,Release_Date_Time__c,(SELECT Id,Product_Name__c,Release_Status__c,Actual_date_of_dispatch__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled' AND Release_Status__c != 'Dispatched') From Project__c WHERE Id IN : setOfSampleIds AND Submitted_To_SAP_Optiva__c = true AND Record_Type_Name__c = 'Sample' AND CreatedDate >=: startDateAPEX AND CreatedDate <=: endDateAPEX ORDER By Sample_Submitted_Date__c DESC limit 2000];   
                       system.debug('listOfSamples 8 ====> '+listOfSamples);
                        }else{
                            listOfSamples = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Account__r.Name, Account__c,
                                             Sample_Requested_by__c,Actual_Date_of_Dispatch__c,Owner.Name,Customers_Contact__c,Customers_Contact__r.Name,Customers_Contact__r.Phone,Customers_Contact__r.Email,Customers_Contact__r.MailingStreet,
                                             Customers_Contact__r.MailingCity,Customers_Contact__r.MailingState,Customers_Contact__r.MailingCountry,Customers_Contact__r.MailingPostalCode, CreatedDate, Sample_Submitted_Date__c,Release_Date_Time__c,(SELECT Id,Product_Name__c,Release_Status__c,Actual_date_of_dispatch__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled'AND Release_Status__c != 'Dispatched' ) From Project__c WHERE Id IN : setOfSampleIds AND Submitted_To_SAP_Optiva__c = true AND Record_Type_Name__c = 'Sample' AND Sample_Submitted_Date__c >=: startCreatedDateAPEX AND Sample_Submitted_Date__c <=: endCreatedDateAPEX ORDER By Sample_Submitted_Date__c DESC limit 2000]; 
                      system.debug('listOfSamples 9 ====> '+listOfSamples);
                        }
                    }else if(isToday && objectType == 'Sample'){
                        if(isCreatedDate){
                            System.debug('inside today filter');
                            listOfSamples = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Account__r.Name, Account__c,
                                             Sample_Requested_by__c,Actual_Date_of_Dispatch__c,Owner.Name,Customers_Contact__c,Customers_Contact__r.Name,Customers_Contact__r.Phone,Customers_Contact__r.Email,Customers_Contact__r.MailingStreet,
                                             Customers_Contact__r.MailingCity,Customers_Contact__r.MailingState,Customers_Contact__r.MailingCountry,Customers_Contact__r.MailingPostalCode, CreatedDate, Sample_Submitted_Date__c,Release_Date_Time__c,(SELECT Id,Product_Name__c,Release_Status__c,Actual_date_of_dispatch__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled'AND Release_Status__c != 'Dispatched') From Project__c WHERE Id IN : setOfSampleIds AND Submitted_To_SAP_Optiva__c = true AND Record_Type_Name__c = 'Sample' AND CreatedDate = TODAY ORDER By Sample_Submitted_Date__c DESC limit 2000]; 
                       system.debug('listOfSamples 10 ====> '+listOfSamples);
                        }else{
                            System.debug('inside today filter');
                            listOfSamples = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Account__r.Name, Account__c,
                                             Sample_Requested_by__c,Actual_Date_of_Dispatch__c,Owner.Name,Customers_Contact__c,Customers_Contact__r.Name,Customers_Contact__r.Phone,Customers_Contact__r.Email,Customers_Contact__r.MailingStreet,
                                             Customers_Contact__r.MailingCity,Customers_Contact__r.MailingState,Customers_Contact__r.MailingCountry,Customers_Contact__r.MailingPostalCode, CreatedDate, Sample_Submitted_Date__c,Release_Date_Time__c,(SELECT Id,Product_Name__c,Release_Status__c,Actual_date_of_dispatch__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled'AND Release_Status__c != 'Dispatched') From Project__c WHERE Id IN : setOfSampleIds AND Submitted_To_SAP_Optiva__c = true AND Record_Type_Name__c = 'Sample' AND Sample_Submitted_Date__c = TODAY ORDER By Sample_Submitted_Date__c DESC limit 2000]; 
                        system.debug('listOfSamples 11 ====> '+listOfSamples);
                        }
                    }
                    
                    else{
                        system.debug('Last Else Condition....');
                        listOfSamples = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Account__r.Name, Account__c,
                                         Sample_Requested_by__c,Actual_Date_of_Dispatch__c,Owner.Name,Customers_Contact__c,Customers_Contact__r.Name,Customers_Contact__r.Phone,Customers_Contact__r.Email,Customers_Contact__r.MailingStreet,
                                         Customers_Contact__r.MailingCity,Customers_Contact__r.MailingState,Customers_Contact__r.MailingCountry,Customers_Contact__r.MailingPostalCode, CreatedDate, Sample_Submitted_Date__c,Release_Date_Time__c,(SELECT Id,Product_Name__c,Release_Status__c,Actual_date_of_dispatch__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled' AND Release_Status__c != 'Dispatched') From Project__c WHERE Id IN : setOfSampleIds AND Submitted_To_SAP_Optiva__c = true AND Record_Type_Name__c = 'Sample' ORDER By Sample_Submitted_Date__c DESC limit 2000];
                    system.debug('listOfSamples 12 ====> '+listOfSamples);
                    }
                    
                    
                    /* For Sample Line Items */
                    
                    if(selProdFamily != '' && selProdFamily != null && objectType == 'SLI'){
                        listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Owner.Name,Sample_Invoice_Date__c,Sample_Submitted_Date__c,Release_Status__c,Release_Date_Time__c FROM Sample_Line_Item__c WHERE Sample_Assignment_Team__c IN : setOfSampleAssignment AND Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Product_Family__c =: selProdFamily limit 2000];
                    }else if(startDate != null && endDate != null && objectType == 'SLI'){
                        System.debug('inside date filter');
                        DateTime startDateAPEX = Datetime.valueOf(startDate.replace('T', ' '));
                        DateTime endDateAPEX = Datetime.valueOf(endDate.replace('T', ' '));
                        Date startCreatedDateAPEX = Date.valueOf(startDate);
                        Date endCreatedDateAPEX = Date.valueOf(endDate);
                        if(isCreatedDate){
                            listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Release_Date_Time__c,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Sample_Submitted_Date__c,Owner.Name,Sample_Invoice_Date__c,Release_Status__c FROM Sample_Line_Item__c WHERE Sample_Assignment_Team__c IN : setOfSampleAssignment AND Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Release_Date_Time__c >=: startDateAPEX AND Release_Date_Time__c <=: endDateAPEX ORDER By Sample_Submitted_Date__c DESC limit 2000];
                            
                        }else{
                            listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Release_Date_Time__c,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Sample_Submitted_Date__c,Owner.Name,Sample_Invoice_Date__c,Release_Status__c FROM Sample_Line_Item__c WHERE Sample_Assignment_Team__c IN : setOfSampleAssignment AND Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Sample_Submitted_Date__c >=: startCreatedDateAPEX AND Sample_Submitted_Date__c <=: endCreatedDateAPEX ORDER By Sample_Submitted_Date__c DESC limit 2000];
                            
                        }
                    }else if(isToday && objectType == 'SLI'){
                        if(isCreatedDate){
                            System.debug('inside today filter');
                            listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Sample_Submitted_Date__c,Release_Date_Time__c,Owner.Name,Sample_Invoice_Date__c,Release_Status__c FROM Sample_Line_Item__c WHERE Sample_Assignment_Team__c IN : setOfSampleAssignment AND Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Release_Date_Time__c = TODAY ORDER By Sample_Submitted_Date__c DESC limit 2000];
                            
                        }else{
                            System.debug('inside today filter');
                            listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Sample_Submitted_Date__c,Release_Date_Time__c,Owner.Name,Sample_Invoice_Date__c,Release_Status__c FROM Sample_Line_Item__c WHERE Sample_Assignment_Team__c IN : setOfSampleAssignment AND Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Sample_Submitted_Date__c = TODAY ORDER By Sample_Submitted_Date__c DESC limit 2000]; 
                        }
                    }else if(releaseStatus != '' && releaseStatus != null && objectType == 'SLI'){
                        system.debug('Inside Release Status -----'+releaseStatus);
                        listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Owner.Name,Sample_Invoice_Date__c,Sample_Submitted_Date__c,Release_Date_Time__c,Release_Status__c FROM Sample_Line_Item__c WHERE Sample_Assignment_Team__c IN : setOfSampleAssignment AND Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' AND Release_Status__c =: releaseStatus ORDER By Sample_Submitted_Date__c DESC limit 2000];
                        system.debug('listOfAllSLI ====> '+listOfAllSLI);
                    }
                    else{
                        system.debug('Last Else Condition....');
                        listOfAllSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c,Owner.Name,Sample_Invoice_Date__c,Sample_Submitted_Date__c,Release_Date_Time__c,Release_Status__c FROM Sample_Line_Item__c WHERE Sample_Assignment_Team__c IN : setOfSampleAssignment AND Sample__r.Submitted_To_SAP_Optiva__c = true AND Sample__r.Record_Type_Name__c = 'Sample' ORDER By Sample_Submitted_Date__c DESC limit 2000];
                        
                    }
                }
                
            }
            wrapper.listOfSLI = listOfAllSLI;
            wrapper.accList = allCustomerList;
            wrapper.accRecord = Null;
            wrapper.listOfSamples = listOfSamples;
            wrapper.oppList = oppList;
            wrapper.oppProductList = oppLIneItems;
            
            return wrapper;
        }catch(Exception e){
            return null;
        }
        
    }
    
    @RemoteAction
    public static accountDetailWrapper getCustomerDetails_OP(string hashCode, string selProdFamily, string startDate, string endDate, boolean isToday, boolean isCreatedDate, string objectType, string releaseStatus){
        try{
            Integer offsetNum;
            System.debug('selProdFamily==> ' + selProdFamily);
            System.debug('startDate==> ' + startDate);
            System.debug('endDate==> ' + endDate);
            system.debug('hashCode ====> '+hashCode);
            system.debug('offsetNum-->'+offsetNum);
            Set<Id> setOfSampleAssignment = New Set<Id>();
            Set<Id> setOfAccountIds = New Set<Id>();
            Set<Id> setOfSampleIds = New Set<Id>();
            Set<Id> setOfOppIds = New Set<Id>();
            List<OpportunityLineItem> oppLIneItems = New List<OpportunityLineItem>();
            List<Opportunity> oppList = New List<Opportunity>();
            List<Account> allCustomerList = New List<Account>();
            List<Project__c> listOfSamples = New List<Project__c>();
            List<Sample_Line_Item__c> listOfAllSLI = New List<Sample_Line_Item__c>();
            Contact conRecord = New Contact();
            accountDetailWrapper wrapper = new accountDetailWrapper();
            
            if(hashCode != null){
                conRecord = [SELECT Id,Name,Role__c,Login_Hash_Code__c,FirstName,LastName,Email,Phone,MobilePhone,Password__c,Sample_Assignment_Team__r.Team_Type__c FROM Contact WHERE Login_Hash_Code__c =: hashCode ];
                system.debug('conRecord ====> '+conRecord);
                wrapper.conRec = conRecord;
                set<Id> setOfOppsIds = new set<Id>();
                oppLIneItems = [SELECT Id,Name,OpportunityId,Product2Id,Product2.Name,Quantity,ListPrice,UnitPrice,TotalPrice,Price_In_KG__c,Quantity_In_KG__c FROM OpportunityLineItem WHERE Product_Family__c =: conRecord.Sample_Assignment_Team__r.Team_Type__c ORDER BY CreatedDate DESC limit 2000 ]; //offset :offsetNum
                system.debug('oppLIneItems size-->'+oppLIneItems.size());
                for(OpportunityLineItem oli : oppLIneItems){
                    setOfOppsIds.add(oli.OpportunityId);
                }
                
                set<Id> setOfAccsIds = new set<Id>();
                oppList = [SELECT Id,Name,Account.Name,Amount,CloseDate,AccountId,StageName,Probability,Type,RecordType.Name FROM Opportunity WHERE Id IN : setOfOppsIds ORDER BY CreatedDate DESC limit 2000];
                for(Opportunity opp : oppList){
                    setOfAccsIds.add(opp.AccountId);
                }
                
                if(!setOfAccsIds.isEmpty()){
                    if(startDate != null && endDate != null && objectType == 'Account'){
                        System.debug('inside date filter');
                        DateTime startDateAPEX = Datetime.valueOf(startDate.replace('T', ' '));
                        DateTime endDateAPEX = Datetime.valueOf(endDate.replace('T', ' '));
                        Date startCreatedDateAPEX = Date.valueOf(startDate);
                        Date endCreatedDateAPEX = Date.valueOf(endDate);
                        if(isCreatedDate){
                            allCustomerList = [SELECT Id,Name,Email__c,Phone,RecordType.Name,Customer_Number__c,CreatedDate,Account_Segment__c,Customer_Code_SAP__c FROM Account WHERE Id IN : setOfAccsIds AND CreatedDate >=: startDateAPEX AND CreatedDate <=: endDateAPEX ORDER By CreatedDate DESC limit 2000];  
                        }
                    }else if(isToday && objectType == 'Account'){
                        if(isCreatedDate){
                            allCustomerList = [SELECT Id,Name,Email__c,Phone,RecordType.Name,Customer_Number__c,CreatedDate,Account_Segment__c,Customer_Code_SAP__c FROM Account WHERE Id IN : setOfAccsIds AND CreatedDate = TODAY ORDER By CreatedDate DESC limit 2000];
                        }
                    }else{
                        allCustomerList = [SELECT Id,Name,Email__c,Phone,RecordType.Name,Customer_Number__c,CreatedDate,Account_Segment__c,Customer_Code_SAP__c FROM Account WHERE Id IN : setOfAccsIds ORDER By CreatedDate DESC limit 2000 ];
                    }
                    system.debug('allCustomerList ====> '+allCustomerList);
                    //oppList = [SELECT Id,Name,Account.Name,Amount,CloseDate,AccountId,StageName,Probability,Type,RecordType.Name FROM Opportunity WHERE AccountId IN : setOfAccountIds];
                }
                
                wrapper.listOfSLI = listOfAllSLI;
                wrapper.accList = allCustomerList;
                wrapper.accRecord = Null;
                wrapper.listOfSamples = listOfSamples;
                wrapper.oppList = oppList;
                wrapper.oppProductList = oppLIneItems;
            }
            return wrapper;
        }
        catch(Exception e){
            return null;
        }
        
    }
    @RemoteAction
    public static accountDetailWrapper getCustomerDetails_OPdummy(string hashCode, string selProdFamily, string startDate, string endDate, boolean isToday, boolean isCreatedDate, string objectType, string releaseStatus,Integer offsetNum){
        try{
            // Integer offsetNum;
            System.debug('selProdFamily==> ' + selProdFamily);
            System.debug('startDate==> ' + startDate);
            System.debug('endDate==> ' + endDate);
            system.debug('hashCode ====> '+hashCode);
            system.debug('offsetNum-->'+offsetNum);
            Set<Id> setOfSampleAssignment = New Set<Id>();
            Set<Id> setOfAccountIds = New Set<Id>();
            Set<Id> setOfSampleIds = New Set<Id>();
            Set<Id> setOfOppIds = New Set<Id>();
            List<OpportunityLineItem> oppLIneItems = New List<OpportunityLineItem>();
            List<Opportunity> oppList = New List<Opportunity>();
            List<Account> allCustomerList = New List<Account>();
            List<Project__c> listOfSamples = New List<Project__c>();
            List<Sample_Line_Item__c> listOfAllSLI = New List<Sample_Line_Item__c>();
            Contact conRecord = New Contact();
            accountDetailWrapper wrapper = new accountDetailWrapper();
            
            if(hashCode != null){
                conRecord = [SELECT Id,Name,Role__c,Login_Hash_Code__c,FirstName,LastName,Email,Phone,MobilePhone,Password__c,Sample_Assignment_Team__r.Team_Type__c FROM Contact WHERE Login_Hash_Code__c =: hashCode ];
                system.debug('conRecord ====> '+conRecord);
                wrapper.conRec = conRecord;
                set<Id> setOfOppsIds = new set<Id>();
                oppLIneItems = [SELECT Id,Name,OpportunityId,Product2Id,Product2.Name,Quantity,ListPrice,UnitPrice,TotalPrice,Price_In_KG__c,Quantity_In_KG__c FROM OpportunityLineItem WHERE Product_Family__c =: conRecord.Sample_Assignment_Team__r.Team_Type__c ORDER BY CreatedDate DESC limit 12 offset :offsetNum ]; //offset :offsetNum
                system.debug('oppLIneItems size'+oppLIneItems.size());
                for(OpportunityLineItem oli : oppLIneItems){
                    setOfOppsIds.add(oli.OpportunityId);
                }
                
                set<Id> setOfAccsIds = new set<Id>();
                oppList = [SELECT Id,Name,Account.Name,Amount,CloseDate,AccountId,StageName,Probability,Type,RecordType.Name FROM Opportunity WHERE Id IN : setOfOppsIds ORDER BY CreatedDate DESC];
                for(Opportunity opp : oppList){
                    setOfAccsIds.add(opp.AccountId);
                }
                
                if(!setOfAccsIds.isEmpty()){
                    if(startDate != null && endDate != null && objectType == 'Account'){
                        System.debug('inside date filter');
                        DateTime startDateAPEX = Datetime.valueOf(startDate.replace('T', ' '));
                        DateTime endDateAPEX = Datetime.valueOf(endDate.replace('T', ' '));
                        Date startCreatedDateAPEX = Date.valueOf(startDate);
                        Date endCreatedDateAPEX = Date.valueOf(endDate);
                        if(isCreatedDate){
                            allCustomerList = [SELECT Id,Name,Email__c,Phone,RecordType.Name,Customer_Number__c,CreatedDate,Account_Segment__c,Customer_Code_SAP__c FROM Account WHERE Id IN : setOfAccsIds AND CreatedDate >=: startDateAPEX AND CreatedDate <=: endDateAPEX ORDER By CreatedDate DESC];  
                        }
                    }else if(isToday && objectType == 'Account'){
                        if(isCreatedDate){
                            allCustomerList = [SELECT Id,Name,Email__c,Phone,RecordType.Name,Customer_Number__c,CreatedDate,Account_Segment__c,Customer_Code_SAP__c FROM Account WHERE Id IN : setOfAccsIds AND CreatedDate = TODAY ORDER By CreatedDate DESC];
                        }
                    }else{
                        allCustomerList = [SELECT Id,Name,Email__c,Phone,RecordType.Name,Customer_Number__c,CreatedDate,Account_Segment__c,Customer_Code_SAP__c FROM Account WHERE Id IN : setOfAccsIds ORDER By CreatedDate DESC ];
                    }
                    system.debug('allCustomerList ====> '+allCustomerList);
                    //oppList = [SELECT Id,Name,Account.Name,Amount,CloseDate,AccountId,StageName,Probability,Type,RecordType.Name FROM Opportunity WHERE AccountId IN : setOfAccountIds];
                }
                
                wrapper.listOfSLI = listOfAllSLI;
                wrapper.accList = allCustomerList;
                wrapper.accRecord = Null;
                wrapper.listOfSamples = listOfSamples;
                wrapper.oppList = oppList;
                wrapper.oppProductList = oppLIneItems;
            }
            return wrapper;
        }
        catch(Exception e){
            return null;
        }
        
    }
    
    @RemoteAction
    public static Contact getCustomerContactDetails(String conId){
        try{
            if(conId != null && conId != ''){
                List<Contact> conList = [SELECT Id, Name, Phone,Email,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalCode FROM Contact WHERE Id=:conId LIMIT 1];
                return conList[0];
            }else{
                return null;
            }
        }catch(exception e){
            System.debug(e.getMessage() + ' at ' + e.getLineNumber());
            return null;
        }
    }
    
    @RemoteAction
    public static accountDetailWrapper getSampleDetails(string sampleId, string userHashId){
        try{
            system.debug('sampleId-->'+sampleId);
            system.debug('userHashId-->'+userHashId);
            List<Attachment> attchList = [SELECT Id,Name FROM Attachment WHERE ParentId = :sampleId];
            system.debug('attchList-->'+attchList);
            List<Contact> conRecord = [SELECT Id,Name,Login_Hash_Code__c,FirstName,LastName,MobilePhone,Email,Password__c, AccountId,Role__c,Sample_Assignment_Team__r.Team_Type__c, (SELECT Id, Name, Sample_Assignment_Team_Type__c FROM Account__r) /*Sample_Assignment_Team__r.Team_Type__c*/ FROM Contact WHERE Login_Hash_Code__c =: userHashId];
            
            List<Contact> conRec = [SELECT AccountId,Id,Name,FirstName,LastName,MobilePhone,Email,Password__c,Role__c, (SELECT Id, Name, Sample_Assignment_Team_Type__c FROM Account__r),Sample_Assignment_Team__r.Team_Type__c FROM Contact WHERE Login_Hash_Code__c =: userHashId];
            List<Project__c> sampleRec = new List<Project__c>();
            if(conRec[0].Role__c == 'Dispatch Team'){
                sampleRec = [SELECT Account__c,Acc_Email__c,Acidity__c,Actual_Date_of_Dispatch__c,Additional_Comments__c,Additive_Status__c,
                             Allergen__c,Allergin_Free_Decleration__c,Annual_Value__c,Annual_Volume_Full__c,Annual_Volume_in_units__c,Application_guidelines_if_any__c,
                             Application_method__c,Application_Name__c,Application_product_shelf_life__c,Application_Ready__c,Application_reciepe_code__c,
                             Application_Samples_Receipe_Support__c,Application_Trails__c,Approval_Status__c,Approver_Name__c,Auto_Submit_Sample__c,Brix_degrees__c,
                             Business_potential_value_INR_New__c,Business_potential_value_INR__c,Category_Buyer__c,Category_description_as_per_FSSAI__c,
                             Center_filling_Cream__c,City__c,Company_Name__c,Confectionary_Type__c,Contact_Number__c,Cost_in_Use_target__c,
                             Country_of_Compliance__c,Country_Regulation__c,Country__c,Courier__c,CreatedById,CreatedDate,Critical__c,CurrencyIsoCode,Currency_Type__c,
                             Current_Cost__c,Current_Packaging__c,Current_RM_FG_Code__c,Current_Shelf_life__c,Current_Supplier_Name__c,Customers_Contact__c, Customers_Contact__r.Name,
                             Customer_Base_Details__c,Customer_Brand_details__c,Customer_Comments__c,Customer_Cost_in_USE_CIU__c,Customer_Launch_Date__c,
                             Customer_Name__c,Customer_Target_price__c,Dispatch_Details__c,Distributer_Customer__c,Documentation_Support__c,Dosage_guidelines_by_customer__c,
                             Dosage_Guidelines__c,End_Application_Category__c,End_Use_Applications__c,End_use_application_other__c,End_Use_category__c,Error_Message_On_Submitting_To_Optiva__c,
                             Error_Occured_On_Submitting_To_Optiva__c,Expected_Annual_Value__c,Expected_Shelf_Life__c,Expected_Volume_Unit__c,Export__c,External_Id__c,Fat__c,
                             Final_Fat__c,Final_SNF__c,First_Sample_due_date__c,Flavor_Legal_Status__c,Flavour_CIU__c,Flavour_Legal_Status__c,Follow_Up_Count__c,GMO_Status__c,
                             Halal_Certification__c,Id,If_Private_Label__c,If_yes_Flavour_Details__c,Ingredient_Specific_If_Any__c,Integration_Product_Type__c,IsDeleted,
                             Is_Shipping_Complete__c,Kosher_Certification__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Lead_Time__c,
                             Lead__c,Legal_Status_as_per_EU__c,Legal_Status_as_per_Indian_FSSAI__c,Legal_Status_as_per_US__c,Legal_Status__c,Matching_Target_details__c,
                             Milk_Solids__c,Minimum_order_quantity_unit__c,Minimum_order_quantity__c,Moved_Production_date__c,MSDS__c,Name,Name__c,New_Supplier__c,Nutritional__c,
                             of_pulp_if_with_fruit_pulp__c,Oil_sprinkling_Dust_on__c,Opportunity_Close_Date__c,Opportunity_Sub_Type__c,Opportunity_Type__c,Opportunity__c,
                             Organic_Certification__c,Other_Application_Methods__c,Other_Project_Composition__c,Other__c,OwnerId,Packaging_Unit__c,Parent_Project__c,
                             Payment_Terms__c,Physical_Form__c,pH__c,Postal_Code__c,Preferred_thickness_Viscosity__c,Priority__c,Processing_condition__c,Product_approval_format_by_customer__c,
                             Product_Code__c,Product_Description__c,Product_Family__c,Product_ID__c,Product_Instruction__c,Product_Link__c,Product_recommended__c,Product_Spec__c,
                             Product_Type__c,Project_Category__c,Project_Completion_Date__c,Project_Name__c,Project_Reference__c,Project_Title__c,Project_Type__c,Proposed_Cost__c,
                             Proposed_date_of_dispatch__c,Proposed_Supplier_Name__c,Prototype_Feedback__c,Quantity_Unit__c,Quantity__c,Quote_Volume_in_units__c,Raw_Material_Name__c,
                             Reason_for_New_Supplier__c,Reason_for_rejection__c,Main_reason_for_selecting_product__c,Recipe_Cost__c,RecordTypeId,Record_Type_Name__c,Regulatory_Requirements__c,
                             Required_End_Date__c,Revert_Date_Count__c,RM_Category__c,R_D_Approval_Status__c,Sales_Code__c,Sales_head_review__c,Sample_Delivery_Date__c,
                             Sample_Name__c,Sample_Project__c,Sample_Requested_by__c,Sample_Revert_Date__c,Sample_Size_for_trails__c,Sample_Submitted_Date__c,Sample_Sub_Retry_Count__c,
                             Sampling_Quantity_details__c,Sampling_Quantity_Unit__c,SAP_User_Code__c,Scaled_up_date__c,Sensory_profiling_Report_Required__c,Sensory_Target_profile_expectation__c,
                             Ship_To_Address__c,Solubility_Preference__c,Solublity__c,Specific_inputs_by_customer__c,Specify_other_reason__c,Start_Date__c,
                             State__c,Status__c,Street__c,Submitted_To_SAP_Optiva__c,Submit_Sample_To_Optiva__c,Sugar__c,Supplier_COA__c,Supplier_Food_Grade_Status__c,
                             Supplier_Legal_Status__c,Supplier_MSDS__c,Supplier_Spec__c,SystemModstamp,S_O_Date__c,Target_Date__c,Target_GM_Improvement_at_FG_levels__c,
                             Target_Price__c,Target_Saving_Percentage__c,Technical_Complexity__c,Tech_Doc_Name__c,Tested_at_Flavor_Level__c,Time_Duration_in_hours__c,Total_Project_Quotient__c,
                             Total_Solids__c,Type_of_PR__c,Usage_Levels_in_Recipes_Average__c,Way_Bill_No__c,Wet_Dry__c,Where_Used__c,who_requested_the_sample__c,
                             Opportunity__r.Name,Opportunity__r.AccountId,Account__r.Name,(SELECT Id, Sample_Invoice_Date__c,Courier__c, Actual_date_of_dispatch__c, Release_to_Dispatch_Team__c, Release_Status__c, Dispatch_Details__c, Way_Bill_No__c, Name, Product__c,Project_Quotient__c,OPTIVA_Recipe__c, Quantity__c, Quantity_Unit__c, Packaging_Quantity__c, Packaging_Unit__c, Product_Max_Qty__c, Formula_Packaging_Qty__c, Product__r.Regulatory__c,OPTIVA_Recipe__r.Name, OPTIVA_Recipe__r.Regulatory__c, OPTIVA_Recipe__r.Shelf_Life__c,Product_Family__c,
                                                                                           Expected_Shelf_Life__c, Additional_Comments__c, Customer_Instructions__c, Sample__c,Sample__r.Owner.Email,Project_Quotient__r.Name, Project_Quotient__r.SSC_Code__c, Product__r.Sampling_Qty_UNIT__c, Product__r.Name, Product__r.Family, Product__r.Max_sampling_Qty__c, Product__r.ProductCode, Product__r.Current_Shelf_Life__c, OPTIVA_Recipe__r.SSC_Code__c,Product_Name__c
                                                                                           FROM Sample_Line_Items__r WHERE Release_Status__c = 'Released'),(SELECT Id,Name,Comment__c,Comment_By__r.Name FROM Comments__r) FROM Project__c WHERE Id =: sampleId limit 2000];
            }else{
                sampleRec = [SELECT Account__c,Acc_Email__c,Acidity__c,Actual_Date_of_Dispatch__c,Additional_Comments__c,Additive_Status__c,
                             Allergen__c,Allergin_Free_Decleration__c,Annual_Value__c,Annual_Volume_Full__c,Annual_Volume_in_units__c,Application_guidelines_if_any__c,
                             Application_method__c,Application_Name__c,Application_product_shelf_life__c,Application_Ready__c,Application_reciepe_code__c,
                             Application_Samples_Receipe_Support__c,Application_Trails__c,Approval_Status__c,Approver_Name__c,Auto_Submit_Sample__c,Brix_degrees__c,
                             Business_potential_value_INR_New__c,Business_potential_value_INR__c,Category_Buyer__c,Category_description_as_per_FSSAI__c,
                             Center_filling_Cream__c,City__c,Company_Name__c,Confectionary_Type__c,Contact_Number__c,Cost_in_Use_target__c,
                             Country_of_Compliance__c,Country_Regulation__c,Country__c,Courier__c,CreatedById,CreatedDate,Critical__c,CurrencyIsoCode,Currency_Type__c,
                             Current_Cost__c,Current_Packaging__c,Current_RM_FG_Code__c,Current_Shelf_life__c,Current_Supplier_Name__c,Customers_Contact__c, Customers_Contact__r.Name,
                             Customer_Base_Details__c,Customer_Brand_details__c,Customer_Comments__c,Customer_Cost_in_USE_CIU__c,Customer_Launch_Date__c,
                             Customer_Name__c,Customer_Target_price__c,Dispatch_Details__c,Distributer_Customer__c,Documentation_Support__c,Dosage_guidelines_by_customer__c,
                             Dosage_Guidelines__c,End_Application_Category__c,End_Use_Applications__c,End_use_application_other__c,End_Use_category__c,Error_Message_On_Submitting_To_Optiva__c,
                             Error_Occured_On_Submitting_To_Optiva__c,Expected_Annual_Value__c,Expected_Shelf_Life__c,Expected_Volume_Unit__c,Export__c,External_Id__c,Fat__c,
                             Final_Fat__c,Final_SNF__c,First_Sample_due_date__c,Flavor_Legal_Status__c,Flavour_CIU__c,Flavour_Legal_Status__c,Follow_Up_Count__c,GMO_Status__c,
                             Halal_Certification__c,Id,If_Private_Label__c,If_yes_Flavour_Details__c,Ingredient_Specific_If_Any__c,Integration_Product_Type__c,IsDeleted,
                             Is_Shipping_Complete__c,Kosher_Certification__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Lead_Time__c,
                             Lead__c,Legal_Status_as_per_EU__c,Legal_Status_as_per_Indian_FSSAI__c,Legal_Status_as_per_US__c,Legal_Status__c,Matching_Target_details__c,
                             Milk_Solids__c,Minimum_order_quantity_unit__c,Minimum_order_quantity__c,Moved_Production_date__c,MSDS__c,Name,Name__c,New_Supplier__c,Nutritional__c,
                             of_pulp_if_with_fruit_pulp__c,Oil_sprinkling_Dust_on__c,Opportunity_Close_Date__c,Opportunity_Sub_Type__c,Opportunity_Type__c,Opportunity__c,
                             Organic_Certification__c,Other_Application_Methods__c,Other_Project_Composition__c,Other__c,OwnerId,Packaging_Unit__c,Parent_Project__c,
                             Payment_Terms__c,Physical_Form__c,pH__c,Postal_Code__c,Preferred_thickness_Viscosity__c,Priority__c,Processing_condition__c,Product_approval_format_by_customer__c,
                             Product_Code__c,Product_Description__c,Product_Family__c,Product_ID__c,Product_Instruction__c,Product_Link__c,Product_recommended__c,Product_Spec__c,
                             Product_Type__c,Project_Category__c,Project_Completion_Date__c,Project_Name__c,Project_Reference__c,Project_Title__c,Project_Type__c,Proposed_Cost__c,
                             Proposed_date_of_dispatch__c,Proposed_Supplier_Name__c,Prototype_Feedback__c,Quantity_Unit__c,Quantity__c,Quote_Volume_in_units__c,Raw_Material_Name__c,
                             Reason_for_New_Supplier__c,Reason_for_rejection__c,Main_reason_for_selecting_product__c,Recipe_Cost__c,RecordTypeId,Record_Type_Name__c,Regulatory_Requirements__c,
                             Required_End_Date__c,Revert_Date_Count__c,RM_Category__c,R_D_Approval_Status__c,Sales_Code__c,Sales_head_review__c,Sample_Delivery_Date__c,
                             Sample_Name__c,Sample_Project__c,Sample_Requested_by__c,Sample_Revert_Date__c,Sample_Size_for_trails__c,Sample_Submitted_Date__c,Sample_Sub_Retry_Count__c,
                             Sampling_Quantity_details__c,Sampling_Quantity_Unit__c,SAP_User_Code__c,Scaled_up_date__c,Sensory_profiling_Report_Required__c,Sensory_Target_profile_expectation__c,
                             Ship_To_Address__c,Solubility_Preference__c,Solublity__c,Specific_inputs_by_customer__c,Specify_other_reason__c,Start_Date__c,
                             State__c,Status__c,Street__c,Submitted_To_SAP_Optiva__c,Submit_Sample_To_Optiva__c,Sugar__c,Supplier_COA__c,Supplier_Food_Grade_Status__c,
                             Supplier_Legal_Status__c,Supplier_MSDS__c,Supplier_Spec__c,SystemModstamp,S_O_Date__c,Target_Date__c,Target_GM_Improvement_at_FG_levels__c,
                             Target_Price__c,Target_Saving_Percentage__c,Technical_Complexity__c,Tech_Doc_Name__c,Tested_at_Flavor_Level__c,Time_Duration_in_hours__c,Total_Project_Quotient__c,
                             Total_Solids__c,Type_of_PR__c,Usage_Levels_in_Recipes_Average__c,Way_Bill_No__c,Wet_Dry__c,Where_Used__c,who_requested_the_sample__c,
                             Opportunity__r.Name,Opportunity__r.AccountId,Account__r.Name,(SELECT Id, Sample_Invoice_Date__c,Courier__c, Actual_date_of_dispatch__c, Release_to_Dispatch_Team__c, Release_Status__c, Dispatch_Details__c, Way_Bill_No__c, Name, Product__c,Project_Quotient__c,OPTIVA_Recipe__c, Quantity__c, Quantity_Unit__c, Packaging_Quantity__c, Packaging_Unit__c, Product_Max_Qty__c, Formula_Packaging_Qty__c, Product__r.Regulatory__c,OPTIVA_Recipe__r.Name, OPTIVA_Recipe__r.Regulatory__c, OPTIVA_Recipe__r.Shelf_Life__c,Product_Family__c,
                                                                                           Expected_Shelf_Life__c, Additional_Comments__c, Product__r.Family,Customer_Instructions__c, Sample__c,Sample__r.Owner.Email,Project_Quotient__r.Name, Project_Quotient__r.SSC_Code__c, Product__r.Sampling_Qty_UNIT__c, Product__r.Name, Product__r.Max_sampling_Qty__c, Product__r.ProductCode, Product__r.Current_Shelf_Life__c, OPTIVA_Recipe__r.SSC_Code__c,Product_Name__c
                                                                                           FROM Sample_Line_Items__r),(SELECT Id,Name,Comment__c,Comment_By__r.Name FROM Comments__r) FROM Project__c WHERE Id =: sampleId limit 2000];
            }
            
            accountDetailWrapper wrapper = new accountDetailWrapper();
            List<String> typeList = new List<String>();
            for(Sample_Allocation_Team__c st : conRec[0].Account__r){
                if(st.Sample_Assignment_Team_Type__c != null && st.Sample_Assignment_Team_Type__c != ''){
                    typeList.add(st.Sample_Assignment_Team_Type__c);
                }
            }
            List<Product2> productList = [SELECT Id,ProductCode,Name,Family FROM Product2 WHERE Family IN : typeList];
            //List<OPTIVA_Recipe__c> opRecipeList = [SELECT Id,Name,SSC_Code__c,Recipe_Family__c FROM OPTIVA_Recipe__c WHERE Recipe_Family__c IN : typeList];
            //List<Project_Quotient__c> proQuotientList = [SELECT Id,Name,SSC_Code__c,Sample_Project_Application__c,Sample_Project_Application__r.Product_Family__c FROM Project_Quotient__c WHERE Sample_Project_Application__r.Product_Family__c IN : typeList];
            wrapper.listOfSamples = sampleRec;
            wrapper.listOfProducts = productList;
            wrapper.accId = sampleRec[0].Opportunity__r.AccountId;
            wrapper.attachmentListing = attchList;
            //wrapper.listOfOptivaRecipe = opRecipeList;
            //wrapper.listOfProQuotient = proQuotientList;
            wrapper.conRec = conRec[0];
            
            return wrapper;
        }catch(Exception e){
            return null;
        }
    }
    
     @RemoteAction
     public static String getAttachmentData(String attchId) {
         Attachment attch;
         try{
             
         Attachment  attach = [SELECT Id,Name,Body,ContentType FROM Attachment WHERE Id = :attchId];
              String base64Data = EncodingUtil.base64Encode(attach.Body);
             system.debug(+attach.ContentType + ';base64,' + base64Data);
             return 'data:' + attach.ContentType + ';base64,' + base64Data;
             
         }catch(Exception e){
             system.debug('Exception Message-->'+e.getMessage());
             System.debug('Exception Line Number-->'+e.getLineNumber());
         }
            // Convert the attachment body to a Base64 encoded string
           
            return null;
    }
    
    
    @RemoteAction
    public static Contact getConDetails(string userHashId){
        Contact conRec = [SELECT Id,Name,FirstName,LastName,MobilePhone,Email,Password__c,AccountId,Sample_Assignment_Team__r.Team_Type__c FROM Contact WHERE Login_Hash_Code__c =: userHashId];
        return conRec;
    }
    
    
    @RemoteAction
    public static Sample_Line_Item__c getSLIDetails(string sliId){
        try{
            List<Sample_Line_Item__c> SLIRec = [SELECT Account_Id__c,Actual_date_of_dispatch__c,Additional_Comments__c,Contact__c,Courier__c,CreatedById,
                                                CreatedDate,CurrencyIsoCode,Current_Shelf_Life__c,Customer_Instructions__c,Customer_Name__c,Customer_Target_price__c,Dispatch_Details__c,
                                                Distributer_Customer__c,Exclusive_customer_product_code__c,Expected_Shelf_Life__c,First_Sample_Due_Date__c,Formula_Packaging_Qty__c,Id,
                                                IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Line_Item_Name__c,Name,OPTIVA_Recipe__c,
                                                OwnerEmail__c,OwnerId,Packaging_Quantity__c,Packaging_Unit__c,Product_Code__c,Product_Family__c,Product_Max_Qty__c,Product_Name__c,Product__c,
                                                Project_Quotient__c,Qty_in_KGs__c,Quantity_Unit__c,Quantity__c,Reason_For_Rejection__c,Regulatory_Requirements__c,Sample_Delivery_Date__c,
                                                Sample_Invoice_Date__c,Sample_Request_Status__c,Sample_Submitted_Date__c,Sample_Type__c,Sample__c,SLI_Dispatched__c,Start_Date__c,Submitted__c,
                                                SystemModstamp,Way_Bill_No__c,Sample__r.Name,Project_Quotient__r.Name,(SELECT Id,Name,Comment__c,Comment_By__r.Name FROM Comments__r) FROM Sample_Line_Item__c WHERE Id =: sliId limit 2000];
            return SLIRec[0];
        }catch(Exception e){
            return null;
        }
    }
    
    @AuraEnabled
    public static Account getAccRecord(String id){
        try {
            if(String.isBlank(id))
                return null;
            return [SELECT Id, Name FROM Account where Id =:id];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string getProjectRecordTypeId(string recordTypeName){
        try {
            system.debug('recordTypeName ====> '+recordTypeName);
            // system.debug('idd'+Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId());
            return '0129D000001KUxvQAG';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @RemoteAction
    public static accountDetailWrapper getCustomerDetail(String accId, String hashCode){
        try{
            List<ContentDistribution> filesList = OperationsPortalController.getAccRelatedFiles(accId);
            List<Project__c> listOfAllSampleRecords = New List<Project__c>();
            List<Sample_Allocation_Team__c> listOfAllocationTeam = New List<Sample_Allocation_Team__c>();
            Set<Id> setOfSampleAssignment = New Set<Id>();
            List<Sample_Line_Item__c> listOfAllSLI = New List<Sample_Line_Item__c>();
            
            List<Contact> conRec = [SELECT Id,Name,FirstName,LastName,MobilePhone,Email,Password__c,Sample_Assignment_Team__r.Team_Type__c,(SELECT Id, Name, Sample_Assignment_Team_Type__c FROM Account__r)/*Sample_Assignment_Team__r.Team_Type__c*/,Role__c FROM Contact WHERE Login_Hash_Code__c =: hashCode];
            List<Account> accRecord = [SELECT AccountSource,Account_Potential__c,
                                       Account_Segment__c,Account_Type__c,BillingAddress,BillingCity,BillingCountry,
                                       BillingCountryCode,BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,
                                       BillingPostalCode,BillingState,BillingStateCode,BillingStreet,Billing_Block__c,
                                       Billing_To_Shipping__c,Brands__c,Closed_Opportunity_Value_New__c,
                                       Closed_Opportunity_Value__c,Closed_opportunity__c,COLOR_Opportunity_Closed_Value_New__c,
                                       COLOR_Opportunity_Closed_Value__c,Contract_period__c,CPD_Opportunity_Closed_Value_New__c,
                                       CPD_Opportunity_Closed_Value__c,CreatedById,CreatedDate,Credit_Block__c,Credit_Limit_Finance__c,
                                       Credit_Limit__c,Credit_Period_Finance__c,Credit_Period__c,CurrencyIsoCode,
                                       Currency__c,Current_year_Volume_Unit__c,Current_year_Volume__c,Customer_Code_OPTIVA__c,
                                       Customer_Code_SAP__c,Customer_Contact__r.Name,Customer_Discount__c,Customer_Number__c,
                                       Customer_Type__c,Delivery_Block__c,Delivery_Plant__c,Description,DISTRIBUTOR_BASIC_RATE_in_INR__c,
                                       DISTRIBUTOR_LANDING_in_INR__c,Document_Category__c,Email__c,Existing_product_portfolio_of_the_compny__c,
                                       FLAVOR_Opportunity_Closed_Value_New__c,FLAVOR_Opportunity_Closed_Value__c,FSSAI__c,GST_number__c,
                                       Id,Industry,InitiatedCustomerCreation__c,IsDeleted,Jigsaw,JigsawCompanyId,Language__c,
                                       LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,
                                       Launching_in_brands_associated__c,Lead_generated_by__c,Lead_generated_by__r.Name,Login_Hash_Code__c,MasterRecordId,
                                       Missing_Fields__c,Name,NDA_required__c,Owner.FirstName,User__r.Name,Next_Follow_up_Date__c,NumberOfEmployees,
                                       Number_of_closed_opportunity_new__c,Number_of_closed_opportunity__c,Number_of_open_opportunity_new__c,
                                       Number_of_open_opportunity__c,Number_of_Total_Opportunity_new__c,Number_of_Total_Opportunity__c,
                                       Number_Of_Won_Opportunity_new__c,Number_of_won_opportunity_partially_exec__c,Number_of_won_opportunity_partially_new__c,
                                       Number_Of_Won_Opportunity__c,Outstanding_Balance__c,Overall_Block__c,OwnerEmail__c,
                                       OwnerId,PAN_Number__c,ParentId,Partially_executed_actual_order_value_vs__c,
                                       Password__c,Payment_terms__c,Percentage_Value__c,Phone,PhotoUrl,PLANT_BASED_Opportunity_Closed_Value_New__c,
                                       PLANT_BASED_Opportunity_Closed_Value__c,Potential_Opportunity__c,Profile_Pic_Id__c,
                                       RecordTypeId,Record_Type_Name__c,Run_Validation_Rule__c,ShippingAddress,ShippingCity,
                                       ShippingCountry,ShippingCountryCode,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,
                                       ShippingPostalCode,ShippingState,ShippingStateCode,ShippingStreet,Show_Parent_Account_Summary__c,
                                       SicDesc,Single_Multiple__c,SPD_Opportunity_Closed_Value_New__c,SPD_Opportunity_Closed_Value__c,
                                       Status__c,Submitted_to_Optiva__c,Submitted_to_SAP__c,SystemModstamp,Tax_Collected_At_Source__c,
                                       Tax_Type__c,Total_Team_Members__c,Transportation_Terms__c,Type,User__c,Visible_Potential__c,
                                       Website,Win_rate__c,Won_opportunity_value_product_wise__c,(SELECT Id From Opportunities),(SELECT Id,Name,Comment__c,Comment_By__r.Name FROM Comments__r) FROM Account WHERE Id =: accId];
            
            set<Id> setOfOppIds = New set<Id>();
            if(!accRecord[0].Opportunities.isEmpty()){
                for(Opportunity opp : accRecord[0].Opportunities){
                    setOfOppIds.add(opp.Id);
                }
            }
            system.debug('setOfOppIds =====> '+setOfOppIds);
            set<Id> setOfProId = New Set<Id>();
            accountDetailWrapper wrapper = new accountDetailWrapper();
            if(conRec[0].Role__c == 'Dispatch Team'){
                system.debug('Dispatch Team....');
                List<Project__c> listOfProject = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Project_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Sample_Requested_by__c,Opportunity__c,CreatedDate,Sample_Submitted_Date__c,Release_Date_Time__c,Owner.Name,(SELECT Id,Product_Name__c,Release_Status__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled' AND Release_Status__c != null) From Project__c  WHERE Opportunity__c IN : setOfOppIds AND Record_Type_Name__c = 'Sample' limit 2000];
                system.debug('listOfProject ====> '+listOfProject);
                if(!listOfProject.isEmpty()){
                    for(Project__c pro : listOfProject){
                        setOfProId.add(pro.Id);
                    }
                }
                system.debug('setOfProId ====> '+setOfProId);
                listOfAllSLI = [SELECT Id,Name,Sample__c,Sample_Type__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,
                                Sample__r.Name,Sample__r.Record_Type_Name__c,Sample__r.Sample_Name__c,Sample__r.Project_Name__c,Sample__r.Shipping_Type__c,Sample__r.Status__c,Sample__r.Product_Family__c,Sample__r.CreatedDate,Sample__r.Sample_Requested_by__c,Sample__r.Opportunity__c FROM Sample_Line_Item__c WHERE Sample__c IN : setOfProId AND Release_to_Dispatch_Team__c = True limit 2000];
                List<Project__c> listOfsamp = New List<Project__c>();
                // listOfsamp.add(listOfAllSLI[0].Sample__r);
                
                if(!String.isBlank(listOfAllSLI[0].Sample__c)){
                    listOfsamp = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Project_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Sample_Requested_by__c,Opportunity__c,CreatedDate,Sample_Submitted_Date__c,Release_Date_Time__c,Owner.Name,(SELECT Id,Product_Name__c,Release_Status__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled' AND Release_Status__c != null) From Project__c WHERE Id =: listOfAllSLI[0].Sample__c];
                }
                system.debug('listOfsamp ====> '+listOfsamp);
                wrapper.listOfSamples = listOfProject;
                system.debug('listOfAllSLI[0].Sample__r ====> '+listOfAllSLI[0].Sample__r);
            }else{
                listOfAllSampleRecords = [SELECT Id,Name,Record_Type_Name__c,Sample_Name__c,Project_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Sample_Requested_by__c,Opportunity__c,CreatedDate,Sample_Submitted_Date__c,Release_Date_Time__c,Owner.Name,(SELECT Id,Product_Name__c,Release_Status__c FROM Sample_Line_Items__r Where Release_Status__c != 'Released' AND Release_Status__c != 'Cancelled' AND Release_Status__c != null) From Project__c WHERE Opportunity__c IN : setOfOppIds AND Record_Type_Name__c = 'Sample' limit 2000];
                wrapper.listOfSamples = listOfAllSampleRecords;
            }
            
            system.debug('listOfAllSampleRecords ====> '+listOfAllSampleRecords);
            
            wrapper.accRecord = (accRecord.size() > 0) ? accRecord[0] : null;
            
            wrapper.conRec = conRec[0];
            wrapper.filesList = filesList;
            return wrapper;
        }catch(Exception e){
            return null;
        }
    }
    
    @RemoteAction
    public static accountDetailWrapper getOpportunityDetails(string oppId){
        try{
            List<Account> accRec = New List<Account>();
            List<Dispatch_Address__c> custAddRecord = New List<Dispatch_Address__c>();
            List<Contact> conTactList = New List<Contact>();
            List<Opportunity> oppRecord = [SELECT AccountId,Account_Billing_Address__c,Customer_Billing_Address__c,accShipAdr__c,AgeInDays,Amount,Approval_Status__c,Approved_by_Business_Head__c,Approved_by_Manager__c,
                                           Approved_by_MD__c,Approver_Name__c,CampaignId,Child_Opp__c,CloseDate,Color_Opportunity__c,ContactId,ContractId,CPD_Opportunity__c,CreatedById,
                                           Billing_Street__c,Billing_City__c,Billing_State__c,Billing_Country__c,Billing_Postal_Code__c,CreatedDate,CurrencyIsoCode,Customer_Followup_Date__c,Customer_response__c,Description,Distributer_Customer__c,Email__c,End_Use_Application__c,
                                           End_Use_Category__c,Fiscal,FiscalQuarter,FiscalYear,Fiscal_Year__c,Flavor_Opportunity__c,ForecastCategory,ForecastCategoryName,Freight_charges__c,
                                           HasOpenActivity,HasOpportunityLineItem,HasOverdueTask,Id,Include_Freight_Charges__c,Initial_Discount_Approved__c,IsClosed,IsDeleted,
                                           IsPriorityRecord,IsWon,LastActivityDate,LastActivityInDays,LastAmountChangedHistoryId,LastCloseDateChangedHistoryId,LastModifiedById,
                                           LastModifiedDate,LastReferencedDate,LastStageChangeDate,LastStageChangeInDays,LastViewedDate,Last_Opp_Closure_Reminder_Date__c,LeadSource,
                                           Markdown__c,Name,NextStep,Next_Order_Date__c,Opportunity_Age__c,Opportunity_Reference_No__c,OwnerEmail__c,OwnerId,Parent_Opportunity__c,
                                           Performa_Invoice_No__c,Place_of_Reciept_by_Pre_Carrier__c,Plant_Based_Opportunity__c,Port_of_Discharge__c,Port_of_Loading__c,Pre_carriage_By__c,
                                           Pricebook2Id,Primary_Contact__c,Probability,Proposed_Date_of_Dispatch__c,PushCount,Pvt_Label_Item_Count__c,Reason_For_Loss_del__c,RecordTypeId,
                                           Repeat_Order_Created__c,Sample__c,Send_Fert_Notification_Email__c,Show_FERT_Button__c,SPD_Opportunity__c,StageName,
                                           SyncedQuoteId,SystemModstamp,TotalOpportunityQuantity,Total_FERT_Products__c,Total_Freight_Charges__c,Total_List_Price__c,Total_Markdown_Price__c,
                                           Total_Qty_In_Kg__c,Total_Quantity__c,Total_Unit_Price__c,Type,Vessel_Flight_Name_Voy_No__c,RecordType.Name,
                                           Account.Name,Primary_Contact__r.Name,Pricebook2.Name FROM Opportunity WHERE Id =: oppId];
            
            List<OpportunityLineItem> oliList = [SELECT Applied_Volume_Based_Markup__c,Approval_Markdown__c,Art_Work__c,Change_in_Dispatch_Date__c,CreatedById,CreatedDate,CurrencyIsoCode,
                                                 Cusinery_identity__c,Customer_Code__c,Customer_Discount_Applied__c,Customer_Type__c,Customized_Label__c,Description,Discount,Discount_Description__c,
                                                 FERT_Code__c,Fert_Description__c,Id,If_Organised_set_Micro_as_Long_Term__c,Ingredients_List_Declared_With_Customer__c,Ingredient_list__c,IsDeleted,
                                                 Is_Parent_Opportunity__c,Is_PIR_Created__c,Label__c,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,ListPrice,ListPriceXQty__c,
                                                 MarkdownXQty__c,MarkDown_Amount__c,Markup_Amount__c,Material_Sector__c,Name,OpportunityId,Order_Quantity__c,Packaging_Quantity__c,Packaging_Type__c,
                                                 Packaging_Unit__c,Planned_Delivery_Date__c,Plant__c,PricebookEntryId,Price_In_KG__c,Primary__c,Product2Id,Product2.Name,ProductCode,Product_Family__c,
                                                 Pvt_Label_Selling_Price__c,Quantity,Quantity_In_KG__c,Quantity_Unit__c,Reveal_Symega_Identity__c,Sales_Order__c,Sales_Remarks__c,
                                                 Sale_Order_Submitted__c,Secondary__c,ServiceDate,Service_Rendering_Date_Reason__c,Service_Rendering_Date__c,SortOrder,SSC_Code_for_Flavours__c,
                                                 Sub_Total__c,Symega_Logo__c,SystemModstamp,Tertiary__c,TotalPrice,Type__c,UnitPrice,UnitPriceXQty__c,Unit_Of_Measure__c,Volume_Based_Amount__c,Product2.Shelf_Life__c, 
                                                 Product2.Allergen_Status_Required__c,Product2.HSN_Code__c,Product2.Veg_Nonveg_Logo_In_Label__c,Opportunity.Account.Name,Sales_Unit__c,HSN_Code__c FROM OpportunityLineItem WHERE OpportunityId =: oppId limit 2000];
            
            
            
            if(oppRecord[0].AccountId != null && oppRecord[0].Account_Billing_Address__c == true){
                accRec = [Select Id,Name, Customer_Type__c,CurrencyIsoCode,BillingCity,BillingCountry,BillingStreet,BillingPostalCode,BillingState,Delivery_Plant__c,Account_Segment__c,
                          Transportation_Terms__c,PAN_Number__c,GST_number__c From Account WHERE Id =: oppRecord[0].AccountId];
                conTactList = [SELECT Id,Name FROM Contact WHERE AccountId =: accRec[0].Id];
                
            }
            if(oppRecord[0].Customer_Billing_Address__c != null){
                custAddRecord = [select Id,Address__city__s,Address__Street__s,Address__PostalCode__s,toLabel(Address__CountryCode__s),toLabel(Address__StateCode__s),Contact__c,Account__c,
                                 Type__c from Dispatch_Address__c WHERE Id =: oppRecord[0].Customer_Billing_Address__c]; 
                conTactList = [SELECT Id,Name FROM Contact WHERE AccountId =: custAddRecord[0].Account__c];
            }
            
            accountDetailWrapper wrapper = new accountDetailWrapper();
            wrapper.oppList = oppRecord;
            if(!accRec.isEmpty()){
                wrapper.accRecord = accRec[0];
            }
            
            if(!custAddRecord.isEmpty()){
                wrapper.customerAddRec = custAddRecord[0];
            }
            if(!oliList.isEmpty()){
                wrapper.oppProductList = oliList;
            }
            if(!conTactList.isEmpty()){
                wrapper.conList = conTactList;
            }
            return wrapper;
        }catch(Exception e){
            return null;
        }
    }
    
    @RemoteAction
    public static OpportunityLineItem getOppProductDetails(string oliId){
        try{
            List<OpportunityLineItem> oppProdRecord = [SELECT Applied_Volume_Based_Markup__c,Approval_Markdown__c,Change_in_Dispatch_Date__c,CreatedById,
                                                       CreatedDate,CurrencyIsoCode,Customer_Code__c,Customer_Discount_Applied__c,Customer_SF_Id__c,Customer_Type__c,Customized_Label__c,Description,
                                                       Discount,Discount_Description__c,FERT_Code__c,Id,If_Organised_set_Micro_as_Long_Term__c,IsDeleted,Is_Parent_Opportunity__c,Is_PIR_Created__c,
                                                       LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,ListPrice,ListPriceXQty__c,MarkdownXQty__c,MarkDown_Amount__c,Markup_Amount__c,
                                                       Material_Sector__c,Name,OpportunityId,Packaging_Quantity__c,Packaging_Type__c,Packaging_Unit__c,Planned_Delivery_Date__c,Plant__c,PricebookEntryId,
                                                       Price_In_KG__c,Primary__c,Product2Id,ProductCode,Product_Family__c,Pvt_Label_Selling_Price__c,Quantity,Quantity_In_KG__c,Quantity_Unit__c,
                                                       Repeat_Order_Details__c,Sales_Order__c,Secondary__c,ServiceDate,Service_Rendering_Date_Reason__c,Service_Rendering_Date__c,SortOrder,Sub_Total__c,
                                                       Symega_Logo__c,SystemModstamp,Tertiary__c,TotalPrice,UnitPrice,UnitPriceXQty__c,Volume_Based_Amount__c,Volume_Based_Unit__c,
                                                       Opportunity.Name,Product2.Name,Sales_Order__r.Name, (SELECT Id,Name,Comment__c,Comment_By__r.Name FROM Comments__r) FROM OpportunityLineItem WHERE Id =: oliId];
            return oppProdRecord[0];
        }catch(Exception e){
            return null;
        }
    }
    
    public class accountDetailWrapper{
        public Account accRecord { get; set; }
        public String accId {get; set;}
        public List<Project__c> listOfSamples { get; set; }
        public List<Sample_Line_Item__c> listOfSLI { get; set; }
        public List<Account> accList { get; set; }
        public Contact conRec { get; set; }
        public List<Opportunity> oppList { get; set; }
        public List<OpportunityLineItem> oppProductList { get; set; }
        public Dispatch_Address__c customerAddRec {get; set;}
        public list<Product2> listOfProducts { get; set; }
        public list<OPTIVA_Recipe__c> listOfOptivaRecipe { get; set; }
        public list<Project_Quotient__c> listOfProQuotient { get; set; }
        public list<Contact> conList { get; set; }
        public List<ContentDistribution> filesList {get; set;}
        public List<Attachment> attachmentListing {get;set;}
    }
    
    public class SampleStatusWrapper{
        public String cssClass { get; set; }
        public String statusVal {get; set;}
    }
    
    @RemoteAction
    public static List<Sample_Line_Item__c> getAllSampleLineItems(String hashCode){
        try{
            if(!String.isBlank(hashCode)){
                List<Sample_Line_Item__c> listOfAllSLI = [SELECT Id,Name,Product__c,Product__r.Name,Quantity_Unit__c,Quantity__c,Packaging_Unit__c,
                                                          Packaging_Quantity__c,Contact__c,Contact__r.Login_Hash_Code__c,Contact__r.Name,Contact__r.Email,Contact__r.FirstName,Contact__r.LastName,Contact__r.MobilePhone FROM Sample_Line_Item__c WHERE Contact__r.Login_Hash_Code__c =: hashCode];
                if(!listOfAllSLI.isEmpty()){
                    return listOfAllSLI;
                }else{
                    return null;
                }
            }
            return null;
        }catch(Exception e){
            system.debug('Error ===> '+e.getMessage()+e.getLineNumber());
            return null;
        }
    }
    
    @RemoteAction
    public static List<Map<String, Object>> getDetailrecordOfSLI(String SLIid){
        try{
            List<Map<String, Object>> accountFields = new List<Map<String, Object>>();
            Sample_Line_Item__c acc = [SELECT Name,Actual_date_of_dispatch__c,Additional_Comments__c,Contact__c,Courier__c,Current_Shelf_Life__c,
                                       Customer_Instructions__c,Customer_Name__c,Customer_Target_price__c,Dispatch_Details__c,Distributer_Customer__c,Exclusive_customer_product_code__c,
                                       Expected_Shelf_Life__c,First_Sample_Due_Date__c,Formula_Packaging_Qty__c,Line_Item_Name__c,OPTIVA_Recipe__c,OwnerEmail__c,
                                       Packaging_Quantity__c,Packaging_Unit__c,Product__c,Product_Code__c,Product_Family__c,Product_Max_Qty__c,Product_Name__c,Project_Quotient__c,
                                       Qty_in_KGs__c,Quantity__c,Quantity_Unit__c,Reason_For_Rejection__c,Regulatory_Requirements__c,Sample__c,CreatedById,LastModifiedDate,
                                       Sample_delivery_date__c,Sample_Invoice_Date__c,Sample_Request_Status__c,Sample_Submitted_Date__c,OwnerId,Isdeleted,CreatedDate,LastModifiedById,
                                       Sample_Type__c,SLI_Dispatched__c,Start_Date__c,Submitted__c,Way_Bill_No__c,SystemModstamp,LastActivityDate,LastViewedDate,LastReferencedDate
                                       FROM Sample_Line_Item__c WHERE Id = :SLIid LIMIT 1];
            system.debug('acc =====> '+acc);
            
            // Get the Schema information for the Account object
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Sample_Line_Item__c.fields.getMap();
            system.debug('fieldMap ====> '+fieldMap);
            for (String fieldName : fieldMap.keySet()) {
                Object fieldValue = acc.get(fieldName);
                Map<String, Object> fieldData = new Map<String, Object>();
                if (fieldMap.containsKey(fieldName)) {
                    Schema.SObjectField field = fieldMap.get(fieldName);
                    String fieldLabel = field.getDescribe().getLabel();
                    System.debug('Field Label: ' + fieldLabel);
                    fieldData.put('fieldLabel', fieldLabel);
                }
                fieldData.put('fieldValue', fieldValue);
                system.debug('fieldData =====> '+fieldData);
                accountFields.add(fieldData);
            }
            system.debug('accountFields ====> '+accountFields);
            
            return accountFields;
        }catch(Exception e){
            return null;
        }
    }
    
    @RemoteAction
    public static String LogoutApplicant(String loginHasgCode){
        try{
            
            contact conRec = [SELECT Name,Id FROM Contact where Login_Hash_Code__c =:loginHasgCode limit 1];
            conRec.Login_Hash_Code__c=null;
            update conRec;
            return 'success';
        }
        catch(Exception e){
            system.debug('The Error :: '+e.getMessage()+' AND Line No :: '+e.getLineNumber()+'');
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static string savePDF(String url,String id,String fileName){
        System.debug('url==> ' + url);
        System.debug('id==> ' + id);
        List<Attachment> attachmentList = new List<Attachment>();
        System.debug('fileName==> ' + fileName);
        try {
            //  string  disReqId = id;
            //   PageReference ref =page.SymegaStickerPDF;
            
            PageReference pageRef;
            if(fileName == 'Label'){// //Sample Invoice
                system.debug('Label-->');
                pageRef = page.SymegaStickerPDF;
                if(!String.isBlank(id)){
                    List<Sample_Line_Item__c> listOfReleasedSLIs = [SELECT Id,Name,Release_Status__c, Released_Dispatched__c,Released_Dispatched_Non_Hazardous__c From Sample_Line_Item__c WHERE Release_Status__c = 'Released' AND Sample__c =: id limit 2000];
                    if(!listOfReleasedSLIs.isEmpty()){
                        for(Sample_Line_Item__c SLI : listOfReleasedSLIs){
                            SLI.Released_Dispatched__c = true;
                        }
                        update listOfReleasedSLIs;
                        system.debug('listOfReleasedSLIs---->'+listOfReleasedSLIs);
                    }
                }
            }else if(fileName == 'Non-Hazardous'){
                pageRef = page.NonHarzardousDHLPDF;
                  system.debug('NonHarzardousDHLPDF-->');
                if(!String.isBlank(id)){
                    List<Sample_Line_Item__c> listOfReleasedSLIs = [SELECT Id,Name,Release_Status__c, Released_Dispatched__c,Released_Dispatched_Non_Hazardous__c From Sample_Line_Item__c WHERE Release_Status__c = 'Released' AND Sample__c =: id limit 2000];
                    if(!listOfReleasedSLIs.isEmpty()){
                        for(Sample_Line_Item__c SLI : listOfReleasedSLIs){
                            SLI.Released_Dispatched_Non_Hazardous__c = true;
                        }
                        update listOfReleasedSLIs;
                          system.debug('listOfReleasedSLIs---->'+listOfReleasedSLIs);
                    }
                }
            }
            pageRef.getParameters().put('id',id);
            blob vBody;
            if(Test.isRunningTest()){
                vBody = blob.valueOf('Unit.Test');
            }else{
                vBody = pageRef.getContent();
            }
            
            Attachment attach = new Attachment();
            attach.Body = vBody;
            attach.Name = fileName+'_.pdf';
            attach.ParentId = id;
            attach.ContentType = 'application/pdf';
            attachmentList.add(attach);
            
            insert attachmentList;
            system.debug('attachmentList---->'+attachmentList);  
            if(attachmentList.size()>0){
                return 'Success'; 
            }
        } 
        catch (Exception e) {
            System.debug('(e.getMessage());==>' + (e.getMessage()) + 'at line number ' + e.getLineNumber());
            // throw new AuraHandledException(e.getMessage());
        }
        return null;
    }
    
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        system.debug('contentVersionId ====> '+contentVersionId);
        system.debug('recordId =====> '+recordId);
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id,ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        insert cdl;
        return cdl;
    }
    
    @RemoteAction
    public static string updateProfile(Contact ConDetails){
        System.debug('ConDetails ==> ' + ConDetails);
        try{
            update ConDetails;
            System.debug('ConDetails ==> ' + ConDetails);
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static String resetpassword(String emailId){
        try{
            List<Contact> conList = [SELECT FirstName,LastName,Name,Email,Password__c,Login_Hash_Code__c FROM Contact WHERE Email =: emailId LIMIT 1];
            if(conList.size()>0){
                
                EmailTemplate temp = [SELECT Id,Name,HTMLValue,Subject, Body FROM EmailTemplate WHERE Name =: 'Forgot Password'];
                List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
                Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                mail.setToAddresses(new String[] {conList[0].Email});
                mail.setSubject(temp.Subject);//Set Subject
                string emailHtmlValue = temp.HtmlValue;
                
                if(!string.isBlank(conList[0].Name))
                    emailHtmlValue = emailHtmlValue.replace('{!Contact.Name}', conList[0].Name);
                //if(!string.isBlank(conList[0].LastName))
                //emailHtmlValue = emailHtmlValue.replace('{!Contact.LastName}', conList[0].LastName);
                if(!string.isBlank(conList[0].Email))
                    emailHtmlValue = emailHtmlValue.replace('{!Contact.Email}', conList[0].Email);
                if(!string.isBlank(conList[0].Login_Hash_Code__c))
                    emailHtmlValue = emailHtmlValue.replace('{!Contact.Login_Hash_Code__c}', conList[0].Login_Hash_Code__c);
                
                mail.setHtmlBody(emailHtmlValue);//Set HTML Body
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static String resetpassApplication(String password, String loginhashcode){
        try{
            Contact conToUpdate = [SELECT Name,Email, Password__c, Login_Hash_Code__c FROM Contact WHERE Login_Hash_Code__c =: loginhashcode LIMIT 1];
            conToUpdate.Password__c = password;
            conToUpdate.Login_Hash_Code__c = Utility.generateRandomString();
            update conToUpdate;
            return 'SUCCESS';
        }catch(Exception e){
            System.debug('The Error---->'+e.getMessage());
            System.debug('The Error Line---->'+e.getLineNumber());
        }
        return 'error';
    }
    
    @RemoteAction
    public static string updateSLIRecord(Sample_Line_Item__c SLIRecord, Integer dispatchYear, Integer dispatchmonth, Integer dispatchday, Integer invoiceYear, Integer invoicemonth, Integer invoiceday){
        try{
            //system.debug('comment ====> '+comment);
            if(dispatchYear == 0 && dispatchmonth==0 && dispatchday==0){
                
            }else{
                SLIRecord.Actual_date_of_dispatch__c = Date.newInstance(dispatchYear, dispatchmonth, dispatchday); 
            }
            if(invoiceYear == 0 && invoicemonth==0 && invoiceday==0){
                
            }else{
                SLIRecord.Sample_Invoice_Date__c = Date.newInstance(invoiceYear, invoicemonth, invoiceday); 
            }
            update SLIRecord;
            //insert comment;
            return 'Success';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static string updateSLIList(List<Sample_Line_Item__c> SLIList){
        try{
            System.debug('Inside Update SLI List Method');
            system.debug('SLIList ===> '+SLIList);
            set<Id> setOfSampleId = New set<Id>();
            if(!SLIList.isEmpty()){
                for(Sample_Line_Item__c sli : SLIList){
                    system.debug('sli.ActualDateOfDispatch ====> ' +sli.Actual_date_of_dispatch__c);
                    if(sli.Release_Status__c == 'Released'){
                        sli.Release_Date_Time__c = System.now();
                        setOfSampleId.add(sli.Sample__c);
                    }
                    system.debug('setOfSampleId ===> '+setOfSampleId);
                    if(sli.Actual_date_of_dispatch__c != null){
                        Date parsedDate = Date.valueOf(sli.Actual_date_of_dispatch__c);
                        sli.Actual_date_of_dispatch__c = parsedDate;
                    }
                    if(sli.Sample_Invoice_Date__c != null){
                        Date parsedDate = Date.valueOf(sli.Sample_Invoice_Date__c);
                        sli.Sample_Invoice_Date__c = parsedDate;
                    }
                }
                List<Project__c> listOfSamples = [SELECT Id, Release_Date_Time__c FROM Project__c WHERE Id IN : setOfSampleId limit 2000];
                system.debug('listOfSamples ====> '+listOfSamples);
                if(!listOfSamples.isEmpty()){
                    for(Project__c samplerec : listOfSamples){
                        samplerec.Release_Date_Time__c = System.now();
                    }
                    update listOfSamples;
                }
            }
            update SLIList;
            //insert comment;
            return 'Success';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static List<Sample_Line_Item__c> searchOLI(string serachKey, string hashCode, List<Sample_Line_Item__c> listOfSLIist){
        try{
            system.debug('serachKey ====> '+serachKey);
            system.debug('hashCode ====> '+hashCode);
            set<Id> setOfSLIId = New set<Id>();
            if(!listOfSLIist.isEmpty()){
                for(Sample_Line_Item__c sli : listOfSLIist)
                    setOfSLIId.add(sli.Id);
            }
            List<Sample_Line_Item__c> listOfSLI = [SELECT Id,Name,Sample__c,Sample__r.Name,Sample_Type__c,Customer_Name__c,SLI_Dispatched__c,Release_Date_Time__c,Sample_Request_Status__c,Product__r.Name,Product_Family__c,Contact__c,Contact__r.Login_Hash_Code__c,Account_Id__c,Product_Code__c,Actual_date_of_dispatch__c,Product_Name__c FROM Sample_Line_Item__c WHERE (Product_Name__c LIKE :('%' + serachKey + '%') OR Customer_Name__c LIKE :('%' + serachKey + '%')) AND Id IN : setOfSLIId limit 2000];
            system.debug('listOfSLI ====> '+listOfSLI);
            return listOfSLI;
        }catch(Exception e){
            return null;
        }
    }
    
    @RemoteAction
    public static List<Project__c> searchSample(string serachKey, List<Project__c> listOfSamp){
        try{
            Set<Id> setOfSampleIds = New Set<Id>();
            if(!listOfSamp.isEmpty()){
                for(Project__c samp : listOfSamp){
                    setOfSampleIds.add(samp.Id);
                }
            }
            List<Project__c> listOfSample = [SELECT Id,Name,Sample_Name__c,Record_Type_Name__c,Shipping_Type__c,Status__c,Product_Family__c,Sample_Requested_by__c,Account__r.Name,Account__c FROM Project__c WHERE (Sample_Name__c LIKE :('%' + serachKey + '%') OR Customer_Name__c LIKE :('%' + serachKey + '%') OR Name LIKE :('%' + serachKey + '%')) AND Id IN : setOfSampleIds limit 2000];
            return listOfSample;
        }catch(Exception e){
            return null;
        }
    }
    
    @RemoteAction
    public static List<Opportunity> searchOpportunity(string serachKey, List<Opportunity> listOfOpp){
        try{
            system.debug('serachKey ====> '+serachKey);
            system.debug('listOfOpp size ====> '+listOfOpp.size());
            Set<Id> setOfOppIds = New Set<Id>();
            if(!listOfOpp.isEmpty()){
                for(Opportunity opp : listOfOpp){
                    setOfOppIds.add(opp.Id);
                }
            }
            system.debug('setOfOppIds ====> '+setOfOppIds);
            system.debug('setOfOppIds Size ====> '+setOfOppIds.size());
            List<Opportunity> listOfOpportunity = [SELECT Id,Name,Account.Name,Amount,CloseDate,AccountId,StageName,Probability,Type,RecordType.Name FROM Opportunity WHERE Name LIKE :('%' + serachKey + '%') AND Id IN : setOfOppIds limit 2000];
            system.debug('listOfOpportunity ====> '+listOfOpportunity);
            return listOfOpportunity;
        }catch(Exception e){
            return null;
        }
    }
    
    @RemoteAction
    public static List<OpportunityLineItem> searchOppProds(string serachKey, List<OpportunityLineItem> listOfOLI){
        try{
            Set<Id> setOfOLIIds = New Set<Id>();
            if(!listOfOLI.isEmpty()){
                for(OpportunityLineItem oli : listOfOLI){
                    setOfOLIIds.add(oli.Id);
                }
            }
            List<OpportunityLineItem> listOfOppProducts = [SELECT Id,Name,OpportunityId,Product2Id,Product2.Name,Quantity,ListPrice,UnitPrice,TotalPrice,Price_In_KG__c,Quantity_In_KG__c FROM OpportunityLineItem WHERE Name LIKE :('%' + serachKey + '%') AND Id IN : setOfOLIIds limit 2000];
            return listOfOppProducts;
        }catch(Exception e){
            return null;
        }
    }
    
    @RemoteAction
    public static List<Account> searchAccount(string serachKey, List<Account> listOfAcc){
        try{
            Set<Id> setOfAccIds = New Set<Id>();
            if(!listOfAcc.isEmpty()){
                for(Account acc : listOfAcc){
                    setOfAccIds.add(acc.Id);
                }
            }
            List<Account> listOfAccount = [SELECT Id,Name,Email__c,Phone,RecordType.Name,Customer_Number__c,CreatedDate,Account_Segment__c,Customer_Code_SAP__c FROM Account WHERE (Name LIKE :('%' + serachKey + '%') OR Customer_Code_SAP__c LIKE :('%' + serachKey + '%') OR Account_Segment__c LIKE :('%' + serachKey + '%'))  AND Id IN : setOfAccIds limit 2000];
            return listOfAccount;
        }catch(Exception e){
            return null;
        }
    }
    
    @RemoteAction // newly created on 10-06-24
    public static String generateInvoice(List<Id> listOfSampleIds){
        system.debug('listOfSampleIds-->'+listOfSampleIds);
        try {
            String resultMSG;
            String PDFName;
            system.debug('listOfSampleIds =====> ' + listOfSampleIds);
            List<Project__c> listOfSamples = [SELECT Id, Name, Shipping_Type__c FROM Project__c WHERE Id IN : listOfSampleIds];
            
            if (!listOfSamples.isEmpty()) {
                Set<Id> sampleIds = new Set<Id>();
                for (Project__c proj : listOfSamples) {
                    sampleIds.add(proj.Id);
                }
                
                List<Sample_Line_Item__c> SLIList = [SELECT Id, Name, Sample_Invoice_Date__c FROM Sample_Line_Item__c WHERE Sample__c IN : sampleIds];
                System.debug('SLIList ==> ' + SLIList);
                
                List<Attachment> attachmentList = new List<Attachment>();
                
                if (listOfSamples[0].Shipping_Type__c == 'Domestic') {
                    PDFName = 'SampleInvoiceDomesticPDF';
                } else {
                    PDFName = 'SampleInvoicePDF';
                }
                
                for (Project__c parent : listOfSamples) {
                    PageReference ref;
                    if (parent.Shipping_Type__c == 'Export') {
                        ref = Page.SampleInvoicePDF;
                    } else {
                        ref = Page.SampleInvoiceDomesticPDF;
                    }
                    
                    ref.getParameters().put('id', parent.Id);
                    system.debug('ref -- ' + ref);
                    system.debug('ref.getParameters() -- ' + ref.getParameters());
                    
                    Attachment attachment = new Attachment();
                    attachment.ParentId = parent.Id;
                    string shippingType = parent.Shipping_Type__c;
                    if (shippingType == null || shippingType == '') { 
                        shippingType = 'Domestic';                
                        
                    } else {
                        shippingType = parent.Shipping_Type__c;
                    }
                    attachment.Name = shippingType + 'Invoice' + '.pdf'; // listOfSamples[0].Shipping_Type__c + 'Invoice' + '.pdf';
                    attachment.Body = ref.getContentAsPDF();
                    attachment.ContentType = 'application/pdf';
                    attachmentList.add(attachment);
                }
                
                insert attachmentList;
                System.debug('attachmentList -- ' + attachmentList);
                
                for (Sample_Line_Item__c sliRec : SLIList) {
                    sliRec.Sample_Invoice_Date__c = System.today();
                }
                update SLIList;
            }
            
            resultMSG = 'success';
            return resultMSG;
        } catch (Exception e) {
            return e.getMessage() + ' at line ' + e.getLineNumber();
        }
    }
    
    
    
    /*   @RemoteAction commented on 10-6-24
public static String generateInvoice(List<Id> listOfSampleIds){
try{
// List<Id>
string resultMSG;
String PDFName;
system.debug('listOfSampleIds =====> '+listOfSampleIds);
List<Project__c> listOfSamples = [SELECT Id,Name,Shipping_Type__c FROM Project__c WHERE Id IN : listOfSampleIds];
if(!listOfSamples.isEmpty()){
set<Id> sampleIds = new set<Id>();
for(Project__c proj : listOfSamples ){
sampleIds.add(proj.Id);
}
List<Sample_Line_Item__c> SLIList = [SELECT Id, Name, Sample_Invoice_Date__c FROM Sample_Line_Item__c WHERE Sample__c IN: sampleIds];
System.debug('SLIList ==> ' + SLIList);
List<ContentVersion> fileDataList = new List<ContentVersion>();
List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
if(listOfSamples[0].Shipping_Type__c == 'Domestic'){
PDFName = 'SampleInvoiceDomesticPDF';
}else{
PDFName = 'SampleInvoicePDF'; 
}

for (Project__c parent : listOfSamples) {
PageReference ref;
if(parent.Shipping_Type__c == 'Export'){
ref = Page.SampleInvoicePDF;
}else{
ref = Page.SampleInvoiceDomesticPDF; 
}
//PageReference ref = Page.SampleInvoiceDomesticPDF;
ref.getParameters().put('id', parent.Id);
system.debug('ref -- ' + ref);
system.debug('ref.getParameters() -- ' + ref.getParameters());
ContentVersion fileData = new ContentVersion();
fileData.Title = listOfSamples[0].Shipping_Type__c+'Invoice';
fileData.VersionData = ref.getContentAsPdf();
fileData.PathOnClient = listOfSamples[0].Shipping_Type__c+'Invoice' + '.pdf'; // Set the file path
fileData.FirstPublishLocationId = parent.Id;
fileDataList.add(fileData);
}
insert fileDataList;
system.debug('fileDataList -- ' + fileDataList);

set<Id> cvIdSet = new set<Id>();
for (ContentVersion fileData : fileDataList) {
cvIdSet.add(fileData.Id);
insert new ContentDistribution(
Name = fileData.Title,
ContentVersionId = fileData.Id,
PreferencesAllowViewInBrowser= true

);
}
system.debug('cvIdSet -- ' + cvIdSet);

List<ContentVersion> cvList = [SELECT Id, ContentDocumentId, FirstPublishLocationId FROM ContentVersion WHERE Id IN: cvIdSet];
// Get the ContentDocumentIds after the insert operation
Map<Id, Id> parentIdToContentDocumentIdMap = new Map<Id, Id>();
for (ContentVersion fileData : cvList) {
parentIdToContentDocumentIdMap.put(fileData.FirstPublishLocationId, fileData.ContentDocumentId);
}
system.debug('parentIdToContentDocumentIdMap -- ' + parentIdToContentDocumentIdMap);

// Create ContentDocumentLink records using the ContentDocumentIds
List<ContentDocumentLink> existingContentDocumentLinks = [
SELECT Id, ContentDocumentId, LinkedEntityId
FROM ContentDocumentLink
WHERE ContentDocumentId IN :parentIdToContentDocumentIdMap.values()
AND LinkedEntityId IN :sampleIds
];

Set<String> uniqueContentDocumentLinks = new Set<String>();
for (ContentDocumentLink existingLink : existingContentDocumentLinks) {
String uniqueKey = existingLink.ContentDocumentId + '_' + existingLink.LinkedEntityId;
uniqueContentDocumentLinks.add(uniqueKey);
}

// Create ContentDocumentLink records using the ContentDocumentIds
for (Project__c parent : listOfSamples) {
if(parentIdToContentDocumentIdMap.containsKey(parent.Id)){
String contentDocumentId = parentIdToContentDocumentIdMap.get(parent.Id);
System.debug('contentDocumentId==> ' + contentDocumentId);
String uniqueKey = contentDocumentId + '_' + parent.Id;

if (!uniqueContentDocumentLinks.contains(uniqueKey)) {
contentDocumentLinks.add(new ContentDocumentLink(
ContentDocumentId = contentDocumentId,
LinkedEntityId = parent.Id,
ShareType = 'V' // 'V' represents sharing the file with the record and its related users
));
uniqueContentDocumentLinks.add(uniqueKey);
}
}
}

Database.upsert(contentDocumentLinks, false); // Upsert ContentDocumentLink records
System.debug('contentDocumentLinks==> ' + contentDocumentLinks);
for(Sample_Line_Item__c sliRec : SLIList){
sliRec.Sample_Invoice_Date__c = System.today();
}
update SLIList;
}
//  return sampleIds;
resultMSG = 'success';
return resultMSG;
}catch(Exception e){
return e.getMessage()+e.getLineNumber(); 
}
}
*/
    
    // commented by GC
    // @RemoteAction
    // public static string generateInvoice(List<Id> listOfSampleIds){
    //     try{
    //         String PDFName;
    //         listOfSampleIds.add('a0DIo000000PJJpMAO');
    //         system.debug('listOfSampleIds =====> '+listOfSampleIds);
    //         if(!listOfSampleIds.isEmpty()){
    //             List<Project__c> listOfSamples = [SELECT Id,Name,Shipping_Type__c FROM Project__c WHERE Id IN : listOfSampleIds];
    //             List<Sample_Line_Item__c> SLIList = [SELECT Id, Name, Sample_Invoice_Date__c FROM Sample_Line_Item__c WHERE Sample__c IN: listOfSampleIds];
    //             System.debug('SLIList ==> ' + SLIList);
    //             List<ContentVersion> fileDataList = new List<ContentVersion>();
    //         	List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
    //             if(listOfSamples[0].Shipping_Type__c == 'Domestic'){
    //                 PDFName = 'SampleInvoiceDomesticPDF';
    //             }else{
    //                PDFName = 'SampleInvoicePDF'; 
    //             }
    
    //             for (Id parentId : listOfSampleIds) {
    //                 PageReference ref;
    //                 if(PDFName == 'SampleInvoiceDomesticPDF'){
    //                     ref = Page.SampleInvoiceDomesticPDF;
    //                 }else{
    //                    ref = Page.SampleInvoicePDF; 
    //                 }
    //                 //PageReference ref = Page.SampleInvoiceDomesticPDF;
    //                 ref.getParameters().put('id', parentId);
    //                 system.debug('ref -- ' + ref);
    //                 system.debug('ref.getParameters() -- ' + ref.getParameters());
    //                 ContentVersion fileData = new ContentVersion();
    //                 fileData.Title = listOfSamples[0].Shipping_Type__c+'Invoice';
    //                 fileData.VersionData = ref.getContentAsPdf();
    //                 fileData.PathOnClient = listOfSamples[0].Shipping_Type__c+'Invoice' + '.pdf'; // Set the file path
    //                 fileData.FirstPublishLocationId = parentId;
    //                 fileDataList.add(fileData);
    //         	}
    //             insert fileDataList;
    //         	system.debug('fileDataList -- ' + fileDataList);
    
    //             set<Id> cvIdSet = new set<Id>();
    //         for (ContentVersion fileData : fileDataList) {
    //             cvIdSet.add(fileData.Id);
    //             insert new ContentDistribution(
    //                 Name = fileData.Title,
    //                 ContentVersionId = fileData.Id,
    //                 PreferencesAllowViewInBrowser= true
    
    //             );
    //         }
    //         system.debug('cvIdSet -- ' + cvIdSet);
    
    //         List<ContentVersion> cvList = [SELECT Id, ContentDocumentId, FirstPublishLocationId FROM ContentVersion WHERE Id IN: cvIdSet];
    //         // Get the ContentDocumentIds after the insert operation
    //         Map<Id, Id> parentIdToContentDocumentIdMap = new Map<Id, Id>();
    //         for (ContentVersion fileData : cvList) {
    //             parentIdToContentDocumentIdMap.put(fileData.FirstPublishLocationId, fileData.ContentDocumentId);
    //         }
    //         system.debug('parentIdToContentDocumentIdMap -- ' + parentIdToContentDocumentIdMap);
    
    //         // Create ContentDocumentLink records using the ContentDocumentIds
    //         List<ContentDocumentLink> existingContentDocumentLinks = [
    //             SELECT Id, ContentDocumentId, LinkedEntityId
    //             FROM ContentDocumentLink
    //             WHERE ContentDocumentId IN :parentIdToContentDocumentIdMap.values()
    //             AND LinkedEntityId IN :listOfSampleIds
    //         ];
    
    //         Set<String> uniqueContentDocumentLinks = new Set<String>();
    //         for (ContentDocumentLink existingLink : existingContentDocumentLinks) {
    //             String uniqueKey = existingLink.ContentDocumentId + '_' + existingLink.LinkedEntityId;
    //             uniqueContentDocumentLinks.add(uniqueKey);
    //         }
    
    //         // Create ContentDocumentLink records using the ContentDocumentIds
    //         for (Id parentId : listOfSampleIds) {
    //             String contentDocumentId = parentIdToContentDocumentIdMap.get(parentId);
    //             System.debug('contentDocumentId==> ' + contentDocumentId);
    //             String uniqueKey = contentDocumentId + '_' + parentId;
    
    //             if (!uniqueContentDocumentLinks.contains(uniqueKey)) {
    //                 contentDocumentLinks.add(new ContentDocumentLink(
    //                     ContentDocumentId = contentDocumentId,
    //                     LinkedEntityId = parentId,
    //                     ShareType = 'V' // 'V' represents sharing the file with the record and its related users
    //                 ));
    //                 uniqueContentDocumentLinks.add(uniqueKey);
    //             }
    //         }
    
    //         Database.upsert(contentDocumentLinks, false); // Upsert ContentDocumentLink records
    //             System.debug('contentDocumentLinks==> ' + contentDocumentLinks);
    //             for(Sample_Line_Item__c sliRec : SLIList){
    //                 sliRec.Sample_Invoice_Date__c = System.today();
    //             }
    //             update SLIList;
    //         }
    //         return listOfSampleIds[0];
    //     }catch(Exception e){
    //        return e.getMessage()+e.getLineNumber(); 
    //     }
    // }
    
    // Method to display Invoice PDF Preview upon successful generation
    // Author -: Vaibhav Kumar Chauhan
    // Organisation -: Utilitarian Labs Pvt. Ltd.
    // Date of Creation -: 15-Nov-2023
    // Last Updated on-: 15-Nov-2023
    
    @RemoteAction
    public static List<ContentDistribution> getGeneratedInvoice(String recordId){
        try{
            if(recordId != null && recordId != ''){
                List<ContentDocumentLink> files = [SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.Title, ContentDocument.CreatedDate FROM ContentDocumentLink WHERE LinkedEntityId = :recordId ORDER BY ContentDocument.CreatedDate DESC LIMIT 1];
                System.debug('files[0].ContentDocumentId ==> ' + files[0].ContentDocumentId);
                List<ContentDistribution> contDist = [SELECT Id, ContentDownloadUrl, ContentVersionId, DistributionPublicUrl FROM ContentDistribution WHERE ContentDocumentId =:files[0].ContentDocumentId LIMIT 1];
                System.debug('contDist ==> ' + contDist);
                return contDist;
            }else{
                return null;
            }
        }catch(exception e){
            System.debug(e.getMessage()+e.getLineNumber()); 
            return null;
        }
    }
    
    /*@RemoteAction
public static List<ContentDistribution> getGeneratedInvoice(List<Id> recordIds){
try{
if(!recordIds.isEmpty()){
List<ContentDocumentLink> files = [SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.Title, ContentDocument.CreatedDate FROM ContentDocumentLink WHERE LinkedEntityId IN: recordIds ORDER BY ContentDocument.CreatedDate DESC LIMIT 1];
System.debug('files[0].ContentDocumentId ==> ' + files[0].ContentDocumentId);
List<ContentDistribution> contDist = [SELECT Id, ContentDownloadUrl, ContentVersionId, DistributionPublicUrl FROM ContentDistribution WHERE ContentDocumentId =:files[0].ContentDocumentId LIMIT 1];
System.debug('contDist ==> ' + contDist);
return contDist;
}else{
return null;
}
}catch(exception e){
System.debug(e.getMessage()+e.getLineNumber()); 
return null;
}
} */
    
    // Method to get all the Files attached under Account (Customer Tab)
    // Author -: Vaibhav Kumar Chauhan
    // Organisation -: Utilitarian Labs Pvt. Ltd.
    // Date of Creation -: 15-Nov-2023
    // Last Updated on-: 15-Nov-2023
    
    @RemoteAction
    public static List<ContentDistribution> getAccRelatedFiles(String recordId){
        try{
            if(recordId != null && recordId != ''){
                Set<Id> contentDocumentIdSet = new Set<Id>();
                List<ContentDocumentLink> files = [SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.Title, ContentDocument.CreatedDate FROM ContentDocumentLink WHERE LinkedEntityId = :recordId ORDER BY ContentDocument.CreatedDate DESC];
                if(!files.isEmpty()){
                    for(ContentDocumentLink conDocLinkRec : files){
                        contentDocumentIdSet.add(conDocLinkRec.ContentDocumentId);
                    }
                    System.debug('contentDocumentIdSet ==> ' + contentDocumentIdSet);
                }
                List<ContentDistribution> contDist = [SELECT Id,Name, ContentDownloadUrl, ContentVersionId, DistributionPublicUrl FROM ContentDistribution WHERE ContentDocumentId IN:contentDocumentIdSet];
                System.debug('contDist ==> ' + contDist);
                return contDist;
            }else{
                return null;
            }
        }catch(exception e){
            System.debug(e.getMessage()+e.getLineNumber()); 
            return null;
        }
    } 
    
    // Method to save Invoice PDF under the account on saving from preview popup
    // Author -: Vaibhav Kumar Chauhan
    // Organisation -: Utilitarian Labs Pvt. Ltd.
    // Date of Creation -: 15-Nov-2023
    // Last Updated on-: 15-Nov-2023
    
    @RemoteAction
    public static String saveInvoiceUnderAccount(String recordId, String contentVersionId){
        try{
            String PDFName;
            if(recordId != null && recordId != ''){
                Project__c sampleRec = [SELECT Id,Name,Shipping_Type__c,Account__c,Opportunity__r.AccountId FROM Project__c WHERE Id =: recordId];
                String accId = sampleRec.Opportunity__r.AccountId;
                List<ContentVersion> fileDataList = new List<ContentVersion>();
                List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
                List<ContentDistribution> ContentDistributionList = new List<ContentDistribution>();
                if(sampleRec.Shipping_Type__c == 'Domestic'){
                    PDFName = 'SampleInvoiceDomesticPDF';
                }else{
                    PDFName = 'SampleInvoicePDF'; 
                }
                PageReference ref;
                if(PDFName == 'SampleInvoiceDomesticPDF'){
                    ref = Page.SampleInvoiceDomesticPDF;
                }else{
                    ref = Page.SampleInvoicePDF; 
                }
                ref.getParameters().put('id', accId);
                system.debug('ref -- ' + ref);
                system.debug('ref.getParameters() -- ' + ref.getParameters());
                ContentVersion fileData = new ContentVersion();
                fileData.Title = sampleRec.Shipping_Type__c+'Invoice';
                fileData.PathOnClient = sampleRec.Shipping_Type__c+'Invoice' + '.pdf'; // Set the file path
                if(sampleRec.Shipping_Type__c == null){
                    fileData.Title = 'Invoice';
                    fileData.PathOnClient ='Invoice' + '.pdf'; // Set the file path
                }
                fileData.VersionData = ref.getContentAsPdf();
                fileData.FirstPublishLocationId = accId;
                fileDataList.add(fileData);
                
                insert fileDataList;
                System.debug('fileDataList==> ' + fileDataList);
                for(ContentVersion cv : fileDataList){
                    ContentDistribution cd = new ContentDistribution();
                    cd.Name = cv.Title;
                    cd.ContentVersionId = cv.Id;
                    cd.PreferencesAllowOriginalDownload = true; // Allow download of the original file
                    cd.PreferencesAllowViewInBrowser = true; // Allow viewing in the browser
                    ContentDistributionList.add(cd);
                }
                insert ContentDistributionList;
                if(!String.isBlank(recordId)){
                    List<Sample_Line_Item__c> listOfReleasedSLIs = [SELECT Id,Name,Release_Status__c, Released_Dispatched__c,Released_Dispatched_Non_Hazardous__c From Sample_Line_Item__c WHERE Release_Status__c = 'Released' AND Sample__c =: recordId  limit 2000];
                    if(!listOfReleasedSLIs.isEmpty()){
                        for(Sample_Line_Item__c SLI : listOfReleasedSLIs){
                            SLI.Released_Invoice__c = true;
                        }
                        update listOfReleasedSLIs;
                    }
                }
                return 'SUCCESS';
            }else{
                return 'ERROR';
            }
        }catch(exception e){
            System.debug(e.getMessage()+e.getLineNumber()); 
            return e.getMessage()+e.getLineNumber();
        }
    } 
    
    // Method to display File upon clicking view on Customer Detail Page
    // Author -: Vaibhav Kumar Chauhan
    // Organisation -: Utilitarian Labs Pvt. Ltd.
    // Date of Creation -: 15-Nov-2023
    // Last Updated on-: 15-Nov-2023
    
    @RemoteAction
    public static List<ContentDistribution> getFileRecordUnderAccount(String recordId){
        try{
            if(recordId != null && recordId != ''){
                //List<ContentDocumentLink> files = [SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.Title, ContentDocument.CreatedDate FROM ContentDocumentLink WHERE LinkedEntityId = :recordId ORDER BY ContentDocument.CreatedDate DESC LIMIT 1];
                //System.debug('files[0].ContentDocumentId ==> ' + files[0].ContentDocumentId);
                List<ContentDistribution> contDist = [SELECT Id, ContentDownloadUrl, ContentVersionId, DistributionPublicUrl FROM ContentDistribution WHERE Id =:recordId LIMIT 1];
                System.debug('contDist ==> ' + contDist);
                return contDist;
            }else{
                return null;
            }
        }catch(exception e){
            System.debug(e.getMessage()+e.getLineNumber()); 
            return null;
        }
    }
    
    @RemoteAction
    public static string saveComment(Comment__c com, String hashCode, string SLIid){
        try{
            List<Contact> conRec = [SELECT Id,Name,Login_Hash_Code__c FROM Contact WHERE Login_Hash_Code__c =: hashCode];
            com.Comment_By__c = conRec[0].Id;
            com.Sample_Line_Item__c = SLIid;
            system.debug('com =====> '+com);
            insert com;
            return com.Id;
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber(); 
        }
    }
    
    @RemoteAction
    public static string saveCommentSample(Comment__c com, String hashCode, string SLIid){
        try{
            List<Contact> conRec = [SELECT Id,Name,Login_Hash_Code__c FROM Contact WHERE Login_Hash_Code__c =: hashCode];
            com.Comment_By__c = conRec[0].Id;
            com.Sample__c = SLIid;
            system.debug('com =====> '+com);
            insert com;
            return com.Id;
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber(); 
        }
    }
    
    @RemoteAction
    public static string saveCommentonOLI(Comment__c com, String hashCode, string SLIid){
        try{
            List<Contact> conRec = [SELECT Id,Name,Login_Hash_Code__c FROM Contact WHERE Login_Hash_Code__c =: hashCode];
            com.Comment_By__c = conRec[0].Id;
            com.Opportunity_Product__c = SLIid;
            system.debug('com =====> '+com);
            insert com;
            return com.Id;
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber(); 
        }
    }
    
    @RemoteAction
    public static string saveComment2(Comment__c com, String hashCode, string accId){
        try{
            List<Contact> conRec = [SELECT Id,Name,Login_Hash_Code__c FROM Contact WHERE Login_Hash_Code__c =: hashCode];
            com.Comment_By__c = conRec[0].Id;
            com.Account__c = accId;
            system.debug('com =====> '+com);
            insert com;
            return com.Id;
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber(); 
        }
    }
    
    @RemoteAction
    public static string saveReply(Comment__c com, String hashCode, string comId){
        try{
            List<Contact> conRec = [SELECT Id,Name,Login_Hash_Code__c FROM Contact WHERE Login_Hash_Code__c =: hashCode];
            com.Comment_By__c = conRec[0].Id;
            com.Comments__c = comId;
            system.debug('com =====> '+com);
            insert com;
            
            Comment__c comRec = [select id,Name,OwnerId,Sample__c,Sample__r.OwnerId FROM Comment__c where Id =:comId];
            
           //Recently Added For Creating Task for Sample
            Task taskRec = new Task();
            taskRec.OwnerId = comRec.Sample__r.OwnerId;
            taskRec.Status = 'Open';
            taskRec.Priority = 'High';
            taskRec.Subject = 'Please Check '+comRec.Name +' Comment';
            insert taskRec;
            
            return com.Id;
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static List<Comment__c> getReplies(string comId){
        try{
            List<Comment__c> comList = [SELECT Id,Name,Comment_By__c,Sample_Line_Item__c,Comment__c,Comments__c, Reply__c,Comment_By__r.Name FROM Comment__c WHERE Comments__c =: comId];
            return comList;
        }
        catch(Exception e){
            System.debug('e.getMessage()+e.getLineNumber() ==> ' + e.getMessage()+e.getLineNumber());
            return null;
        }
    }
    
    @RemoteAction
    public static string saveSLIDetails(List<Sample_Line_Item__c> ListOfSLI, string hashcode, List<Sample_Line_Item__c> ListOfEditedSLI, List<Sample_Line_Item__c> ListOfAddedSLI){
        System.debug('ListOfSLI-->'+ListOfSLI);
        System.debug('hashcode-->'+hashcode);
        System.debug('ListOfEditedSLI-->'+ListOfEditedSLI);
        System.debug('ListOfAddedSLI-->'+ListOfAddedSLI);
        try{
            Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress limit 1 ].Id;
            String ownerEmail = ListOfSLI[0].Sample__r.Owner.Email;
            //String productFamily = ListOfSLI[0].Product_Family__c;
            Sample_Assignment_Team__c sampleAssignmentTeamSPD = [SELECT Id, Name, Team_Type__c FROM Sample_Assignment_Team__c WHERE Team_Type__c = 'SPD' LIMIT 1];
            Sample_Assignment_Team__c sampleAssignmentTeamCPD = [SELECT Id, Name, Team_Type__c FROM Sample_Assignment_Team__c WHERE Team_Type__c = 'CPD' LIMIT 1];
            Sample_Assignment_Team__c sampleAssignmentTeamPLANTBASED = [SELECT Id, Name, Team_Type__c FROM Sample_Assignment_Team__c WHERE Team_Type__c = 'PLANT BASED' LIMIT 1];
            Set<Id> productIds = new Set<Id>();
            Map<Id, String> prodFamilyById = new Map<Id, String>();
            for(Sample_Line_Item__c sliRec : ListOfSLI){
                System.debug('sliRec.Product__c==> ' + sliRec.Product__c);
                productIds.add(sliRec.Product__c);
            }
            
            List<Product2> prodList = [SELECT Id, Name, Family FROM Product2 WHERE Id IN: productIds];
            for(Product2 prodRec : prodList){
                if(!prodFamilyById.containsKey(prodRec.Id)){
                    prodFamilyById.put(prodRec.Id, prodRec.Family);
                }
            }
            
            for(Sample_Line_Item__c sliRec : ListOfSLI){
                if(prodFamilyById.containsKey(sliRec.Product__c)){
                    System.debug('prodFamilyById.get(sliRec.Product__c)==> ' + prodFamilyById.get(sliRec.Product__c));
                    if(prodFamilyById.get(sliRec.Product__c) == 'CPD'){
                        sliRec.Sample_Assignment_Team__c = sampleAssignmentTeamCPD.Id;
                    }else if(prodFamilyById.get(sliRec.Product__c)  == 'SPD'){
                        sliRec.Sample_Assignment_Team__c = sampleAssignmentTeamSPD.Id;
                    }else if(prodFamilyById.get(sliRec.Product__c) == 'PLANT BASED'){
                        sliRec.Sample_Assignment_Team__c = sampleAssignmentTeamPLANTBASED.Id;
                    }
                    
                }
                if(sliRec.Sample_Request_Status__c != 'Submitted for Sampling'){
                    sliRec.Sample_Request_Status__c = 'Submitted for Sampling';
                } 
                System.debug('sliRec.Sample_Assignment_Team__c==> ' + sliRec.Sample_Assignment_Team__c);
            }
            /*set<Id> setOfAssignmentTeamId = New set<Id>();
List<Sample_Assignment_Team__c> listOfAssignmentTeam = New List<Sample_Assignment_Team__c>();
Contact conRec = [SELECT Id,Name,Login_Hash_Code__c,(SELECT Id,Name,Sample_Assignment_Team__c FROM Account__r) FROM Contact WHERE Login_Hash_Code__c =: hashcode LIMIT 1];
system.debug('Sample Allocation Teams ====> '+conRec.Account__r);
if(!conRec.Account__r.isEmpty()){
for(Sample_Allocation_Team__c SAT : conRec.Account__r){
setOfAssignmentTeamId.add(SAT.Sample_Assignment_Team__c);
}
}
system.debug('setOfAssignmentTeamId ===> '+setOfAssignmentTeamId);
if(!setOfAssignmentTeamId.isEmpty()){
listOfAssignmentTeam = [SELECT Id,Name,Team_Type__c FROM Sample_Assignment_Team__c WHERE Id IN : setOfAssignmentTeamId];
}
system.debug('listOfAssignmentTeam ====> '+listOfAssignmentTeam);*/
            if(!ListOfEditedSLI.isEmpty()){
                System.debug('Inside Send Email for Edited SLIs');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> listOfEmailIds = new List<String>();
                mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                listOfEmailIds.add(ownerEmail);
                //listOfEmailIds.add('vaibhav.chauhan@utilitarianlabs.com');
                System.debug('listOfEmailIds==> ' + listOfEmailIds);
                mail.setToAddresses(listOfEmailIds);
                //mail.setReplyTo('no-reply@symegafood.com');
                //mail.setSenderDisplayName('Symega Foods');
                mail.setSubject('Sample Line Item Edited');
                mail.setPlainTextBody('Some Sample Line Items have been changed');
                //mail.setHtmlBody('<b> This is HTML body </b>' );//Enable if you want HTML content
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                System.debug('Email Sent');
            }
            
            if(!ListOfAddedSLI.isEmpty()){
                System.debug('Inside Send Email for Added SLIs');
                Messaging.SingleEmailMessage mailNew = new Messaging.SingleEmailMessage();
                List<String> listOfEmailIdsForAdded = new List<String>();
                mailNew.setOrgWideEmailAddressId(orgWideEmailAddressId);
                listOfEmailIdsForAdded.add(ownerEmail);
                //listOfEmailIdsForAdded.add('vaibhav.chauhan@utilitarianlabs.com');
                System.debug('listOfEmailIdsForAdded==> ' + listOfEmailIdsForAdded);
                mailNew.setToAddresses(listOfEmailIdsForAdded);
                //mailNew.setReplyTo('no-reply@symegafood.com');
                //mailNew.setSenderDisplayName('Symega Foods');
                mailNew.setSubject('Sample Line Item Added');
                mailNew.setPlainTextBody('Some Sample Line Items have been added');
                //mail.setHtmlBody('<b> This is HTML body </b>' );//Enable if you want HTML content
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailNew });
                System.debug('Email Sent Upon Add');
            }
            System.debug('ListOfSLI 1->'+ListOfSLI);
            upsert ListOfSLI;
            System.debug('ListOfSLI 2-->'+ListOfSLI);
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
        
    }
    
    @RemoteAction
    public static string SaveSampleDetails(Project__c sampleDetails, Integer year, Integer month, Integer day){
        try{
            if(year == 0 && month==0 && day==0){
                
            }else{
                sampleDetails.Opportunity_Close_Date__c = Date.newInstance(year, month, day); 
            }
            update sampleDetails;
            return 'SUCCESS'; 
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static string saveAccDetails(Account accRec, Integer year, Integer month, Integer day){
        try{
            if(year == 0 && month==0 && day==0){
                
            }else{
                accRec.Next_Follow_up_Date__c = Date.newInstance(year, month, day); 
            }
            update accRec;
            return 'SUCCESS'; 
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static string updateDetails(Account accRec,Dispatch_Address__c CustomerAddRec){
        try{
            if(accRec.Name != ''){
                update accRec;
            }
            if(CustomerAddRec.Name != ''){
                update CustomerAddRec;
            }
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static string updateOppProductDetails(List<OpportunityLineItem> listOfOLIToUpdate){
        try{
            system.debug('listOfOLIToUpdate ===> '+listOfOLIToUpdate);
            if(!listOfOLIToUpdate.isEmpty()){
                update listOfOLIToUpdate; 
            }
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    
    
    @AuraEnabled
    public static Upload_Sample_LineItems__mdt uploadResultCSVFormat(){
        List<Upload_Sample_LineItems__mdt> uploadCSVFileFormat = [SELECT Field_API_Name__c, Id, Label, Sequence__c FROM Upload_Sample_LineItems__mdt];
        system.debug('uploadCSVFileFormat'+uploadCSVFileFormat);
        return uploadCSVFileFormat[0];
    }
    
    @AuraEnabled
    public static void uploadFinalResult(String fileData,String sobjectName,List<String> fields){
        try{
            system.debug('fileData ===> '+fileData);
            system.debug('sobjectName ===> '+sobjectName);
            system.debug('fields ===> '+fields);
            List<String> csvLines = new List<String>();
            String[] csvData = fileData.toString().split('\n');
            
            for (String line : csvData) {
                csvLines.add(line);
            }
            system.debug('csvLines ====> '+csvLines);
            
            List<Map<String, String>> csvLinesMap = new List<Map<String, String>>();
            List<Sample_Line_Item__c> sampleLineItemsList = new List<Sample_Line_Item__c>();
            
            for (Integer i = 1; i < csvLines.size(); i++) {
                String csvLine = csvLines[i];
                List<String> csvValues = csvLine.split(',');
                
                Map<String, String> csvLineMap = new Map<String, String>();
                csvLineMap.put('Name', csvValues[0].trim());
                csvLineMap.put('Release_Status__c', csvValues[1].trim());
                csvLineMap.put('Sample_Invoice_Date__c', csvValues[2].trim());
                csvLineMap.put('Actual_date_of_dispatch__c', csvValues[3].trim());
                csvLineMap.put('Courier__c', csvValues[4].trim());
                csvLineMap.put('Dispatch_Details__c', csvValues[5].trim());
                csvLineMap.put('Way_Bill_No__c', csvValues[6].trim());
                csvLineMap.put('Additional_Comments__c', csvValues[7].trim());
                
                csvLinesMap.add(csvLineMap);
            }
            
            System.debug('csvLinesMap =====> '+csvLinesMap);
            
            List<String> csvLineNames = new List<String>();
            for(Map<String, String> line : csvLinesMap){
                csvLineNames.add(line.get('Name'));
            }
            
            List<Sample_Line_Item__c> existingLineItems = [
                SELECT Id, Name, Release_Status__c, Sample_Invoice_Date__c, Actual_date_of_dispatch__c, 
                Courier__c, Dispatch_Details__c, Way_Bill_No__c, Additional_Comments__c 
                FROM Sample_Line_Item__c 
                WHERE Name IN :csvLineNames
            ];
            system.debug('existingLineItems =====> '+existingLineItems);
            
            Map<String, String> existingLineItemsIdMap = new Map<String, String>();
            for (Sample_Line_Item__c lineItem : existingLineItems) {
                existingLineItemsIdMap.put(lineItem.Name, lineItem.Id);
            }
            
            system.debug('existingLineItemsIdMap ====> '+existingLineItemsIdMap);
            
            List<Sample_Line_Item__c> lineItemsToInsertOrUpdate = new List<Sample_Line_Item__c>();
            for (Map<String, String> csvLineMap : csvLinesMap) {
                Sample_Line_Item__c lineItem;
                if (existingLineItemsIdMap.containsKey(csvLineMap.get('Name'))) {
                    lineItem = new Sample_Line_Item__c(Id = existingLineItemsIdMap.get(csvLineMap.get('Name')));
                }
                lineItem.Release_Status__c = csvLineMap.get('Release_Status__c');
                system.debug('Invoice date ====> '+csvLineMap.get('Sample_Invoice_Date__c'));
                if(csvLineMap.get('Sample_Invoice_Date__c') == null || csvLineMap.get('Sample_Invoice_Date__c') == ''){
                    lineItem.Sample_Invoice_Date__c = null;
                }else{
                    lineItem.Sample_Invoice_Date__c = Date.valueOf(csvLineMap.get('Sample_Invoice_Date__c'));
                }
                
                system.debug('Actual Date Of Dispatch ====> '+csvLineMap.get('Sample_Invoice_Date__c'));
                if(csvLineMap.get('Actual_date_of_dispatch__c') == null || csvLineMap.get('Actual_date_of_dispatch__c') == ''){
                    lineItem.Actual_date_of_dispatch__c = null;
                }else{
                    lineItem.Actual_date_of_dispatch__c = Date.valueOf(csvLineMap.get('Actual_date_of_dispatch__c'));
                }
                
                lineItem.Courier__c = csvLineMap.get('Courier__c');
                lineItem.Dispatch_Details__c = csvLineMap.get('Dispatch_Details__c');
                lineItem.Way_Bill_No__c = csvLineMap.get('Way_Bill_No__c');
                
                lineItemsToInsertOrUpdate.add(lineItem);
            }
            system.debug('Before Upsert =====> '+lineItemsToInsertOrUpdate);
            
            upsert lineItemsToInsertOrUpdate;
            
        }
        catch(Exception e){
            system.debug('uploadGDResult ERROR -- ' + e.getMessage());
            system.debug('LINE NO -- ' + e.getLineNumber());
        }
    }
    
}