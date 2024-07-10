Global class BatchClassForRemainderMailNo1 implements Database.Batchable<sObject> {
    
    //Reminder Mail No. 1   BatchClassForOpportunityOwner 
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select Id, Name, CloseDate, StageName, OwnerId,CreatedDate,AccountId,Account.Name FROM Opportunity Where AccountId != null and CloseDate = YESTERDAY and StageName != 'Closed Won' and StageName != 'Closed Lost' and RecordType.name = 'Parent']); 
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> OppList){   
        try{
            System.debug('OppList---->'+OppList);
            Map<Id,List<Opportunity>> oppMapList = new Map<ID,List<Opportunity>>();
            List<Task> tskList = new list<Task>();
            for(Opportunity oppRec: OppList){
                oppRec.Remainder_Sent_Date__c = System.today();
                
                if(!oppMapList.containsKey(oppRec.OwnerId)){
                    oppMapList.put(oppRec.OwnerId,new List<Opportunity>{oppRec});
                }
                else{
                    oppMapList.get(oppRec.OwnerId).add(oppRec);
                }
                
                Task taskRec = new Task();
                taskRec.Subject = 'Close the opportunity, if potential';
                taskRec.OwnerId =  oppRec.OwnerId;
                taskRec.ActivityDate = System.today().addDays(5); 
                taskRec.Status = 'Open';
                taskRec.WhatId = oppRec.Id;
                tskList.add(taskRec);
            }
            insert tskList;
            Update OppList;
            sendEmailToOwnersAccount(oppMapList);
        }
        catch(Exception e){
            System.debug('Exception Line Number-->'+e.getLineNumber());
            System.debug('Exception-->'+e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('Sending Reminder Mail No. 1 to Opportunity Owners');   
    } 
    
    public static void sendEmailToOwnersAccount(Map<Id,List<Opportunity>> oppMapList){
        
        try{
           // Map<ID, Opportunity> oppMap = new Map<ID, Opportunity>([SELECT ID,Name,AccountId,Account.Name,CloseDate,CreatedDate FROM Opportunity]);
            
            Map<ID, User> userMap = new Map<ID, User>([SELECT ID,LastName,FirstName,Email FROM User]);
            List<Messaging.SingleEmailMessage> semList = new List<Messaging.SingleEmailMessage>(); 
             OrgWideEmailAddress owea = [ SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName = 'Symega Food Ingredients Limited' ];
                 system.debug('owea--->'+owea);
            for(ID keyS: oppMapList.keySet()){            
                Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                mymail.setToAddresses(new string[]  {userMap.get(keyS).Email} );  
               // mymail.setSenderDisplayName('Symega');
               // mymail.setReplyTo(UserInfo.getUserEmail()); //recently Added
                mymail.setSubject('Reminder mail no. 1 - Opportunities closure date lapse');
              //  mymail.setSaveAsActivity(false);
                 mymail.setReplyTo(owea.Address);
                mymail.setOrgWideEmailAddressId(owea.Id);
                String emailBody = 'Hi ' + userMap.get(keyS).FirstName + ',';
                emailBody += ' <br> <br> We observe that below Opportunities close date is lapsed.';         
                List<Opportunity> relatedOwnerRec = oppMapList.get(keyS);
                emailBody += '<br><br> <table border="2" style="border-collapse: collapse"><tr><th>Opportunity Name</th><th>Created Date</th><th>Proposed Closed Date</th><th>Account Name</th></tr>';  
                
                for(opportunity oppRec:relatedOwnerRec){
                    String oppName = ' <br><a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+oppRec.Id+'">'+ oppRec.Name +'</a><br>' ;  
                    emailBody += '<tr><td Style="padding-left: 10px;  padding-bottom: 10px;">' + oppName  + '</td><td Style="padding-left: 10px;">' + oppRec.CreatedDate + '</td><td Style="padding-left: 10px;">' + oppRec.CloseDate + '</td><td Style="padding-left: 10px;">' +  oppRec.Account.Name + '</td></tr>'; 
                } 
                
                emailBody += '</table>';
                emailBody += ' <br> <br> Please re-visit these opportunities and update the opportunities close date, if they are still active.';
                emailBody +=   '<br> <br> Note : If this opportunity is not active, please update stage as  Closed lost. This is Reminder mail no. 1.';
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