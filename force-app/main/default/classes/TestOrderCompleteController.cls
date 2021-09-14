@isTest
public class TestOrderCompleteController {
	
    @isTest
    public static void testContstructor(){
        PageReference testPage = Page.OrderComplete;
        testPage.getParameters().put('readyTime', 'test amount');
        
        Test.setCurrentPage(testPage);
        OrderCompleteController testController = new OrderCompleteController();
        //associate these somehow
        System.assertEquals('Will be ready in test amount', testController.readyTime);
    }
}