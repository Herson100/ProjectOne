@isTest
public class TestCreatePizzaPageExtension {
    
    @TestSetup
    static void setup(){
        User u = new User();
        u.LastName = 'Inv #';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'adsnhefwuh@hdfhjfhj.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = [SELECT id FROM Profile WHERE name = 'System Administrator' LIMIT 1].id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.IsActive = true; 
        u.UserRoleID = [SELECT id FROM UserRole WHERE name = 'CEO' LIMIT 1].id;
        u.street = 'street';
        u.city = 'city';
        u.state = 'state';
        u.postalCode = '0';
        Insert u;
    }

    @isTest
    static void testPage(){
        Test.startTest();

        User u = [SELECT id FROM User WHERE LastName = 'Inv #'  LIMIT 1];
        Shopping_Cart__C testCart = new Shopping_Cart__C(OwnerID = u.id);
        insert testCart;

        System.runAs(u){
            Pizza__C pizza = new Pizza__C(size__c = 'Medium', Shopping_Cart__c = testCart.id, recordTypeID = Schema.SObjectType.Pizza__C.GetRecordTypeInfosByDeveloperName().get('Custom_Order').getRecordTypeID());
            insert pizza;
            ApexPages.StandardController testcont = new ApexPages.StandardController(Pizza);
            CreatePizzaPageExtension ext = new CreatePizzaPageExtension(testcont);
            ext.pizza.size__c = 'Medium';
            System.assertEquals(pizza.recordTypeID, Schema.SObjectType.Pizza__C.GetRecordTypeInfosByDeveloperName().get('Custom_Order').getRecordTypeID());
            ext.pizza.toppings__c = 'Sausage';
            //Testing pizza price check
            System.assertEquals(ext.getCurrPrice(), '' + 14.50);
            //Testing page references
            System.assertEquals(ext.toCheckout().getURL(), Page.checkout.getURL());
            //Testing getPizzaIMG
            System.assertEquals(ext.getPizzaIMG(), 'PizzaS.png');
            ext.pizza.toppings__c = 'Pepporoni;Bacon';
            System.assertEquals(ext.getPizzaIMG(), 'PizzaPB.png');
            //Testing savePizza
            //ext.savePizza();
            List<Pizza__C> Pizzas = [SELECT id FROM Pizza__C];
            System.assertEquals(pizzas[0].id, ext.pizza.id);
        }
    }
}