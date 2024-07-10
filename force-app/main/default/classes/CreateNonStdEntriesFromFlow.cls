public without sharing class CreateNonStdEntriesFromFlow {
    public CreateNonStdEntriesFromFlow() {

    }

    @InvocableMethod(label='Create Non Standard Entries')
    public static void createNonStdProductEntries2(List<Id> prodIdList){

        List<Product2> prodRecList = [SELECT Id, List_Price__c FROM Product2 WHERE Id =: prodIdList[0] AND List_Price__c != null LIMIT 1];

        List<CurrencyType> currenciesType = [SELECT IsoCode, ConversionRate FROM CurrencyType WHERE IsActive = true];
        system.debug('-- currenciesType -- ' + currenciesType);
        List<Pricebook2> nonStandardPriceBooks = [SELECT Id, IsStandard FROM Pricebook2 WHERE IsActive = true AND IsStandard = false];
        system.debug('-- nonStandardPriceBooks -- ' + nonStandardPriceBooks);
        List<PricebookEntry> nonStdEntriesToInsert = new List<PricebookEntry>();
        
        for (Pricebook2 pricebook : nonStandardPriceBooks) {
            for (CurrencyType currType : currenciesType) {
                PricebookEntry entry = new PricebookEntry();
                entry.Product2Id = prodIdList[0];
                entry.Pricebook2Id = pricebook.Id;
                entry.UnitPrice = currType.ConversionRate * prodRecList[0].List_Price__c;
                entry.IsActive = true;
                entry.CurrencyIsoCode = currType.IsoCode;
                entry.UseStandardPrice = false;
                nonStdEntriesToInsert.add(entry);
            }
        }
        insert nonStdEntriesToInsert;
    }
}