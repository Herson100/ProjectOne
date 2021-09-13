@isTest
public class TestOrderIsReady {
    
    static void setup(){
        list<pizza__c> testPizzas = new List<pizza__c>();
        Account testAccount = new Account(name = 'test account');
        shopping_cart__c testCart = new Shopping_Cart__c(Account__c = testAccount.ID); 
        for (Integer i = 0; i < 10; i++){
            testPizzas.add(new Pizza__c(shopping_cart__c = testCart.id, size__c = TestAutoPriceChange.SizeHelper(math.mod(i,4)), toppings__c = TestAutoPriceChange.ToppingsHelper(math.mod(i,2)), recordTypeID = TestAutoPriceChange.specialHelper(math.mod(i, 8))));
        }
        for (Pizza__c curr : testPizzas){
            if (curr.RecordTypeID == '0125e000000uuaAAAQ'){
                curr.toppings__c = TestAutoPriceChange.ToppingsHelper(500);
            }
        }
        insert testAccount;
        insert testCart;
        insert testPizzas;
    }

    @isTest
    static void testOrderIsReady(){
        setup();
        list<shopping_cart__c> carts = [SELECT id, Order_is_Ready__c FROM shopping_cart__c];
        list<pizza__c> pizzas = [SELECT id, isFinished__c, shopping_cart__c FROM pizza__c];
        //At this point, the order should not be ready.
        System.assertEquals(carts[0].Order_is_Ready__c, false);
        //Adds another pizza not in pizzas to the cart.
        Pizza__c newPizza = new Pizza__c(size__c = 'Small', shopping_cart__c = carts[0].id);
        insert newPizza;
        for (Pizza__c currPizza : pizzas){
            currPizza.isFinished__c = true;
        }
        update pizzas;
        //at this point, all but one pizza in the cart is finished - however, the new one we inserted is not.
        carts = [SELECT id, Order_is_Ready__c FROM shopping_cart__c];
        System.assertEquals(carts[0].Order_is_Ready__c, false);
        newPizza.isFinished__c = true;
        update newPizza;
        pizzas = [SELECT id, isFinished__c, shopping_cart__c FROM pizza__c];
        for (pizza__c curr : pizzas){
            System.assert(curr.isFinished__c);
        }
        carts = [SELECT id, Order_is_Ready__c FROM shopping_cart__c];
        //At this point, every pizza in the cart is finished, so the cart should be updated.
        System.assertEquals(carts[0].Order_is_Ready__c, true);

    }

}