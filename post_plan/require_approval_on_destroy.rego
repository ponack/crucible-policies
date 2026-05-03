# crucible:type post_plan
# Require a human to approve any plan that destroys at least one resource.
package crucible.post_plan.require_approval_on_destroy

import rego.v1

default require_approval := false

require_approval if {
	input.plan_destroy > 0
}
