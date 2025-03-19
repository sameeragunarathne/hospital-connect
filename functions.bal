import ballerinax/health.fhir.r4 as r4;
import ballerinax/health.fhir.r4.international401 as international401;
import ballerinax/health.fhir.r4utils.ccdatofhir as ccdatofhir;
import ballerina/lang.regexp;

function getFhirResourcesFromCcda(xml ccdaDocument, string resourceType, string patientId, string? resourceId = ()) returns r4:Resource|error {
    r4:Bundle|error fhirBundle = ccdatofhir:ccdaToFhir(ccdaDocument);
    if fhirBundle is error {
        return error("Failed to convert CCDA to FHIR");
    }
    r4:BundleEntry[] entries = fhirBundle.entry ?: [];
    r4:BundleEntry[] fhirBundleEntryArr = [];
    r4:Bundle fhirBundleResult = {entry: fhirBundleEntryArr, 'type: "searchset"};
    int resourceCount = 0;
    foreach var entry in entries {
        r4:Resource resourceContent = check entry?.'resource.cloneWithType();
        string extractedResourceType = resourceContent.resourceType;
        if resourceType == "Patient" && resourceType == extractedResourceType {
            international401:Patient patient = check entry?.'resource.cloneWithType();
            patient.id = string `Patient/${patientId}`;
            return patient;
        } else if resourceType == "AllergyIntolerance" && resourceType == extractedResourceType {
            international401:AllergyIntolerance allergyIntolerance = check entry?.'resource.cloneWithType();
            allergyIntolerance.patient.reference = string `Patient/${patientId}`;
            if resourceId != () {
                allergyIntolerance.id = resourceId;
                return allergyIntolerance;
            } else {
                resourceCount += 1;
                if entries.length() > 1 {
                    allergyIntolerance.id = string `alg-${resourceCount}-${patientId}`;
                } else {
                    allergyIntolerance.id = string `alg-${patientId}`;
                }
            }
            fhirBundleEntryArr.push({'resource: allergyIntolerance});
        } else if resourceType == "Condition" && resourceType == extractedResourceType {
            international401:Condition condition = check entry?.'resource.cloneWithType();
            condition.subject.reference = string `Patient/${patientId}`;
            if resourceId != () {
                condition.id = resourceId;
                return condition;
            } else {
                resourceCount += 1;
                if entries.length() > 1 {
                    condition.id = string `cnd-${resourceCount}-${patientId}`;
                } else {
                    condition.id = string `cnd-${patientId}`;
                }
            }
            fhirBundleEntryArr.push({'resource: condition});
        } else if resourceType == "MedicationRequest" && resourceType == extractedResourceType {
            international401:MedicationRequest medicationRequest = check entry?.'resource.cloneWithType();
            medicationRequest.subject.reference = string `Patient/${patientId}`;
            if resourceId != () {
                medicationRequest.id = resourceId;
                return medicationRequest;
            } else {
                resourceCount += 1;
                if entries.length() > 1 {
                    medicationRequest.id = string `med-${resourceCount}-${patientId}`;
                } else {
                    medicationRequest.id = string `med-${patientId}`;
                }
            }
            fhirBundleEntryArr.push({'resource: medicationRequest});
        } 
    }
    return fhirBundleResult;
}

function extractPatientId(string prefix, string id) returns string|error {
    if id.startsWith(prefix) {
        string[] parts = regexp:split(re `-`, id.substring(4));
        if parts.length() == 2 {
            return parts[1];
        } else if parts.length() == 3 {
            return parts[2];
        }
    }
    return error("Invalid Resource ID format");
}