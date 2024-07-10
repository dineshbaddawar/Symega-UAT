public without sharing class customPathController {
    public List<PicklistValueWrapper> picklistValues { get; set; }

    public customPathController( String recordId) {
        String objectName = 'Sample_Line_Item__c';
        String fieldName = 'Sample_Request_Status__c';

        picklistValues = getPicklistValues(objectName, fieldName, recordId);
    }

    public class PicklistValueWrapper {
        public String label { get; set; }
        public String value { get; set; }

        public PicklistValueWrapper(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

    private List<PicklistValueWrapper> getPicklistValues(String objectName, String fieldName, String recordId) {
        List<PicklistValueWrapper> values = new List<PicklistValueWrapper>();
		Sample_Line_Item__c SLIRec = [SELECT Id, Name, Sample_Request_Status__c FROM Sample_Line_Item__c WHERE Id=:recordId];
        // Retrieve the field describe result
        Schema.DescribeFieldResult fieldDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();

            // Get the picklist values
            List<Schema.PicklistEntry> picklistEntries = fieldDescribe.getPicklistValues();
            for (Schema.PicklistEntry entry : picklistEntries) {
                if(entry.getLabel() == SLIRec.Sample_Request_Status__c){
					values.add(new PicklistValueWrapper(entry.getLabel(), 'Current'));
                }else{
                    values.add(new PicklistValueWrapper(entry.getLabel(), 'Standard'));
                }
            
    }
                return values;
}
}