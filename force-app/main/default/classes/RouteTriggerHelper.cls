public without sharing class RouteTriggerHelper {
    
    static RouteTriggerHelper handlerInstance;
    public static RouteTriggerHelper getInstance() {
        if(handlerInstance == null) 
            handlerInstance = new RouteTriggerHelper();
        return handlerInstance;
    }
    
    public void RouteDuplicateCheck(List<Route__c> routeList){
        Set<String> predefinedAreas = new Set<String>();
        for (Route__c route : routeList) {
            system.debug('route === >'+route);
            predefinedAreas.add(route.Predefined_Area__c);
        }
        
        
        Map<String, List<Route__c>> predefinedAreaToRoutes = new Map<String, List<Route__c>>();
        List<Predefined_Route__mdt> predefinedAreaRecords = [SELECT Predefined_Area__c,Sales_User__c FROM Predefined_Route__mdt];
        
        system.debug('predefinedAreas === >'+predefinedAreas);
        system.debug('UserInfo.getUserId() === >'+UserInfo.getUserId());
        
        for (Route__c existingRoute : [SELECT Id, Predefined_Area__c, Sales_User__c FROM Route__c WHERE Predefined_Area__c IN :predefinedAreas AND Sales_User__c = :UserInfo.getUserId()]) {
            system.debug('existingRoute === >'+existingRoute);
            if (!predefinedAreaToRoutes.containsKey(existingRoute.Predefined_Area__c)) {
                predefinedAreaToRoutes.put(existingRoute.Predefined_Area__c, new List<Route__c>());
            }
            predefinedAreaToRoutes.get(existingRoute.Predefined_Area__c).add(existingRoute);
        }
        
        for (Route__c newRoute : routeList) {
            if (predefinedAreaToRoutes.containsKey(newRoute.Predefined_Area__c)) {
                for (Route__c existingRoute : predefinedAreaToRoutes.get(newRoute.Predefined_Area__c)) {
                    if (existingRoute.Id != newRoute.Id) { 
                        newRoute.addError('A route with the same Predefined Area already exists for this sales user.');
                    }
                }
            }
        }
        
        // For Test class Extra Code
        /*Account acc = new Account();
acc.name = 'Testing';
insert acc;

Contact con = new Contact();
con.LastName = 'Venky ';
con.FirstName = 'test';
insert con;

Case caseObj = new Case(
Status = 'Working',
ContactId = con.id,
AccountId = acc.id,
Origin = 'Phone');
insert caseObj;*/
        
    }
    
    
}