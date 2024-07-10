@isTest(SeeAllData=true)
public class DocCategoryHelperTest {
    @isTest
    public static void getTest1(){
        
        Account acc = new Account();
        acc.Name = 'Test Acc';
        acc.Account_Segment__c = 'Key';
        acc.Currency__c = 'INR';
        acc.Email__c = 'test@gmail.com';
        
        acc.BillingCity = 'Bangalore';
        acc.BillingCountry = 'India';
        acc.BillingState = 'Punjab';
        acc.BillingStreet = 'XYZ, Test';
        acc.BillingPostalCode = '561011';
        acc.ShippingCity = 'Bangalore';
        acc.ShippingCountry = 'India';
        acc.ShippingState = 'Punjab';
        acc.ShippingStreet = 'XYZ, Test';
        acc.ShippingPostalCode = '561011';
        
        acc.Website = 'https://chat.openai.com/c/e1e8178b-6bd6-4d49-b71e-ca03caba95f6';
        acc.Phone = '4567889000';
        insert acc; 
        
        Contact conRec = new Contact();
        conRec.LastName = 'Test Con';
        insert conRec;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp1';
        opp.CloseDate = Date.newInstance(2023, 11, 17);
        opp.Annual_Volume_Full__c = 1;
        opp.Target_Price_Kg__c = 1;
        opp.Annual_Volume_in_units__c = 'Kg';
        opp.StageName = 'New';
        opp.End_Use_Application__c = 'Biscuits and Cookies';
        opp.End_Use_Category__c = 'Baked Goods';
        opp.AccountId = acc.Id ;
        insert opp;
        
        String currentUserId = UserInfo.getUserId();
        
        Weekly_Beat_Plan__c wbp = new Weekly_Beat_Plan__c();
        wbp.End_Day_of_Week__c = Date.newInstance(2023, 11, 17);
        wbp.Week_Identifier__c ='w1';
        wbp.Week_Number__c = 'Week 1';
        wbp.CurrencyIsoCode = 'INR';
        insert wbp;
        
        Datetime currentDateTime = System.now();
        Time currentTime = currentDateTime.time();
        
        KPI_Target__c kt = new KPI_Target__c();
        insert kt;
        
        Visit__c vsRec = new Visit__c();
        vsRec.Planned_visit_date__c =  Date.newInstance(2023, 11, 16);
        vsRec.Assigned_User__c = currentUserId;
        vsRec.Account__c = acc.Id;
        vsRec.Visit_Status__c = 'Sent For Approval';
        vsRec.Weekly_Beat_Plan__c = wbp.Id;
        vsRec.KPI_Target__c = kt.Id;
        vsRec.Geo_Location__Latitude__s = 12.890992;
        vsRec.Geo_Location__Longitude__s = 77.570802;
        vsRec.Expected_Start_Time__c = currentTime ;
        insert vsRec;
        
        Deal__c dealRec = new Deal__c();
        dealRec.Name = 'test 1';
        dealRec.Contact__c = conRec.Id;
        insert dealRec;
        
        Monthly_Beat_Plan__c mbpRec = new Monthly_Beat_Plan__c();
        mbpRec.Approval_Status__c = 'Approved';
        mbpRec.Start_Date__c = system.today();
        mbpRec.End_Date__c = system.today();
        mbpRec.CurrencyIsoCode = 'INR';
        mbpRec.Status__c = 'Approved';
        insert mbpRec;
        
        Document_Category__c dcm = new Document_Category__c();
        dcm.Monthly_Beat_Plan__c = mbpRec.Id;
        insert dcm;
        
        Documents_Attachment__c dabm = new Documents_Attachment__c();
        dabm.Name = 'Test Doc1';
        dabm.Document_Category__c = dcm.Id;
        dabm.Active__c = true;
        insert dabm;
        
        Document_Category__c dcc = new Document_Category__c();
        dcc.Visit__c = vsRec.Id;
        insert dcc;
        
        Documents_Attachment__c dab = new Documents_Attachment__c();
        dab.Name = 'Test Doc1';
        dab.Document_Category__c = dcc.Id;
        dab.Active__c = true;
        insert dab;
        
        Document_Category__c dc = new Document_Category__c();
        dc.deal__c = dealRec.Id;
        insert dc;
        
        Documents_Attachment__c da = new Documents_Attachment__c();
        da.Name = 'Test Doc1';
        da.Document_Category__c = dc.Id;
        da.Active__c = true;
        insert da;
        
        Document_Category__c dc1 = new Document_Category__c();
        dc1.Account__c = acc.Id;
        insert dc1;
        
        Documents_Attachment__c daa1 = new Documents_Attachment__c();
        daa1.Name = 'Doc Test';
        daa1.Document_Category__c = dc1.Id;
        daa1.Active__c = true;
        insert daa1;
        
        Document_Category__c dc2 = new Document_Category__c();
        dc2.Opportunity__c = opp.Id;
        insert dc2;
        
        Documents_Attachment__c daa = new Documents_Attachment__c();
        daa.Name = 'Doc Test';
        daa.Document_Category__c = dc2.Id;
        daa.Active__c = true;
        insert daa;
        
        /*Id approverId = UserInfo.getUserId();
User userList = [SELECT Id, FirstName, LastName, Username, Email,ManagerId  FROM User WHERE ID =:approverId];
List<Id> appIds = new List<Id>();
//  appIds.add(approverId);
appIds.add(userList.ManagerId);
Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
app.setObjectId(mbpRec.id);
app.setNextApproverIds( appIds);
Approval.ProcessResult result = Approval.process(app);*/
        
        DocCategoryHelper dch = new DocCategoryHelper();
        dch.closePopup();
        dch.showPopup();
        // dch.blobData();
        DocCategoryHelper.DocumentTreeWrapper wc = new DocCategoryHelper.DocumentTreeWrapper(daa1.Id,daa1.Name);
        string pageRef = 'https://symegafood--uat--c.sandbox.vf.force.com/apex/docCategories?attachId='+daa.id;
        
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(daa);
        PageReference pageRef1 = Page.docCategories;
        pageRef1.getParameters().put('Id',daa.Id);
        Test.setCurrentPage(pageRef1);
        //DocCategoryHelper pdf1 = new DocCategoryHelper(sc1);
        
        DocCategoryHelper.getDocuments(dealRec.Id);
        DocCategoryHelper.getDocuments(acc.Id);
        DocCategoryHelper.getDocuments(opp.Id);
        DocCategoryHelper.getDocuments(mbpRec.Id);
        DocCategoryHelper.getDocuments(vsRec.Id);
        DocCategoryHelper.deleteDoc(da.Id);
        
        
        
        
    }
    
