public class ProductcustomLookupController {
    
    @AuraEnabled
    public static List<ProductLookupWrapper> fetchLookUpValues(String searchKeyWord, String recId) {
        system.debug('searchKeyWord-->' + searchKeyWord);
        system.debug('recId-->' + recId);
        String searchKey =  searchKeyWord + '*';
        
        Decimal defaultSamplingPrice = Decimal.valueOf(System.Label.Default_Sampling_Price);
        
        /*List<sObject> returnList = new List<sObject>();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        //String sQuery =  'select id, Name, ProductCode from ' +ObjectName + ' where Name LIKE '+ searchKey + 'OR ProductCode LIKE ' + searchKey+ 'order by createdDate DESC limit 5';
        String sQuery =  'select id, Name, Current_Shelf_Life__c from ' +ObjectName + ' where Name LIKE '+ searchKey + 'order by createdDate DESC limit 5';
        List<sObject> lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;*/
        List<Project__c> prjList = [SELECT Id, Account__c FROM Project__c WHERE Id =: recId];
        system.debug('prjList -- ' + prjList);
        List<List<SObject>> searchList = [FIND :searchKey IN ALL FIELDS RETURNING Product2(Id, ProductCode, Name, Description, Sampling_Qty_UNIT__c, Regulatory__c, Max_sampling_Qty__c, Current_Shelf_Life__c, Sampling_Price__c WHERE IsActive = true AND ProductCode != null AND Family != null), 
                                          OPTIVA_Recipe__c(Id, Name, SSC_Code__c, Recipe_Description__c, Regulatory__c, Shelf_Life__c, Sampling_Price__c WHERE SSC_Code__c != null AND Recipe_Family__c != null), 
                                          Project_Quotient__c(Id, Name, SSC_Code__c, Product_Name__c, Current_Shelf_Life__c, Description__c WHERE SSC_Code__c != null AND Sample_Project_Application__r.Account__c =: prjList[0].Account__c ) ];
        System.debug('--- searchList'+searchList);
        
        List<ProductLookupWrapper> productWrapperList = new List<ProductLookupWrapper>();
        for(Product2 prd: (Product2[])searchList[0]) {
            productWrapperList.add(new ProductLookupWrapper(prd.Id, prd.Name, prd.ProductCode, prd.Description, prd.Sampling_Qty_UNIT__c, 'product2' , prd.Regulatory__c, prd.Current_Shelf_Life__c, prd.Max_sampling_Qty__c, prd.Sampling_Price__c));
        }
        
        for(OPTIVA_Recipe__c prd: (OPTIVA_Recipe__c[])searchList[1]) {
            productWrapperList.add(new ProductLookupWrapper(prd.Id, prd.Name, prd.SSC_Code__c, prd.Recipe_Description__c, null, 'recepie', prd.Regulatory__c, prd.Shelf_Life__c, null, prd.Sampling_Price__c));
        }
        
        for(Project_Quotient__c prd: (Project_Quotient__c[])searchList[2]) {
            productWrapperList.add(new ProductLookupWrapper(prd.Id, prd.Name, prd.SSC_Code__c, prd.Description__c, null, 'quotient', null, prd.Current_Shelf_Life__c, null, defaultSamplingPrice));
        }
        
        Map<String, string> getIdByNameMap = new Map<String, string>();
        
        return productWrapperList;
    }
    
    
    public class ProductLookupWrapper {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String productCode;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public String samplingQuantityUnit;
        @AuraEnabled
        public String regulatoryReq;
        @AuraEnabled
        public String currentShelfLife;
        @AuraEnabled
        public Decimal maxSampleQty;
        @AuraEnabled
        public Decimal samplingPrice;
        
        public ProductLookupWrapper(String id, String name, String productCode, String description, String samplingQuantityUnit, String type, String regulatoryReq, String currentShelfLife, Decimal maxSampleQty, Decimal samplingPrice) {
            this.id = id;
            this.name = name;
            this.productCode = productCode;
            this.description = description;
            this.type = type;
            this.samplingQuantityUnit = samplingQuantityUnit;
            this.regulatoryReq = regulatoryReq;
            this.currentShelfLife = currentShelfLife;
            this.maxSampleQty = maxSampleQty;
            this.samplingPrice = samplingPrice;
        }
    }

}