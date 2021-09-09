public class LocationWrapper {
    public Location__c location {get; set;}
    public Integer distance {get; set;}
    
    public LocationWrapper(Location__c input) {
        location = input;
        distance = 1000000;
    }
}