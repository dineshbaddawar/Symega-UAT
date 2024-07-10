Global class BatchClassForRemainderMailNo5 implements Database.Batchable<sObject> {
    
    //Remainder Mail No 5
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select Id,Name,LastStageChangeDate,StageName,OwnerId,CreatedDate,AccountId,Account.Name,CloseDate FROM Opportunity Where LastStageChangeDate != null and StageName !='Closed Lost' and StageName !='Closed Won' and RecordType.name = 'Parent']); 
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> OppList){   
        
        List<Opportunity> updateOpp = new List<Opportunity>();
        Map<Id,List<Opportunity>> oppMapList = new Map<ID,List<Opportunity>>();
        Boolean sendNotification = false;
        
        for(Opportunity oppRec : OppList){
            
            date d = Date.valueOf(oppRec.LastStageChangeDate.addDays(90));
            System.debug('d----->'+d); 
            if(d == System.today()){
                if(!oppMapList.containsKey(oppRec.OwnerId)){
                    oppMapList.put(oppRec.OwnerId,new List<Opportunity>{oppRec});
                }
                else{
                    oppMapList.get(oppRec.OwnerId).add(oppRec);
                }
            }       
        }
        sendEmailToOwnersAccount(oppMapList);
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug(' Batch to close all the opportunities after 90 days of no status change');        
    }   
    
    public static void sendEmailToOwnersAccount(Map<Id,List<Opportunity>> oppMapList){
        System.debug('oppMapList---->'+oppMapList);
        try{            
            Map<ID, User> userMap = new Map<ID, User>([SELECT ID,LastName,FirstName,Email FROM User]);
            List<Messaging.SingleEmailMessage> semList = new List<Messaging.SingleEmailMessage>(); 
             OrgWideEmailAddress owea = [ SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName = 'Symega Food Ingredients Limited' ];
                 system.debug('owea--->'+owea);
            for(ID keyS: oppMapList.keySet()){            
                Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                mymail.setToAddresses(new string[]  {userMap.get(keyS).Email} );  
              //  mymail.setSenderDisplayName('Symega'); 
                mymail.setSubject('Stage not changed - since 90 days');
               // mymail.setReplyTo(UserInfo.getUserEmail()); //recently Added
               // mymail.setSaveAsActivity(false);
                mymail.setReplyTo(owea.Address);
                mymail.setOrgWideEmailAddressId(owea.Id);
                
                String emailBody = 'Hi ' + userMap.get(keyS).FirstName + ',';
                emailBody += '<br> <br>We observe there is no status change for past 3 months for the below opportunities';
                List<Opportunity> relatedOwnerRec = oppMapList.get(keyS);
                emailBody += '<br><br> <table border="2" style="border-collapse: collapse"><tr><th>Opportunity Name</th><th>Created Date</th><th>Account Name</th><th>Last Stage Date</th></tr>';  // <td>' + gdResult + '</td><td>' + piResult + '</td></tr>';
                for(opportunity oppRec:relatedOwnerRec){
                    String oppName = ' <br><a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+oppRec.Id+'">'+ oppRec.Name +'</a><br>' ; 
                    date lastStageDAte = Date.valueOf(oppRec.LastStageChangeDate); 
                    emailBody += '<tr><td Style="padding-left: 10px;  padding-bottom: 20px;">' + oppName  + '</td><td Style="padding-left: 10px;">' + oppRec.CreatedDate + '</td><td Style="padding-left: 10px;">' +  oppRec.Account.Name + '</td><td Style="padding-left: 10px;">' + lastStageDAte + '</td> </tr>'; 
                }
                
                emailBody += '</table>';
                emailBody += ' <br> <br> Note : If these opportunities are active, please update stage and the progress, else if lost update as Closed lost.';
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