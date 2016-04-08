/**
 * PaymentManagerExtension.cls
 *
 * @abstract Main extension for the Payment Manager application, handles view state manipulation
 * and passing of CRUD operations to service layer.
 *
 * @author Chase Logan
 */
public class PaymentManagerExtension {
	
	/* member constants & variables */
	private final String ERROR_MESSAGE = 'An error has occurred processing your request. Details: ';
	private final String SUCCESS_UPDATE_MESSAGE = 'Records succesfully saved.';
	private final String SUCCESS_CREATE_MESSAGE = 'New payment successfully created.';
	private final String SUCCESS_DELETE_MESSAGE = 'Payment successfully deleted';
	private final String NO_DATA_MESSAGE = 'No Payments found! To use the Payment Manager, you must create at least one Project, ' +
										   'and associate at least one Payment, to at least one Contact.';
	
	private ContactDataService cDataService;
	private PaymentDataService pDataService;
	private List<Contact> contactList;

	/* properties */
	public List<PaymentWrapper> paymentWrapperList { get; set; }
	public Payment__c newPaymentRecord { get; set; }
	public List<Payment__c> paymentsToDeleteList { get; set; }
	public String currentContactId { get; set; }
	public Boolean renderNewPayment { get; set; }
	public Boolean renderDeletePayment { get; set; }


	/* default ctor */
	public PaymentManagerExtension( ApexPages.StandardController stdController) {

		this.cDataService = new ContactDataService();
		this.pDataService = new PaymentDataService();
		this.renderNewPayment = false;
		this.renderDeletePayment = false;
	}

	/**
	 * Page action method, fired after constructor for UI initialization, retrieves
	 * necessary Contact and Payment details to inflate view. As per the requirements, this page
	 * only displays data "that lists all people that have made at least one Payment to any Project"
	 *
	 * @return PageRef
	 */
	public PageReference getActivePaymentsByContact() {

		this.contactList = this.cDataService.getContactsWithAppliedPayments();

		if ( this.contactList != null && this.contactList.size() > 0) {

			this.paymentWrapperList = new List<PaymentWrapper>();
			for ( Contact c : this.contactList) {

				if ( c.Payments__r != null && c.Payments__r.size() > 0) {

					PaymentWrapper wrapper = new PaymentWrapper();
					wrapper.contact = c;
					
					for ( Payment__c p : c.Payments__r) {

						if ( p.Contact__c == c.Id) {

							wrapper.paymentList.add( (Payment__c)p);
						}
					}
					
					this.paymentWrapperList.add( wrapper);
				}
			} 
		} else {

			Util.AddInfoMessage( this.NO_DATA_MESSAGE);
		}

		if ( this.paymentWrapperList.size() == 0) {

			Util.AddInfoMessage( this.NO_DATA_MESSAGE);
		}

		return null;
	}

	/**
	 * View method for controlling the new payment display, inits new payment record.
	 *
	 * @return PageRef
	 */
	public PageReference addNewPayment() {
		this.renderNewPayment = true;
		this.newPaymentRecord = new Payment__c();
		this.newPaymentRecord.Contact__c = ( Id)this.currentContactId;

		return null;
	}

	/**
	 * View method for persisting new payment record to data model.
	 *
	 * @return PageRef
	 */
	public PageReference saveNewPayment() {
		PageReference returnVal = null;
		this.renderNewPayment = false;

		try {

			insert this.newPaymentRecord;

			returnVal = getActivePaymentsByContact();
			Util.AddConfirmMessage( this.SUCCESS_CREATE_MESSAGE);
		} catch ( Exception e) {

			Util.debug( e.getStackTraceString(), e.getLineNumber(), e.getMessage());
			Util.AddErrorMessage( this.ERROR_MESSAGE + e.getMessage());
		}

		return returnVal;
	}

	/**
	 * View method for canceling new payment dialog.
	 *
	 * @return PageRef
	 */
	public PageReference cancelNewPayment() {
		this.renderNewPayment = false;

		return null;
	}

	/**
	 * View method for init of delete payment dialog.
	 *
	 * @return PageRef
	 */
	public PageReference deletePayment() {
		this.renderDeletePayment = true;

		this.paymentsToDeleteList = this.pDataService.getAllAppliedPaymentsByContact( (Id)this.currentContactId);

		return null;
	}

	/**
	 * View method for handling actual deletion of selected records
	 *
	 * @return PageRef
	 */
	public PageReference deleteSelectedPayments() {
		PageReference returnVal = null;
		this.renderDeletePayment = false;

		try {

			List<Payment__c> deleteList = new List<Payment__c>();
			for ( Payment__c p : this.paymentsToDeleteList) {

				if ( p.Delete__c) deleteList.add( p);
			}

			delete deleteList;

			returnVal = getActivePaymentsByContact();
			Util.AddConfirmMessage( this.SUCCESS_DELETE_MESSAGE);
		} catch ( Exception e) {

			Util.debug( e.getStackTraceString(), e.getLineNumber(), e.getMessage());
			Util.AddErrorMessage( this.ERROR_MESSAGE + e.getMessage());
		}
		
		return returnVal;
	}

	/**
	 * View method for cancel of delete dialog
	 *
	 * @return PageRef
	 */
	public PageReference cancelDeletePayment() {
		this.renderDeletePayment = false;

		return null;
	}

	/**
	 * View method for saving all changes on the page, any edits to any payment
	 * rows will be persisted when the "Save Changes" button is clicked
	 *
	 * @return PageRef
	 */
	public PageReference saveChanges() {
		PageReference returnVal = null;

		try {
			List<Payment__c> paymentList = new List<Payment__c>();
			for ( PaymentWrapper pW : this.paymentWrapperList) {

				for ( Payment__c payment : pW.paymentList) {

					if ( this.currentContactId == payment.Contact__c) {

						paymentList.add( payment);
					}
				}
			}

			update paymentList;
			returnVal = getActivePaymentsByContact();
			Util.AddConfirmMessage( this.SUCCESS_UPDATE_MESSAGE);
		} catch ( Exception e) {

			Util.debug( e.getStackTraceString(), e.getLineNumber(), e.getMessage());
			Util.AddErrorMessage( this.ERROR_MESSAGE + e.getMessage());
		}
		
		return returnVal;
	}

	
	/* inner wrapper class for UI display */
	public class PaymentWrapper {
		public Contact contact { get; set; }
		public List<Payment__c> paymentList { get; set; }

		public PaymentWrapper() {

			paymentList = new List<Payment__c>();
		}
	}

}