public without sharing class DistanceCalculatorController {//without sharing because it only queries locations, which are publicly available
    
    public String outputHolder {get; set;}
    public List<Location__c> tempLocations {get; set;}
    public List<LocationWrapper> locations {get; set;}
    
    public static String destinationLatitude {get; set;}
    public static String destinationLongitude {get; set;}
    
    public static String addressInput {get; set;}
    public static String city {get; set;}
    public static String state {get; set;}
    public static Integer zip {get; set;}
    
    public DistanceCalculatorController() { 
        tempLocations = [SELECT Name, LocationField__longitude__s, LocationField__latitude__s FROM Location__c LIMIT 20];
        locations = new List<LocationWrapper>();
        for (Location__c current : tempLocations) {
            locations.add(new LocationWrapper(current));
        }
        destinationLatitude = String.valueOf(tempLocations[1].locationField__latitude__s);
        destinationLongitude = String.valueOf(tempLocations[1].locationField__longitude__s);
    }
    
    
    
    
    //callout methods
    
    public void geocode() {//must be asynchronous, can probably call the others synchronously with itself
        HTTP h = new HTTp();
        HTTpResponse hR = h.send(ApiHandler.request(parseString(addressInput)));
        
        destinationLatitude = ApiHandler.xmlParse(hR.getBodyDocument(), true);
        destinationLongitude = ApiHandler.xmlParse(hR.getBodyDocument(), false);
        
        compareAll();
    }
    
    public void compareAll() {
        for (LocationWrapper current : locations) {
            current.seconds = compare(destinationLatitude, destinationLongitude, current.location);
            current.refresh();
        }
        locations.sort();
    }
    
    public static Integer compare(String destinationLatitude, String destinationLongitude, Location__c start) {
        
        HTTP h = new HTTP();
        HTTpResponse result = h.send(ApiHandler.request(String.valueOf(start.locationField__latitude__s), String.valueOf(start.locationField__longitude__s), destinationLatitude, destinationLongitude));  
        return ApiHandler.xmlParse(result.getBodyDocument());
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //helper methods
    public static String parseString(String input) {
        for (String current : new List<String>{city, state, String.valueOf(zip)}) {
            if (current != null) {
                input = input + '%20' + current;
            }
        }
        for (Integer i = 0; i < 20; i++) {
            if (input.contains(' ')) {
                input = input.substringBefore(' ') + '%20' + input.substringAfter(' ');
            } else {
                break;
            }
        }
        for (Integer i = 0; i < 20; i++) {
            if (input.contains(',')) {
                input = input.substringBefore(',') + input.substringAfter(',');
            } else {
                break;
            }
        }
        return input;
    }
    
    public void getAddressFromContact(Contact contact) {
        addressInput = contact.mailingAddress.getStreet();
        city = contact.mailingAddress.getCity();
        state = contact.mailingAddress.getState();
        //zip = Integer.valueOf(contact.mailingAddress.getPostalCode());
    }
}