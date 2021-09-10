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
                return '{!$Resource.Cheese_Pizza}';
            }
            when 'Pepporoni'{
                return '{!$Resource.PizzaP}';
            }
            when 'Bacon'{
                return '{!$Resource.PizzaB}';
            }
            when 'Sausage'{
                return '{!$Resource.PizzaS}';
            }
            when 'Pineapple'{
                return '{!$Resource.PizzaPineapple}';
            }
            when ('pepporoni;bacon'){
                return '{!$Resource.PizzaPB}';
            }
            when ('pepporoni;sausage'){
                return '{!$Resource.PizzaPS}';
            }
            when ('pepporoni;pineapple'){
                return '{!$Resource.PizzaPP}';
            }
            when ('pepporoni;bacon;sausage'){
                return '{!$Resource.PizzaPBS}';
            }
            when ('pepporoni;bacon;pineapple'){
                return '{!$Resource.PizzaPBP}';
            }
            when ('pepporoni;sausage;pineapple'){
                return '{!$Resource.PizzaPSP}';
            }
            when ('pepporoni;bacon;sausage;pineapple'){
                return '{!$Resource.PizzaPBSP}';
            }
            when ('bacon;sausage'){
                return '{!$Resource.PizzaBS}';
            }
            when ('bacon;pineapple'){
                return '{!$Resource.PizzaBP}';
            }
            when ('bacon;sausage;pineapple'){
                return '{!$Resource.PizzaBSP}';
            }
            when ('sausage;pineapple'){
                return '{!$Resource.PizzaSP}';
            }
        }
        return '{!$Resource.Cheese_Pizza}';
    }

    //Saves pizza to database
    public void SavePizza(){
        insert pizza;
    }
    
}