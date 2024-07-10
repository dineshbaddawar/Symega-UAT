import { LightningElement,api,wire,track } from 'lwc';
import getOpportunityRecord from "@salesforce/apex/UpdateOppAddressController.getOpportunityRecord"; 
import updateOpportunityShipRecord from "@salesforce/apex/UpdateOppAddressController.updateOpportunityShipRecord"; 
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class UpdateShippingAddress extends LightningElement {

     @api recordId;


     shipStreet ;
     shipCity   ;
     shipCountry  ;
     shipState  ;
     shipPostCode ;


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
                this.shipStreet = data.Shipping_Street__c;
                this.shipCity =  data.Shipping_City__c;
                this.shipCountry =  data.Shipping_Country__c;
                this.shipState =  data.Shipping_State__c;
                this.shipPostCode =  data.Shipping_Postal_Code__c;
            }
        })
    }

      handleChange(event){
         debugger;
       var name = event.target.name;
       var val = event.target.value;
       if(name == 'shipCity'){
            this.shipCity =  event.target.value;

       }else  if(name == 'shipCountry'){
            this.shipCountry =   event.target.value;

       }else  if(name == 'shipStreet'){
            this.shipStreet =   event.target.value;

       }else  if(name == 'shipState'){
            this.shipState =   event.target.value;

       }else if(name == 'shipPostCode'){

              this.shipPostCode =   event.target.value;
       }


    }
     handleNext(){
       debugger;
        updateOpportunityShipRecord({recId:this.recordId,shippingCity: this.shipCity,shippingState:this.shipState,shippingStreet:this.shipStreet,shippingCountry: this.shipCountry,shippingPostal:  this.shipPostCode}).then(data=>{
            if(data == 'SUCCESS'){
              this.showToast('Success','Billing Address Updated','success');
           //  location.reload('/'+this.recordId);
              this.closeAction();
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