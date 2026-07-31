import { NsgRule, buildAllowRule } from 'lib.bicep'

param location string = resourceGroup().location

var rules NsgRule[] = [
  buildAllowRule('AllowHttps', 100, '443')
  buildAllowRule('AllowSsh', 110, '22')
]

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-03-01' = {
  name: 'nsg-udf-demo'
  location: location
  properties: {
    securityRules: [
      for rule in rules: {
        name: rule.name
        properties: {
          priority: rule.priority
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: rule.destinationPortRange
        }
      }
    ]
  }
}

output ruleNames array = [for rule in rules: rule.name]
