<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)
[![Tests](https://github.com/terraform-cisco-modules/terraform-intersight-policies-ethernet-adapter/actions/workflows/terratest.yml/badge.svg)](https://github.com/terraform-cisco-modules/terraform-intersight-policies-ethernet-adapter/actions/workflows/terratest.yml)

# Terraform Intersight Policies - Ethernet Adapter
Manages Intersight Ethernet Adapter Policies

Location in GUI:
`Policies` » `Create Policy` » `Ethernet Adapter`

## Easy IMM

[*Easy IMM - Comprehensive Example*](https://github.com/terraform-cisco-modules/easy-imm-comprehensive-example) - A comprehensive example for policies, pools, and profiles.

## Example

### main.tf
```hcl
module "ethernet_adapter_policy" {
  source  = "terraform-cisco-modules/policies-ethernet-adapter/intersight"
  version = ">= 1.0.1"

  adapter_template = "WIN-AzureStack"
  description      = "default Ethernet Adapter Policy."
  name             = "default"
  organization     = "default"
}
```

### provider.tf
```hcl
terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
  required_version = ">=1.3.0"
}

provider "intersight" {
  apikey    = var.apikey
  endpoint  = var.endpoint
  secretkey = fileexists(var.secretkeyfile) ? file(var.secretkeyfile) : var.secretkey
}
```

### variables.tf
```hcl
variable "apikey" {
  description = "Intersight API Key."
  sensitive   = true
  type        = string
}

variable "endpoint" {
  default     = "https://intersight.com"
  description = "Intersight URL."
  type        = string
}

variable "secretkey" {
  default     = ""
  description = "Intersight Secret Key Content."
  sensitive   = true
  type        = string
}

variable "secretkeyfile" {
  default     = "blah.txt"
  description = "Intersight Secret Key File Location."
  sensitive   = true
  type        = string
}
```

## Environment Variables

### Terraform Cloud/Enterprise - Workspace Variables
- Add variable apikey with the value of [your-api-key]
- Add variable secretkey with the value of [your-secret-file-content]

### Linux and Windows
```bash
export TF_VAR_apikey="<your-api-key>"
export TF_VAR_secretkeyfile="<secret-key-file-location>"
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.32 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | 1.0.32 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apikey"></a> [apikey](#input\_apikey) | Intersight API Key. | `string` | n/a | yes |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | Intersight URL. | `string` | `"https://intersight.com"` | no |
| <a name="input_secretkey"></a> [secretkey](#input\_secretkey) | Intersight Secret Key. | `string` | n/a | yes |
| <a name="input_adapter_template"></a> [adapter\_template](#input\_adapter\_template) | Name of a Pre-Configured Adapter Policy.  Options are:<br>* Linux<br>* Linux-NVMe-RoCE<br>* MQ<br>* MQ-SMBd<br>* SMBServer<br>* SMBClient<br>* Solaris<br>* SRIOV<br>* usNIC<br>* usNICOracleRAC<br>* VMware<br>* VMwarePassThru<br>* WIN-AzureStack<br>* Win-HPN<br>* Win-HPN-SMBd<br>* Windows | `string` | `""` | no |
| <a name="input_completion_queue_count"></a> [completion\_queue\_count](#input\_completion\_queue\_count) | The number of completion queue resources to allocate. In general, the number of completion queue resources to allocate is equal to the number of transmit queue resources plus the number of receive queue resources.  Range is 1-2000. | `number` | `5` | no |
| <a name="input_completion_ring_size"></a> [completion\_ring\_size](#input\_completion\_ring\_size) | The number of descriptors in each completion queue.  Range is 1-256. | `number` | `1` | no |
| <a name="input_description"></a> [description](#input\_description) | Description for the Policy. | `string` | `""` | no |
| <a name="input_enable_accelerated_receive_flow_steering"></a> [enable\_accelerated\_receive\_flow\_steering](#input\_enable\_accelerated\_receive\_flow\_steering) | Status of Accelerated Receive Flow Steering on the virtual ethernet interface. | `bool` | `false` | no |
| <a name="input_enable_advanced_filter"></a> [enable\_advanced\_filter](#input\_enable\_advanced\_filter) | Enables advanced filtering on the interface. | `bool` | `false` | no |
| <a name="input_enable_geneve_offload"></a> [enable\_geneve\_offload](#input\_enable\_geneve\_offload) | GENEVE offload protocol allows you to create logical networks that span physical network boundaries by allowing any information to be encoded in a packet and passed between tunnel endpoints. | `bool` | `false` | no |
| <a name="input_enable_interrupt_scaling"></a> [enable\_interrupt\_scaling](#input\_enable\_interrupt\_scaling) | Enables Interrupt Scaling on the interface. | `bool` | `false` | no |
| <a name="input_enable_nvgre_offload"></a> [enable\_nvgre\_offload](#input\_enable\_nvgre\_offload) | Status of the Network Virtualization using Generic Routing Encapsulation on the virtual ethernet interface. | `bool` | `false` | no |
| <a name="input_enable_vxlan_offload"></a> [enable\_vxlan\_offload](#input\_enable\_vxlan\_offload) | Status of the Virtual Extensible LAN Protocol on the virtual ethernet interface. | `bool` | `false` | no |
| <a name="input_interrupt_coalescing_type"></a> [interrupt\_coalescing\_type](#input\_interrupt\_coalescing\_type) | Interrupt Coalescing Type. This can be one of the following:- MIN - The system waits for the time specified in the Coalescing Time field before sending another interrupt event IDLE - The system does not send an interrupt until there is a period of no activity lasting as least as long as the time specified in the Coalescing Time field.  Options are:<br>* IDLE<br>* MIN | `string` | `"MIN"` | no |
| <a name="input_interrupt_mode"></a> [interrupt\_mode](#input\_interrupt\_mode) | The preferred driver interrupt mode. This can be one of the following:<br>* INTx - Line-based interrupt (INTx) mechanism similar to the one used in Legacy systems.<br>* MSI - Message Signaled Interrupt (MSI) mechanism that treats messages as interrupts.<br>* MSIx - Message Signaled Interrupt mechanism with the optional extension (MSIx).<br>MSIx is the recommended and default option. | `string` | `"MSIx"` | no |
| <a name="input_interrupt_timer"></a> [interrupt\_timer](#input\_interrupt\_timer) | The time to wait between interrupts or the idle period that must be encountered before an interrupt is sent. To turn off interrupt coalescing, enter 0 (zero) in this field.  Range is 0-65535. | `number` | `125` | no |
| <a name="input_interrupts"></a> [interrupts](#input\_interrupts) | The number of interrupt resources to allocate. Typical value is be equal to the number of completion queue resources.  Range is 1-1024. | `number` | `8` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the Policy. | `string` | `"default"` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/. | `string` | `"default"` | no |
| <a name="input_receive_side_scaling_enable"></a> [receive\_side\_scaling\_enable](#input\_receive\_side\_scaling\_enable) | Receive Side Scaling allows the incoming traffic to be spread across multiple CPU cores. | `bool` | `true` | no |
| <a name="input_roce_cos"></a> [roce\_cos](#input\_roce\_cos) | The Class of Service for RoCE on this virtual interface.  Options are:<br>* 1<br>* 2<br>* 4<br>* 5<br>* 6 | `number` | `6` | no |
| <a name="input_roce_enable"></a> [roce\_enable](#input\_roce\_enable) | If enabled sets RDMA over Converged Ethernet (RoCE) on this virtual interface. | `bool` | `false` | no |
| <a name="input_roce_memory_regions"></a> [roce\_memory\_regions](#input\_roce\_memory\_regions) | The number of memory regions per adapter. Recommended value = integer power of 2.  Range is 0-524288. | `number` | `0` | no |
| <a name="input_roce_queue_pairs"></a> [roce\_queue\_pairs](#input\_roce\_queue\_pairs) | The number of queue pairs per adapter. Recommended value = integer power of 2.  Range is 0-8192. | `number` | `0` | no |
| <a name="input_roce_resource_groups"></a> [roce\_resource\_groups](#input\_roce\_resource\_groups) | The number of resource groups per adapter. Recommended value = be an integer power of 2 greater than or equal to the number of CPU cores on the system for optimum performance.  Range is 0-128. | `number` | `0` | no |
| <a name="input_roce_version"></a> [roce\_version](#input\_roce\_version) | Configure RDMA over Converged Ethernet (RoCE) version on the virtual interface. Only RoCEv1 is supported on Cisco VIC 13xx series adapters and only RoCEv2 is supported on Cisco VIC 14xx series adapters.  Options are:<br>* 1<br>* 2 | `number` | `1` | no |
| <a name="input_rss_enable_ipv4_hash"></a> [rss\_enable\_ipv4\_hash](#input\_rss\_enable\_ipv4\_hash) | When enabled, the IPv4 address is used for traffic distribution. | `bool` | `true` | no |
| <a name="input_rss_enable_ipv6_extensions_hash"></a> [rss\_enable\_ipv6\_extensions\_hash](#input\_rss\_enable\_ipv6\_extensions\_hash) | When enabled, the IPv6 extensions are used for traffic distribution. | `bool` | `false` | no |
| <a name="input_rss_enable_ipv6_hash"></a> [rss\_enable\_ipv6\_hash](#input\_rss\_enable\_ipv6\_hash) | When enabled, the IPv6 address is used for traffic distribution. | `bool` | `true` | no |
| <a name="input_rss_enable_tcp_and_ipv4_hash"></a> [rss\_enable\_tcp\_and\_ipv4\_hash](#input\_rss\_enable\_tcp\_and\_ipv4\_hash) | When enabled, both the IPv4 address and TCP port number are used for traffic distribution. | `bool` | `true` | no |
| <a name="input_rss_enable_tcp_and_ipv6_extensions_hash"></a> [rss\_enable\_tcp\_and\_ipv6\_extensions\_hash](#input\_rss\_enable\_tcp\_and\_ipv6\_extensions\_hash) | When enabled, both the IPv6 extensions and TCP port number are used for traffic distribution. | `bool` | `false` | no |
| <a name="input_rss_enable_tcp_and_ipv6_hash"></a> [rss\_enable\_tcp\_and\_ipv6\_hash](#input\_rss\_enable\_tcp\_and\_ipv6\_hash) | When enabled, both the IPv6 address and TCP port number are used for traffic distribution. | `bool` | `true` | no |
| <a name="input_rss_enable_udp_and_ipv4_hash"></a> [rss\_enable\_udp\_and\_ipv4\_hash](#input\_rss\_enable\_udp\_and\_ipv4\_hash) | When enabled, both the IPv4 address and UDP port number are used for traffic distribution. | `bool` | `false` | no |
| <a name="input_rss_enable_udp_and_ipv6_hash"></a> [rss\_enable\_udp\_and\_ipv6\_hash](#input\_rss\_enable\_udp\_and\_ipv6\_hash) | When enabled, both the IPv6 address and UDP port number are used for traffic distribution. | `bool` | `false` | no |
| <a name="input_receive_queue_count"></a> [receive\_queue\_count](#input\_receive\_queue\_count) | The number of queue resources to allocate.  Range is 1-1000. | `number` | `4` | no |
| <a name="input_receive_ring_size"></a> [receive\_ring\_size](#input\_receive\_ring\_size) | The number of descriptors in each queue.  Range is 64-4096. | `number` | `512` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of Tag Attributes to Assign to the Policy. | `list(map(string))` | `[]` | no |
| <a name="input_tcp_offload_large_recieve"></a> [tcp\_offload\_large\_recieve](#input\_tcp\_offload\_large\_recieve) | Enables the reassembly of segmented packets in hardware before sending them to the CPU. | `bool` | `true` | no |
| <a name="input_tcp_offload_large_send"></a> [tcp\_offload\_large\_send](#input\_tcp\_offload\_large\_send) | Enables the CPU to send large packets to the hardware for segmentation. | `bool` | `true` | no |
| <a name="input_tcp_offload_rx_checksum"></a> [tcp\_offload\_rx\_checksum](#input\_tcp\_offload\_rx\_checksum) | When enabled, the CPU sends all packet checksums to the hardware for validation. | `bool` | `true` | no |
| <a name="input_tcp_offload_tx_checksum"></a> [tcp\_offload\_tx\_checksum](#input\_tcp\_offload\_tx\_checksum) | When enabled, the CPU sends all packets to the hardware so that the checksum can be calculated. | `bool` | `true` | no |
| <a name="input_transmit_queue_count"></a> [transmit\_queue\_count](#input\_transmit\_queue\_count) | The number of queue resources to allocate.  Range is 1-1000. | `number` | `1` | no |
| <a name="input_transmit_ring_size"></a> [transmit\_ring\_size](#input\_transmit\_ring\_size) | The number of descriptors in each queue.  Range is 64-4096. | `number` | `256` | no |
| <a name="input_uplink_failback_timeout"></a> [uplink\_failback\_timeout](#input\_uplink\_failback\_timeout) | Uplink Failback Timeout in seconds when uplink failover is enabled for a vNIC. After a vNIC has started using its secondary interface, this setting controls how long the primary interface must be available before the system resumes using the primary interface for the vNIC.  Range is 0-600. | `number` | `5` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_moid"></a> [moid](#output\_moid) | Ethernet Adapter Policy Managed Object ID (moid). |
## Resources

| Name | Type |
|------|------|
| [intersight_vnic_eth_adapter_policy.ethernet_adapter](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/vnic_eth_adapter_policy) | resource |
| [intersight_organization_organization.org_moid](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/organization_organization) | data source |
<!-- END_TF_DOCS -->