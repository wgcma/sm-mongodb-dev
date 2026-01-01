# terraform/outputs.tf
output "k3s_public_ip" {
  description = "Public IP of K3s server"
  value       = aws_instance.k3s.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to K3s server"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_instance.k3s.public_ip}"
}

output "kubeconfig_command" {
  description = "Command to use kubeconfig"
  value       = "export KUBECONFIG=${path.module}/kubeconfig.yaml"
}
