// Alias me some jQuery
var $j = jQuery.noConflict();

/* Form validation for real-time error notification
 * All form fields are inputField, so a save with invalid data will prevent persistence
 * This function simply serves to provide notification in real-time, before save
 */
function validateData() {

	var CHILD_ERROR_ID_ATTR = 'child-error-id';
	var ERROR_FIELD_ATTR = 'error-field';
	var AMOUNT_FIELD = 'amountField';
	var DATE_FIELD = 'payDateField';
	var target = event.target;
	var errId = $j( target).attr( CHILD_ERROR_ID_ATTR);

	// validate amount fields
	if ( $j( target).attr( ERROR_FIELD_ATTR) === AMOUNT_FIELD) {

		var patt = new RegExp(/^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$/);

		if ( !patt.test( $j(target).val())) {

			$j( '#' + errId).text( 'Invalid currency format.');
			$j( '#' + errId).addClass( 'required');
			$j(target).addClass( 'required_border');
		} else {

			$j( '#' + errId).text( '');
			$j( '#' + errId).removeClass( 'required');
			$j(target).removeClass( 'required_border');
		}
	// validate date fields
	} else if ( $j( target).attr( ERROR_FIELD_ATTR) === DATE_FIELD) {

		// Longest regex of all time to handle SQL-type Datetime
		var patt = new 
		RegExp(/^(((((0[13578])|([13578])|(1[02]))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(3[01])))|((([469])|(11))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(30)))|((02|2)[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9]))))[\-\/\s]?\d{4})(\s(((0[1-9])|([1-9])|(1[0-2]))\:([0-5][0-9])((\s)|(\:([0-5][0-9])\s))([AM|PM|am|pm]{2,2})))?$/);

		if ( !patt.test( $j(target).val())) {

			$j( '#' + errId).text( 'Invalid date format.');
			$j( '#' + errId).addClass( 'required');
			$j( target).addClass( 'required_border');
		} else {

			$j( '#' + errId).text( '');
			$j( '#' + errId).removeClass( 'required');
			$j( target).removeClass( 'required_border');
		}
	}
}