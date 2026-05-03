# crucible:type post_plan
# Emit a warning when a plan affects a large number of resources.
# This does not block the run — it surfaces a visible warning in the run detail.
package crucible.post_plan.warn_on_large_change

import rego.v1

THRESHOLD := 20

default warn := false
default warn_message := ""

total_changes := (input.plan_add + input.plan_change + input.plan_destroy)

warn if {
	total_changes >= THRESHOLD
}

warn_message := sprintf("Large plan: %d resources affected (%d add, %d change, %d destroy). Review carefully.", [
	total_changes,
	input.plan_add,
	input.plan_change,
	input.plan_destroy,
]) if {
	warn
}
