package test

import (
	"fmt"
	"os"
	"testing"

	iassert "github.com/cgascoig/intersight-simple-go/assert"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestFull(t *testing.T) {
	//========================================================================
	// Setup Terraform options
	//========================================================================

	// Generate a unique name for objects created in this test to ensure we don't
	// have collisions with stale objects
	uniqueId := random.UniqueId()
	instanceName := fmt.Sprintf("test-policies-eth-adapter-%s", uniqueId)

	// Input variables for the TF module
	vars := map[string]interface{}{
		"apikey":        os.Getenv("IS_KEYID"),
		"secretkeyfile": os.Getenv("IS_KEYFILE"),
		"name":          instanceName,
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./full",
		Vars:         vars,
	})

	//========================================================================
	// Init and apply terraform module
	//========================================================================
	defer terraform.Destroy(t, terraformOptions) // defer to ensure that TF destroy happens automatically after tests are completed
	terraform.InitAndApply(t, terraformOptions)
	moid := terraform.Output(t, terraformOptions, "moid")
	assert.NotEmpty(t, moid, "TF module moid output should not be empty")

	//========================================================================
	// Make Intersight API call(s) to validate module worked
	//========================================================================

	// Setup the expected values of the returned MO.
	// This is a Go template for the JSON object, so template variables can be used
	expectedJSONTemplate := `
{
	"Name":        "{{ .name }}",

	"AdvancedFilter": false,
	"ArfsSettings": {
	  "ClassId": "vnic.ArfsSettings",
	  "Enabled": false,
	  "ObjectType": "vnic.ArfsSettings"
	},
	"CompletionQueueSettings": {
	  "ClassId": "vnic.CompletionQueueSettings",
	  "Count": 2,
	  "ObjectType": "vnic.CompletionQueueSettings",
	  "RingSize": 1
	},
	"Description": "Recommended adapter settings for VMware.",
	"GeneveEnabled": false,
	"InterruptScaling": false,
	"InterruptSettings": {
	  "ClassId": "vnic.EthInterruptSettings",
	  "CoalescingTime": 125,
	  "CoalescingType": "MIN",
	  "Count": 4,
	  "Mode": "MSIx",
	  "ObjectType": "vnic.EthInterruptSettings"
	},
	"NvgreSettings": {
	  "ClassId": "vnic.NvgreSettings",
	  "Enabled": false,
	  "ObjectType": "vnic.NvgreSettings"
	},
	"PtpSettings": {
	  "ClassId": "vnic.PtpSettings",
	  "Enabled": false,
	  "ObjectType": "vnic.PtpSettings"
	},
	"RoceSettings": {
	  "ClassId": "vnic.RoceSettings",
	  "ClassOfService": 5,
	  "Enabled": false,
	  "MemoryRegions": 0,
	  "ObjectType": "vnic.RoceSettings",
	  "QueuePairs": 0,
	  "ResourceGroups": 0,
	  "Version": 1
	},
	"RssHashSettings": {
	  "ClassId": "vnic.RssHashSettings",
	  "Ipv4Hash": false,
	  "Ipv6ExtHash": false,
	  "Ipv6Hash": false,
	  "ObjectType": "vnic.RssHashSettings",
	  "TcpIpv4Hash": false,
	  "TcpIpv6ExtHash": false,
	  "TcpIpv6Hash": false,
	  "UdpIpv4Hash": false,
	  "UdpIpv6Hash": false
	},
	"RssSettings": false,
	"RxQueueSettings": {
	  "ClassId": "vnic.EthRxQueueSettings",
	  "Count": 1,
	  "ObjectType": "vnic.EthRxQueueSettings",
	  "RingSize": 512
	},
	"TcpOffloadSettings": {
	  "ClassId": "vnic.TcpOffloadSettings",
	  "LargeReceive": true,
	  "LargeSend": true,
	  "ObjectType": "vnic.TcpOffloadSettings",
	  "RxChecksum": true,
	  "TxChecksum": true
	},
	"TxQueueSettings": {
	  "ClassId": "vnic.EthTxQueueSettings",
	  "Count": 1,
	  "ObjectType": "vnic.EthTxQueueSettings",
	  "RingSize": 256
	},
	"UplinkFailbackTimeout": 5,
	"VxlanSettings": {
	  "ClassId": "vnic.VxlanSettings",
	  "Enabled": false,
	  "ObjectType": "vnic.VxlanSettings"
	}
}
`
	// Validate that what is in the Intersight API matches the expected
	// The AssertMOComply function only checks that what is expected is in the result. Extra fields in the
	// result are ignored. This means we don't have to worry about things that aren't known in advance (e.g.
	// Moids, timestamps, etc)
	iassert.AssertMOComply(t, fmt.Sprintf("/api/v1/vnic/EthAdapterPolicies/%s", moid), expectedJSONTemplate, vars)
}
