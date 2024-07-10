@isTest
private class TriggerTestClass{
    @isTest(SeeAllData=true)
    private static void run(){
        Database.SaveResult dsr;
        User_Document__c ud = new User_Document__c();
        ud.Name = 'Test';
        insert ud;
        ud.Display_On_Portal__c = true;
        update ud;
    }
    
    @isTest(SeeAllData=true)
    private static void run1(){
        Database.SaveResult dsr;
        Opportunity opp = new Opportunity(Name='ABC', StageName ='New', CloseDate= system.today(), 
                                          Annual_Volume_Full__c = 78, Annual_Volume_in_units__c = 'Kg', 
                                          Target_Price_Kg__c = 67890, End_Use_Application__c = 'Beer', End_Use_Category__c = ' Beverages');
        insert opp;
        opp.StageName = 'New';
        update opp;
    }
    
    @isTest(SeeAllData=true)
    private static void run2(){
        Database.SaveResult dsr;
        Opportunity opp = new Opportunity(Name='ABC', StageName ='New', CloseDate= system.today(), Annual_Volume_Full__c = 78, Annual_Volume_in_units__c = 'Kg', 
                                          Target_Price_Kg__c = 67890, End_Use_Application__c = 'Beer', End_Use_Category__c = ' Beverages');
        insert opp;
        Quote qt = new Quote(Name='ABC');
        qt.OpportunityId = opp.Id;
        insert qt;

    }
    
    @isTest(SeeAllData=true)
    private static void run3(){
        Database.SaveResult dsr;
        
        Account accRec = new Account();
        accRec.Name = 'Test';
        accRec.Account_Segment__c = 'Key';
        accRec.CurrencyIsoCode = 'INR';
        accRec.BillingCity = 'Bangalore';
        accRec.BillingCountry = 'India';
        accRec.BillingState = 'Punjab';
        accRec.BillingStreet = 'XYZ, Test';
        accRec.BillingPostalCode = '561011';
        accRec.ShippingCity = 'Bangalore';
        accRec.ShippingCountry = 'India';
        accRec.ShippingState = 'Punjab';
        accRec.ShippingStreet = 'XYZ, Test';
        accRec.ShippingPostalCode = '561011';
        insert accRec;
        
        Opportunity opp = new Opportunity(Name='ABC', StageName ='New', CloseDate= system.today(), Annual_Volume_Full__c = 78, Annual_Volume_in_units__c = 'Kg', 
                                          Target_Price_Kg__c = 67890, End_Use_Application__c = 'Beer', End_Use_Category__c = ' Beverages',AccountId = accRec.Id,
                                          Shipping_Street__c = 'Test Nagar',Shipping_City__c = 'Bengalore',Shipping_Country__c = 'India',Shipping_State__c = 'Karnataka',
                                          Shipping_Postal_Code__c = '560074');
        insert opp;
        
         Sales_Order__c saleOrder = new Sales_Order__c(Name='ABC', Opportunity__c = opp.Id);
        insert saleOrder;
        
        Invoice__c invoice = new Invoice__c(Sales_Order__c = saleOrder.Id, Account__c = accRec.Id, Invoice_Number__c = '4sj');
        insert invoice;
        
        Pricebook2 book = new Pricebook2(IsActive=true, Name='Std Book');
        insert book;
        
        Product2 prod = new Product2(IsActive=true, Name='AAM PANNA', To_Be_Sold_By__c ='Direct', Product_Visibility__c = 'Public', Product_Used_By__c = 'portfolio product');
        insert prod;
        
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
        PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE;
        
        PricebookEntry entry = new PricebookEntry(IsActive=true, UnitPrice=900, UseStandardPrice=false);
        entry.Pricebook2Id=book.Id;
        entry.Product2Id=prod.Id;	
        insert entry;
        
        //OpportunityLineItemTrigger.checkProdCreationAcceptanceCriteria();
        
        /*OpportunityLineItem OLI = new OpportunityLineItem(Quantity=20.00, Packaging_Type__c='Bulk', UnitPrice=1000, Markup_Amount__c= 100);
        OLI.OpportunityId=opp.id;
        //OLI.Product2Id = prod.Id;
        OLI.PricebookEntryId = standardPBE .id; 
        insert OLI;
        OLI.Quantity = 1;
        update OLI;  */
              
        List<OpportunityLineItem> OLI2List = new List<OpportunityLineItem>();
        OpportunityLineItem OLI2 = new OpportunityLineItem();
        OLI2.Quantity=10.00;
        OLI2.Discount = 34;
        OLI2.TotalPrice=2525;
        OLI2.Packaging_Type__c='Bulk';
        //OLI2.UnitPrice=1000;
        OLI2.Markup_Amount__c= 100;
        OLI2.OpportunityId = opp.id;
        OLI2.Product2Id = prod.Id;
        OLI2.Packaging_Quantity__c = 20;
        OLI2.Packaging_Unit__c = 'GM';
        OLI2.Primary__c = '250';
        OLI2.Secondary__c = '250';
        OLI2.Tertiary__c = '250';
        // OLI2.ProductCode = 'ProdCode';
        OLI2.PricebookEntryId = standardPBE .id; 
        OLI2List.add(OLI2);
        insert OLI2List;
         System.debug('--- OLI2Test '+OLI2);
        System.debug('--- OLI2ListTest '+OLI2List);
        //OLI2.Product2Id = null;
        //OLI2.PricebookEntryId = null;
        //OLI2.Quantity = 1;
        //update OLI2;
        
        Return__c returnObj = new Return__c(Quantity__c  = 1, Opportunity_Product__c = OLI2.Id, Sale_Order__c = saleOrder.Id, Invoice__c = invoice.Id);
        insert returnObj;
        
        returnObj.Quantity__c = 1;
        update returnObj;
        
    }
    
