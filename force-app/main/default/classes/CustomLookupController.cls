public with sharing class CustomLookupController {
    
    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String value) {
        try {
            List<RecordsData> recordsDataList = new List<RecordsData>();
            String query = 'SELECT Id, ' + filterField + ' FROM '+objectName;
            if(String.isNotBlank(value)) {
                query += ' WHERE Id = \''+ value + '\' LIMIT 49999';
            } else {
                query += ' WHERE '+filterField+
                    ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' LIMIT 49999';
            }
            for(SObject s : Database.query(query)) {
                recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id')) );
            }
            return recordsDataList;
        } catch (Exception err) {
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                System.debug('Error = >'+err.getMessage() + ' && Error Line == >'+err.getLineNumber());
                // throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } 
        }
        return null;
    }
    
    @AuraEnabled
    public static List<RecordsData> fetchSalesUsers(String objectName, String filterField, String searchString, String value, String profileName, String condnField) {
        List<RecordsData> recordsDataList = new List<RecordsData>();
        try {
            Id currUserId = UserInfo.getUserId();
            String query = 'SELECT Id, ' + filterField + ' FROM ' + objectName +
                ' WHERE Manager.Name = :currentUserFullName AND ' + filterField + ' LIKE :searchStringWildcard';
            
            if(String.isNotBlank(value)) {
                query += ' AND Id = :value';
            }
            
            query += ' LIMIT 49999';
            
            System.debug('query==> ' + query);
            
            String searchStringWildcard = '%' + String.escapeSingleQuotes(searchString.trim()) + '%';
            User currentUser = [SELECT Name FROM User WHERE Id = :currUserId LIMIT 1];
            String currentUserFullName = currentUser.Name;
            
            for(SObject s : Database.query(query)) {
                recordsDataList.add(new RecordsData((String)s.get(filterField), (String)s.get('id')));
            }
        } catch (Exception err) {
            System.debug('Error => ' + err.getMessage() + ' && Error Line => ' + err.getLineNumber());
            // Log the error or throw AuraHandledException if needed
        }
        return recordsDataList;
    }


    
    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    
    @AuraEnabled
    public static List<RecordsData> fetchUsersRoute(String objectName, String filterField, String searchString, String city, String state) {
        try {
            List<RecordsData> recordsDataList = new List<RecordsData>();
            String query = 'SELECT Id, ' + filterField + ' FROM ' + objectName;
            
            // Add conditions for city and state filtering
            if (String.isNotBlank(city) && String.isNotBlank(state)) {
                query += ' WHERE City__c = \'' + String.escapeSingleQuotes(city) + '\' AND State__c = \'' + String.escapeSingleQuotes(state) + '\'';
            }
            
            if (String.isNotBlank(searchString)) {
                if (String.isNotBlank(city) && String.isNotBlank(state)) {
                    query += ' AND ' + filterField + ' LIKE \'' + String.escapeSingleQuotes(searchString.trim()) + '%\'';
                } else {
                    query += ' WHERE ' + filterField + ' LIKE \'' + String.escapeSingleQuotes(searchString.trim()) + '%\'';
                }
            }
            
            query += ' LIMIT 49999';
            System.debug('query==> ' + query);
            
            for (SObject s : Database.query(query)) {
                recordsDataList.add(new RecordsData((String) s.get(filterField), (String) s.get('Id')));
            }
            System.debug('recordsDataList==> ' + recordsDataList);
            return recordsDataList;
        } catch (Exception err) {
            if (String.isNotBlank(err.getMessage()) && err.getMessage().contains('error:')) {
                System.debug('Error = >' + err.getMessage() + ' && Error Line == >' + err.getLineNumber());
                
            }
        }
        return null;
    }
    
    
}