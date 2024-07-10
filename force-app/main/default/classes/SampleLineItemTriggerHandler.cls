public without sharing class SampleLineItemTriggerHandler {
    
    static final String SHIPPING_COUNTRY_INDIA = 'India';
    
    static SampleLineItemTriggerHandler handlerInstance;
    
    public static SampleLineItemTriggerHandler getInstance() {
        if(handlerInstance == null) 
            handlerInstance = new SampleLineItemTriggerHandler();
        return handlerInstance;
    }
    
    
    public void processCalculation(List<Sample_Line_Item__c> newSLIList){
        
        set<Id> productIds = new set<Id>();
        set<Id> optivaIds = new set<Id>();
        set<Id> projQuoIds = new set<Id>();
        set<Id> sampleIds = new set<Id>();
        
        Map<Id,Product2> productsGSTMap ;
        Map<Id,OPTIVA_Recipe__c> optivaGSTMap;
        Map<Id,Project_Quotient__c> projectQuoGSTMap;
        Map<Id,Project__c> sampleMap;
        List<Sample_Line_Item__c> sliInsertList =  new  List<Sample_Line_Item__c>();
        try{
            
            for(Sample_Line_Item__c sli : newSLIList){
                if(sli.Product__c != null){ 
                    productIds.add(sli.Product__c);
                }
                if(sli.OPTIVA_Recipe__c != null){
                    optivaIds.add(sli.OPTIVA_Recipe__c);
                }
                if(sli.Project_Quotient__c != null){
                    projQuoIds.add(sli.Project_Quotient__c);
                }
                if(sli.Sample__c != null){
                    sampleIds.add(sli.Sample__c);
                }
            }
            
            if(productIds.size() > 0 )
                productsGSTMap = new Map<Id,Product2>([SELECT Id, List_Price__c, HSN_TAX__c FROM Product2 WHERE Id IN: productIds AND HSN_TAX__c > 0]);
            
            if(optivaIds.size() >0)
                optivaGSTMap = new map<Id,OPTIVA_Recipe__c>([SELECT ID FROM OPTIVA_Recipe__c WHERE ID IN:optivaIds ]);
            if(projQuoIds.size() >0){
                projectQuoGSTMap = new map<Id,Project_Quotient__c>([SELECT ID FROM Project_Quotient__c WHERE ID IN: projQuoIds]);
            }
            
            if(sampleIds.size() > 0){
                sampleMap = new Map<Id,Project__c>([SELECT ID, State__c, Country__c FROM Project__c WHERE ID IN: sampleIds]);
            }
            System.debug('productsGSTMap--->' + productsGSTMap);
            
            for(Sample_Line_Item__c sli : newSLIList){
                
                //clear all
                sli.IGSTC_Percent__c = null;
                sli.IGSTC_Amount__c = null;
                sli.CGST_Percent__c = null;
                sli.SGST_Percent__c = null;
                sli.CGST_Amount__c = null; 
                sli.SGST_Amount__c = null;
                
                if(sampleMap.containsKey(sli.Sample__c) && sampleMap.get(sli.Sample__c) != null && sampleMap.get(sli.Sample__c).Country__c == SHIPPING_COUNTRY_INDIA){
                    
                    Decimal stdGST = Decimal.valueOf(System.Label.Default_GST);
                    
                    if(sli.Plant_State__c ==  sampleMap.get(sli.Sample__c).State__c){    
                        if( productsGSTMap.containsKey(sli.Product__c)){  
                            decimal taxRate =  productsGSTMap.get(sli.Product__c).HSN_TAX__c / 2;
                            sli.CGST_Percent__c = taxRate;
                            sli.SGST_Percent__c = taxRate;   
                            sli.CGST_Amount__c =  (taxRate / 100)  * sli.Sampling_Price_Formula__c;
                            sli.SGST_Amount__c =   (taxRate / 100) * sli.Sampling_Price_Formula__c;
                            
                            sli.IGSTC_Percent__c = null;
                            sli.IGSTC_Amount__c = null;                        
                        }
                        else if((optivaGSTMap.containsKey(sli.OPTIVA_Recipe__c) || projectQuoGSTMap.containsKey(sli.Project_Quotient__c)) && stdGST != null){
                            decimal taxRate = stdGST / 2 ;  
                            
                            sli.CGST_Percent__c = taxRate;
                            sli.SGST_Percent__c = taxRate;
                            sli.CGST_Amount__c =  (taxRate / 100)  *  sli.Sampling_Price_Formula__c;
                            sli.SGST_Amount__c =   (taxRate / 100) * sli.Sampling_Price_Formula__c;
                            
                            sli.IGSTC_Percent__c = null;
                            sli.IGSTC_Amount__c = null;
                        }
                    }
                    else{
                        // Different State
                        System.debug('Different State--->');
                        if(sli.Product__c != null)
                        if( productsGSTMap.containsKey(sli.Product__c)){  
                            decimal taxRate =  productsGSTMap.get(sli.Product__c).HSN_TAX__c ;
                            sli.IGSTC_Percent__c = taxRate ;    
                            System.debug('taxRate--->'+taxRate);
                            sli.IGSTC_Amount__c =  (taxRate / 100) * sli.Sampling_Price_Formula__c;
                            System.debug(sli.IGSTC_Amount__c);
                            sli.CGST_Percent__c = null;
                            sli.SGST_Percent__c = null;
                            sli.CGST_Amount__c =  null;
                            sli.SGST_Amount__c =  null;
                        }
                        else if((optivaGSTMap.containsKey(sli.OPTIVA_Recipe__c) != null || projectQuoGSTMap.containsKey(sli.Project_Quotient__c) != null) && stdGST != null){
                            decimal taxRate = stdGST;  
                            sli.IGSTC_Percent__c = taxRate;
                            sli.IGSTC_Amount__c =  (taxRate / 100) * sli.Sampling_Price_Formula__c;
                            
                            sli.CGST_Percent__c = null;
                            sli.SGST_Percent__c = null;
                            sli.CGST_Amount__c =  null;
                            sli.SGST_Amount__c =  null;                        
                        }
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Message---->'+e.getMessage());
            System.debug('Exception Line number--->'+e.getLineNumber());
        }        
    }
    
    public void onAfterInsert(List<Sample_Line_Item__c> newSLIList){
        
        List<Sample_Line_Item__c> sliList = new  List<Sample_Line_Item__c>();
        try{
            for(Sample_Line_Item__c sli : newSLIList){
                if(sli.Sampling_Price_Formula__c != null && sli.Sampling_Price_Formula__c > 0 && sli.Plant_State__c != '' && sli.Plant_State__c != null){
                    sliList.add(sli);
                }
            }
            if(sliList != null)
                processCalculation(sliList);
            
        }
        catch(Exception e){
            System.debug('Exception Message---->'+e.getMessage());
            System.debug('Exception Line number--->'+e.getLineNumber());
        }
    } 
    
    
    public void onAfterUpdate(List<Sample_Line_Item__c> newSLIList, map<Id,Sample_Line_Item__c> oldSLIMapList){
        List<Sample_Line_Item__c> sliList = new  List<Sample_Line_Item__c>();
        try{
            for(Sample_Line_Item__c sli : newSLIList){
                if((sli.Plant_State__c !=  oldSLIMapList.get(sli.Id).Plant_State__c && sli.Sampling_Price_Formula__c != null && sli.Sampling_Price_Formula__c > 0)){
                    sliList.add(sli);
                }
            }
            if(sliList != null)
                processCalculation(sliList);
            
        }
        catch(Exception e){
            System.debug('Exception Message---->'+e.getMessage());
            System.debug('Exception Line number--->'+e.getLineNumber());
        }
    }    
    
}