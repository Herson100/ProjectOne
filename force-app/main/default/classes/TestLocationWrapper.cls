@isTest
public class TestLocationWrapper {

    @TestSetup
    static void makeData(){
        //not used because the class includes no queries or DML
    }

    @isTest
    public static void testGetDistanceSP() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new ApiMock());

        Location__c locationInner = new Location__c();
        locationInner.name = 'testName';
        locationInner.locationField__latitude__s = 30;
        locationInner.locationField__longitude__s = -100;

        LocationWrapper testLocation = new LocationWrapper(locationInner);
        String destinationLatitude = '35';
        String destinationLongitude = '-105';

        System.assertNotEquals(null, ApiHandler.requestDistance(String.valueOf(testLocation.location.locationField__latitude__s), String.valueOf(testLocation.location.locationField__longitude__s), destinationLatitude, destinationLongitude));
        System.assertEquals(true, testLocation.getDistance(destinationLatitude, destinationLongitude));

        Test.stopTest();
    }

    @isTest
    public static void testGetDistanceSN() {
        Test.startTest();

        //no ApiMock

        Location__c locationInner = new Location__c();
        locationInner.name = 'testName';
        locationInner.locationField__latitude__s = 30;
        locationInner.locationField__longitude__s = -100;

        LocationWrapper testLocation = new LocationWrapper(locationInner);
        String destinationLatitude = '35';
        String destinationLongitude = '-105';

        System.assertNotEquals(null, ApiHandler.requestDistance(String.valueOf(testLocation.location.locationField__latitude__s), String.valueOf(testLocation.location.locationField__longitude__s), destinationLatitude, destinationLongitude));
        System.assertEquals(false, testLocation.getDistance(destinationLatitude, destinationLongitude));

        Test.stopTest();
    }

    @isTest
    public static void testCompareToSP() {
        Test.startTest();

        Location__c locationInner = new Location__c();
        locationInner.name = 'testName';
        List<LocationWrapper> testLocations = new List<LocationWrapper>();
        for (Integer i = 0; i < 5; i++) {
            testLocations.add(new LocationWrapper(locationInner));
        }

        for (Integer i = 0; i < 5; i++) {
            testLocations[i].seconds = 5 - i;
        }
        testLocations[0].seconds = null;
        testLocations[1].seconds = 0;
        //null, 0, 3, 2, 1

        testLocations.sort();
        //0, 1, 2, 3, null

        for (Integer i = 0; i < 4; i++) {
            System.assertEquals(i, testLocations[i].seconds);
        }
        System.assertEquals(null, testLocations[4].seconds);

        Test.stopTest();
    }
}