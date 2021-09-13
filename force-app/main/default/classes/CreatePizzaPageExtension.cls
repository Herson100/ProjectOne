public class CreatePizzaPageExtension {
	private Pizza__c pizza;
    public CreatePizzaPageExtension(ApexPages.StandardController stdController){
        this.pizza = (Pizza__c)stdController.getRecord();
    }
    
    public String getCurrPrice(){
        List<pizza__c> pizzas = new List<pizza__c>();
        pizzas.add(pizza);
        TriggerHelper.updatePrice(pizzas);
        return '' + pizzas[0].price__c;
    }

    public PageReference toCheckout(){
        return Page.Checkout;
    }

    public String getPizzaIMG(){
        System.debug(pizza.toppings__c);
        switch on pizza.toppings__c{
            when null{
                return 'Cheese_Pizza.png';
            }
            when 'Pepporoni'{
                return 'PizzaP.png';
            }
            when 'Bacon'{
                return 'PizzaB.png';
            }
            when 'Sausage'{
                return 'PizzaS.png';
            }
            when 'Pineapple'{
                return 'PizzaPineapple.png';
            }
            when ('Pepporoni;Bacon'){
                return 'PizzaPB.png';
            }
            when ('Pepporoni;Sausage'){
                return 'PizzaPS.png';
            }
            when ('Pepporoni;Pineapple'){
                return 'PizzaPP.png';
            }
            when ('Pepporoni;Bacon;Sausage'){
                return 'PizzaPBS.png';
            }
            when ('Pepporoni;Bacon;Pineapple'){
                return 'PizzaPBP.png';
            }
            when ('Pepporoni;Sausage;Pineapple'){
                return 'PizzaPSP.png';
            }
            when ('Pepporoni;Bacon;Sausage;Pineapple'){
                return 'PizzaPBSP.png';
            }
            when ('Bacon;Sausage'){
                return 'PizzaSB.png';
            }
            when ('Bacon;Pineapple'){
                return 'PizzaBP.png';
            }
            when ('Bacon;Sausage;Pineapple'){
                return 'PizzaSBP.png';
            }
            when ('Sausage;Pineapple'){
                return 'PizzaSP.png';
            }
        }
        return 'Cheese_Pizza.png';
    }

    //Saves pizza to database
    public void SavePizza(){
        insert pizza;
    }
    
}