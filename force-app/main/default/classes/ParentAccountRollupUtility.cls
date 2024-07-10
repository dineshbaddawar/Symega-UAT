/**
* Author: DeaGle~
* CreatedDate: May 2nd, 2023
* Description: contains all parent account summary calculation
*/

public without sharing class ParentAccountRollupUtility {
    
    //@future
    /*public static void processSummaryCalculationFuture_OLD(Set<Id> parentAccIdSet) {

Map<Id, Account> childAccountMap = new Map<Id,Account>([SELECT Id, ParentId, (SELECT Id, StageName, Color_Opportunity__c, CPD_Opportunity__c, Flavor_Opportunity__c, Plant_Based_Opportunity__c, SPD_Opportunity__c FROM Opportunities), Number_of_closed_opportunity__c, Number_of_open_opportunity__c, Number_of_Total_Opportunity__c, Number_Of_Won_Opportunity__c, Number_of_won_opportunity_partially_exec__c, Closed_Opportunity_Value__c, COLOR_Opportunity_Closed_Value__c, CPD_Opportunity_Closed_Value__c, FLAVOR_Opportunity_Closed_Value__c, PLANT_BASED_Opportunity_Closed_Value__c, SPD_Opportunity_Closed_Value__c FROM Account WHERE ParentId IN :parentAccIdSet OR Id IN :parentAccIdSet]);

Map<Id, List<Account>> parentToChildAccMap = new Map<Id, List<Account>>();

for(Account acc : childAccountMap.values()) {
if(acc.ParentId != null) {
if(parentToChildAccMap.containsKey(acc.ParentId)) 
parentToChildAccMap.get(acc.ParentId).add(acc);
else
parentToChildAccMap.put(acc.ParentId, new List<Account> {acc});
}

}


List<Account> parentAccountToUpdateList = new List<Account>();

for(Id parentId : parentToChildAccMap.keySet()) {
Account parentAcc = new Account(Id = parentId);
parentAcc.Number_of_closed_opportunity_new__c = 0;
parentAcc.Number_of_open_opportunity_new__c = 0;
parentAcc.Number_of_Total_Opportunity_new__c = 0;
parentAcc.Number_Of_Won_Opportunity_new__c = 0;
parentAcc.Number_of_won_opportunity_partially_new__c = 0;
parentAcc.Closed_Opportunity_Value_New__c = 0;
parentAcc.COLOR_Opportunity_Closed_Value_New__c = 0;
parentAcc.CPD_Opportunity_Closed_Value_New__c = 0;
parentAcc.FLAVOR_Opportunity_Closed_Value_New__c = 0;
parentAcc.PLANT_BASED_Opportunity_Closed_Value_New__c = 0;
parentAcc.SPD_Opportunity_Closed_Value_New__c = 0;

for(Account acc: parentToChildAccMap.get(parentId)) {
parentAcc.Number_of_closed_opportunity_new__c += acc.Number_of_closed_opportunity__c;
parentAcc.Number_of_open_opportunity_new__c += acc.Number_of_open_opportunity__c;
parentAcc.Number_of_Total_Opportunity_new__c += acc.Number_of_Total_Opportunity__c;
parentAcc.Number_Of_Won_Opportunity_new__c += acc.Number_Of_Won_Opportunity__c;
parentAcc.Number_of_won_opportunity_partially_new__c += acc.Number_of_won_opportunity_partially_exec__c;
parentAcc.Closed_Opportunity_Value_New__c += acc.Closed_Opportunity_Value__c;
parentAcc.COLOR_Opportunity_Closed_Value_New__c += acc.COLOR_Opportunity_Closed_Value__c;
parentAcc.CPD_Opportunity_Closed_Value_New__c += acc.CPD_Opportunity_Closed_Value__c;
parentAcc.FLAVOR_Opportunity_Closed_Value_New__c += acc.FLAVOR_Opportunity_Closed_Value__c;
parentAcc.PLANT_BASED_Opportunity_Closed_Value_New__c += acc.PLANT_BASED_Opportunity_Closed_Value__c;
parentAcc.SPD_Opportunity_Closed_Value_New__c += acc.SPD_Opportunity_Closed_Value__c;
}

if(childAccountMap.containsKey(parentId)) {
Account currentParent = childAccountMap.get(parentId);
parentAcc.Number_of_closed_opportunity_new__c += currentParent.Number_of_closed_opportunity__c;
parentAcc.Number_of_open_opportunity_new__c += currentParent.Number_of_open_opportunity__c;
parentAcc.Number_of_Total_Opportunity_new__c += currentParent.Number_of_Total_Opportunity__c;
parentAcc.Number_Of_Won_Opportunity_new__c += currentParent.Number_Of_Won_Opportunity__c;
parentAcc.Number_of_won_opportunity_partially_new__c += currentParent.Number_of_won_opportunity_partially_exec__c;
parentAcc.Closed_Opportunity_Value_New__c += currentParent.Closed_Opportunity_Value__c;
parentAcc.COLOR_Opportunity_Closed_Value_New__c += currentParent.COLOR_Opportunity_Closed_Value__c;
parentAcc.CPD_Opportunity_Closed_Value_New__c += currentParent.CPD_Opportunity_Closed_Value__c;
parentAcc.FLAVOR_Opportunity_Closed_Value_New__c += currentParent.FLAVOR_Opportunity_Closed_Value__c;
parentAcc.PLANT_BASED_Opportunity_Closed_Value_New__c += currentParent.PLANT_BASED_Opportunity_Closed_Value__c;
parentAcc.SPD_Opportunity_Closed_Value_New__c += currentParent.SPD_Opportunity_Closed_Value__c;
}

parentAccountToUpdateList.add(parentAcc);
}

if(!parentAccountToUpdateList.isEmpty()) {
try{
System.debug(LoggingLevel.DEBUG, '--- parentAccountToUpdateList '+parentAccountToUpdateList);
update parentAccountToUpdateList;
}catch(DmlException e) {
System.debug('--- error message'+e.getMessage());
HandleBusinessException.captureError('ParentAccountRollupUtility', 'processSummaryCalculationFuture', e);
}
}


/**
*  Number_of_closed_opportunity_new__c
Number_of_open_opportunity__new__c
Number_of_Total_Opportunity_new__c
Number_Of_Won_Opportunity_new__c
Number_of_won_opportunity_partially_new__c
Closed_Opportunity_Value_New__c
COLOR_Opportunity_Closed_Value__New__c
CPD_Opportunity_Closed_Value_New__c
FLAVOR_Opportunity_Closed_Value_New__c
PLANT_BASED_Opportunity_Closed_Value_New__cSPD_Opportunity_Closed_Value_New__c
*
}*/
    
    //@future
    public static void processSummaryCalculationFuture(Set<Id> childAccountIdSet) {
        
        Map<Id, parentChildWrapper> parentCalculationOppMap = new Map<Id, parentChildWrapper>();
        List<Distributor_Allocation__c> distAllocationList = [SELECT Id, Customer_Account__c, Distributor_Account__c, Customer_Account__r.Number_of_closed_opportunity__c, Customer_Account__r.Number_of_open_opportunity__c, Customer_Account__r.Number_of_Total_Opportunity__c, Customer_Account__r.Number_Of_Won_Opportunity__c, 
                                                              Customer_Account__r.Number_of_won_opportunity_partially_exec__c, Customer_Account__r.Closed_Opportunity_Value__c, Customer_Account__r.COLOR_Opportunity_Closed_Value__c, Customer_Account__r.CPD_Opportunity_Closed_Value__c, Customer_Account__r.FLAVOR_Opportunity_Closed_Value__c, 
                                                              Customer_Account__r.PLANT_BASED_Opportunity_Closed_Value__c, Customer_Account__r.SPD_Opportunity_Closed_Value__c,
                                                              Distributor_Account__r.Number_of_closed_opportunity_new__c, Distributor_Account__r.Number_of_open_opportunity_new__c, Distributor_Account__r.Number_of_Total_Opportunity_new__c, Distributor_Account__r.Number_Of_Won_Opportunity_new__c, Distributor_Account__r.Number_of_won_opportunity_partially_new__c, 
                                                              Distributor_Account__r.Closed_Opportunity_Value_New__c, Distributor_Account__r.COLOR_Opportunity_Closed_Value_New__c, Distributor_Account__r.CPD_Opportunity_Closed_Value_New__c, Distributor_Account__r.FLAVOR_Opportunity_Closed_Value_New__c, Distributor_Account__r.PLANT_BASED_Opportunity_Closed_Value_New__c, Distributor_Account__r.SPD_Opportunity_Closed_Value_New__c 
                                                              From Distributor_Allocation__c WHERE Customer_Account__c IN: childAccountIdSet];
        
        
        if(distAllocationList.size() > 0){
            Set<Id> distributorAccIdSet = new Set<Id>();
            for(Distributor_Allocation__c dAll : distAllocationList){
                distributorAccIdSet.add(dAll.Distributor_Account__c);                
            }
            
            system.debug('distributorAccIdSet -->> ' + distributorAccIdSet);
            
            List<Distributor_Allocation__c> newDistAllocationList = [SELECT Id, Customer_Account__c, Distributor_Account__c, Customer_Account__r.Number_of_closed_opportunity__c, Customer_Account__r.Number_of_open_opportunity__c, Customer_Account__r.Number_of_Total_Opportunity__c, Customer_Account__r.Number_Of_Won_Opportunity__c, 
                                                                     Customer_Account__r.Number_of_won_opportunity_partially_exec__c, Customer_Account__r.Closed_Opportunity_Value__c, Customer_Account__r.COLOR_Opportunity_Closed_Value__c, Customer_Account__r.CPD_Opportunity_Closed_Value__c, Customer_Account__r.FLAVOR_Opportunity_Closed_Value__c, 
                                                                     Customer_Account__r.PLANT_BASED_Opportunity_Closed_Value__c, Customer_Account__r.SPD_Opportunity_Closed_Value__c,
                                                                     Distributor_Account__r.Number_of_closed_opportunity_new__c, Distributor_Account__r.Number_of_open_opportunity_new__c, Distributor_Account__r.Number_of_Total_Opportunity_new__c, Distributor_Account__r.Number_Of_Won_Opportunity_new__c, Distributor_Account__r.Number_of_won_opportunity_partially_new__c, 
                                                                     Distributor_Account__r.Closed_Opportunity_Value_New__c, Distributor_Account__r.COLOR_Opportunity_Closed_Value_New__c, Distributor_Account__r.CPD_Opportunity_Closed_Value_New__c, Distributor_Account__r.FLAVOR_Opportunity_Closed_Value_New__c, Distributor_Account__r.PLANT_BASED_Opportunity_Closed_Value_New__c, Distributor_Account__r.SPD_Opportunity_Closed_Value_New__c 
                                                                     From Distributor_Allocation__c WHERE Distributor_Account__c IN: distributorAccIdSet];
            system.debug('newDistAllocationList.size() -->> ' + newDistAllocationList.size()); 
            for(Distributor_Allocation__c dAll : newDistAllocationList){
                system.debug('dAll.Distributor_Account__c -->> ' + dAll.Distributor_Account__c);                    
                
                if(!parentCalculationOppMap.containsKey(dAll.Distributor_Account__c)){
                    parentChildWrapper cWrapper = new parentChildWrapper();
                    cWrapper.TotalClosedOpp += dAll.Customer_Account__r.Number_of_closed_opportunity__c;
                    cWrapper.TotalOpenOpp += dAll.Customer_Account__r.Number_of_open_opportunity__c;
                    cWrapper.TotalOpp += dAll.Customer_Account__r.Number_of_Total_Opportunity__c;
                    cWrapper.TotalWonOpp += dAll.Customer_Account__r.Number_Of_Won_Opportunity__c;
                    cWrapper.TotalWonPartialOpp += dAll.Customer_Account__r.Number_of_won_opportunity_partially_exec__c;
                    cWrapper.ClosedOppVl += dAll.Customer_Account__r.Closed_Opportunity_Value__c;
                    cWrapper.ColorClosedOppVl += dAll.Customer_Account__r.COLOR_Opportunity_Closed_Value__c;
                    cWrapper.CpdClosedOppVl += dAll.Customer_Account__r.CPD_Opportunity_Closed_Value__c;
                    cWrapper.FlavorClosedOppVl += dAll.Customer_Account__r.FLAVOR_Opportunity_Closed_Value__c;
                    cWrapper.PlantClosedOppVl += dAll.Customer_Account__r.PLANT_BASED_Opportunity_Closed_Value__c;
                    cWrapper.SpdclosedOppVl += dAll.Customer_Account__r.SPD_Opportunity_Closed_Value__c;
                    
                    parentCalculationOppMap.put(dAll.Distributor_Account__c, cWrapper);
                    system.debug(' parentCalculationOppMap -->> ' + parentCalculationOppMap);                    
                    system.debug(' cWrapper 1st -->> ' + cWrapper);                    
                }
                else{
                    parentChildWrapper cWrapper = parentCalculationOppMap.get(dAll.Distributor_Account__c);
                    cWrapper.TotalClosedOpp += dAll.Customer_Account__r.Number_of_closed_opportunity__c;
                    cWrapper.TotalOpenOpp += dAll.Customer_Account__r.Number_of_open_opportunity__c;
                    cWrapper.TotalOpp += dAll.Customer_Account__r.Number_of_Total_Opportunity__c;
                    cWrapper.TotalWonOpp += dAll.Customer_Account__r.Number_Of_Won_Opportunity__c;
                    cWrapper.TotalWonPartialOpp += dAll.Customer_Account__r.Number_of_won_opportunity_partially_exec__c;
                    cWrapper.ClosedOppVl += dAll.Customer_Account__r.Closed_Opportunity_Value__c;
                    cWrapper.ColorClosedOppVl += dAll.Customer_Account__r.COLOR_Opportunity_Closed_Value__c;
                    cWrapper.CpdClosedOppVl += dAll.Customer_Account__r.CPD_Opportunity_Closed_Value__c;
                    cWrapper.FlavorClosedOppVl += dAll.Customer_Account__r.FLAVOR_Opportunity_Closed_Value__c;
                    cWrapper.PlantClosedOppVl += dAll.Customer_Account__r.PLANT_BASED_Opportunity_Closed_Value__c;
                    cWrapper.SpdclosedOppVl += dAll.Customer_Account__r.SPD_Opportunity_Closed_Value__c;
                    
                    system.debug(' parentCalculationOppMap  22 -->> ' + parentCalculationOppMap);                    
                    system.debug(' cWrapper 2nd -->> ' + cWrapper);
                    
                }
            }
            
            system.debug('parentCalculationOppMap -->> ' + parentCalculationOppMap);
            
            List<Account> distAccList = [SELECT Id, Number_of_closed_opportunity_new__c, Number_of_open_opportunity_new__c, Number_of_Total_Opportunity_new__c, Number_Of_Won_Opportunity_new__c, Number_of_won_opportunity_partially_new__c, 
                                         Closed_Opportunity_Value_New__c, COLOR_Opportunity_Closed_Value_New__c, CPD_Opportunity_Closed_Value_New__c, FLAVOR_Opportunity_Closed_Value_New__c, PLANT_BASED_Opportunity_Closed_Value_New__c, SPD_Opportunity_Closed_Value_New__c 
                                         FROM Account WHERE Id IN: distributorAccIdSet];
            for(Account parentAcc : distAccList){                
                if(parentCalculationOppMap.containsKey(parentAcc.Id)){
                    parentChildWrapper cWrapper = parentCalculationOppMap.get(parentAcc.Id);
                    parentAcc.Number_of_closed_opportunity_new__c = cWrapper.TotalClosedOpp;
                    parentAcc.Number_of_open_opportunity_new__c = cWrapper.TotalOpenOpp;
                    parentAcc.Number_of_Total_Opportunity_new__c = cWrapper.TotalOpp;
                    parentAcc.Number_Of_Won_Opportunity_new__c = cWrapper.TotalWonOpp;
                    parentAcc.Number_of_won_opportunity_partially_new__c = cWrapper.TotalWonPartialOpp;
                    parentAcc.Closed_Opportunity_Value_New__c = cWrapper.ClosedOppVl;
                    parentAcc.COLOR_Opportunity_Closed_Value_New__c = cWrapper.ColorClosedOppVl;
                    parentAcc.CPD_Opportunity_Closed_Value_New__c = cWrapper.CpdClosedOppVl;
                    parentAcc.FLAVOR_Opportunity_Closed_Value_New__c = cWrapper.FlavorClosedOppVl;
                    parentAcc.PLANT_BASED_Opportunity_Closed_Value_New__c = cWrapper.PlantClosedOppVl;
                    parentAcc.SPD_Opportunity_Closed_Value_New__c = cWrapper.SpdclosedOppVl;
                }
            }
            if(distAccList.size() > 0)
                update distAccList;
        }
    }
    
    public class parentChildWrapper{
        Public Decimal TotalClosedOpp = 0;
        Public Decimal TotalOpenOpp = 0;
        Public Decimal TotalOpp = 0;
        Public Decimal TotalWonOpp = 0;
        Public Decimal TotalWonPartialOpp = 0;
        Public Decimal ClosedOppVl = 0;
        Public Decimal ColorClosedOppVl = 0;
        Public Decimal CpdClosedOppVl = 0;
        Public Decimal FlavorClosedOppVl = 0;
        Public Decimal PlantClosedOppVl = 0;
        Public Decimal SpdclosedOppVl = 0;        
    }
    
}