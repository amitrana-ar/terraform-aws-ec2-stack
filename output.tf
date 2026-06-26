output "ec2_public_ip" {
    value = values(aws_instance.ec2_instance)[*].public_ip
}

output "ec2_private_ip" {
    value = values(aws_instance.ec2_instance)[*].private_ip
}

output "ec2_tags" {
    value = values(aws_instance.ec2_instance)[*].tags
}

output "ec2_instance_type" {
    value = values(aws_instance.ec2_instance)[*].instance_type
}