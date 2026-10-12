/*
  Databricks MWS Networking and PrivateLink Connectivity Configuration
  Documentation:
    - https://docs.databricks.com/aws/en/security/network/classic/privatelink
    - https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_networks
*/

resource "aws_security_group" "privatelink_vpce_sg" {
  name        = "${var.network_name}-vpce-sg"
  description = "Security group for Databricks PrivateLink interface VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTPS 443 from Databricks compute clusters"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = var.security_group_ids
  }

  ingress {
    description     = "Allow Secure Cluster Connectivity relay port 6666 from clusters"
    from_port       = 6666
    to_port         = 6666
    protocol        = "tcp"
    security_groups = var.security_group_ids
  }

  egress {
    description = "Allow all outbound traffic from VPC endpoints"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.network_name}-vpce-sg"
    }
  )
}

/* AWS VPC Interface Endpoint for Databricks Workspace REST API */
resource "aws_vpc_endpoint" "backend_rest" {
  vpc_id              = var.vpc_id
  service_name        = var.workspace_vpce_service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.privatelink_vpce_sg.id]
  private_dns_enabled = false

  tags = merge(
    var.tags,
    {
      Name = "${var.network_name}-rest-vpce"
    }
  )
}

/* AWS VPC Interface Endpoint for Databricks SCC Relay */
resource "aws_vpc_endpoint" "relay" {
  vpc_id              = var.vpc_id
  service_name        = var.relay_vpce_service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.privatelink_vpce_sg.id]
  private_dns_enabled = false

  tags = merge(
    var.tags,
    {
      Name = "${var.network_name}-relay-vpce"
    }
  )
}

/* Register Workspace REST Endpoint in Databricks Account */
resource "databricks_mws_vpc_endpoint" "backend_rest" {
  provider            = databricks.mws
  aws_vpc_endpoint_id = aws_vpc_endpoint.backend_rest.id
  vpc_endpoint_name   = "${var.network_name}-rest-vpce"
  region              = var.aws_region
}

/* Register SCC Relay Endpoint in Databricks Account */
resource "databricks_mws_vpc_endpoint" "relay" {
  provider            = databricks.mws
  aws_vpc_endpoint_id = aws_vpc_endpoint.relay.id
  vpc_endpoint_name   = "${var.network_name}-relay-vpce"
  region              = var.aws_region
}

/* Configure Databricks Private Access Settings (PAS) */
resource "databricks_mws_private_access_settings" "pas" {
  provider                     = databricks.mws
  private_access_settings_name = "${var.network_name}-pas"
  region                       = var.aws_region
  public_access_enabled        = var.public_access_enabled
  private_access_level         = var.private_access_level
}

/* Register Customer-Managed VPC in Databricks Account */
resource "databricks_mws_networks" "this" {
  provider           = databricks.mws
  account_id         = var.databricks_account_id
  network_name       = var.network_name
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids

  vpc_endpoints {
    rest_api        = [databricks_mws_vpc_endpoint.backend_rest.vpc_endpoint_id]
    dataplane_relay = [databricks_mws_vpc_endpoint.relay.vpc_endpoint_id]
  }

  depends_on = [
    databricks_mws_vpc_endpoint.backend_rest,
    databricks_mws_vpc_endpoint.relay
  ]
}
