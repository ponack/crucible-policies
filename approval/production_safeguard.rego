# Require approval for any stack whose name contains "prod".
# Adjust the regex to suit your naming conventions.
package crucible.approval.production_safeguard

import rego.v1

default require_approval := false

require_approval if {
	regex.match(`(?i)(^|[-_/])prod([-_/]|$)`, input.stack.name)
}
