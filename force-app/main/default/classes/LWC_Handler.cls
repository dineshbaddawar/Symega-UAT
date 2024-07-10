public without sharing class LWC_Handler {
    public LWC_Handler() {

    }

    @AuraEnabled
    public static Monthly_Beat_Plan__c getMBPRecordDetails(Id mbpId){
        if(mbpId == null) return null;
        Monthly_Beat_Plan__c mbpRec = [SELECT Id, Sales_User__c FROM Monthly_Beat_Plan__c WHERE Id =: mbpId];
        return mbpRec;
    }
}