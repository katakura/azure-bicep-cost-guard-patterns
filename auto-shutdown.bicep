@description('対象VMのリソースID')
param vmId string

@description('対象VMと同じリソースグループの場所')
param location string

@description('シャットダウン時刻（UTCで指定）。JST 22:00 = UTC 13:00')
param shutdownTimeUtc string = '1300'

@description('通知先メールアドレス（空文字で通知なし）')
param notificationEmail string = ''

var notificationSettings = empty(notificationEmail)
  ? { status: 'Disabled' }
  : {
      status: 'Enabled'
      timeInMinutes: 30
      emailRecipient: notificationEmail
    }

resource autoShutdown 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: 'shutdown-computevm-${last(split(vmId, '/'))}'
  location: location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: shutdownTimeUtc
    }
    timeZoneId: 'UTC'
    targetResourceId: vmId
    notificationSettings: notificationSettings
  }
}

output scheduleName string = autoShutdown.name
output shutdownTime string = autoShutdown.properties.dailyRecurrence.time
