public class CheckoutExtension {

    public Integer property {get; set;}
    
    public CheckoutExtension(ApexPages.StandardSetController controller) {
        
    }
    
     
    public void CustomFunction() {
        Shopping_Cart__c shopCart = new Shopping_Cart__c();
        Insert shopCart;
        
        System.debug(shopCart.id);
    }
    
    /** Vi Nguyen
      * create a cart 
      * go to pizza page with cart id 
      */
    public PageReference cartThenPage(){
        
        Shopping_Cart__c shopCart = new Shopping_Cart__c();
        Insert shopCart;
        System.debug(shopCart.id);
        
        return Page.testerPage;
    }
    
}