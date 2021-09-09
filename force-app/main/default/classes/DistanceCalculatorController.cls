public class DistanceCalculatorController {
    public List<Location__c> tempLocations {get; set;}
    public List<LocationWrapper> locations {get; set;}
    //public String startLatitude {get; set;}
    //public String startLongitude {get; set;}
    public String destinationLatitude {get; set;}
    public String destinationLongitude {get; set;}
    public String addressInput {get; set;}
    
    public DistanceCalculatorController() { 
        tempLocations = [SELECT Name, LocationField__longitude__s, LocationField__latitude__s FROM Location__c LIMIT 20];
        locations = new List<LocationWrapper>();
        for (Location__c current : tempLocations) {
            locations.add(new LocationWrapper(current));
        }
        destinationLatitude = String.valueOf(tempLocations[1].locationField__latitude__s);//'52.50274';
        destinationLongitude = String.valueOf(tempLocations[1].locationField__longitude__s);//'13.43872';
        
    }
    
    public void remover() {
        HTTP h = new HTTp();
        String tempString = '81%20greenwood%20ave%20wakefield%20ma';
        tempString = parseString('81 Greenwood Ave. Wakefield Ma 01880');
        tempString = parseString(addressInput);
        
        destinationLatitude = ApiHandler.xmlParse(h.send(ApiHandler.request(tempString)).getBodyDocument(), true);
        destinationLongitude = ApiHandler.xmlParse(h.send(ApiHAndler.request(tempString)).getBodyDocument(), false);
    }
    
    public void reorder() {
        /*List<AdWrapper> toSort = new List<AdWrapper>();
		for (Integer i = 0; i < adsList.Size(); i++) {
			toSort.add(new AdWrapper(adsList[i]));
		}
		toSort.sort();
		for (Integer i = 0; i < adsList.Size(); i++) {
			adsList[i] = toSort[i].ad;
		}*/
    }
    
    public void compareAll() {
        for (LocationWrapper current : locations) {
            current.distance = compare(destinationLatitude, destinationLongitude, current.location);
        }
    }

    public Integer compare(String destinationLatitude, String destinationLongitude, Location__c start) {
        
        HTTP h = new HTTP();
        HTTpResponse result = h.send(ApiHandler.request(String.valueOf(start.locationField__latitude__s), String.valueOf(start.locationField__longitude__s), destinationLatitude, destinationLongitude));  
        return ApiHandler.xmlParse(result.getBodyDocument());
    }
    
    public String parseString(String input) {
        for (Integer i = 0; i < 20; i++) {
            if (input.contains(' ')) {
                input = input.substringBefore(' ') + '%20' + input.substringAfter(' ');
            } else {
                break;
            }
        }
        return input;
    }
}