    @isTest(SeeAllData=true)
    private static void run4(){
        Database.SaveResult dsr;
        Lead ld = new Lead(FirstName='ABC', LastName='XYZ', Company ='New', Status='New', Email='dummy@gmail.com');
        insert ld;
        ld.Company = 'Old';
        update ld;
    }
    
   /* @isTest(SeeAllData=true)
    public static void run5(){
        Database.SaveResult dsr;
        
        Account accRec = new Account();
        accRec.Name = 'Test';
        accRec.Account_Segment__c = 'Key';
        accRec.CurrencyIsoCode = 'INR';
        accRec.BillingCity = 'Bangalore';
        accRec.BillingCountry = 'India';
        accRec.BillingState = 'Punjab';
        accRec.BillingStreet = 'XYZ, Test';
        accRec.BillingPostalCode = '561011';
        accRec.ShippingCity = 'Bangalore';
        accRec.ShippingCountry = 'India';
        accRec.ShippingState = 'Punjab';
        accRec.ShippingStreet = 'XYZ, Test';
        accRec.ShippingPostalCode = '561011';
        insert accRec;
        
        Dispatch_Address__c dAdd = new Dispatch_Address__c(Account__c = accRec.Id, Type__c = 'Shipping', Address__Street__s = 'test street', 
                                                           Address__City__s = 'Bangalore' , Address__PostalCode__s = '67891', 
                                                           Address__StateCode__s = 'KA', Address__CountryCode__s = 'IN');
        insert dAdd;
        
        
        Opportunity opp = new Opportunity(Name='ABC', StageName ='New', CloseDate= system.today(), Annual_Volume_Full__c = 78, Annual_Volume_in_units__c = 'Kg', 
                                          Target_Price_Kg__c = 67890, End_Use_Application__c = 'Beer', End_Use_Category__c = ' Beverages',AccountId = accRec.Id);
        insert opp;
        
        Sales_Order__c saleOrder = new Sales_Order__c(Name='ABC', Opportunity__c = opp.Id);
        insert saleOrder;
        
        Invoice__c invoice = new Invoice__c(Sales_Order__c = saleOrder.Id, Account__c = accRec.Id, Invoice_Number__c = '4sj');
        insert invoice;
        
        Pricebook2 book = new Pricebook2(IsActive=true, Name='Std Book');
        insert book;
        
        Product2 prod = new Product2(IsActive=true, Name='AAM PANNA', To_Be_Sold_By__c ='Direct', Product_Visibility__c = 'Public', Product_Used_By__c = 'Tailor Made');
        insert prod;
        
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
        PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE;
        
        PricebookEntry entry = new PricebookEntry(IsActive=true, UnitPrice=900, UseStandardPrice=false);
        entry.Pricebook2Id=book.Id;
        entry.Product2Id=prod.Id;	
        insert entry;
        
        List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();
        OpportunityLineItem oppLineItem = new OpportunityLineItem(Packaging_Type__c = 'Bulk', OpportunityId = opp.Id, Discount = 67, Quantity = 45, TotalPrice=678);
        oppLineItem.PricebookEntryId = standardPBE.id;
        oppLineItem.Product2Id = prod.Id;
        insert oppLineItem;
        oppLineItemList.add(oppLineItem);
        
        Return__c returnObj = new Return__c(Quantity__c  = 1, Opportunity_Product__c = oppLineItem.Id, Sale_Order__c = saleOrder.Id, Invoice__c = invoice.Id);
        insert returnObj;
        
        returnObj.Quantity__c = 1;
        update returnObj;
       // 
       //OpportunityLineItemTriggerHandler.onAfterInsert(oppLineItemList);
    }  */
    
