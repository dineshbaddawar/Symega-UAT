// Activity Lapse Batch 

Global class ActivityLapseBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, WhatId, Subject, OwnerId, Auto_Close__c, CreatedDate, What.Name, Who.Name, CreatedById, CreatedBy.Email, CreatedBy.Username FROM Task WHERE Status != 'Completed' AND ActivityDate = YESTERDAY AND Auto_Close__c = FALSE]); 
    }
    
    global void execute(Database.BatchableContext bc, List<Task> taskList){   
        try{
            System.debug('taskList----> ' + taskList);
            Map<Id, List<Task>> taskMapList = new Map<Id, List<Task>>();
            for(Task tskRec : taskList){
                if(!taskMapList.containsKey(tskRec.OwnerId)){
                    taskMapList.put(tskRec.OwnerId, New List<Task>{tskRec});
                }
                else{
                    taskMapList.get(tskRec.OwnerId).add(tskRec);
                }
            }
            notifyOnActivityLapse(taskMapList);
        }
        catch(Exception e){
            System.debug('Exception Line Number-->'+e.getLineNumber());
            System.debug('Exception-->'+e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('Sending Reminder Mail No. 1 to Opportunity Owners');   
    } 
    
    public static void notifyOnActivityLapse(Map<Id, List<Task>> taskMapList){
        try{            
            Map<ID, User> userMap = new Map<ID, User>([SELECT Id, LastName, FirstName, Email FROM User WHERE Id IN: taskMapList.keySet()]);
            List<Messaging.SingleEmailMessage> semList = new List<Messaging.SingleEmailMessage>(); 
            OrgWideEmailAddress owea = [ SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName = 'Symega Food Ingredients Limited' ];
            system.debug('owea--->'+owea);
            
            for(ID keyS : taskMapList.keySet()){            
                Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                mymail.setToAddresses(new string[]  {userMap.get(keyS).Email} );  
                mymail.setSubject('Activity Lapse');
                mymail.setReplyTo(owea.Address);
                mymail.setOrgWideEmailAddressId(owea.Id);
                String emailBody = 'Hi ' + userMap.get(keyS).FirstName + ',';
                emailBody += ' <br> <br> We observe that below Tasks Due Date is lapsed.';         
                List<Task> relatedOwnerRec = taskMapList.get(keyS);
                emailBody += '<br><br> <table border="2" style="border-collapse: collapse"><tr><th>Subject</th><th>Related To</th><th>Assigned Date</th> </tr>';  
                List<String> ccEmailIds = new List<String>();
                for(Task tskRec : relatedOwnerRec){
                    if(userMap.get(keyS).Email != tskRec.CreatedBy.Email && tskRec.CreatedBy.Username != 'ajeet@utilitarianlab.com')
                        ccEmailIds.add(tskRec.CreatedBy.Email);
                    String subject = ' <br><a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/' + tskRec.Id+'">'+ tskRec.Subject +'</a><br>' ;  
                    String relatedTo = tskRec.What.Name != null ? tskRec.What.Name : tskRec.Who.Name;
                    emailBody += '<tr></td><td Style="padding-left: 10px;  padding-bottom: 10px;">' + subject  + '</td><td Style="padding-left: 10px;">' + relatedTo + '</td><td Style="padding-left: 10px;">' + tskRec.CreatedDate + '</td></tr>'; 
                } 
                if(!ccEmailIds.isEmpty())
                    mymail.setCcAddresses(ccEmailIds);
                emailBody += '</table>';
                emailBody += ' <br> <br> Please re-visit these tasks.';
                emailBody += '<br> <br>  Regards';
                emailBody += '<br> Symega';
                mymail.setHtmlBody(emailBody);
                semList.add(mymail);
            }
            Messaging.sendEmail(semList);
        }
        catch(Exception e){
            System.debug('Exception Line Number-->'+e.getLineNumber());
            System.debug('Exception-->'+e.getMessage());
        }     
    }  
    
}