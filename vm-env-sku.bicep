@description('デプロイ環境')
@allowed(['dev', 'stg', 'prod'])
param environment string

@description('管理者ユーザー名')
param adminUsername string

@secure()
@description('管理者パスワード')
param adminPassword string

param location string = resourceGroup().location

// 環境ごとに許可するSKUをマッピング
var vmSkuMap = {
  dev:  'Standard_B2s'    // 月 約$30（2vCPU / 4GB）
  stg:  'Standard_D2s_v5' // 月 約$70（2vCPU / 8GB）
  prod: 'Standard_B4ms'   // 月 約$140（4vCPU / 16GB）※検証用（本来はD4s_v5等）
}

var vmSku = vmSkuMap[environment]

resource vnet 'Microsoft.Network/virtualNetworks@2024-03-01' = {
  name: 'vnet-${environment}'
  location: location
  properties: {
    addressSpace: { addressPrefixes: ['10.0.0.0/16'] }
    subnets: [
      {
        name: 'snet-vms'
        properties: { addressPrefix: '10.0.0.0/24' }
      }
    ]
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2024-03-01' = {
  name: 'nic-${environment}-001'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: { id: vnet.properties.subnets[0].id }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: 'vm-${environment}-001'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSku
    }
    osProfile: {
      computerName: 'vm-${environment}-001'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: environment == 'prod' ? 'Premium_LRS' : 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [{ id: nic.id }]
    }
  }
}

output vmSize string = vm.properties.hardwareProfile.vmSize
output diskType string = vm.properties.storageProfile.osDisk.managedDisk.storageAccountType