    @isTest(SeeAllData=true)
    private static void run6(){
        Database.SaveResult dsr;
        Account acc = new Account(Name = 'ACC-INVOICE');
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
        
        Dispatch_Address__c dAdd = new Dispatch_Address__c(Account__c = acc.Id, Type__c = 'Shipping', Address__Street__s = 'test street', 
                                                           Address__City__s = 'Bangalore' , Address__PostalCode__s = '67891', 
                                                           Address__StateCode__s = 'KA', Address__CountryCode__s = 'IN');
        
        insert dAdd;
        dAdd.Type__c = 'Billing';
        update dAdd;        
    }
    
     @isTest(SeeAllData=true)
    private static void run7(){
        Database.SaveResult dsr;
        
        Account accRec = new Account();
        accRec.Name = 'Test';
        accRec.Account_Segment__c = 'Key';
        accRec.CurrencyIsoCode = 'INR';
        accRec.BillingCity = 'Bangalore';
        accRec.BillingCountry = 'India';
        accRec.BillingState = 'Punjab';
        accRec.BillingStreet = 'XYZ, Test';
        accRec.BillingPostalCode = '561011';
        accRec.ShippingCity = 'Bangalore';
        accRec.ShippingCountry = 'India';
        accRec.ShippingState = 'Punjab';
        accRec.ShippingStreet = 'XYZ, Test';
        accRec.ShippingPostalCode = '561011';
        insert accRec;
        
        Opportunity opp = new Opportunity(Name='ABC', StageName ='New', CloseDate= system.today(), Annual_Volume_Full__c = 78, Annual_Volume_in_units__c = 'Kg', 
                                          Target_Price_Kg__c = 67890, End_Use_Application__c = 'Beer', End_Use_Category__c = ' Beverages',AccountId = accRec.Id);
        insert opp;
        
        Pricebook2 book = new Pricebook2(IsActive=true, Name='Std Book');
        insert book;
        
        Product2 prod = new Product2(IsActive=true, Name='AAM PANNA', To_Be_Sold_By__c ='Direct', Product_Visibility__c = 'Public', Product_Used_By__c = 'Tailor Made');
        insert prod;
        
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
        PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE;
        
        PricebookEntry entry = new PricebookEntry(IsActive=true, UnitPrice=900, UseStandardPrice=false);
        entry.Pricebook2Id=book.Id;
        entry.Product2Id=prod.Id;	
        insert entry;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem(Packaging_Type__c = 'Bulk', OpportunityId = opp.Id, Discount = 67, Quantity = 45, TotalPrice=678);
        oppLineItem.PricebookEntryId = standardPBE.id;
        //oppLineItem.Product2Id = prod.Id;
       // insert oppLineItem;
        
        Sales_Order__c saleOrder = new Sales_Order__c(Name='ABC', Opportunity__c = opp.Id);
        insert saleOrder;
        
        Account acc = new Account(Name = 'ACC-INVOICE');
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
        
        Dispatch_Address__c dAdd = new Dispatch_Address__c(Account__c = acc.Id, Type__c = 'Shipping', Address__Street__s = 'test street', 
                                                           Address__City__s = 'Bangalore' , Address__PostalCode__s = '67891', 
                                                           Address__StateCode__s = 'KA', Address__CountryCode__s = 'IN');
        insert dAdd;
        
        Invoice__c invoice = new Invoice__c(Sales_Order__c = saleOrder.Id, Account__c = acc.Id, Invoice_Number__c = '4sj');
        insert invoice;
        
        Return__c returnObj = new Return__c(Quantity__c  = 1, Opportunity_Product__c = oppLineItem.Id, Sale_Order__c = saleOrder.Id, Invoice__c = invoice.Id);
       // insert returnObj;
        
        returnObj.Quantity__c = 1;
       // update returnObj;
    }
   
   
}