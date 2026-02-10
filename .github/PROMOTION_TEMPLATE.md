---
title: Model Promotion Review — {{ env.ART_COLLECTION }}
assignees: MBakirWB
labels: model-promotion
---

**{{ env.AUTHOR }}** promoted a new version of **{{ env.ART_COLLECTION }}** to production.

| Field | Value |
|-------|-------|
| Collection | `{{ env.ART_COLLECTION }}` |
| Version | `{{ env.ART_VERSION_STR }}` |
| Project | `{{ env.PROJECT_NAME }}` |
| Entity | `{{ env.ENTITY_NAME }}` |

View the artifact in W&B: https://mbakir.wandb.io/{{ env.ENTITY_NAME }}/{{ env.PROJECT_NAME }}/artifacts/{{ env.ART_COLLECTION }}

Please review and approve as necessary.
