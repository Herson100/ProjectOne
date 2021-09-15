@isTest(seeAllData = false)
public class CustomerHandlerTest 
{
    @testSetup
    public static void setupTest()
    {
        //PermissionSet permSet = new PermissionSet(name = 'CustomerPerms');
        //Insert permSet;   //Permission sets and profiles seem to exist while testing, so this is only needed if this permission set is not present.  
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
        Insert u;                                              
    }
    
    @isTest
    public static void testSingle()
    {
        Test.startTest();
        UserRole role = [SELECT id FROM UserROLE WHERE name = 'CEO' LIMIT 1];
        User ceo = [SELECT id FROM User WHERE UserRoleID = : role.id LIMIT 1];
        System.runas(ceo)
        {
        Account newAcc = new Account(Name = 'Account', OwnerID = ceo.id);        
        Insert newAcc;  
        Contact newCon = new Contact(Lastname = 'Frederick', AccountID = newAcc.id);
        Insert newCon;
        
        User u = new user();
        u.LastName = 'Inv #';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = '14775hf@84hef8.com';
        u.CommunityNickname = 'tfggh';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = [SELECT id FROM Profile WHERE name = 'Customer Community Plus Login User' LIMIT 1].id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.IsActive = true; 
        u.ContactId = newCon.id;
        Insert u;
        
        PermissionSet custPerm = [SELECT id FROM PermissionSet WHERE name = 'CustomerPerms' LIMIT 1];
        List<PermissionSetAssignment> assignments = [SELECT AssigneeID FROM PermissionSetAssignment WHERE AssigneeID = : u.id AND PermissionSetID = : custPerm.id];
        System.assertEquals(1, assignments.size()); //We should have exactly one permission set assignment from our trigger. 
        }
        Test.stopTest();
    }
    
    @isTest
    public static void testNegative()
    {
        Test.startTest();
        
        User u = new user();
        u.LastName = 'Inv #';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = '14775hf@84hef8.com';
        u.CommunityNickname = 'tfggh';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = [SELECT id FROM Profile WHERE name = 'System Administrator' LIMIT 1].id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.IsActive = true; 
        Insert u;
        
        PermissionSet custPerm = [SELECT id FROM PermissionSet WHERE name = 'CustomerPerms' LIMIT 1];
        List<PermissionSetAssignment> assignments = [SELECT AssigneeID FROM PermissionSetAssignment WHERE AssigneeID = : u.id AND PermissionSetID = : custPerm.id];
        System.assertEquals(0, assignments.size()); //We should not have assigned a non-customer community user a permission set in our trigger. 
        Test.stopTest();
    }
    
    
    @isTest
    public static void testBulk()
    {
        Test.startTest();
        UserRole role = [SELECT id FROM UserROLE WHERE name = 'CEO' LIMIT 1];
        User ceo = [SELECT id FROM User WHERE UserRoleID = : role.id LIMIT 1];
        System.runas(ceo)
        {
        Account newAcc = new Account(Name = 'Account', OwnerID = ceo.id);        
        Insert newAcc;  
            
        Contact newCon = new Contact(Lastname = 'Frederick', AccountID = newAcc.id);
        Insert newCon;

        id comProfile = [SELECT id FROM Profile WHERE name = 'Customer Community Plus Login User' LIMIT 1].id;
            
        List<Contact> contactList = new List<Contact>();
        for(Integer n = 0; n < 151; n++)
        {
            contactList.Add(New Contact(Lastname = 'Frederick' + String.valueOf(n), AccountID = newAcc.id));
        }
        
        Insert contactList;
            
        List<User> toInsert = new List<User>();
        for(Integer n = 0; n < 151; n++) 
        {
            User u = new user();
            u.LastName = 'Inv #' + string.valueOf(n);
            u.Email = 'test@test.com';
            u.Alias = 'Tcode';
            u.Username = string.valueof(n) + 'person@person.com';
            u.CommunityNickname = string.valueof(n) + 'test12';
            u.LocaleSidKey = 'en_US';
            u.TimeZoneSidKey = 'GMT';
            u.ProfileID = comProfile;
            u.LanguageLocaleKey = 'en_US';
            u.EmailEncodingKey = 'UTF-8';
            u.IsActive = true;
            u.ContactId = contactList.Get(n).id;
            
            toInsert.add(u);
        }
        Insert toInsert;
        
        PermissionSet custPerm = [SELECT id FROM PermissionSet WHERE name = 'CustomerPerms' LIMIT 1];
        List<PermissionSetAssignment> assignments = [SELECT AssigneeID FROM PermissionSetAssignment WHERE AssigneeID IN : toInsert AND PermissionSetID = : custPerm.id];
        System.assertEquals(151, assignments.size()); //We should get 151 assignments here. 
        }
        
        Test.stopTest();
    }
}