# Política IAM para permitir criar instâncias
# Esta política é criada no tenancy para aplicar a todos os compartments

resource "oci_identity_policy" "allow_compute_instances" {
  compartment_id = var.tenancy_ocid
  name           = "Allow-Administrators-Create-Instances"
  description    = "Permite que Administrators criem e gerenciem instâncias de compute"
  
  statements = [
    "Allow group Administrators to manage instance-family in tenancy",
    "Allow group Administrators to read app-catalog-listing in tenancy",
    "Allow group Administrators to use volume-family in tenancy",
    "Allow group Administrators to use virtual-network-family in tenancy"
  ]
}

