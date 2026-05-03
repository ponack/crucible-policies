# Block applies when the stack is flagged with "s3" or "storage" in its slug AND
# the run creates new resources via an automated push — a lightweight gate that
# requires a human apply confirmation before storage buckets can be provisioned.
#
# NOTE: Full per-resource ACL checking (Checkov/Trivy findings) is not yet
# available in the standard Crucible policy input. Upgrade this policy once
# security-scanning results are injected into input.security_findings.
package crucible.post_plan.no_public_s3_buckets

import rego.v1

default deny := false
default deny_message := ""

storage_stack if {
	contains(lower(input.stack.slug), "s3")
}

storage_stack if {
	contains(lower(input.stack.slug), "storage")
}

deny if {
	storage_stack
	input.run.plan_add > 0
	input.run.trigger in {"push", "pull_request"}
}

deny_message := sprintf(
	"Stack '%s' is flagged as a storage stack. Automated runs that create resources require manual apply confirmation.",
	[input.stack.name],
) if {
	deny
}
