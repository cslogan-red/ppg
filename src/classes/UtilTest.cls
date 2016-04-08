@isTest (SeeAllData = false)
private class UtilTest {
	
	/* positive test cases */

    // test debug methods
    static testMethod void testDebugPositive() {  
        
        // Arrange
        // no work

        // Act
        Test.startTest();
        	Util.debug( 'test', 'test');
        	Util.debug( 'test', 'test');
        Test.stopTest();

        // Assert
        // no work
    }

    // test page message methods
    static testMethod void testPageMessagesPositive() {  
        
        // Arrange
        // no work

        // Act
        Test.startTest();
        	Util.AddInfoMessage( 'test');
        	Util.AddWarningMessage( 'test');
        	Util.AddConfirmMessage( 'test');
        	Util.AddErrorMessage( 'test');
        	Util.AddFatalMessage( 'test');
        Test.stopTest();

        // Assert
        // no work
    }
	
}