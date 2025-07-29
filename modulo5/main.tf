# -------- providers.tf --------
# Define el proveedor y región a utilizar
provider "aws" {
  region = "us-east-1"
}

# -------- variables.tf --------
# Variables reutilizables para entorno
variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "vod-cluster"
}

variable "vpc_id" {
  description = "ID de la VPC existente"
}

variable "subnet_ids" {
  type = list(string)
  description = "Lista de subredes para los nodos EKS"
}

# -------- s3.tf --------
# S3 para almacenamiento de videos
resource "aws_s3_bucket" "vod_videos" {
  bucket = "vod-video-storage-bucket"

  tags = {
    Name = "VideoStorage"
    Project = "VOD"
  }
}

# Versionado para manejar múltiples versiones de videos
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.vod_videos.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Cifrado del bucket con AES256 (por defecto)
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.vod_videos.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# -------- eks.tf --------
# Crea el cluster EKS utilizando un módulo oficial de Terraform
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  version         = "1.27"
  subnets         = var.subnet_ids
  vpc_id          = var.vpc_id

  # Habilita la autenticación IRSA
  # (IAM Roles for Service Accounts)
  enable_irsa     = true

  # Define un grupo de nodos (EC2) para ejecutar los pods
  node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 4
      min_capacity     = 1
      instance_type    = "t3.medium"

      labels = {
        role = "general"
      }
    }
  }

  tags = {
    Environment = "dev"
    Project     = "VOD"
  }
}
