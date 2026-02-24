param location string = resourceGroup().location

@description('Bastionを配置するVNetのリソースID（Developer SKUはVNetに直接デプロイ）')
param vnetId string

@description('デプロイ環境（dev以外ではBastion Basicを使う）')
@allowed(['dev', 'stg', 'prod'])
param environment string

// dev環境は無料のDeveloper、それ以外はBasic
var bastionSku = environment == 'dev' ? 'Developer' : 'Basic'

// Developer SKU は Public IP が不要
resource pipBastion 'Microsoft.Network/publicIPAddresses@2024-03-01' = if (environment != 'dev') {
  name: 'pip-bastion'
  location: location
  sku: { name: 'Standard' }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2024-03-01' = {
  name: 'bas-${environment}'
  location: location
  sku: {
    name: bastionSku
  }
  properties: environment == 'dev'
    // Developer SKU: VNetに直接アタッチ、Public IP なし
    ? {
        virtualNetwork: {
          id: vnetId
        }
      }
    // Basic/Standard SKU: AzureBastionSubnet + Public IP が必要
    : {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              subnet: {
                id: '${vnetId}/subnets/AzureBastionSubnet'
              }
              publicIPAddress: { id: pipBastion.id }
            }
          }
        ]
      }
}

output bastionName string = bastion.name
output bastionSku string = bastion.sku.name
