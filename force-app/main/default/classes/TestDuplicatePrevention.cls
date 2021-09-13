@isTest

public class TestDuplicatePrevention {
    static void setup(){
        list<order_ticket__c> testTickets = new List<order_ticket__c>();
        list<user> testUsers = new List<user>();
        list<pizza__c> testPizzas = new List<pizza__c>();

        for (Integer i = 0; i < 10; i++){
            testPizzas.add(new Pizza__c(size__c = 'Medium'));
            testUsers.add(new User(username = 'user' + i + '@revature.com', lastName = 'user ' + i, email = 'user' + i + '@revature.com', alias = 'user ' + i, timeZoneSidkey = 'America/New_York', localesidkey = 'en_US', languagelocalekey = 'en_US', emailencodingkey = 'UTF-8', isActive = false, profileID = '00e5e000000iWpX'));

        }
        Insert testPizzas;
        Insert testUsers;
        list<Pizza__C> testPizzaIDs = [SELECT id FROM Pizza__c ORDER BY id];
        list<User> testUserIDs = [SELECT id, lastName FROM user ORDER BY id];
        for (Integer i = 0; i < 10; i++){
            testTickets.add(new order_ticket__c(Pizza__c = testPizzaIDs[i].id, cook__c = testUserIDs[i].id));
        }
        Insert testTickets;
    }

    //Tests tickets that ought to be rejected as duplicates
    @isTest
    static void testTheTickets(){
        Test.startTest();
        setup();
        List<Pizza__c> Pizzas = [SELECT ID FROM pizza__c ORDER BY ID];
        List<User> Users = [SELECT ID FROM User ORDER BY ID];
        List<Order_Ticket__C> badTickets = new List<Order_Ticket__C>();
        List<Order_Ticket__C> goodTickets = new List<Order_Ticket__C>();

        //Generates a list of duplicate tickets
        for(Integer i = 0; i < Pizzas.size(); i++) {
            badTickets.add(new order_ticket__c(pizza__c = Pizzas[i].id, cook__c = Users[i].id));
        }
        //Tests bulk insert of false tickets
        try {
            insert badTickets;
            System.debug('bad bulk tickets failed');
            system.assert(false);
        } catch (System.Exception e){
            System.assert(true);
        }

        //Tests insert of individual false ticket
        try {
            insert badTickets[5];
            System.debug('bad individual ticket failed');
            system.assert(false);
        } catch (System.Exception e){
            System.assert(true);
        }

        //Generates list of nonduplicate, good tickets
        for(Integer i = 0; i < Pizzas.size()-1; i++) {
            goodTickets.add(new order_ticket__c(pizza__c = Pizzas[i].id, cook__c = Users[i+1].id));
        }

        //Tests bulk insert of good tickets
        try {
            insert goodTickets;
            system.assert(true);
        } catch (System.Exception e){
            System.debug('good bulk tickets failed');
            System.assert(false);
        }
        //creates a new good ticket
        goodTickets.add(new order_ticket__c(pizza__c = Pizzas[0].id, cook__c = Users[2].id));
        //Tests insert of individual good ticket
        try {
            insert goodTickets[goodTickets.size()-1];
            system.assert(true);
        } catch (System.Exception e){
            System.debug('good individual ticket failed');
            System.assert(false);
        }

        Test.stopTest();
    }
}