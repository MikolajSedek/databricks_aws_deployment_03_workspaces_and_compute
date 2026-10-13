# Databricks Workspace Compute Orchestration Module (`004.workspace_compute`)

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5.0-623CE4?logo=terraform)](https://developer.hashicorp.com/terraform/docs)
[![Databricks Provider](https://img.shields.io/badge/Databricks_Provider-%3E%3D1.135.0-FF3621?logo=databricks)](https://registry.terraform.io/providers/databricks/databricks/latest/docs)

---

## 1. Executive Summary

- **Purpose & Scope**:
  This composite module orchestrates the complete in-workspace compute ecosystem for a Databricks workspace. It unifies compute policy governance ([`001.compute_policies`](file:///modules/05.compute/001.compute_policies)), all-purpose interactive clusters ([`002.all_purpose_cluster`](file:///modules/05.compute/002.all_purpose_cluster)), and SQL Warehouses ([`003.sql_warehouse`](file:///modules/05.compute/003.sql_warehouse)) into a single parameterized module declaration instantiated per workspace.
- **Problem Statement & Solution**:
  Declaring individual cluster resources and policies directly at the root environment level leads to repetitive HCL configurations across multiple workspaces. This composite module abstracts this complexity by accepting maps of cluster and warehouse definitions, automatically deploying the capped Platform Admin policy (max 25 DBU) alongside the Shared Workspace policy, and binding every provisioned cluster directly to the governed policy ID.
- **Key Business & Security Outcomes**:
  - **Single Point of Orchestration**: Environments instantiate this single module per workspace to provision all policies, clusters, and warehouses.
  - **Automated Policy Binding**: Binds provisioned clusters directly to the shared workspace policy or optional custom cluster policy ID.
  - **Scalable Map Architecture**: Supports provisioning zero, one, or multiple clusters and SQL endpoints per workspace without code changes.

---

## 2. General Logic & Operational Flow

### 2.1 Provisioning Lifecycle
1. **Compute Policies Deployment**: Instantiates `module.compute_policies` creating the Platform Admin policy (max 25 DBU) and Shared Workspace policy.
2. **Cluster Fleet Provisioning**: Uses `for_each = var.clusters` to invoke `module.clusters`, binding each cluster to `module.compute_policies.shared_policy_id`.
3. **SQL Warehouses Provisioning**: Uses `for_each = var.sql_warehouses` to invoke `module.sql_warehouses`, configuring T-shirt sizing and inactivity auto-stop.

---

## 3. Architecture of the Module

### 3.1 Submodules Invoked

| Submodule | Source | Role & Responsibility |
|:---|:---|:---|
| `module.compute_policies` | `../001.compute_policies` | Creates capped admin policy and shared workspace policy |
| `module.clusters` | `../002.all_purpose_cluster` | Instantiates policy-bound interactive clusters via `for_each` |
| `module.sql_warehouses` | `../003.sql_warehouse` | Instantiates auto-stopping SQL Warehouses via `for_each` |

---

## 4. Architecture C4 Visualisation

### 4.1 Level 2: Component Architecture Diagram

```mermaid
flowchart TD
    classDef input fill:#ECEFF1,stroke:#37474F,stroke-width:2px,color:#212121;
    classDef sub fill:#FFF3E0,stroke:#E65100,stroke-width:2px,color:#BF360C;

    Inputs["Inputs: workspace_url, admin_group_name, user_group_names, clusters, sql_warehouses"]:::input

    subgraph CompositeModule ["004.workspace_compute (per Workspace)"]
        Policies["001.compute_policies<br/>(Admin <=25 DBU + Shared)"]:::sub
        Clusters["002.all_purpose_cluster<br/>(for_each = var.clusters)"]:::sub
        Warehouses["003.sql_warehouse<br/>(for_each = var.sql_warehouses)"]:::sub

        Policies -->|"shared_policy_id"| Clusters
    end

    Inputs --> CompositeModule
```

---

## 5. Terraform Documentation Interface

> [!NOTE]
> Machine-generated interface specifications for this module are maintained by `terraform-docs` in [`TERRAFORM.md`](./TERRAFORM.md).

### 5.1 Essential Inputs Summary

| Variable | Type | Description | Required |
|:---|:---:|:---|:---:|
| `workspace_url` | `string` | The target workspace URL passed from the workspace module | Yes |
| `admin_group_name` | `string` | Name of the platform admin group | Yes |
| `user_group_names` | `list(string)` | List of user group names granted access | No |
| `clusters` | `map(object)` | Map of compute cluster configuration objects | No |
| `sql_warehouses` | `map(object)` | Map of SQL Warehouse endpoint configuration objects | No |

---

## 6. Important Links and References

- [Compute Policies Module (`001.compute_policies`)](file:///modules/05.compute/001.compute_policies)
- [All-Purpose Cluster Module (`002.all_purpose_cluster`)](file:///modules/05.compute/002.all_purpose_cluster)
- [SQL Warehouse Module (`003.sql_warehouse`)](file:///modules/05.compute/003.sql_warehouse)
- [Terraform Documentation Interface (`TERRAFORM.md`)](./TERRAFORM.md)
