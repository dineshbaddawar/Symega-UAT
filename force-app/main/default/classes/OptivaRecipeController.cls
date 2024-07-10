public without sharing class OptivaRecipeController {

    @AuraEnabled
    public static String createProduct(String optivaRecId){
       
       String result;
        try{
        
        OPTIVA_Recipe__c optRec = [SELECT ID,Name,SSC_Code__c,CurrencyIsoCode,Quantity_Unit_Of_Measure__c,SALES_CODE__c,LEGACYCODE__c,Legal_status__c,SOLUBILITY__c,Recipe_Description__c,Active__c,Allergen_Status_Required__c,
                                  Dosage_Guidelines__c, End_Application__c,Shelf_Life__c,PHYSICAL_FORM__c,Region__c,Plant__c,Recipe_Family__c,MOQ__c FROM OPTIVA_Recipe__c WHERE ID =:optivaRecId];


            Product2  prodRec = new Product2();
            prodRec.OPTIVA_Recipe__c = optRec.Id;
            prodRec.Name = optRec.Name;
            prodRec.ProductCode = optRec.SSC_Code__c;
            prodRec.CurrencyIsoCode = optRec.CurrencyIsoCode;
            prodRec.QuantityUnitOfMeasure = optRec.Quantity_Unit_Of_Measure__c;
            prodRec.SALES_CODE__c  = optRec.SALES_CODE__c;
            prodRec.LEGACYCODE__c  = optRec.LEGACYCODE__c;
            prodRec.Legal_status__c = optRec.Legal_status__c;
            prodRec.SOLUBILITY__c  = optRec.SOLUBILITY__c;
            prodRec.Description  = optRec.Recipe_Description__c;
            prodRec.IsActive = optRec.Active__c;
            prodRec.Dosage_Guidelines__c = optRec.Dosage_Guidelines__c;
            prodRec.End_Application__c   = optRec.End_Application__c  ;
            prodRec.Shelf_Life__c   = Decimal.valueOf(optRec.Shelf_Life__c) ;
            prodRec.PHYSICAL_FORM__c   = optRec.PHYSICAL_FORM__c  ;
            prodRec.Region__c   = optRec.Region__c  ;
          //  prodRec.Plant__c   = optRec.Plant__c  ;
            prodRec.Family   = optRec.Recipe_Family__c  ;
            prodRec.MOQ__c   = optRec.MOQ__c  ;
          //   prodRec.Allergen_Status_Required__c =  optRec.Allergen_Status_Required__c
            insert prodRec;    
           result ='SUCCESS';

        }catch(Exception e){
            System.debug('Exception Line Number--->'+e.getLineNumber());
            System.debug('Exception Message-->'+e.getMessage());
        }
        return result;
    }

}