import { LightningElement,api,wire,track } from 'lwc';
import getOpportunityRecord from "@salesforce/apex/UpdateOppAddressController.getOpportunityRecord"; 
import updateOpportunityRecord from "@salesforce/apex/UpdateOppAddressController.updateOpportunityRecord"; 
import { updateRecord } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class UpdateOppBillingAddress extends LightningElement {

  @api recordId;

     billStreet ;
     billCity   ;
     billCountry  ;
     billState  ;
     billPostCode ;


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
                this.billStreet = data.Billing_Street__c;
                this.billCity =  data.Billing_City__c;
                this.billCountry =  data.Billing_Country__c;
                this.billState =  data.Billing_State__c;
                this.billPostCode =  data.Billing_Postal_Code__c;
            }
        })
    }

    handleChange(event){
     debugger;
       var name = event.target.name;
       var val = event.target.value;
       if(name == 'billCity'){
            this.billCity =  event.target.value;

       }else  if(name == 'billCountry'){
            this.billCountry =   event.target.value;

       }else  if(name == 'billStreet'){
            this.billStreet =   event.target.value;

       }else  if(name == 'billState'){
            this.billState =   event.target.value;

       }else if(name == 'billPostal'){

              this.billPostCode =   event.target.value;
       }


    }

    handleNext(){
       debugger;
        updateOpportunityRecord({recId:this.recordId,billingCity: this.billCity,billingState:this.billState,billingStreet:this.billStreet,billingCountry: this.billCountry,billingPostal:  this.billPostCode}).then(data=>{
            if(data == 'SUCCESS'){
              this.showToast('Success','Billing Address Updated','success');
           //  location.reload('/'+this.recordId);
              this.closeAction();
              updateRecord({ fields: { Id: this.recordId } });
            }else{
                 this.showToast('Error', data,'error');
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