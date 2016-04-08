/**
 * PaymentDataService.cls
 *
 * @abstract Data service class for exposing CRUD operations on the Payment object.
 *
 * @author Chase Logan
 */
public class PaymentDataService extends BaseDataService {
	
	/**
	 * Get all applied Payments by Contact Id. (limited to 1000 records)
	 *
	 * @return List of Payments
	 */
	public List<Payment__c> getAllAppliedPaymentsByContact( Id contactId) {
		List<Payment__c> returnVal;

		if ( contactId != null) {

			try {

				returnVal = [select Id, Name, Amount__c, Payment_Date__c, Contact__c, Delete__c,
								    Project__r.Name
							   from Payment__c
							  where Contact__c = :contactId
							    and Project__c != null
						   order by Payment_Date__c asc
							  limit 1000];

			} catch ( DmlException de) {

				Util.debug( de.getStackTraceString(), de.getLineNumber(), de.getMessage());
			} catch ( Exception e) {

				Util.debug( e.getStackTraceString(), e.getLineNumber(), e.getMessage());
			}
		}

		return returnVal;
	}

	/**
	 * Overloaded service method exposed to PaymentTriggerHandler for working with related field
	 * updates inside various trigger contexts.
	 *
	 */
	public static void updateRelatedPaymentDetails() {
			
		ContactDataService cDataService = new ContactDataService();
		List<Contact> contactList = cDataService.getContactsWithAppliedPayments();

		updateRelatedPaymentDetails( contactList);
	}

	/**
	 * Service method exposed to PaymentTriggerHandler for working with related field
	 * updates inside various trigger contexts.
	 *
	 * Handles the meat of the work for keeping running totals accurate on Contact and Project.
	 * Resuable logic for all trigger scopes (insert/update/delete)
	 *
	 */
	public static void updateRelatedPaymentDetails( List<Contact> contactList) {

		if ( contactList != null && contactList.size() > 0) {

			List<Contact> contactUpdateList = new List<Contact>();
			List<Project__c> projectUdpateList = new List<Project__c>();
			Map<Id,Double> projectAmountMap = new Map<Id,Double>();
			Boolean lastPaymentRow = false;

			for ( Contact c : contactList) {

				// Handle removal of last payment for a project
				if ( Trigger.isDelete && Trigger.isBefore &&
					 c.Payments__r != null && c.Payments__r.size() == 1) {

					lastPaymentRow = true;
				}
				Contact tempContact = new Contact();
				for ( Payment__c p : c.Payments__r) {

					// handle Contact records
					if ( tempContact.Applied_Payment_Total__c == null) {

						tempContact.Applied_Payment_Total__c = p.Amount__c;
						tempContact.Last_Payment_Date__c = p.Payment_Date__c;
					} else {

						Double currentAmount = tempContact.Applied_Payment_Total__c;
						currentAmount += p.Amount__c;
						tempContact.Applied_Payment_Total__c = currentAmount;
						tempContact.Last_Payment_Date__c = 
							( tempContact.Last_Payment_Date__c > p.Payment_Date__c ? tempContact.Last_Payment_Date__c : p.Payment_Date__c);
					}

					// handle Project__c records
					if ( !projectAmountMap.containsKey( p.Project__c) && !lastPaymentRow) {

						projectAmountMap.put( p.Project__c, p.Amount__c);
					} else if ( !lastPaymentRow) {

						Double currentAmount = projectAmountMap.get( p.Project__c);
						currentAmount += p.Amount__c;
						projectAmountMap.put( p.Project__c, currentAmount);
					} else {

						projectAmountMap.put( p.Project__c, null);
					}
				}

				c.Applied_Payment_Total__c = tempContact.Applied_Payment_Total__c;
				c.Last_Payment_Date__c = tempContact.Last_Payment_Date__c;
				contactUpdateList.add( c);
			}

			for ( Id i : projectAmountMap.keySet()) {

				Project__c currProject = new Project__c( Id = i);
				currProject.Applied_Payment_Total__c = projectAmountMap.get( i);
				projectUdpateList.add( currProject);
			}

			// perform final DML operations, log exceptions but bubble to top for front end error handling to display
			try {
				
				upsert contactUpdateList;
				upsert projectUdpateList;
			} catch ( DmlException de) {

				Util.debug( de.getStackTraceString(), de.getLineNumber(), de.getMessage());
				throw de;
			} catch ( Exception e) {

				Util.debug( e.getStackTraceString(), e.getLineNumber(), e.getMessage());
				throw e;
			}
		}
	}

}