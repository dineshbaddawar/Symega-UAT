public without sharing class ClassCallFromFlow {
    
    @InvocableMethod(label='Create Product Entries')
    public static void createProductEntries(List<Id> prodIdList) {
        List<Product2> prodRecList = [SELECT Id, List_Price__c FROM Product2 WHERE Id IN: prodIdList AND List_Price__c != null LIMIT 1];
        system.debug('-- prodRecList -- ' + prodRecList);
        if(prodRecList.size() > 0){
            
            List<CurrencyType> currenciesType = [SELECT IsoCode, ConversionRate FROM CurrencyType WHERE IsActive = true];
            system.debug('-- currenciesType -- ' + currenciesType);
            
            List<Pricebook2> standardPriceBooks = [SELECT Id, IsStandard FROM Pricebook2 WHERE IsActive = true AND IsStandard = true LIMIT 1];
            system.debug('-- standardPriceBooks -- ' + standardPriceBooks);
            List<PricebookEntry> stdEntriesToInsert = new List<PricebookEntry>();
            List<PricebookEntry> existingPBEList = [SELECT Id, CurrencyIsoCode FROM PricebookEntry WHERE Product2Id IN: prodIdList AND Pricebook2Id =: standardPriceBooks[0].Id];

            Set<String> existingCurrSet = new Set<String>();
            for(PricebookEntry pbe : existingPBEList){
                existingCurrSet.add(pbe.CurrencyIsoCode);
            }
            
            for (CurrencyType currType : currenciesType) {
                if(!existingCurrSet.contains(currType.IsoCode)){
                    PricebookEntry entry = new PricebookEntry();
                    entry.Product2Id = prodRecList[0].Id;
                    entry.Pricebook2Id = standardPriceBooks[0].Id;
                    entry.UnitPrice = currType.ConversionRate * prodRecList[0].List_Price__c;
                    entry.IsActive = true;
                    entry.CurrencyIsoCode = currType.IsoCode;
                    entry.UseStandardPrice = false;
                    stdEntriesToInsert.add(entry);
                }
            }
            
            if(stdEntriesToInsert.size() > 0){
                insert stdEntriesToInsert;
                createNonStdProductEntries(prodRecList[0].Id, prodRecList[0].List_Price__c);
            }
        }
    }
    
    @future
    public static void createNonStdProductEntries(Id prodId, Decimal price){
        List<CurrencyType> currenciesType = [SELECT IsoCode, ConversionRate FROM CurrencyType WHERE IsActive = true];
        system.debug('-- currenciesType -- ' + currenciesType);
        List<Pricebook2> nonStandardPriceBooks = [SELECT Id, IsStandard FROM Pricebook2 WHERE IsActive = true AND IsStandard = false];
        system.debug('-- nonStandardPriceBooks -- ' + nonStandardPriceBooks);
        List<PricebookEntry> nonStdEntriesToInsert = new List<PricebookEntry>();
        
        for (Pricebook2 pricebook : nonStandardPriceBooks) {
            for (CurrencyType currType : currenciesType) {
                PricebookEntry entry = new PricebookEntry();
                entry.Product2Id = prodId;
                entry.Pricebook2Id = pricebook.Id;
                entry.UnitPrice = currType.ConversionRate * price;
                entry.IsActive = true;
                entry.CurrencyIsoCode = currType.IsoCode;
                entry.UseStandardPrice = false;
                nonStdEntriesToInsert.add(entry);
            }
        }
        insert nonStdEntriesToInsert;
    }
}