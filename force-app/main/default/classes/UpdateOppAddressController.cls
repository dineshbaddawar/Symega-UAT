public class UpdateOppAddressController {

    @AuraEnabled
    Public Static Opportunity getOpportunityRecord(String oppId){
          Opportunity oppRec;
        try{
            oppRec = [SELECT ID,Name,AccountId,Account_Billing_Address__c,Account_Shipping_Address__c,Customer_Billing_Address__c,Customer_Shipping_Address__c,Billing_City__c,Billing_Country__c,Billing_Postal_Code__c,Billing_State__c,Billing_Street__c,
                       Shipping_City__c, Shipping_Country__c,Shipping_Postal_Code__c,Shipping_State__c,Shipping_Street__c
                        FROM Opportunity  WHERE Id =:oppId];
        }catch(Exception e){
            system.debug('Exception Line Number-->'+e.getLineNumber());
            System.debug('Exception message-->'+e.getMessage());
        }
         return oppRec;
    }

    @AuraEnabled
    public static String getAccountId(String accId , String oppId,String dispId){
        System.debug('accId--->'+accId);
         System.debug('oppId--->'+oppId);
          System.debug('dispId--->'+dispId);
        String result;
        Account acc;
        Dispatch_Address__c daRec;
        Opportunity oppRec = new Opportunity();
        Dispatch_Address__c  disp ;
        try{
        if(accId != null){
             acc =[Select Id,BillingState,BillingCity,BillingStreet,BillingCountry,BillingPostalCode FROM Account WHERE ID =:accId];
                oppRec.Id = oppId;
                oppRec.Billing_City__c        =   acc.BillingCity;
                oppRec.Billing_State__c       =   acc.BillingState;
                oppRec.Billing_Street__c      =   acc.BillingStreet;
                oppRec.Billing_Country__c    =   acc.BillingCountry;
                oppRec.Billing_Postal_Code__c =   acc.BillingPostalCode;
                 update  oppRec;
        }else{
          disp = [SELECT ID,tolabel(Address__CountryCode__s),tolabel(Address__StateCode__s),Address__Street__s, Address__City__s,Address__PostalCode__s FROM Dispatch_Address__c where ID =:dispId ];
            System.debug('-->'+disp);
                oppRec.Id = oppId;
                oppRec.Billing_City__c        =   disp.Address__City__s;
                oppRec.Billing_State__c       =   disp.Address__StateCode__s;
                oppRec.Billing_Street__c      =   disp.Address__Street__s;
                oppRec.Billing_Country__c    =   disp.Address__CountryCode__s;
                oppRec.Billing_Postal_Code__c =   disp.Address__PostalCode__s;
                 update  oppRec;
        }   


         List<Project__c> projectList = [SELECT ID,Sample_Name__c,Billing_City__c,Billing_State__c,Billing_Street__c,
                                             Billing_Country__c,Billing_Postal_Code__c FROM Project__c WHERE Opportunity__c =:oppId];
         
           List<Project__c> updateProjList = new  List<Project__c>();

            if(projectList != null){
                for(Project__c prjRec : projectList){
                    prjRec.Billing_City__c =  oppRec.Billing_City__c;
                    prjRec.Billing_State__c =  oppRec.Billing_State__c;
                    prjRec.Billing_Street__c = oppRec.Billing_Street__c;
                    prjRec.Billing_Country__c = oppRec.Billing_Country__c;
                    prjRec.Billing_Postal_Code__c =  oppRec.Billing_Postal_Code__c;
                    updateProjList.add(prjRec);
                }
                 if(updateProjList != null)
                  update updateProjList;
                  result ='SUCCESS';
            }

        }catch(Exception e){
            system.debug('Exception Line Number-->'+e.getLineNumber());
            System.debug('Exception message-->'+e.getMessage());
            result = e.getMessage();
        }
           return result;
    }

     @AuraEnabled
    public static String getAccountShipping(String accId , String oppId,String dispId){
        System.debug('accId--->'+accId);
         System.debug('oppId--->'+oppId);
          System.debug('dispId--->'+dispId);
        String result;
        Account acc;
        Dispatch_Address__c daRec;
        Opportunity oppRec = new Opportunity();
        Dispatch_Address__c  disp ;
        try{
        if(accId != null){
             acc =[Select Id,ShippingCity,ShippingState,ShippingStreet,ShippingCountry,ShippingPostalCode,BillingState,BillingCity,BillingStreet,BillingCountry,BillingPostalCode FROM Account WHERE ID =:accId];
                oppRec.Id = oppId;
                oppRec.Shipping_City__c        =   acc.ShippingCity;
                oppRec.Shipping_State__c       =   acc.ShippingState;
                oppRec.Shipping_Street__c      =   acc.ShippingStreet;
                oppRec.Shipping_Country__c    =   acc.ShippingCountry;
                oppRec.Shipping_Postal_Code__c =   acc.ShippingPostalCode;
                 update  oppRec;
        }else{
          disp = [SELECT ID,tolabel(Address__CountryCode__s),tolabel(Address__StateCode__s),Address__Street__s, Address__City__s,Address__PostalCode__s FROM Dispatch_Address__c where ID =:dispId ];
            System.debug('-->'+disp);
                oppRec.Id = oppId;
                oppRec.Shipping_City__c        =   disp.Address__City__s;
                oppRec.Shipping_State__c       =   disp.Address__StateCode__s;
                oppRec.Shipping_Street__c      =   disp.Address__Street__s;
                oppRec.Shipping_Country__c    =   disp.Address__CountryCode__s;
                oppRec.Shipping_Postal_Code__c =   disp.Address__PostalCode__s;
                 update  oppRec;
        }   


         List<Project__c> projectList = [SELECT ID,Sample_Name__c,Billing_City__c,Billing_State__c,Billing_Street__c,Billing_Country__c,Billing_Postal_Code__c,
         City__c,State__c, Street__c,Country__c,Postal_Code__c FROM Project__c WHERE Opportunity__c =:oppId];
         
           List<Project__c> updateProjList = new  List<Project__c>();

            if(projectList != null){
                for(Project__c prjRec : projectList){
                    prjRec.City__c =  oppRec.Shipping_City__c;
                    prjRec.State__c =  oppRec.Shipping_State__c;
                    prjRec.Street__c = oppRec.Shipping_Street__c;
                    prjRec.Country__c = oppRec.Shipping_Country__c;
                    prjRec.Postal_Code__c =  oppRec.Shipping_Postal_Code__c;
                    updateProjList.add(prjRec);
                }
                 if(updateProjList != null)
                  update updateProjList;
                  result ='SUCCESS';
            }

        }catch(Exception e){
            system.debug('Exception Line Number-->'+e.getLineNumber());
            System.debug('Exception message-->'+e.getMessage());
            result = e.getMessage();
        }
           return result;
    }

    @AuraEnabled
    public static String updateOpportunityRecord(string recId,String billingCity,String billingState,String billingStreet,String billingCountry,String billingPostal){
         
         System.debug('recId--->'+recId);
         System.debug('billingCity--->'+billingCity);
         System.debug('billingState--->'+billingState);
         System.debug('billingStreet--->'+billingStreet);
         System.debug('billingCountry--->'+billingCountry);
         System.debug('billingPostal--->'+billingPostal);
        String result;
        map<String,String> countrymap = new map<String,String>();
        try{
            List<CountryList__mdt> countList = [select id,label,value__c from CountryList__mdt];

            for(CountryList__mdt cl : countList){
                countrymap.put(cl.label,cl.value__c);
            }

            opportunity oppRec = new  Opportunity();
            oppRec.Id = recId;
            oppRec.CloseDate = System.today();
            oppRec.Billing_City__c = billingCity;
            oppRec.Billing_State__c = billingState;
            oppRec.Billing_Street__c =billingStreet;
            oppRec.Shipping_Country__c = billingCountry;
            oppRec.Billing_Postal_Code__c = billingPostal;
            update oppRec;           

         opportunity oppRecord = [SELECT ID,AccountId,Account_Billing_Address__c,Account_Shipping_Address__c,Customer_Billing_Address__c,Name,Billing_City__c,Billing_Country__c,Billing_Postal_Code__c,Billing_State__c,Billing_Street__c,
                       Shipping_City__c, Shipping_Country__c,Shipping_Postal_Code__c,Shipping_State__c,Shipping_Street__c
                        FROM Opportunity  WHERE Id =:recId];

            if(oppRecord.Account_Billing_Address__c){
              
          //   string country =  Utility.getPickVal('Account','BillingCountryCode').get(billingCountry);
         //    String state =  Utility.getPickVal('Account','BillingStateCode').get(billingState);
          //   System.debug('country-->'+country);
          //   System.debug('state-->'+state);
              Account acc = new Account();
              acc.Id = oppRecord.AccountId;
              acc.BillingCity = billingCity;
              acc.BillingState = billingState ; //state ; //;
              acc.BillingStreet = billingStreet;
              acc.BillingCountry =  billingCountry; //country; //
              acc.BillingPostalCode = billingPostal;
              update  acc ;
            }else{
                //   string countrydis = Utility.getPickVal('Dispatch_Address__c','Address__CountryCode__s').get(billingCountry);
                //     string statedis = Utility.getPickVal('Dispatch_Address__c','Address__StateCode__s').get(billingState);
                if(oppRecord.Customer_Billing_Address__c != null){
                    Dispatch_Address__c dispatchAd  = new Dispatch_Address__c();
                    dispatchAd.Id = oppRecord.Customer_Billing_Address__c;
                    dispatchAd.Address__Street__s = billingStreet;
                    dispatchAd.Address__City__s = billingCity;
                    dispatchAd.Address__PostalCode__s = billingPostal;
                    dispatchAd.Address__CountryCode__s = billingCountry;// countrydis;  //countrymap.get(billingCountry); // set country code - IN For india  
                    dispatchAd.Address__StateCode__s =billingState; // billingState; // billingState;
                    update dispatchAd;

                }
                
            }

             List<Project__c> projectList = [SELECT ID,Sample_Name__c,Billing_City__c,Billing_State__c,Billing_Street__c,
                                             Billing_Country__c,Billing_Postal_Code__c FROM Project__c WHERE Opportunity__c =:recId];
              List<Project__c> updateProjList = new  List<Project__c>();

            if(projectList != null){
                for(Project__c prjRec : projectList){
                    prjRec.Billing_City__c = billingCity;
                    prjRec.Billing_State__c = billingState;
                    prjRec.Billing_Street__c = billingStreet;
                    prjRec.Billing_Country__c = billingCountry;
                    prjRec.Billing_Postal_Code__c = billingPostal;
                    updateProjList.add(prjRec);
                }
                 if(updateProjList != null)
                  update updateProjList;
            }
             
            result = 'SUCCESS';

        }catch(Exception e){
                system.debug('Exception Line Number-->'+e.getLineNumber());
                System.debug('Exception message-->'+e.getMessage());
                result = e.getMessage();
        }
        
          return result;
    }

    @AuraEnabled
    public static String updateOpportunityShipRecord(string recId,String shippingCity,String shippingState,String shippingStreet,String shippingCountry,String shippingPostal){
         
         System.debug('recId--->'+recId);
         System.debug('billingCity--->'+shippingCity);
         System.debug('billingState--->'+shippingState);
         System.debug('billingStreet--->'+shippingStreet);
         System.debug('billingCountry--->'+shippingCountry);
         System.debug('billingPostal--->'+shippingPostal);
        String result;
          map<String,String> countrymap = new map<String,String>();
        try{
            List<CountryList__mdt> countList = [select id,label,value__c from CountryList__mdt];

            for(CountryList__mdt cl : countList){
                countrymap.put(cl.label,cl.value__c);
            }
            opportunity oppRec = new  Opportunity();
            oppRec.Id = recId;
            oppRec.CloseDate = System.today();
            oppRec.Billing_City__c = shippingCity;
            oppRec.Billing_State__c = shippingState;
            oppRec.Billing_Street__c =shippingStreet;
            oppRec.Shipping_Country__c = shippingCountry;
            oppRec.Billing_Postal_Code__c = shippingPostal;
            update oppRec;           

         opportunity oppRecord = [SELECT ID,Customer_Shipping_Address__c,Account_Billing_Address__c,Account_Shipping_Address__c,Customer_Billing_Address__c,AccountId,Name,Billing_City__c,Billing_Country__c,Billing_Postal_Code__c,Billing_State__c,Billing_Street__c,
                       Shipping_City__c, Shipping_Country__c,Shipping_Postal_Code__c,Shipping_State__c,Shipping_Street__c
                        FROM Opportunity  WHERE Id =:recId];

            if(oppRecord.Account_Shipping_Address__c){
              
              Account acc = new Account();
              acc.Id = oppRecord.AccountId;
              acc.ShippingCity = shippingCity;
              acc.ShippingState = shippingState;
              acc.ShippingStreet = shippingStreet;
              acc.ShippingCountry = shippingCountry;
              acc.ShippingPostalCode = shippingPostal;
              update  acc ;
            }else{
                if(oppRecord.Customer_Shipping_Address__c != null){
                    Dispatch_Address__c dispatchAd  = new Dispatch_Address__c();
                    dispatchAd.Id = oppRecord.Customer_Shipping_Address__c;
                    dispatchAd.Address__Street__s = shippingStreet;
                    dispatchAd.Address__City__s = shippingCity;
                    dispatchAd.Address__PostalCode__s = shippingPostal;
                    dispatchAd.Address__CountryCode__s =  countrymap.get(shippingCountry); // set country code - IN For india  
                    update dispatchAd;
                }
            }

             List<Project__c> projectList = [SELECT ID,Sample_Name__c,Billing_City__c,Billing_State__c,Billing_Street__c,
                                             Billing_Country__c,Billing_Postal_Code__c,City__c,Country__c,Postal_Code__c,State__c,Street__c FROM Project__c WHERE Opportunity__c =:recId];
              List<Project__c> updateProjList = new  List<Project__c>();

            if(projectList != null){
                for(Project__c prjRec : projectList){
                    prjRec.City__c = shippingCity;
                    prjRec.State__c = shippingState;
                    prjRec.Street__c = shippingStreet;
                    prjRec.Country__c = shippingCountry;
                    prjRec.Postal_Code__c = shippingPostal;
                    updateProjList.add(prjRec);
                }
                 if(updateProjList != null)
                  update updateProjList;
            }
             
            result = 'SUCCESS';

        }catch(Exception e){
                system.debug('Exception Line Number-->'+e.getLineNumber());
                System.debug('Exception message-->'+e.getMessage());
                result = e.getMessage();
        }
        
          return result;
    }

}