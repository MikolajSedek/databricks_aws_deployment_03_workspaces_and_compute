# Databricks Multi-Workspace and Compute Management - Dev Environment (`environments/dev`)

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5.0-623CE4?logo=terraform)](https://developer.hashicorp.com/terraform/docs)
[![AWS Provider](https://img.shields.io/badge/AWS_Provider-%3E%3D5.0-FF9900?logo=amazon-aws)](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
[![Databricks Provider](https://img.shields.io/badge/Databricks_Provider-%3E%3D1.135.0-FF3621?logo=databricks)](https://registry.terraform.io/providers/databricks/databricks/latest/docs)
[![Time Provider](https://img.shields.io/badge/Time_Provider-%3E%3D0.9.0-623CE4?logo=terraform)](https://registry.terraform.io/providers/hashicorp/time/latest/docs)

---

## 1. Executive Summary

- **Purpose & Scope**:
  This environment orchestrates the complete end-to-end provisioning of dedicated Databricks workspaces and governed compute infrastructure for **Data Engineering**, **Data Science**, and **Data Analytics** personas in the `dev` environment. It builds on the networking foundation established in project `01_setup_vpc_networking` and the account identity governance established in project `02_setup_identity_management`.
- **Problem Statement & Solution**:
  Deploying multiple Databricks workspaces in an enterprise environment requires orchestrating account-level resources (cross-account IAM roles, customer-managed VPC network registration, S3 root storage, KMS customer-managed keys) before workspace-level compute engines can be launched. This environment solves this dependency sequencing by separating deployment into an account-level foundation phase and a workspace-level compute governance phase.
- **Key Business & Security Outcomes**:
  - **AWS & Account Foundation**: Dedicated cross-account IAM role with AWS STS propagation protection, registration of the customer-managed Spoke VPC in Databricks MWS, and encrypted state persistence.
  - **Isolated Storage**: Dedicated Amazon S3 root storage buckets per workspace, each encrypted with an independent customer-managed KMS key and registered with Databricks MWS.
  - **Multi-Workspace Fabric**: Discrete Databricks workspaces for `data_engineering`, `data_science`, and `data_analytics` personas with authoritative access assignments.
  - **Strict Compute Governance**: Enforced cluster policies—including a Platform Admin policy capped at **maximum 25 DBUs/hr** and a Shared Workspace policy capped at **maximum 15 DBUs/hr**—ensuring no unconstrained clusters can be launched.
  - **Configured Workloads**: Automated autoscaling compute clusters and cost-optimized SQL Warehouses orchestrated via a single composite module instantiated per workspace.

---

## 2. General Logic & Operational Flow

### 2.1 Configuration & Dependency Lifecycle

```text
Project 01 (Spoke VPC, Subnets, SG)  ──>  AWS Data Lookups (data.tf)
Project 02 (Account Groups)          ──>  Databricks Data Lookups (data.tf)
                                                │
                                                ▼
         ┌──────────────────────────────────────────────────────────────┐
         │              Phase 1: Foundation (Account Plane)             │
         │  - S3 Backend & KMS Key                                      │
         │  - Cross-Account IAM Role (with 30s sleep)                   │
         │  - Customer-Managed Spoke VPC Network Registration in MWS    │
         │  - Dedicated Workspace KMS Keys & Root S3 Buckets            │
         │  - Generic MWS Workspaces & Group Role Assignments           │
         └──────────────────────────────┬───────────────────────────────┘
                                        │ (Workspace URLs Generated)
                                        ▼
         ┌──────────────────────────────────────────────────────────────┐
         │              Phase 2: Compute Governance (Workspace Plane)   │
         │  Composite Module: 004.workspace_compute (Instantiated 3x)   │
         │  - Compute Policies (Admin <=25 DBU & Shared <=15 DBU)       │
         │  - All-Purpose Compute Clusters (tied to policy IDs)         │
         │  - SQL Warehouses (with inactivity auto-stop)                │
         └──────────────────────────────────────────────────────────────┘
```

### 2.2 Network & Traffic Flow
- **Customer-Managed VPC**: Compute planes reside within the Spoke VPC provisioned in project `01_setup_vpc_networking`.
- **Outbound Egress (Databricks Clusters -> SCC Relay)**:
  `[Databricks Compute Cluster]` $\rightarrow$ `[Private Subnet]` $\rightarrow$ `[AWS Interface VPCE: backend_relay]` $\rightarrow$ `[Databricks Control Plane (Port 6666)]`.
- **REST API Management**:
  `[Terraform / Developer]` $\rightarrow$ `[AWS Interface VPCE: backend_rest]` $\rightarrow$ `[Databricks Control Plane (Port 443)]`.
- **Data Storage**:
  `[Compute Clusters]` $\rightarrow$ `[AWS S3 Root Bucket]` $\rightarrow$ `[SSE-KMS Encryption]`.

---

## 3. Architecture of the Dev Environment

### 3.1 Network Topology & Integration
This environment imports existing network infrastructure provisioned by project `01_setup_vpc_networking`:

| Resource Type | Source | Purpose |
|:---|:---|:---|
| `vpc_id` | `data.aws_vpc.spoke` | Customer-managed Spoke VPC (`Spoke VPC-dev`) |
| `subnet_ids` | `data.aws_subnets.spoke_compute` | Private compute subnets (`spoke-db-private-dev-*`) across AZs |
| `security_group_ids` | `data.aws_security_group.spoke_sg` | Default Spoke cluster security group (`default_spoke_sg-dev`) |

### 3.2 Security, IAM & Encryption Posture
- **Encryption at Rest**:
  - Remote state bucket encrypted with dedicated KMS CMK (`alias/dbx_workspaces_compute_backend_kms_key-dev`).
  - Each workspace has a dedicated KMS CMK (`alias/dbx_de_root_kms-dev`, `alias/dbx_ds_root_kms-dev`, `alias/dbx_da_root_kms-dev`) with automatic annual key rotation and root account delegation.
- **Cross-Account Access**:
  - Dedicated IAM role assumed by Databricks Account (`414351767826`) with conditional External ID verification matching the Databricks Account ID.
  - 30-second sleep buffer to prevent STS eventual consistency race conditions during MWS registration.

---

## 4. Architecture C4 Visualisations

### 4.1 Level 1: System Context Diagram

```mermaid
flowchart TD
    classDef actor fill:#232F3E,stroke:#FF9900,stroke-width:2px,color:#FFFFFF;
    classDef databricks fill:#FF3621,stroke:#B71C1C,stroke-width:2px,color:#FFFFFF;
    classDef aws fill:#1E88E5,stroke:#0D47A1,stroke-width:2px,color:#FFFFFF;
    classDef workspace fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;

    Admin["Platform Administrator"]:::actor
    Users["Data Engineers / Scientists / Analysts"]:::actor

    subgraph DatabricksSaaS ["Databricks E2 SaaS Platform"]
        MWS["Databricks MWS Console"]:::databricks
        CP["Databricks Control Plane (REST & SCC Relay)"]:::databricks
    end

    subgraph AWSAccount ["AWS Account (dev)"]
        subgraph Foundations ["Foundational Infrastructure"]
            IAM["Cross-Account IAM Role"]:::aws
            MWSNet["MWS Customer VPC Network"]:::aws
            S3["Root S3 Buckets & KMS CMKs"]:::aws
        end

        subgraph Workspaces ["Workspaces Fabric"]
            WS_DE["Workspace: Data Engineering"]:::workspace
            WS_DS["Workspace: Data Science"]:::workspace
            WS_DA["Workspace: Data Analytics"]:::workspace
        end
    end

    Admin -->|"MWS Governance"| MWS
    Users -->|"Workspace Analytics"| Workspaces
    MWS -->|"Assumes Role"| IAM
    MWSNet --> Workspaces
    S3 --> Workspaces
    CP <--> Workspaces
```

### 4.2 Level 2: Component Architecture Diagram

```mermaid
flowchart TD
    classDef infra fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef compute fill:#FFF3E0,stroke:#E65100,stroke-width:2px,color:#BF360C;
    classDef policy fill:#F3E5F5,stroke:#4A148C,stroke-width:2px,color:#311B92;

    subgraph DevEnv ["environments/dev"]
        subgraph Stage1Modules ["Stage 1: Foundation Modules"]
            KmsKey["001.kms_key"]:::infra
            CrossAccount["002.cross_account_role"]:::infra
            Networking["006.databricks_mws_networking"]:::infra
            RootBuckets["002.databricks_root_bucket (3x)"]:::infra
            WorkspacesMod["001.generic_workspace (3x)"]:::infra
        end

        subgraph Stage2Modules ["Stage 2: Compute Governance Modules"]
            subgraph CompositeCompute ["004.workspace_compute (Instantiated 3x)"]
                Policies["001.compute_policies"]:::policy
                Clusters["002.all_purpose_cluster"]:::compute
                SQLWarehouses["003.sql_warehouse"]:::compute
            end
        end

        CrossAccount --> WorkspacesMod
        Networking --> WorkspacesMod
        RootBuckets --> WorkspacesMod
        WorkspacesMod -->|"workspace_url"| CompositeCompute
    end
```

---

## 5. Provisioning Sequence & Staged Rollout

Because workspace-scoped providers require live workspace URLs determined during workspace creation, initial deployment follows a two-stage apply sequence:

### Stage 1: Foundation Deployment (Account Plane)
Provisions the state backend, cross-account credentials, customer-managed VPC network registration, root storage, and creates the Databricks workspaces:

```bash
terraform init
terraform apply \
  -target="module.kms_key" \
  -target="module.backend_bucket" \
  -target="module.cross_account_role" \
  -target="module.mws_networking" \
  -target="module.workspace_kms_keys" \
  -target="module.root_buckets" \
  -target="module.workspaces"
```

### Stage 2: Compute & Policies Convergence (Workspace Plane)
Deploys the scoped cluster policies, compute clusters, SQL Warehouses, and object access control lists:

```bash
terraform apply
```

---

## 6. Compute Policy & Workload Governance Matrix

All workspaces deploy the capped **Platform Admin** policy alongside the **Workspace Shared** policy, with clusters and SQL Warehouses tailored to each workload:

| Policy / Workload | Scope / Target Workspace | Core Constraints | Group Permissions |
|:---|:---|:---|:---|
| **Platform Admin Policy** | All Workspaces | **Max 25 DBUs/hr budget cap**, max 4 workers, cost-efficient instance types (`m5.xlarge`, `m5.2xlarge`, `c5.xlarge`, `c5.2xlarge`, `r5.xlarge`, `r5.2xlarge`, `i3.xlarge`, etc.), max 45 min idle timeout | `CAN_USE` for `dbx-platform-admins` |
| **Workspace Shared Policy** | All Workspaces | **Max 15 DBUs/hr budget cap**, auto-scaling 1–4 workers, max 30 min idle timeout | `CAN_USE` for `dbx-platform-admins` & workspace user groups |
| **Data Engineering Compute** | `data_engineering` | ETL cluster (`de-etl-cluster-dev`, 1–3 workers, `m5.xlarge`, `18.x-scala2.13`, 30 min idle timeout) + SQL Warehouse (`de-sql-warehouse-dev`, `2X-Small`, 15 min auto-stop) | `CAN_RESTART`/`CAN_USE` for `dbx-data-engineers` |
| **Data Science Compute** | `data_science` | ML cluster (`ds-ml-cluster-dev`, 1–2 workers, `m5.xlarge`, ML runtime `18.x-cpu-ml-scala2.13`, 20 min idle timeout) | `CAN_RESTART` for `dbx-data-scientists` |
| **Data Analytics Compute** | `data_analytics` | BI SQL Warehouse (`da-bi-warehouse-dev`, `X-Small`, 10 min auto-stop) | `CAN_USE` for `dbx-data-analysts` |

---

## 7. Module Inventory & References

- [`02.security/001.kms_key`](file:///modules/02.security/001.kms_key): Customer-managed KMS key for state and root storage encryption.
- [`02.security/002.cross_account_role`](file:///modules/02.security/002.cross_account_role): Databricks AWS cross-account role using official assume and cross-account policies with STS propagation protection.
- [`01.networking/006.databricks_mws_networking`](file:///modules/01.networking/006.databricks_mws_networking): Customer-managed VPC network registration in Databricks Account MWS.
- [`03.storage/001.env_backend_bucket`](file:///modules/03.storage/001.env_backend_bucket): Secure S3 remote state storage bucket.
- [`03.storage/002.databricks_root_bucket`](file:///modules/03.storage/002.databricks_root_bucket): S3 root storage bucket using `databricks_aws_bucket_policy`, dynamic KMS grants, and MWS storage config.
- [`04.workspaces/001.generic_workspace`](file:///modules/04.workspaces/001.generic_workspace): Generic workspace creation and account group permission assignments.
- [`05.compute/001.compute_policies`](file:///modules/05.compute/001.compute_policies): Granular compute policies and policy ACLs.
- [`05.compute/002.all_purpose_cluster`](file:///modules/05.compute/002.all_purpose_cluster): Policy-enforced autoscaling clusters.
- [`05.compute/003.sql_warehouse`](file:///modules/05.compute/003.sql_warehouse): Auto-stopping BI SQL Warehouses.
- [`05.compute/004.workspace_compute`](file:///modules/05.compute/004.workspace_compute): Composite workspace compute module unifying policies, clusters, and warehouses into a single instantiation.
- [Terraform Documentation Interface (`TERRAFORM.md`)](./TERRAFORM.md): Machine-generated documentation of all inputs and provider dependencies (no public outputs exposed).
