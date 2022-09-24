module "ethernet_adapter_policy" {
  source  = "terraform-cisco-modules/policies-ethernet-adapter/intersight"
  version = ">= 1.0.1"

  adapter_template = "VMware"
  description      = "default Ethernet Adapter Policy."
  name         = "default"
  organization = "default"
}
