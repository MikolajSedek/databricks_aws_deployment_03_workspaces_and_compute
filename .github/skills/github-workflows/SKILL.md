---
name: github-workflows
description: "Authoritative skill, best practices, and production patterns for architecting, authoring, securing, and testing GitHub Actions CI/CD workflows for Terraform, AWS, and Databricks deployments."
compatibility: "GitHub Actions runners (ubuntu-latest, self-hosted), Actions v4+, reusable workflows, OIDC, GitHub Environments"
metadata:
  version: "1.0.0"
---

# GitHub Actions CI/CD Workflows for Cloud & Terraform Infrastructure

This skill provides authoritative guidelines, architectural patterns, and production recipes for authoring, securing, and maintaining **GitHub Actions CI/CD Workflows** for Terraform-based cloud infrastructure (AWS and Databricks).

---

## 1. Authoritative Sources of Truth

Every workflow, step definition, and security posture must be grounded in these authoritative references:

- **Official GitHub Actions Documentation**:
  [GitHub Actions Documentation](https://docs.github.com/en/actions)
  *Definitive guide for workflow syntax, runner execution environments, reusable workflows (`workflow_call`), matrix builds, and expressions.*
- **GitHub Security & Hardening Guide**:
  [Security Hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
  *Official best practices for token permissions (`GITHUB_TOKEN`), script injection defense, OpenID Connect (OIDC), and secret protection.*
- **HashiCorp Setup Terraform Action**:
  [hashicorp/setup-terraform](https://github.com/hashicorp/setup-terraform)
  *Official action for installing and configuring Terraform CLI binaries on runners.*
- **AWS Configure AWS Credentials Action**:
  [aws-actions/configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials)
  *Official action for authenticating GitHub runners to AWS using IAM access keys or OpenID Connect (OIDC) role federation.*
- **Astral Setup uv Action**:
  [astral-sh/setup-uv](https://github.com/astral-sh/setup-uv)
  *Official high-performance Python package installer action with built-in virtual environment and lockfile caching.*
- **TFLint GitHub Action**:
  [terraform-linters/setup-tflint](https://github.com/terraform-linters/setup-tflint)
  *Official installer action for the TFLint Terraform linter and plugin ecosystem.*
- **Aqua Security Setup Trivy Action**:
  [aquasecurity/setup-trivy](https://github.com/aquasecurity/setup-trivy)
  *Official installer for the Trivy security scanner.*
- **Databricks Terraform Provider Documentation**:
  [Databricks Terraform Registry Docs](https://registry.terraform.io/providers/databricks/databricks/latest/docs)
  *Authoritative specification for OAuth M2M Service Principal authentication in automated pipelines.*

---

## 2. Core CI/CD Architectural Patterns

### 2.1 Reusable Modular Workflows (`workflow_call`)
Separate concerns by decomposing pipelines into reusable sub-workflows (`workflow_call`) coordinated by root orchestrator workflows (`push`, `pull_request`, `workflow_dispatch`):

```
.github/workflows/
├── deploy-dev.yml              # Root Orchestrator (Coordinates stages for 'dev')
├── deploy-dev-stage1.yml       # Standalone Orchestrator (Stage 1 only)
├── deploy-dev-stage2.yml       # Standalone Orchestrator (Stage 2 only)
├── dpl-01-precommit.yml        # Reusable: Linting, hygiene, security scanning
├── dpl-02-plan-stage1.yml      # Reusable: Targeted foundation plan
├── dpl-03-apply-stage1.yml     # Reusable: Environment-gated foundation apply
├── dpl-04-plan-stage2.yml      # Reusable: Full workspace compute plan
├── dpl-05-apply-stage2.yml     # Reusable: Environment-gated compute apply
└── README.md                   # Comprehensive pipeline documentation
```

### 2.2 Shift-Left Quality & Security Gate
Never run `terraform plan` or cloud API calls before code passes static analysis:
1. Syntax formatting (`terraform fmt -check -recursive`).
2. General hygiene (`trailing-whitespace`, `end-of-file-fixer`, `check-yaml`, `check-json`).
3. Secret scanning (`gitleaks`, `detect-aws-credentials`).
4. Terraform linting (`tflint --init --config .tflint.hcl`).
5. Security misconfiguration scanning (`trivy` or `checkov`).

### 2.3 Speculative Planning vs. Gated Deployment
- **Plan on Every Commit**: Execute speculative plans (`terraform plan`) on every push to any branch and on pull requests targeting `main`.
- **Apply Strictly Gated on `main`**: Restrict `terraform apply` executions solely to the default branch (`main`) or explicit authorized dispatches.
- **Plan Immutability**: Always store the speculative execution plan as an encrypted binary artifact (`tfplan` via `actions/upload-artifact`). The apply job must download and execute this exact binary file without re-evaluating interpolations (`terraform apply tfplan`).

### 2.4 Two-Stage Deployment Pattern (Handling Provider Dependencies)
When Terraform provider blocks depend on resource outputs created in the same root module (e.g. Databricks workspace-scoped providers depending on `module.workspaces["..."].workspace_url`):
- **Stage 1 (Account Plane Foundation)**: Plan and apply with explicit `-target` flags for backend storage, IAM roles, networking, and workspace resources.
- **Stage 2 (Workspace Plane Compute & Governance)**: Plan and apply the full project, which connects to the live workspace URLs stored in the remote state.

---

## 3. Security, Permissions & Identity Standards

### 3.1 Principle of Least Privilege for `GITHUB_TOKEN`
Always declare minimal explicit permissions at the top of every workflow:

```yaml
permissions:
  contents: read          # Minimal permission to checkout repository code
  id-token: write         # Required for AWS OIDC authentication
  pull-requests: write    # Required for posting plan summaries to PRs
```

### 3.2 Dual-Cloud Authentication Guardrails

#### AWS Authentication Pattern
Always use `aws-actions/configure-aws-credentials` and write standard CLI profile configuration files to satisfy the AWS Go SDK and Terraform S3 backend:

```yaml
- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v6
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-session-token: ${{ secrets.AWS_SESSION_TOKEN }}
    aws-region: ${{ env.AWS_REGION }}
    aws-profile: ${{ env.AWS_PROFILE }}
    overwrite-aws-profile: true

- name: Ensure AWS Shared Profile Files
  run: |
    mkdir -p ~/.aws
    cat << EOF > ~/.aws/config
    [default]
    region = ${{ env.AWS_REGION }}
    output = json

    [profile ${{ env.AWS_PROFILE }}]
    region = ${{ env.AWS_REGION }}
    output = json
    EOF
    if [ -n "${{ secrets.AWS_PROFILE_ROLE_ARN }}" ]; then
      cat << EOF >> ~/.aws/config
    role_arn = ${{ secrets.AWS_PROFILE_ROLE_ARN }}
    source_profile = default
    EOF
    fi
```

#### Databricks OAuth Service Principal Authentication Pattern
Inject credentials via both native `DATABRICKS_*` environment variables and Terraform `TF_VAR_*` definitions:

```yaml
env:
  TF_VAR_databricks_account_id: ${{ secrets.DATABRICKS_ACCOUNT_ID }}
  TF_VAR_service_principal_id: ${{ secrets.DATABRICKS_CLIENT_ID || secrets.DATABRICKS_SERVICE_PRINCIPAL_ID }}
  TF_VAR_service_principal_secret: ${{ secrets.DATABRICKS_CLIENT_SECRET || secrets.DATABRICKS_SERVICE_PRINCIPAL_SECRET }}
  DATABRICKS_HOST: 'https://accounts.cloud.databricks.com'
  DATABRICKS_ACCOUNT_ID: ${{ secrets.DATABRICKS_ACCOUNT_ID }}
  DATABRICKS_CLIENT_ID: ${{ secrets.DATABRICKS_CLIENT_ID || secrets.DATABRICKS_SERVICE_PRINCIPAL_ID }}
  DATABRICKS_CLIENT_SECRET: ${{ secrets.DATABRICKS_CLIENT_SECRET || secrets.DATABRICKS_SERVICE_PRINCIPAL_SECRET }}
```

### 3.3 GitHub Environments for Manual Approvals
Protect all apply jobs with GitHub Environments:
```yaml
jobs:
  apply:
    runs-on: ubuntu-latest
    environment: dev    # Configured with Required Reviewers in GitHub UI
```

---

## 4. Multi-Layer Performance Caching

To keep CI/CD execution times fast and predictable, implement 4-layer caching:

### Layer 1: Python & Pre-commit (`astral-sh/setup-uv`)
```yaml
- name: Setup uv
  uses: astral-sh/setup-uv@v9.0.0
  with:
    enable-cache: true
    cache-dependency-glob: 'uv.lock'
```

### Layer 2: Pre-commit Hook Virtual Environments
```yaml
- name: Cache Pre-commit Environments
  uses: actions/cache@v6
  with:
    path: ~/.cache/pre-commit
    key: pre-commit-${{ runner.os }}-${{ hashFiles('.pre-commit-config.yaml') }}
    restore-keys: |
      pre-commit-${{ runner.os }}-
```

### Layer 3: TFLint Plugins
```yaml
- name: Cache TFLint Plugins
  uses: actions/cache@v6
  with:
    path: ~/.tflint.d/plugins
    key: tflint-${{ runner.os }}-${{ hashFiles('.tflint.hcl') }}
    restore-keys: |
      tflint-${{ runner.os }}-
```

### Layer 4: Terraform Provider Cache
```yaml
- name: Cache Terraform Providers
  uses: actions/cache@v6
  with:
    path: ${{ env.TF_WORKING_DIR }}/.terraform
    key: terraform-${{ runner.os }}-${{ hashFiles(format('{0}/.terraform.lock.hcl', env.TF_WORKING_DIR)) }}
    restore-keys: |
      terraform-${{ runner.os }}-
```

---

## 5. Standard Step Summary Reporting

Always publish actionable plan results to `$GITHUB_STEP_SUMMARY` so reviewers can inspect changes directly in the GitHub UI:

```yaml
- name: Add Plan Summary to Job Summary
  run: |
    echo "### Terraform Plan Summary (\`${{ inputs.environment }}\` - ${{ inputs.stage_name }})" >> $GITHUB_STEP_SUMMARY
    echo '```terraform' >> $GITHUB_STEP_SUMMARY
    cat tfplan.txt | tail -n 50 >> $GITHUB_STEP_SUMMARY
    echo '```' >> $GITHUB_STEP_SUMMARY
```

---

## 6. Operational Guardrails & Anti-Patterns

| Anti-Pattern | Why It Fails | Recommended Production Solution |
|:---|:---|:---|
| Running `terraform apply` without an existing `tfplan` | Evaluates dynamic values again, causing drift between review and apply | Plan with `-out=tfplan`, upload artifact, and run `terraform apply tfplan` |
| Running `terraform-docs` during CI | Modifies `TERRAFORM.md` during CI, causing git diff or dirty workspace errors | Set `SKIP: 'terraform_docs,terraform-docs'` during CI pre-commit runs |
| Blank `role_arn = ` in `~/.aws/config` | AWS Go SDK throws `SharedConfigEmptyRoleARNErr` | Conditionally append `role_arn` only if secret is non-empty |
| Single-stage apply on Databricks workspaces | Workspace-scoped provider fails with empty host during plan | Use Two-Stage Deployment (Stage 1 targets workspaces; Stage 2 converges compute) |
| Hardcoding credentials in workflow files | Severe credential leak risk | Pass via `${{ secrets.* }}` into environment variables |
| Allowing apply on unreviewed feature branches | Accidental resource modifications or outages | Restrict apply to `main` and gate behind GitHub Environment approvals |
