module "main" {
  source           = "../.."
  adapter_template = "VMware"
  name             = var.name
  organization     = "terratest"
}
