@isTest
public with sharing class TestDistanceCalculatorController {

    @TestSetup
    static void makeData(){
        List<Location__c> testLocations = new List<Location__c>();
        for (Integer i = 0; i < 200; i++) {
            Location__c locationInner = new Location__c();
            locationInner.name = 'testName';
            locationInner.locationField__latitude__s = 30;
            locationInner.locationField__longitude__s = -100;
            testLocations.add(locationInner);
        }
        Insert testLocations;
        Contact testContact = new Contact();
        testContact.lastName = 'testName';
        testContact.mailingStreet = '11049 Burbank Blvd';
        testContact.mailingCity = 'North Hollywood';
        testContact.mailingState = 'CA';
        testContact.mailingPostalCode = '91601';
        Insert testContact;

    }

    /*
    @isTest
    static void testGeocoderSP() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new ApiMock());

        DistanceCalculatorController testController = new DistanceCalculatorController();
        DistanceCalculatorController.geocoder();

        HTTP h = new HTTp();//this is exactly the same as what happens in geocoder, but this works and geocoder doesn't
        HTTpResponse coordinatesResponse = new HTTpResponse();
        try {
            coordinatesResponse = h.send(ApiHandler.requestCoordinates(DistanceCalculatorController.addressUrlFormat()));
        } catch (System.exception e) {
            System.assert(false);
        }
        Test.stopTest();

        System.assertEquals('Complete', DistanceCalculatorController.progress);

    }

    @isTest
    static void testGeocoderSN() {

    }

    @isTest
    static void testGeocoderBP() {

    }
	*/

    @isTest
    static void testPassCoordinatesSP() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new ApiMock());

        DistanceCalculatorController testController = new DistanceCalculatorController();

        HttpResponse response = new HttpResponse();
        Http h = new Http();
        response = h.send(ApiHandler.requestCoordinates(''));

        System.assert(DistanceCalculatorController.passCoordiantes(response));
        System.assertEquals('', DistanceCalculatorController.progress);

        Test.stopTest();
    }

    @isTest
    static void testPassCoordinatesSN() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new ApiMock());

        DistanceCalculatorController testController = new DistanceCalculatorController();
        HttpResponse response = new HttpResponse();

        //no callout
        System.assert(!DistanceCalculatorController.passCoordiantes(response));
        System.assertEquals('Failed (Geocoder)', DistanceCalculatorController.progress);

        Test.stopTest();
    }









    @isTest
    static void testGetAllDistancesBP() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new ApiMock());

        DistanceCalculatorController testController = new DistanceCalculatorController();
        String destinationLatitude = '35';
        String destinationLongitude = '-105';
        System.assert(DistanceCalculatorController.getAllDistances(destinationLatitude, destinationLongitude));
        System.assertEquals('', DistanceCalculatorController.progress);

        Test.stopTest();

    }

    @isTest
    static void testGetAllDistancesBN() {
        Test.startTest();

        //no ApiMock

        DistanceCalculatorController testController = new DistanceCalculatorController();
        String destinationLatitude = '35';
        String destinationLongitude = '-105';
        System.assert(!DistanceCalculatorController.getAllDistances(destinationLatitude, destinationLongitude));
        System.assertEquals('Failed (Distance Calculator)', DistanceCalculatorController.progress);

        Test.stopTest();

    }
	/*
    @isTest
    static void testGetAllDistancesSP() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new ApiMock());

        Location__c saveOne = [SELECT id FROM Location__c LIMIT 1];
        System.assertNotEquals(0, [SELECT id FROM Location__c].size());
        Delete [SELECT id FROM Location__c WHERE NOT id = :saveOne.id];
        System.assertEquals(1, [SELECT id FROM Location__c].size());

        DistanceCalculatorController testController = new DistanceCalculatorController();
        String destinationLatitude = '35';
        String destinationLongitude = '-105';
        System.assert(DistanceCalculatorController.getAllDistances(destinationLatitude, destinationLongitude));
        System.assertEquals('', DistanceCalculatorController.progress);

        Test.stopTest();

    }
	*/
    @isTest
    static void testGetAllDistances0P() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new ApiMock());

        System.assertNotEquals(0, [SELECT id FROM Location__c].size());
        Delete [SELECT id FROM Location__c];
        System.assertEquals(0, [SELECT id FROM Location__c].size());

        DistanceCalculatorController testController = new DistanceCalculatorController();
        String destinationLatitude = '35';
        String destinationLongitude = '-105';
        System.assert(DistanceCalculatorController.getAllDistances(destinationLatitude, destinationLongitude));
        System.assertEquals('', DistanceCalculatorController.progress);

        Test.stopTest();

    }









    @isTest
    static void testAddressUrlFormatSP() {
        Test.startTest();

        DistanceCalculatorController testController = new DistanceCalculatorController();

        //System.assertEquals('10900%20Katella%20Ave%20Garden%20Grove%20CA%2092840', DistanceCalculatorController.addressUrlFormat());
        System.assertEquals('10900%20Katella%20Ave%20Garden%20Grove%20CA%2092840', DistanceCalculatorController.addressUrlFormat());

        Test.stopTest();
    }

    @isTest
    static void testAddressUrlFormatSN() {
        Test.startTest();

        DistanceCalculatorController testController = new DistanceCalculatorController();
        DistanceCalculatorController.streetAddress = null;
        DistanceCalculatorController.city = ' , , , , , , , , , ,';
        DistanceCalculatorController.state = null;
        DistanceCalculatorController.zip = null;

        System.assertEquals('%20%20%20%20%20%20%20%20%20%20%20', DistanceCalculatorController.addressUrlFormat());
        //one extra %20 because the string is in city, not streetAddress

        DistanceCalculatorController.streetAddress = null;
        DistanceCalculatorController.city = null;
        DistanceCalculatorController.state = null;
        DistanceCalculatorController.zip = null;

        System.assertEquals('', DistanceCalculatorController.addressUrlFormat());

        Test.stopTest();
    }

    @isTest
    static void testGetAddressByContactIdSP() {//deprecated method
        Test.startTest();

        DistanceCalculatorController testController = new DistanceCalculatorController();

        Contact c = [SELECT id FROM Contact LIMIT 1];
        System.assertNotEquals(null, c);
        String id = String.valueOf(c.id);
        System.assertNotEquals(null, id);

        System.assertEquals('10900 Katella Ave', DistanceCalculatorController.streetAddress);
        System.assertEquals('Garden Grove', DistanceCalculatorController.city);
        System.assertEquals('CA', DistanceCalculatorController.state);
        System.assertEquals(92840, DistanceCalculatorController.zip);

        testController.getAddressFromContactId(id);

        System.assertEquals('11049 Burbank Blvd', DistanceCalculatorController.streetAddress);
        System.assertEquals('North Hollywood', DistanceCalculatorController.city);
        System.assertEquals('CA', DistanceCalculatorController.state);
        System.assertEquals(91601, DistanceCalculatorController.zip);

        Test.stopTest();
    }

    @isTest
    static void testGetAddressByContactIdSN() {//deprecatd method
        Test.startTest();

        DistanceCalculatorController testController = new DistanceCalculatorController();

        Contact c = [SELECT id FROM Contact LIMIT 1];
        System.assertNotEquals(null, c);
        String id = String.valueOf(c.id);
        System.assertNotEquals(null, id);

        System.assertEquals('10900 Katella Ave', DistanceCalculatorController.streetAddress);
        System.assertEquals('Garden Grove', DistanceCalculatorController.city);
        System.assertEquals('CA', DistanceCalculatorController.state);
        System.assertEquals(92840, DistanceCalculatorController.zip);

        testController.getAddressFromContactId('000000000000000');

        System.assertEquals('10900 Katella Ave', DistanceCalculatorController.streetAddress);
        System.assertEquals('Garden Grove', DistanceCalculatorController.city);
        System.assertEquals('CA', DistanceCalculatorController.state);
        System.assertEquals(92840, DistanceCalculatorController.zip);

        Test.stopTest();
    }

    
    @isTest
    static void testGetAddressByContactIdNinvalidInput() {//deprecated method
        Test.startTest();

        DistanceCalculatorController testController = new DistanceCalculatorController();

        Contact c = [SELECT id FROM Contact LIMIT 1];
        System.assertNotEquals(null, c);
        String id = String.valueOf(c.id);
        System.assertNotEquals(null, id);

        System.assertEquals('10900 Katella Ave', DistanceCalculatorController.streetAddress);
        System.assertEquals('Garden Grove', DistanceCalculatorController.city);
        System.assertEquals('CA', DistanceCalculatorController.state);
        System.assertEquals(92840, DistanceCalculatorController.zip);

        testController.getAddressFromContactId('');

        System.assertEquals('10900 Katella Ave', DistanceCalculatorController.streetAddress);
        System.assertEquals('Garden Grove', DistanceCalculatorController.city);
        System.assertEquals('CA', DistanceCalculatorController.state);
        System.assertEquals(92840, DistanceCalculatorController.zip);

        Test.stopTest();
    }


}