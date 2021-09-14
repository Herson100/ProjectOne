@isTest
public class TestSubmitApplication {

 @testSetup
    public static void setup(){
        Application__c var = new Application__c();
        var.Phone__c = '1234567890';
        insert var;
    }

  @isTest
    public static void positiveTestMydoc(){
        test.startTest();
        List<Application__c> appList = [SELECT ID FROM Application__c];
        system.assertNotEquals(0, appList.size());
        ApexPages.StandardController controller = new ApexPages.StandardController([SELECT ID FROM Application__c]);
        SubmitApplication testExtension = new SubmitApplication(controller);

        Attachment temp = new Attachment();
        system.assertEquals(testExtension.myDocument, null);
        system.assertNotEquals(testExtension.myDoc, null);
        system.assertNotEquals(testExtension.myDocument, null);                
    }
    
    @isTest
    public static void positiveTestUpload(){
        ApexPages.StandardController controller = new ApexPages.StandardController([SELECT ID FROM Application__c]);
        SubmitApplication testExtension = new SubmitApplication(controller);
        testExtension.appFile.First_Name__c = 'test1';
        testExtension.appFile.Last_Name__c = 'user1';
        testExtension.appFile.Phone__c = '1234567890';
        testExtension.appFile.Email__c = 'test@user.com';
        testExtension.appFile.Details__c = 'details';
        
        List<Application__c> tempApp = [SELECT ID FROM Application__c];
        integer old = tempApp.size();
        testExtension.upload();
        tempApp = [SELECT ID FROM Application__c];
        integer new1 = tempApp.size();
        system.assertEquals(old+1,new1);
        
    }
       @isTest
    	public static void negativeTestUpload(){
        ApexPages.StandardController controller = new ApexPages.StandardController([SELECT ID FROM Application__c]);
        SubmitApplication testExtension = new SubmitApplication(controller);
        testExtension.appFile.First_Name__c = 'test1';
        testExtension.appFile.Last_Name__c = 'user1';
        testExtension.appFile.Phone__c = '123'; // the phone number is not meeting the USA phone number criteria
        testExtension.appFile.Email__c = 'test@user.com';
        testExtension.appFile.Details__c = 'details';        

        List<Application__c> tempApp = [SELECT ID FROM Application__c];
        integer old = tempApp.size();
        testExtension.upload();
        tempApp = [SELECT ID FROM Application__c];
        integer new1 = tempApp.size();
        system.assertEquals(old,new1);        
    }
}