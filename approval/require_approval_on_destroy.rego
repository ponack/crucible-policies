# Require a human to approve any plan that destroys at least one resource.
package crucible.approval.require_approval_on_destroy

import rego.v1

default require_approval := false

require_approval if {
	input.run.plan_destroy > 0
}
