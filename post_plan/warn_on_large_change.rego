# Emit a warning when a plan affects a large number of resources.
# This does not block the run — it surfaces a visible warning in the run detail.
# Adjust THRESHOLD to match your team's tolerance.
package crucible.post_plan.warn_on_large_change

import rego.v1

THRESHOLD := 20

default warn := false
default warn_message := ""

total_changes := input.run.plan_add + input.run.plan_change + input.run.plan_destroy

warn if {
	total_changes >= THRESHOLD
}

warn_message := sprintf(
	"Large plan: %d resources affected (%d add, %d change, %d destroy). Review carefully.",
	[total_changes, input.run.plan_add, input.run.plan_change, input.run.plan_destroy],
) if {
	warn
}
