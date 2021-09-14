public without sharing class CustomerController 
{
    public User currentCustomer{get; set;} //Store a reference to our current user. 
    public List<Pizza__c> allPizzas{get; set;} //This will store all pizzas associated with the user's carts. 
    public List<Shopping_Cart__c> allOrders {get; set;} //This will store all of the User's completed orders. 
    public Shopping_Cart__c cartToDisplay{get; set;} //This is the previous order we're currently displaying. 
    public List<Pizza__c> currentPizzas{get; set;} //This is the list of pizzas in the order we're currently displaying. 

    @testvisible
    Integer currentPosition{get; set;} //This is our current index position in the list of allOrders. 
    
    public CustomerController() 
    { 
        if(System.UserInfo.getUserId() != null) //There won't be any orders to display if we don't have a current user. 
        {
            SetCustomer(System.UserInfo.getUserID());

            if(allOrders.size() > 0 && allPizzas.size() > 0) //If our query found some orders, we display those. Otherwise, we'll redirect.
            {
                InitOnLoad();
            }
        }
        else
        {
            //To DO: REDIRECT
        }
    }
    
    public PageReference noOrdRedirect()
    {
        if(System.UserInfo.GetUserId() == null || allOrders.size() == 0)
        {
        Page.NoOrders.setRedirect(true);
        return Page.NoOrders;
        }
        else{return null;}
    }
    
    public void SetCustomer(id curUser)
    {
        currentCustomer = [SELECT id FROM User WHERE id = : curUser LIMIT 1]; 
        allOrders = [SELECT id, Total_Cost__c FROM Shopping_Cart__c WHERE ownerID = : currentCustomer.id AND Order_is_ready__c = true]; 
        allPizzas = [SELECT id, Price__c, Toppings__c, Shopping_Cart__c, Size__c FROM Pizza__c WHERE Shopping_Cart__c IN : allOrders];
        currentPosition = 0;
    }
    
    public void InitOnLoad()
    {
        cartToDisplay = allOrders.get(0);
        currentPizzas = new List<Pizza__c>();
        SetPizzas(cartToDisplay.id);
    }
    
    public void SetPizzas(id cartID) //This function is called when we want to change our currently displayed order/pizzas. 
    {
        currentPizzas.clear();
        for (Pizza__c pizza : allPizzas)
        {
            if(pizza.Shopping_Cart__c == cartID)
            {
                currentPizzas.add(pizza);
            }
        }
        currentPizzas.add(new Pizza__c(size__c = null, Toppings__c = null, price__c = cartToDisplay.Total_Cost__c)); 
        //Probably not the ideal way to display a total...
    }
    
    public void Next() //Move forward on our list of all orders by one step. 
    {
        if(currentPosition < allOrders.size() - 1)
        {
            currentPosition += 1;
            cartToDisplay = allOrders.get(currentPosition);
            SetPizzas(cartToDisplay.id);
        }
    }
    
    public void Previous() //Move backward on our list of all orders by one step. 
    {
        if(currentPosition > 0)
        {
            currentPosition -= 1;
            cartToDisplay = allOrders.get(currentPosition);
            SetPizzas(cartToDisplay.id);
        }
    }
    
    public PageReference ReOrder1() //This function creates a new order 
    {
        Shopping_Cart__c newOrder = new Shopping_Cart__c(ownerId = currentCustomer.id); 
        List<Pizza__c> newPizzas = new List<Pizza__c>();
        Insert newOrder;
        for(Pizza__c pizza : currentPizzas)
        {
            if(pizza.size__c != null)
            {
            newPizzas.add(new Pizza__c(Shopping_Cart__c = newOrder.id, toppings__c = pizza.Toppings__c, size__c = pizza.size__c));
            }
        }
        Database.Insert(newPizzas);
        Page.ordPla.setRedirect(true);
        return Page.ordPla;
    }
    
    /*
    Ideally, I think this would use a wrapper class and the VF page would have the ability to show multiple results at a time. 
    I originally tried something along those lines but ran into issues, and ultimately I've kind of run out of time to refine this before the P1 Presentation. 
    
    */
    
}