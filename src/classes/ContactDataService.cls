/**
 * ContactDataService.cls
 *
 * @abstract Data service class for exposing CRUD operations on the Contact object.
 *
 * @author Chase Logan
 */
public class ContactDataService extends BaseDataService {

	/**
	 * Get all Contacts that have made at least one Payment to any Project as a child collection. 
	 * Limited to 1000 records as you can't display more than that in an apex:repeat without a 
	 * readonly page, as well as modified in the last two years, for sake of performance :)
	 *
	 * @return List of Contacts with associated List of Payment records
	 */
	public List<Contact> getContactsWithAppliedPayments() {
		
		List<Contact> returnVal;

		try {

			returnVal = [select Id, Name, Applied_Payment_Total__c, Last_Payment_Date__c,
								( select Id, Name, Amount__c, Payment_Date__c, Contact__c,
										 Project__c, Project__r.Name, Project__r.Applied_Payment_Total__c
								    from Payments__r
								   where Project__c != null
								     and LastModifiedDate = LAST_N_DAYS:730
								order by CreatedDate desc)
						   from Contact
						  limit 1000];

		} catch ( DmlException de) {

			Util.debug( de.getStackTraceString(), de.getLineNumber(), de.getMessage());
		} catch ( Exception e) {

			Util.debug( e.getStackTraceString(), e.getLineNumber(), e.getMessage());
		}

		return returnVal;
	}

}