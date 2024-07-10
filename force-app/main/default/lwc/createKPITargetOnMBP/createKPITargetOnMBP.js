import { LightningElement,wire,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import getRecordDetails from '@salesforce/apex/LWC_Handler.getMBPRecordDetails';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class CreateKPITargetOnMBP extends NavigationMixin(LightningElement) {

    @api recordId;
    mbpRecord;

    connectedCallback(){
        setTimeout(() => {
            this.recordId = this.recordId;
            this.getRecordDetails();
        }, 300);
    }

    getRecordDetails(){
        getRecordDetails({mbpId : this.recordId}).then(data=>{
            if(data){
                this.mbpRecord = data;
                console.log('RecordId', this.recordId);
                console.log('Data',data);
                this.openCreateRecordForm();
            }
        })
    }

    openCreateRecordForm(){
        debugger;
        let defaultValues = encodeDefaultFieldValues({
            Sales_User__c :this.mbpRecord.Sales_User__c,
            Monthly_Beat_Plan__c : this.mbpRecord.Id
        });

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'KPI_Target__c',
                actionName: 'new'
            },state: {
                defaultFieldValues: defaultValues
            }
        },true);
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}