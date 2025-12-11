output "instance_ip" {
  description = "IP público da instância criada"
  value       = oci_core_instance.app_server.public_ip
}

output "instance_id" {
  description = "OCID da instância"
  value       = oci_core_instance.app_server.id
}

output "instance_name" {
  description = "Nome da instância"
  value       = oci_core_instance.app_server.display_name
}

