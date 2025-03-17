import ballerina/http;
import ballerinax/health.fhir.r4 as r4;

final http:Client ccdaClient = check new (ccdaEndpoint);

service /fhir/r4 on new http:Listener(servicePort) {

    // Create a new patient
    resource function post Patient(@http:Payload r4:DomainResource payload) returns r4:Resource|error {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome;
    }

    // Read patient by ID
    resource function get Patient/[string id]() returns r4:Resource|error {
        xml|error ccdaResponse = check ccdaClient->/patients/[id]/ccda;
        if ccdaResponse is error {
            return error("Failed to retrieve CCDA data");
        }
        r4:Resource|error fhirResourcesFromCcda = getFhirResourcesFromCcda(ccdaResponse, "Patient", id);
        if fhirResourcesFromCcda is r4:Resource {
            return fhirResourcesFromCcda;
        }
        r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "exception", diagnostics: "Failed to construct FHIR patient resource"}]};
        return operationOutcome;
    }

    // Read specific version of patient
    resource function get Patient/[string id]/_history/[string vid]() returns r4:DomainResource|error {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome;
    }

    // Delete patient
    resource function delete Patient/[string id]() returns r4:Resource|error {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome;
    }

    // Create a new condition
    resource function post Condition(@http:Payload r4:Resource payload) returns r4:Resource|error {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome;
    }

    // Read condition by ID
    resource function get Condition/[string id]() returns r4:Resource|error {
        xml|error ccdaResponse = check ccdaClient->/patients/ccda;
        if ccdaResponse is error {
            return error("Failed to retrieve CCDA data");
        }
        r4:Resource|error fhirResourcesFromCcda = getFhirResourcesFromCcda(ccdaResponse, "Condition", (), id);
        if fhirResourcesFromCcda is r4:Resource {
            return fhirResourcesFromCcda;
        }
        r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "exception", diagnostics: "Failed to construct FHIR condition resources"}]};
        return operationOutcome;
    }

    // Search conditions
    resource function get Condition(string? patient) returns r4:Bundle|r4:OperationOutcome|error {
        if patient is () {
            return error("Patient reference is required");
        }
        xml|error ccdaResponse = check ccdaClient->/patients/[patient]/ccda;
        if ccdaResponse is error {
            r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "exception", diagnostics: "Failed to retrieve CCDA data"}]};
            return operationOutcome;
        }
        r4:Resource|error fhirResourcesFromCcda = getFhirResourcesFromCcda(ccdaResponse, "Condition", patient);
        if fhirResourcesFromCcda is r4:Bundle {
            return fhirResourcesFromCcda;
        }
        r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "exception", diagnostics: "Failed to construct FHIR condition resources"}]};
        return operationOutcome;
    }

    // Read specific version of condition
    resource function get Condition/[string id]/_history/[string vid]() returns r4:Resource|error {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome;
    }

    // Delete condition
    resource function delete Condition/[string id]() returns r4:Resource|error {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome;
    }

    // Create a new allergy intolerance
    resource function post AllergyIntolerance(@http:Payload r4:DomainResource payload) returns r4:DomainResource|error {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome;
    }

    // Read allergy intolerance by ID
    resource function get AllergyIntolerance/[string id]() returns r4:Resource|error {
        xml|error ccdaResponse = check ccdaClient->/patients/ccda;
        if ccdaResponse is error {
            return error("Failed to retrieve CCDA data");
        }
        r4:Resource|error fhirResourcesFromCcda = getFhirResourcesFromCcda(ccdaResponse, "AllergyIntolerance", (), id);
        if fhirResourcesFromCcda is r4:Resource {
            return fhirResourcesFromCcda;
        }
        r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "exception", diagnostics: "Failed to construct FHIR allergyintolerance resources"}]};
        return operationOutcome;
    }

    // Search allergy intolerances
    resource function get AllergyIntolerance(string? patient) returns r4:Bundle|r4:OperationOutcome|error {
        if patient is () {
            return error("Patient reference is required");
        }
        xml|error ccdaResponse = check ccdaClient->/patients/[patient]/ccda;
        if ccdaResponse is error {
            return error("Failed to retrieve CCDA data");
        }
        r4:Resource|error fhirResourcesFromCcda = getFhirResourcesFromCcda(ccdaResponse, "AllergyIntolerance", patient);
        if fhirResourcesFromCcda is r4:Bundle {
            return fhirResourcesFromCcda;
        }
        r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "exception", diagnostics: "Failed to construct FHIR allergyintolerance resources"}]};
        return operationOutcome;
    }

    // Read specific version of allergy intolerance
    resource function get AllergyIntolerance/[string id]/_history/[string vid]() returns r4:Resource|error {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome;
    }

    // Delete allergy intolerance
    resource function delete AllergyIntolerance/[string id]() returns r4:Resource|error {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome;
    }
}