public without sharing class SubmitOpportunityForApprovalController {
    public SubmitOpportunityForApprovalController() {
        
    }
    
    @AuraEnabled
    public Static String intiateApprovalProcess(String oppId){
        Savepoint sp = Database.setSavepoint();
        String result;
        try{
            
            List<Opportunity> newOppList = [SELECT Id, Approver_Name__c,Markdown_Total_Unit_Price__c,Markdown_Total_List_Price__c, RecordType.DeveloperName, Owner.UserRole.Name, Approved_by_Manager__c, Approved_by_MD__c, Approved_by_Business_Head__c, Owner.ManagerId, Owner.UserRoleId
                                            FROM opportunity WHERE Id =: oppId LIMIT 1];
            Map<Id, Approval.ProcessSubmitRequest> oppToapprovalRequestMap = new Map<Id, Approval.ProcessSubmitRequest>();
            Map<Id,UserRole> userRoleMap = new Map<Id,UserRole>([SELECT Id, ParentRoleId, Name FROM UserRole]);
            Map<Id,Id> oppTomdApprovalRoleIdMap = new Map<Id,Id>();
            Map<Id, User> userByIdMap = new Map<Id, User>([SELECT Id, Name FROM User]);
            
            LeadApprovalUtility.OpportunityApprovalWrapper approvalBHWrapper = LeadApprovalUtility.getUserBHMap(); //Has all User -> BH
            LeadApprovalUtility.OpportunityApprovalWrapper approvalMDWrapper = LeadApprovalUtility.getUserMDMap(); //Has all User -> MD
            
            Map<Id, ApprovalWrapper> mdApprovalMap = new Map<Id, ApprovalWrapper>();
            List<ApprovalWrapper> managerApprovalOppList = new List<ApprovalWrapper>();
            List<ApprovalWrapper> bhApprovalOppList = new List<ApprovalWrapper>();
            Map<Id, ApprovalWrapper> bhApprovalFutureOppMap = new Map<Id, ApprovalWrapper>();
            List<Opportunity> oppUpdateList = new List<Opportunity>();
            List<Opportunity> oppUpdateList2 = new List<Opportunity>();
            
            List<ApprovalWrapper> bhApprovalOppListAnnual = new List<ApprovalWrapper>();
            
            if(!newOppList.isEmpty()) {
                for(opportunity opp : newOppList) {
                    
                    Id oppOwnersRoleId = opp.Owner.UserRoleId;
                    Id managerId = opp.Owner.ManagerId;
                    Id businessHeadId = approvalBHWrapper.smToManagerMap.containsKey(oppOwnersRoleId) && approvalBHWrapper.managerRoleToUserIdMap.containsKey(approvalBHWrapper.smToManagerMap.get(oppOwnersRoleId)) ? approvalBHWrapper.managerRoleToUserIdMap.get(approvalBHWrapper.smToManagerMap.get(oppOwnersRoleId)) : null; //userBhMap.containsKey(oppOwnersRoleId) ? userBhMap.get(oppOwnersRoleId) : null;
                    Id mdId = approvalMDWrapper.smToManagerMap.containsKey(oppOwnersRoleId) && approvalMDWrapper.managerRoleToUserIdMap.containsKey(approvalMDWrapper.smToManagerMap.get(oppOwnersRoleId)) ? approvalMDWrapper.managerRoleToUserIdMap.get(approvalMDWrapper.smToManagerMap.get(oppOwnersRoleId)) : null; //getUserMDMap.containsKey(oppOwnersRoleId) ? userBhMap.get(oppOwnersRoleId) : null;
                    
                    system.debug('businessHeadId: ' + businessHeadId);
                    if(oppOwnersRoleId == null) {
                        System.debug('couldnt find this opp owner\'s / BH role Id');
                        return 'couldnt find this opp owner\'s Id';
                        //continue;
                    }
                    //2nd is second level approval
                    //if required third level approval
                    
                    //1st use case is initial submission
                    System.debug('--- Testing : :  ');
                    
                    if(opp.Markdown_Total_Unit_Price__c > opp.Markdown_Total_List_Price__c)
                        return 'List Price is less than the Sales Price';
                    if(opp.Markdown_Total_Unit_Price__c == opp.Markdown_Total_List_Price__c)
                        return 'List Price is same as the Sales Price';
                    
                    if(opp.Markdown_Total_Unit_Price__c != null && opp.Markdown_Total_Unit_Price__c < opp.Markdown_Total_List_Price__c && opp.Markdown_Total_Unit_Price__c > 0 && opp.Markdown_Total_List_Price__c > 0 && opp.Approved_by_Business_Head__c == false && opp.Approved_By_Manager__c == false && opp.Approved_By_MD__c == false) {
                        //calculate %
                        Double difference = opp.Markdown_Total_List_Price__c - opp.Markdown_Total_Unit_Price__c;
                        System.debug('--- difference ' + difference);
                        Double markDownPercentage = (difference / opp.Markdown_Total_List_Price__c) * 100;
                        System.debug('--- markDownPercentage '+ markDownPercentage);		
                        //unchecking checkboxes because of re-add/update scenarios.
                        oppUpdateList.add(new Opportunity(Id = opp.Id, Markdown__c = markDownPercentage, Approved_by_Manager__c = false, Approved_by_Business_Head__c = false, Approved_By_MD__c = false));
                        
                        if(markDownPercentage > 0) {
                            if((managerId != null && managerId != businessHeadId && !opp.Owner.UserRole.Name.contains('Business Head')) || (managerId != null && opp.Owner.UserRole.Name.contains('Business Head'))) {
                                oppUpdateList2.add(new Opportunity(Id = opp.Id, Approver_Name__c = userByIdMap.get(managerId).Name, Is_Manual_Approval_Completed__c = TRUE));
                                managerApprovalOppList.add(new ApprovalWrapper(opp, managerId));
                            }
                            else {
                                if(businessHeadId != null){
                                    oppUpdateList2.add(new Opportunity(Id = opp.Id, Approver_Name__c = userByIdMap.get(businessHeadId).Name, Is_Manual_Approval_Completed__c = TRUE));
                                    bhApprovalOppList.add(new ApprovalWrapper(opp, businessHeadId));
                                }
                            }
                        }
                        else{
                            return 'Markdown % is 0 or less than 0.';
                        }
                    }
                }
                
                if(!oppUpdateList.isEmpty()){
                    update oppUpdateList;
                }
                if(!oppUpdateList2.isEmpty())
                    update oppUpdateList2;
                
                if(!managerApprovalOppList.isEmpty()) {
                    initiateManagerApproval(managerApprovalOppList, oppToapprovalRequestMap);
                    return 'success';
                }
                
                if(!bhApprovalOppList.isEmpty()) {
                    initiateBHApproval(bhApprovalOppList, oppToapprovalRequestMap);
                    return 'success';
                }
            }
            return 'Approval couldn\'t take place';
        }
        catch(exception ex){
            //Database.rollback(sp);
            system.debug('Error==>'+ex.getMessage());
            system.debug('Error>>><<'+ex.getLineNumber());
            HandleBusinessException.captureError('OppTriggerHandler', 'initiateApprovalProcess', ex);
            return result = ex.getMessage();
        }
        // return result;
    }
    
    
    private static void initiateManagerApproval(List<ApprovalWrapper> oppWrpList, Map<Id, Approval.ProcessSubmitRequest> oppToapprovalRequestMap) {
        
        for(ApprovalWrapper oppWrp: oppWrpList){
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitting for Manager price Approval.');
            req.setObjectId(oppWrp.opp.Id);
            req.setProcessDefinitionNameOrId('Manager_Approval');
            system.debug('opp.Owner.ManagerId----->'+oppWrp.approverId);
            
            req.setNextApproverIds(new List<Id> { oppWrp.approverId });
            oppToapprovalRequestMap.put(oppWrp.opp.Id, req);   
            
        }
        if(!oppToapprovalRequestMap.isEmpty())
            approvalInitiator(oppToapprovalRequestMap);
    }
    
    
    private static void initiateBHApproval(List<ApprovalWrapper> oppWrpList, Map<Id, Approval.ProcessSubmitRequest> oppToapprovalRequestMap) {
        for(ApprovalWrapper oppWrp: oppWrpList){
            
            Approval.ProcessSubmitRequest approvalReq = new Approval.ProcessSubmitRequest();
            approvalReq.setComments('Submitting for Business Head Price Approval.');
            approvalReq.setObjectId(oppWrp.opp.Id);
            approvalReq.setProcessDefinitionNameOrId('Business_Head_Approval');
            approvalReq.setNextApproverIds(new List<Id> {oppWrp.approverId});
            oppToapprovalRequestMap.put(oppWrp.opp.Id, approvalReq);
        }
        if(!oppToapprovalRequestMap.isEmpty())
            approvalInitiator(oppToapprovalRequestMap);
    }
    
    private static void approvalInitiator(Map<Id, Approval.ProcessSubmitRequest> oppToapprovalRequestMap) {
        if(!oppToapprovalRequestMap.isEmpty()) {
            try{
                List<Approval.ProcessResult> result = Approval.process(oppToapprovalRequestMap.values());
            }catch(Exception ex) {
                System.debug('--- Message'+ex.getMessage());
                System.debug('--- Line NO:'+ex.getLineNumber());
                HandleBusinessException.captureError('OpportunityTriggerHandler', 'initiateSecondPricingApproval', ex);
            }
        }
    }
    
    class ApprovalWrapper {
        public Opportunity opp;
        public Id approverId;
        
        public ApprovalWrapper(Opportunity opp, Id approverId) {
            this.opp = opp;
            this.approverId = approverId;
        }
    }
    
    
}