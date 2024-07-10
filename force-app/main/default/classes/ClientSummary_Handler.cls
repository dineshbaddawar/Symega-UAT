public class ClientSummary_Handler {
    
    @AuraEnabled
    public static ClientSummaryWrapper getAllAccountCount(){
        try{

            String userId = UserInfo.getUserId();
            Integer getAllLeadRecCount = [SELECT COUNT() From Lead WHERE OwnerId =: userId AND IsConverted = false];//recently Added 28-06-2024
            Integer getAllOpportunityRecCount = [Select COUNT() From Opportunity WHERE OwnerId =: userId];
            Integer getAllETBAccountRecCount = [Select COUNT() From Account where Account_Stage__c = 'Active' AND OwnerId =: userId AND Id IN (SELECT AccountId FROM Opportunity WHERE StageName = 'Closed Won')];
            
            Integer getAllNTBAccountRecCount = [Select COUNT() From Account where Account_Stage__c = 'Active' AND OwnerId =: userId AND Id IN (SELECT AccountId FROM Opportunity WHERE StageName != 'Closed Won')];
            Integer getAllNTBAccountRecCount2 = [Select COUNT() From Account where Account_Stage__c = 'Active' AND OwnerId =: userId AND Id NOT IN (SELECT AccountId FROM Opportunity)];

            getAllNTBAccountRecCount += getAllNTBAccountRecCount2;
            
            Integer getAllLCAccountRecCount = [Select COUNT() From Account where Account_Stage__c = 'Inactive' AND OwnerId =: userId];
            ClientSummaryWrapper cswr = new ClientSummaryWrapper();
            if(getAllLeadRecCount !=null){
                cswr.leadToatlCount = getAllLeadRecCount;
            }
            
            if(getAllOpportunityRecCount != null) {
                cswr.oppToatlCount = getAllOpportunityRecCount;
            }
            if(getAllETBAccountRecCount != null) {
                cswr.accETBCount = getAllETBAccountRecCount;
            }
            if(getAllNTBAccountRecCount != null) {
                cswr.accNTBCount = getAllNTBAccountRecCount;
            }
            if(getAllLCAccountRecCount != null) {
                cswr.accLCCount = getAllLCAccountRecCount;
            }
            if(cswr !=null){
                return cswr; 
            }
        }catch(Exception e){
            System.debug('Error message == >'+e.getMessage() + ' && Error Line == >'+e.getLineNumber());
        }
        return null; 
    }
    
   public class ClientSummaryWrapper {
        @AuraEnabled
        public Integer leadToatlCount {get;set;}
        @AuraEnabled
        public Integer oppToatlCount {get;set;}
        @AuraEnabled
        public Integer accETBCount {get;set;}
        @AuraEnabled
        public Integer accNTBCount {get;set;}
        @AuraEnabled
        public Integer accLCCount {get;set;}
    }
}