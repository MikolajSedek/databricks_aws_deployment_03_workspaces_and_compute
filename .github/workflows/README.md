# GitHub Actions CI/CD & Two-Stage Deployment Workflows

[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI%2FCD-2088FF?logo=github-actions)](https://docs.github.com/en/actions)
[![Terraform](https://img.shields.io/badge/Terraform-1.16.3-623CE4?logo=terraform)](https://developer.hashicorp.com/terraform/docs)
[![AWS Provider](https://img.shields.io/badge/AWS_Provider-6.66.0-FF9900?logo=amazon-aws)](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
[![Databricks Provider](https://img.shields.io/badge/Databricks_Provider-1.135.0-FF3621?logo=databricks)](https://registry.terraform.io/providers/databricks/databricks/latest/docs)
[![Astral uv](https://img.shields.io/badge/uv-Package_Manager-DE5FE9?logo=python)](https://github.com/astral-sh/uv)

---

## 1. Executive Summary

- **Purpose & Scope**:
  This directory contains the GitHub Actions automation pipelines powering continuous integration, automated validation, and continuous delivery for **Databricks Workspaces and Compute Management** on AWS. It implements an enterprise multi-tier workflow model ensuring all commits across all branches are validated and planned, while infrastructure deployments (`apply`) execute sequentially in two stages restricted to the `main` branch under manual GitHub Environment approvals.
- **Problem Statement & Staged Deployment Justification**:
  Workspace-scoped Terraform providers (`workspace_de`, `workspace_ds`, `workspace_da`) require live workspace URLs (`https://<workspace-id>.cloud.databricks.com`) generated during workspace creation. In a single-stage greenfield apply, Terraform cannot configure workspace-level providers because workspace URLs do not exist yet. As defined in Section 6 of the root [`README.md`](../../README.md), deployment is architected as an automated **Two-Stage Apply**:
  - **Stage 1 (Foundation - Account Plane)**: Provisions the S3 state backend, cross-account IAM role, Databricks MWS network registration with PrivateLink VPC endpoints, dedicated KMS keys, root storage buckets, and initializes the generic Databricks E2 Workspaces.
  - **Stage 2 (Compute & Governance Convergence - Workspace Plane)**: Connects to the newly provisioned workspace URLs and deploys scoped compute policies, autoscaled all-purpose clusters, and cost-optimized SQL Warehouses.
- **Two Plans and Two Apply Runs**:
  To guarantee operational stability, the repository provides dedicated workflows for each phase:
  1. **Stage 1**: [`dpl-02-plan-stage1.yml`](./dpl-02-plan-stage1.yml) $\rightarrow$ [`dpl-03-apply-stage1.yml`](./dpl-03-apply-stage1.yml) (or standalone [`deploy-dev-stage1.yml`](./deploy-dev-stage1.yml)).
  2. **Stage 2**: [`dpl-04-plan-stage2.yml`](./dpl-04-plan-stage2.yml) $\rightarrow$ [`dpl-05-apply-stage2.yml`](./dpl-05-apply-stage2.yml) (or standalone [`deploy-dev-stage2.yml`](./deploy-dev-stage2.yml)).
  3. **Unified Pipeline**: [`deploy-dev.yml`](./deploy-dev.yml) runs both stages sequentially with manual review checkpoints between phases.

---

## 2. Workflow Orchestration & Operational Flow

### 2.1 Pipeline Lifecycle & Stages

```mermaid
flowchart TD
    classDef trigger fill:#ECEFF1,stroke:#455A64,stroke-width:1.5px,color:#263238;
    classDef stage fill:#E1F5FE,stroke:#0288D1,stroke-width:1.5px,color:#01579B;
    classDef gate fill:#FFF3E0,stroke:#E65100,stroke-width:1.5px,color:#BF360C;
    classDef finish fill:#E8F5E9,stroke:#2E7D32,stroke-width:1.5px,color:#1B5E20;

    Trigger["Push (All Branches) / PR (main) / Dispatch"]:::trigger
    Precommit["Step 0: Pre-commit Quality & Security Checks<br/>(Formatting, TFLint, Gitleaks, Trivy)"]:::stage

    subgraph Stage1Flow ["Stage 1: Foundation Deployment (Account Plane)"]
        S1Plan["dpl-02-plan-stage1.yml<br/>(Targeted Plan: KMS, IAM, MWS, Workspaces)"]:::stage
        S1Gate["Environment Gate: dev<br/>(Stage 1 Approval)"]:::gate
        S1Apply["dpl-03-apply-stage1.yml<br/>(Workspaces & URLs Provisioned)"]:::stage
    end

    subgraph Stage2Flow ["Stage 2: Compute & Governance (Workspace Plane)"]
        S2Plan["dpl-04-plan-stage2.yml<br/>(Full Plan: Policies, Clusters, Warehouses)"]:::stage
        S2Gate["Environment Gate: dev<br/>(Stage 2 Approval)"]:::gate
        S2Apply["dpl-05-apply-stage2.yml<br/>(Compute Convergence Complete)"]:::stage
    end

    Done["Deployment Complete"]:::finish

    Trigger --> Precommit
    Precommit --> S1Plan
    S1Plan -->|"dev-stage1-tfplan"| S1Gate
    S1Gate -->|"Approved (main branch)"| S1Apply
    S1Apply -->|"Live URLs in Remote State"| S2Plan
    S1Plan -.->|"On PR: Speculative Full Plan"| S2Plan
    S2Plan -->|"dev-stage2-tfplan"| S2Gate
    S2Gate -->|"Approved (main branch)"| S2Apply
    S2Apply --> Done
```

### 2.2 Stage 1 vs. Stage 2 Targeted Scope

| Stage | Target Plane | Targeted Modules / Scope | Pipeline Workflow | Plan Artifact Name |
|:---|:---:|:---|:---|:---:|
| **Stage 1** | Account Plane | `module.kms_key`, `module.backend_bucket`, `module.cross_account_role`, `module.mws_networking`, `module.workspace_kms_keys`, `module.root_buckets`, `module.workspaces` | [`dpl-02-plan-stage1.yml`](./dpl-02-plan-stage1.yml) $\rightarrow$ [`dpl-03-apply-stage1.yml`](./dpl-03-apply-stage1.yml) | `dev-stage1-tfplan` |
| **Stage 2** | Workspace Plane | Full convergence: `module.compute_data_engineering`, `module.compute_data_science`, `module.compute_data_analytics` (policies, clusters, SQL warehouses) | [`dpl-04-plan-stage2.yml`](./dpl-04-plan-stage2.yml) $\rightarrow$ [`dpl-05-apply-stage2.yml`](./dpl-05-apply-stage2.yml) | `dev-stage2-tfplan` |

### 2.3 Trigger & Branching Strategy

| Event | Target Branches | Workflow | Plan Phase | Apply Phase |
|:---|:---:|:---|:---:|:---:|
| `push` | Any branch (`**`) | `deploy-dev.yml` | Runs Stage 1 Plan & Stage 2 Plan | **No** (Skipped on feature branches; executes on `main` under approval gates) |
| `pull_request` | `main` | `deploy-dev.yml` | Runs Stage 1 Plan & Stage 2 Plan (summaries attached to PR) | **No** (Plan only; apply runs upon PR merge to `main`) |
| `workflow_dispatch` | Selected branch | `deploy-dev-stage1.yml` | Runs Stage 1 Plan | Runs Stage 1 Apply on `main` (gated by Environment Approval) |
| `workflow_dispatch` | Selected branch | `deploy-dev-stage2.yml` | Runs Stage 2 Plan | Runs Stage 2 Apply on `main` (gated by Environment Approval) |
| `workflow_dispatch` | Selected branch | `deploy-dev.yml` | Configurable (`all`, `stage1`, `stage2`) | Runs requested stage apply on `main` (gated by Environment Approval) |

---

## 3. Workflow Architecture & Reusable Modules

```mermaid
graph TD
    classDef root fill:#ECEFF1,stroke:#37474F,stroke-width:2px,color:#212121;
    classDef subwf fill:#E8F5E9,stroke:#2E7D32,stroke-width:1.5px,color:#1B5E20;

    DeployDev["<b>deploy-dev.yml</b><br/>(Root Two-Stage Orchestrator)"]:::root
    DeployS1["<b>deploy-dev-stage1.yml</b><br/>(Stage 1 Standalone Run)"]:::root
    DeployS2["<b>deploy-dev-stage2.yml</b><br/>(Stage 2 Standalone Run)"]:::root

    Precommit["<b>dpl-01-precommit.yml</b><br/>(Quality & Security Checks)"]:::subwf
    PlanS1["<b>dpl-02-plan-stage1.yml</b><br/>(Stage 1 Targeted Plan)"]:::subwf
    ApplyS1["<b>dpl-03-apply-stage1.yml</b><br/>(Stage 1 Apply)"]:::subwf
    PlanS2["<b>dpl-04-plan-stage2.yml</b><br/>(Stage 2 Full Plan)"]:::subwf
    ApplyS2["<b>dpl-05-apply-stage2.yml</b><br/>(Stage 2 Apply)"]:::subwf

    DeployDev -->|"job: precommit"| Precommit
    DeployDev -->|"job: stage1_plan"| PlanS1
    DeployDev -->|"job: stage1_apply"| ApplyS1
    DeployDev -->|"job: stage2_plan"| PlanS2
    DeployDev -->|"job: stage2_apply"| ApplyS2

    DeployS1 -->|"job: precommit"| Precommit
    DeployS1 -->|"job: plan_stage1"| PlanS1
    DeployS1 -->|"job: apply_stage1"| ApplyS1

    DeployS2 -->|"job: precommit"| Precommit
    DeployS2 -->|"job: plan_stage2"| PlanS2
    DeployS2 -->|"job: apply_stage2"| ApplyS2
```

---

## 4. Workflow Inventory

| Workflow File | Trigger Type | Primary Role | Key Inputs / Defaults |
|:---|:---:|:---|:---|
| [`deploy-dev.yml`](./deploy-dev.yml) | `push`, `pull_request`, `workflow_dispatch` | Unified pipeline coordinating Stage 1 and Stage 2 sequentially | `stage: all` (`all`, `stage1`, `stage2`), `auto_apply: false` |
| [`deploy-dev-stage1.yml`](./deploy-dev-stage1.yml) | `workflow_dispatch` | Dedicated standalone run for Stage 1 (Foundation) | `auto_apply: false` |
| [`deploy-dev-stage2.yml`](./deploy-dev-stage2.yml) | `workflow_dispatch` | Dedicated standalone run for Stage 2 (Compute & Governance) | `auto_apply: false` |
| [`dpl-01-precommit.yml`](./dpl-01-precommit.yml) | `workflow_call` | Runs linting, syntax formatting, and multi-engine security scans | `terraform_version: 1.16.3`, `tflint_version: latest`, `trivy_version: latest` |
| [`dpl-02-plan-stage1.yml`](./dpl-02-plan-stage1.yml) | `workflow_call` | Validates configuration, runs targeted Stage 1 `terraform plan`, and uploads artifact | `working_directory: environments/dev`, `environment: dev`, `plan_artifact_name: dev-stage1-tfplan` |
| [`dpl-03-apply-stage1.yml`](./dpl-03-apply-stage1.yml) | `workflow_call` | Downloads Stage 1 plan artifact and executes `terraform apply` under environment gates | `working_directory: environments/dev`, `environment: dev`, `plan_artifact_name: dev-stage1-tfplan` |
| [`dpl-04-plan-stage2.yml`](./dpl-04-plan-stage2.yml) | `workflow_call` | Validates configuration, runs full Stage 2 `terraform plan`, and uploads artifact | `working_directory: environments/dev`, `environment: dev`, `plan_artifact_name: dev-stage2-tfplan` |
| [`dpl-05-apply-stage2.yml`](./dpl-05-apply-stage2.yml) | `workflow_call` | Downloads Stage 2 plan artifact and executes `terraform apply` under environment gates | `working_directory: environments/dev`, `environment: dev`, `plan_artifact_name: dev-stage2-tfplan` |

---

## 5. Required Secrets and Variables

Configure the following secrets in GitHub (**Settings** $\rightarrow$ **Secrets and variables** $\rightarrow$ **Actions**):

### 5.1 AWS Infrastructure Secrets

| Secret Name | Required | Description | Example / Format |
|:---|:---:|:---|:---|
| `AWS_ACCESS_KEY_ID` | **Yes** | AWS IAM User access key ID for deployment automation | `AKIAIOSFODNN7EXAMPLE` |
| `AWS_SECRET_ACCESS_KEY` | **Yes** | AWS IAM User secret access key | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `AWS_SESSION_TOKEN` | Optional | Session token when using temporary AWS STS credentials | `AQoDYXdzEJr...` |
| `AWS_ACCOUNT_ID` | **Yes** | 12-digit target AWS Account ID (enforces account guardrail) | `419259485595` |
| `AWS_REGION` | Optional | Target AWS deployment region (defaults to `eu-central-1`) | `eu-central-1` |
| `AWS_PROFILE_ROLE_ARN` | Optional | IAM Role ARN to assume for the `production-admin` profile | `arn:aws:iam::419259485595:role/TerraformDeploymentRole` |

### 5.2 Databricks Platform Secrets

| Secret Name | Required | Description | Example / Format |
|:---|:---:|:---|:---|
| `DATABRICKS_ACCOUNT_ID` | **Yes** | Databricks Account ID (UUID format) from Account Console | `1980a5a1-023b-4929-9d42-9bc0f468d719` |
| `DATABRICKS_CLIENT_ID` | **Yes** | OAuth Service Principal Client ID with Account Admin privileges | `b6dd846d-1567-469e-a05b-b99eaf76de93` |
| `DATABRICKS_CLIENT_SECRET` | **Yes** | OAuth Service Principal Secret | Sensitive OAuth secret string |

> [!NOTE]
> The workflows also support `DATABRICKS_SERVICE_PRINCIPAL_ID` and `DATABRICKS_SERVICE_PRINCIPAL_SECRET` as alternative secret names.

### 5.3 GitHub Environment Configuration

To enable manual review protection before applying changes to AWS and Databricks:
1. Navigate to **Settings** $\rightarrow$ **Environments** in your GitHub repository.
2. Click **New environment** and enter name: `dev`.
3. Under **Deployment protection rules**, enable **Required reviewers** and assign designated platform engineers / reviewers.
4. (Optional) Under **Deployment branches**, restrict deployment to `main` only.

---

## 6. Important Links and Resources

### 6.1 Authoritative Documentation
- [GitHub Actions Documentation](https://docs.github.com/en/actions) - Official GitHub Actions documentation.
- [HashiCorp Setup Terraform Action](https://github.com/hashicorp/setup-terraform) - Official Terraform installer action.
- [AWS Configure AWS Credentials Action](https://github.com/aws-actions/configure-aws-credentials) - Official AWS credential provider action.
- [Astral Setup uv Action](https://github.com/astral-sh/setup-uv) - Python package and tool installer action.
- [TFLint GitHub Action](https://github.com/terraform-linters/setup-tflint) - TFLint installer action.
- [Aqua Security Setup Trivy Action](https://github.com/aquasecurity/setup-trivy) - Trivy security scanner action.
- [Databricks Terraform Provider Documentation](https://registry.terraform.io/providers/databricks/databricks/latest/docs) - Databricks provider schema reference.

### 6.2 Internal References
- [Root Two-Stage Deployment Pipeline](./deploy-dev.yml)
- [Stage 1 Deployment Pipeline](./deploy-dev-stage1.yml)
- [Stage 2 Deployment Pipeline](./deploy-dev-stage2.yml)
- [Pre-commit Quality & Security Workflow](./dpl-01-precommit.yml)
- [Stage 1 Plan Workflow](./dpl-02-plan-stage1.yml)
- [Stage 1 Apply Workflow](./dpl-03-apply-stage1.yml)
- [Stage 2 Plan Workflow](./dpl-04-plan-stage2.yml)
- [Stage 2 Apply Workflow](./dpl-05-apply-stage2.yml)
- [Root Staged Deployment Runbook](../../README.md#6-staged-deployment-runbook)
- [Dev Environment Terraform Code](../../environments/dev)
- [Project Instructions & Source of Truth](../../.ai/instructions.md)
