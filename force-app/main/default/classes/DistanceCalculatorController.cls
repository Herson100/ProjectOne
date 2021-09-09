public class DistanceCalculatorController {
    public Integer inputHolder {get; set;}
    public String tempOutput {get; set;}
    
    public List<List<String>> test {get; set;}
    public List<Location__c> tempLocations {get; set;}
    public List<LocationWrapper> locations {get; set;}
    public String destination {get; set;}
    public String apiUrl {get; set;}
    public String startLatitude {get; set;}
    public String startLongitude {get; set;}
    public String destinationLatitude {get; set;}
    public String destinationLongitude {get; set;}
    public String keyXml {get; set;}
    public String keyJSON {get; set;}
    public String tempLatitude {get; set;}
    
    public DistanceCalculatorController() {
        test = new List<List<String>>{new List<String>{'0','1','2'}, new List<String>{'a','b','c'}};
        inputHolder = 0;
        tempOutput = 'output here';  
        tempLocations = [SELECT Name, LocationField__longitude__s, LocationField__latitude__s FROM Location__c LIMIT 20];
        locations = new List<LocationWrapper>();
        for (Location__c current : tempLocations) {
            locations.add(new LocationWrapper(current));
        }
        apiUrl = 'https://api.tomtom.com/routing/1/calculateRoute/';
        
        startLatitude = String.valueOf(tempLocations[0].locationField__latitude__s);//'52.50931';
        startLongitude = String.valueOf(tempLocations[0].locationField__longitude__s);//'13.42936';
        destinationLatitude = String.valueOf(tempLocations[1].locationField__latitude__s);//'52.50274';
        destinationLongitude = String.valueOf(tempLocations[1].locationField__longitude__s);//'13.43872';
        keyXml = '/xml?key=9sJWV9i2gsog74RN6XwGdFMLosz8iAwN';
        keyJSON = '/json?key=9sJWV9i2gsog74RN6XwGdFMLosz8iAwN';
        
    }
    
    public void remover() {
        tempOutput = String.valueOf(compare(destinationLatitude, destinationLongitude, tempLocations[inputHolder]));
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
            current.distance = compare(String.valueOf(tempLocations[inputHolder].locationField__latitude__s), String.valueOf(tempLocations[inputHolder].locationField__longitude__s), current.location);
        }
    }
    
    public HTTpRequest request(String apiUrl, String startLatitude, String startLongitude, String destinationLatitude, String destinationLongitude, String key) {
        HTTpRequest output = new HTTpRequest();
        output.setMethod('GET');
        output.setEndpoint(apiUrl + startLatitude + '%2C' + startLongitude + '%3A' + destinationLatitude + '%2C' + destinationLongitude + key);
        
        return output;
    }
    
    public HTTpRequest request() {
        return request(apiUrl, startLatitude, startLongitude, destinationLatitude, destinationLongitude, keyXml);
    }
    
    public Integer xmlParse(Dom.Document domOutput) {
        Dom.XMLNode root = domOutput.getRootElement();
        Dom.XMLNode[] r2 = root.getChildElements();
        Dom.XMLNode[] r3 = r2[0].getChildElements();
        Dom.XMLNode[] r4 = r3[0].getChildElements();
        String output = r4[1].getText();
        System.debug(output);
		
        return Integer.valueOf(output);
    }
    
    public Integer compare(String destinationLatitude, String destinationLongitude, Location__c start) {
        
        HTTP h = new HTTP();
        HTTpResponse result = h.send(request(apiUrl, String.valueOf(start.locationField__latitude__s), String.valueOf(start.locationField__longitude__s), destinationLatitude, destinationLongitude, keyXml));  
        return xmlParse(result.getBodyDocument());
    }
}