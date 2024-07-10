import { LightningElement,api,wire,track} from 'lwc';
import getRecordDetails from '@salesforce/apex/ProjectHanlder.getLeadRecord';
import getRecordTypeId from '@salesforce/apex/ProjectHanlder.getProjectRecordTypeId';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { NavigationMixin } from 'lightning/navigation';
//import { CloseActionScreenEvent } from 'lightning/actions';
//import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateSampleOnLead extends NavigationMixin(LightningElement) {

    @api recordId;
    leadRecord;


    connectedCallback(){
        setTimeout(() => {
            this.getRecordDetails();
        }, 300);
    }

    getRecordDetails(){
        getRecordDetails({leadId : this.recordId}).then(data=>{
            if(data){
                this.leadRecord = data;
                console.log('RecordId', this.recordId);
                console.log('Data',data);
                this.openCreateRecordForm();
            }
        })
    }



    // @wire(getRecordDetails,{ leadId : '$recordId'})
    // recordDetails({data,error}){
    //     debugger;
    //     if(data){
    //         this.leadRecord = data;
    //         console.log('RecordId', this.recordId);
    //         console.log('Data',data);
    //         this.openCreateRecordForm();
    //     }
    //     if(error){
    //         console.log("Errorsss",error);
    //     }
    // }

    openCreateRecordForm(){
        debugger;

         getRecordTypeId({recordTypeName: 'Sample'}).then(result=>{
            console.log("RecordTypeRECEIVED-----",result);
            let recordTypeId = result;
        
            let defaultValues = encodeDefaultFieldValues({
                //RecordTypeId: 'Sample',
                Customer_Name__c :this.leadRecord.Name,
                Lead__c : this.leadRecord.Id,
                Sample_Name__c : `${this.leadRecord.Company}-sample`,
                City__c:this.leadRecord.Address?this.leadRecord.Address.city:"",
                Country__c:this.leadRecord.Address?this.leadRecord.Address.country:"",
                Postal_Code__c	:this.leadRecord.Address?this.leadRecord.Address.postalCode:"",
                State__c:this.leadRecord.Address?this.leadRecord.Address.state:"",
                Street__c:this.leadRecord.Address?this.leadRecord.Address.street:"",
                CurrencyIsoCode : this.leadRecord.CurrencyIsoCode
            });

            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Project__c',
                    actionName: 'new'
                },state: {
                    defaultFieldValues: defaultValues,
                    recordTypeId: recordTypeId
                }
            });
        }).catch(error=>{
        console.log("Error-----",error);
    })
    }

   
}