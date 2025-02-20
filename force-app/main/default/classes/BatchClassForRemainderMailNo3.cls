/**
 * @description       : 
 * @author            : Dhanush Babu
 * @group             : 
 * @last modified on  : 02-20-2024
 * @last modified by  : Dhanush Babu
**/
Global class BatchClassForRemainderMailNo3 implements Database.Batchable<sObject> {

    //Reminder Mail No. 3

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select Id,Name,Remainder_Sent_Date__c,StageName,OwnerId,CreatedDate,AccountId,Account.Name,CloseDate FROM Opportunity Where Remainder_Sent_Date__c != null and StageName !='Closed Lost' and StageName !='Closed Won' and RecordType.name = 'Parent']); 
    }

    global void execute(Database.BatchableContext bc, List<Opportunity> OppList){   
        
        List<Opportunity> updateOpp = new List<Opportunity>();
        Map<Id,List<Opportunity>> oppMapList = new Map<ID,List<Opportunity>>();
        Boolean sendNotification = false;
        
        for(Opportunity oppRec : OppList){
            Date d = oppRec.Remainder_Sent_Date__c.addDays(10);
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
        System.debug(' Batch to close all the opportunities after 10 days of Reminder sent');        
    }

    public static void sendEmailToOwnersAccount(Map<Id,List<Opportunity>> oppMapList){
        
        System.debug('oppMapList---->'+oppMapList);
        
        try{
            //Map<ID, Opportunity> oppMap = new Map<ID, Opportunity>([SELECT ID,Name,AccountId,Account.Name,CloseDate,CreatedDate FROM Opportunity]);
            OrgWideEmailAddress owea = [ SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName = 'Symega Food Ingredients Limited' ];
                 system.debug('owea--->'+owea);
            Map<ID, User> userMap = new Map<ID, User>([SELECT ID,LastName,FirstName,Email FROM User]);
            List<Messaging.SingleEmailMessage> semList = new List<Messaging.SingleEmailMessage>(); 
            
            for(ID keyS: oppMapList.keySet()){            
                Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                mymail.setToAddresses(new string[]  {userMap.get(keyS).Email} );  
              //  mymail.setSenderDisplayName('Symega'); 
                mymail.setSubject('Final Reminder - Opportunity closure date lapse');
              //  mymail.setReplyTo(UserInfo.getUserEmail()); //recently Added
               // mymail.setSaveAsActivity(false);
                mymail.setReplyTo(owea.Address);
                mymail.setOrgWideEmailAddressId(owea.Id);
                
                String emailBody = 'Hi ' + userMap.get(keyS).FirstName + ',';
                emailBody += '<br> <br> This is last and final Reminder Mail no. 3.';
                emailBody += ' <br> <br>We observe there is no status change since last reminder mails for the below opportunities : ';
                List<Opportunity> relatedOwnerRec = oppMapList.get(keyS);
                emailBody += '<br><br> <table border="2" style="border-collapse: collapse"><tr><th>Opportunity Name</th><th>Created Date</th><th>Proposed Closed Date</th><th>Account Name</th></tr>';  // <td>' + gdResult + '</td><td>' + piResult + '</td></tr>';
                for(opportunity oppRec:relatedOwnerRec){
                    String oppName = ' <br><a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+oppRec.Id+'">'+ oppRec.Name +'</a><br>' ;  
                    emailBody += '<tr><td Style="padding-left: 10px;  padding-bottom: 20px;">' + oppName  + '</td><td Style="padding-left: 10px;">' + oppRec.CreatedDate + '</td><td Style="padding-left: 10px;">' + oppRec.CloseDate + '</td><td Style="padding-left: 10px;">' +  oppRec.Account.Name + '</td></tr>'; 
                }
                
                emailBody += '</table>';

                emailBody += ' <br> <br> Kindly note that 2 reminders have already been sent, if no update this opportunity will auto close tomorrow';
                emailBody += ' <br> <br> Note : If this opportunity is not active, please update stage as Closed lost.';
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