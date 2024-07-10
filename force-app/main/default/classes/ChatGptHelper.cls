public class ChatGptHelper {

    public static final String BaseEndURL = Label.ChatGptEndPointURL;
    Public static final string BaseChatEndURL = Label.chatGPTChatEndpointURL;
    
     @AuraEnabled
    public static string getChatGPTResult(String emailBody){ 
        string result;
        try{
            String seachQueryEscaped = (emailBody).trim();
            Http http = new Http();
            
            if (seachQueryEscaped.length() > 4097) {
                seachQueryEscaped = seachQueryEscaped.substring(0, 4097);
            }
            Map<String, Object> requestBodyMap = new Map<String, Object>();
            List<Map<String, Object>> messages = new List<Map<String, Object>>();
            Map<String, Object> message = new Map<String, Object>();
            message.put('role', 'user');
            message.put('content', seachQueryEscaped.escapeUnicode());
            messages.add(message);
            requestBodyMap.put('messages', messages);
            requestBodyMap.put('model', 'gpt-3.5-turbo');
            requestBodyMap.put('max_tokens', 4050);
            requestBodyMap.put('temperature', 0);
            requestBodyMap.put('stream', false);
            requestBodyMap.put('top_p', 0.5);
            String requestBody = JSON.serialize(requestBodyMap);
            System.debug('Query '+seachQueryEscaped+' '+requestBody);
            HttpRequest request = new HttpRequest();            
            request.setEndpoint(BaseChatEndURL);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer '+String.escapeSingleQuotes(Label.chatgptApiKey).trim());
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody(requestBody);
            
            HttpResponse response = http.send(request);                         
            if(response.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getBody());
                return response.getBody();
            } 
            result = response.getBody();
            system.debug('Result==>'+result);          
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return result;
    }
    
    @AuraEnabled
    Public Static List<Chatbot_Description__c> creatingResponseRecord(String Question, String Response){
        List<Chatbot_Description__c> Responseslist = new List<Chatbot_Description__c>();
        List<Chatbot_Description__c> Resp = new List<Chatbot_Description__c>();
        Chatbot_Description__c res;
        if(Question != null & Response != null){
            res = new Chatbot_Description__c();            
            res.Question__c = Question;
            res.Answers__c = Response;
         }
         insert res;
         Responseslist = [select id,Question__c, Answers__c from Chatbot_Description__c Order By CreatedDate Asc]; 
         for(Chatbot_Description__c chatRes :Responseslist){
            if(chatRes.Question__c != null){
                Resp.add(chatRes);
            }
        }
        return Resp; 
    }
    
    @AuraEnabled(cacheable=true)
    Public Static List<Chatbot_Description__c> getResponseRecord(){
        List<Chatbot_Description__c> Responseslist;
        Responseslist = [Select Id,Question__c, Answers__c from Chatbot_Description__c Order By CreatedDate Asc];
        List<Chatbot_Description__c> Response = new List<Chatbot_Description__c>();
        for(Chatbot_Description__c chatRes :Responseslist){
            if(chatRes.Question__c != null){
                Response.add(chatRes);
            }
        }
        return Response;
    }
    
    @AuraEnabled
    Public Static List<Counter_Objection__c> creatingCounterResponseRecord(String Question, String Response){
        List<Counter_Objection__c> Responseslist = new List<Counter_Objection__c>();
        List<Counter_Objection__c> Resp = new List<Counter_Objection__c>();
        Counter_Objection__c res;
        if(Question != null & Response != null){
            res = new Counter_Objection__c();            
            res.Question__c = Question;
            res.Answers__c = Response;
         }
         insert res;
         Responseslist = [select id,Question__c, Answers__c from Counter_Objection__c Order By CreatedDate Asc]; 
         for(Counter_Objection__c chatRes :Responseslist){
            if(chatRes.Question__c != null){
                Resp.add(chatRes);
            }
        }
        return Resp; 
    }
    
    @AuraEnabled(cacheable=true)
    Public Static List<Counter_Objection__c> getCounterResponseRecord(){
        List<Counter_Objection__c> Responseslist;
        Responseslist = [Select Id,Question__c, Answers__c from Counter_Objection__c Order By CreatedDate Asc];
        List<Counter_Objection__c> Response = new List<Counter_Objection__c>();
        for(Counter_Objection__c chatRes :Responseslist){
            if(chatRes.Question__c != null){
                Response.add(chatRes);
            }
        }
        return Response;
    }
}