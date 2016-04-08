/**
 * PaymentTriggerHandler.cls
 *
 * @abstract Handler class for divying work to various service classes depending on trigger scope, 
 * implements TriggerHandler interface to solve for all trigger scopes.
 *
 * @author Chase Logan
 */
public class PaymentTriggerHandler implements TriggerHandler {
	
	/* Insert Operations */
	public void beforeInsert( List<sObject> newSObjects) { /* implement future operations */ }
	
	public void afterInsert( Map<Id,sObject> newSObjects) {
		
		PaymentDataService.updateRelatedPaymentDetails();
	}

	/* Update Operations */
	public void beforeUpdate( Map<Id,sObject> newSObjects, Map<Id,sObject> oldSObjects) { /* implement future operations */ }

	public void afterUpdate( Map<Id,sObject> newSObjects, Map<Id,sObject> oldSObjects) {
		
		PaymentDataService.updateRelatedPaymentDetails();
	}
	
	/* Delete Operations */
	public void beforeDelete( Map<Id,sObject> newSObjects, Map<Id,sObject> oldSObjects) { 

		PaymentDataService.updateRelatedPaymentDetails(); 
	}
	
	public void afterDelete( Map<Id,sObject> newSObjects, Map<Id,sObject> oldSObjects) {
		
		PaymentDataService.updateRelatedPaymentDetails();
	}

	/* Undelete Operations */
	public void afterUnDelete( Map<Id,sObject> newSObjects, Map<Id,sObject> oldSObjects) { /* implement future operations */ }

}