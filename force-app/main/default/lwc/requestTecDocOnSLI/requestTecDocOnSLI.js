import { LightningElement,wire,api,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import getRecordDetails from '@salesforce/apex/ProjectHanlder.getSliRecord';
import getSliRecord from '@salesforce/apex/ProjectHanlder.getSliRecord';
import getRecordTypeId from '@salesforce/apex/ProjectHanlder.getProjectRecordTypeId';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class RequestTecDocOnSLI extends  NavigationMixin(LightningElement) {

     @api recordId;
     qntRecord;
     sliRecord;
       accVar;

      connectedCallback(){
        setTimeout(() => {
            this.getRecordDetails();
        }, 300);
    }

     getRecordDetails(){
         debugger;
        getRecordDetails({sampLId : this.recordId}).then(data=>{
            if(data){
                console.log('data--->',JSON.stringify(data.slIRecord));
                this.sliRecord = data; // data.slIRecord;
               // this.accVar = data.accID;
                console.log('RecordId', this.recordId);
                console.log('Data',data);
                this.openCreateRecordForm();
            }
        })
    }
     
    //  sliList;
    // @wire(getSliRecord, {sampLId:'$recordId'})
    // wiredContacts(result){
    //     debugger;
    //     if(result.data){
                
    //             this.sliList = result.data;
    //             var resultData = JSON.parse( this.sliList); 
    //             this.sliRecord = resultData.slIRecord;
    //             this.accVar = resultData.accID;
    //             console.log('RecordId', this.recordId);
    //           //  console.log('Data',data);
    //             this.openCreateRecordForm();
           
    //     }
    // }
     
   
    openCreateRecordForm(){
        debugger;
        getRecordTypeId({recordTypeName: 'Tech_Doc'}).then(result=>{
            console.log("RecordTypeRECEIVED-----",result);
            let recordTypeId = result;
           // let tempVar = this.sliRecord;
           
            // if(this.sliRecord.Sample__r.Opportunity__c ){
            //     this.accVar = this.sliRecord.Sample__r.Opportunity__r.Account.Id
            // }else if(this.sliRecord.Sample__r.Account__c ){
            //     this.accVar = this.sliRecord.Sample__r.Account__c 
            // }

            // if(this.sliRecord.Sample__c == undefined){
            //      this.accVar = '';
            // }
          // this.accVar =  this.sliRecord.Sample__r.Opportunity__c ?  this.sliRecord.Sample__r.Opportunity__r.Account.Id : null;

            let defaultValues = encodeDefaultFieldValues({
                Tech_Doc_Name__c :this.sliRecord.Line_Item_Name__c,
                Product_ID__c:this.recordId,
                CurrencyIsoCode : this.sliRecord.CurrencyIsoCode,    
                Sample_Line_Item__c	: this.recordId,  
             //   Account__c :   this.accVar //null  // this.sliRecord.Sample__r.Opportunity__c ?  this.sliRecord.Sample__r.Opportunity__r.Account.Id :  this.accVar     //? //this.sliRecord.Sample__r.Opportunity__r.Account.Id
                
                
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

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}