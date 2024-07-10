import { LightningElement,api,wire,track} from 'lwc';
import getRecordDetails from '@salesforce/apex/createAutoSampleHelper.createSample';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {CloseActionScreenEvent} from 'lightning/actions';

export default class CreateSampleOnProject extends LightningElement {

    @api recordId;
    connectedCallback(){
        setTimeout(() => {
            this.getRecordDetails();
        }, 300);
    }

    getRecordDetails(){
        debugger;
        getRecordDetails({ projId : this.recordId}).then(data=>{
            if(data){
                console.log('Data',data);
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Auto-Sample and Line Items have been created',
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                this.dispatchEvent(new CloseActionScreenEvent());
            }
        })
    }
    
    /*@api recordId;
    @track recordTypeSelected;

    connectedCallback(){
        setTimeout(() => {
            this.getRecordDetails();
        }, 300);
    }

    getRecordDetails(){
        debugger;
        getRecordDetails({ projectId : this.recordId}).then(data=>{
            if(data){
                this.projectRecord = data;
                console.log('RecordId', this.recordId);
                console.log('Data',data);
                this.openCreateRecordForm();
            }
        })
    }
    
    openCreateRecordForm(){
        debugger;
        getRecordTypeId({recordTypeName: 'Sample'}).then(result=>{
            console.log("RecordTypeRECEIVED-----",result);
            let recordTypeId = result;
            let defaultValues = encodeDefaultFieldValues({

            Sample_Project__c : this.recordId,
            Opportunity__c :   this.projectRecord.Opportunity__c,//this.Opportunity__c,
            Account__c :   this.projectRecord.Opportunity__r.AccountId,
            Customer_Name__c : this.projectRecord.Opportunity__r.Account.Name,
            Sample_Name__c	: `${this.projectRecord.Opportunity__r.Account.Name}-Sample`,
            Customers_Contact__c : this.projectRecord.Opportunity__r.Primary_Contact__c,
            CurrencyIsoCode : this.projectRecord.Opportunity__r.CurrencyIsoCode,

            Opportunity_Close_Date__c : this.projectRecord.Opportunity__r.CloseDate,
            End_Use_category__c : this.projectRecord.Opportunity__r.End_Use_Category__c,
            End_Use_Applications__c : this.projectRecord.Opportunity__r.End_Use_Application__c,
            End_use_application_other__c : this.projectRecord.Opportunity__r.End_Use_Application_Other__c,

            City__c : this.projectRecord.Opportunity__r.Shipping_City__c,
            Country__c : this.projectRecord.Opportunity__r.Shipping_Country__c,
            Postal_Code__c : this.projectRecord.Opportunity__r.Shipping_Postal_Code__c,
            State__c : this.projectRecord.Opportunity__r.Shipping_State__c,
            Street__c : this.projectRecord.Opportunity__r.Shipping_Street__c,

            Billing_City__c : this.projectRecord.Opportunity__r.Billing_City__c,
            Billing_Country__c : this.projectRecord.Opportunity__r.Billing_Country__c,
            Billing_Postal_Code__c : this.projectRecord.Opportunity__r.Billing_Postal_Code__c,
            Billing_State__c : this.projectRecord.Opportunity__r.Billing_State__c,
            Billing_Street__c : this.projectRecord.Opportunity__r.Billing_Street__c,
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
    }*/


}