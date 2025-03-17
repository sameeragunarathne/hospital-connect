import ballerina/http;
import ballerinax/health.fhir.r4 as r4;
import ballerinax/health.fhir.r4.international401 as international401;
import ballerinax/health.fhir.r4.ips;
import ballerinax/health.fhir.r4utils.ccdatofhir as ccdatofhir;
import ballerina/time;

final http:Client ccdaClient = check new (ccdaEndpoint);

service /fhir/r4 on new http:Listener(servicePort) {

    // Get patient summary by converting CCDA to FHIR
    resource function get Patient/[string id]/summary() returns r4:Bundle|error {
        xml|error ccdaResponse = check ccdaClient->/patients/[id]/ccda;
        if ccdaResponse is error {
            return error("Failed to retrieve CCDA data");
        }
        r4:Bundle|error fhirBundle = ccdatofhir:ccdaToFhir(ccdaResponse);
        if fhirBundle is error {
            return error("Failed to convert CCDA to FHIR");
        }
        r4:BundleEntry[] entries = fhirBundle.entry ?: [];
        ips:CompositionUvIps composition = {date: time:utcNow().toString(), subject: {reference: ""}, author: [], section: [], title: "", 'type: {}, status: "preliminary"};
        ips:IpsBundleData ipsData = {composition: composition, patient: {birthDate: "", name: []}};
        ips:AllergyIntoleranceUvIps[] allergyIntoleranceArr = [];
        ips:ConditionUvIps[] conditionArr = [];
        foreach var entry in entries {
            if entry?.'resource is international401:Patient {
                ipsData.patient = check entry?.'resource.cloneWithType();
                ipsData.patient.id = string`Patient/${id}`;
                composition.subject.reference = string`Patient/${id}`;
            } else if entry?.'resource is international401:AllergyIntolerance {
                international401:AllergyIntolerance allergyIntolerance = check entry?.'resource.cloneWithType();
                allergyIntolerance.patient.reference = string`Patient/${id}`;
                ips:AllergyIntoleranceUvIps allergyIntoleranceIps = check allergyIntolerance.cloneWithType();
                allergyIntoleranceArr.push(allergyIntoleranceIps);
            } else if entry?.'resource is international401:Condition {
                international401:Condition condition = check entry?.'resource.cloneWithType();
                condition.subject.reference = string`Patient/${id}`;
                ips:ConditionUvIps conditionIps = check condition.cloneWithType();
                conditionArr.push(conditionIps);
            }
        }
        if allergyIntoleranceArr.length() > 0 {
            ipsData.allergyIntolerance = allergyIntoleranceArr;
        }
        if conditionArr.length() > 0 {
            ipsData.condition = conditionArr;
        }
        return ips:getIpsBundle(ipsData);
    }

    // Create a new patient
    resource function post Patient(@http:Payload r4:DomainResource payload) returns r4:DomainResource|error {
        // Implementation for creating patient
        return payload;
    }

    // Read patient by ID
    resource function get Patient/[string id]() returns r4:DomainResource|error {
        // Implementation for reading patient
        return error("Not implemented");
    }

    // Read specific version of patient
    resource function get Patient/[string id]/_history/[string vid]() returns r4:DomainResource|error {
        // Implementation for version specific read
        return error("Not implemented");
    }

    // Delete patient
    resource function delete Patient/[string id]() returns http:NoContent|error {
        // Implementation for deleting patient
        return http:NO_CONTENT;
    }
}
