public class ApiHandler {//set strings to private
    public static final String distanceCalculatorUrl = 'https://api.tomtom.com/routing/1/calculateRoute/';
    public static final String geocoderUrl = 'https://api.tomtom.com/search/2/geocode/';
    public static final String keyXml = 'xml?key=9sJWV9i2gsog74RN6XwGdFMLosz8iAwN';
    public static final String keyJSON = 'json?key=9sJWV9i2gsog74RN6XwGdFMLosz8iAwN';
    
    
    //distance calculator methods
    public static HTTpRequest request(String startLatitude, String startLongitude, String destinationLatitude, String destinationLongitude) {
        HTTpRequest output = new HTTpRequest();
        output.setMethod('GET');
        output.setEndpoint(distanceCalculatorUrl + startLatitude + '%2C' + startLongitude + '%3A' + destinationLatitude + '%2C' + destinationLongitude + '/' + keyXml);
        
        return output;
    }
    
    public static Integer xmlParse(Dom.Document domOutput) {
        Dom.XMLNode root = domOutput.getRootElement();
        Dom.XMLNode[] element = root.getChildElements();
        element = element[0].getChildElements();
        element = element[0].getChildElements();
        String output = element[1].getText();
        System.debug(output);
        
        return Integer.valueOf(output);
    }
    
    
    //geocoder methods
    public static HTTpRequest request(String body) {
        HTTpRequest output = new HTTpRequest();
        output.setMethod('GET');
        output.setEndpoint(geocoderUrl + body + '.' + keyXml);
        
        return output;
    }
    
    public static String xmlParse(Dom.Document domOutput, boolean latitude) {
        Dom.XMLNode root = domOutput.getRootElement();
        Dom.XMLNode[] element = root.getChildElements();
        element = element[1].getChildElements();
        element = element[0].getChildElements();
        element = element[4].getChildElements();
        String output = latitude ? element[0].getText() : element[1].getText();
        System.debug(output);
        
        return output;
    }
}