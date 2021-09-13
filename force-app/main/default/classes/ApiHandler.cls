public class ApiHandler {
    private static final String distanceCalculatorUrl = 'https://api.tomtom.com/routing/1/calculateRoute/';
    private static final String geocoderUrl = 'https://api.tomtom.com/search/2/geocode/';
    private static final String keyXml = 'xml?key=9sJWV9i2gsog74RN6XwGdFMLosz8iAwN';
    private static final String keyJSON = 'json?key=9sJWV9i2gsog74RN6XwGdFMLosz8iAwN';

    
    public static HTTpRequest requestCoordinates(String body) {
        HTTpRequest output = new HTTpRequest();
        output.setMethod('GET');
        output.setEndpoint(geocoderUrl + body + '.' + keyXml);
        
        return output;
    }
    
    public static String parseGeocoder(Dom.Document domOutput, boolean latitude) {
        Dom.XMLNode root = domOutput.getRootElement();
        Dom.XMLNode[] element = root.getChildElements();
        element = element[1].getChildElements();
        element = element[0].getChildElements();
        element = element[4].getChildElements();
        String output = latitude ? element[0].getText() : element[1].getText();
        System.debug(output);
        
        return output;
    }
    
    
    
    public static HTTpRequest requestDistance(String startLatitude, String startLongitude, String destinationLatitude, String destinationLongitude) {
        HTTpRequest output = new HTTpRequest();
        output.setMethod('GET');
        output.setEndpoint(distanceCalculatorUrl + startLatitude + '%2C' + startLongitude + '%3A' + destinationLatitude + '%2C' + destinationLongitude + '/' + keyXml);
        
        return output;
    }
    
    public static Integer parseDistanceCalculator(Dom.Document domOutput) {
        Dom.XMLNode root = domOutput.getRootElement();
        Dom.XMLNode[] element = root.getChildElements();
        element = element[0].getChildElements();
        element = element[0].getChildElements();
        String output = element[1].getText();
        System.debug(output);
        
        return Integer.valueOf(output);
    }
}