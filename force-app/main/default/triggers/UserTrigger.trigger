trigger UserTrigger on User (before insert, before update, before delete, after insert, after update, after delete, after undelete ) 
{
    switch on trigger.operationType 
    {
        when BEFORE_INSERT 
        { 
        }
        when BEFORE_UPDATE 
        { 

        }

        when BEFORE_DELETE 
        { 

        }
        when AFTER_INSERT 
        { 
            CustomerHandler.checkIfCustomerUser(trigger.new); //We only need to assign the permission set once after insertion of new customer users.
        }
        when AFTER_UPDATE 
        {

        }
        when AFTER_DELETE 
        { 
        }
        when AFTER_UNDELETE 
        {

        }
    }
}