# crucible:type post_plan
# Block applies that would create or update an S3 bucket with public ACL.
# Works with Checkov/Trivy findings surfaced in the run context.
package crucible.post_plan.no_public_s3_buckets

import rego.v1

default deny := false
default deny_message := ""

public_acls := {"public-read", "public-read-write", "authenticated-read"}

deny if {
	some finding in input.security_findings
	finding.severity == "CRITICAL"
	contains(finding.check_id, "S3")
	contains(lower(finding.description), "public")
}

deny_message := "CRITICAL: S3 bucket with public ACL detected. Remove public access before applying." if {
	deny
}
