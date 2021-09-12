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

    public Component.Apex.Image getPizzaIMG(){
        switch on pizza.toppings__c{
            when null{
                return [SELECT Body FROM StaticResource WHERE Name = 'Cheese_Pizza'].get(0);
            }
            when 'Pepporoni'{
                return [SELECT Body FROM StaticResource WHERE Name = 'pizzaP'].get(0);
            }
            when 'Bacon'{
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaB'].get(0);
            }
            when 'Sausage'{
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaS'].get(0);
            }
            when 'Pineapple'{
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaPineapple'].get(0);
            }
            when ('pepporoni;bacon'){
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaPB'].get(0);
            }
            when ('pepporoni;sausage'){
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaPS'].get(0);
            }
            when ('pepporoni;pineapple'){
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaPP'].get(0);
            }
            when ('pepporoni;bacon;sausage'){
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaPBS'].get(0);
            }
            when ('pepporoni;bacon;pineapple'){
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaPBP'].get(0);
            }
            when ('pepporoni;sausage;pineapple'){
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaPSP'].get(0);
            }
            when ('pepporoni;bacon;sausage;pineapple'){
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaPBSP'].get(0);
            }
            when ('bacon;sausage'){
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaBS'].get(0);
            }
            when ('bacon;pineapple'){
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaBP'].get(0);
            }
            when ('bacon;sausage;pineapple'){
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaBSP'].get(0);
            }
            when ('sausage;pineapple'){
                return [SELECT Body FROM StaticResource WHERE Name = 'PizzaSP'].get(0);
            }
        }
        return [SELECT Body FROM StaticResource WHERE Name = 'Cheese_Pizza'].get(0);
    }

    //Saves pizza to database
    public void SavePizza(){
        insert pizza;
    }
    
}