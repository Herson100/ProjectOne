@isTest
public class TestCheckOutExtension {
    
    @testSetup
    static void setup(){
        List<shopping_cart__c> testCart = new List<shopping_cart__c>();
        
        testCart.add(new shopping_cart__c());
        Insert testCart;
        
    }
    
    @isTest
    static void TestCheckout(){
        setup();
        Test.startTest();
        
        //CheckoutExtension.getTotalPrice();
        
    }
    
}