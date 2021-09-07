trigger OrderTicketTrigger on Order_Ticket__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    //The Main Switch Statement
    switch on trigger.operationType {
        when BEFORE_INSERT {
            TriggerHelper.CheckForDuplicates(Trigger.new);
        }
        when BEFORE_UPDATE { 
        }
        when BEFORE_DELETE { 
        }
        when AFTER_INSERT {
        }
        when AFTER_UPDATE {
        }
        when AFTER_DELETE { 
        }
        when AFTER_UNDELETE {
        }
    }
    
}