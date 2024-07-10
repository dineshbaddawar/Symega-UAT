public without sharing class DistAllocationController {
    
    static DistAllocationController distAllTriggerInstance;
    
    public static DistAllocationController getInstance(){
        if(distAllTriggerInstance==null)
            distAllTriggerInstance = new DistAllocationController();
        return distAllTriggerInstance;     
    }
    
    public void onAfterInsert(List<Distributor_Allocation__c> dAllList) {
        
        Set<Id> customerAccountIdSet = new Set<Id>();
        for(Distributor_Allocation__c dAlloc : dAllList) {
            if(dAlloc.Customer_Account__c != null) {
                customerAccountIdSet.add(dAlloc.Customer_Account__c);
            }
        }
        system.debug('customerAccountIdSet -->> ' + customerAccountIdSet);            
        
        if(!customerAccountIdSet.isEmpty())
            ParentAccountRollupUtility.processSummaryCalculationFuture(customerAccountIdSet);
    }
}