trigger PizzaTrigger on Pizza__C (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    //the main switch statement
    switch on trigger.operationType {
        when BEFORE_INSERT { 
            TriggerHelper.updatePrice(Trigger.new);
        }
        when BEFORE_UPDATE { 
            TriggerHelper.updatePrice(Trigger.new);
        }
        //TODO: Update cart when pizza is deleted
        when BEFORE_DELETE { 
            TriggerHelper.updateShoppingCart(Trigger.old, Trigger.oldMap);
        }
        when AFTER_INSERT { 
            TriggerHelper.updateShoppingCart(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            TriggerHelper.checkIfOrderIsReady(Trigger.new);
            TriggerHelper.updateShoppingCart(Trigger.new, Trigger.oldMap);
        }
        when AFTER_DELETE { 
        }
        //TODO: Update cart when pizza is undeleted
        when AFTER_UNDELETE {
            TriggerHelper.updateShoppingCart(Trigger.new, Trigger.newMap);
        }
    }


}