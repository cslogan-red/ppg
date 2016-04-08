/**
 * PaymentManagerExtensionTest.cls
 *
 * @abstract Test class that gets coverage for most of the application. Tests setup using the
 * Arrange/Act/Assert pattern, with no reliance on org data. Covers all application scenarios.
 *
 * @author Chase Logan
 */
@isTest (SeeAllData = false)
private class PaymentManagerExtensionTest {

    /* test data setup */
	@testSetup static void setupTestData() {
        
        List<Contact> contactList = new List<Contact>();
        contactList.add( new Contact( FirstName = 'Ted', LastName = 'Tester', Phone = '(444) 111-2222', Email = 'test@test.com'));
        contactList.add( new Contact( FirstName = 'Larry', LastName = 'Tester', Phone = '(444) 111-2222', Email = 'test@test.com'));
        contactList.add( new Contact( FirstName = 'Marry', LastName = 'Tester', Phone = '(444) 111-2222', Email = 'test@test.com'));

        insert contactList;

        List<Project__c> projectList = new List<Project__c>();
        projectList.add( new Project__c( Name = 'Bank of America'));
        projectList.add( new Project__c( Name = 'AAA'));
        projectList.add( new Project__c( Name = 'PTF'));

        insert projectList;

        List<Payment__c> paymentList = new List<Payment__c>();
        paymentList.add( new Payment__c( Name ='test1', Contact__c = contactList[0].Id, Payment_Date__c = Datetime.now(), Amount__c = 1000, Project__c = projectList[0].Id));
        paymentList.add( new Payment__c( Name ='test2', Contact__c = contactList[1].Id, Payment_Date__c = Datetime.now(), Amount__c = 1000, Project__c = projectList[0].Id));
        paymentList.add( new Payment__c( Name ='test3', Contact__c = contactList[2].Id, Payment_Date__c = Datetime.now(), Amount__c = 1000, Project__c = projectList[1].Id));
        paymentList.add( new Payment__c( Name ='test4', Contact__c = contactList[2].Id, Payment_Date__c = Datetime.now(), Amount__c = 1000, Project__c = projectList[2].Id));

        insert paymentList;
    }

    /* negative test cases */

    // test PaymentManager page invocation, page action method, start to add payment with invalid data
    static testMethod void testPaymentManagerAddAndSaveWithBadDataNegative() {  
        
        // Arrange
        Payment__c p = [select Id from Payment__c limit 1];

        // Act
        Test.startTest();
        	PageReference pMRef = Page.PaymentManager;
			Test.setCurrentPage( pMRef);
			ApexPages.StandardController controller = new ApexPages.StandardController( p);
			PaymentManagerExtension pMExtension = new PaymentManagerExtension( controller);
			pMExtension.getActivePaymentsByContact();
			pMExtension.addNewPayment();
			pMExtension.newPaymentRecord.Contact__c = null;
			pMExtension.newPaymentRecord.Project__c = null;
			pMExtension.newPaymentRecord.Amount__c = null;
			pMExtension.newPaymentRecord.Payment_Date__c = Datetime.now();
			pMExtension.saveNewPayment();
        Test.stopTest();


        // Assert
        System.debug( 'The expected value is false and the actual value is ' + pMExtension.renderNewPayment);
        System.assertEquals( pMExtension.renderNewPayment, false);

        System.debug( 'The expected value is 3 and the actual value is ' + pMExtension.paymentWrapperList.size());
        System.assertEquals( pMExtension.paymentWrapperList.size(), 3);

    }

    /* positive test cases */

    // test PaymentManager page invocation
    static testMethod void testPaymentManagerInvocationPositive() {  
        
        // Arrange
        Payment__c p = [select Id from Payment__c limit 1];

        // Act
        Test.startTest();
        	PageReference pMRef = Page.PaymentManager;
			Test.setCurrentPage( pMRef);
			ApexPages.StandardController controller = new ApexPages.StandardController( p);
			PaymentManagerExtension pMExtension = new PaymentManagerExtension( controller);
        Test.stopTest();

        // Assert
        System.debug( 'The expected value is false and the actual value is ' + pMExtension.renderNewPayment);
        System.assertEquals( pMExtension.renderNewPayment, false);
    }

