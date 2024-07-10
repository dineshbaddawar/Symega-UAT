import { LightningElement, track } from 'lwc';
import getChatGPTResult from "@salesforce/apex/ChatGptHelper.getChatGPTResult";
export default class AccountInsightsChatgptComp extends LightningElement {

    @track responseData;
    @track orderInsight;
    @track salesInsight;
    @track freqInterventions;
    @track qtOrderRatio;
    @track highlowValue;
    @track orderCompletions;

    connectedCallback() {
        setTimeout(()=>{
            this.handleSearch();
        },300);
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
}