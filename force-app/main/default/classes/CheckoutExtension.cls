public class CheckoutExtension {
    public Integer property {get; set;}
    public ID user {get; set;}
    public ID theCart {get;set;}
    public List<Pizza__c> currentCart {get; set;}
    
    public ID testerCart = 'a015f000002IZtPAAW';
    
    public CheckoutExtension(ApexPages.StandardSetController controller) {
        //CartCreation();
        PopulateCart();
    }
    
    //Show info on cart
    public void PopulateCart(){
    	currentCart = 
            [Select name, Size__c, Toppings__c, Price__c, shopping_cart__c
             FROM Pizza__c 
             WHERE Shopping_Cart__c = : testerCart];
        //switch testerCart to theCart
    }
    
    //Submit purchase and set OrderSubmitted to true
    public void Buy() {
        System.debug('Congratulation you have bought the pizza');
    }
    
    //Create a cart
    public void CartCreation(){
        Shopping_Cart__c shopCart = new Shopping_Cart__c();
        Insert shopCart;
        System.debug(shopCart.id);
        theCart = (shopCart.id);
    }
    
    //go to pizza page
    public PageReference PizzaPage(){
        return Page.testerPage;
    }
    
    
}