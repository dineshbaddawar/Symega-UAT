import { LightningElement,wire,api,track } from 'lwc';
import submitForApproval from '@salesforce/apex/SubmitOpportunityForApprovalController.intiateApprovalProcess';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SubmitOpportunityForApproval extends LightningElement {


@api recordId;

    handleSearch() {
        debugger;
        submitForApproval({ oppId: this.recordId }).then((result) => {
           console.log('result--->',result);
         if(result =='success'){
            this.showToast('Success', 'Submitted For Approval', 'success');
            this.closeModal();
         }else{
               this.showToast('error', result, 'error');
              this.closeModal();
         }
          
        }).catch((error) => {
            console.log('error--->',error);
        });
  }
    showToast(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

        closeModal() {
                this.dispatchEvent(new CloseActionScreenEvent());
                this.handleButtonClick();
        }
        handleButtonClick() {
            const customEvent = new CustomEvent('closeaura');
            this.dispatchEvent(customEvent);
        }


}