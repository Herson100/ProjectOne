public class CheckoutExtension {
    public Integer property {get; set;}
    public ID theCart {get;set;} //main cart to track
    public List<Pizza__c> currentCart {get; set;} //whats in the cart
    public List<User> currentUser{get;set;} //main user to track
    
    public ID testerCart = 'a015f000002IZtPAAW';
    public ID user = System.UserInfo.GetUserId();
    
    public CheckoutExtension(ApexPages.StandardSetController controller) {
        //CartCreation();
        UserChecker();
        PopulateCart();
        getTotalPrice();
    }
    
    //check for user to be null then set currentUser to the current user
    public void UserChecker(){
        if(user != null){
            currentUser = [SELECT id FROM User WHERE id = : user LIMIT 1];
        }
    }
    

    //Show info on cart
    public void PopulateCart(){
    	currentCart = 
            [Select name, ownerID, Size__c, Toppings__c, Price__c, shopping_cart__c
             FROM Pizza__c 
             WHERE Shopping_Cart__c = : theCart AND ownerID = :user];
        //switch testerCart to theCart
        
    }
    
    public void PopulateCart2(){
        currentCart = 
            [Select name, ownerID, Size__c, Toppings__c, Price__c, shopping_cart__c
             FROM Pizza__c 
             WHERE OwnerID = :user];
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
    
    //calculating prices
    public Decimal getTotalPrice(){
        Decimal total = 0;
        for(Pizza__c pizza : currentCart){
            total += pizza.price__c;
        }
        System.debug(total);
        return total;
        
    }
    
    
    /**
     * When user create new cart it will 
     * delete unsubmitted cart that they may have
     **/
	public void deleteUnsubmittedCart(){
        // logic to delete cart
        // Delete cartToDelete;
    }
    
    //adding pizza dummy
    public void addPizzaDummy(){
        List<Pizza__C> pizzaDummy = new List<Pizza__c>();
        pizzaDummy.add(new Pizza__c(size__c = 'Medium',
                                   shopping_cart__c = theCart));
        Insert pizzaDummy;
    }
    
    //go to pizza page
    public PageReference PizzaPage(){
        return Page.testerPage;
    }
    
    //go to checkout page
    public PageReference CheckoutPage(){
        CartCreation();
        return Page.CheckOut;
    }
    
    
}