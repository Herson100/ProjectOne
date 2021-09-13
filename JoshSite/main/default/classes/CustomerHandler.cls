public class CustomerHandler //This is a handler for new customer users, giving them a permission set to access some objects in the database.
{
    public static void checkIfCustomerUser(list<User> users)
    {
        {     
        List<PermissionSetAssignment> PermSets = new List<PermissionSetAssignment>(); //We'll insert these at the end. 
        List<PermissionSet> toAssign = [SELECT id FROM PermissionSet WHERE name = 'CustomerPerms' LIMIT 1]; //I was getting errors when I didn't make this a list for some reason.
        
        Profile communityProfile = [SELECT id FROM Profile WHERE name = 'Customer Community Plus Login User' LIMIT 1]; //We'll use this to check whether our inserted users are community users.
        for(User u : users)
        {
            if(u.ProfileId == communityProfile.id)
            {
                PermissionSetAssignment ps = new PermissionSetAssignment(PermissionSetId = toAssign[0].id, AssigneeId = u.id); 
                PermSets.add(ps); 
            }
        }
        Insert PermSets;
        }
    }
}