@isTest
public class TestCartPriceUpdate {
        
    static void setup(){
        list<pizza__c> testPizzas = new List<pizza__c>();
        Account testAccount = new Account(name = 'test account');
        shopping_cart__c testCart = new Shopping_Cart__c(Account__c = testAccount.ID); 
        for (Integer i = 0; i < 10; i++){
            testPizzas.add(new Pizza__c(shopping_cart__c = testCart.id, size__c = TestAutoPriceChange.SizeHelper(math.mod(i,4)), toppings__c = TestAutoPriceChange.ToppingsHelper(math.mod(i,2)), recordTypeID = TestAutoPriceChange.specialHelper(math.mod(i, 8))));
        }
        for (Pizza__c curr : testPizzas){
            if (curr.RecordTypeID == Schema.SObjectType.Pizza__C.GetRecordTypeInfosByDeveloperName().get('meatLoverSpecial').getRecordTypeID()){
                curr.toppings__c = TestAutoPriceChange.ToppingsHelper(500);
            }
        }
        insert testAccount;
        insert testCart;
        insert testPizzas;
    }
    @isTest
    static void testTotalCostUpdate(){
        Test.startTest();
        setup();
        list<shopping_cart__c> carts = [SELECT id, total_cost__c FROM shopping_cart__c];
        Decimal startCost = carts[0].total_cost__c;
        //Inserting new pizza into cart, price $14
        Pizza__c testPizza = new Pizza__c(shopping_cart__c = carts[0].id, size__c = 'Medium');
        insert testPizza;
        carts = [SELECT id, total_cost__c FROM shopping_cart__c];
        //Testing if cart price works on pizza inserts
        System.assertEquals(startCost+14, carts[0].total_cost__c);
        //Updating pizza to large, price $16
        testPizza.size__c = 'Large';
        update testPizza;
        carts = [SELECT id, total_cost__c FROM shopping_cart__c];
        //Testing if cart price works on pizza updates
        System.assertEquals(startCost+16, carts[0].total_cost__c);
        //Deleting pizza from cart, price $16
        delete testPizza;
        carts = [SELECT id, total_cost__c FROM shopping_cart__c];
        //Testing if cart price works on pizza deletions
        System.assertEquals(startCost, carts[0].total_cost__c);
        //Undeleting pizza from cart, price $16
        undelete testPizza;
        carts = [SELECT id, total_cost__c FROM shopping_cart__c];
        //Testing if cart price works on pizza undeletions
        System.assertEquals(startCost+16, carts[0].total_cost__c);
        Test.stopTest();
    }
}