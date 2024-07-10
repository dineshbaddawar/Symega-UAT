import { LightningElement, api, wire, track} from 'lwc';
import {CloseActionScreenEvent} from 'lightning/actions';
import sendSONotification from '@salesforce/apex/OpportunityCreateSaleOrderController.sendSONotification'
import getLineItemDet from '@salesforce/apex/saleOrderSubmissionController.getLineItemDetails'
import updateOpp from '@salesforce/apex/saleOrderSubmissionController.submitSaleOrder'
import updateAccRecord from '@salesforce/apex/OpportunityCreateSaleOrderController.updateAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PushSOToSAP extends LightningElement {

    @api recordId;
    show1stPage = false;
    showSpinner = true;
    
    accRecId;
    billingDispRecId;
    shippingDispRecId;

    isBilling_ShippingAccount = false;
    isAccBilling_ShippigCustomer = false;
    isBillingCustomer_AccShipping = false;
    isCustomerBilling_Shipping = false;

    accountMissingFieldList;
    billingCustMissingFieldList;
    shippingCustMissingFieldList;
    onlyAccMissingFieldList;

    userId;
    addressUserId
    bhId;
    isAccount = false;

    pickValList;
    pan;
    gst;
    fssai;

    showUserField = false;
    showBhField = false;
    showAddressUserField = false;


    showAccountOnScreen = false;
    showCustAddrssOnShippingScreen = false;
    showCustAddrssOnBillingScreen = false;

    custAddFieldsMissing = false;
    accFieldsMissing = false;

    showDlvryPlantField = false;
    showCustTypeField = false;
    showAccSegField = false;
    showTaxType = false;
    showTaxCollect = false;
    showPaymentTerms = false;
    showTransportTerms = false;

    @track dlvryPlantList = [];
    @track custTypeList = [];
    @track accSegList = [];
    @track taxTypeList = [];
    @track taxCollectList = [];
    @track paymentTermsList = [];
    @track transportTermsList = [];

    dlvryPlantVal;
    accSegVal;
    custTypeVal;
    taxTypeVal;
    taxCollectVal;
    paymentTermsVal;
    transportTermsVal;

    connectedCallback(){
        setTimeout(() => {
            this.getRecordDetails();
        }, 300);
    }

    getRecordDetails(){
        debugger;
        getLineItemDet({recId : this.recordId}).then(data => {
            this.showSpinner = false;
            if(data.fertCodesPresentForAll == false){
                this.showToast('Error','FERT Code missing','error');
                this.closePopup();
            }
            else{
                if(!data.isBilling_ShippingAccount && !data.isAccBilling_ShippigCustomer && !data.isBillingCustomer_AccShipping && !data.isCustomerBilling_Shipping){
                    this.showToast('Error', 'Address is missing', 'error');
                    this.closeModal();
                }
                else{
                    if(data.reqFieldsMissing == false){
                        this.sendSONotification();
                    }
                    else{
                        this.show1stPage = true;

                        this.accRecId = data.accRecId;
                        this.billingDispRecId = data.billingDispRecId;
                        this.shippingDispRecId = data.shippingDispRecId;

                        this.accountMissingFieldList = data.accountMissingFieldList;
                        this.billingCustMissingFieldList = data.billingCustMissingFieldList;
                        this.shippingCustMissingFieldList = data.shippingCustMissingFieldList;
                        this.onlyAccMissingFieldList = data.onlyAccMissingFieldList;


                        this.isBilling_ShippingAccount = data.isBilling_ShippingAccount;
                        this.isAccBilling_ShippigCustomer = data.isAccBilling_ShippigCustomer;
                        this.isBillingCustomer_AccShipping = data.isBillingCustomer_AccShipping;
                        this.isCustomerBilling_Shipping = data.isCustomerBilling_Shipping;   

                        if(data.accountMissingFieldList.length > 0){
                            this.showAccountOnScreen = true;
                        }
                        else{
                            if(this.shippingCustMissingFieldList.length > 0){
                                this.showCustAddrssOnShippingScreen = true;
                            }
                            if(this.billingCustMissingFieldList.length > 0){
                                this.showCustAddrssOnBillingScreen = true;
                                this.showCustAddrssOnShippingScreen = false;
                            }
                        }

                        
                        if(this.isCustomerBilling_Shipping){
                            if(this.onlyAccMissingFieldList.length>0){
                                this.showCustAddrssOnBillingScreen = true;
                                this.showCustAddrssOnShippingScreen = false;

                                if(!this.billingCustMissingFieldList.length > 0){
                                    this.showAccountOnScreen = true;
                                }
                            
                                if(data.onlyAccMissingFieldList.includes('Delivery_Plant__c')){
                                    this.showDlvryPlantField = true;
                                }
                                if(data.onlyAccMissingFieldList.includes('Customer_Type__c')){
                                    this.showCustTypeField = true;
                                }
                                if(data.onlyAccMissingFieldList.includes('Account_Segment__c')){
                                    this.showAccSegField = true;
                                }
                                if(data.onlyAccMissingFieldList.includes('Payment_terms__c')){
                                    this.showPaymentTerms = true;
                                }
                                if(data.onlyAccMissingFieldList.includes('Tax_Collected_At_Source__c')){
                                    this.showTaxCollect = true;
                                }
                                if(data.onlyAccMissingFieldList.includes('Transportation_Terms__c')){
                                    this.showTransportTerms = true;
                                }
                            }
                        }

                        this.pickValList = data.pickValList;

                        if(this.pickValList != undefined){
                            let Arr5  = this.pickValList.Delivery_Plant__c.Delivery_Plant__c;
                            let Arr6 = this.pickValList.Customer_Type__c.Customer_Type__c;
                            let Arr7 = this.pickValList.Account_Segment__c.Account_Segment__c;

                            let Arr1 = this.pickValList.Tax_Type__c.Tax_Type__c;
                            let Arr2 = this.pickValList.Tax_Collected_At_Source__c.Tax_Collected_At_Source__c;
                            let Arr3 = this.pickValList.Payment_terms__c.Payment_terms__c;
                            let Arr4 = this.pickValList.Transportation_Terms__c.Transportation_Terms__c;


                            let option1=[]
                            for(var i=0; i < Arr1.length; i++){
                                option1.push({label:Arr1[i],value:Arr1[i]});
                            }
                            this.taxTypeList=option1;

                            let option2=[]
                            for(var i=0; i < Arr2.length; i++){
                                option2.push({label:Arr2[i],value:Arr2[i]});
                            }
                            this.taxCollectList=option2;

                            let option3=[]
                            for(var i=0; i < Arr3.length; i++){
                                option3.push({label:Arr3[i],value:Arr3[i]});
                            }
                            this.paymentTermsList=option3;

                            let option4=[]
                            for(var i=0; i < Arr4.length; i++){
                                option4.push({label:Arr4[i],value:Arr4[i]});
                            }
                            this.transportTermsList=option4;


                            let option5=[]
                            for(var i=0; i < Arr5.length; i++){
                                option5.push({label:Arr5[i],value:Arr5[i]});
                            }
                            this.dlvryPlantList=option5;

                            let option6=[]
                            for(var i=0; i < Arr6.length; i++){
                                option6.push({label:Arr6[i],value:Arr6[i]});
                            }
                            this.custTypeList=option6;

                            let option7=[]
                            for(var i=0; i < Arr7.length; i++){
                                option7.push({label:Arr7[i],value:Arr7[i]});
                            }
                            this.accSegList=option7;
                        }

                        
                    }

                }

            }
        })
    }

    sendSONotification(){
        debugger;
        sendSONotification({id : this.recordId}).then(data=>{
            if(data=='Success'){
                this.showToast('Success','Notification Sent Successfully','success');
            }
            if(this.showSpinner == true){
                this.showSpinner = false;
            }

            this.updateOpp();
        })
    }

    handleChange(event){
        debugger;
        let name = event.target.name;

        if(name == 'UserCode'){
            this.userSapCode = event.target.value
        }
        else if(name == 'BHCode'){
            this.bhSapCode = event.target.value
        }
        else if(name == 'dlvryPlant'){
            this.dlvryPlantVal = event.target.value
        }
        else if(name == 'custType'){
            this.custTypeVal = event.target.value
        }
        else if(name == 'accSeg'){
            this.accSegVal = event.target.value
        }

        else if(name == 'taxType'){
            this.taxTypeVal = event.target.value
        }
        else if(name == 'taxCollect'){
            this.taxCollectVal = event.target.value
        }
        else if(name == 'paymentTerms'){
            this.paymentTermsVal = event.target.value
        }
        else if(name == 'transportTerms'){
            this.transportTermsVal = event.target.value
        }
        else if(name == 'gst'){
            this.gst = event.target.value
        }
        else if(name == 'pan'){
            this.pan = event.target.value
        }
        else if(name == 'fssai'){
            this.fssai = event.target.value
        }
    }

    updateOpp(){
        updateOpp({soId:this.recordId}).then(result =>{
            console.log('Opp Update Result',result);
            if(result!='Success'){
                if(result.includes('in Progress')){
                    this.showToast('Success',result,'success');
                    this.dispatchEvent(new CloseActionScreenEvent());        
                }
                else{
                    this.showToast('Error',result,'error');     
                }
            }
            else{
                this.closePopup();
            }
        }).catch(err =>{
            console.log('Errror-----',err);
        })
    }

    closePopup(){
        this.dispatchEvent(new CloseActionScreenEvent());
        setTimeout(()=>window.location.reload(),1500);
    }

    showToast(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }


    handleAccountBillingAndShipping(){
        debugger;
        this.sendSONotification();
        this.showToast('Success', 'Account updated successfully', 'success');
        this.show1stPage = false;
    }

    handleAccountBillingAndCustomerShipping_Account(){
        debugger;
        this.showAccountOnScreen = false;
        if(this.shippingCustMissingFieldList.length > 0){
            this.showCustAddrssOnShippingScreen = true;
        }
        else{
            this.sendSONotification();
            this.showToast('Success', 'Account updated successfully', 'success');
            this.show1stPage = false;
        }
    }

    handleAccountBillingAndCustomerShipping_CustAddr(){
        debugger;
        this.sendSONotification();
        this.showToast('Success', 'Customer Address updated successfully', 'success');
        this.show1stPage = false;
    }

    handleCustomerBillingAndAccountShipping_Account(){
        debugger;
        this.showAccountOnScreen = false;
        if(this.billingCustMissingFieldList.length > 0){
            this.showCustAddrssOnBillingScreen = true;
        }
        else{
            this.sendSONotification();
            this.showToast('Success', 'Account updated successfully', 'success');
            this.show1stPage = false;
        }
    }

    handleCustomerBillingAndAccountShipping_CustAddr(){
        debugger;
        this.sendSONotification();
        this.showToast('Success', 'Customer Address updated successfully', 'success');
        this.show1stPage = false;
    }

    handleCustomerBilling(){
        debugger;
        this.showCustAddrssOnBillingScreen = false;

        if( (this.dlvryPlantVal != undefined && this.dlvryPlantVal != '') || (this.custTypeVal != undefined && this.custTypeVal != '') || (this.accSegVal != undefined && this.accSegVal != '') ||
        (this.taxCollectVal != undefined && this.taxCollectVal != '') || (this.paymentTermsVal != undefined && this.paymentTermsVal != '') ||
        (this.transportTermsVal != undefined && this.transportTermsVal != '') )
        {
            updateAccRecord({accId:this.accRecId, dlvryPlant:this.dlvryPlantVal, custType : this.custTypeVal, accSeg : this.accSegVal, taxType : this.taxTypeVal, taxCollect : this.taxCollectVal, paymentTerms : this.paymentTermsVal, transportTerms : this.transportTermsVal, Gst : this.gst, Pan : this.pan, fssai : this.fssai})
        }

        if(this.shippingCustMissingFieldList.length > 0){
            this.showCustAddrssOnShippingScreen = true;
        }
        else{
            this.sendSONotification();
            this.showToast('Success', 'Customer updated successfully', 'success');
            this.show1stPage = false;
        }
    }

    handleCustomerShipping(){
        debugger;
        this.sendSONotification();
        this.showToast('Success', 'Customer Address updated successfully', 'success');
        this.show1stPage = false;
    }

    closeModal() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleError(event){
        debugger;
        console.log('ERROR -- ', event.detail.detail);
    }
}