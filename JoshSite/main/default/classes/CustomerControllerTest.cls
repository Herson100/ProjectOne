@isTest
public class CustomerControllerTest 
{
    @testSetup
    public static void setup() //I need a user, first.
    {
        User u = new User();
        u.LastName = 'Inv #';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'Frederickson55597@Frederick.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = [SELECT id FROM Profile WHERE name = 'System Administrator' LIMIT 1].id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.IsActive = true; 
        u.UserRoleID = [SELECT id FROM UserRole WHERE name = 'CEO' LIMIT 1].id;
        Insert u;
    }
    
    @isTest
    public static void PageTest()
    {
        Test.startTest();
        
        User u = [SELECT Id FROM User WHERE Username = 'Frederickson55597@Frederick.com' LIMIT 1];
    
        List<Shopping_Cart__c> someCarts = new List<Shopping_Cart__c>(); //We need some carts associated with our user. 
        for(Integer i = 0; i < 5; i++)
        {
            someCarts.Add(new Shopping_Cart__c(ownerID = u.id));
        }
        Insert someCarts;
        
        List<Pizza__c> somePizzas = new List<Pizza__c>();
        
        for(Integer i = 0; i < 5; i++) //Just adding one pizza per cart. 
        {
            somePizzas.add(new Pizza__c(shopping_cart__c = someCarts.Get(i).id, size__c = 'small'));
        }
        
        System.debug([SELECT ownerID, Order_Is_ready__c FROM Shopping_Cart__c]);
        
        Insert somePizzas;
        for(Pizza__c piz : somePizzas)
        {
            piz.isFinished__c = true;
            System.debug(piz.Shopping_Cart__c);
        }
        Update somePizzas; 
        for(Shopping_Cart__c cart : someCarts)
        {
            cart.Order_is_ready__c = true; //We have to do these update steps because of the automation happening with the carts. 
        }
        Update someCarts; 
        
        System.runAs(u)
        {
            CustomerController con2 = new CustomerController();
            System.assertEquals(5, con2.allOrders.size()); //We should have a total of five carts associated with the user.
            System.assertEquals(5, con2.allPizzas.size()); //we should have a total of five pizzas associated with the user.
            con2.Next();
            System.assertEquals(1, con2.allOrders.indexof(con2.allOrders.get(con2.currentPosition))); //Did we move to the 1 position of the list.
            System.assertEquals(con2.cartToDisplay, con2.allOrders.get(1)); //Are we displaying the right cart?
            System.assertEquals(2, con2.currentPizzas.size()); //This value should be two because of how we're displaying the order total. 
            System.assertEquals(con2.cartToDisplay.id, con2.currentPizzas.get(0).shopping_cart__c); //Does the current pizza refer to the right shopping cart?
            
            con2.Previous();
            System.assertEquals(0, con2.allOrders.indexof(con2.allOrders.get(con2.currentPosition))); //Did we move back to the 0 position?
            System.assertEquals(con2.cartToDisplay, con2.allOrders.get(0)); //Are we displaying the right cart? 
            
            con2.ReOrder1();
            List<Shopping_Cart__c> submittedCarts = [SELECT Id FROM Shopping_Cart__c WHERE order_is_ready__c = false]; //We ordered one new order. 
            System.assertEquals(1, submittedCarts.size()); 
            List<Pizza__c> newPizza = [SELECT id FROM Pizza__c WHERE Shopping_Cart__c = : submittedCarts.get(0).id];
            System.assertEquals(1, newPizza.size()); //The submitted cart should have only included one pizza. 
        }
        
        Test.stopTest(); //Testing for bulk doesn't really make sense here; there should only ever be one user on a page at a time. 
    } //There shouldn't be restricted users who have access to the page, and negative results should lead to redirects. 
}