@IsTest
private class DentalCopilotBillingEngineTest {

    @IsTest
    static void testStandardCoverage() {

        Insurance_Policy__c policy =
            new Insurance_Policy__c(
                Annual_Maximum__c = 2000,
                Benefits_Used_To_Date__c = 500,
                Crown_Frequency_Limit_Years__c = 5
            );

        insert policy;

        DentalCopilotBillingEngine.PreDetRequestInputs input =
            new DentalCopilotBillingEngine.PreDetRequestInputs();

        input.policyId = policy.Id;
        input.cdtCode = 'D2740';
        input.providerCharge = 1200;
        input.toothNumber = '3';

        Test.startTest();

        List<DentalCopilotBillingEngine.PreDetOutputs> results =
            DentalCopilotBillingEngine.calculateDentalBenefits(
                new List<DentalCopilotBillingEngine.PreDetRequestInputs>{
                    input
                }
            );

        Test.stopTest();

        System.assertEquals(
            600,
            results[0].insuranceCoverage
        );

        System.assertEquals(
            600,
            results[0].patientResponsibility
        );
    }

    @IsTest
    static void testAnnualMaximumReached() {

        Insurance_Policy__c policy =
            new Insurance_Policy__c(
                Annual_Maximum__c = 1000,
                Benefits_Used_To_Date__c = 800,
                Crown_Frequency_Limit_Years__c = 5
            );

        insert policy;

        DentalCopilotBillingEngine.PreDetRequestInputs input =
            new DentalCopilotBillingEngine.PreDetRequestInputs();

        input.policyId = policy.Id;
        input.cdtCode = 'D2740';
        input.providerCharge = 1200;
        input.toothNumber = '3';

        Test.startTest();

        List<DentalCopilotBillingEngine.PreDetOutputs> results =
            DentalCopilotBillingEngine.calculateDentalBenefits(
                new List<DentalCopilotBillingEngine.PreDetRequestInputs>{
                    input
                }
            );

        Test.stopTest();

        System.assertEquals(
            200,
            results[0].insuranceCoverage
        );

        System.assertEquals(
            1000,
            results[0].patientResponsibility
        );
    }
}