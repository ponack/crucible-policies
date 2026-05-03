# crucible:type post_plan
# Require approval for any stack whose name contains "prod".
# Adjust the match condition to suit your naming conventions or use tags.
package crucible.post_plan.production_safeguard

import rego.v1

default require_approval := false

require_approval if {
	regex.match(`(?i)(^|[-_/])prod([-_/]|$)`, input.stack_name)
}
