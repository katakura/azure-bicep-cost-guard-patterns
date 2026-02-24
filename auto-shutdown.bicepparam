using './auto-shutdown.bicep'

param vmId = '/subscriptions/7c90acce-6e10-45cb-9f4d-ffb18d5495ad/resourceGroups/rg-bicep-cost-guard-test/providers/Microsoft.Compute/virtualMachines/vm-dev-001'
param location = 'japaneast'
param shutdownTimeUtc = '1300'
param notificationEmail = 'yoshimasa.katakura@outlook.com'
