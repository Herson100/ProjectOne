@isTest
public with sharing class TestDistanceCalculatorAddressByUser {
    @TestSetup
    static void makeData(){
         
        User u = new User();
        u.LastName = 'Inv #';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'adsnhefwuh@hdfhjfhj.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = [SELECT id FROM Profile WHERE name = 'System Administrator' LIMIT 1].id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.IsActive = true; 
        u.UserRoleID = [SELECT id FROM UserRole WHERE name = 'CEO' LIMIT 1].id;
        u.street = 'street';
        u.city = 'city';
        u.state = 'state';
        u.postalCode = '0';
        Insert u;  
    }
    


    
    @isTest
    static void testGetAddressByUserSP() {
        Test.startTest();

        User u = [SELECT id FROM User WHERE LastName = 'Inv #'  LIMIT 1];
        System.assertNotEquals(null, u);
        String id = String.valueOf(u.id);
        System.assertNotEquals(null, id);

        System.runAs(u){
            DistanceCalculatorController testController = new DistanceCalculatorController();

            System.assertEquals('street', DistanceCalculatorController.streetAddress);
            System.assertEquals('city', DistanceCalculatorController.city);
            System.assertEquals('state', DistanceCalculatorController.state);
            System.assertEquals(0, DistanceCalculatorController.zip);

        }

        Test.stopTest();
    }

    @isTest
    static void testGetAddressByUserSN() {
        Test.startTest();

        User u = [SELECT id FROM User WHERE LastName = 'Inv #'  LIMIT 1];
        System.assertNotEquals(null, u);
        String id = String.valueOf(u.id);
        System.assertNotEquals(null, id);

        System.runAs(u){
            DistanceCalculatorController testController = new DistanceCalculatorController();

            System.assertEquals('street', DistanceCalculatorController.streetAddress);
            System.assertEquals('city', DistanceCalculatorController.city);
            System.assertEquals('state', DistanceCalculatorController.state);
            System.assertEquals(0, DistanceCalculatorController.zip);

        }

        Test.stopTest();
    }
}