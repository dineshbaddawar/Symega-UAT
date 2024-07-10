import { LightningElement,wire,api,track } from 'lwc';
import createProduct from '@salesforce/apex/OptivaRecipeController.createProduct'; 
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CreateProductOnOptivaRecipe extends LightningElement {

    @api recordId;
    
    @track showSpinner = true;
    connectedCallback(){
          debugger;
          setTimeout(() => {
               this.getRecordDetails();
          }, 300);
    }

   getRecordDetails() {
        createProduct({ optivaRecId: this.recordId })
            .then(result => {
                
                if(result == 'SUCCESS'){
                    this.showSpinner = false ;
                    this.showToast('Success', 'Product is Created Successfully', 'success');
                    this.closeModal();
                }else{
                       this.showToast('error', 'error', 'error');
                }
            })
            .catch(error => {
                 this.showToast('error', error, 'error');
            });
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

     closeModal() {
        this.dispatchEvent(new CloseActionScreenEvent());
     }
 

}