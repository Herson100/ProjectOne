public without sharing class DistanceCalculatorController {//without sharing because it only queries locations, which are publicly available
    
    public static List<LocationWrapper> locations {get; set;}
    public static String progress {get; set;}
    public static String selectedLocationTime {get; set;}
    public static Id selectedLocation {get; set;}
    
    public static String streetAddress {get; set;}
    public static String city {get; set;}
    public static String state {get; set;}
    public static Integer zip {get; set;}
    
    public DistanceCalculatorController() { 
        getLocationsList();
        progress = '';
        
        streetAddress = '10900 Katella Ave';
        city = 'Garden Grove';
        state = 'CA';
        zip = 92840;
        //getAddressFromContactId('0035f000003PK4UAAW');
        getAddressFromUser();
    }
    
    
    
    
    public void showProgressText() {
        progress = 'Loading';
    }
    
    @future
    public static void geocoder() {
        HTTP h = new HTTp();
        HTTpResponse coordinatesResponse = new HTTpResponse();
        try {
            coordinatesResponse = h.send(ApiHandler.requestCoordinates(addressUrlFormat()));
        } catch (System.exception e) {
            progress = 'Failed (Initial callout failed)';//should never really get here, wouldn't throw an exception
            return;
        }
        if (passCoordiantes(coordinatesResponse)) {progress =  'Complete';}
    }
    
    public static boolean passCoordiantes(HTTpResponse response) {
        String destinationLatitude;
        String destinationLongitude;
        try {
            destinationLatitude = ApiHandler.parseGeocoder(response.getBodyDocument(), true);
            destinationLongitude = ApiHandler.parseGeocoder(response.getBodyDocument(), false);
        } catch (System.Exception e) {
            progress = 'Failed (Geocoder)';
            getLocationsList();
            return false;
        }
        getLocationsList();//needed because static variables are transient on controllers,
        					//and we can only call static variables from a static @future method
        return getAllDistances(destinationLatitude, destinationLongitude);
    }
    
    public static boolean getAllDistances(String destinationLatitude, String destinationLongitude) {
        try {
            for (LocationWrapper currentLocation : locations) {
                if (!currentLocation.getDistance(destinationLatitude, destinationLongitude)) {
                    progress = 'Failed (Distance Calculator)';
                    return false;
                }
            }
        } catch (System.LimitException e) {
            progress = 'Failed (Too many Distance Calculator Callouts';
        }
        locations.sort();
        return true;
    }
    
    
    
    
    public PageReference moveAlong() {
        
        progress = 'Next page with ' + selectedLocationTime;
        Id id =  System.UserInfo.getUserId();
        //Shopping_Cart__c currentCart = [SELECT id FROM Shopping_Cart__c WHER id = :id];//and in progress
        //currentCart.location__c = selectedLocation;
        //Update currentCart;
        
        //delete existing
        Shopping_Cart__c shopCart = new Shopping_Cart__c();
        shopCart.Location__c = selectedLocation;
        shopCart.Delivery_Time__c = selectedLocationTime;
        Insert shopCart;

        //PageReference pageRef = Page.OrderComplete;
        PageReference pageRef = Page.CheckOut;
        pageRef.setRedirect(true);
        //pageRef.getParameters().put('readyTime', selectedLocationTime);
        return pageRef;
        //return null;

    }
    
    
    public static void getLocationsList() {
        List<Location__c> tempLocations = [SELECT Name, LocationField__longitude__s, LocationField__latitude__s
                                           FROM Location__c LIMIT 99];
        locations = new List<LocationWrapper>();
        for (Location__c currentLocation : tempLocations) {
            locations.add(new LocationWrapper(currentLocation));
        }
    }
    
    public static String addressUrlFormat() {
        String output = '';
        if (streetAddress != null) {
            output = streetAddress;
        }
        for (String current : new List<String>{city, state, String.valueOf(zip)}) {
            if (current != null) {
                output = output + '%20' + current;
            }
        }
        for (Integer i = 0; i < output.length(); i++) {
            if (output.contains(' ')) {
                output = output.substringBefore(' ') + '%20' + output.substringAfter(' ');
            } else if (output.contains(',')) {
                output = output.substringBefore(',') + output.substringAfter(',');
            } else {break;}
        }
        return output;
    }
    
    public void getAddressFromContactId(String id) {
        
        Contact contact = new Contact();
        try{
            contact = [SELECT mailingAddress FROM Contact WHERE id = :id LIMIT 1];
        } catch (System.exception e) {return;}
        if (contact.mailingAddress.getCity() == null) {return;}
        
        streetAddress = contact.mailingAddress.getStreet();
        city = contact.mailingAddress.getCity();
        state = contact.mailingAddress.getState();
        try {
            zip = Integer.valueOf(contact.mailingAddress.getPostalCode());
        } catch (System.Exception e) {
            zip = null;
        }
    }
    
    public void getAddressFromUser() {
        
        User user = new User();
        Id id =  System.UserInfo.getUserId();
        try{
            user = [SELECT address FROM User WHERE id = :id LIMIT 1];
            System.debug('User found');
        } catch (System.exception e) {System.debug(e); return;}
        if (user.address == null) {System.debug('No address'); return;}
        if (user.address.getCity() == null) {System.debug('No city'); return;}
        
        streetAddress = user.address.getStreet();
        city = user.address.getCity();
        state = user.address.getState();
        try {
            zip = Integer.valueOf(user.address.getPostalCode());
        } catch (System.Exception e) {
            zip = null;
        }
    }
}