    @isTest
    public static void getTest2(){
        Monthly_Beat_Plan__c mbpRec = new Monthly_Beat_Plan__c();
        mbpRec.Approval_Status__c = 'Approved';
        mbpRec.Start_Date__c = system.today();
        mbpRec.End_Date__c = system.today();
        mbpRec.CurrencyIsoCode = 'INR';
        mbpRec.Status__c = 'Approved';
        mbpRec.OwnerId =  UserInfo.getUserId();
        insert mbpRec;
        
        Id approverId = UserInfo.getUserId();
        User userList = [SELECT Id, FirstName, LastName, Username, Email,ManagerId  FROM User WHERE ID =:approverId];
        List<Id> appIds = new List<Id>();
        //  appIds.add(approverId);
        appIds.add(userList.ManagerId);
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(mbpRec.id);
        app.setNextApproverIds(appIds);
        Approval.ProcessResult result = Approval.process(app);
        
        //DocCategoryHelper.initiateApprovalProcess(mbpRec.Id);
    }
    
    @isTest
    public static void getTest3(){
        Document_Category__c dcm = new Document_Category__c();
        // dcm.Monthly_Beat_Plan__c = mbpRec.Id;
        insert dcm;
        
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=dcm.id;
        insert attach;
        
        Documents_Attachment__c dabm = new Documents_Attachment__c();
        dabm.Name = 'Test Doc1';
        dabm.Document_Category__c = dcm.Id;
        dabm.Active__c = true;
        dabm.Attachement_Id__c = attach.id;
        insert dabm;
        
        ApexPages.currentPage().getParameters().put('attachId', dabm.Id);
        DocCategoryHelper  var = new DocCategoryHelper();
        var.viewPDF();
    }
}