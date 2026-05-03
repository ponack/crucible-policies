# crucible-policies

Starter OPA/Rego policies for [Crucible IAP](https://github.com/ponack/crucible-iap).

Connect this repository as a **Policy GitOps source** in Crucible (Settings → Integrations → Policy Git Sources) to automatically sync all policies into your instance. Crucible infers the policy type from each file's parent directory name.

---

## Policies

| File | Type | What it does |
|------|------|-------------|
| `post_plan/require_approval_on_destroy.rego` | `post_plan` | Gate any plan that destroys ≥1 resource |
| `post_plan/require_approval_on_high_cost.rego` | `post_plan` | Gate when estimated monthly cost delta > $100 (adjustable) |
| `post_plan/warn_on_large_change.rego` | `post_plan` | Warn when plan affects ≥20 resources (adjustable) |
| `post_plan/production_safeguard.rego` | `post_plan` | Require approval for stacks whose name contains `prod` |
| `post_plan/no_public_s3_buckets.rego` | `post_plan` | Block CRITICAL S3 public-access findings from Checkov/Trivy |
| `approval/block_outside_business_hours.rego` | `approval` | Prevent auto-triggered applies outside Mon–Fri 09:00–17:00 UTC |
| `trigger/skip_docs_only_changes.rego` | `trigger` | Skip runs when only `.md`/docs files changed |
| `pre_apply/require_annotation_before_apply.rego` | `pre_apply` | Require an operator note before any apply |

## Quick start

1. Fork this repo (so you can customise policies without losing upstream updates).
2. In Crucible, go to **Settings → Integrations → Policy Git Sources** and add your fork.
3. Click **Sync now** (or push a commit) — policies will appear in **Policies**.
4. Attach the policies you want to individual stacks, or use **OPA approval** hooks at the org level.

> **Tip:** Use the **Policies → Test Playground** (`/policies/test`) to validate any policy with synthetic input before attaching it to a stack.

## Customising

Each policy file is self-contained. Common adjustments:

- **Cost threshold** — edit `THRESHOLD_USD` in `require_approval_on_high_cost.rego`
- **Large-change threshold** — edit `THRESHOLD` in `warn_on_large_change.rego`
- **Business hours** — edit `ALLOWED_DAYS`, `ALLOWED_START`, `ALLOWED_END` in `block_outside_business_hours.rego`
- **Production name pattern** — edit the `regex.match` in `production_safeguard.rego`

## Directory layout

Crucible infers policy type from the directory name:

```
post_plan/    →  runs after terraform plan
pre_apply/    →  runs before terraform apply
approval/     →  gates manual approval step
trigger/      →  controls whether a run is queued at all
login/        →  runs on SSO login (for access control)
```

You can also override the type with an inline comment: `# crucible:type post_plan`

---

Built by [Forged in Feathers Technology](https://www.forgedinfeatherstechnology.com) · [Crucible IAP](https://github.com/ponack/crucible-iap)
