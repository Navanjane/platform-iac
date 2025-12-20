# EKS Module
# This module creates an Amazon EKS cluster with managed node groups
# using the official terraform-aws-modules/eks/aws module

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.10.1"

  # Cluster configuration
  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  # Network configuration
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # Cluster endpoint access
  endpoint_public_access  = var.cluster_endpoint_public_access
  endpoint_private_access = var.cluster_endpoint_private_access

  # Enable IRSA and cluster creator admin permissions
  enable_irsa                              = true
  enable_cluster_creator_admin_permissions = true

  # Cluster addons
  addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  # EKS Managed Node Groups
  eks_managed_node_groups = {
    general = {
      name = "${var.cluster_name}-general"

      instance_types = var.node_group_instance_types
      capacity_type  = var.node_group_capacity_type

      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size

      # Use the latest EKS optimized AMI
      ami_type = "AL2023_x86_64_STANDARD"

      # Node group configuration
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = var.node_group_disk_size
            volume_type = "gp3"
          }
        }
      }

      # Labels
      labels = merge(
        {
          role = "general"
        },
        var.node_group_labels
      )

      # Taints
      taints = var.node_group_taints

      # Tags
      tags = merge(
        var.tags,
        {
          Name      = "${var.cluster_name}-general-node"
          NodeGroup = "general"
        }
      )
    }
  }

  # Enable cluster logging
  enabled_log_types = var.cluster_enabled_log_types

  # Tags
  tags = var.tags
}
