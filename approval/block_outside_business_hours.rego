# Require manual approval for automated runs outside business hours.
# Runs triggered by a human (manual, api) are always allowed through.
# Adjust ALLOWED_DAYS, ALLOWED_START, ALLOWED_END to match your change window.
package crucible.approval.block_outside_business_hours

import rego.v1

ALLOWED_DAYS  := {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"}
ALLOWED_START := 9   # 09:00 UTC inclusive
ALLOWED_END   := 17  # 17:00 UTC exclusive

default require_approval := false

# Only gate automated runs; humans triggering runs bypass this check.
require_approval if {
	not input.run.trigger in {"manual", "api"}
	in_change_blackout
}

in_change_blackout if {
	not time.weekday(time.now_ns()) in ALLOWED_DAYS
}

in_change_blackout if {
	h := time.clock([time.now_ns(), "UTC"])[0]
	h < ALLOWED_START
}

in_change_blackout if {
	h := time.clock([time.now_ns(), "UTC"])[0]
	h >= ALLOWED_END
}
