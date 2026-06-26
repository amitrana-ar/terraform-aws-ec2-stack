resource "aws_key_pair" "awskeypair" {
    key_name   = var.ec2_key_pair_name
    public_key = file(var.ec2_key_pair_public_key)
}

 resource "aws_default_vpc" "default_vpc" {
     tags = {
         Name = var.ec2_vpc_name
     }
 }

resource "aws_security_group" "sg" {
    name        = var.ec2_security_group_name   
    vpc_id      = aws_default_vpc.default_vpc.id

    ingress {
        from_port   = var.ec2_ingress_ssh_port
        to_port     = var.ec2_ingress_ssh_port
        protocol    = "tcp"
        cidr_blocks = var.ec2_ssh_cidr_blocks
    }

    ingress {
        from_port   = var.ec2_ingress_http_port
        to_port     = var.ec2_ingress_http_port
        protocol    = "tcp"
        cidr_blocks = var.ec2_http_cidr_blocks
    }

    ingress {
        from_port   = var.ec2_ingress_https_port
        to_port     = var.ec2_ingress_https_port
        protocol    = "tcp"
        cidr_blocks = var.ec2_https_cidr_blocks
    }

    egress {
        from_port   = var.ec2-egress_all_port
        to_port     = var.ec2-egress_all_port
        protocol    = "-1"
        cidr_blocks = var.ec2_egress_all_cidr_blocks
    }
}

resource "aws_s3_bucket" s3_bucket {
  bucket = var.s3_bucket
  force_destroy = "true"
  tags = {
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.s3_versioning
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_sse_config" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_public_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = var.s3_block_public_acls
  block_public_policy     = var.s3_block_public_policy
  ignore_public_acls      = var.s3_ignore_public_acls
  restrict_public_buckets = var.s3_restrict_public_buckets
}

resource "aws_s3_bucket_logging" "s3_logging" {
  bucket = aws_s3_bucket.s3_bucket.id

  target_bucket = aws_s3_bucket.s3_bucket.id
  target_prefix = "logs/"
}

resource "aws_dynamodb_table" "terraformm_state_lock" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Environment = "Dev"
  }
}

resource "aws_instance" "ec2_instance" {
    for_each = var.ec2_instance_type
    ami           = each.value.ami
    instance_type = each.value.type
    key_name      = var.ec2_key_pair_name
    tags = {
      Name = "${each.key}"
    }
    user_data = file(each.value.user_data)
    vpc_security_group_ids = [aws_security_group.sg.id]
    root_block_device {
        volume_size = var.ec2_root_volume_size
    }
    depends_on = [aws_s3_bucket.s3_bucket]
}

