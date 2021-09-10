public class LocationWrapper implements Comparable{
    public Location__c location {get; set;}
    public String name {get; set;}
    public Integer seconds {get; set;}
    public Integer minutes {get; set;}
    public Integer hours {get; set;}
    public String deliveryTime {get; set;}
    
    public LocationWrapper(Location__c input) {
        location = input;
        name = location.name;
        seconds = 5400;
        //refresh();
    }
    
    public Integer compareTo(object forCompare) {
        LocationWrapper comp = (LocationWrapper) forCompare;
        
        Integer output = 0;
        
        if (seconds > comp.seconds) {
            output = 1;
        }
        if (seconds < comp.seconds) {
            output = -1;
        }
        if ((seconds == null) && (comp.seconds != null)) {
            output = 1;
        }
        if ((seconds != null) && (comp.seconds == null)) {
            output = -1;
        }
        
        return output;
    }
    
    public void refresh() {
        minutes = seconds/60;
        hours = minutes/60;
        minutes = math.mod(minutes, 60);
        deliveryTime = '';
        if (hours > 0) {deliveryTime += String.valueOf(hours) + ' hour';
                        deliveryTime += (hours > 1 ? 's, ' : ', ');}
        deliveryTime += String.valueOf(minutes) + ' minute';
        if (minutes != 1) {deliveryTime += 's';}
    }
}