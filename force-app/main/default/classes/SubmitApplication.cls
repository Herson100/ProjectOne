public class SubmitApplication {
   
    public Application__c appFile;
	public final Career__c acct; 
    // constructor is for job list page
    public SubmitApplication(ApexPages.StandardSetController controller) {}
    // constructor for application page
    public SubmitApplication(ApexPages.StandardController controller){
        appFile = (Application__c)controller.getRecord();
    }

    public transient Attachment myDocument;
    public Attachment myDoc{
        get{
            if(myDocument==null){
                myDocument = new Attachment();
            }
            return myDocument;
        }
        set;
    }

    public PageReference upload(){
        Application__c newApp = new Application__c(); 
        newApp.First_Name__c = appFile.First_Name__c;
        newApp.Last_Name__c = appFile.Last_Name__c;
        newApp.Phone__c = appFile.Phone__c;
        newApp.Email__c = appFile.Email__c;
        newApp.Details__c = appFile.Details__c;
        try {
            Insert newApp; 
            myDoc.parentId = newApp.Id;
            insert myDoc; 
        } catch (DMLException e){
            ApexPages.addMessages(e);
            return null;
        } 
        ApexPages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Application submitted!'));
        return null;
    }
        // redirect to Application page
    public PageReference applyJob() {
        PageReference pageRef = new PageReference('/apex/application');
        return pageRef;    
    }
        // redirect to FirstPage (Job Lists)
    public PageReference jobList(){
       // PageReference pageRef = new PageReference('/apex/FirstPage');
       // Changing to redirect to home page. 
        PageReference pageRef = new PageReference('https://joesfloatingpalace-developer-edition.na163.force.com/CustomerTest');
       return pageRef;    
    }
   
}