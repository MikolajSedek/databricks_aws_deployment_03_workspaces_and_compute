# Databricks All-Purpose Compute Cluster Module (`002.all_purpose_cluster`)

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5.0-623CE4?logo=terraform)](https://developer.hashicorp.com/terraform/docs)
[![Databricks Provider](https://img.shields.io/badge/Databricks_Provider-%3E%3D1.135.0-FF3621?logo=databricks)](https://registry.terraform.io/providers/databricks/databricks/latest/docs)

---

## 1. Executive Summary

- **Purpose & Scope**:
  This module provisions an all-purpose interactive compute cluster (`databricks_cluster`) within an individual Databricks workspace. It strictly enforces upstream policy adherence by requiring a `policy_id` parameter, establishes automatic scaling worker boundaries, configures inactivity auto-termination, and sets up role-based access controls (`databricks_permissions`).
- **Problem Statement & Solution**:
  Interactive clusters that lack policy enforcement can lead to configuration drift, oversized worker fleets, and high idle cloud compute costs. This module mandates that every cluster is tied to an upstream cluster policy, guarantees automatic shutdown after an idle period, and configures granular group-level permissions granting `CAN_MANAGE` to platform administrators and `CAN_RESTART` to authorized user groups.
- **Key Business & Security Outcomes**:
  - **Enforced Governance**: Guaranteed attachment to a validated cluster policy ID preventing unapproved configurations.
  - **Cost Minimization**: Strict inactivity autotermination and dynamic autoscaling minimize idle EC2 charges.
  - **RBAC Cluster Security**: Accepts a list of authorized user groups (`user_group_names`) granted `CAN_RESTART` and `CAN_ATTACH_TO`, while strictly restricting `CAN_MANAGE` to a single platform admin group (`admin_group_name`).

---

## 2. General Logic & Operational Flow

### 2.1 Provisioning Lifecycle
1. **Cluster Specification**: Creates `databricks_cluster.this` configured with:
   - `spark_version`: Databricks Runtime (DBR) version.
   - `node_type_id`: EC2 instance type (must comply with the bound policy's allowlist).
   - `policy_id`: Upstream policy governing cluster constraints.
   - `autoscale`: Minimum and maximum worker node limits.
   - `autotermination_minutes`: Idle timeout before automatic shutdown.
   - `custom_tags`: Merges user-defined tags with `ManagedBy = "Terraform"`.
2. **Access Control List (ACL)**: Creates `databricks_permissions.cluster_permissions`:
   - `CAN_MANAGE`: Granted to single `var.admin_group_name`.
   - `CAN_RESTART`: Iterates dynamically over `var.user_group_names` (granting developer groups permission to start/stop and attach to the cluster).

---

## 3. Architecture of the Module

### 3.1 Resource Architecture & Attributes

| Resource Identifier | Resource Type | Description |
|:---|:---|:---|
| `databricks_cluster.this` | `databricks_cluster` | All-purpose interactive compute cluster bound to policy |
| `databricks_permissions.cluster_permissions` | `databricks_permissions` | Access control granting `CAN_MANAGE` to single admin group and `CAN_RESTART` to user groups |

---

## 4. Architecture C4 Visualisation

### 4.1 Level 2: Component Architecture Diagram

```mermaid
flowchart TD
    classDef input fill:#ECEFF1,stroke:#37474F,stroke-width:2px,color:#212121;
    classDef compute fill:#FFF3E0,stroke:#E65100,stroke-width:2px,color:#BF360C;
    classDef acl fill:#E8EAF6,stroke:#283593,stroke-width:2px,color:#1A237E;

    Inputs["Inputs: cluster_name, spark_version, node_type_id, policy_id, min/max_workers, admin_group_name, user_group_names"]:::input

    subgraph ClusterModule ["002.all_purpose_cluster"]
        Cluster["databricks_cluster.this (Bound to policy_id)"]:::compute
        ACL["databricks_permissions.cluster_permissions"]:::acl

        Cluster --> ACL
    end

    Inputs --> Cluster
```

---

## 5. Terraform Documentation Interface

> [!NOTE]
> Machine-generated interface specifications for this module are maintained by `terraform-docs` in [`TERRAFORM.md`](./TERRAFORM.md).

### 5.1 Essential Inputs Summary

| Variable | Type | Description | Required |
|:---|:---:|:---|:---:|
| `cluster_name` | `string` | Name of the compute cluster | Yes |
| `spark_version` | `string` | Databricks Runtime (DBR) Spark version string | Yes |
| `node_type_id` | `string` | Worker node EC2 instance type ID | Yes |
| `policy_id` | `string` | ID of the cluster policy governing this cluster | Yes |
| `min_workers` | `number` | Minimum number of autoscaling workers | Yes |
| `max_workers` | `number` | Maximum number of autoscaling workers | Yes |
| `admin_group_name` | `string` | Single platform admin group name (`CAN_MANAGE`) | Yes |
| `autotermination_minutes` | `number` | Inactivity minutes before auto-shutdown (default: `30`) | No |
| `user_group_names` | `list(string)` | List of group names granted permissions (`CAN_RESTART`) (default: `[]`) | No |
| `custom_tags` | `map(string)` | Custom tags attached to cluster | No |

---

## 6. Important Links and References

- [Databricks Cluster Configuration Reference](https://docs.databricks.com/aws/en/compute/configure)
- [Databricks Cluster Resource Documentation](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster)
- [Databricks Cluster Permissions Documentation](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions)
- [Terraform Documentation Interface (`TERRAFORM.md`)](./TERRAFORM.md)
