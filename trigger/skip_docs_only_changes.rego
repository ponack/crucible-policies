# crucible:type trigger
# Skip a run when the push only touches documentation or non-IaC files.
# Prevents unnecessary plan runs on README or CHANGELOG updates.
package crucible.trigger.skip_docs_only_changes

import rego.v1

# File extensions that do NOT require a run.
SKIP_EXTENSIONS := {".md", ".txt", ".png", ".jpg", ".jpeg", ".svg", ".pdf", ".gif"}

# Directory prefixes that do NOT require a run.
SKIP_PREFIXES := {"docs/", ".github/", "scripts/"}

default skip := false

skip if {
	count(input.changed_files) > 0
	every f in input.changed_files {
		should_skip_file(f)
	}
}

should_skip_file(path) if {
	some ext in SKIP_EXTENSIONS
	endswith(path, ext)
}

should_skip_file(path) if {
	some prefix in SKIP_PREFIXES
	startswith(path, prefix)
}
