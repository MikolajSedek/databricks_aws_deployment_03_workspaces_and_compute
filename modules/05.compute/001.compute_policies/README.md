# Databricks Compute Cluster Policies Module (`001.compute_policies`)

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5.0-623CE4?logo=terraform)](https://developer.hashicorp.com/terraform/docs)
[![Databricks Provider](https://img.shields.io/badge/Databricks_Provider-%3E%3D1.135.0-FF3621?logo=databricks)](https://registry.terraform.io/providers/databricks/databricks/latest/docs)

---

## 1. Executive Summary

- **Purpose & Scope**:
  This module provisions role-based Databricks Cluster Policies (`databricks_cluster_policy`) and binds granular access permissions (`databricks_permissions`) granting `CAN_USE` to authorized groups. It enforces strict architectural and financial constraints across all compute workloads, featuring a hard **10 DBU/hour budget cap** on platform administrator compute, alongside persona policies for Data Engineering, Data Science, and Data Analytics.
- **Problem Statement & Solution**:
  Without cluster policies, users can launch oversized instances (such as GPU nodes for basic SQL queries), omit auto-termination timeouts, or exceed enterprise infrastructure budgets. This module prevents compute sprawl by enforcing JSON policy definitions that restrict allowable instance types, enforce mandatory autotermination, cap worker autoscaling limits, and restrict cluster creation permissions.
- **Key Business & Security Outcomes**:
  - **Financial Guardrails**: A hard limit of 10 DBUs/hour on Platform Admin clusters prevents accidental high-cost compute operations.
  - **Persona Tailoring**: Specialized policies tailored to ETL pipelines (autoscale 1–4, Photon-ready), Machine Learning (single-user security mode, GPU/CPU allowlist), and Ad-hoc Analytics (strictly single-node, directing heavy BI to SQL Warehouses).
  - **Role-Based Access Control**: Binds `CAN_USE` permissions to specific persona groups and administrators, ensuring users only launch approved cluster configurations.

---

## 2. General Logic & Operational Flow

### 2.1 Governance Matrix & Constraints

| Policy Name | Target Group | Node Type Allowlist | Worker Limits | Max Inactivity Timeout | Key Security / Profile Constraints |
|:---|:---|:---|:---:|:---:|:---|
| **Platform Admin** | `admin_group_name` | `m5.large`, `m5.xlarge`, `c5.xlarge` | Max 4 workers | 45 minutes | **Max 10 DBUs/hr** (`dbus_per_hour` range cap) |
| **Data Engineering** | `data_engineers_group_name` | `m5.large`, `m5.xlarge`, `i3.xlarge` | Autoscale 1–4 workers | 30 minutes | Storage-optimized instances for ETL |
| **Data Science** | `data_scientists_group_name` | `m5.large`, `m5.xlarge`, `g4dn.xlarge` | Autoscale 1–2 workers | 25 minutes | `data_security_mode = "SINGLE_USER"`, GPU support |
| **Data Analytics** | `data_analysts_group_name` | `m5.large` | **0 workers (Single Node)** | 15 minutes | `spark.databricks.cluster.profile = "singleNode"` |

### 2.2 Provisioning Lifecycle
1. **Admin Policy Creation**: Provisions `databricks_cluster_policy.admin_policy` with the 10 DBU cap and assigns `CAN_USE` to `var.admin_group_name`.
2. **Data Engineering Policy**: If `var.data_engineers_group_name` is provided, provisions `databricks_cluster_policy.data_engineers` and attaches dual permissions (admin + DE group).
3. **Data Science Policy**: If `var.data_scientists_group_name` is provided, provisions `databricks_cluster_policy.data_scientists` and attaches dual permissions (admin + DS group).
4. **Data Analytics Policy**: If `var.data_analysts_group_name` is provided, provisions `databricks_cluster_policy.data_analysts` and attaches dual permissions (admin + DA group).
5. **Policy ID Mapping**: Exposes a map of policy IDs (`policy_ids`) for downstream cluster binding.

---

## 3. Architecture of the Module

### 3.1 Resource Architecture & Attributes

| Resource Identifier | Resource Type | Description |
|:---|:---|:---|
| `databricks_cluster_policy.admin_policy` | `databricks_cluster_policy` | Capped policy enforcing max 10 DBUs/hr budget cap |
| `databricks_permissions.admin_policy` | `databricks_permissions` | Grants `CAN_USE` to the platform admin group |
| `databricks_cluster_policy.data_engineers` | `databricks_cluster_policy` | ETL cluster policy supporting autoscaling 1–4 nodes |
| `databricks_permissions.data_engineers` | `databricks_permissions` | Grants `CAN_USE` to admins and data engineers |
| `databricks_cluster_policy.data_scientists` | `databricks_cluster_policy` | ML policy enforcing Single-User mode and GPU allowlist |
| `databricks_permissions.data_scientists` | `databricks_permissions` | Grants `CAN_USE` to admins and data scientists |
| `databricks_cluster_policy.data_analysts` | `databricks_cluster_policy` | Single-node ad-hoc analytics policy |
| `databricks_permissions.data_analysts` | `databricks_permissions` | Grants `CAN_USE` to admins and data analysts |

---

## 4. Architecture C4 Visualisation

### 4.1 Level 2: Component Architecture Diagram

```mermaid
flowchart TD
    classDef input fill:#ECEFF1,stroke:#37474F,stroke-width:2px,color:#212121;
    classDef policy fill:#F3E5F5,stroke:#4A148C,stroke-width:2px,color:#311B92;
    classDef acl fill:#E8EAF6,stroke:#283593,stroke-width:2px,color:#1A237E;
    classDef out fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;

    Inputs["Inputs: admin_group_name, persona_group_name"]:::input

    subgraph Policies ["Cluster Policies"]
        AdminPol["Admin Policy (Max 10 DBU)"]:::policy
        DEPol["Data Engineering Policy (Autoscale 1-4)"]:::policy
        DSPol["Data Science Policy (Single User / ML)"]:::policy
        DAPol["Data Analytics Policy (Single Node)"]:::policy
    end

    subgraph ACLs ["Policy Access Permissions (CAN_USE)"]
        AdminACL["databricks_permissions.admin_policy"]:::acl
        DEACL["databricks_permissions.data_engineers"]:::acl
        DSACL["databricks_permissions.data_scientists"]:::acl
        DAACL["databricks_permissions.data_analysts"]:::acl

        AdminPol --> AdminACL
        DEPol --> DEACL
        DSPol --> DSACL
        DAPol --> DAACL
    end

    OutMap["Output: policy_ids map"]:::out

    Inputs --> Policies
    Policies --> OutMap
```

---

## 5. Terraform Documentation Interface

> [!NOTE]
> Machine-generated interface specifications for this module are maintained by `terraform-docs` in [`TERRAFORM.md`](./TERRAFORM.md).

### 5.1 Essential Inputs Summary

| Variable | Type | Description | Required |
|:---|:---:|:---|:---:|
| `admin_group_name` | `string` | Name of the platform admin group granted policy access | Yes |
| `data_engineers_group_name` | `string` | Name of the data engineers group | No |
| `data_scientists_group_name` | `string` | Name of the data scientists group | No |
| `data_analysts_group_name` | `string` | Name of the data analysts group | No |

### 5.2 Essential Outputs Summary

| Output | Type | Description |
|:---|:---:|:---|
| `policy_ids` | `map(string)` | Map of policy keys (`admin`, `data_engineers`, `data_scientists`, `data_analysts`) to their created policy IDs |

---

## 6. Important Links and References

- [Databricks Cluster Policy Reference](https://docs.databricks.com/aws/en/admin/clusters/policies)
- [Databricks Cluster Policy Resource Documentation](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy)
- [Databricks Permissions Resource Documentation](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions)
- [Terraform Documentation Interface (`TERRAFORM.md`)](./TERRAFORM.md)
