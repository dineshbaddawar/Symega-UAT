/**
 * @author [Dinesh Baddawar]
 * @email dinesh.b@utilitarianLab.com
 * @create date 2024-07-07 15:02:54
 * @modify date 2024-07-07 15:02:54
 * @desc [PDF Controller]
 */

public class PDFPerformaInvoiceHelper {
    public CustomPDFWrapper customWrap {get;set;}
    public String TodayDate { get { return Date.today().format(); }}
    public Symega_Configuration__c symObj {get;set;}
    public string sumOfAmtIntoWords {get;set;}
    public PDFPerformaInvoiceHelper(){
        customWrap = new CustomPDFWrapper();
        symObj = Symega_Configuration__c.getValues('Symega Configuration');
        Symega_Configuration__c[] settingsList = Symega_Configuration__c.getAll().values();
        String multiLineString = String.valueOf(settingsList[0].get('Proforma_invoic_Address__c'));
        System.debug('multiLineString == >'+multiLineString);
        List<String> address = multiLineString.split(';');
        String company = address.size() > 0 ? address[0] : '';
        String address1 = address.size() > 1 ? address[1] : '';
        String address2 = address.size() > 2 ? address[2] : '';
        String address3 = address.size() > 3 ? address[3] : '';
        String phone = address.size() > 4 ? address[4] : '';
        customWrap.company =company; 
        customWrap.Address2 = address1;
        customWrap.Address3 = address2;
        customWrap.Address4 = address3;
        customWrap.Address5 = phone;
        try{

            sumOfAmtIntoWords = '';
            String recordId =  System.currentPageReference().getParameters().get('id');
            if(recordId !=null){
                Opportunity oppDetails = [SELECT id, Total_Qty_In_Kg__c, Total_Freight_Charges__c, Freight_charges__c, Fiscal_Year__c, TotalOpportunityQuantity, accShipAdr__c, Pvt_Label_Item_Count__c, Proposed_Date_of_Dispatch__c, Performa_Invoice_No__c, Pre_carriage_By__c, Place_of_Reciept_by_Pre_Carrier__c,Port_of_Discharge__c,Vessel_Flight_Name_Voy_No__c,Port_of_Loading__c,Include_Freight_Charges__c,
                                          (SELECT Product2Id, ProductCode, Description, Quantity, UnitPrice, TotalPrice, ListPrice, Sub_Total__c, Product2.ProductCode, FERT_Code__c, Product2.Name, Product2.HSN_Code__c, Product2.HSN_TAX__c FROM OpportunityLineItems), 
                                          Account.Name, Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingCountry, Account.ShippingPostalCode, Account.ShippingStateCode, Account.Payment_terms__c, Account.Transportation_Terms__c,
                                          Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingCountry, Account.BillingPostalCode , Account.BillingStateCode, Account.GST_number__c, Account.PAN_Number__c,Account.Phone,Account.Email__c
                                          FROM Opportunity WHERE Id =: recordId];
                system.debug('oppDetails :: ' +oppDetails); 
                if(oppDetails != null) customWrap.oppRecDetails = oppDetails;
                if(oppDetails.Total_Freight_Charges__c !=null){
                    customWrap.TotalFreightCharges = oppDetails.Total_Freight_Charges__c;
                }
                List<OpportunityLineItem> oppLineItems = getOppLineItems(oppDetails.id);
                if (oppLineItems.size() > 0){
                    List<OppLineWrapper> lines = new List<OppLineWrapper>(); 
                    Decimal totalAmountValue = 0;
                    for (OpportunityLineItem line : oppLineItems) {
                        totalAmountValue += line.TotalPrice;
                        OppLineWrapper oppLine = new OppLineWrapper();
                        if(line.Product2.Description !=null){
                            oppLine.productDescription = line.Product2.Description;
                        }
                        if(line.Quantity !=null){
                            oppLine.prodctQty = line.Quantity;
                        }
                        if(line.UnitPrice !=null){
                            oppLine.prdouctRate = line.UnitPrice;
                        }
                        if(line.TotalPrice !=null){
                            oppLine.productAmount = line.TotalPrice;
                        }
                        if(line.Product2.HSN_Code__c !=null){
                            oppLine.productHSNCode = line.Product2.HSN_Code__c;
                        }

                        oppLine.oppLineItem = line;
                        lines.add(oppLine);
                    }
                    customWrap.totalAmount = totalAmountValue;
                    String IntegerInAmountWords = Utility.getNumberTOWordConvertion(Integer.valueOf(totalAmountValue));
                    System.debug('IntegerInAmountWords == >'+IntegerInAmountWords);
                    sumOfAmtIntoWords = IntegerInAmountWords;
                    customWrap.oppLines = lines;

                    System.debug('Record Size  oppline == >'+customWrap.oppLines.size());
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }        
    }
    
    public static List<OpportunityLineItem> getOppLineItems(String recordId){
        try{
            if(recordId !=null){
                return [SELECT Id,OpportunityId,Quantity,Product2.Name,Product2.Description,TotalPrice,UnitPrice,Product2.HSN_Code__c FROM OpportunityLineItem WHERE OpportunityId=:recordId];
            }            
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    public class CustomPDFWrapper{
        public string company {get;set;}
        public string Address2 {get;set;}
        public string Address3 {get;set;}
        public string Address4 {get;set;}
        public string Address5 {get;set;}
        public Decimal totalAmount {get;set;}

        public Decimal TotalFreightCharges {get;set;}
        public Opportunity oppRecDetails {get;set;}
        public List<OppLineWrapper> oppLines {get;set;}
    }
    
    public class OppLineWrapper{
        public OpportunityLineItem oppLineItem {get;set;}
        public String productDescription {get;set;}
        public String productHSNCode {get;set;}
        public Decimal  prodctQty {get;set;}
        public Decimal prdouctRate {get;set;}
        public Decimal productAmount {get;set;}
    }
    
}