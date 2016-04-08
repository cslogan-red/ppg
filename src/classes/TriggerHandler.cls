/**
 * TriggerHandler.cls
 *
 * @abstract Interface for implementing super trigger pattern (single trigger per object)
 *
 * @author Chase Logan
 */
public interface TriggerHandler {

	/* Insert Operations */
	void beforeInsert( List<sObject> newSObjects);
	void afterInsert( Map<Id,sObject> newSObjects);

	/* Update Operations */
	void beforeUpdate( Map<Id,sObject> newSObjects, Map<Id,sObject> oldSObjects);
	void afterUpdate( Map<Id,sObject> newSObjects, Map<Id,sObject> oldSObjects);

	/* Delete Operations */
	void beforeDelete( Map<Id,sObject> newSObjects, Map<Id,sObject> oldSObjects);
	void afterDelete( Map<Id,sObject> newSObjects, Map<Id,sObject> oldSObjects);

	/* Undelete Operations */
	void afterUnDelete( Map<Id,sObject> newSObjects, Map<Id,sObject> oldSObjects);
}