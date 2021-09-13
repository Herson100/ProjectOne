public class OrderCompleteController {
    public String readyTime {get; set;}
    
    public OrderCompleteController() {
        readyTime = 'Will be ready in ';
        readyTime += System.currentPageReference().getParameters().get('readyTime');
        //readyTime += 'it\'s own time';
    }
}