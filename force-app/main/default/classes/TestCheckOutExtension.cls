@isTest
public class TestCheckOutExtension {
    
    @testSetup
    static void setup(){

        ID sysAdmin = [SELECT id FROM profile WHERE name = 'System Administrator' LIMIT 1].id;
        ID CEO = [SELECT id FROM UserRole WHERE name = 'CEO' LIMIT 1].id;
        User testUser = new User(LastName = 'Inv #', Email = 'test@test.com', Alias = 'Tcode', 
                                  LocaleSidKey = 'en_US', TimeZoneSidKey = 'GMT', 
                                 LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', IsActive = true,
                                 ProfileId = sysAdmin,  UserRoleID = CEO, username = (Math.random()+'@'+Math.random()+'.test') );
        
        Insert testUser;
        
        //adding an empty cart
        List<shopping_cart__c> testCart = new List<shopping_cart__c>();
        
        System.runAs(testUser){
        testCart.add(new shopping_cart__c());
        Insert testCart;
        }
        
        
    }
    
    @isTest
    static void TestCheckout(){
        setup();
        Test.startTest();
        
        User tester = [SELECT id FROM USER WHERE LastName = 'Inv #' LIMIT 1];
        System.runAs(tester){
            
            //constructor
            ApexPages.StandardSetController controller = new ApexPages.StandardSetController(
                [SELECT name, ownerID, Size__c, Toppings__c, Price__c, shopping_cart__c FROM pizza__C]);
            CheckoutExtension ce = new CheckoutExtension(controller);
            
            // testing PizzaDummy and checking total in cart
            ce.addPizzaDummy();
            ce.addPizzaDummy();
            List<shopping_cart__c> getPrice = [SELECT total_cost__c FROM shopping_cart__C WHERE OrderSubmitted__c = false];
            System.assertEquals(28.00, getPrice[0].total_cost__c);
            
            // testing cartCreation deleting unsubmitted cart
            ce.CartCreation();
            System.assertEquals(0, ce.getTotalPrice());
            
            //testing populate cart
            ce.addPizzaDummy();
            ce.PopulateCart();
            Decimal priceChecker = ce.currentCart[0].price__c;
            System.assertEquals(14, priceChecker);
            
            //testing Buy which submit the cart and create new one.
            ce.Buy();
            getPrice = [SELECT total_cost__c FROM shopping_cart__C WHERE OrderSubmitted__c = false];
            System.assertEquals(0, getPrice[0].total_cost__c);
            
        }
        
        //97% code coverage
        Test.stopTest();
        
        
        
    }
    
}