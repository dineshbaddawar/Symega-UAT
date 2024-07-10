import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getChatGPTResult from "@salesforce/apex/ChatGptHelper.getChatGPTResult";
import creatingCounterResponseRecord from "@salesforce/apex/ChatGptHelper.creatingCounterResponseRecord"
import getCounterResponseRecord from "@salesforce/apex/ChatGptHelper.getCounterResponseRecord"
export default class CounterObjectionComp extends LightningElement {
@track responseData;
    @track responseList = [];
    @track currentRecord;
    @track isRecognizedText = false;
    @track recognizedText = '';
    
    connectedCallback() {
        this.getResponseRecords();
    }

    getResponseRecords() {
        debugger;
        getCounterResponseRecord()
            .then((result) => {
                this.responseList = result;
            })
            .catch((error) => {
                console.error('Error fetching response records:', error);
            });
    }

    handleChange(event){
  debugger;
  this.isRecognizedText = true;
  this.recognizedText = event.target.value;
    }

    handleClick(){
    debugger;
    this.handleSearch();
}

    handleSearch() {
    debugger;
  getChatGPTResult({ 
    emailBody: this.recognizedText 
    })
    .then((result) => {
      debugger;
      console.log(result);
      let response = JSON.parse(result);
        if (response.error) {
                    this.responseData = response.error.message;
             } 
            else {
              let assistantResponse = response.choices[0].message.content;
              assistantResponse = assistantResponse.replace(/\n/g, "");
              let tempScriptData = '';
                if (assistantResponse.includes('<script>')) {
                    tempScriptData = 'JS File: ' + assistantResponse.split('<script>')[1];
                }
                tempScriptData = tempScriptData.replace(/\n/g, "<br />");
                this.responseData = assistantResponse + tempScriptData;
                this.responseData = this.responseData.includes('XML File:') ? this.responseData.split('XML File:')[0] : this.responseData;
                this.responseData = this.responseData.trim();
            }
    console.log('SR',JSON.stringify(this.responseData));
      this.handleResponse();
      
    })
    .catch((error) => {
      console.log('error-->',error)
    });
}

 handleResponse(){
   debugger;
   let sanitizedResponse = this.sanitizeInput(this.responseData);
   creatingCounterResponseRecord({
     Question: this.recognizedText,
     Response : sanitizedResponse
   })
   .then((result)=>{
       this.responseList = result;
       this.recognizedText='';
       this.isRecognizedText = false;
       this.error = undefined;
       this.showSuccessToast();
   })
   .catch((error)=> {
     this.currentRecord = undefined;
       this.error = error;
     console.log('error--->', error)
   });
 }

 sanitizeInput(input) {
    return input.replace(/<script[^>]*>(.*?)<\/script>/gi, '');
}

showSuccessToast() {
  const evt = new ShowToastEvent({
      title: 'Toast Success',
      message: 'Opearion sucessful',
      variant: 'success',
      mode: 'dismissable'
  });
  this.dispatchEvent(evt);
  this.template.querySelector('lightning-input').reset();
}
}