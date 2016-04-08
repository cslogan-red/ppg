/**
 * Util.cls
 *
 * @abstract Basic utility class for reusable debug and any such utility methods, Apex
 * doesn't allow inheritance of static's so easier to throw them in here without 
 * requiring an instance to access
 *
 * @author Chase Logan
 */
public class Util {
	
	/** 
	 * Overriden System.debug method with additional details
	 *
	 * @param caller, input stack trace String
	 * @param debugString, input exception message String
	 *
	 */	
	public static void debug( String caller, String debugString) {
		final String MSG_PREFIX = ':::CODE_DEBUG_STATEMENT:::FROM: ';
		final String MSG_BODY_1 = ' :::MESSAGE: ';
		final String MSG_SUFFIX = ' :::@TIMESTAMP: ';

		System.debug( MSG_PREFIX + String.valueOf( caller) + MSG_BODY_1 + String.valueOf( debugString) + 
						MSG_SUFFIX + Datetime.now());
	}

	/** 
	 * Overriden System.debug method with additional details
	 *
	 * @param caller, input stack trace String
	 * @param lineAt, input line number Integer
	 * @param debugString, input exception message String
	 *
	 */	
	public static void debug( String caller, Integer lineAt, String debugString) {
		final String MSG_PREFIX = ':::CODE_DEBUG_STATEMENT:::FROM: ';
		final String MSG_BODY_1 = ' :::AT LINE: ';
		final String MSG_BODY_2 = ' :::MESSAGE: ';
		final String MSG_SUFFIX = ' :::@TIMESTAMP: ';

		System.debug( MSG_PREFIX + String.valueOf( caller) + MSG_BODY_1 + String.valueOf( lineAt) + MSG_BODY_2 + 
						String.valueOf( debugString) + MSG_SUFFIX + Datetime.now());
	}

	/** 
	 * Utility methods for adding various levels of error messages/severities
	 *
	 * @param s, String to display on page
	 *
	 */
	public static void AddInfoMessage( String s) {
        ApexPages.AddMessage( new ApexPages.Message( ApexPages.Severity.INFO, String.valueOf( s)));
    }

    public static void AddWarningMessage( String s) {
        ApexPages.AddMessage( new ApexPages.Message( ApexPages.Severity.WARNING, String.valueOf( s)));
    }

    public static void AddConfirmMessage( String s) {
        ApexPages.AddMessage( new ApexPages.Message( ApexPages.Severity.CONFIRM, String.valueOf( s)));
    }
    
    public static void AddErrorMessage( String s) {
        ApexPages.AddMessage( new ApexPages.Message( ApexPages.Severity.ERROR, String.valueOf( s)));
    }
    
    public static void AddFatalMessage( String s) {
        ApexPages.AddMessage( new ApexPages.Message( ApexPages.Severity.FATAL, String.valueOf( s)));
    }

}