    // test PaymentManager page invocation, including page action method
    static testMethod void testPaymentManagerActionMethodPositive() {  
        
        // Arrange
        Payment__c p = [select Id from Payment__c limit 1];

        // Act
        Test.startTest();
        	PageReference pMRef = Page.PaymentManager;
			Test.setCurrentPage( pMRef);
			ApexPages.StandardController controller = new ApexPages.StandardController( p);
			PaymentManagerExtension pMExtension = new PaymentManagerExtension( controller);
			pMExtension.getActivePaymentsByContact();
        Test.stopTest();

        List<Contact> contactList = [select Id, Name, Applied_Payment_Total__c from Contact];
        Contact contactTed = new Contact();
        Contact contactLarry = new Contact();
        Contact contactMarry = new Contact();
        for ( Contact c : contactList) {

        	if ( c.Name == 'Ted Tester') {
        		contactTed = c;
        	} else if ( c.Name == 'Larry Tester') {
        		contactLarry = c;
        	} else if ( c.Name == 'Marry Tester') {
        		contactMarry = c;
        	}
        }

        List<Project__c> projectList = [select Id, Name, Applied_Payment_Total__c from Project__c];
        Project__c projBOA = new Project__c();
        Project__c projAAA = new Project__c();
        Project__c projPTF = new Project__c();
        for ( Project__c pr : projectList) {

            if ( pr.Name == 'Bank of America') {
                projBOA = pr;
            } else if ( pr.Name == 'AAA') {
                projAAA = pr;
            } else if ( pr.Name == 'PTF') {
                projPTF = pr;
            }
        }

        // Assert
        System.debug( 'The expected value is false and the actual value is ' + pMExtension.renderNewPayment);
        System.assertEquals( pMExtension.renderNewPayment, false);

        System.debug( 'The expected value is 3 and the actual value is ' + pMExtension.paymentWrapperList.size());
        System.assertEquals( pMExtension.paymentWrapperList.size(), 3);

        System.debug( 'The expected value is 1000 and the actual value is ' + contactTed.Applied_Payment_Total__c);
        System.assertEquals( contactTed.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 1000 and the actual value is ' + contactLarry.Applied_Payment_Total__c);
        System.assertEquals( contactLarry.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 2000 and the actual value is ' + contactMarry.Applied_Payment_Total__c);
        System.assertEquals( contactMarry.Applied_Payment_Total__c, 2000);

        System.debug( 'The expected value is 2000 and the actual value is ' + projBOA.Applied_Payment_Total__c);
        System.assertEquals( projBOA.Applied_Payment_Total__c, 2000);

        System.debug( 'The expected value is 1000 and the actual value is ' + projAAA.Applied_Payment_Total__c);
        System.assertEquals( projAAA.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 1000 and the actual value is ' + projPTF.Applied_Payment_Total__c);
        System.assertEquals( projPTF.Applied_Payment_Total__c, 1000);
    }

    // test PaymentManager page invocation, page action method, and save changes
    static testMethod void testPaymentManagerWithSavePositive() {  
        
        // Arrange
        Payment__c p = [select Id from Payment__c limit 1];

        // Act
        Test.startTest();
        	PageReference pMRef = Page.PaymentManager;
			Test.setCurrentPage( pMRef);
			ApexPages.StandardController controller = new ApexPages.StandardController( p);
			PaymentManagerExtension pMExtension = new PaymentManagerExtension( controller);
			pMExtension.getActivePaymentsByContact();
			pMExtension.saveChanges();
        Test.stopTest();

        List<Contact> contactList = [select Id, Name, Applied_Payment_Total__c from Contact];
        Contact contactTed = new Contact();
        Contact contactLarry = new Contact();
        Contact contactMarry = new Contact();
        for ( Contact c : contactList) {

        	if ( c.Name == 'Ted Tester') {
        		contactTed = c;
        	} else if ( c.Name == 'Larry Tester') {
        		contactLarry = c;
        	} else if ( c.Name == 'Marry Tester') {
        		contactMarry = c;
        	}
        }

        List<Project__c> projectList = [select Id, Name, Applied_Payment_Total__c from Project__c];
        Project__c projBOA = new Project__c();
        Project__c projAAA = new Project__c();
        Project__c projPTF = new Project__c();
        for ( Project__c pr : projectList) {

            if ( pr.Name == 'Bank of America') {
                projBOA = pr;
            } else if ( pr.Name == 'AAA') {
                projAAA = pr;
            } else if ( pr.Name == 'PTF') {
                projPTF = pr;
            }
        }

        // Assert
        System.debug( 'The expected value is false and the actual value is ' + pMExtension.renderNewPayment);
        System.assertEquals( pMExtension.renderNewPayment, false);

        System.debug( 'The expected value is 3 and the actual value is ' + pMExtension.paymentWrapperList.size());
        System.assertEquals( pMExtension.paymentWrapperList.size(), 3);

        System.debug( 'The expected value is 1000 and the actual value is ' + contactTed.Applied_Payment_Total__c);
        System.assertEquals( contactTed.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 1000 and the actual value is ' + contactLarry.Applied_Payment_Total__c);
        System.assertEquals( contactLarry.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 2000 and the actual value is ' + contactMarry.Applied_Payment_Total__c);
        System.assertEquals( contactMarry.Applied_Payment_Total__c, 2000);

        System.debug( 'The expected value is 2000 and the actual value is ' + projBOA.Applied_Payment_Total__c);
        System.assertEquals( projBOA.Applied_Payment_Total__c, 2000);

        System.debug( 'The expected value is 1000 and the actual value is ' + projAAA.Applied_Payment_Total__c);
        System.assertEquals( projAAA.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 1000 and the actual value is ' + projPTF.Applied_Payment_Total__c);
        System.assertEquals( projPTF.Applied_Payment_Total__c, 1000);
    }

    // test PaymentManager page invocation, page action method, start new payment but cancel
    static testMethod void testPaymentManagerAddAndCancelPositive() {  
        
        // Arrange
        Payment__c p = [select Id from Payment__c limit 1];

        // Act
        Test.startTest();
        	PageReference pMRef = Page.PaymentManager;
			Test.setCurrentPage( pMRef);
			ApexPages.StandardController controller = new ApexPages.StandardController( p);
			PaymentManagerExtension pMExtension = new PaymentManagerExtension( controller);
			pMExtension.getActivePaymentsByContact();
			pMExtension.addNewPayment();
			pMExtension.cancelNewPayment();
        Test.stopTest();

        List<Contact> contactList = [select Id, Name, Applied_Payment_Total__c from Contact];
        Contact contactTed = new Contact();
        Contact contactLarry = new Contact();
        Contact contactMarry = new Contact();
        for ( Contact c : contactList) {

        	if ( c.Name == 'Ted Tester') {
        		contactTed = c;
        	} else if ( c.Name == 'Larry Tester') {
        		contactLarry = c;
        	} else if ( c.Name == 'Marry Tester') {
        		contactMarry = c;
        	}
        }

        List<Project__c> projectList = [select Id, Name, Applied_Payment_Total__c from Project__c];
        Project__c projBOA = new Project__c();
        Project__c projAAA = new Project__c();
        Project__c projPTF = new Project__c();
        for ( Project__c pr : projectList) {

            if ( pr.Name == 'Bank of America') {
                projBOA = pr;
            } else if ( pr.Name == 'AAA') {
                projAAA = pr;
            } else if ( pr.Name == 'PTF') {
                projPTF = pr;
            }
        }

        // Assert
        System.debug( 'The expected value is false and the actual value is ' + pMExtension.renderNewPayment);
        System.assertEquals( pMExtension.renderNewPayment, false);

        System.debug( 'The expected value is 3 and the actual value is ' + pMExtension.paymentWrapperList.size());
        System.assertEquals( pMExtension.paymentWrapperList.size(), 3);

        System.debug( 'The expected value is 1000 and the actual value is ' + contactTed.Applied_Payment_Total__c);
        System.assertEquals( contactTed.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 1000 and the actual value is ' + contactLarry.Applied_Payment_Total__c);
        System.assertEquals( contactLarry.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 2000 and the actual value is ' + contactMarry.Applied_Payment_Total__c);
        System.assertEquals( contactMarry.Applied_Payment_Total__c, 2000);

        System.debug( 'The expected value is 2000 and the actual value is ' + projBOA.Applied_Payment_Total__c);
        System.assertEquals( projBOA.Applied_Payment_Total__c, 2000);

        System.debug( 'The expected value is 1000 and the actual value is ' + projAAA.Applied_Payment_Total__c);
        System.assertEquals( projAAA.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 1000 and the actual value is ' + projPTF.Applied_Payment_Total__c);
        System.assertEquals( projPTF.Applied_Payment_Total__c, 1000);
    }

    // test PaymentManager page invocation, page action method, start to delete payment but cancel
    static testMethod void testPaymentManagerDeleteAndCancelPositive() {  
        
        // Arrange
        Payment__c p = [select Id from Payment__c limit 1];

        // Act
        Test.startTest();
        	PageReference pMRef = Page.PaymentManager;
			Test.setCurrentPage( pMRef);
			ApexPages.StandardController controller = new ApexPages.StandardController( p);
			PaymentManagerExtension pMExtension = new PaymentManagerExtension( controller);
			pMExtension.getActivePaymentsByContact();
			pMExtension.deletePayment();
			pMExtension.cancelDeletePayment();
        Test.stopTest();

        List<Contact> contactList = [select Id, Name, Applied_Payment_Total__c from Contact];
        Contact contactTed = new Contact();
        Contact contactLarry = new Contact();
        Contact contactMarry = new Contact();
        for ( Contact c : contactList) {

        	if ( c.Name == 'Ted Tester') {
        		contactTed = c;
        	} else if ( c.Name == 'Larry Tester') {
        		contactLarry = c;
        	} else if ( c.Name == 'Marry Tester') {
        		contactMarry = c;
        	}
        }

        List<Project__c> projectList = [select Id, Name, Applied_Payment_Total__c from Project__c];
        Project__c projBOA = new Project__c();
        Project__c projAAA = new Project__c();
        Project__c projPTF = new Project__c();
        for ( Project__c pr : projectList) {

            if ( pr.Name == 'Bank of America') {
                projBOA = pr;
            } else if ( pr.Name == 'AAA') {
                projAAA = pr;
            } else if ( pr.Name == 'PTF') {
                projPTF = pr;
            }
        }

        // Assert
        System.debug( 'The expected value is false and the actual value is ' + pMExtension.renderNewPayment);
        System.assertEquals( pMExtension.renderNewPayment, false);

        System.debug( 'The expected value is 3 and the actual value is ' + pMExtension.paymentWrapperList.size());
        System.assertEquals( pMExtension.paymentWrapperList.size(), 3);

        System.debug( 'The expected value is 1000 and the actual value is ' + contactTed.Applied_Payment_Total__c);
        System.assertEquals( contactTed.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 1000 and the actual value is ' + contactLarry.Applied_Payment_Total__c);
        System.assertEquals( contactLarry.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 2000 and the actual value is ' + contactMarry.Applied_Payment_Total__c);
        System.assertEquals( contactMarry.Applied_Payment_Total__c, 2000);

        System.debug( 'The expected value is 2000 and the actual value is ' + projBOA.Applied_Payment_Total__c);
        System.assertEquals( projBOA.Applied_Payment_Total__c, 2000);

        System.debug( 'The expected value is 1000 and the actual value is ' + projAAA.Applied_Payment_Total__c);
        System.assertEquals( projAAA.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 1000 and the actual value is ' + projPTF.Applied_Payment_Total__c);
        System.assertEquals( projPTF.Applied_Payment_Total__c, 1000);
    }

    // test PaymentManager page invocation, page action method, start new payment and save
    static testMethod void testPaymentManagerAddAndSavePositive() {  
        
        // Arrange
        Payment__c p = [select Id from Payment__c limit 1];
        Project__c project = [select Id from Project__c where Name = 'Bank of America'];
        Contact contact = [select Id from Contact where Name = 'Larry Tester'];

        // Act
        Test.startTest();
        	PageReference pMRef = Page.PaymentManager;
			Test.setCurrentPage( pMRef);
			ApexPages.StandardController controller = new ApexPages.StandardController( p);
			PaymentManagerExtension pMExtension = new PaymentManagerExtension( controller);
			pMExtension.getActivePaymentsByContact();
			pMExtension.addNewPayment();
			pMExtension.newPaymentRecord.Contact__c = contact.Id;
			pMExtension.newPaymentRecord.Project__c = project.Id;
			pMExtension.newPaymentRecord.Amount__c = 1000;
			pMExtension.newPaymentRecord.Payment_Date__c = Datetime.now();
			pMExtension.saveNewPayment();
        Test.stopTest();

        List<Contact> contactList = [select Id, Name, Applied_Payment_Total__c from Contact];
        Contact contactTed = new Contact();
        Contact contactLarry = new Contact();
        Contact contactMarry = new Contact();
        for ( Contact c : contactList) {

        	if ( c.Name == 'Ted Tester') {
        		contactTed = c;
        	} else if ( c.Name == 'Larry Tester') {
        		contactLarry = c;
        	} else if ( c.Name == 'Marry Tester') {
        		contactMarry = c;
        	}
        }

        List<Project__c> projectList = [select Id, Name, Applied_Payment_Total__c from Project__c];
        Project__c projBOA = new Project__c();
        Project__c projAAA = new Project__c();
        Project__c projPTF = new Project__c();
        for ( Project__c pr : projectList) {

            if ( pr.Name == 'Bank of America') {
                projBOA = pr;
            } else if ( pr.Name == 'AAA') {
                projAAA = pr;
            } else if ( pr.Name == 'PTF') {
                projPTF = pr;
            }
        }

        // Assert
        System.debug( 'The expected value is false and the actual value is ' + pMExtension.renderNewPayment);
        System.assertEquals( pMExtension.renderNewPayment, false);

        System.debug( 'The expected value is 3 and the actual value is ' + pMExtension.paymentWrapperList.size());
        System.assertEquals( pMExtension.paymentWrapperList.size(), 3);

        System.debug( 'The expected value is 1000 and the actual value is ' + contactTed.Applied_Payment_Total__c);
        System.assertEquals( contactTed.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 2000 and the actual value is ' + contactLarry.Applied_Payment_Total__c);
        System.assertEquals( contactLarry.Applied_Payment_Total__c, 2000);

        System.debug( 'The expected value is 2000 and the actual value is ' + contactMarry.Applied_Payment_Total__c);
        System.assertEquals( contactMarry.Applied_Payment_Total__c, 2000);

        System.debug( 'The expected value is 3000 and the actual value is ' + projBOA.Applied_Payment_Total__c);
        System.assertEquals( projBOA.Applied_Payment_Total__c, 3000);

        System.debug( 'The expected value is 1000 and the actual value is ' + projAAA.Applied_Payment_Total__c);
        System.assertEquals( projAAA.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 1000 and the actual value is ' + projPTF.Applied_Payment_Total__c);
        System.assertEquals( projPTF.Applied_Payment_Total__c, 1000);
    }

    // test PaymentManager page invocation, page action method, delete payment and save
    static testMethod void testPaymentManagerDeleteAndSavePositive() {  
        
        // Arrange
        Payment__c p = [select Id from Payment__c limit 1];
        Contact cn = [select Id from Contact where Name = 'Larry Tester'];

        // Act
        Test.startTest();
        	PageReference pMRef = Page.PaymentManager;
			Test.setCurrentPage( pMRef);
			ApexPages.StandardController controller = new ApexPages.StandardController( p);
			PaymentManagerExtension pMExtension = new PaymentManagerExtension( controller);
			pMExtension.getActivePaymentsByContact();
			pMExtension.deletePayment();
			PaymentDataService pDataService = new PaymentDataService();
			pMExtension.paymentsToDeleteList = pDataService.getAllAppliedPaymentsByContact( cn.Id);
			for ( Payment__c pay : pMExtension.paymentsToDeleteList) {

				pay.Delete__c = true;
			}
			pMExtension.deleteSelectedPayments();
        Test.stopTest();

        List<Contact> contactList = [select Id, Name, Applied_Payment_Total__c from Contact];
        Contact contactTed = new Contact();
        Contact contactLarry = new Contact();
        Contact contactMarry = new Contact();
        for ( Contact c : contactList) {

        	if ( c.Name == 'Ted Tester') {
        		contactTed = c;
        	} else if ( c.Name == 'Larry Tester') {
        		contactLarry = c;
        	} else if ( c.Name == 'Marry Tester') {
        		contactMarry = c;
        	}
        }

        List<Project__c> projectList = [select Id, Name, Applied_Payment_Total__c from Project__c];
        Project__c projBOA = new Project__c();
        Project__c projAAA = new Project__c();
        Project__c projPTF = new Project__c();
        for ( Project__c pr : projectList) {

            if ( pr.Name == 'Bank of America') {
                projBOA = pr;
            } else if ( pr.Name == 'AAA') {
                projAAA = pr;
            } else if ( pr.Name == 'PTF') {
                projPTF = pr;
            }
        }

        // Assert
        System.debug( 'The expected value is false and the actual value is ' + pMExtension.renderNewPayment);
        System.assertEquals( pMExtension.renderNewPayment, false);

        System.debug( 'The expected value is 3 and the actual value is ' + pMExtension.paymentWrapperList.size());
        System.assertEquals( pMExtension.paymentWrapperList.size(), 2);

        System.debug( 'The expected value is 1000 and the actual value is ' + contactTed.Applied_Payment_Total__c);
        System.assertEquals( contactTed.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is null and the actual value is ' + contactLarry.Applied_Payment_Total__c);
        System.assertEquals( contactLarry.Applied_Payment_Total__c, null);

        System.debug( 'The expected value is 2000 and the actual value is ' + contactMarry.Applied_Payment_Total__c);
        System.assertEquals( contactMarry.Applied_Payment_Total__c, 2000);

        System.debug( 'The expected value is 1000 and the actual value is ' + projBOA.Applied_Payment_Total__c);
        System.assertEquals( projBOA.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 1000 and the actual value is ' + projAAA.Applied_Payment_Total__c);
        System.assertEquals( projAAA.Applied_Payment_Total__c, 1000);

        System.debug( 'The expected value is 1000 and the actual value is ' + projPTF.Applied_Payment_Total__c);
        System.assertEquals( projPTF.Applied_Payment_Total__c, 1000);
    }
    
}