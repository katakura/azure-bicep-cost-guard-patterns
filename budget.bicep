targetScope = 'resourceGroup'

@description('月予算の上限額（USD）')
param budgetAmountUsd int = 10

@description('アラートを送る先のメールアドレス')
param alertEmailAddress string

@description('予算期間の開始日（YYYY-MM-DD）')
param startDate string = '2026-01-01'

resource budget 'Microsoft.Consumption/budgets@2024-08-01' = {
  name: 'budget-${resourceGroup().name}'
  properties: {
    category: 'Cost'
    amount: budgetAmountUsd
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: startDate
    }
    notifications: {
      actual_80: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 80
        contactEmails: [alertEmailAddress]
        thresholdType: 'Actual'
      }
      actual_100: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 100
        contactEmails: [alertEmailAddress]
        thresholdType: 'Actual'
      }
      forecast_120: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 120
        contactEmails: [alertEmailAddress]
        thresholdType: 'Forecasted'
      }
    }
  }
}

output budgetName string = budget.name
