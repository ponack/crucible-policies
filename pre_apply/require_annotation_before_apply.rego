# crucible:type pre_apply
# Block applies that do not have an operator note/annotation.
# Ensures every infrastructure change has a documented reason in the audit trail.
package crucible.pre_apply.require_annotation_before_apply

import rego.v1

default deny := false
default deny_message := ""

deny if {
	not has_annotation
}

deny_message := "A run annotation (operator note) is required before applying. Add one on the run detail page." if {
	deny
}

has_annotation if {
	count(trim_space(input.annotation)) > 0
}
