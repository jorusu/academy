trigger AccountTrigger on Account(
    before insert,
    after insert,
    after update
) {
    if(Trigger.isAfter){
        if(Trigger.IsInsert){
            AccountTriggerHandler.afterInsert(Trigger.new);
        }
        if(Trigger.IsUpdate){
            AccountTriggerHandler.afterUpdate(Trigger.oldMap, Trigger.new);
        }
    }
    if(Trigger.isBefore){
        if(Trigger.IsInsert){
            AccountTriggerHandler.beforeInsert(Trigger.new);
        }
    }
}