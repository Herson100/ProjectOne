public class CheckoutExtension {
    public ID theCart {get;set;} //main cart to track
    public List<Pizza__c> currentCart {get; set;} //whats in the cart  
    String deliveryTime {get; set;}
    Id selectedLocation {get; set;}
    
    //main user to track
    public List<User> currentUser{get;set;} 
    public ID user = System.UserInfo.GetUserId();    
    
    //this List is used 3 times
    public List<shopping_cart__c> unsubmitted = 
        [SELECT name, OrderSubmitted__c, Location__c, Delivery_Time__c
            FROM shopping_cart__c
            WHERE ordersubmitted__c = false AND OwnerID = :user];
    
    //Constructor
    public CheckoutExtension(ApexPages.StandardSetController controller) {
        //CartCreation();
        UserChecker();
        PopulateCart();
        //getTotalPrice();
    }
    
    //check for user to be null then set currentUser to the current user
    public void UserChecker(){
        if(user != null){
            currentUser = [SELECT id FROM User WHERE id = : user LIMIT 1];
            if (theCart == null){
                theCart = unsubmitted[0].id;
            }
        }
    }

    //Show info on cart
    public void PopulateCart(){
    	currentCart = 
            [Select name, ownerID, Size__c, Toppings__c, Price__c, shopping_cart__c
             FROM Pizza__c 
             WHERE Shopping_Cart__c = :theCart AND ownerID = :user];
        //switch testerCart to theCart
    }
    
    public void emptyCart(){
        
    }
    
    //Submit purchase and set OrderSubmitted to true
    public PageReference Buy() {
        System.debug('Congratulation you have bought the pizza');
         List<shopping_cart__c> toBeSubmitted = 
            [SELECT name, OrderSubmitted__c, Delivery_Time__c
             FROM shopping_cart__c
             WHERE ordersubmitted__c = false AND OwnerID = :user];
        
        for(Integer i = 0; i < toBeSubmitted.size(); i++){
            toBeSubmitted[i].orderSubmitted__c = true;
            deliveryTime = toBeSubmitted[i].Delivery_Time__c;
        }
        
        Update toBeSubmitted;
        
        PageReference pageRef = Page.OrderComplete;
        pageRef.setRedirect(true);
        pageRef.getParameters().put('readyTime', deliveryTime);
        return pageRef;
    }
    
    //Create a cart
    public void CartCreation(){
        deleteCart();
       
        Shopping_Cart__c shopCart = new Shopping_Cart__c();
        shopCart.Location__c = selectedLocation;
        shopCart.Delivery_Time__c = deliveryTime;
        Insert shopCart;
        System.debug(shopCart.id);
        theCart = (shopCart.id);
    }
    
    //grabbing prices
    public Decimal getTotalPrice(){
        
            List<Shopping_Cart__C> cartPrice = 
                [SELECT total_cost__c 
                 FROM Shopping_Cart__c
                WHERE ID = :theCart];
        
        System.debug(theCart);
        System.debug(cartPrice[0].total_cost__c);
        return cartPrice[0].total_cost__c;
    }
    
    // delete unsubmitted cart
	public void deleteCart(){
        deliveryTime = unsubmitted[0].Delivery_Time__c;
        selectedLocation = unsubmitted[0].Location__c;
        Delete unsubmitted;
    }
    
    
    // vvv *Dummy testing below* vvv
    
    //adding pizza dummy
    public void addPizzaDummy(){
        List<Pizza__C> pizzaDummy = new List<Pizza__c>();
        pizzaDummy.add(new Pizza__c(size__c = 'Medium',
                                   shopping_cart__c = theCart));
        Insert pizzaDummy;
    }
    

    //go to pizza page
    public PageReference PizzaPage(){
        
        return Page.Pizza_Creation_Page;
    }
    
    //go to checkout page
    public PageReference CheckoutPage(){
        CartCreation();
        return Page.CheckOut;
    }

    
}