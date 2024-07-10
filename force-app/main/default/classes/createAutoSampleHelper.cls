public without sharing class createAutoSampleHelper {
    
    @AuraEnabled
    public static string createSample(String projId){
        system.debug('projId-->'+projId);
        try{
            createAutoSampleAndSampleLineItem(new set<Id> {projId});
            return 'success';
        }
        catch(Exception ex){
            system.debug('EXCEPTION EX MSG --' + ex.getMessage());
            system.debug('EXCEPTION EX LINE NO --' + ex.getLineNumber());
            return ex.getMessage();
        }
    }
    
    private static void createAutoSampleAndSampleLineItem(Set<Id> projectIds){
        //TODO:- Map missing fields on sample after confirmation;
        System.debug('projectIds-->'+projectIds);
        String projectRecId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Sample').getRecordTypeId();
        system.debug('projectRecId-->'+projectRecId);
        Map<Id,Project__c> samples = new Map<Id,Project__c>();
        Map<Id,Project__c> projects = new Map<Id,Project__c>([Select Id,Opportunity__r.AccountId,Opportunity__r.OwnerId,Opportunity__r.Billing_City__c, Opportunity__r.Billing_Country__c, Opportunity__r.Billing_State__c, 
                                                              Opportunity__r.Shipping_Street__c, Opportunity__r.Shipping_State__c,Opportunity__r.Shipping_City__c,
                                                              Opportunity__r.Shipping_Postal_Code__c ,Opportunity__r.Shipping_Country__c,
                                                              Opportunity__r.Billing_Street__c,Opportunity__r.Billing_Postal_Code__c,  Name,Opportunity__c,Sampling_Quantity_Unit__c,
                                                              Parent_Project__c,Auto_Submit_Sample__c,Opportunity__r.Account.OwnerId,Expected_Annual_Value__c,End_Use_category__c,End_Use_Applications__c,Account__c,Opportunity_Close_Date__c,Sampling_Quantity_details__c ,CurrencyIsoCode, Opportunity__r.Account.Customer_Contact__r.MailingCity, Opportunity__r.Account.Customer_Contact__r.MailingState, Opportunity__r.Account.Customer_Contact__r.MailingCountry, Opportunity__r.Account.Customer_Contact__r.MailingPostalCode, Opportunity__r.Account.Customer_Contact__r.MailingStreet, Opportunity__r.Account.ShippingCity, Opportunity__r.Account.ShippingState, Opportunity__r.Account.ShippingCountry, Opportunity__r.Account.ShippingPostalCode, Opportunity__r.Account.ShippingStreet, Opportunity__r.Account.Customer_Contact__r.MailingAddress, (Select Id,Product_Name__c,Name,SSC_Code__c,Description__c From Project_Quotients__r) From Project__c Where Id In :projectIds]);
        Map<Id,List<Sample_Line_Item__c>> projSampleLineItemMap = new Map<Id,List<Sample_Line_Item__c>>();
        System.debug('projects -->'+projects);
        for(Project__c proj : projects.values()){
            
            Project__c sample = new Project__c();
            sample.RecordTypeId = projectRecId;
            sample.Account__c = !String.isEmpty(proj.Opportunity__r.AccountId)?proj.Opportunity__r.AccountId:null;
            sample.Opportunity__c = !String.isEmpty(proj.Opportunity__c)?proj.Opportunity__c:null;
            sample.Sample_Name__c = proj.Name + ' - Sample';
            sample.CurrencyIsoCode = proj.CurrencyIsoCode;
            sample.Opportunity_Close_Date__c = proj.Opportunity_Close_Date__c;
            sample.End_Use_category__c = !String.isEmpty(proj.End_Use_category__c)?proj.End_Use_category__c : '';
            sample.End_Use_Applications__c = !String.isEmpty(proj.End_Use_Applications__c)?proj.End_Use_Applications__c : '';
            sample.Expected_Annual_Value__c = proj.Expected_Annual_Value__c ;
            sample.Sample_Project__c = proj.Id;
            if(proj.Opportunity__c != null){
                sample.OwnerId = proj.Opportunity__r.OwnerId;
                
                //Add address fields here.
                //  system.debug('proj.Opportunity__r.Shipping_Street__c.length() ' + proj.Opportunity__r.Shipping_Street__c.length());
                if(proj.Opportunity__r.Account.Customer_Contact__c != null && proj.Opportunity__r.Account.Customer_Contact__r.MailingAddress != null) {
                    sample.City__c = proj.Opportunity__r.Account.Customer_Contact__r.MailingCity;
                    sample.State__c = proj.Opportunity__r.Account.Customer_Contact__r.MailingState;
                    sample.Country__c = proj.Opportunity__r.Account.Customer_Contact__r.MailingCountry;
                    sample.Postal_Code__c = proj.Opportunity__r.Account.Customer_Contact__r.MailingPostalCode;
                    sample.Street__c = proj.Opportunity__r.Account.Customer_Contact__r.MailingStreet != null && proj.Opportunity__r.Account.Customer_Contact__r.MailingStreet.length() >= 125 ? proj.Opportunity__r.Account.Customer_Contact__r.MailingStreet.substring(0, 124) : proj.Opportunity__r.Account.Customer_Contact__r.MailingStreet; 
                }
                else {
                    sample.City__c = proj.Opportunity__r.Shipping_City__c;
                    sample.State__c = proj.Opportunity__r.Shipping_State__c;
                    sample.Country__c = proj.Opportunity__r.Shipping_Country__c;
                    sample.Postal_Code__c = proj.Opportunity__r.Shipping_Postal_Code__c;
                    sample.Street__c = proj.Opportunity__r.Shipping_Street__c != null && proj.Opportunity__r.Shipping_Street__c.length() >= 125 ? proj.Opportunity__r.Shipping_Street__c.substring(0, 124) : proj.Opportunity__r.Shipping_Street__c;
                }
                
                sample.Billing_City__c = proj.Opportunity__r.Billing_City__c;
                sample.Billing_State__c = proj.Opportunity__r.Billing_State__c;
                sample.Billing_Country__c = proj.Opportunity__r.Billing_Country__c;
                sample.Billing_Postal_Code__c = proj.Opportunity__r.Billing_Postal_Code__c;
                sample.Billing_Street__c = proj.Opportunity__r.Billing_Street__c != null && proj.Opportunity__r.Billing_Street__c.length() >= 125 ? proj.Opportunity__r.Billing_Street__c.substring(0, 124) : proj.Opportunity__r.Billing_Street__c; 
            }
            
            
             //NEW
            Map<String, String> sampleTeamByProdFamily = new Map<String, String>();
            List<Sample_Assignment_Team__c> smTeamList = [SELECT Id, Name, Team_Type__c FROM Sample_Assignment_Team__c WHERE Team_Type__c != null ];
            
            for(Sample_Assignment_Team__c sTeam : smTeamList){
                sampleTeamByProdFamily.put(sTeam.Team_Type__c, sTeam.Id);
            }
            //
            system.debug('sampleTeamByProdFamily-->'+sampleTeamByProdFamily);
            samples.put(proj.Id,sample);
            for(Project_Quotient__c pq :proj.Project_Quotients__r){
                system.debug('pq-->'+pq);
                Id teamId;
                system.debug(' pq.Sample_Project_Application__r.Product_Family__c -->'+ pq.Sample_Project_Application__r.Product_Family__c );
                if( pq.Sample_Project_Application__r.Product_Family__c != null){
                    teamId = sampleTeamByProdFamily.containsKey(pq.Sample_Project_Application__r.Product_Family__c) ? sampleTeamByProdFamily.get(pq.Sample_Project_Application__r.Product_Family__c) : null;
                }
                
                Sample_Line_Item__c sli = new Sample_Line_Item__c();
                sli.Project_Quotient__c = pq.Id;
                sli.Quantity_Unit__c = proj.Sampling_Quantity_Unit__c;
                sli.Quantity__c = proj.Sampling_Quantity_details__c;
                sli.Additional_Comments__c = pq.Description__c;
                sli.Packaging_Unit__c = proj.Sampling_Quantity_Unit__c;
                system.debug('teamId-->'+teamId);
                if(teamId != null)
                    sli.Sample_Assignment_Team__c = teamId;
                system.debug('projSampleLineItemMap.containsKey(proj.Id)-->'+projSampleLineItemMap.containsKey(proj.Id));
                if(projSampleLineItemMap.containsKey(proj.Id)){
                    projSampleLineItemMap.get(proj.Id).add(sli);
                }
                else{
                    projSampleLineItemMap.put(proj.Id,new List<Sample_Line_Item__c>{sli});
                }
            }
        }
        
        insert samples.values();
        system.debug('samples.values()-->'+samples.values());
        List<Sample_Line_Item__c> sampleLineItems = new List<Sample_Line_Item__c>();
        Set<Id> samplesId = new Set<Id>();
        
        for(Project__c sample : samples.values()){
            if(projSampleLineItemMap.containsKey(sample.Sample_Project__c)){
                for(Sample_Line_Item__c sli : projSampleLineItemMap.get(sample.Sample_Project__c)){
                    sli.Sample__c = sample.Id;
                    sampleLineItems.add(sli);
                }
                samplesId.add(sample.Id);
            }
        }
        
        insert sampleLineItems;
               
    }
}