public without sharing class ProjectQuotientController {
    
    static ProjectQuotientController handlerInstance;
    public static ProjectQuotientController getInstance() {
        if(handlerInstance == null) 
            handlerInstance = new ProjectQuotientController();
        return handlerInstance;
    }
    
    public void afterInsert(List<Project_Quotient__c> projQuoRec){
        try{
            Map<Id,Integer> projMap = new   Map<Id,Integer>(); 
            Set<Id> projectIds = new Set<Id>();
            
            for(Project_Quotient__c projRec : projQuoRec){
                if(projRec.Sample_Project_Application__c != null){
                    projectIds.add(projRec.Sample_Project_Application__c);
                }
            } 
            
            List<Project_Quotient__c> totalProjQuoList = [SELECT ID,Product_Name__c,SSC_Code__c, Sample_Project_Application__c,Name FROM Project_Quotient__c Where Sample_Project_Application__c In:projectIds];
            
            Map<Id,List<Project_Quotient__c>> projQMapList = new  Map<Id,List<Project_Quotient__c>>(); // projMapList();
            Integer  totalcount = totalProjQuoList.size();
            system.debug('totalProjQuoList--->'+totalProjQuoList.size());
            System.debug('totalcount--->'+totalcount);
            
            for(Project_Quotient__c projRec: totalProjQuoList){
                
                projMap.put(projRec.Sample_Project_Application__c,totalcount);
                
                if(!projQMapList.containsKey(projRec.Sample_Project_Application__c)){
                    projQMapList.put(projRec.Sample_Project_Application__c,new List<Project_Quotient__c>{projRec});
                }
                else{
                    projQMapList.get(projRec.Sample_Project_Application__c).add(projRec);
                }
            }
            
            if(projMap != null){
                sendEmail(projMap,projQMapList);       
            }
        }
        catch(exception e){
            system.debug('Error Msg :: ' + e.getMessage());
            system.debug('Error Line No :: ' + e.getLineNumber());
        }
    }
    
    public void sendEmail( Map<Id,Integer> projListmap,  Map<Id,List<Project_Quotient__c>> projQMapList){
        try{
            String adminMail = null;
            list<Admin_Mail_Id__mdt> mdtList = Admin_Mail_Id__mdt.getAll().values();
            if(mdtList.size() >0 && mdtList[0].Email__c != null){
                adminMail = mdtList[0].Email__c;
            }
            
            system.debug('adminMail--->'+adminMail);
                        
            Map<Id,Project__c>  ProjList = new Map<Id,Project__c>([SELECT ID, OwnerId, Owner.FirstName, Owner.Email, Manager_Email__c, Name, Quotient_Mail_Sent__c, Project_Name__c FROM Project__c where Quotient_Mail_Sent__c = false and Id In :projListmap.keyset()]);
            OrgWideEmailAddress owea = [ SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName = 'Symega Food Ingredients Limited' ];
            system.debug('owea--->'+owea);
            List<Messaging.SingleEmailMessage> semList = new List<Messaging.SingleEmailMessage>(); 
            Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();      
            List<Project__c> updateProjList = new List<Project__c>();
            for(Project__c projRec : ProjList.values()){
                //mymail = new Messaging.SingleEmailMessage();
                String mailSubject ;
                mailSubject = projRec.Project_Name__c + '-'+ projRec.Name +' - ' + projListmap.get(projRec.Id)+ ' - Project Quotients are added';
                if(projListmap.containsKey(projRec.Id) && projRec.Quotient_Mail_Sent__c == false){                    
                    List<String> emailList = new List<String>();
                    emailList.add(projRec.Owner.Email);
                    if(projRec.Manager_Email__c != null)
                        emailList.add(projRec.Manager_Email__c);
                    if(adminMail != null)
                        emailList.add(adminMail);
                    mymail.setToAddresses(emailList);            
                    //mymail.setSenderDisplayName('Symega');
                    
                    Symega_Configuration__c orgConfig = Symega_Configuration__c.getValues('Symega Configuration');
                   // String replyTo =  orgConfig.Symega_Email_Id__c == null ? projRec.Owner.Email : orgConfig.Symega_Email_Id__c;
                    // mymail.setReplyTo(replyTo); //recently Added
                    
                 mymail.setReplyTo(owea.Address);
                 mymail.setOrgWideEmailAddressId(owea.Id);
                    
                    mymail.setSubject(mailSubject);
                   // mymail.setSaveAsActivity(false);   
                    semList.add(mymail);  
                }
                system.debug('semList ====> '+semList);
                
                String projectName = '<html><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ projRec.Id+'">'+ projRec.Name+'</a></html>';
                
                string htmlBody = 'Hi '+ projRec.Owner.FirstName +',' +'<br/>'+ '<br/>'+' The project ' +projectName  +' is completed by R&D and ' + projListmap.get(projRec.Id) +' number of quotient is added.'+'<br/>';
                htmlBody += '<br><br> <table border="2" style="border-collapse: collapse"><tr><th>Project Quotient Name</th><th>Product Name</th><th>Product Code</th></tr>';
                
                for(Project_Quotient__c pqRec: projQMapList.get(projRec.Id)){
                    String prodName = pqRec.Product_Name__c == null ? '' : pqRec.Product_Name__c;
                    String sscCode = pqRec.SSC_Code__c == null ? '' : pqRec.SSC_Code__c;
                    htmlBody += '<tr><td>' + pqRec.Name + '</td><td>' + prodName + '</td><td>' + sscCode + '</td></tr>' ; 
                }          
                
                htmlBody += '</table>';
                htmlBody += '<br><br> Thanks & Regards';
                htmlBody += '<br>Symega';
                mymail.setHtmlBody(htmlBody);
                
                projRec.Quotient_Mail_Sent__c = true;
                updateProjList.add(projRec);
                
            }     
            if(semList != null){
                Messaging.sendEmail(semList);
                System.debug('Email Sent');
                update updateProjList;
                System.debug('Update List-->'+updateProjList);
            }
        }
        catch(Exception e){
            System.debug('Exception Line Number--->'+e.getLineNumber());
            System.debug('Exception Message-->'+e.getMessage());
        }
    }
    
}