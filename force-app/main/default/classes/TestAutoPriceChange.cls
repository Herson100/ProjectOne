@isTest
public class TestAutoPriceChange {
    
    static void setup(){
        list<pizza__c> testPizzas = new List<pizza__c>();
        for (Integer i = 0; i < 50; i++){
            testPizzas.add(new Pizza__c(size__c = SizeHelper(math.mod(i,4)), toppings__c = ToppingsHelper(math.mod(i,2)), recordTypeID = specialHelper(math.mod(i, 8))));
        }
        for (Pizza__c curr : testPizzas){
            if (curr.RecordTypeID == Schema.SObjectType.Pizza__C.GetRecordTypeInfosByDeveloperName().get('meatLoverSpecial').getRecordTypeID()){
                curr.toppings__c = ToppingsHelper(500);
            }
        }
        Insert testPizzas;
    }
    
    //The actual test function
    @isTest
    static void TestPizzaPriceChange(){
        Test.startTest();
        setup();
        list<pizza__c> Pizzas = [SELECT id, price__c, size__c, RecordTypeID FROM pizza__c ORDER BY id];
        //Storing prices of pizza pre-changes
        list<Decimal> oldPrices = new List<Decimal>();
        for (Pizza__c curr : Pizzas){
            oldPrices.add(curr.price__c);
        }
        //Storing sizes of pizza pre-changes
        list<String> oldSizes = new List<String>();
        for (pizza__c curr : Pizzas){
            oldSizes.add(curr.size__c);
        }
        //Changing Pizza Sizes: Small -> medium, medium -> large, large -> extra large, extra large -> small (except for meat lover specials)
        for (pizza__c curr : Pizzas){
            string initSize = curr.size__c;
            switch on initSize {
                when 'Small' {
                    curr.size__c = 'Medium';
                }
                when 'Medium' {
                    curr.size__c = 'Large';
                }
                when 'Large' {
                    curr.size__c = 'Extra_Large';
                }
                when 'Extra_Large' {
                    if (curr.RecordTypeID != Schema.SObjectType.Pizza__C.GetRecordTypeInfosByDeveloperName().get('meatLoverSpecial').getRecordTypeID()) {
                        curr.size__c = 'Small';
                    }
                }
            }
        }

        update Pizzas;

        Pizzas = [SELECT id, price__c, size__c, RecordTypeID FROM pizza__c ORDER BY id];

        //Testing if the trigger updated prices properly on each pizza
        for (pizza__c curr : Pizzas){
            Integer currIndex = Pizzas.indexOf(curr);
            switch on curr.size__c {
                when 'Small' {
                    System.debug('Extra large to small is ' + (curr.price__c - oldPrices[currIndex]));
                    System.assertEquals(curr.price__c, oldPrices[currIndex]-8);
                }
                when 'Medium' {
                    System.debug('Small to medium is ' + (curr.price__c - oldPrices[currIndex]));
                    System.assertEquals(curr.price__c, oldPrices[currIndex]+4);
                }
                when 'Large' {
                    System.debug('Medium to large is ' + (curr.price__c - oldPrices[currIndex]));
                    System.assertEquals(curr.price__c, oldPrices[currIndex]+2);
                }
                when 'Extra_Large' {
                    if (curr.recordTypeID != Schema.SObjectType.Pizza__C.GetRecordTypeInfosByDeveloperName().get('meatLoverSpecial').getRecordTypeID()){
                        System.debug('Large to extra large is ' + (curr.price__c - oldPrices[currIndex]));
                        System.assertEquals(curr.price__c, oldPrices[currIndex]+2);
                    }
                }
            }
        }

    }
    // A helper function for procedually generating pizzas during setup
    public static String SizeHelper(Integer i){
        String result = '';
        switch on i {
            when 0 {
                result = 'Small';
            }
            when 1 {
                result = 'Medium';
            }
            when 2 {
                result = 'Large';
            }
            when 3 {
                result = 'Extra_Large';
            }
        }
        return result;
    }

    // A helper function for procedually generating pizzas during setup
    public static String ToppingsHelper(Integer i){
        String result = '';
        switch on i {
            when 0 {
                result = '';
            }
            when 1 {
                result = 'pepporoni';
            }
            when 500 {
                result = 'pepporoni;sausage';
            }
        }
        return result;
    }

    // A helper function for procedually generating pizzas during setup
    public static String SpecialHelper(Integer i){
        if (i == 7){
            return Schema.SObjectType.Pizza__C.GetRecordTypeInfosByDeveloperName().get('meatLoverSpecial').getRecordTypeID();
        }
        return Schema.SObjectType.Pizza__C.GetRecordTypeInfosByDeveloperName().get('meatLoverSpecial').getRecordTypeID();
    }
}