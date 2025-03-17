import ballerina/http;
import ballerinax/health.fhir.r4 as r4;

final http:Client ccdaClient = check new (ccdaEndpoint);

service /fhir/r4 on new http:Listener(servicePort) {

    // Create a new patient
    resource function post Patient(@http:Payload json payload) returns json|error {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome.toJson();
    }

    // Read patient by ID
    resource function get Patient/[string id]() returns json|error {
        xml|error ccdaResponse = check ccdaClient->/patients/[id]/ccda;
        if ccdaResponse is error {
            return error("Failed to retrieve CCDA data");
        }
        r4:Resource|error fhirResourcesFromCcda = getFhirResourcesFromCcda(ccdaResponse, "Patient", id);
        if fhirResourcesFromCcda is r4:Resource {
            return fhirResourcesFromCcda.toJson();
        }
        r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "exception", diagnostics: "Failed to construct FHIR patient resource"}]};
        return operationOutcome.toJson();
    }

    // Read specific version of patient
    resource function get Patient/[string id]/_history/[string vid]() returns json|error {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome.toJson();
    }

    // Delete patient
    resource function delete Patient/[string id]() returns json|error {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome.toJson();
    }

    // Create a new condition
    resource function post Condition(@http:Payload json payload) returns json|error {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome.toJson();
    }

    // Read condition by ID
    resource function get Condition/[string id]() returns json|error {
        if !id.startsWith("cnd-") {
            r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "processing", diagnostics: "Invalid ID"}]};
            return operationOutcome.toJson();
        }
        string patient = id.substring(4);
        xml|error ccdaResponse = check ccdaClient->/patients/[patient]/ccda;
        if ccdaResponse is error {
            return error("Failed to retrieve CCDA data");
        }
        r4:Resource|error fhirResourcesFromCcda = getFhirResourcesFromCcda(ccdaResponse, "Condition", patient, id);
        if fhirResourcesFromCcda is r4:Resource {
            return fhirResourcesFromCcda.toJson();
        }
        r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "exception", diagnostics: "Failed to construct FHIR condition resources"}]};
        return operationOutcome.toJson();
    }

    // Search conditions
    resource function get Condition(string? patient) returns json|error {
        if patient is () {
            return error("Patient reference is required");
        }
        xml|error ccdaResponse = check ccdaClient->/patients/[patient]/ccda;
        if ccdaResponse is error {
            r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "exception", diagnostics: "Failed to retrieve CCDA data"}]};
            return operationOutcome.toJson();
        }
        r4:Resource|error fhirResourcesFromCcda = getFhirResourcesFromCcda(ccdaResponse, "Condition", patient);
        if fhirResourcesFromCcda is r4:Bundle {
            return fhirResourcesFromCcda.toJson();
        }
        r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "exception", diagnostics: "Failed to construct FHIR condition resources"}]};
        return operationOutcome.toJson();
    }

    // Read specific version of condition
    resource function get Condition/[string id]/_history/[string vid]() returns json {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome.toJson();
    }

    // Delete condition
    resource function delete Condition/[string id]() returns json {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome.toJson();
    }

    // Create a new allergy intolerance
    resource function post AllergyIntolerance(@http:Payload json payload) returns json {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome.toJson();
    }

    // Read allergy intolerance by ID
    resource function get AllergyIntolerance/[string id]() returns json|error {
        if !id.startsWith("alg-") {
            r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "processing", diagnostics: "Invalid ID"}]};
            return operationOutcome.toJson();
        }
        string patient = id.substring(4);
        xml|error ccdaResponse = check ccdaClient->/patients/[patient]/ccda;
        if ccdaResponse is error {
            r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "processing", diagnostics: "Failed to retrieve CCDA data"}]};
            return operationOutcome.toJson();
        }
        r4:Resource|error fhirResourcesFromCcda = getFhirResourcesFromCcda(ccdaResponse, "AllergyIntolerance", patient, id);
        if fhirResourcesFromCcda is r4:Resource {
            return fhirResourcesFromCcda.toJson();
        }
        r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "exception", diagnostics: "Failed to construct FHIR allergyintolerance resources"}]};
        return operationOutcome.toJson();
    }

    // Search allergy intolerances
    resource function get AllergyIntolerance(string? patient) returns json|error {
        if patient is () {
            r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "processing", diagnostics: "Patient reference is required"}]};
            return operationOutcome.toJson();
        }
        xml|error ccdaResponse = check ccdaClient->/patients/[patient]/ccda;
        if ccdaResponse is error {
            r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "processing", diagnostics: "Failed to retrieve CCDA data"}]};
            return operationOutcome.toJson();
        }
        r4:Resource|error fhirResourcesFromCcda = getFhirResourcesFromCcda(ccdaResponse, "AllergyIntolerance", patient);
        if fhirResourcesFromCcda is r4:Bundle {
            return fhirResourcesFromCcda.toJson();
        }
        r4:OperationOutcome operationOutcome = {issue: [{severity: "error", code: "exception", diagnostics: "Failed to construct FHIR allergyintolerance resources"}]};
        return operationOutcome.toJson();
    }

    // Read specific version of allergy intolerance
    resource function get AllergyIntolerance/[string id]/_history/[string vid]() returns json {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome.toJson();
    }

    // Delete allergy intolerance
    resource function delete AllergyIntolerance/[string id]() returns json {
        r4:OperationOutcome operationOutcome = {issue: [{severity: "information", code: "informational", diagnostics: "Not implemented"}]};
        return operationOutcome.toJson();
    }
}