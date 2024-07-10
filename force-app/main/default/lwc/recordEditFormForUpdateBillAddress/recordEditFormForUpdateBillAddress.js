import { LightningElement,api,wire,track } from 'lwc';
import getOpportunityRecord from "@salesforce/apex/UpdateOppAddressController.getOpportunityRecord"; 
import getAccountId from "@salesforce/apex/UpdateOppAddressController.getAccountId";
import { updateRecord } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class RecordEditFormForUpdateBillAddress extends LightningElement {

      @api recordId;
       accId;
       dispId;

      @track showAccForm;
      @track showDispForm ;

       connectedCallback(){
         debugger;
        setTimeout(() => {
           this.getRecordDetails();
        }, 300);
    }


    getRecordDetails(){
        debugger;
        getOpportunityRecord({oppId:this.recordId}).then(data=>{
            if(data){
                if(data.Account_Billing_Address__c){
                    this.showAccForm = true;
                       this.accId = data.AccountId;
                }else if(data.Customer_Billing_Address__c){
                     this.showDispForm = true;
                    this.dispId = data.Customer_Billing_Address__c;
                }
               
            }
        })
    }

    handleSubmit(event) {
        debugger;
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
    }

    handleSuccess(event) {
            debugger;
            var resId ;
            var disId ;
        console.log('onsuccess event recordEditForm', event.detail.id);
            if(this.accId != null){
              resId  = event.detail.id;
            }else{
                resId =null;
            }
            
            if(this.dispId != null){
             disId =  event.detail.id;
            }else{
                    disId =  null;
            }
        getAccountId({accId :resId,oppId:this.recordId,dispId:disId}).then(data=>{
            if(data =='SUCCESS'){
                   this.showToast('Success','Billing Address Updated','success');
                   this.closeAction();
            }
        })
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }


}