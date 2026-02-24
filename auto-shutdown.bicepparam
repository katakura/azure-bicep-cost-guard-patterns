using './auto-shutdown.bicep'

param vmId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>'
param location = 'japaneast'
param shutdownTimeUtc = '1300'
param notificationEmail = 'your-email@example.com'
