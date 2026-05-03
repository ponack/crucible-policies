# Require approval when the estimated monthly cost delta exceeds a threshold.
# Requires Infracost to be configured (INFRACOST_API_KEY in Settings → General).
# Adjust THRESHOLD_USD to match your team's policy.
package crucible.approval.require_approval_on_high_cost

import rego.v1

THRESHOLD_USD := 100

default require_approval := false

require_approval if {
	is_number(input.run.cost_add)
	input.run.cost_add > THRESHOLD_USD
}
