/**
 * PaymentTrigger.trigger
 *
 * @abstract Single trigger for the Payment__c object, context is passed via TriggerHandler, 
 * which accomplishes work via various service classes specific to use case, keeps logic
 * out of trigger following the Factory pattern.
 *
 * @author Chase Logan
 */
trigger PaymentTrigger on Payment__c ( before insert, before update, after insert, after update,
										before delete, after delete, after undelete) {
	
	final String PAYMENT_TRIGGER_HANDLER = 'PaymentTriggerHandler';

	TriggerFactory.createAndExecuteHandler( PAYMENT_TRIGGER_HANDLER);
}