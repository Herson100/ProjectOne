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
        switch on pizza.toppings__c{
            when null{
                return 'Cheese_Pizza.png';
            }
            when 'Pepporoni'{
                return 'pizzaP.png';
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
            when ('pepporoni;bacon'){
                return 'PizzaPB.png';
            }
            when ('pepporoni;sausage'){
                return 'PizzaPS.png';
            }
            when ('pepporoni;pineapple'){
                return 'PizzaPP.png';
            }
            when ('pepporoni;bacon;sausage'){
                return 'PizzaPBS.png';
            }
            when ('pepporoni;bacon;pineapple'){
                return 'PizzaPBP.png';
            }
            when ('pepporoni;sausage;pineapple'){
                return 'PizzaPSP.png';
            }
            when ('pepporoni;bacon;sausage;pineapple'){
                return 'PizzaPBSP.png';
            }
            when ('bacon;sausage'){
                return 'PizzaBS.png';
            }
            when ('bacon;pineapple'){
                return 'PizzaBP.png';
            }
            when ('bacon;sausage;pineapple'){
                return 'PizzaBSP.png';
            }
            when ('sausage;pineapple'){
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