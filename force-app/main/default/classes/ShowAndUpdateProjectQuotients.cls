public class ShowAndUpdateProjectQuotients {
    
    @AuraEnabled
    public static List<Project_Quotient__c> showProjectQuotientRec(string proRecId){
        List<Project_Quotient__c> prolist;
        if(proRecId != null){
            prolist   = [Select Id, Name, Stage__c, Lost_Reason__c, Product_Name__c, SSC_Code__c, Email_Sent__c from Project_Quotient__c where Sample_Project_Application__c =: proRecId];
            if(prolist.size()>0){
                return prolist;
            }  
            
        }
        return null;
    }
    
    @AuraEnabled
    public static List<String> getStagePicklistValues() {
        Schema.DescribeFieldResult fieldResult = Project_Quotient__c.Stage__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        List<String> StageValues = new List<String>();
        
        for (Schema.PicklistEntry entry : picklistValues) {
            StageValues.add(entry.getValue());
        }
        
        return StageValues;
    }
    
    @AuraEnabled
    public static string updateProjectQuotientValues( List<Project_Quotient__c> projectlist, String projId){
        try{
            if(projectlist.size() > 0){
                               
                Integer wonQntCnt = 0;
                Integer lostQntCnt = 0;
                
                Project__c projectRec = [SELECT ID, OwnerId, Owner.FirstName, Owner.Email, Manager_Email__c, Name, Project_Name__c, Product_Family__c  FROM Project__c WHERE Id =: projId];
                List<Project_Quotient__c> wonProjQntlist = new List<Project_Quotient__c>();
                List<Project_Quotient__c> lostProjQntlist = new List<Project_Quotient__c>();
                
                update projectlist;
                
                system.debug('projectlist -- ' + projectlist);

                for(Project_Quotient__c pQnt :  projectlist){
                    if(!pQnt.Email_Sent__c){
                        if(pQnt.Stage__c == 'Won'){
                            wonQntCnt ++;
                            wonProjQntlist.add(pQnt);
                        }
                        if(pQnt.Stage__c == 'Lost'){
                            lostQntCnt ++;
                            lostProjQntlist.add(pQnt);
                        }
                    }
                }
                
                Map<string, Notification_Ids_Metadata__mdt	> getMDTByMap = new Map<string, Notification_Ids_Metadata__mdt	>();
                list<Notification_Ids_Metadata__mdt	> mdtList = Notification_Ids_Metadata__mdt.getAll().values();
                for (Notification_Ids_Metadata__mdt	 MDT : mdtList) {
                    getMDTByMap.put(MDT.Label, MDT);
                }  
                system.debug(' getMDTByMap -- ' + getMDTByMap);
                String emails = null;
                if(getMDTByMap.keySet().size() > 0 && getMDTByMap.get(projectRec.Product_Family__c) != null){
                    system.debug(' getMDTByMap.get(projectRec.Product_Family__c).Email_Ids__c--> '+ getMDTByMap.get(projectRec.Product_Family__c ).Email_Ids__c);
                    emails = getMDTByMap.get(projectRec.Product_Family__c ).Email_Ids__c;
                }
                List <String> emailRecipients = new List <String>(); 
                if(emails != null)
                    emailRecipients = emails.split(',');
                System.debug('emailRecipients-->'+emailRecipients);
                if(wonProjQntlist.size()>0){
                    sendWonEmail(projectRec, wonQntCnt, wonProjQntlist, emailRecipients);
                }
                if(lostProjQntlist.size()>0){
                    sendLostEmail(projectRec, lostQntCnt, lostProjQntlist, emailRecipients);
                }
                return 'success';                
            }
            return 'Please perform updation before saving';
        }
        catch(exception e){
            system.debug('Error Msg :: ' + e.getMessage());
            system.debug('Error Line No :: ' + e.getLineNumber());
            return e.getMessage();
        }
    }
    
    public static void sendWonEmail( Project__c projRec, Integer wonCount, List<Project_Quotient__c> projQntList, List <String> emailRecipients){
        try{
            
            String adminMail = null;
            list<Admin_Mail_Id__mdt> mdtList = Admin_Mail_Id__mdt.getAll().values();
            if(mdtList.size() >0 && mdtList[0].Email__c != null){
                adminMail = mdtList[0].Email__c;
            }
            
            system.debug('adminMail--->'+adminMail);
            
            List<Messaging.SingleEmailMessage> semList = new List<Messaging.SingleEmailMessage>(); 
            OrgWideEmailAddress owea = [ SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName = 'Symega Food Ingredients Limited' ];
            system.debug('owea--->'+owea);
            Messaging.SingleEmailMessage mymail;      
            mymail = new Messaging.SingleEmailMessage();
            String mailSubject ;
            mailSubject = projRec.Project_Name__c + '-'+ projRec.Name +' - ' + wonCount + ' - Project Quotients are Won';
            List<String> emailList = new List<String>();
            if(emailRecipients.size()>0)
                emailList = emailRecipients;
            
            emailList.add(projRec.Owner.Email);
            if(projRec.Manager_Email__c != null)
                emailList.add(projRec.Manager_Email__c);
            if(adminMail != null)
                emailList.add(adminMail);
            System.debug('emailList--->'+emailList);
            mymail.setToAddresses(emailList);            
          //  mymail.setSenderDisplayName('Symega');
            
            Symega_Configuration__c orgConfig = Symega_Configuration__c.getValues('Symega Configuration');
            String replyTo =  orgConfig.Symega_Email_Id__c == null ? projRec.Owner.Email : orgConfig.Symega_Email_Id__c;
           // mymail.setReplyTo(replyTo); 
           // //recently Added
             mymail.setReplyTo(owea.Address);
             mymail.setOrgWideEmailAddressId(owea.Id);
              mymail.setSubject(mailSubject);
           // mymail.setSaveAsActivity(false);   
            semList.add(mymail);  
            
            string htmlBody = 'Hi '+ projRec.Owner.FirstName +',' +'<br/>'+ '<br/>'+' The following Project Quotients are won, request to initiate commercialisation process and update.'+'<br/>';
            htmlBody += '<br><br> <table border="2" style="border-collapse: collapse"><tr><th>Project Quotient Name</th><th>Product Name</th><th>Product Code</th></tr>';
            
            for(Project_Quotient__c pqRec: projQntList){
                String qntName = '<html><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ pqRec.Id+'">'+ pqRec.Name+'</a></html>';
                String prodName = pqRec.Product_Name__c == null ? '' : pqRec.Product_Name__c;
                String sscCode = pqRec.SSC_Code__c == null ? '' : pqRec.SSC_Code__c;
                htmlBody += '<tr><td>' + qntName + '</td><td>' + prodName + '</td><td>' + sscCode + '</td></tr>' ; 
                if(!pqRec.Email_Sent__c)
                    pqRec.Email_Sent__c = true;
            }      
            update projQntList;
            
            htmlBody += '</table>';
            htmlBody += '<br><br> Thanks & Regards';
            htmlBody += '<br>Symega';
            mymail.setHtmlBody(htmlBody);
            
            if(semList != null){
                Messaging.sendEmail(semList);
                System.debug('Email Sent');
            }
        }
        catch(Exception e){
            System.debug('Exception Line Number--->'+e.getLineNumber());
            System.debug('Exception Message-->'+e.getMessage());
        }
    }
    
    public static void sendLostEmail( Project__c projRec, Integer lostCount, List<Project_Quotient__c> projQntList, List <String> emailRecipients){
        try{
            String adminMail = null;
            list<Admin_Mail_Id__mdt> mdtList = Admin_Mail_Id__mdt.getAll().values();
            if(mdtList.size() >0 && mdtList[0].Email__c != null){
                adminMail = mdtList[0].Email__c;
            }
            
            system.debug('adminMail--->'+adminMail);
            OrgWideEmailAddress owea = [ SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName = 'Symega Food Ingredients Limited' ];
            system.debug('owea--->'+owea);
            List<Messaging.SingleEmailMessage> semList = new List<Messaging.SingleEmailMessage>(); 
            Messaging.SingleEmailMessage mymail;      
            mymail = new Messaging.SingleEmailMessage();
            String mailSubject ;
            mailSubject = projRec.Project_Name__c + '-'+ projRec.Name +' - ' + lostCount + ' - Project Quotients are Lost';
            List<String> emailList = new List<String>();
            if(emailRecipients.size()>0)
                emailList = emailRecipients;
            
            emailList.add(projRec.Owner.Email);
            if(projRec.Manager_Email__c != null)
                emailList.add(projRec.Manager_Email__c);
            if(adminMail != null)
                emailList.add(adminMail);
            mymail.setToAddresses(emailList);            
          //  mymail.setSenderDisplayName('Symega');
            
            Symega_Configuration__c orgConfig = Symega_Configuration__c.getValues('Symega Configuration');
            String replyTo =  orgConfig.Symega_Email_Id__c == null ? projRec.Owner.Email : orgConfig.Symega_Email_Id__c;
          //  mymail.setReplyTo(replyTo); //recently Added
             mymail.setReplyTo(owea.Address);
             mymail.setOrgWideEmailAddressId(owea.Id);
            mymail.setSubject(mailSubject);
          //  mymail.setSaveAsActivity(false);   
            semList.add(mymail);  
            
            string htmlBody = 'Hi '+ projRec.Owner.FirstName +',' +'<br/>'+ '<br/>'+' The following Project Quotients are Rejected.'+'<br/>';
            htmlBody += '<br><br> <table border="2" style="border-collapse: collapse"><tr><th>Project Quotient Name</th><th>Product Name</th><th>Product Code</th><th>Rejection Reason</th></tr>';
            
            for(Project_Quotient__c pqRec: projQntList){
                String qntName = '<html><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ pqRec.Id+'">'+ pqRec.Name+'</a></html>';
                String prodName = pqRec.Product_Name__c == null ? '' : pqRec.Product_Name__c;
                String sscCode = pqRec.SSC_Code__c == null ? '' : pqRec.SSC_Code__c;
                String rejectionReason = pqRec.Lost_Reason__c;
                htmlBody += '<tr><td>' + qntName + '</td><td>' + prodName + '</td><td>' + sscCode + '</td><td>' + rejectionReason + '</td></tr>' ; 
                if(!pqRec.Email_Sent__c)
                    pqRec.Email_Sent__c = true;
            }
            
            update projQntList;

            htmlBody += '</table>';
            htmlBody += '<br><br> Thanks & Regards';
            htmlBody += '<br>Symega';
            mymail.setHtmlBody(htmlBody);
            
            if(semList != null){
                Messaging.sendEmail(semList);
                System.debug('Email Sent');
            }
        }
        catch(Exception e){
            System.debug('Exception Line Number--->'+e.getLineNumber());
            System.debug('Exception Message-->'+e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<String> getSampleStatusPicklistValues() {
        Schema.DescribeFieldResult fieldResult = Sample_Line_Item__c.Sample_Request_Status__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        List<String> StageValues = new List<String>();
        
        for (Schema.PicklistEntry entry : picklistValues) {
            StageValues.add(entry.getValue());
        }
        
        return StageValues;
    }
    
    @AuraEnabled
    public static List<Sample_Line_Item__c> showSamplelineRec(string proRecId){
        List<Sample_Line_Item__c> samplelist;
        if(proRecId != null){
            samplelist   = [Select id, Product_Name__c,Sample_Request_Status__c  from Sample_Line_Item__c where Sample__c =: proRecId];
            if(samplelist.size()>0){
                return samplelist;
            }  
            
        }
        return null;
    }
    
    @AuraEnabled
    public static string updateSamplelineItemValues( List<Sample_Line_Item__c> samplelineIemlist){
        try{
            update samplelineIemlist;
            return 'success';
        }
        catch(exception e){
            system.debug('Error Msg :: ' + e.getMessage());
            system.debug('Error Line No :: ' + e.getLineNumber());
            return e.getMessage();
        }
    }
}