# crucible:type approval
# Prevent automatic approval (auto_apply) outside business hours.
# Runs triggered manually by an authenticated user are still allowed through.
# Adjust ALLOWED_HOURS and ALLOWED_DAYS to match your org's change window.
package crucible.approval.block_outside_business_hours

import rego.v1

# Mon=1 … Fri=5 in Go's time.Weekday
ALLOWED_DAYS   := {1, 2, 3, 4, 5}
ALLOWED_START  := 9   # 09:00 UTC
ALLOWED_END    := 17  # 17:00 UTC (exclusive)

default require_approval := false

require_approval if {
	input.trigger == "push"           # auto-triggered runs only
	in_change_blackout
}

in_change_blackout if {
	not number_in_set(input.weekday, ALLOWED_DAYS)
}

in_change_blackout if {
	input.hour < ALLOWED_START
}

in_change_blackout if {
	input.hour >= ALLOWED_END
}

number_in_set(n, s) if {
	s[n]
}
