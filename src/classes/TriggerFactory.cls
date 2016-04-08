/**
 * TriggerFactory.cls
 *
 * @abstract Factory class for handling super trigger pattern (single trigger per object)
 *
 * @author Chase Logan
 */
public class TriggerFactory {
	private static final String INVALID_TYPE_MSG = 'Invalid class type';
	private static final String INVALID_INSTANCE_MSG = 'Invalid class type';


	public class HandlerException extends Exception {}

	/**
	 * Create and execute an instance of a TriggerHandler.
	 */
	public static void createAndExecuteHandler( string handlerName) {

		TriggerHandler handler = create( handlerName);
		execute( handler);
	}

	/**
	 * Create an instance of a TriggerHandler based on a valid TriggerHandler type.
	 *
	 * @param handlerName - String representation of trigger handler class name
	 * 
	 * @return A new TriggerHandler
	 */
	private static TriggerHandler create( String handlerName) {

		System.Type classType = Type.forName( handlerName);

		if ( classType == null) {

			throw new HandlerException( INVALID_TYPE_MSG);
		}

		Object handler = classType.newInstance();

		if ( !( handler instanceOf TriggerHandler)) {

			throw new HandlerException( INVALID_INSTANCE_MSG);
		}

		return ( TriggerHandler)handler;
	}

	/**
	 * Execute an instance of a TriggerHandler based on a valid TriggerHandler type.
	 *
	 * @param handler - a valid TriggerHandler instance
	 * 
	 */
	private static void execute( TriggerHandler handler) {

		if ( Trigger.isBefore) {

			if ( Trigger.isInsert) {

				handler.beforeInsert( Trigger.new);
			} else if ( Trigger.isUpdate) {

				handler.beforeUpdate( Trigger.newMap, Trigger.oldMap);
			} else if ( Trigger.isDelete) {

				handler.beforeDelete( Trigger.newMap, Trigger.oldMap);
			}
		} else if ( Trigger.isAfter) {

			if ( Trigger.isInsert) {

				handler.afterInsert( Trigger.newMap);
			} else if ( Trigger.isUpdate) {

				handler.afterUpdate( Trigger.newMap, Trigger.oldMap);
			} else if ( Trigger.isDelete) {

				handler.afterDelete( Trigger.newMap, Trigger.oldMap);
			} else if ( Trigger.isUndelete) {

				handler.afterUnDelete( Trigger.newMap, Trigger.oldMap);
			}
		}
	}

}