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
        //TODO: Change to checkout page when merging
        return Page.Pizza_Creation_Page;
    }
    
}