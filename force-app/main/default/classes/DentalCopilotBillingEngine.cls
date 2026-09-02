public with sharing class DentalCopilotBillingEngine {

    public class PreDetRequestInputs {

        @InvocableVariable(required=true)
        public Id policyId;

        @InvocableVariable(required=true)
        public String cdtCode;

        @InvocableVariable(required=true)
        public Decimal providerCharge;

        @InvocableVariable(required=true)
        public String toothNumber;
    }

    public class PreDetOutputs {

        @InvocableVariable
        public Decimal patientResponsibility;

        @InvocableVariable
        public Decimal insuranceCoverage;

        @InvocableVariable
        public String calculationBreakdown;
    }

    @InvocableMethod(
    label='Calculate Dental Benefits'
    description='Computes dental coverage'
)
public static List<PreDetOutputs> calculateDentalBenefits(
    List<PreDetRequestInputs> inputs
) {

    List<PreDetOutputs> outputs =
        new List<PreDetOutputs>();

    for (PreDetRequestInputs req : inputs) {

        PreDetOutputs result =
            new PreDetOutputs();

        Insurance_Policy__c policy = [
            SELECT
                Annual_Maximum__c,
                Benefits_Used_To_Date__c
            FROM Insurance_Policy__c
            WHERE Id = :req.policyId
            LIMIT 1
        ];

        Decimal remainingMaximum =
            policy.Annual_Maximum__c -
            policy.Benefits_Used_To_Date__c;

        Decimal expectedCoverage =
            req.providerCharge * 0.50;

        if (expectedCoverage > remainingMaximum) {

            result.insuranceCoverage =
                remainingMaximum;

            result.patientResponsibility =
                req.providerCharge - remainingMaximum;

            result.calculationBreakdown =
                'Coverage capped because the annual maximum has been reached.';

        } else {

            result.insuranceCoverage =
                expectedCoverage;

            result.patientResponsibility =
                req.providerCharge - expectedCoverage;

            result.calculationBreakdown =
                'Standard 50% co-insurance applied for major restorative procedures.';
        }

        outputs.add(result);
    }

    return outputs;
}
}