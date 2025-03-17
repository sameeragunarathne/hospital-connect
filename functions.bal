import ballerinax/health.fhir.r4 as r4;
import ballerinax/health.fhir.r4.international401 as international401;
import ballerinax/health.fhir.r4utils.ccdatofhir as ccdatofhir;

function getFhirResourcesFromCcda(xml ccdaDocument, string resourceType, string patientId, string? resourceId = ()) returns r4:Resource|error {
    r4:Bundle|error fhirBundle = ccdatofhir:ccdaToFhir(ccdaDocument);
    if fhirBundle is error {
        return error("Failed to convert CCDA to FHIR");
    }
    r4:BundleEntry[] entries = fhirBundle.entry ?: [];
    r4:BundleEntry[] fhirBundleEntryArr = [];
    r4:Bundle fhirBundleResult = {entry: fhirBundleEntryArr, 'type: "document"};
    foreach var entry in entries {
        if resourceType == "Patient" && entry?.'resource is international401:Patient {
            international401:Patient patient = check entry?.'resource.cloneWithType();
            patient.id = string `Patient/${patientId}`;
            return patient;
        } else if resourceType == "AllergyIntolerance" && entry?.'resource is international401:AllergyIntolerance {
            international401:AllergyIntolerance allergyIntolerance = check entry?.'resource.cloneWithType();
            allergyIntolerance.patient.reference = string `Patient/${patientId}`;
            if resourceId != () {
                allergyIntolerance.id = resourceId;
                return allergyIntolerance;
            } else {
                allergyIntolerance.id = string `alg-${patientId}`;
            }
            fhirBundleEntryArr.push({'resource: allergyIntolerance});
        } else if resourceType == "Condition" && entry?.'resource is international401:Condition {
            international401:Condition condition = check entry?.'resource.cloneWithType();
            condition.subject.reference = string `Patient/${patientId}`;
            if resourceId != () {
                condition.id = resourceId;
                return condition;
            } else {
                condition.id = string `cnd-${patientId}`;
            }
            fhirBundleEntryArr.push({'resource: condition});
        }
    }
    return fhirBundleResult;
}
