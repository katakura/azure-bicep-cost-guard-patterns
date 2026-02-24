@description('このリソースを管理するチーム・部署名')
param ownerTeam string

@description('リソースの用途・プロジェクト名')
param project string

@description('デプロイ環境')
@allowed(['dev', 'stg', 'prod'])
param environment string

@description('コスト配賦先のコストセンターコード')
param costCenter string

param location string = resourceGroup().location

@description('デプロイ日時（自動付与）')
param deployedAt string = utcNow('yyyy-MM-dd')

var commonTags = {
  Owner: ownerTeam
  Project: project
  Environment: environment
  CostCenter: costCenter
  DeployedAt: deployedAt
  ManagedBy: 'Bicep'
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'st${uniqueString(resourceGroup().id)}'
  location: location
  tags: commonTags
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: 'asp-${project}-${environment}'
  location: location
  tags: union(commonTags, { Component: 'WebApp' })
  sku: {
    name: environment == 'prod' ? 'P1v3' : 'B1'
  }
  properties: {}
}

output storageAccountName string = storageAccount.name
output appServicePlanSku string = appServicePlan.sku.name
output appliedTags object = commonTags
