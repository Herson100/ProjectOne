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

    //Saves pizza to database
    public void SavePizza(){
        insert pizza;
    }
    
}