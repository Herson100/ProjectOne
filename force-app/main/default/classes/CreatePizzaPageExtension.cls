public class CreatePizzaPageExtension {
	public Pizza__c pizza;
    //User Stuff
    public ID user = System.UserInfo.GetUserId();
    public List<User> currentUser{get;set;}
    public ID theCart {get;set;}
    public List<shopping_cart__c> unsubmitted = 
        [SELECT name, OrderSubmitted__c
            FROM shopping_cart__c
            WHERE ordersubmitted__c = false AND OwnerID = :user];
    //Constructor
    public CreatePizzaPageExtension(ApexPages.StandardController stdController){
        this.pizza = (Pizza__c)stdController.getRecord();
        currUserSetter();
        pizza.shopping_cart__c = theCart;
    }
    //Used to display the current price
    public String getCurrPrice(){
        List<pizza__c> pizzas = new List<pizza__c>();
        pizzas.add(pizza);
        TriggerHelper.updatePrice(pizzas);
        return '' + pizzas[0].price__c;
    }
    //Returns the page reference for the checkout page
    public PageReference toCheckout(){
        return Page.Checkout;
    }
    //Populates currentUser with user data
    public void currUserSetter(){
        if(user != null){
            currentUser = [SELECT id FROM User WHERE id = : user LIMIT 1];
            if (theCart == null){
                theCart = unsubmitted[0].id;
            }
        }
    }
    //Returns which pizza img to load based on the toppings
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