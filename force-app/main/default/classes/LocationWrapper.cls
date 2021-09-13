public class LocationWrapper implements Comparable{
    
    public Location__c location {get; set;}
    
    public String name {get; set;}
    public Integer seconds {get; set;}
    public Integer minutes {get; set;}
    public Integer hours {get; set;}
    public String deliveryTime {get; set;}
    
    public LocationWrapper(Location__c inputLocation) {
        location = inputLocation;
        name = location.name;
    }
    
    
    
    public boolean getDistance(String destinationLatitude, String destinationLongitude) {       
        HTTP h = new HTTP();
        try {
            HTTpResponse result = h.send(ApiHandler.requestDistance(String.valueOf(location.locationField__latitude__s), String.valueOf(location.locationField__longitude__s), destinationLatitude, destinationLongitude));  
            seconds = ApiHandler.parseDistanceCalculator(result.getBodyDocument());
        } catch (System.Exception e) {return false;}
        
        refreshDeliveryTime();
        return true;
    }
    
    public void refreshDeliveryTime() {
        minutes = seconds/60;
        hours = minutes/60;
        minutes = math.mod(minutes, 60);
        deliveryTime = '';
        if (hours > 0) {deliveryTime += String.valueOf(hours) + ' hour';
                        deliveryTime += (hours != 1 ? 's, ' : ', ');}
        deliveryTime += String.valueOf(minutes) + ' minute';
        if (minutes != 1) {deliveryTime += 's';}
    }
    
    
    
    public Integer compareTo(object forCompare) {//for Comparable interface
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
}