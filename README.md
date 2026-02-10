# W&B Automation Jobs

Automated CI/CD workflows triggered by W&B Automations. When a model is promoted in the W&B Registry (e.g., the `production` alias is added), a webhook fires and triggers a GitHub Actions workflow that creates a review issue.

## How it works

1. A model artifact is promoted in the W&B Model Registry (alias `production` is added)
2. W&B fires a webhook automation with artifact metadata (version, collection, author, project)
3. The webhook triggers a GitHub Actions `repository_dispatch` event
4. The GitHub Action creates a review issue from a template, populated with the promotion details

## Setup

### Prerequisites

- A W&B account with access to Automations (Pro or Enterprise plan)
- A GitHub Personal Access Token (PAT) with `repo` scope or fine-grained permissions for Issues (read/write) and Contents (read)

### GitHub repo configuration

1. Add a repository secret called `ACTION_PAT` with your GitHub PAT value (Settings -> Secrets and variables -> Actions)

### W&B configuration

1. **Create a Secret** in W&B Team Settings: name it `GITHUB_TOKEN`, paste your GitHub PAT
2. **Create a Webhook** in W&B Team Settings:
   - Name: `github-model-cicd`
   - Endpoint: `https://api.github.com/repos/<OWNER>/<REPO>/dispatches`
   - Access token: select the `GITHUB_TOKEN` secret
3. **Create an Automation** on the Registry or Project:
   - Event: "An artifact alias is added"
   - Alias regex: `^production$`
   - Action: Webhook -> `github-model-cicd`
   - Payload:
     ```json
     {
       "event_type": "webhook",
       "client_payload": {
         "event_author": "${event_author}",
         "artifact_version": "${artifact_version}",
         "artifact_version_string": "${artifact_version_string}",
         "artifact_collection_name": "${artifact_collection_name}",
         "project_name": "${project_name}",
         "entity_name": "${entity_name}"
       }
     }
     ```

### Test it

1. In W&B Team Settings, find your webhook and click the `...` menu -> Test
2. Paste the payload above (replace `${}` variables with sample values) and click "Test webhook"
3. Check the GitHub Actions tab — a workflow should run and create an issue

## Files

```
.github/
  PROMOTION_TEMPLATE.md          # Issue template with artifact metadata
  workflows/
    model_promotion_ci_cd.yml    # GitHub Actions workflow triggered by webhook
```

## Extending this pattern

This example creates a GitHub Issue for human review. In production, the same pattern can trigger:

- Model evaluation on a held-out benchmark
- Deployment to a serving endpoint (SageMaker, Vertex AI, etc.)
- Slack/Teams notifications to the ML platform team
- A PR that updates a model config file in a deployment repo

The webhook payload passes all the artifact metadata needed to identify and fetch the model programmatically via the W&B Public API.

## References

- [W&B Automations docs](https://docs.wandb.ai/models/automations)
- [Webhook automations](https://docs.wandb.ai/models/automations/create-automations/webhook)
- [GitHub repository dispatch](https://docs.github.com/en/rest/repos/repos#create-a-repository-dispatch-event)
- [Model CI/CD with W&B (tutorial)](https://wandb.ai/wandb/wandb-model-cicd/reports/Model-CI-CD-with-W-B--Vmlldzo0OTcwNDQw)
