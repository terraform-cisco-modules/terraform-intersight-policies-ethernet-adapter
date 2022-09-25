#____________________________________________________________
#
# Intersight Organization Data Source
# GUI Location: Settings > Settings > Organizations > {Name}
#____________________________________________________________

data "intersight_organization_organization" "org_moid" {
  for_each = {
    for v in [var.organization] : v => v if length(
      regexall("[[:xdigit:]]{24}", var.organization)
    ) == 0
  }
  name = each.value
}

#__________________________________________________________________
#
# Intersight Ethernet Adapter Policy
# GUI Location: Policies > Create Policy > Ethernet Adapter
#__________________________________________________________________

resource "intersight_vnic_eth_adapter_policy" "ethernet_adapter" {
  depends_on = [
    data.intersight_organization_organization.org_moid
  ]
  advanced_filter = length(
    compact([var.adapter_template])) > 0 ? false : length(
    compact([var.enable_advanced_filter])
  ) > 0 ? var.enable_advanced_filter : false
  description = length(
    regexall("(Linux-NVMe-RoCE)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for NVMe using RDMA." : length(
    regexall("(Linux)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for linux." : length(
    regexall("(MQ-SMBd)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for MultiQueue with RDMA." : length(
    regexall("(MQ)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for VM Multi Queue Connection with no RDMA." : length(
    regexall("(SMBClient)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for SMB Client." : length(
    regexall("(SMBServer)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for SMB server." : length(
    regexall("(Solaris)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for Solaris." : length(
    regexall("(SRIOV)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for Win8 SRIOV-VMFEX PF." : length(
    regexall("(usNICOracleRAC)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for usNIC Oracle RAC Connection." : length(
    regexall("(usNIC)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for usNIC Connection." : length(
    regexall("(VMwarePassThru)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for VMware pass-thru." : length(
    regexall("(VMware)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for VMware." : length(
    regexall("(Win-AzureStack)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for Azure Stack." : length(
    regexall("(Win-HPN-SMBd)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for Windows high performance and networking with RoCE V2." : length(
    regexall("(Win-HPN)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for Windows high performance and networking." : length(
    regexall("(Windows)", coalesce(var.adapter_template, "EMPTY"))
  ) > 0 ? "Recommended adapter settings for Windows." : var.description != null ? var.description : ""
  geneve_enabled = length(
    compact([var.adapter_template])) > 0 ? false : length(
    compact([var.enable_geneve_offload])
  ) > 0 ? var.enable_geneve_offload : false
  interrupt_scaling = length(
    compact([var.adapter_template])) > 0 ? false : length(
    compact([var.enable_interrupt_scaling])
  ) > 0 ? var.enable_interrupt_scaling : false
  name = var.name
  rss_settings = length(
    regexall("(Linux|Solaris|VMware)", coalesce(var.adapter_template, "EMPTY"))
    ) > 0 ? false : length(compact([var.adapter_template])
  ) > 0 ? true : var.receive_side_scaling_enable != null ? var.receive_side_scaling_enable : true
  uplink_failback_timeout = length(
    regexall("(usNIC|usNICOracleRAC)", coalesce(var.adapter_template, "EMPTY"))
  ) > 0 ? 0 : var.uplink_failback_timeout != null ? var.uplink_failback_timeout : 5
  arfs_settings {
    enabled = length(
      compact([var.adapter_template])) > 0 ? false : length(
      compact([var.enable_accelerated_receive_flow_steering])
    ) > 0 ? var.enable_accelerated_receive_flow_steering : false
  }
  completion_queue_settings {
    nr_count = length(
      regexall("(Linux-NVMe-RoCE|Linux|Solaris|VMware)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 2 : length(
      regexall("(usNIC)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 6 : length(
      regexall("(VMwarePassThru)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 8 : length(
      regexall("(Win-AzureStack)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 11 : length(
      regexall("(usNIC)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 12 : length(
      regexall("(MQ-SMBd|MQ)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 576 : length(
      regexall("(usNICOracleRAC)", coalesce(var.adapter_template, "EMPTY"))
    ) > 0 ? 2000 : var.completion_queue_count != null ? var.completion_queue_count : 5
    ring_size = length(
      regexall("(MQ|usNIC|usNICOracleRAC)", coalesce(var.adapter_template, "EMPTY"))
    ) > 0 ? 4 : var.completion_ring_size != null ? var.completion_ring_size : 1
  }
  interrupt_settings {
    coalescing_time = var.adapter_template != null ? 125 : var.interrupt_timer != null ? var.interrupt_timer : 125
    coalescing_type = length(
      compact([var.adapter_template])) > 0 ? "MIN" : length(
      compact([var.interrupt_coalescing_type])
    ) > 0 ? var.interrupt_coalescing_type : "MIN"
    nr_count = length(
      regexall("(Linux|Solaris|VMware)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 4 : length(
      regexall("(VMwarePassThru)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 12 : length(
      regexall("(SRIOV)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 32 : length(
      regexall("(MQ-SMBd|Win-HPN|Win-HPN-SMBd)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 512 : length(
      regexall("(Linux-NVMe-RoCE|MQ|Win-AzureStack)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 256 : length(
      regexall("(usNICOracleRAC)", coalesce(var.adapter_template, "EMPTY"))
    ) > 0 ? 1024 : var.adapter_template != null ? 8 : var.interrupts != null ? var.interrupts : 8
    mode = length(
      regexall("(VMwarePassThru)", coalesce(var.adapter_template, "EMPTY"))
      ) > 0 ? "MSI" : length(compact([var.adapter_template])
      ) > 0 ? "MSIx" : length(compact([var.interrupt_mode])
    ) > 0 ? var.interrupt_mode : "MSIx"
  }
  nvgre_settings {
    enabled = length(
      compact([var.adapter_template])) > 0 ? false : length(
      compact([var.enable_nvgre_offload])
    ) > 0 ? var.enable_nvgre_offload : false
  }
  organization {
    moid = length(
      regexall("[[:xdigit:]]{24}", var.organization)
      ) > 0 ? var.organization : data.intersight_organization_organization.org_moid[
      var.organization].results[0
    ].moid
    object_type = "organization.Organization"
  }
  roce_settings {
    class_of_service = var.adapter_template != null ? 5 : var.roce_cos != null ? var.roce_cos : 5
    enabled = length(
      regexall("(Linux-NVMe-RoCE|MQ-SMBd|SMBClient|SMBServer|Win-AzureStack|Win-HPN-SMBd)", coalesce(var.adapter_template, "EMPTY"))
    ) > 0 ? true : var.roce_enable != null ? var.roce_enable : false
    memory_regions = length(
      regexall("(MQ-SMBd)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 65536 : length(
      regexall("(Linux-NVMe-RoCE|SMBClient|SMBServer|Win-AzureStack|Win-HPN-SMBd)", coalesce(var.adapter_template, "EMPTY"))
    ) > 0 ? 131072 : var.roce_memory_regions != null ? var.roce_memory_regions : var.roce_enable == true ? 131072 : 0
    queue_pairs = length(
      regexall("(MQ-SMBd|SMBClient|Win-AzureStack|Win-HPN-SMBd)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 256 : length(
      regexall("(Linux-NVMe-RoCE)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 1024 : length(
      regexall("(SMBServer)", coalesce(var.adapter_template, "EMPTY"))
    ) > 0 ? 2048 : var.roce_queue_pairs != null ? var.roce_queue_pairs : var.roce_enable == true ? 256 : 0
    resource_groups = length(
      regexall("(MQ-SMBd|Win-HPN-SMBd)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 2 : length(
      regexall("(Linux-NVMe-RoCE)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 8 : length(
      regexall("(SMBClient|SMBServer)", coalesce(var.adapter_template, "EMPTY"))
    ) > 0 ? 32 : var.roce_resource_groups != null ? var.roce_resource_groups : var.roce_enable == true ? 4 : 0
    nr_version = length(
      regexall("(Linux-NVMe-RoCE|MQ-SMBd|Win-AzureStack|Win-HPN-SMBd)", coalesce(var.adapter_template, "EMPTY"))
    ) > 0 ? 2 : var.roce_version != null ? var.roce_version : 1
  }
  rss_hash_settings {
    ipv4_hash = length(
      compact([var.adapter_template])) > 0 ? false : length(
      compact([var.rss_enable_ipv4_hash])) > 0 ? var.rss_enable_ipv4_hash : length(
      regexall(true, coalesce(var.receive_side_scaling_enable, false))
    ) > 0 ? true : false
    ipv6_ext_hash = length(
      compact([var.adapter_template])) > 0 ? false : length(
    compact([var.rss_enable_ipv6_extensions_hash])) > 0 ? var.rss_enable_ipv6_extensions_hash : false
    ipv6_hash = length(
      compact([var.adapter_template])) > 0 ? false : length(
      compact([var.rss_enable_ipv6_hash])
      ) > 0 ? var.rss_enable_ipv6_hash : length(
      regexall(true, coalesce(var.receive_side_scaling_enable, false))
    ) > 0 ? true : false
    tcp_ipv4_hash = length(
      compact([var.adapter_template])) > 0 ? false : length(
      compact([var.rss_enable_tcp_and_ipv4_hash])) > 0 ? var.rss_enable_tcp_and_ipv4_hash : length(
      regexall(true, coalesce(var.receive_side_scaling_enable, false))
    ) > 0 ? true : false
    tcp_ipv6_ext_hash = length(
      compact([var.adapter_template])) > 0 ? false : length(
    compact([var.rss_enable_tcp_and_ipv6_extensions_hash])) > 0 ? var.rss_enable_tcp_and_ipv6_extensions_hash : false
    tcp_ipv6_hash = length(
      compact([var.adapter_template])) > 0 ? false : length(
      compact([var.rss_enable_tcp_and_ipv6_hash])) > 0 ? var.rss_enable_tcp_and_ipv6_hash : length(
      regexall(true, coalesce(var.receive_side_scaling_enable, false))
    ) > 0 ? true : false
    udp_ipv4_hash = length(
      compact([var.adapter_template])) > 0 ? false : length(
      compact([var.rss_enable_udp_and_ipv4_hash])
    ) > 0 ? var.rss_enable_udp_and_ipv4_hash : false
    udp_ipv6_hash = length(
      compact([var.adapter_template])) > 0 ? false : length(
      compact([var.rss_enable_udp_and_ipv6_hash])
    ) > 0 ? var.rss_enable_udp_and_ipv6_hash : false
  }
  rx_queue_settings {
    nr_count = length(
      regexall("(Linux|Linux-NVMe-RoCE|Solaris|VMware)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 1 : length(
      regexall("(usNIC)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 6 : length(
      regexall("(Win-AzureStack)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 8 : length(
      regexall("(MQ-SMBd|MQ)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 512 : length(
      regexall("(usNICOracleRAC)", coalesce(var.adapter_template, "EMPTY"))
    ) > 0 ? 1000 : var.receive_queue_count != null ? var.receive_queue_count : 4
    ring_size = length(
      regexall("(Win-AzureStack)", coalesce(var.adapter_template, "EMPTY"))
    ) > 0 ? 4096 : var.receive_ring_size != null ? var.receive_ring_size : 512
  }
  tcp_offload_settings {
    large_receive = length(
      compact([var.adapter_template])) > 0 ? true : length(
      compact([var.tcp_offload_large_recieve])
    ) > 0 ? var.tcp_offload_large_recieve : true
    large_send = length(
      compact([var.adapter_template])) > 0 ? true : length(
      compact([var.tcp_offload_large_send])
    ) > 0 ? var.tcp_offload_large_send : true
    rx_checksum = length(
      compact([var.adapter_template])) > 0 ? true : length(
      compact([var.tcp_offload_rx_checksum])
    ) > 0 ? var.tcp_offload_rx_checksum : true
    tx_checksum = length(
      compact([var.adapter_template])) > 0 ? true : length(
      compact([var.tcp_offload_tx_checksum])
    ) > 0 ? var.tcp_offload_tx_checksum : true
  }
  tx_queue_settings {
    nr_count = length(
      regexall("(Win-AzureStack)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 3 : length(
      regexall("(VMwarePassThru)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 4 : length(
      regexall("(usNIC)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 6 : length(
      regexall("(MQ-SMBd|MQ)", coalesce(var.adapter_template, "EMPTY"))) > 0 ? 64 : length(
      regexall("(usNICOracleRAC)", coalesce(var.adapter_template, "EMPTY"))
    ) > 0 ? 1000 : var.transmit_queue_count != null ? var.transmit_queue_count : 1
    ring_size = length(
      regexall("(Win-AzureStack)", coalesce(var.adapter_template, "EMPTY"))
    ) > 0 ? 1024 : var.transmit_ring_size != null ? var.transmit_ring_size : 256
  }
  vxlan_settings {
    enabled = length(
      regexall("(Win-AzureStack|Win-HPN|Win-HPN-SMBd)", coalesce(var.adapter_template, "EMPTY"))
      ) > 0 ? true : length(compact([var.adapter_template])
    ) > 0 ? false : var.enable_vxlan_offload != null ? var.enable_vxlan_offload : false
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
