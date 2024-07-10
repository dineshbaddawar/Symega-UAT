public without sharing class customProgressPathController {
    @AuraEnabled(cacheable=true)
    public static List<String> getSampleLineItemStatusPicklistValues(String recordId){
        Sample_Line_Item__c SLIRec = [SELECT Id, Name, Sample_Request_Status__c FROM Sample_Line_Item__c WHERE Id=:recordId LIMIT 1];
        List<String> picklistValues = Utility.getPicklistValues('Sample_Line_Item__c' , 'Sample_Request_Status__c');
        List<String> picklistValuesToSend = new List<String>();
        for(String picklistCurrVal : picklistValues){
            if(SLIRec.Sample_Request_Status__c == picklistCurrVal){
                picklistCurrVal += '.';
            picklistValuesToSend.add(picklistCurrVal);
            }else{
                picklistValuesToSend.add(picklistCurrVal);
            }
        }
        return picklistValuesToSend;
    }
    
        @AuraEnabled(cacheable=true)
    public static List<String> getOpportunityStatusPicklistValues(String recordId){
        Opportunity OppRec = [SELECT Id, Name, StageName FROM Opportunity WHERE Id=:recordId LIMIT 1];
        List<String> picklistValues = Utility.getPicklistValues('Opportunity' , 'StageName');
        List<String> picklistValuesToSend = new List<String>();
        for(String picklistCurrVal : picklistValues){
            if(OppRec.StageName == picklistCurrVal){
                picklistCurrVal += '.';
            picklistValuesToSend.add(picklistCurrVal);
            }else{
                picklistValuesToSend.add(picklistCurrVal);
            }
        }
        return picklistValuesToSend;
    }
}